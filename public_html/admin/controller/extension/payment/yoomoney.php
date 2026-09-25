<?php

use YooKassa\Model\CurrencyCode;
use YooKassa\Model\PaymentStatus;

/**
 * Class ControllerExtensionPaymentYoomoney
 *
 * @property ModelSettingSetting $model_setting_setting
 * @property Url $url
 * @property Loader $load
 */
class ControllerExtensionPaymentYoomoney extends Controller
{
    const MODULE_NAME = 'yoomoney';
    const MODULE_VERSION = '2.8.2';

    /**
     * @var integer
     */
    private $npsRetryAfterDays = 90;

    private $error = array();

    /**
     * @var ModelExtensionPaymentYoomoney
     */
    private $_model;

    private $_prefix;

    private function getPrefix()
    {
        if ($this->_prefix === null) {
            $this->_prefix = '';
            if (version_compare(VERSION, '2.3.0') >= 0) {
                $this->_prefix = 'extension/';
            }
        }

        return $this->_prefix;
    }

    private function getTemplatePath($template = null)
    {
        $tpl = $this->getPrefix().'payment/yoomoney';
        if (!empty($template) && $template !== '/') {
            $tpl .= '/'.$template;
        }
        if (version_compare(VERSION, '2.2.0') < 0) {
            $tpl .= '.tpl';
        }

        return $tpl;
    }

    /**
     * @return YooMoneyKassaModel
     */
    public function getKassaModel() {
        if (!$this->kassaModel) {
            $this->kassaModel = $this->getModel()->getKassaModel();
        }
        return $this->kassaModel;
    }

    public function incl($file) {
        return modification(DIR_TEMPLATE . $this->getPrefix() . 'payment/yoomoney/' . $file);
    }

    public function index()
    {
        $prefix = $this->getPrefix();
        $this->load->language($prefix.'payment/'.self::MODULE_NAME);
        $this->document->setTitle($this->language->get('heading_title'));
        $this->load->model('setting/setting');
        $this->load->model('localisation/currency');

        $tab = 'tab-kassa';

        if (!empty($this->request->post['last_active_tab'])) {
            $this->session->data['last-active-tab'] = $this->request->post['last_active_tab'];
        } elseif (!isset($this->session->data['last-active-tab'])) {
            $this->session->data['last-active-tab'] = $tab;
        }

        $data = array(
            'lastActiveTab' => $this->session->data['last-active-tab'],
        );
        if ($this->request->server['REQUEST_METHOD'] === 'POST') {

            $this->getModel()->getKassaLog()->sendHeka(array('settings.save.init'));

            if ($this->validate($this->request)) {
                $this->enableB2bSberbank();
            } else {
                $this->saveValidationErrors();
            }

            $this->model_setting_setting->editSetting(self::MODULE_NAME, $this->request->post);

            $this->session->data['success']         = $this->language->get('kassa_text_success');
            $this->session->data['last-active-tab'] = $data['lastActiveTab'];

            if (isset($this->request->post['language_reload'])) {
                $this->session->data['success-message'] = $this->language->get('kassa_text_success_message');
                $this->getModel()->getKassaLog()->sendHeka(array('settings.save.success'));
                $this->response->redirect(
                    $this->url->link($prefix.'payment/'.self::MODULE_NAME, 'token='.$this->session->data['token'], true)
                );
            } else {
                $this->getModel()->getKassaLog()->sendHeka(array('settings.save.fail'));
                $this->response->redirect(
                    $this->url->link(
                        'extension/extension', 'token='.$this->session->data['token'].'&type=payment', true
                    )
                );
            }
        } else {
            $this->session->data['last-active-tab'] = $tab;
            $this->applyValidationErrors($data);
        }

        $data['module_version']      = self::MODULE_VERSION;
        $data['breadcrumbs']         = $this->getBreadCrumbs();
        $data['kassaTaxSystemCodes'] = $this->getKassaTaxSystemCodes();
        $data['kassaTaxRates']       = $this->getKassaTaxRates();
        $data['b2bTaxRates']         = $this->getB2bTaxRates();
        $data['shopTaxRates']        = $this->getShopTaxRates();
        $data['orderStatuses']       = $this->getAvailableOrderStatuses();
        $data['geoZones']            = $this->getAvailableGeoZones();

        if (isset($this->session->data['success-message'])) {
            $data['successMessage'] = $this->session->data['success-message'];
            unset($this->session->data['success-message']);
        }

        $data['action']          = $this->url->link($prefix.'payment/'.self::MODULE_NAME,
            'token='.$this->session->data['token'], true);
        $data['cancel']          = $this->url->link('extension/extension',
            'token='.$this->session->data['token'].'&type=payment', true);
        $data['kassa_logs_link'] = $this->url->link($prefix.'payment/'.self::MODULE_NAME.'/logs',
            'token='.$this->session->data['token'], true);

        $data['language'] = $this->language;

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');

        $data['kassa'] = $this->getKassaModel();
        $data['kassa_currencies'] = $this->createKassaCurrencyList();

        $name          = $data['kassa']->getDisplayName();
        if (empty($name)) {
            $data['kassa']->setDisplayName($this->language->get('kassa_default_display_name'));
        }

        $url                     = new Url(HTTP_CATALOG, HTTPS_CATALOG);
        $data['notificationUrl'] = $url->link($prefix.'payment/'.self::MODULE_NAME.'/capture', '', true);
        $data['callbackUrl']     = $url->link($prefix.'payment/'.self::MODULE_NAME.'/callback', '', true);

        $data['oauth_connect_url'] = htmlspecialchars_decode($this->url->link(
            $prefix . 'payment/' . self::MODULE_NAME . '/oauthConnect',
            'token=' . $this->session->data['token'],
            true
        ));

        $data['oauth_token_url'] = htmlspecialchars_decode($this->url->link(
            $prefix . 'payment/' . self::MODULE_NAME . '/oauthToken',
            'token=' . $this->session->data['token'],
            true
        ));

        if (isset($this->request->post['yoomoney_kassa_sort_order'])) {
            $data['yoomoney_kassa_sort_order'] = $this->request->post['yoomoney_kassa_sort_order'];
        } elseif ($this->config->get('yoomoney_kassa_sort_order')) {
            $data['yoomoney_kassa_sort_order'] = $this->config->get('yoomoney_kassa_sort_order');
        } else {
            $data['yoomoney_kassa_sort_order'] = '0';
        }

        $this->load->model('catalog/option');
        $this->load->model('localisation/order_status');

        $array_init             = array();

        $data['update_action']       = $this->url->link($this->getPrefix().'payment/yoomoney/update',
            'token='.$this->session->data['token'], 'SSL');
        $data['backup_action']       = $this->url->link($this->getPrefix().'payment/yoomoney/backups',
            'token='.$this->session->data['token'], 'SSL');
        $versionInfo                 = $this->getModel()->checkModuleVersion(false);
        $data['kassa_payments_link'] = $this->url->link(
            $prefix.'payment/yoomoney/payments',
            'token='.$this->session->data['token'],
            true
        );
        if (isset($versionInfo['version']) && version_compare($versionInfo['version'], self::MODULE_VERSION) > 0) {
            $data['new_version_available'] = true;
            $data['changelog']             = $this->getModel()->getChangeLog(self::MODULE_VERSION,
                $versionInfo['version']);
            $data['newVersion']            = $versionInfo['version'];
        } else {
            $data['new_version_available'] = false;
            $data['changelog']             = '';
            $data['newVersion']            = self::MODULE_VERSION;
        }
        $data['currentVersion'] = self::MODULE_VERSION;
        $data['newVersionInfo'] = $versionInfo;
        $data['backups']        = $this->getModel()->getBackupList();

        // kassa
        $arLang = array(
            'p2p_os',
            'tab_row_sign',
            'tab_row_cause',
            'tab_row_primary',
            'yoomoney_version',
            'text_license',
            'active',
            'active_on',
            'active_off',
            'log',
            'button_cancel',
            'text_installed',
            'button_save',
            'button_cancel'
        );
        foreach ($arLang as $lang_name) {
            $data[$lang_name] = $this->language->get($lang_name);
        }
        $data['mod_off'] = sprintf($this->language->get('mod_off'), $this->url->link($prefix.'payment/install',
            'token='.$this->session->data['token'].'&extension=yoomoney', true));

        $data['token'] = $this->session->data['token'];

        $results             = $this->model_catalog_option->getOptions(array('sort' => 'name'));
        $data['options']     = $results;
        $data['tab_general'] = $this->language->get('tab_general');

        $this->load->model('localisation/stock_status');
        $data['stock_statuses'] = $this->model_localisation_stock_status->getStockStatuses();
        $this->load->model('catalog/category');
        $data['categories'] = $this->model_catalog_category->getCategories(0);

        $this->document->setTitle($this->language->get('heading_title'));

        $data = array_merge($data, $this->initForm($array_init));
        $data = array_merge($data, $this->initErrors());

        $data['yoomoney_nps_prev_vote_time']    = $this->config->get('yoomoney_nps_prev_vote_time');
        $data['yoomoney_nps_current_vote_time'] = time();
        $data['callback_off_nps']                   = $this->url->link($prefix.'payment/'.self::MODULE_NAME.'/vote_nps',
            'token='.$this->session->data['token'], true);
        $data['nps_block_text']                     = sprintf($this->language->get('nps_text'),
            '<a href="#" onclick="return false;" class="yoomoney_nps_link">', '</a>');
        $isTimeForVote                              = $data['yoomoney_nps_current_vote_time'] > (int)$data['yoomoney_nps_prev_vote_time']
                                                                                                    + $this->npsRetryAfterDays * 86400;
        $data['is_needed_show_nps']                 = $isTimeForVote
                                                      && substr($this->getKassaModel()->getPassword(), 0,
                5) === 'live_'
                                                      && $data['nps_block_text'];

        $data['module'] = $this;
        if ($this->getKassaModel()->isEnabled()){
            $this->getKassaModel()->fetchShopInfo();
        }

        $data['has_oauth_token'] = (bool)$this->getKassaModel()->getOauthToken();
        $data['isConnectionFailed'] = !$this->getKassaModel()->checkConnection();
        $data['is_test_shop'] = $this->getKassaModel()->isTestShop();

        $this->response->setOutput($this->load->view($this->getTemplatePath(), $data));
    }

