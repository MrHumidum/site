<?php
class ControllerCheckoutCustom extends Controller {
	public function index() {
 
		$this->document->addScript('catalog/view/javascript/custom/checkout.js');
		$this->document->addStyle('catalog/view/javascript/custom/stylesheet.css');

		if ($this->cart->countProducts() > 0) {

			$this->load->model('setting/setting');
			$setting = $this->model_setting_setting->getSetting('custom');

			$this->load->model('extension/module/custom/custom');
		$this->document->addStyle('css/cart/style.css');
$this->document->addStyle('media/cart/media.css');
$this->document->addStyle('catalog/view/theme/default/stylesheet/haramain-checkout.css');
			$errors = $this->model_extension_module_custom_custom->validate();

			// Подгружаем настройки
			if ($setting['custom_status'] && !empty($errors)){
				$data['cart'] = $this->getChildController('cart', $setting['custom_cart']);
				$data['errors'] = $errors;
			} elseif ($setting['custom_status']) {
				$data['login'] 		= $this->getChildController('login', $setting['custom_login']);
				$data['cart'] 		= $this->getChildController('cart', $setting['custom_cart']);
				$data['customer'] = $this->getChildController('customer', $setting['custom_customer']);
				$data['shipping'] = $this->getChildController('shipping', $setting['custom_shipping']);
				$data['payment'] 	= $this->getChildController('payment', $setting['custom_payment']);
				$data['comment'] 	= $this->getChildController('comment', $setting['custom_comment']);
				$data['module'] 	= $this->getChildController('module', $setting['custom_module']);
				$data['total'] 		= $this->getChildController('total', $setting['custom_total']);
			}
			
		} else {
			$data['empty'] = $this->language->get('entry_empty');
		}

		$data['logged'] = $this->customer->isLogged();

		$this->load->language('checkout/custom');
		$this->document->setTitle($this->language->get('heading_title'));

		$data['button_continue'] = $this->language->get('button_continue');
		$data['text_loading'] = $this->language->get('text_loading');
		
		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('checkout/custom', '', true)
		);

		if ($this->config->get('config_checkout_id')) {
			$this->load->model('catalog/information');

			$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));

			if ($information_info) {
				$data['text_agree'] = sprintf($this->language->get('text_agree'), $this->url->link('information/information/agree', 'information_id=' . $this->config->get('config_checkout_id'), true), $information_info['title'], $information_info['title']);
			} else {
				$data['text_agree'] = '';
			}
		} else {
			$data['text_agree'] = '';
		}

		if (isset($this->session->data['agree'])) {
			$data['agree'] = $this->session->data['agree'];
		} else {
			$data['agree'] = '';
		}

		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');

		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');
		
		$this->response->setOutput($this->load->view('checkout/custom', $data));
	}

	public function getChildController($name, $setting){
		return $this->load->controller('extension/module/custom/'.$name, $setting);
	}

	public function render(){

		if (isset($this->request->get['block'])){

			$block = $this->request->get['block'];

			$this->load->model('setting/setting');
			$setting = $this->model_setting_setting->getSetting('custom');
			
			$this->response->setOutput($this->load->controller('extension/module/custom/'.$block, $setting['custom_'.$block]));

		}

	}

}