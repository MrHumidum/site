<?php

use YooKassa\Common\Exceptions\ApiException;
use YooKassa\Model\ConfirmationType;
use YooKassa\Model\Notification\AbstractNotification;
use YooKassa\Model\Notification\NotificationFactory;
use YooKassa\Model\Notification\NotificationRefundSucceeded;
use YooKassa\Model\Notification\NotificationSucceeded;
use YooKassa\Model\Notification\NotificationWaitingForCapture;
use YooKassa\Model\NotificationEventType;
use YooKassa\Model\PaymentMethodType;
use YooKassa\Model\PaymentStatus;
use YooKassa\Model\CancellationDetailsReasonCode;
use YooKassa\Model\CancellationDetailsPartyCode;
use YooMoneyModule\Model\KassaModel;

/**
 * Класс контроллера модуля оплаты с помощью ЮMoney
 *
 * @property ModelPaymentYoomoney $model_payment_yoomoney
 * @property ModelCheckoutOrder $model_checkout_order
 * @property ModelAccountOrder $model_account_order
 * @property ModelAccountCustomer $model_account_customer
 * @property \Cart\Cart $cart
 * @property \Cart\Customer $customer
 */
class ControllerExtensionPaymentYoomoney extends Controller
{
    /** @var string */
    const MODULE_NAME = 'yoomoney';
    const MODULE_VERSION = '2.8.2';

    /**
     * @var ModelExtensionPaymentYoomoneyb2
     */
    private $_model;

    /**
     * @var
     */
    private $_prefix;

    /**
     * @return string
     */
    public function getPrefix()
    {
        if ($this->_prefix === null) {
            $this->_prefix = '';
            if (version_compare(VERSION, '2.3.0') >= 0) {
                $this->_prefix = 'extension/';
            }
        }

        return $this->_prefix;
    }

    /**
     * @param $template
     *
     * @return string
     */
    public function getTemplatePath($template)
    {
        if ($this->getPrefix() !== '') {
            return $this->getPrefix().$template;
        } elseif (version_compare(VERSION, '2.2.0') >= 0) {
            return $template;
        }

        return 'default/template/'.$template.'.tpl';
    }

    /**
     * Экшен генерирующий страницу оплаты с помощью ЮMoney
     * @return string
     */
    public function index()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        $this->document->setTitle($this->language->get('heading_title'));

        if (isset($this->session->data['confirmation_token'])) {
            $this->session->data['confirmation_token'] = null;
        }
        $model = $this->getModel()->getPaymentModel();
        if ($model === null) {
            $this->failure('YooKassa module disabled');
        }

        if ($model->getMinPaymentAmount() > 0 && $model->getMinPaymentAmount() > $this->cart->getSubTotal()) {
            $this->failure(sprintf($this->language->get('error_minimum'),
                $this->currency->format($model->getMinPaymentAmount(), $this->session->data['currency'])));
        }

        $this->load->model('checkout/order');
        $orderInfo = $this->model_checkout_order->getOrder($this->session->data['order_id']);

        $data['language'] = $this->language;
        $shopId           = $this->config->get('yoomoney_kassa_shop_id');
        $data['orderInfo'] = $orderInfo;
        if ($this->currency->has('RUB')) {
            $amount = sprintf('%.2f', $this->currency->format($orderInfo['total'], 'RUB', '', false));
        } else {
            $amount = sprintf('%.2f', $this->getModel()->convertFromCbrf($orderInfo, 'RUB'));
        }
        $data['shopId'] = $shopId;
        $data['sum']    = $amount;

        $data['fullView'] = false;

        $data['column_left']    = $this->load->controller('common/column_left');
        $data['column_right']   = $this->load->controller('common/column_right');
        $data['content_top']    = $this->load->controller('common/content_top');
        $data['content_bottom'] = $this->load->controller('common/content_bottom');
        $data['footer']         = $this->load->controller('common/footer');
        $data['header']         = $this->load->controller('common/header');

