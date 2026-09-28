<?php
class ControllerSellerAddress extends Controller {
    public function index() {
        if (!$this->seller->isLogged()) { $this->response->redirect($this->url->link('seller/login', '', true)); return; }
        $this->response->setOutput($this->load->controller('seller/profile', false));
    }
}
