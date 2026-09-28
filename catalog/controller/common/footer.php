<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerCommonFooter extends Controller {
	public function index() {
		$this->load->language('common/footer');

		$data['scripts'] = $this->document->getScripts('footer');

		$data['text_information'] = $this->language->get('text_information');
		$data['text_service'] = $this->language->get('text_service');
		$data['text_extra'] = $this->language->get('text_extra');
		$data['text_contact'] = $this->language->get('text_contact');
		$data['text_return'] = $this->language->get('text_return');
		$data['text_sitemap'] = $this->language->get('text_sitemap');
		$data['text_manufacturer'] = $this->language->get('text_manufacturer');
		$data['text_voucher'] = $this->language->get('text_voucher');
		$data['text_affiliate'] = $this->language->get('text_affiliate');
		$data['text_special'] = $this->language->get('text_special');
		$data['text_bestseller'] = $this->language->get('text_bestseller');
		$data['text_mostviewed'] = $this->language->get('text_mostviewed');
		$data['text_latest'] = $this->language->get('text_latest');
		$data['text_account'] = $this->language->get('text_account');
		$data['text_order'] = $this->language->get('text_order');
		$data['text_wishlist'] = $this->language->get('text_wishlist');
		$data['text_newsletter'] = $this->language->get('text_newsletter');

		$this->load->model('catalog/information');

		$data['informations'] = array();

		foreach ($this->model_catalog_information->getInformations() as $result) {
			if ($result['bottom']) {
				$data['informations'][] = array(
					'title' => $result['title'],
					'href'  => $this->url->link('information/information', 'information_id=' . $result['information_id'])
				);
			}
		}
$this->load->model('tool/image');

		$this->load->model('catalog/manufacturer');

		$this->load->model('catalog/product');

		$data['manufacturer'] = array();

		$manufacturers = $this->model_catalog_manufacturer->getManufacturers();

//print_r($manufacturers);

		foreach ($manufacturers as $manufacturer) {
$filter_data = array(
				'filter_manufacturer_id' => $manufacturer['customer_id']
				
			);

           
			//$product_total = $this->model_catalog_product->getTotalProducts($filter_data);
			$data['manufacturers'][] = array(
				'manufacturer_id' => $manufacturer['customer_id'],
				'name'        => $manufacturer['firstname'],
				'product_total' => $manufacturer['total'],
				'image' => $this->model_tool_image->resize($manufacturer['image'], 200,200),
				'href'        => $this->url->link('product/manufacturer/info', 'manufacturer_id=' . $manufacturer['customer_id'])
			);
		}
	//usort($data['manufacturers'], "product_total");	
		
		$data['contact'] = $this->url->link('information/contact');
		$data['return'] = $this->url->link('account/return/add', '', true);
		$data['sitemap'] = $this->url->link('information/sitemap');
		$data['manufacturer'] = $this->url->link('product/manufacturer');
		$data['voucher'] = $this->url->link('account/voucher', '', true);
		$data['affiliate'] = $this->url->link('affiliate/account', '', true);
		$data['special'] = $this->url->link('product/special');
		$data['bestseller'] = $this->url->link('product/bestseller');
		$data['mostviewed'] = $this->url->link('product/mostviewed');
		$data['latest'] = $this->url->link('product/latest');
		$data['account'] = $this->url->link('account/account', '', true);
		$data['order'] = $this->url->link('account/order', '', true);
		$data['wishlist'] = $this->url->link('account/wishlist', '', true);
		$data['newsletter'] = $this->url->link('account/newsletter', '', true);

		$data['powered'] = sprintf($this->language->get('text_powered'), $this->config->get('config_name'), date('Y', time()));

		// Whos Online
		if ($this->config->get('config_customer_online')) {
			$this->load->model('tool/online');

			if (isset($this->request->server['REMOTE_ADDR'])) {
				$ip = $this->request->server['REMOTE_ADDR'];
			} else {
				$ip = '';
			}

			if (isset($this->request->server['HTTP_HOST']) && isset($this->request->server['REQUEST_URI'])) {
				$url = 'http://' . $this->request->server['HTTP_HOST'] . $this->request->server['REQUEST_URI'];
			} else {
				$url = '';
			}

			if (isset($this->request->server['HTTP_REFERER'])) {
				$referer = $this->request->server['HTTP_REFERER'];
			} else {
				$referer = '';
			}

			$this->model_tool_online->addOnline($ip, $this->customer->getId(), $url, $referer);
		}
$data['login'] = $this->url->link('account/login', '', true);
$data['loginseller'] = $this->url->link('seller/login', '', true);

$data['email'] = $this->config->get('config_invoice_prefix');
$data['instagram'] = $this->config->get('config_fax');
$data['youtube'] = $this->config->get('config_geocode');


$this->load->model('catalog/category');

		$this->load->model('catalog/product');

		$data['categories'] = array();
$categories = $this->model_catalog_category->getCategories(0);

		foreach ($categories as $category) {
			 
				// Level 2
				$children_data = array();

				$children = $this->model_catalog_category->getCategories($category['category_id']);

				foreach ($children as $child) {
					$filter_data = array(
						'filter_category_id'  => $child['category_id'],
						'filter_sub_category' => true
					);

					$children_data[] = array(
						'name'  => $child['name'] . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : ''),
						'href'  => $this->url->link('product/category', 'path=' . $category['category_id'] . '_' . $child['category_id'])
					);
				}

				// Level 1
				$data['categories'][] = array(
					'name'     => $category['name'],
					'children' => $children_data,
					'column'   => $category['column'] ? $category['column'] : 1,
					'href'     => $this->url->link('product/category', 'path=' . $category['category_id'])
				);
		 
		}



$this->load->model('catalog/information');
$information_info = $this->model_catalog_information->getInformation(7);
$data['html'] = html_entity_decode($information_info['description'], ENT_QUOTES, 'UTF-8');
		 
		return $this->load->view('common/footer', $data);
	}
}
