<?php
class ControllerSellerProfile extends Controller {
    public function index($register = false) {
        if (!$register && !$this->seller->isLogged()) { $this->response->redirect($this->url->link('seller/login', '', true)); return ''; }
        $this->load->model('seller/seller');
        $this->load->model('marketplace/location');
        $this->load->model('localisation/country');
        if (empty($this->session->data['seller_form_token'])) { $this->session->data['seller_form_token'] = bin2hex(random_bytes(32)); }
        $seller_id = (int)$this->seller->getId();
        $seller = $register ? array() : $this->model_seller_seller->getseller($seller_id);
        $address = $register ? array() : $this->model_seller_seller->getProfileAddress($seller_id);
        $values = array_merge(array('firstname'=>'','lastname'=>'','email'=>'','telephone'=>'','address_1'=>'','city'=>'Мекка','country_id'=>$this->model_marketplace_location->getCountryId()), $seller, $address);
        $error = '';
        if (($this->request->server['REQUEST_METHOD'] ?? '') === 'POST') {
            foreach (array('firstname','lastname','email','telephone','address_1','city','country_id') as $key) {
                $values[$key] = isset($this->request->post[$key]) && is_scalar($this->request->post[$key]) ? trim((string)$this->request->post[$key]) : '';
            }
            $token = $this->request->post['form_token'] ?? '';
            $password = $this->request->post['password'] ?? '';
            if (!is_string($token) || !hash_equals($this->session->data['seller_form_token'], $token)) { $error = 'Обновите страницу и повторите действие.'; }
            elseif (utf8_strlen($values['firstname']) < 1 || utf8_strlen($values['firstname']) > 32 || utf8_strlen($values['lastname']) < 1 || utf8_strlen($values['lastname']) > 32) { $error = 'Укажите имя и фамилию (до 32 символов).'; }
            elseif (!filter_var($values['email'], FILTER_VALIDATE_EMAIL) || strlen($values['email']) > 96) { $error = 'Укажите корректный e-mail.'; }
            elseif (utf8_strlen($values['telephone']) < 3 || utf8_strlen($values['telephone']) > 32) { $error = 'Укажите телефон.'; }
            elseif (utf8_strlen($values['address_1']) < 3 || utf8_strlen($values['address_1']) > 128 || !in_array($values['city'], array('Мекка','Медина'), true) || !$this->model_localisation_country->getCountry((int)$values['country_id'])) { $error = 'Укажите страну, город и адрес (от 3 до 128 символов).'; }
            elseif ($register && (!is_string($password) || strlen($password) < 8 || strlen($password) > 72 || $password !== ($this->request->post['confirm'] ?? ''))) { $error = 'Пароли должны совпадать и содержать от 8 до 72 символов.'; }
            $duplicate = $this->model_seller_seller->getsellerByEmail($values['email']);
            if (!$error && $duplicate && ($register || (int)$duplicate['seller_id'] !== $seller_id)) { $error = 'Этот e-mail уже зарегистрирован.'; }
            if (!$error) {
                if ($register) {
                    $values['password'] = $password;
                    $seller_id = $this->model_seller_seller->addseller($values);
                    if ($this->seller->login($values['email'], $password)) {
                        $this->session->data['token'] = bin2hex(random_bytes(32));
                        $this->response->redirect($this->url->link('seller/account', '', true)); return '';
                    }
                    $this->session->data['success'] = 'Регистрация завершена. Дождитесь одобрения администратора.';
                    $this->response->redirect($this->url->link('seller/login', '', true)); return '';
                }
                $values['avatar'] = $seller['image'];
                $values['custom_field'] = json_decode($seller['custom_field'], true) ?: array();
                $this->model_seller_seller->editseller($values);
                $this->model_seller_seller->saveProfileAddress($seller_id, $values);
                $this->session->data['success'] = 'Данные сохранены.';
                $this->response->redirect($this->url->link('seller/account', '', true)); return '';
            }
        }
        $data = array('values'=>$values,'error'=>$error,'register'=>$register,'form_token'=>$this->session->data['seller_form_token'], 'countries'=>$this->model_localisation_country->getCountries());
        $data['title'] = $register ? 'Регистрация продавца' : 'Данные продавца';
        $data['action'] = $this->url->link($register ? 'seller/register' : 'seller/edit', '', true);
        $data['login'] = $this->url->link('seller/login', '', true);
        $this->document->setTitle($data['title'] . ' — haramain.online');
        $data['header'] = $this->load->controller('common/header');
        $data['footer'] = $this->load->controller('common/footer');
        return $this->load->view('seller/profile', $data);
    }
}