    /**
     * Экшен для сохранения времени голосования в NPS
     */
    public function vote_nps()
    {
        $this->load->model('setting/setting');
        $this->model_setting_setting->editSettingValue(self::MODULE_NAME, 'yoomoney_nps_prev_vote_time', time());
    }

    public function logs()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        $this->document->setTitle($this->language->get('kassa_breadcrumbs_heading_title'));

        $fileName = DIR_LOGS.'yoomoney.log';

        if (isset($_POST['clear-logs']) && $_POST['clear-logs'] === '1') {
            if (file_exists($fileName)) {
                unlink($fileName);
            }
        }
        if (isset($_POST['download']) && $_POST['download'] === '1') {
            if (file_exists($fileName) && filesize($fileName) > 0) {
                $this->response->addheader('Pragma: public');
                $this->response->addheader('Expires: 0');
                $this->response->addheader('Content-Description: File Transfer');
                $this->response->addheader('Content-Type: application/octet-stream');
                $this->response->addheader('Content-Disposition: attachment; filename="yoomoney_'.date('Y-m-d_H-i-s').'.log"');
                $this->response->addheader('Content-Transfer-Encoding: binary');

                $this->response->setOutput(file_get_contents($fileName));

                return;
            }
        }

        $content = '';
        if (file_exists($fileName)) {
            $content = file_get_contents($fileName);
        }
        $data['logs']        = $content;
        $data['breadcrumbs'] = $this->getBreadCrumbs(array(
            'text' => 'kassa_breadcrumbs_logs',
            'href' => 'logs',
        ));

        $data['language'] = $this->language;

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');
        $data['cancel']      = $this->url->link($this->getPrefix().'payment/yoomoney', 'token='.$this->session->data['token'], true);

