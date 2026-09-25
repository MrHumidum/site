<?php


namespace YooMoneyModule\Model;

use Config;
use Exception;
use Log;
use Session;
use YooKassa\Client;
use YooKassa\Common\Exceptions\ApiException;
use YooKassa\Common\Exceptions\BadApiRequestException;
use YooKassa\Common\Exceptions\ExtensionNotFoundException;
use YooKassa\Common\Exceptions\ForbiddenException;
use YooKassa\Common\Exceptions\InternalServerError;
use YooKassa\Common\Exceptions\NotFoundException;
use YooKassa\Common\Exceptions\ResponseProcessingException;
use YooKassa\Common\Exceptions\TooManyRequestsException;
use YooKassa\Common\Exceptions\UnauthorizedException;
use YooKassa\Model\PaymentInterface;
use YooKassa\Model\PaymentStatus;
use YooKassa\Model\Receipt\PaymentMode;
use YooKassa\Model\ReceiptCustomer;
use YooKassa\Model\ReceiptItem;
use YooKassa\Model\ReceiptType;
use YooKassa\Model\Settlement;
use YooKassa\Request\Receipts\CreatePostReceiptRequest;
use YooKassa\Request\Receipts\PaymentReceiptResponse;
use YooKassa\Request\Receipts\ReceiptResponseInterface;
use YooKassa\Request\Receipts\ReceiptResponseItem;
use YooKassa\Request\Receipts\ReceiptResponseItemInterface;

class KassaSecondReceiptModel
{
    const MODULE_VERSION = '2.8.2';

    /**
     * @var Config
     */
    private $config;

    /**
     * @var Session
     */
    private $session;

    /**
     * @var int|string
     */
    private $orderId;

    /**
     * @var array
     */
    private $orderInfo;

    /**
     * @var PaymentInterface
     */
    private $paymentInfo;

    /**
     * @var KassaModel
     */
    private $kassaModel;

    /**
     * @var KassaLogger
     */
    private $kassaLogger;

    /**
     * @var string
     */
    private $settlementsSum;


    /**
     * @var Client
     */
    protected $client;

    /**
     * KassaSecondReceiptModel constructor.
     * @param $config
     * @param $session
     * @param $orderId
     * @param $paymentInfo
     * @param $orderInfo
     */
    public function __construct($config, $session, $orderId, $paymentInfo, $orderInfo)
    {
        $this->config      = $config;
        $this->session     = $session;
        $this->orderId     = $orderId;
        $this->orderInfo   = $orderInfo;
        $this->paymentInfo = $paymentInfo;
        $this->kassaModel  = new KassaModel($config);
        $this->kassaLogger = new KassaLogger($config->get('yoomoney_kassa_shop_id'));
    }

    /**
     * @return Client
     * @throws Exception
     */
    protected function getClient()
    {
        if ($this->client === null) {
            $client = new ApiClient($this);
            $client->setKassaModel($this->kassaModel);
            $this->client = $client->getClient();
        }

        return $this->client;
    }

    /**
     * Устанавливает креды авторизации клиента кассы,
     * приоритет - OAuth токен
     *
     * @return void
     */
    private function setClientAuth()
    {
        $token = $this->kassaModel->getOauthToken();
        if (!empty($token)) {
            $this->client->setAuthToken($token);
            return;
        }

        $this->client->setAuth(
            $this->kassaModel->getShopId(),
            $this->kassaModel->getPassword()
        );
    }

    /**
     * @param $statusId
     * @return bool
     */
    public function sendSecondReceipt($statusId)
    {
        $this->kassaLogger->sendHeka(array('second-receipt.webhook.init'));
        $this->log("info", "Hook send second receipt");

        if (!$this->isNeedSecondReceipt($statusId)) {
            $this->log("info", "Второй чек не требуется");
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.skip'));
            return false;
        } elseif (!$this->isPaymentInfoValid($this->paymentInfo)) {
            $this->log("error", "Invalid paymentInfo");
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.skip'));
            return false;
        } elseif (empty($this->orderInfo)) {
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.skip'));
            $this->log("error", "Invalid orderInfo orderId = " . $this->orderId);
            return false;
        }

        try {
            $lastReceipt = $this->getLastReceipt($this->paymentInfo->getid());
        } catch (Exception $e) {
            $this->log("error", "Get last receipt error: " . $e->getMessage());
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.fail'));
            return false;
        }

        if (empty($lastReceipt)) {
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.fail'));
            return false;
        }

        $receiptRequest = $this->buildSecondReceipt($lastReceipt, $this->paymentInfo, $this->orderInfo);

        if (!empty($receiptRequest)) {

            $this->log("info", "Second receipt request data: " . json_encode($receiptRequest->jsonSerialize()));

            try {
                $this->kassaLogger->sendHeka(array('second-receipt.send.init'));
                $response = $this->getClient()->createReceipt($receiptRequest);
                $this->kassaLogger->sendHeka(array('second-receipt.send.success'));
            } catch (Exception $e) {
                $this->log("error", "Request second receipt error: " . $e->getMessage());
                $this->kassaLogger->sendHeka(array('second-receipt.send.fail'));
                return false;
            }

            $this->log("info", "Request second receipt result: " . json_encode($response->jsonSerialize()));
            $this->generateSettlementsAmountSum($response);
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.success'));
            return true;
        } else {
            $this->kassaLogger->sendHeka(array('second-receipt.webhook.fail'));
            return false;
        }
    }