        $template  = $model->applyTemplateVariables($this, $data, $orderInfo);
        $this->getModel()->log('info', $this->getTemplatePath($template));

        return $this->load->view($this->getTemplatePath($template), $data);
    }

    /**
     * @param $orderInfo
     * @param bool $fullView
     *
     * @return mixed
     */
    private function payment($orderInfo, $fullView = false)
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        $this->document->setTitle($this->language->get('heading_title'));

        $model = $this->getModel()->getPaymentModel();
        if (!$model || !$model->isEnabled()) {
            $this->failure('YooKassa module disabled');
        }

        if ($model->getMinPaymentAmount() > 0 && $model->getMinPaymentAmount() > $orderInfo['total']) {
            $this->failure(
                sprintf(
                    $this->language->get('error_minimum'),
                    $this->currency->format($model->getMinPaymentAmount(), $orderInfo['currency_id'])
                )
            );
        }

        $template = $model->applyTemplateVariables($this, $data, $orderInfo);

        $data['language'] = $this->language;
        $data['fullView'] = $fullView;

        if ($fullView) {
            $data['column_left']    = $this->load->controller('common/column_left');
            $data['column_right']   = $this->load->controller('common/column_right');
            $data['content_top']    = $this->load->controller('common/content_top');
            $data['content_bottom'] = $this->load->controller('common/content_bottom');
            $data['footer']         = $this->load->controller('common/footer');
            $data['header']         = $this->load->controller('common/header');
        }

        return $this->load->view($this->getTemplatePath($template), $data);
    }

    public function simplePayment()
    {
        $kassa = $this->getModel()->getKassaModel();
        if (!$kassa->isEnabled()) {
            $this->failure('YooKassa module disabled');
        }
        if (!isset($this->request->get['order_id'])) {
            $this->failure('Order id not send');
        }
        $orderId = (int)$this->request->get['order_id'];
        if ($orderId <= 0) {
            $this->failure('Invalid order id');
        }
        if (!$this->customer->isLogged()) {
            $this->session->data['redirect'] = $this->url->link(
                $this->getPrefix().'payment/yoomoney/repay', 'order_id='.$orderId, 'SSL'
            );
            $this->response->redirect($this->url->link('account/login', '', true));
        }

        $this->load->model('account/order');
        $order = $this->model_account_order->getOrder($orderId);
        if (empty($order)) {
            $this->response->redirect(
                $this->url->link('account/order/info', 'order_id='.$orderId, true)
            );
        }

        $query = $this->db->query("SELECT `payment_code`, `order_status_id` FROM `".DB_PREFIX."order` WHERE order_id = '".$orderId."'");
        if (empty($query)) {
            $this->response->redirect(
                $this->url->link('account/order/info', 'order_id='.$orderId, true)
            );
        }
        if ($query->row['payment_code'] !== 'yoomoney') {
            $this->session->data['error'] = $this->language->get('text_invalid_payment_method');
            $this->response->redirect(
                $this->url->link('account/order/info', 'order_id='.$orderId, true)
            );
        }
        if ($query->row['order_status_id'] == $kassa->getSuccessOrderStatusId()) {
            $this->session->data['error'] = 'Заказ уже оплачен';
            $this->response->redirect(
                $this->url->link('account/order/info', 'order_id='.$orderId, true)
            );
        }

        $this->getModel()->log('info', $this->language->get('log_text_create_payment').$orderId);

        $payment = $this->getModel()->createOrderPayment($order, false);
        if ($payment === null) {
            $this->failure($this->language->get('log_text_payment_create_failed'));
        } elseif ($payment->getStatus() === PaymentStatus::CANCELED) {
            $this->failure($this->language->get('log_text_payment_create_failed'));
        }
        $confirmation = $payment->getConfirmation();
        if ($confirmation !== null && $confirmation->getType() === ConfirmationType::REDIRECT) {
            $this->getModel()->getKassaLog()->sendHeka(array('payment.redirect.init'));
            $this->response->redirect($confirmation->getConfirmationUrl());
        }
        $this->session->data['error'] = $this->language->get('log_text_payment_init_failed');
        $this->response->redirect(
            $this->url->link('account/order/info', 'order_id='.$orderId, true)
        );
    }

    /**
     * @param $error
     * @param bool $display
     */
    public function failure($error, $display = true)
    {
        if ($display) {
            $this->session->data['error'] = $error;
        }
        $this->getModel()->log('info', $error);
        $this->response->redirect($this->url->link('checkout/checkout', '', true));
    }

    /**
     * @param $message
     */
    public function jsonError($message)
    {
        if (ob_get_level() != 0) {
            $output = ob_get_clean();
            $this->getModel()->log('warning', 'None empty buffer: '.$output);
        }
        $this->getModel()->log('error', $message);
        echo json_encode(array(
            'success' => false,
            'error'   => $message,
        ));
        exit();
    }

    /**
     * Экшен проведения платежа, вызываемый после подтверждения заказа пользователем
     */
    public function create()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        ob_start();
        $kassa = $this->getModel()->getKassaModel();
        if (!$kassa->isEnabled()) {
            $this->jsonError('YooKassa module disabled');
        }
        if (!isset($this->session->data['order_id'])) {
            $this->jsonError('Cart is empty');
        }
        $orderId = $this->session->data['order_id'];
        $this->getModel()->log('info', $this->language->get('log_text_create_payment').$orderId);
        if (!isset($this->request->get['paymentType'])) {
            $this->jsonError('Payment method not specified');
        }
        $paymentMethod = $this->request->get['paymentType'];
        $successUrl = $this->url->link('checkout/success', '', true);

        if (!$kassa->getEPL()) {
            $this->jsonError('Invalid payment method');
        }

        $payment = $this->getModel()->createPayment($orderId, $paymentMethod);
        if ($payment === null) {
            $this->jsonError($this->language->get('log_text_payment_create_failed'));
        } elseif ($payment->getStatus() === PaymentStatus::CANCELED) {
            $this->jsonError($this->language->get('log_text_payment_create_failed'));
        }
        $result       = array(
            'success'  => true,
            'redirect' => $successUrl,
        );
        $confirmation = $payment->getConfirmation();

        if ($confirmation !== null) {
            if ($confirmation->getType() === ConfirmationType::REDIRECT) {
                $result['redirect'] = $confirmation->getConfirmationUrl();
                $this->getModel()->getKassaLog()->sendHeka(array('payment.redirect.init'));
            }
        }

        if ($kassa->getCreateOrderBeforeRedirect()) {
            $this->getModel()->log('info', 'Confirm order #'.$orderId.' after payment creation');
            $this->getModel()->addPaymentLinkToOrderHistory($orderId);
        }
        if ($kassa->getClearCartBeforeRedirect()) {
            $this->getModel()->log('info', 'Clear order#'.$orderId.' cart after payment creation');
            $this->cart->clear();
        }

        $output = ob_get_clean();
        if (!empty($output)) {
            $this->getModel()->log('warning', 'Non empty buffer: '.$output);
        }

        echo json_encode($result);
        exit();
    }

    /**
     * Экшен вызываемый при возврате пользователя из кассы, проверяет статус платежа, добавляет в историю заказа
     * событие о создании платежа
     */
    public function confirm()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        if (empty($_GET['order_id'])) {
            $this->failure($this->language->get('text_error_payment_id'));
        }
        $this->getModel()->log('info', $this->language->get('log_text_payment_capture').$_GET['order_id']);
        $kassa = $this->getModel()->getKassaModel();

        if (!$kassa->isEnabled()) {
            $this->failure($this->language->get('text_module_disabled'));
        }

        $orderId   = (int)$_GET['order_id'];
        $paymentId = $this->getModel()->findPaymentIdByOrderId($orderId);

        if (empty($paymentId)) {
            $this->failure($this->language->get('text_get_payment_id_failed').$orderId);
        }

        $this->load->model('checkout/order');
        $payment = $this->getModel()->fetchPaymentInfo($paymentId);

        if ($payment === null) {
            $this->failure(sprintf($this->language->get('log_text_order_not_found'), $paymentId, $orderId));
        } elseif (!$payment->getPaid()) {
            $this->failure($this->language->get('log_text_error_payment_capture'));
        } elseif ($payment->getStatus() === PaymentStatus::CANCELED) {
            $this->failure(sprintf($this->language->get('log_text_status_canceled'), $paymentId, $orderId));
        }

        $this->response->redirect($this->url->link('checkout/success', '', true));
    }

    public function validate()
    {
        $this->jsonError('Unknown payment type');
        exit();
    }

    /**
     * Экшен обработки нотификации для проведения capture платежа
     */
    public function capture()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        if (!$this->getModel()->getKassaModel()->isEnabled()) {
            header('HTTP/1.1 403 Module disabled');
            exit();
        }
        $source = file_get_contents('php://input');
        if (empty($source)) {
            header('HTTP/1.1 400 Empty request body');
            exit();
        }

        $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.init'));

        $json = json_decode($source, true);
        if (empty($json)) {
            if (json_last_error() === JSON_ERROR_NONE) {
                $message = 'empty object in body';
            } else {
                $message = 'invalid object in body: '.$source;
            }
            $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.fail'));
            $this->getModel()->log('warning', 'Invalid parameters in capture notification controller - '.$message);
            header('HTTP/1.1 400 Invalid json object in body');
            exit();
        }

        $this->getModel()->log('info', 'Notification: '.$source);

        try {
            $factory = new NotificationFactory();
            $notification = $factory->factory($json);
        } catch (\Exception $e) {
            $this->getModel()->log('error', 'Invalid notification object - '.$e->getMessage());
            $this->getModel()->getKassaLog()->sendAlertLog('Invalid notification object', array(
                'methodid' => 'POST/capture',
                'exception' => $e,
            ), array('payment.notification.fail'));
            header('HTTP/1.1 400 Invalid object in body');
            exit();
        }

        $metadata = $notification->getObject()->getMetadata();

        if (
            isset($metadata['cms_name'])
            && !in_array($metadata['cms_name'], array(
                ModelExtensionPaymentYoomoney::CMS_NAME,
                ModelExtensionPaymentYoomoney::CMS_NAME_OLD,
                ModelExtensionPaymentYoomoney::CMS_NAME_INVOICE
            ))
        ) {
            $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.skip'));
            $this->getModel()->log('info', 'This notification not for opencart2. This notification for: ' . $metadata['cms_name']);
            header('HTTP/1.1 400 Invalid object in body');
            exit();
        }

        $paymentId = $notification instanceof NotificationRefundSucceeded
                   ? $notification->getObject()->getPaymentId()
                   : $notification->getObject()->getId();

        $orderId = $this->getModel()->findOrderIdByPayment($paymentId);
        $this->getModel()->log('info',
            sprintf($this->language->get('text_capture_init'), $notification->getObject()->getId(), $orderId));
        if ($orderId <= 0) {
            $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.skip'));
            $this->getModel()->log('error', 'Order not exists for payment ' . $paymentId);
            exit();
        }

        if ($notification->getEvent() === NotificationEventType::REFUND_SUCCEEDED) {
            $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.skip'));
            $this->getModel()->log('info', 'Refund success for order #'.$orderId);
            exit();
        }

        $shopId = $this->config->get('yoomoney_kassa_shop_id') ?: 'null';

        if ($notification->getEvent() === NotificationEventType::PAYMENT_CANCELED) {
            $this->getModel()->log('info', 'Payment for order #'.$orderId.' cancelled');
            $notifyPaymentMethod = $notification->getObject()->getPaymentMethod();
            $canceledStatusId = $this->getModel()->getKassaModel()->getOrderCanceledStatus();
            $cancellationDetails = $notification->getObject()->getCancellationDetails();
            $changeStatus = false;
            if (
                $cancellationDetails
                && $cancellationDetails->getParty() === CancellationDetailsPartyCode::MERCHANT
                && $cancellationDetails->getReason() === CancellationDetailsReasonCode::CANCELED_BY_MERCHANT
            ) {
                $changeStatus = true;
            }

            if (
                $notifyPaymentMethod
                && $notifyPaymentMethod->getType() === PaymentMethodType::SBER_LOAN
                && $notifyPaymentMethod->getDiscountAmount()
            ) {
                $this->load->model('checkout/order');
                $orderInfo = $this->model_checkout_order->getOrder($orderId);
                $statusId = $changeStatus ? $canceledStatusId : $orderInfo['order_status_id'];
                try {
                    $this->handleSberLoan($notification, $orderInfo, $statusId);
                    if (!$changeStatus) {
                        // Возвращаем исходный статус заказу, т.к. он изменяется на 0 при вызове editOrder()
                        $this->getModel()->updateOrderStatus($orderId, array('order_status_id' => $statusId));
                    }
                } catch (Exception $e) {
                    $this->getModel()->log(
                        'error',
                        'Sber loan. Discount apply error',
                        array('exception' => $e)
                    );
                    $this->getModel()->getKassaLog()->sendAlertLog('Sber loan. Discount apply error', array(
                        'methodid' => 'POST/capture',
                        'exception' => $e,
                    ));
                }
            }

            if ($changeStatus) {
                $this->getModel()->updateOrderStatus(
                    $orderId,
                    array('order_status_id' => $canceledStatusId),
                    $this->language->get('cancel_payment_success_message')
                );
                //добавляем ссылку на повторную оплату в истории
                $this->getModel()->addPaymentLinkToOrderHistory($orderId, $canceledStatusId);
            }

            $this->getModel()->updatePaymentInDatabase($notification->getObject());
            $this->getModel()->getKassaLog()->sendHeka(array(
                'shop.'.$shopId.'.payment.canceled',
                'payment.notification.success'
            ));
            exit();
        }

        $this->load->model('checkout/order');
        $orderInfo = $this->model_checkout_order->getOrder($orderId);
        if (empty($orderInfo)) {
            $this->getModel()->log('warning', 'Empty order #'.$orderId.' in notification');
            $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.skip'));
            exit();
        }

        $result = null;
        if ($notification instanceof NotificationWaitingForCapture) {
            $payment = $this->getModel()->updatePaymentInfo($notification->getObject()->getId());
            if ($payment === null) {
                $this->getModel()->log('error', 'Payment not captured: capture result is null');
            } elseif ($payment->getStatus() !== PaymentStatus::WAITING_FOR_CAPTURE) {
                $this->getModel()->log('error',
                    'Payment not captured: invalid payment status "'.$payment->getStatus().'"');
            } else {
                $kassa = $this->getModel()->getKassaModel();
                $this->getModel()->getKassaLog()->sendHeka(array('order-status.change.init'));
                $this->model_checkout_order->addOrderHistory(
                    $orderId,
                    $kassa->getHoldOrderStatusId(),
                    $this->language->get('text_payment_on_hold')
                );
                $this->getModel()->getKassaLog()->sendHeka(array('order-status.change.success'));
                $this->getModel()->disablePaymentLink($orderId);
            }
            $this->getModel()->getKassaLog()->sendHeka(array('shop.'.$shopId.'.payment.waiting_for_capture'));
        } elseif ($notification instanceof NotificationSucceeded) {
            $result = $this->getModel()->fetchPaymentInfo($notification->getObject()->getId());
            if ($result === null) {
                $this->getModel()->log('error', 'Payment not captured: capture result is null');
            } elseif ($result->getStatus() !== PaymentStatus::SUCCEEDED) {
                $this->getModel()->log(
                    'error',
                    'Payment not captured: invalid payment status "'.$result->getStatus().'"'
                );
            } else {
                $successOrderStatusId = $this->getModel()->getKassaModel()->getSuccessOrderStatusId();

                $paymentMethod = $notification->getObject()->getPaymentMethod();
                if ($paymentMethod->getType() === PaymentMethodType::SBER_LOAN && $paymentMethod->getDiscountAmount()) {
                    try {
                        $this->handleSberLoan($notification, $orderInfo, $successOrderStatusId);
                    } catch (Exception $e) {
                        $message = 'Sber loan. Error applying discount';
                        $this->getModel()->log(
                            'error',
                            $message,
                            array('exception' => $e->getMessage())
                        );
                        $this->getModel()->getKassaLog()->sendAlertLog($message, array(
                            'methodid' => 'POST/capture',
                            'exception' => $e,
                        ), array('payment.notification.fail'));
                        exit();
                    }
                }
                $this->getModel()->confirmOrderPayment($orderId, $result, $successOrderStatusId);

                $stat = $this->getModel()->getSuccessPaymentStat();
                if (!empty($stat)) {
                    $host = str_replace(array('http://', 'https://', '.', '/', ':'), array('', '', '-', '-', '-'), trim(HTTPS_SERVER, '/'));
                    $this->getModel()->getKassaLog()->sendHeka(array(
                        'shop.' . $shopId . '.payment.succeeded',
                        'shop.' . $shopId . '.host.' . $host . '.payment-count' => array(
                            'metric_type' => 'gauges',
                            'metric_count' => $stat['count']
                        ),
                        'shop.' . $shopId . '.host.' . $host . '.payment-total' => array(
                            'metric_type' => 'gauges',
                            'metric_count' => $stat['total']
                        ),
                    ));
                }
            }
        }
        $this->getModel()->getKassaLog()->sendHeka(array('payment.notification.success'));
        echo json_encode(array('success' => $result));
        exit();
    }

    /**
     * @param AbstractNotification $notification
     * @param array $orderInfo
     * @param int $statusId
     * @return void
     * @throws Exception
     */
    private function handleSberLoan($notification, $orderInfo, $statusId)
    {
        $notifyPaymentMethod = $notification->getObject()->getPaymentMethod();
        $paymentId = $notification->getObject()->getId();

        $discountAmount = $notifyPaymentMethod->getDiscountAmount()->value;
        $this->getModel()->log(
            'info',
            'Sber loan. Discount amount: ' . $discountAmount
        );
        $this->addDiscountToOrder($orderInfo, $discountAmount);

        $paymentAmount = $notification->getObject()->getAmount()->getValue();
        $this->getModel()->updatePaymentAmount($paymentId, $paymentAmount);

        $this->getModel()->addOrderHistory(
            $orderInfo['order_id'],
            $statusId,
            $this->language->get('text_history_sber_loan_discount') . $discountAmount
        );
    }

    public function callback()
    {
        $this->getModel()->log('info', "callback:  request \n" . print_r($_REQUEST, true));
        $this->getModel()->log('warning', 'callback: YooMoney payment type is not available.');
        exit('YooMoney payment type is not available.');
    }

    public function repay()
    {
        if (!$this->customer->isLogged()) {
            $this->session->data['redirect'] = $this->url->link(
                $this->getPrefix().'payment/yoomoney/repay', 'order_id='.$this->request->get['order_id'], true
            );
            $this->response->redirect($this->url->link('account/login', '', true));
        }
        $this->session->data['order_id'] = $this->request->get['order_id'];
        $this->load->model('account/order');
        $order = $this->model_account_order->getOrder((int)$this->request->get['order_id']);
        if (empty($order)) {
            $this->response->redirect(
                $this->url->link('account/order/info', 'order_id='.$this->request->get['order_id'], true)
            );
        }
        $this->response->setOutput($this->payment($order, true));
    }


    public function productInfo()
    {
        $productId = !empty($this->request->post['id']) ?
            $this->request->post['id']
            : 0;

        $this->load->model('catalog/product');
        $product     = $this->model_catalog_product->getProduct($productId);
        $productInfo = array(
            'id'      => $product['product_id'],
            'name'    => (string)$product['name'],
            'price'   => (float)$product['price'],
            'brand'   => (string)$product['manufacturer'],
            'variant' => (string)$product['model'],
        );

        $this->response->setOutput(json_encode($productInfo));
    }

    /**
     * @param $price
     * @return int|string
     */
    private function formatPrice($price)
    {
        $price = number_format((float)$price, 2, '.', '');

        return $price < 0 ? 0 : $price;
    }

    /**
     * @return ModelExtensionPaymentYoomoney
     */
    public function getModel()
    {
        if ($this->_model === null) {
            $this->load->model($this->getPrefix().'payment/yoomoney');
            if ($this->getPrefix() === '') {
                $this->_model = $this->model_payment_yoomoney;
            } else {
                $this->_model = $this->model_extension_payment_yoomoney;
            }
        }

        return $this->_model;
    }

    /**
     * @param $orderInfo
     * @param $discountAmount
     * @return void
     * @throws Exception
     */
    private function addDiscountToOrder($orderInfo, $discountAmount)
    {
        $discount = (float)str_replace(' ', '', $discountAmount);
        $orderTotal =  $orderInfo['total'];

        /** Высчитываем процент, по которому будем вычислять скидку для всех позиций в заказе */
        $percentDiscount = round(100 / ($orderTotal / (int)$discount), 1);

        $orderId = $orderInfo['order_id'];

        $this->load->model('account/order');
        $this->load->model('account/customer');
        $products = $this->model_account_order->getOrderProducts($orderId);
        $vouchers = $this->model_account_order->getOrderVouchers($orderId);
        $totals = $this->model_account_order->getOrderTotals($orderId);

        $isTaxInOrder = false;
        $isDeliveryInOrder = false;
        foreach($totals as $total) {
            if ($total['code'] === 'tax') {
                $isTaxInOrder = true;
            }

            if ($total['code'] === 'shipping') {
                $isDeliveryInOrder = true;
            }
        }

        $taxAndShippingInOrder = $isTaxInOrder && $isDeliveryInOrder;

        if ($taxAndShippingInOrder) {
            foreach ($totals as $index => $total) {
                if ($total['code'] === 'total') {
                    $totals[$index]['value'] = $this->calculateTotalFromPercent($total['value'], $percentDiscount);
                }
            }
        }

        if (!$taxAndShippingInOrder) {
            foreach ($totals as $index => $total) {
                if ($total['value']) {
                    $totals[$index]['value'] = $this->calculateTotalFromPercent($total['value'], $percentDiscount);
                }
            }
        }


        foreach ($products as $index => $product) {
            if (!$taxAndShippingInOrder) {
                $products[$index]['total'] = $this->calculateTotalFromPercent($product['total'], $percentDiscount);
                $products[$index]['tax'] = $this->calculateTotalFromPercent($product['tax'], $percentDiscount);
            }
            $products[$index]['option'] = $this->model_account_order->getOrderOptions($orderId, $product['order_product_id']);
        }

        $orderInfo['products'] = $products;
        $orderInfo['vouchers'] = $vouchers;
        $orderInfo['totals'] = $totals;
        $orderInfo['total'] = $this->calculateTotalFromPercent($orderInfo['total'], $percentDiscount);
        $customerInfo = $this->model_account_customer->getCustomer($orderInfo['customer_id']);
        $orderInfo['customer_group_id'] = isset($customerInfo['customer_group_id']) ? $customerInfo['customer_group_id'] : 1;

        $this->model_checkout_order->editOrder($orderId, $orderInfo);
    }

    /**
     * Вычисление процента из числа
     *
     * @param float $total Общая сумма
     * @param float $percent Процент, который хотим вычесть из числа
     *
     * @return float
     */
    private function calculateTotalFromPercent($total, $percent)
    {
        return $total - ($percent * ($total / 100));
    }

}

class ControllerPaymentYoomoney extends ControllerExtensionPaymentYoomoney
{
}
