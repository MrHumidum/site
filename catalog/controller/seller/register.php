<?php
class ControllerSellerRegister extends Controller {
    public function index() {
        if ($this->seller->isLogged()) { $this->response->redirect($this->url->link('seller/account', '', true)); return; }
        $this->response->setOutput($this->load->controller('seller/profile', true));
    }
}