    /**
     * @return string
     */
    public function getSettlementsSum()
    {
        return $this->settlementsSum;
    }

    /**
     * @param ReceiptResponseInterface $response
     * @return string
     */
    private function generateSettlementsAmountSum($response)
    {
        $amount = 0;

        foreach ($response->getSettlements() as $settlement) {
            $amount += $settlement->getAmount()->getIntegerValue();
        }

        $this->settlementsSum = number_format($amount / 100.0, 2, '.', ' ');
    }

    /**
     * @param ReceiptResponseInterface $lastReceipt
     * @param PaymentInterface $paymentInfo
     * @param $orderInfo
     *
     * @return void|CreatePostReceiptRequest
     */
    private function buildSecondReceipt($lastReceipt, $paymentInfo, $orderInfo)
    {
        $this->kassaLogger->sendHeka(array('second-receipt.create.init'));
        if ($lastReceipt instanceof ReceiptResponseInterface) {
            if ($lastReceipt->getType() === "refund") {
                $this->kassaLogger->sendHeka(array('second-receipt.create.skip'));
                return;
            }

            $resendItems = $this->getResendItems($lastReceipt->getItems());

            if (count($resendItems['items']) < 1) {
                $this->kassaLogger->sendHeka(array('second-receipt.create.skip'));
                $this->log("info", "Second receipt isn't need");
                return;
            }

            try {
                $receiptBuilder = CreatePostReceiptRequest::builder();
                $customer = $this->getReceiptCustomer($orderInfo);

                if (empty($customer)) {
                    $this->kassaLogger->sendHeka(array('second-receipt.create.fail'));
                    $this->log("error", "Need customer phone or email for second receipt");
                    return;
                }

                $receiptBuilder->setObjectId($paymentInfo->getId())
                    ->setType(ReceiptType::PAYMENT)
                    ->setItems($resendItems['items'])
                    ->setSettlements(
                        array(
                            new Settlement(
                                array(
                                    'type' => 'prepayment',
                                    'amount' => array(
                                        'value' => $resendItems['amount'],
                                        'currency' => 'RUB',
                                    ),
                                )
                            ),
                        )
                    )
                    ->setCustomer($customer)
                    ->setSend(true);

                if ($lastReceipt->getTaxSystemCode()) {
                    $receiptBuilder->setTaxSystemCode($lastReceipt->getTaxSystemCode());
                } else if ($defaultTaxSystemCode = $this->config->get('yoomoney_kassa_tax_system_default')) {
                    $receiptBuilder->setTaxSystemCode($defaultTaxSystemCode);
                }

                $result = $receiptBuilder->build();
                $this->log('info', 'Second Receipt build', $result->toArray());
                $this->kassaLogger->sendHeka(array('second-receipt.create.success'));
                return $result;
            } catch (Exception $e) {
                $this->kassaLogger->sendHeka(array('second-receipt.create.fail'));
                $this->log("error", $e->getMessage() . ". Property name:". $e->getProperty());
            }
        } else {
            $this->kassaLogger->sendHeka(array('second-receipt.create.skip'));
            $this->log("info", "Второй чек не требуется");
        }
    }

    /**
     * @param PaymentInterface $paymentInfo
     * @return bool
     */
    private function isPaymentInfoValid($paymentInfo)
    {
        if (empty($paymentInfo)) {
            $this->log("error", "Fail send second receipt paymentInfo is null: " . print_r($paymentInfo, true));
            return false;
        }

        if ($paymentInfo->getStatus() !== PaymentStatus::SUCCEEDED) {
            $this->log("error", "Fail send second receipt payment have incorrect status: " . $paymentInfo->getStatus());
            return false;
        }

        return true;
    }

    /**
     * @param $orderInfo
     * @return ReceiptCustomer
     */
    private function getReceiptCustomer($orderInfo)
    {
        $customerData = array();

        if (isset($orderInfo['email']) && !empty($orderInfo['email'])) {
            $customerData['email'] = $orderInfo['email'];
        }

        if (isset($orderInfo['telephone']) && !empty($orderInfo['telephone'])) {
            $customerData['phone'] = preg_replace('/\D/', '', $orderInfo['telephone']);
        }


        return new ReceiptCustomer($customerData);
    }

    /**
     * @param $statusId
     * @return bool
     */
    private function isNeedSecondReceipt($statusId)
    {
        if (!$this->kassaModel->isSendReceipt()) {
            return false;
        } elseif (!$this->kassaModel->isSecondReceipt()) {
            return false;
        } elseif ($statusId != $this->kassaModel->getSecondReceiptStatus()) {
            return false;
        }

        return true;
    }

