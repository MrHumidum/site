<?php
class ControllerExtensionModuleCustom extends Controller {
	private $error = array();
	private $version = '2.1.5';

	public function index() {
		
		$this->load->model('setting/setting');
		$this->load->model('extension/module/custom');
		$this->load->model('customer/customer_group');
		$this->load->model('extension/extension');


		$this->load->language('extension/module/custom');
		$this->document->setTitle($this->language->get('heading_title'));

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('custom', $this->request->post);
			$data['success'] = $this->language->get('text_success');
		}

		if (isset($this->error['cart'])) {
			$data['error_cart'] = $this->error['cart'];
			$data['tab_cart'] = sprintf($this->language->get('error_tab'), $this->language->get('tab_cart'));
		} else {
			$data['error_cart'] = '';
			$data['tab_cart'] = $this->language->get('tab_cart');
		}

		if (isset($this->error['customer'])) {
			$data['error_customer'] = $this->error['customer'];
			$data['tab_customer'] = sprintf($this->language->get('error_tab'), $this->language->get('tab_customer'));
		} else {
			$data['error_customer'] = '';
			$data['tab_customer'] = $this->language->get('tab_customer');
		}

		if (isset($this->error['payment'])) {
			$data['error_payment'] = $this->error['payment'];
			$data['tab_payment'] = sprintf($this->language->get('error_tab'), $this->language->get('tab_payment'));
		} else {
			$data['error_payment'] = '';
			$data['tab_payment'] = $this->language->get('tab_payment');
		}

		if (isset($this->request->post['custom_status'])) {
			$data['custom_status'] = $this->request->post['custom_status'];
		} else {
			$data['custom_status'] = $this->config->get('custom_status');
		}

		$result = $this->model_setting_setting->getSetting('custom');

		// LOGIN SETTING
		if (isset($result['custom_general'])) {
			$data['custom_general'] = $result['custom_general'];
		} else {
			$data['custom_general'] = array(
				'theme' => 'bootstrap3', 
				'setting' => 0
			);
		}

		// LOGIN SETTING
		if (isset($result['custom_login'])) {
			$data['custom_login'] = $result['custom_login'];
		} else {
			$data['custom_login'] = array(
				'status' => 0, 
				'sort' => 0
			);
		}
		
		// CART SETTING
		if (isset($result['custom_cart'])) {
			$data['custom_cart'] = $result['custom_cart'];
		} else {
			$data['custom_cart'] = array(
				'status' => 0, 
				'sort' => 0,
				'column' => array()
			);
		}
		$data['custom_cart']['list'] = $this->model_extension_module_custom->getCartColumns();

		// customer SETTING
		if (isset($result['custom_customer'])) {
			$data['custom_customer'] = $result['custom_customer'];
		} else {
			$data['custom_customer'] = array(
				'status' => 1, 
				'sort' => 0,
				'fields' => array()
			);
		}
		$data['custom_customer']['list'] = $this->model_extension_module_custom->getСustomerFieldlist();
		$data['customer_groups'] = $this->model_customer_customer_group->getCustomerGroups();

		// SHIPPING SETTING
		if (isset($result['custom_shipping'])) {
			$data['custom_shipping'] = $result['custom_shipping'];
		} else {
			$data['custom_shipping'] = array(
				'status' => 1, 
				'sort' => 0,
				'fields' => array()
			);
		}
		$data['custom_shipping']['list'] = $this->model_extension_module_custom->getShippingFieldlist();
		$data['custom_shipping']['methods'] = $this->model_extension_module_custom->getShippingMethodList();

		
		// PAYMENT SETTING
		if (isset($result['custom_payment'])) {
			$data['custom_payment'] = $result['custom_payment'];
		} else {
			$data['custom_payment'] = array(
				'status' => 1, 
				'sort' => 0
			);
		}

		$data['custom_payment']['list'] = $this->model_extension_module_custom->getPaymentMethodList();

		// comment SETTING
		if (isset($result['custom_comment'])) {
			$data['custom_comment'] = $result['custom_comment'];
		} else {
			$data['custom_comment'] = array(
				'status' => 0, 
				'sort' => 0
			);
		}

		// module SETTING
		if (isset($result['custom_module'])) {
			$data['custom_module'] = $result['custom_module'];
		} else {
			$data['custom_module'] = array(
				'status' => 0, 
				'sort' => 0
			);
		}

		// total SETTING
		if (isset($result['custom_total'])) {
			$data['custom_total'] = $result['custom_total'];
		} else {
			$data['custom_total'] = array(
				'status' => 0, 
				'sort' => 0
			);
		}

		$this->load->language('extension/module/custom');

		// BreadCrumbs
		$data['breadcrumbs'] = array();
 
		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_extension'),
			'href' => $this->url->link('marketplace/extension', 'token=' . $this->session->data['token'] . '&type=module', true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('extension/module/custom', 'token=' . $this->session->data['token'], true)
		);
		
		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_extension'] = $this->language->get('text_extension');
		$data['text_success'] = $this->language->get('text_success');
		$data['text_edit'] = $this->language->get('text_edit');

