<?php
class ModelExtensionModuleCustom extends Model {

	public function getCartColumns(){

		$this->load->language('extension/module/custom');

		return array(
			'image' => array(
				'label' => $this->language->get('label_image')
			),
			'name' => array(
				'label' => $this->language->get('label_name')
			),
			'model' => array(
				'label' => $this->language->get('label_model')
			),
			'sku' => array(
				'label' => $this->language->get('label_sku')
			),
			'quantity' => array(
				'label' => $this->language->get('label_quantity')
			),
			'price' => array(
				'label' => $this->language->get('label_price')
			),
			'total' => array(
				'label' => $this->language->get('label_total')
			),
			'remove' => array(
				'label' => $this->language->get('label_remove')
			)
		);

	}

	public function getСustomerFieldlist(){

		$this->load->language('extension/module/custom');
		$this->load->model('customer/custom_field');

		$result = array(
			'firstname' => array(
				'label' => $this->language->get('label_firstname')
			),
			'lastname' => array(
				'label' => $this->language->get('label_lastname')
			),
			'telephone' => array(
				'label' => $this->language->get('label_telephone')
			),
			'email' => array(
				'label' => $this->language->get('label_email')
			),
			'fax' => array(
				'label' => $this->language->get('label_fax')
			),
			'password' => array(
				'label' => $this->language->get('label_password')
			),
			'confirm' => array(
				'label' => $this->language->get('label_confirm')
			)
		);

		foreach($this->model_customer_custom_field->getCustomFields() as $field){
			$field_id = $field['custom_field_id'];
			if ($field['location'] === 'account' ){
				$result['custom_field'.$field_id] = array(
					'label' => $field['name']
				);
			}
		}

		return $result;

	}

	public function getShippingFieldlist(){

		$this->load->language('extension/module/custom');
		$this->load->model('customer/custom_field');

		$result = array(
			'address_1' => array(
				'label' => $this->language->get('label_address_1')
			),
			'address_2' => array(
				'label' => $this->language->get('label_address_2')
			),
			'city' => array(
				'label' => $this->language->get('label_city')
			),
			'postcode' => array(
				'label' => $this->language->get('label_postcode')
			),
			'country_id' => array(
				'label' => $this->language->get('label_country_id')
			),
			'zone_id' => array(
				'label' => $this->language->get('label_zone_id')
			),
			'company' => array(
				'label' => $this->language->get('label_company')
			)
		);

		foreach($this->model_customer_custom_field->getCustomFields() as $field){
			$field_id = $field['custom_field_id'];
			if ($field['location'] === 'address' ){
				$result['custom_field'.$field_id] = array(
					'label' => $field['name']
				);
			}
		}

		return $result;

	}

	public function getShippingMethodList(){

		$this->load->model('extension/extension');

		$methods = array();

		foreach($this->model_extension_extension->getInstalled('shipping') as $key => $method){

			$this->load->language('extension/shipping/'.$method);
			
			$methods[$key]['code'] = $method;
			$methods[$key]['label'] = $this->language->get('heading_title');

		}

		return $methods;

	}

	public function getPaymentMethodList(){

		$this->load->model('extension/extension');

		$methods = array();

		foreach($this->model_extension_extension->getInstalled('payment') as $key => $method){

			$this->load->language('extension/payment/'.$method);
			
			$methods[$key]['code'] = $method;
			$methods[$key]['label'] = $this->language->get('heading_title');

		}

		return $methods;

	}


}