        $this->response->setOutput($this->load->view($this->getTemplatePath('logs'), $data));
    }

    public function payments()
    {
        $prefix = $this->getPrefix();
        $this->load->language($prefix.'payment/'.self::MODULE_NAME);
        $this->load->model('setting/setting');

        if (!$this->getKassaModel()->isEnabled()) {
            $url = $this->url->link($prefix.'payment/yoomoney', 'token='.$this->session->data['token'], true);
            $this->response->redirect($url);
        }

        if (isset($this->request->get['page'])) {
            $page = $this->request->get['page'];
        } else {
            $page = 1;
        }
        $limit    = $this->config->get('config_limit_admin');
        $payments = $this->getModel()->findPayments(($page - 1) * $limit);

        if (isset($this->request->get['update_statuses'])) {

            $orderIds = array();
            foreach ($payments as $row) {
                $orderIds[$row['payment_id']] = $row['order_id'];
            }

            /** @var ModelSaleOrder $orderModel */
            $this->load->model('sale/order');
            $orderModel = $this->model_sale_order;

            $paymentObjects = $this->getModel()->updatePaymentsStatuses($payments);
            if ($this->request->get['update_statuses'] == 2) {
                foreach ($paymentObjects as $payment) {
                    $this->getModel()->log('info', 'Check payment#'.$payment->getId());
                    if ($payment['status'] === PaymentStatus::WAITING_FOR_CAPTURE) {
                        $this->getModel()->log('info', 'Capture payment#'.$payment->getId());
                        if ($this->getModel()->capturePayment($payment, false)) {
                            $orderId   = $orderIds[$payment->getId()];
                            $orderInfo = $orderModel->getOrder($orderId);
                            if (empty($orderInfo)) {
                                $this->getModel()->log('warning', 'Empty order#'.$orderId.' in notification');
                                continue;
                            } elseif ($orderInfo['order_status_id'] <= 0) {
                                $link                         = $this->url->link($prefix.'payment/yoomoney/repay',
                                    'order_id='.$orderId, true);
                                $anchor                       = '<a href="'.$link.'" class="button">Оплатить</a>';
                                $orderInfo['order_status_id'] = 1;
                                $this->getModel()->updateOrderStatus($orderId, $orderInfo, $anchor);
                            }
                            $this->getModel()->confirmOrderPayment(
                                $orderId,
                                $orderInfo,
                                $payment,
                                $this->getKassaModel()->getSuccessOrderStatusId()
                            );
                            $this->getModel()->log('info', 'Платёж для заказа №'.$orderId.' подтверждён');
                        }
                    }
                }
            }
            $link = $this->url->link($prefix.'payment/yoomoney/payments', 'token='.$this->session->data['token'],
                true);
            $this->response->redirect($link);
        }

        $this->document->setTitle($this->language->get('kassa_payments_page_title'));

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');

        $data['language']     = $this->language;
        $data['payments']     = $payments;
        $data['breadcrumbs']  = $this->getBreadCrumbs(array(
            'text' => 'kassa_breadcrumbs_payments',
            'href' => 'payments',
        ));
        $data['update_link']  = $this->url->link(
            $prefix.'payment/yoomoney/payments',
            'token='.$this->session->data['token'].'&update_statuses=1',
            true
        );
        $data['capture_link'] = $this->url->link(
            $prefix.'payment/yoomoney/payments',
            'token='.$this->session->data['token'].'&update_statuses=2',
            true
        );

        $pagination        = new Pagination();
        $pagination->total = $this->getModel()->countPayments();
        $pagination->page  = $page;
        $pagination->limit = $limit;
        $pagination->url   = $this->url->link(
            $prefix.'payment/yoomoney/payments',
            'token='.$this->session->data['token'].'&page={page}',
            true
        );

        $data['pagination'] = $pagination->render();

        $this->response->setOutput($this->load->view($this->getTemplatePath('kassa_payments_list'), $data));
    }

    public function install()
    {
        $this->getModel()->install();
    }

    public function uninstall()
    {
        $this->getModel()->uninstall();
    }

    public function getModel()
    {
        if ($this->_model === null) {
            $this->load->model($this->getPrefix().'payment/'.self::MODULE_NAME);
            if ($this->getPrefix() !== '') {
                $property = 'model_extension_payment_'.self::MODULE_NAME;
            } else {
                $property = 'model_payment_'.self::MODULE_NAME;
            }
            $this->_model = $this->__get($property);
        }

        return $this->_model;
    }

    private function getBreadCrumbs($add = null)
    {
        $params = 'token='.$this->session->data['token'];
        $result = array(
            array(
                'text' => $this->language->get('kassa_breadcrumbs_home'),
                'href' => $this->url->link('common/dashboard', $params, true),
            ),
            array(
                'text' => $this->language->get('kassa_breadcrumbs_extension'),
                'href' => $this->url->link('extension/extension', $params.'&type=payment', true),
            ),
            array(
                'text' => $this->language->get('module_title'),
                'href' => $this->url->link($this->getPrefix().'payment/'.self::MODULE_NAME, $params, true),
            ),
        );
        if (!empty($add)) {
            $result[] = array(
                'text' => $this->language->get($add['text']),
                'href' => $this->url->link($this->getPrefix().'payment/'.self::MODULE_NAME.'/'.$add['href'], $params,
                    true),
            );
        }

        return $result;
    }

    private function validate(Request $request)
    {
        $this->load->model('localisation/currency');
        if (!$this->user->hasPermission('modify', $this->getPrefix().'payment/yoomoney')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        $this->validateKassa($request);

        $enabled = false;
        if ($this->getKassaModel()->isEnabled()) {
            $enabled = true;
            $request->post['yoomoney_sort_order'] = $request->post['yoomoney_kassa_sort_order'];
        }
        $request->post['yoomoney_status'] = $enabled;

        return empty($this->error);
    }

    private function validateKassa(Request $request)
    {
        $kassa   = $this->getKassaModel();
        $enabled = false;
        if (isset($request->post['yoomoney_kassa_enabled']) && $request->post['yoomoney_kassa_enabled'] === 'on') {
            $enabled = true;
        }

        $request->post['kassa_enabled'] = $enabled;
        $kassa->setIsEnabled($enabled);

        $value = isset($request->post['yoomoney_kassa_shop_id']) ? trim($request->post['yoomoney_kassa_shop_id']) : '';
        if ($enabled && !empty($value)) {
            $kassa->setShopId($value);
        }
        $request->post['yoomoney_kassa_shop_id'] = $kassa->getShopId();

        $value = isset($request->post['yoomoney_kassa_password']) ? trim($request->post['yoomoney_kassa_password']) : '';
        $kassa->setPassword($value);
        $request->post['yoomoney_kassa_password'] = $value;

        $value = isset($request->post['yoomoney_kassa_display_name']) ? trim($request->post['yoomoney_kassa_display_name']) : '';
        if (empty($value)) {
            $value = $this->language->get('kassa_default_display_name');
        }
        $kassa->setDisplayName($value);
        $request->post['yoomoney_kassa_display_name'] = $kassa->getDisplayName();

        $value = isset($request->post['yoomoney_kassa_tax_system_default']) ? $request->post['yoomoney_kassa_tax_system_default'] : 0;
        $kassa->setDefaultTaxSystemCode($value);
        $request->post['yoomoney_kassa_tax_system_default'] = $kassa->getDefaultTaxSystemCode();

        $value = isset($request->post['yoomoney_kassa_tax_rate_default']) ? $request->post['yoomoney_kassa_tax_rate_default'] : 1;
        $kassa->setDefaultTaxRate($value);
        $request->post['yoomoney_kassa_tax_rate_default'] = $kassa->getDefaultTaxRate();

        $value = isset($request->post['yoomoney_kassa_tax_rates']) ? $request->post['yoomoney_kassa_tax_rates'] : array();
        if (is_array($value)) {
            $kassa->setTaxRates($value);
            $request->post['yoomoney_kassa_tax_rates'] = $kassa->getTaxRates();
        }

        $value = isset($request->post['yoomoney_kassa_success_order_status']) ? $request->post['yoomoney_kassa_success_order_status'] : array();
        $kassa->setSuccessOrderStatusId($value);
        $request->post['yoomoney_kassa_success_order_status'] = $kassa->getSuccessOrderStatusId();

        $value = isset($request->post['yoomoney_kassa_minimum_payment_amount']) ? $request->post['yoomoney_kassa_minimum_payment_amount'] : array();
        $kassa->setMinPaymentAmount($value);
        $request->post['yoomoney_kassa_minimum_payment_amount'] = $kassa->getMinPaymentAmount();

        $value = isset($request->post['yoomoney_kassa_geo_zone']) ? $request->post['yoomoney_kassa_geo_zone'] : array();
        $kassa->setGeoZoneId($value);
        $request->post['yoomoney_kassa_geo_zone'] = $kassa->getGeoZoneId();

        $value = isset($request->post['yoomoney_kassa_debug_log']) ? $request->post['yoomoney_kassa_debug_log'] === 'on' : false;
        $kassa->setDebugLog($value);
        $request->post['yoomoney_kassa_debug_log'] = $kassa->getDebugLog();

        $value = isset($request->post['yoomoney_kassa_invoice']) ? $request->post['yoomoney_kassa_invoice'] : false;
        $kassa->setInvoicesEnabled($value);
        $request->post['yoomoney_kassa_invoice'] = $kassa->isInvoicesEnabled();

        $value = isset($request->post['yoomoney_kassa_invoice_subject']) ? trim($request->post['yoomoney_kassa_invoice_subject']) : '';
        if (empty($value)) {
            $value = $this->language->get('kassa_invoice_subject_default');
        }
        $kassa->setInvoiceSubject($value);
        $request->post['yoomoney_kassa_invoice_subject'] = $kassa->getInvoiceSubject();

        $value = isset($request->post['yoomoney_kassa_invoice_message']) ? trim($request->post['yoomoney_kassa_invoice_message']) : '';
        $kassa->setInvoiceMessage($value);
        $request->post['yoomoney_kassa_invoice_message'] = $kassa->getInvoiceMessage();

        $value = isset($request->post['yoomoney_kassa_invoice_logo']) ? $request->post['yoomoney_kassa_invoice_logo'] === 'on' : false;
        $kassa->setSendInvoiceLogo($value);
        $request->post['yoomoney_kassa_invoice_logo'] = $kassa->getSendInvoiceLogo();

        $value = false;
        if (isset($request->post['yoomoney_kassa_create_order_before_redirect']) && $request->post['yoomoney_kassa_create_order_before_redirect'] === 'on') {
            $value = true;
        }
        $request->post['yoomoney_kassa_create_order_before_redirect'] = $value;
        $kassa->setCreateOrderBeforeRedirect($value);

        $value = false;
        if (isset($request->post['yoomoney_kassa_clear_cart_before_redirect']) && $request->post['yoomoney_kassa_clear_cart_before_redirect'] === 'on') {
            $value = true;
        }
        $request->post['yoomoney_kassa_clear_cart_before_redirect'] = $value;
        $kassa->setClearCartBeforeRedirect($value);

        $value = isset($request->post['yoomoney_kassa_show_in_footer']) ? $request->post['yoomoney_kassa_show_in_footer'] : 'off';
        $kassa->setShowLinkInFooter($value === 'on');
        $request->post['yoomoney_kassa_show_in_footer'] = $kassa->getShowLinkInFooter();

        $request->post['yoomoney_kassa_test_shop'] = $kassa->isTestShop();
        $request->post['yoomoney_kassa_fiscalization_enabled'] = $kassa->isFiscalisationEnabled();
        $request->post['yoomoney_kassa_token_expires_in'] = $kassa->getOauthTokenExpiresIn();
        $request->post['yoomoney_kassa_access_token'] = $kassa->getOauthToken();
    }

    private function saveValidationErrors()
    {
        $this->session->data['errors_settings'] = array();
        if (!empty($this->error)) {
            foreach ($this->error as $key => $error) {
                $this->session->data['errors_settings'][$key] = $error;
            }
        }
    }

    private function applyValidationErrors(&$data)
    {
        if (!empty($this->session->data['errors_settings'])) {
            foreach ($this->session->data['errors_settings'] as $key => $error) {
                $data['error_'.$key] = $error;
            }
            unset($this->session->data['errors_settings']);
        }
    }

    private function getShopTaxRates()
    {
        $this->load->model('localisation/tax_class');
        $model = $this->model_localisation_tax_class;

        $result = array();
        foreach ($model->getTaxClasses() as $taxRate) {
            $result[$taxRate['tax_class_id']] = $taxRate['title'];
        }

        return $result;
    }

    private function getKassaTaxRates()
    {
        $result = array();
        foreach ($this->getKassaModel()->getTaxRateList() as $taxRateId) {
            $key                = 'kassa_tax_rate_'.$taxRateId.'_label';
            $result[$taxRateId] = $this->language->get($key);
        }

        return $result;
    }

    private function getKassaTaxSystemCodes()
    {
        $result = array();
        foreach ($this->getKassaModel()->getTaxSystemCodeList() as $taxRateId) {
            $key                = 'kassa_tax_system_'.$taxRateId.'_label';
            $result[$taxRateId] = $this->language->get($key);
        }

        return $result;
    }

    private function getB2bTaxRates()
    {
        $result = array();
        foreach ($this->getKassaModel()->getB2bRateList() as $taxRateId) {
            $key                = 'b2b_tax_rate_'.$taxRateId.'_label';
            $result[$taxRateId] = $this->language->get($key);
        }

        return $result;
    }

    private function getAvailableGeoZones()
    {
        $this->load->model('localisation/geo_zone');
        $result = array();
        foreach ($this->model_localisation_geo_zone->getGeoZones() as $row) {
            $result[$row['geo_zone_id']] = $row['name'];
        }

        return $result;
    }

    private function getAvailableOrderStatuses()
    {
        $this->load->model('localisation/order_status');
        $result = array();
        foreach ($this->model_localisation_order_status->getOrderStatuses() as $row) {
            $result[$row['order_status_id']] = $row['name'];
        }

        return $result;
    }

    private function initForm($array)
    {
        $prefix = $this->getPrefix();
        foreach ($array as $a) {
            $data[$a] = $this->config->get($a);
        }

        $url = new Url(HTTP_CATALOG, HTTPS_CATALOG);
        if ($this->config->get('config_secure')) {
            $data['yoomoney_kassa_fail']               = HTTPS_CATALOG.'index.php?route=checkout/failure';
            $data['yoomoney_kassa_success']            = HTTPS_CATALOG.'index.php?route=checkout/success';
            $data['yoomoney_p2p_linkapp']              = HTTPS_CATALOG.'index.php?route='.$prefix.'payment/yoomoney/inside';
        } else {
            $data['yoomoney_kassa_fail']               = HTTP_CATALOG.'index.php?route=checkout/failure';
            $data['yoomoney_kassa_success']            = HTTP_CATALOG.'index.php?route=checkout/success';
            $data['yoomoney_p2p_linkapp']              = HTTP_CATALOG.'index.php?route='.$prefix.'payment/yoomoney/inside';
        }

        $data['mod_status']                    = $this->config->get('yoomoney_status');

        return $data;
    }

    private function initErrors()
    {
        $this->language->load($this->getPrefix().'payment/yoomoney');
        $data                  = array();

        if (empty($data['kassa_status'])) {
            $data['kassa_status'][] = '';
        }//$this->success_alert('Все необходимые настроки заполнены!');

        return $data;
    }

    public function sendmail()
    {
        $this->language->load($this->getPrefix().'payment/yoomoney');

        $json     = array();
        $order_id = (isset($this->request->get['order_id'])) ? $this->request->get['order_id'] : 0;
        if ($order_id <= 0) {
            $json['error'] = $this->language->get('kassa_invoices_invalid_order_id');
            $this->sendResponseJson($json);

            return true;
        }
        $kassa = $this->getKassaModel();
        if (!$kassa->isEnabled()) {
            $json['error'] = $this->language->get('kassa_invoices_kassa_disabled');
            $this->sendResponseJson($json);

            return true;
        }
        if (!$kassa->isInvoicesEnabled()) {
            $json['error'] = $this->language->get('kassa_invoices_disabled');
            $this->sendResponseJson($json);

            return true;
        }
        $this->load->model('sale/order');
        $order_info = $this->model_sale_order->getOrder($order_id);
        if (empty($order_info)) {
            $json['error'] = $this->language->get('kassa_invoices_order_not_exists');
            $this->sendResponseJson($json);

            return true;
        }
        $email     = $order_info['email'];
        $products  = $this->model_sale_order->getOrderProducts($order_id);
        $amount    = number_format(
            $this->currency->convert(
                $this->currency->format(
                    $order_info['total'], $order_info['currency_code'], $order_info['currency_value'], false
                ),
                $order_info['currency_code'],
                'RUB'
            ),
            2, '.', ''
        );
        $urlHelper = new Url(HTTP_CATALOG, HTTPS_CATALOG);
        $url       = $urlHelper->link($this->getPrefix().'payment/yoomoney/simplepayment', 'order_id='.$order_id,
            true);
        $logo      = (is_file(DIR_IMAGE.$this->config->get('config_logo'))) ? DIR_IMAGE.$this->config->get('config_logo') : '';

        $replaceMap = array(
            '%order_id%'  => $order_id,
            '%shop_name%' => $order_info['store_name'],
        );
        foreach ($order_info as $key => $value) {
            if (is_scalar($value)) {
                $replaceMap['%'.$key.'%'] = $value;
            } else {
                $replaceMap['%'.$key.'%'] = json_encode($value);
            }
        }
        $text_instruction = strtr($kassa->getInvoiceMessage(), $replaceMap);
        $subject          = strtr($kassa->getInvoiceSubject(), $replaceMap);

        $link_img = ($this->request->server['HTTPS']) ? HTTPS_CATALOG : HTTP_CATALOG;
        $data     = array(
            'language'      => $this->language,
            'shop_name'     => $order_info['store_name'],
            'shop_url'      => $order_info['store_url'],
            'shop_logo'     => 'cid:'.basename($logo),
            'b_logo'        => $kassa->getSendInvoiceLogo(),
            'customer_name' => $order_info['customer'],
            'order_id'      => $order_id,
            'sum'           => $amount,
            'link'          => $url,
            'yoomoney_button' => $link_img.'image/cache/yoomoney_buttons.png',
            'total'         => $order_info['total'],
            'shipping'      => $order_info['shipping_method'],
            'products'      => $products,
            'instruction'   => $text_instruction,
        );
        $message  = $this->load->view($this->getTemplatePath('invoice_message'), $data);

        try {
            $mail = new Mail();

            $mail->protocol      = $this->config->get('config_mail_protocol');
            $mail->parameter     = $this->config->get('config_mail_parameter');
            $mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
            $mail->smtp_username = $this->config->get('config_mail_smtp_username');
            $mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES,
                'UTF-8');
            $mail->smtp_port     = $this->config->get('config_mail_smtp_port');
            $mail->smtp_timeout  = $this->config->get('config_mail_smtp_timeout');

            $mail->setTo($email);
            $mail->setFrom($this->config->get('config_email'));
            $mail->setSender($this->config->get('config_email'));
            $mail->setSubject($subject);
            $mail->addAttachment(DIR_CATALOG.'view/theme/default/image/yoomoney_buttons.png');
            if ($kassa->getSendInvoiceLogo() && $logo != '') {
                $mail->addAttachment($logo);
            }
            $mail->setHtml($message);
            $mail->send();
        } catch (Exception $e) {
            $json['error'] = $e->getMessage();
            $this->sendResponseJson($json);
        }
        $json['success'] = sprintf("Счет на оплату заказа %s выставлен", $order_id);
        $this->sendResponseJson($json);
    }

    /**
     * Подтверждение холдового платежа
     */
    public function capture()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        $this->load->model('setting/setting');

        $orderId = isset($this->request->get['order_id']) ? (int)$this->request->get['order_id'] : 0;
        if (empty($orderId)) {

            $this->response->redirect($this->url->link('sale/order', 'token='.$this->session->data['token'], true));
        }
        $this->load->model('sale/order');
        $returnUrl  = $this->url->link('sale/order', 'token='.$this->session->data['token'].'&order_id='.$orderId,
            true);
        $orderModel = $this->model_sale_order;
        $orderInfo  = $this->model_sale_order->getOrder($orderId);
        if (empty($orderInfo)) {
            $this->response->redirect($returnUrl);
        }
        $kassaModel = $this->getKassaModel();
        $paymentId  = $this->getModel()->findPaymentIdByOrderId($orderId);
        if (empty($paymentId)) {
            $this->response->redirect($returnUrl, 'SSL');
        }
        /** @var \YooKassa\Request\Payments\PaymentResponse $payment */
        $payment = $this->getModel()->fetchPaymentInfo($paymentId);
        if ($payment === null) {
            $this->response->redirect($returnUrl);
        }
        $amount  = $payment->getAmount()->getValue();
        $comment = '';

        if ($this->request->server['REQUEST_METHOD'] == 'POST' && isset($this->request->post['kassa_capture_amount'])) {
            $action = $this->request->post['action'];
            if ($action == 'capture') {
                //@ToDo расскоментировать при появлении частичного подтверждения.
                //$orderInfo = $this->updateOrder($orderModel, $orderInfo);
                $amount = $this->request->post['kassa_capture_amount'];
                if ($this->getModel()->capturePayment($payment, true, $amount)) {
                    $data['success'] = $this->language->get('capture_payment_success_message');
                } else {
                    $data['error'] = $this->language->get('capture_payment_fail_message');
                }

            } elseif ($action == 'cancel') {
                if ($this->getModel()->cancelPayment($payment)) {
                    $orderInfo['order_status_id'] = $kassaModel->getOrderCanceledStatus();
                    $this->getModel()->updateOrderStatus($orderId, $orderInfo);
                    $data['success'] = $this->language->get('cancel_payment_success_message');
                } else {
                    $data['error'] = $this->language->get('cancel_payment_fail_message');
                }
            }

            $this->response->redirect($this->url->link(
                $this->getPrefix().'payment/yoomoney/capture',
                'token='.$this->session->data['token'].'&order_id='.$orderId,
                true
            ));
        }

        $paymentMethod = '';
        $paymentData   = $payment->getPaymentMethod();
        if ($paymentData !== null) {
            $paymentMethod = $this->language->get('kassa_payment_method_'.$paymentData->getType());
        }
        $paymentCaptured = in_array($payment->getStatus(), array(PaymentStatus::SUCCEEDED, PaymentStatus::CANCELED));
        $products        = $this->model_sale_order->getOrderProducts($orderId);

        $data['kassa']           = $this->getKassaModel();
        $data['paymentCaptured'] = $paymentCaptured;
        $data['payment']         = $payment;
        $data['order']           = $orderInfo;
        $data['products']        = $products;

        $data['paymentMethod']  = $paymentMethod;
        $data['amount']         = $amount;
        $data['comment']        = $comment;
        $data['error']          = isset($this->session->data['error']) ? $this->session->data['error'] : '';
        $data['capture_amount'] = $amount;

        unset($this->session->data['error']);

        $data['vouchers'] = array();

        $vouchers = $this->model_sale_order->getOrderVouchers($this->request->get['order_id']);

        foreach ($vouchers as $voucher) {
            $data['vouchers'][] = array(
                'description' => $voucher['description'],
                'amount'      => $this->currency->format($voucher['amount'], $orderInfo['currency_code'],
                    $orderInfo['currency_value']),
                'href'        => $this->url->link('sale/voucher/edit',
                    'token='.$this->session->data['token'].'&voucher_id='.$voucher['voucher_id'], true),
            );
        }

        $data['totals'] = array();

        $totals = $this->model_sale_order->getOrderTotals($this->request->get['order_id']);

        foreach ($totals as $total) {
            $data['totals'][] = array(
                'title' => $total['title'],
                'text'  => $this->currency->format($total['value'], $orderInfo['currency_code'],
                    $orderInfo['currency_value']),
            );
        }

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');
        $data['language']    = $this->language;
        $data['cancel']      = $this->url->link('sale/order', 'token='.$this->session->data['token'], true);
        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token='.$this->session->data['token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => 'Заказы',
            'href' => $this->url->link('sale/order', 'token='.$this->session->data['token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => 'Подтверждение заказа №'.$orderId,
            'href' => $this->url->link($this->getPrefix().'payment/yoomoney/capture',
                'token='.$this->session->data['token'].'&order_id='.$orderId, true),
        );

        $this->response->setOutput($this->load->view($this->getTemplatePath('capture'), $data));
    }

    /**
     * @param ModelSaleOrder $orderModel
     * @param array $order
     *
     * @return array
     */
    private function updateOrder($orderModel, $order)
    {
        require_once(DIR_CATALOG.'model/checkout/order.php');
        require_once(DIR_CATALOG.'model/account/customer.php');
        require_once(DIR_CATALOG.'model/account/order.php');
        require_once(DIR_CATALOG.'model/'.$this->getPrefix().'total/voucher.php');
        require_once(DIR_CATALOG.'model/'.$this->getPrefix().'total/sub_total.php');
        require_once(DIR_CATALOG.'model/'.$this->getPrefix().'total/shipping.php');
        require_once(DIR_CATALOG.'model/'.$this->getPrefix().'total/tax.php');
        require_once(DIR_CATALOG.'model/'.$this->getPrefix().'total/total.php');

        $this->registry->set('model_checkout_order', new ModelCheckoutOrder($this->registry));
        $this->registry->set('model_account_order', new ModelAccountOrder($this->registry));

        if (version_compare(VERSION, '2.3.0') >= 0) {
            $this->registry->set('model_account_customer', new ModelAccountCustomer($this->registry));
            $this->registry->set('model_extension_total_voucher', new ModelExtensionTotalVoucher($this->registry));
            $this->registry->set('model_extension_total_sub_total', new ModelExtensionTotalSubTotal($this->registry));
            $this->registry->set('model_extension_total_shipping', new ModelExtensionTotalShipping($this->registry));
            $this->registry->set('model_extension_total_tax', new ModelExtensionTotalTax($this->registry));
            $this->registry->set('model_extension_total_total', new ModelExtensionTotalTotal($this->registry));
        } else {
            $this->registry->set('model_extension_total_voucher', new ModelTotalVoucher($this->registry));
            $this->registry->set('model_extension_total_sub_total', new ModelTotalSubTotal($this->registry));
            $this->registry->set('model_extension_total_shipping', new ModelTotalShipping($this->registry));
            $this->registry->set('model_extension_total_tax', new ModelTotalTax($this->registry));
            $this->registry->set('model_extension_total_total', new ModelTotalTotal($this->registry));
        }

        $quantity = $this->request->post['quantity'];

        $products = $orderModel->getOrderProducts($order['order_id']);
        foreach ($products as $index => $product) {
            if ($quantity[$product['product_id']] == "0") {
                unset($products[$index]);
                continue;
            }
            $products[$index]['quantity'] = $quantity[$product['product_id']];
            $products[$index]['total']    = $products[$index]['price'] * $products[$index]['quantity'];
            $products[$index]['option']   = $orderModel->getOrderOptions(
                $order['order_id'],
                $product['order_product_id']
            );
        }
        $order['products'] = array_values($products);
        $order['vouchers'] = $orderModel->getOrderVouchers($order['order_id']);
        $order['totals']   = $orderModel->getOrderTotals($order['order_id']);

        $this->model_checkout_order->editOrder($order['order_id'], $order);

        return $order;
    }

    /**
     * Возврат платежа
     */
    public function refund()
    {
        $this->load->language($this->getPrefix().'payment/'.self::MODULE_NAME);
        $this->load->model('setting/setting');
        $error = array();

        $orderId = isset($this->request->get['order_id']) ? (int)$this->request->get['order_id'] : 0;
        if (empty($orderId)) {
            $this->response->redirect($this->url->link('sale/order', 'token='.$this->session->data['token'], true));
        }
        $this->load->model('sale/order');
        $returnUrl = $this->url->link('sale/order', 'token='.$this->session->data['token'].'&order_id='.$orderId, true);
        $orderInfo = $this->model_sale_order->getOrder($orderId);
        if (empty($orderInfo)) {
            $this->response->redirect($returnUrl);
        }
        $kassaModel = $this->getKassaModel();
        $paymentId  = $this->getModel()->findPaymentIdByOrderId($orderId);
        if (empty($paymentId)) {
            $this->response->redirect($returnUrl, 'SSL');
        }
        $payment = $this->getModel()->fetchPaymentInfo($paymentId);
        if ($payment === null) {
            $this->response->redirect($returnUrl);
        }
        $amount  = $payment->getAmount()->getValue();
        $comment = '';

        if ($this->request->server['REQUEST_METHOD'] == 'POST' && isset($this->request->post['kassa_refund_amount'])) {
            $amount = $this->request->post['kassa_refund_amount'];
            if (!is_numeric($amount)) {
                $error['kassa_refund_amount'] = $this->language->get('kassa_refund_sum_error_int');
            } elseif ($amount > $payment->getAmount()->getValue()) {
                $error['kassa_refund_amount'] = $this->language->get('kassa_refund_sum_error');
            }
            $comment = trim($this->request->post['kassa_refund_comment']);
            if (empty($comment)) {
                $error['kassa_refund_comment'] = $this->language->get('kassa_refund_comment_error');
            }
            if (empty($error)) {
                if (!$this->refundPayment($payment, $orderInfo, $amount, $comment)) {
                    $this->session->data['error'] = $this->language->get('kassa_refund_failed');
                } else {
                    $this->response->redirect(
                        $this->url->link($this->getPrefix().'payment/yoomoney/refund',
                            'token='.$this->session->data['token'].'&order_id='.$orderId, true)
                    );
                }
            }
        }

        $paymentMethod = 'не выбран';
        $paymentData   = $payment->getPaymentMethod();
        if ($paymentData !== null) {
            $paymentMethod = $this->language->get('kassa_payment_method_'.$paymentData->getType());
        }

        $data['kassa']             = $this->getKassaModel();
        $data['payment']           = $payment;
        $data['order']             = $orderInfo;
        $data['paymentMethod']     = $paymentMethod;
        $data['errors']            = $error;
        $data['amount']            = $amount;
        $data['comment']           = $comment;
        $data['error']             = isset($this->session->data['error']) ? $this->session->data['error'] : '';
        $data['refunds']           = $this->getModel()->getOrderRefunds($orderInfo['order_id']);
        $data['refundable_amount'] = $amount;
        foreach ($data['refunds'] as $refund) {
            if ($refund['status'] !== \YooKassa\Model\RefundStatus::CANCELED) {
                $data['refundable_amount'] -= $refund['amount'];
                if ($data['refundable_amount'] < 0) {
                    $data['refundable_amount'] = 0;
                }
            }
        }
        $data['refundable_amount'] = round($data['refundable_amount'], 2);
        unset($this->session->data['error']);

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');
        $data['language']    = $this->language;

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token='.$this->session->data['token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => 'Заказы',
            'href' => $this->url->link('sale/order', 'token='.$this->session->data['token'], true),
        );

        $data['breadcrumbs'][] = array(
            'text' => 'Возвраты заказа №'.$orderId,
            'href' => $this->url->link($this->getPrefix().'payment/yoomoney/refund',
                'token='.$this->session->data['token'].'&order_id='.$orderId, true),
        );

        $this->response->setOutput($this->load->view($this->getTemplatePath('refund'), $data));
    }

    /**
     * @param \YooKassa\Model\PaymentInterface $payment
     * @param array $order
     * @param float $amount
     * @param string $comment
     *
     * @return bool
     */
    private function refundPayment($payment, $order, $amount, $comment)
    {
        $response = $this->getModel()->refundPayment($payment, $order, $amount, $comment);
        if ($response === null) {
            return false;
        }

        return true;
    }

    protected function sendResponseJson($json, $code = 200)
    {
        if (isset($this->request->server['HTTP_ORIGIN'])) {
            $this->response->addHeader('Access-Control-Allow-Origin: '.$this->request->server['HTTP_ORIGIN']);
            $this->response->addHeader('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS');
            $this->response->addHeader('Access-Control-Max-Age: 1000');
            $this->response->addHeader('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->addHeader('HTTP/1.1 ' . $code);
        $this->response->setOutput(json_encode($json));
    }

    private function errors_alert($text)
    {
        $html = '<div class="alert alert-danger">
            <i class="fa fa-exclamation-circle"></i> '.$text.'
                <button type="button" class="close" data-dismiss="alert">×</button>
        </div>';

        return $html;
    }

    public function update()
    {
        $data = array();
        $link = $this->url->link($this->getPrefix().'payment/yoomoney', 'token='.$this->session->data['token'], 'SSL');

        $versionInfo = $this->getModel()->checkModuleVersion();

        if (isset($this->request->post['update']) && $this->request->post['update'] == '1') {
            $this->getModel()->getKassaLog()->sendHeka(array('module.update.init'));
            $fileName = $this->getModel()->downloadLastVersion($versionInfo['tag']);
            $logs     = $this->url->link($this->getPrefix().'payment/yoomoney/logs', 'token='.$this->session->data['token'], 'SSL');
            if (!empty($fileName)) {
                if ($this->getModel()->createBackup(self::MODULE_VERSION)) {
                    if ($this->getModel()->unpackLastVersion($fileName)) {
                        $this->session->data['flash_message'] = sprintf($this->language->get('updater_success_message'), $this->request->post['version']);
                        $this->getModel()->getKassaLog()->sendHeka(array('module.update.success'));
                        $this->response->redirect($link);
                    } else {
                        $data['errors'][] = sprintf($this->language->get('updater_error_unpack_failed'), $fileName);
                    }
                } else {
                    $data['errors'][] = sprintf($this->language->get('updater_error_backup_create_failed'), $logs);
                }
            } else {
                $data['errors'][] = sprintf($this->language->get('updater_error_archive_load'), $logs);
            }
            $this->getModel()->getKassaLog()->sendHeka(array('module.update.fail'));
        }

        $this->response->redirect($link);
    }

    public function backups()
    {
        $link = $this->url->link($this->getPrefix().'payment/yoomoney', 'token='.$this->session->data['token'], 'SSL');

        if (!empty($this->request->post['action'])) {
            $logs = $this->url->link(
                $this->getPrefix().'payment/yoomoney/logs',
                'token='.$this->session->data['token'],
                'SSL'
            );
            switch ($this->request->post['action']) {
                case 'restore';
                    if (!empty($this->request->post['file_name'])) {
                        if ($this->getModel()->restoreBackup($this->request->post['file_name'])) {
                            $this->session->data['flash_message'] = sprintf($this->language->get('updater_restore_backup_message'),
                                $this->request->post['version'], $this->request->post['file_name']);
                            $this->response->redirect($link);
                        }
                        $data['errors'][] = sprintf($this->language->get('updater_error_restore_backup'), $logs);
                    }
                    break;
                case 'remove':
                    if (!empty($this->request->post['file_name'])) {
                        if ($this->getModel()->removeBackup($this->request->post['file_name'])) {
                            $this->session->data['flash_message'] = sprintf($this->language->get('updater_backup_deleted_message'),
                                $this->request->post['file_name']);
                            $this->response->redirect($link);
                        }
                        $data['errors'][] = sprintf($this->language->get('updater_error_delete_backup'),
                            $this->request->post['file_name'], $logs);
                    }
                    break;
            }
        }

        $this->response->redirect($link);
    }

    /**
     * @return array
     */
    private function createKassaCurrencyList()
    {
        $all_currencies = $this->model_localisation_currency->getCurrencies();
        $kassa_currencies = CurrencyCode::getEnabledValues();

        $available_currencies = array();
        foreach ($all_currencies as $key => $item) {
            if (in_array($key, $kassa_currencies) && $item['status'] == 1) {
                $available_currencies[$key] = $item;
            }
        }

        return array_merge(array(
            'RUB' => array(
                'title' => 'Российский рубль',
                'code' => CurrencyCode::RUB,
                'symbol_left' => '',
                'symbol_right' => '₽',
                'decimal_place' => '2',
                'status' => '1',
            )
        ), $available_currencies);
    }

    /**
     * @param $val
     * @param bool $return_null
     * @return bool|mixed|null
     */
    public function isTrue($val, $return_null=false)
    {
        $boolVal = ( is_string($val) ? filter_var($val, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) : (bool) $val );
        return ( $boolVal===null && !$return_null ? false : $boolVal );
    }

    private function enableB2bSberbank()
    {
        if ($this->request->post['yoomoney_status']
            && isset($this->request->post['yoomoney_kassa_b2b_sberbank_enabled'])
            && $this->request->post['yoomoney_kassa_b2b_sberbank_enabled'] == 'on'
        ) {
            $this->model_setting_setting->editSetting('yoomoney_b2b_sberbank', array(
                'yoomoney_b2b_sberbank_status' => true,
            ));
        } else {
            $this->model_setting_setting->editSetting('yoomoney_b2b_sberbank', array(
                'yoomoney_b2b_sberbank_status' => false,
            ));
        }
    }

    /**
     * Обрабатывает ajax запрос с фронта на получение URL для авторизации пользователя через OAuth,
     * загружает модель из файла yoomoney_oauth.php, вызывает ф-ю getOauthConnectUrl() и инициирует ответ на фронт
     *
     * @return void
     */
    public function oauthConnect()
    {
        if (!$this->user->hasPermission('modify', $this->getPrefix().'payment/yoomoney')) {
            $this->sendResponseJson(json_encode(array('error' => 'Permission denied')), 403);
        }
        $this->getModel()->getKassaLog()->sendHeka(array('oauth.process.init'));
        $model = $this->getOauthModel();
        $response = $model->getOauthConnectUrl();
        $code = isset($response['error']) ? 502 : 200;
        if ($code === 200) {
            $this->getModel()->getKassaLog()->sendHeka(array('oauth.process.success'));
        } else {
            $this->getModel()->getKassaLog()->sendHeka(array('oauth.process.fail'));
        }
        $this->sendResponseJson(json_encode($response), $code);
    }

    /**
     * Обрабатывает ajax запрос с фронта на получение и сохранение OAuth токена,
     * загружает модель из файла yoomoney_oauth.php, вызывает ф-ю getOauthToken() и инициирует ответ на фронт
     *
     * @return void
     */
    public function oauthToken()
    {
        if (!$this->user->hasPermission('modify', $this->getPrefix().'payment/yoomoney')) {
            $this->sendResponseJson(json_encode(array('error' => 'Permission denied')), 403);
        }
        $this->getModel()->getKassaLog()->sendHeka(array('oauth.callback.init'));
        $model = $this->getOauthModel();
        $response = $model->getOauthToken();
        $code = isset($response['error']) ? 502 : 200;
        if ($code === 200) {
            $this->getModel()->getKassaLog()->sendHeka(array('oauth.callback.success'));
        } else {
            $this->getModel()->getKassaLog()->sendHeka(array('oauth.callback.fail'));
        }
        $this->sendResponseJson(json_encode($response), $code);
    }

    private function getOauthModel()
    {
        $this->load->model($this->getPrefix().'payment/yoomoney_oauth');

        return $this->getPrefix() === ''
            ? $this->__get('model_payment_yoomoney_oauth')
            : $this->__get('model_extension_payment_yoomoney_oauth');
    }
}


class ControllerPaymentYoomoney extends ControllerExtensionPaymentYoomoney
{
}
