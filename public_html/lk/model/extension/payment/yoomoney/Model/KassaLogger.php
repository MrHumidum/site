<?php

namespace YooMoneyModule\Model;

use Exception;
use Log;
use RuntimeException;

class KassaLogger
{
    const OAUTH_CMS_URL = 'https://yookassa.ru/integration/oauth-cms';

    private $shopId = null;

    /**
     * @param null $shopId
     */
    public function __construct($shopId = null)
    {
        $this->shopId = $shopId;
    }

    /**
     * @return null
     */
    public function getShopId()
    {
        return $this->shopId;
    }

    /**
     * @param null $shopId
     * @return KassaLogger
     */
    public function setShopId($shopId)
    {
        $this->shopId = $shopId;
        return $this;
    }


    /**
     * @param $data
     * @return bool
     */
    public function sendMetric($data)
    {
        $parameters = array(
            'cms' => 'opencart2',
            'host' => $_SERVER['HTTP_HOST'],
            'shop_id' => $this->shopId,
        );

        $options = array(
            CURLOPT_URL => self::OAUTH_CMS_URL . '/metric/opencart',
            CURLOPT_POSTFIELDS => json_encode(array_merge($data, $parameters), JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
        );

        try {
            $this->makeRequest($options);
        } catch (Exception $e) {
            $this->log('error', 'Failed to send metric: ' . $e->getMessage());
            return false;
        }

        return true;
    }

    public function sendHeka($metrics)
    {
        $this->sendMetric(array(
            'metric_heka' => $metrics
        ));
    }

    public function sendBI($type, $metrics)
    {
        $this->sendMetric(array(
            'metric_bi' => array(
                'type' => $type,
                'data' => $metrics
            )
        ));
    }

    public function sendAlertLog($message, $context = array(), $metrics = array())
    {
        if (!empty($context['exception']) && $context['exception'] instanceof Exception) {
            $exception = $context['exception'];
            $context['exception'] = array(
                'code' => $exception->getCode(),
                'message' => $exception->getMessage(),
                'file' => $exception->getFile() . ':' . $exception->getLine(),
                'trace' => $exception->getTraceAsString(),
            );
        }
        $data = array(
            'metric_app' => array(
                'level' => 'alert',
                'message' => $message,
                'context' => $context,
            )
        );
        if (!empty($metrics)) {
            $data['metric_heka'] = $metrics;
        }
        $this->sendMetric($data);
    }


    /**
     * Выполняет запрос с полученными параметрами
     *
     * @param array $options - массив curl опций
     * @return void
     * @throws Exception
     */
    private function makeRequest($options)
    {
        $optionsConst = array(
            CURLOPT_HTTPHEADER => array('Content-Type:application/json;charset=utf-8'),
            CURLOPT_POST => 1,
            CURLOPT_RETURNTRANSFER => 1
        );
        $options = $optionsConst + $options;
        $ch = curl_init();
        curl_setopt_array($ch, $options);
        $result = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($status !== 200) {
            throw new RuntimeException(
                'Response status code is not 200. Code: ' . $status . ' Response: ' . $result
            );
        }

    }

    /**
     * @param string $level
     * @param string $message
     * @param array $context
     */
    public function log($level, $message, $context = array())
    {
        $log     = new Log('yoomoney.log');
        $search  = array();
        $replace = array();
        if (!empty($context)) {
            foreach ($context as $key => $value) {
                $search[]  = '{'.$key.'}';
                $replace[] = (is_array($value)||is_object($value)) ? json_encode($value, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE) : $value;
            }
        }
        $sessionId = session_id();
        $userId    = 0;
        $message = strip_tags($message);
        if (empty($search)) {
            $log->write('['.$level.'] ['.$userId.'] ['.$sessionId.'] - '.$message);
        } else {
            $log->write(
                '['.$level.'] ['.$userId.'] ['.$sessionId.'] - '
                .str_replace($search, $replace, $message)
            );
        }
    }
}