		$data['text_choose'] = $this->language->get('text_choose');
		$data['text_yes'] = $this->language->get('text_yes');
		$data['text_no'] = $this->language->get('text_no');

		$data['text_disabled'] = $this->language->get('text_disabled');
		$data['text_enabled'] = $this->language->get('text_enabled');

		// column
		$data['column_column'] = $this->language->get('column_column');
		$data['column_field'] = $this->language->get('column_field');
		$data['column_custumer_group'] = $this->language->get('column_custumer_group');
		$data['column_required'] = $this->language->get('column_required');
		$data['column_validation'] = $this->language->get('column_validation');
		$data['column_shipping_method'] = $this->language->get('column_shipping_method');

		// tab
		$data['tab_general'] = $this->language->get('tab_general');
		$data['tab_login'] = $this->language->get('tab_login');
		$data['tab_address'] = $this->language->get('tab_address');
		$data['tab_shipping'] = $this->language->get('tab_shipping');
		$data['tab_comment'] = $this->language->get('tab_comment');
		$data['tab_module'] = $this->language->get('tab_module');
		$data['tab_total'] = $this->language->get('tab_total');
		$data['tab_about'] = $this->language->get('tab_about');

		// general
		$data['entry_status'] = $this->language->get('entry_status');
		$data['entry_view'] = $this->language->get('entry_view');
		$data['entry_register'] = $this->language->get('entry_register');
		$data['entry_sort'] = $this->language->get('entry_sort');
		$data['entry_remove'] = $this->language->get('entry_remove');
		$data['entry_validate'] = $this->language->get('entry_validate');
		$data['entry_theme'] = $this->language->get('entry_theme');
		$data['entry_setting'] = $this->language->get('entry_setting');
		$data['entry_support'] = $this->language->get('entry_support');

		// Help
		$data['help_setting'] = $this->language->get('help_setting');
		$data['help_theme'] = $this->language->get('help_theme');
		$data['help_login'] = $this->language->get('help_login');

		// Buttons
		$data['button_save'] = $this->language->get('button_save');
		$data['button_cancel'] = $this->language->get('button_cancel');

		// cart
		$data['entry_cart_status'] = $this->language->get('entry_cart_status');

		// about
		$data['version'] = sprintf($this->language->get('version'), $this->version);
		$data['about_module'] = $this->language->get('about_module');

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		$data['action'] = $this->url->link('extension/module/custom', 'token=' . $this->session->data['token'], true);

		$data['cancel'] = $this->url->link('marketplace/extension', 'token=' . $this->session->data['token'] . '&type=module', true);
		
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('extension/module/custom', $data));
	}

	protected function validate() {
		
		if (!$this->user->hasPermission('modify', 'extension/module/custom')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if ($this->request->post['custom_cart']['status'] == 1 && (!isset($this->request->post['custom_cart']['column']) || count($this->request->post['custom_cart']['column']) == 0)) {
			$this->error['cart'] = $this->language->get('error_cart_nocolumns');
		} elseif (isset($this->request->post['custom_cart']['column']) && count($this->request->post['custom_cart']['column']) > 0) {
			$column_temp = array();
			foreach($this->request->post['custom_cart']['column'] as $column){
				if (!in_array($column, $column_temp)) {
					$column_temp[] = $column;
				} else {
					$this->error['cart'] = $this->language->get('error_cart_double');
				}
			}
		}

		if (!isset($this->request->post['custom_customer']['fields']) || count($this->request->post['custom_customer']['fields']) == 0) {
			$this->error['customer'] = $this->language->get('error_customer_nofields');
		} elseif (isset($this->request->post['custom_customer']['fields']) && count($this->request->post['custom_customer']['fields']) > 0) {
			$field_temp = array();
			foreach($this->request->post['custom_customer']['fields'] as $field){
				if (!in_array($field['name'], $field_temp)) {
					$field_temp[] = $field['name'];
				} else {
					$this->error['customer'] = $this->language->get('error_customer_double');
				}
			}
		}

		if (!isset($this->request->post['custom_payment']['methods']) || count($this->request->post['custom_payment']['methods']) == 0) {
			$this->error['payment'] = $this->language->get('error_payment_nomethods');
		} elseif (isset($this->request->post['custom_payment']['methods']) && count($this->request->post['custom_payment']['methods']) > 0) {
			$method_temp = array();
			foreach($this->request->post['custom_payment']['methods'] as $method){
				if (!in_array($method['name'], $method_temp)) {
					$method_temp[] = $method['name'];
				} else {
					$this->error['payment'] = $this->language->get('error_payment_double');
				}
			}
		}

		return !$this->error;
	}
}