    /**
     * @param string $paymentId
     * @return mixed|ReceiptResponseInterface
     * @throws ApiException
     * @throws BadApiRequestException
     * @throws ExtensionNotFoundException
     * @throws ForbiddenException
     * @throws InternalServerError
     * @throws NotFoundException
     * @throws ResponseProcessingException
     * @throws TooManyRequestsException
     * @throws UnauthorizedException
     * @throws Exception
     */
    private function getLastReceipt($paymentId)
    {
        $paymentReceipts = $this->getClient()->getReceipts(array('payment_id' => $paymentId))->getItems();
        $lastPaymentReceipt = array_shift($paymentReceipts);

        if ($lastPaymentReceipt) {
            $refundReceipts = $this->getRefundReceipts($paymentId);
            if (count($refundReceipts)) {
                return $this->createNewPaymentReceipt($lastPaymentReceipt, $refundReceipts);
            } else {
                return $lastPaymentReceipt;
            }
        }

        return null;
    }

    /**
     * @param string $paymentId
     * @return ReceiptResponseInterface[]
     * @throws ApiException
     * @throws BadApiRequestException
     * @throws ExtensionNotFoundException
     * @throws ForbiddenException
     * @throws InternalServerError
     * @throws NotFoundException
     * @throws ResponseProcessingException
     * @throws TooManyRequestsException
     * @throws UnauthorizedException
     */
    private function getRefundReceipts($paymentId)
    {
        $refundReceipts = array();
        $refunds = $this->getClient()->getRefunds(array('payment_id' => $paymentId))->getItems();
        foreach ($refunds as $refund) {
            $refundReceipts = array_merge(
                $refundReceipts,
                $this->getClient()->getReceipts(array('refund_id' => $refund->getId()))->getItems()
            );
        }
        return $refundReceipts;
    }

    /**
     * @param ReceiptResponseInterface $lastPaymentReceipt
     * @param ReceiptResponseInterface[] $refundReceipts
     * @return PaymentReceiptResponse
     * @throws Exception
     */
    private function createNewPaymentReceipt($lastPaymentReceipt, $refundReceipts)
    {
        $newReceiptItems = array();
        foreach ($lastPaymentReceipt->getItems() as $paymentReceiptItem) {
            $newReceiptItem = new ReceiptResponseItem($paymentReceiptItem->jsonSerialize());
            $newQuantity = $newReceiptItem->getQuantity();
            foreach ($refundReceipts as $refundReceipt) {
                foreach ($refundReceipt->getItems() as $refundReceiptItem) {
                    if ($paymentReceiptItem->getDescription() == $refundReceiptItem->getDescription() &&
                        $paymentReceiptItem->getPrice()->getValue() == $refundReceiptItem->getPrice()->getValue()) {
                        $newQuantity -= $refundReceiptItem->getQuantity();
                    }
                }
            }
            if ($newQuantity > 0) {
                $newReceiptItem->setQuantity($newQuantity);
                $newReceiptItems[] = $newReceiptItem->jsonSerialize();
            }
        }
        /** @var PaymentReceiptResponse $lastPaymentReceipt */
        return new PaymentReceiptResponse(array(
            'id' => $lastPaymentReceipt->getId(),
            'payment_id' => $lastPaymentReceipt->getPaymentId(),
            'type' => $lastPaymentReceipt->getType(),
            'status' => $lastPaymentReceipt->getStatus(),
            'items' => $newReceiptItems,
        ));
    }

    /**
     * @param ReceiptResponseItemInterface[] $items
     *
     * @return array
     */
    private function getResendItems($items)
    {
        $resendItems = array(
            'items'  => array(),
            'amount' => 0,
        );

        foreach ($items as $item) {
            if ($item->getPaymentMode() === PaymentMode::FULL_PREPAYMENT) {
                $item->setPaymentMode(PaymentMode::FULL_PAYMENT);
                $resendItems['items'][] = new ReceiptItem($item->jsonSerialize());
                $resendItems['amount'] += $item->getAmount() / 100.0;
            }
        }

        return $resendItems;
    }

    /**
     * @param string $level
     * @param string $message
     * @param array $context
     */
    public function log($level, $message, $context = array())
    {
        if ($this->kassaModel->getDebugLog()) {
            $log     = new Log('yoomoney.log');
            $search  = array();
            $replace = array();
            if (!empty($context)) {
                foreach ($context as $key => $value) {
                    $search[]  = '{'.$key.'}';
                    $replace[] = (is_array($value)||is_object($value)) ? json_encode($value, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE) : $value;
                }
            }
            $sessionId = $this->session->getId();
            $userId    = 0;
            if (isset($this->session->data['user_id'])) {
                $userId = $this->session->data['user_id'];
            }
            $message = strip_tags($message);
            if (empty($search)) {
                $log->write('['.$level.'] ['.$userId.'] ['.$sessionId.'] - '.$message);
            } else {
                foreach ($search as $object) {
                    if (stripos($message, $object) === false) {
                        $label = trim($object, "{}");
                        $message .= " \n{$label}: {$object}";
                    }
                }
                $log->write(
                    '['.$level.'] ['.$userId.'] ['.$sessionId.'] - '
                    .str_replace($search, $replace, $message)
                );
            }
        }
    }
}
