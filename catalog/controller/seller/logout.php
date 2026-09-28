<?php
class ControllerSellerLogout extends Controller {
    public function index() {
        $this->seller->logout();
        unset($this->session->data['token'], $this->session->data['seller_form_token']);
        $this->response->redirect($this->url->link('seller/login', '', true));
    }
}
