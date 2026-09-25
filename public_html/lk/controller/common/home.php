<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerCommonHome extends Controller {
	public function index() {
		$this->document->setTitle($this->config->get('config_meta_title'));
		$this->document->setDescription($this->config->get('config_meta_description'));
		$this->document->setKeywords($this->config->get('config_meta_keyword'));
$this->document->addScript('js/main/script.js');

		if (isset($this->request->get['route'])) {
			$this->document->addLink($this->config->get('config_url'), 'canonical');
		}

	if (isset($this->request->get['mycart'])) {

$this->load->model('account/order');

$order_info = $this->model_account_order->getOrder($this->request->get['mycart']);

$uname = $order_info['firstname'];
$utelephone= $order_info['telephone'];
$uemail = $order_info['email'];
$this->session->data['coupon'] = $this->request->get['cupon'];
    $this->session->data['guest'] = array(
                'customer_group_id' => 1,
                'firstname' => $uname,
                'lastname' => '',
                'email' => $uemail ,
                'telephone' => $utelephone,
                'fax' => '',
                'custom_field' => '',
                'shipping_address' => '',
            );


$products = $this->model_account_order->getOrderProducts($this->request->get['mycart']);
foreach ($products as $product) {

$this->cart->add($product['product_id'], 1, '', '');
			}
$this->response->redirect($this->url->link('checkout/custom'));
		}


		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');

$this->load->model('extension/module');
$info = $this->model_extension_module->getModule(40);

$data['html'] = html_entity_decode($info['module_description'][$this->config->get('config_language_id')]['description'], ENT_QUOTES, 'UTF-8');
$data['title'] = $info['module_description'][$this->config->get('config_language_id')]['title'];
$info = $this->model_extension_module->getModule(41);

$data['image'] = html_entity_decode($info['module_description'][$this->config->get('config_language_id')]['description'], ENT_QUOTES, 'UTF-8');


		$this->response->setOutput($this->load->view('common/home', $data));
	}
}
