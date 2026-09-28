<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerExtensionModuleSeller extends Controller {
	public function index() {
		$this->load->language('extension/module/account');
	if (!$this->seller->isLogged()) {
			$this->response->redirect($this->url->link('seller/login', '', true));
		}
		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_register'] = $this->language->get('text_register');
		$data['text_login'] = $this->language->get('text_login');
		$data['text_logout'] = $this->language->get('text_logout');
		$data['text_forgotten'] = $this->language->get('text_forgotten');
		$data['text_account'] = $this->language->get('text_account');
		$data['text_edit'] = $this->language->get('text_edit');
		$data['text_password'] = $this->language->get('text_password');
		$data['text_address'] = $this->language->get('text_address');
		$data['text_wishlist'] = $this->language->get('text_wishlist');
		$data['text_order'] = $this->language->get('text_order');
		$data['text_download'] = $this->language->get('text_download');
		$data['text_reward'] = $this->language->get('text_reward');
		$data['text_return'] = $this->language->get('text_return');
		$data['text_transaction'] = $this->language->get('text_transaction');
		$data['text_newsletter'] = $this->language->get('text_newsletter');
		$data['text_recurring'] = $this->language->get('text_recurring');

		$data['logged'] = $this->seller->isLogged();
		$data['register'] = $this->url->link('seller/register', '', true);
		$data['login'] = $this->url->link('seller/login', '', true);
		$data['logout'] = $this->url->link('seller/logout', '', true);
		$data['forgotten'] = $this->url->link('seller/forgotten', '', true);
		$data['account'] = $this->url->link('seller/account', '', true);
		$data['edit'] = $this->url->link('seller/edit', '', true);
		$data['password'] = $this->url->link('seller/password', '', true);
		$data['address'] = $this->url->link('seller/address', '', true);
		$data['wishlist'] = $this->url->link('seller/wishlist');
		$data['order'] = $this->url->link('seller/order', '', true);
		$data['download'] = $this->url->link('seller/download', '', true);
		$data['reward'] = $this->url->link('seller/reward', '', true);
		$data['return'] = $this->url->link('seller/return', '', true);
		$data['transaction'] = $this->url->link('seller/transaction', '', true);
		$data['newsletter'] = $this->url->link('seller/newsletter', '', true);
		$data['recurring'] = $this->url->link('seller/recurring', '', true);
$this->load->model('seller/seller');
$seller_info = $this->model_seller_seller->getseller($this->seller->getId());
$data['firstname'] = $seller_info['firstname'];
$data['bonustotal'] = $this->currency->format((float)$this->model_seller_seller->getBonustotal($this->seller->getId()), $this->session->data['currency']);
$data['bonusall'] = $this->currency->format((float)$this->model_seller_seller->getBonusAll($this->seller->getId()), $this->session->data['currency']);
		return $this->load->view('extension/module/seller', $data);
	}
}