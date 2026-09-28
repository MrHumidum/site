<?php
class ControllerSellerOrder extends Controller {
    public function index() {
        if (!$this->seller->isLogged()) { $this->response->redirect($this->url->link('seller/login', '', true)); return; }
        $where = "b.user_id = '" . (int)$this->seller->getId() . "' AND o.store_id = '" . (int)$this->config->get('config_store_id') . "' AND o.order_status_id > 0";
        if (isset($this->request->get['order_id'])) { $where .= " AND o.order_id = '" . (int)$this->request->get['order_id'] . "'"; }
        $page = max(1, (int)($this->request->get['page'] ?? 1));
        $query = $this->db->query("SELECT o.order_id, o.date_added, o.order_status_id, o.currency_code, o.currency_value, b.prname, b.costtotal, b.summ, os.name AS status FROM " . DB_PREFIX . "bonus b JOIN `" . DB_PREFIX . "order` o ON o.order_id = b.order_id LEFT JOIN " . DB_PREFIX . "order_status os ON os.order_status_id = o.order_status_id AND os.language_id = '" . (int)$this->config->get('config_language_id') . "' WHERE " . $where . " ORDER BY o.order_id DESC LIMIT " . (($page-1)*20) . ",21");
        $data['next'] = count($query->rows) > 20 ? $this->url->link('seller/order', 'page=' . ($page+1), true) : '';
        $data['previous'] = $page > 1 ? $this->url->link('seller/order', 'page=' . ($page-1), true) : '';
        $data['orders'] = array();
        foreach (array_slice($query->rows,0,20) as $row) {
            $row['amount'] = $this->currency->format($row['costtotal'], $row['currency_code'], $row['currency_value']);
            $row['earned'] = in_array((int)$row['order_status_id'], array(1,2), true) ? $this->currency->format($row['summ'], $row['currency_code'], $row['currency_value']) : '—';
            $data['orders'][] = $row;
        }
        $this->document->setTitle('Заказы и статистика — haramain.online');
        $data['acc'] = $this->load->controller('extension/module/seller');
        $data['header'] = $this->load->controller('common/header');
        $data['footer'] = $this->load->controller('common/footer');
        $this->response->setOutput($this->load->view('seller/orders', $data));
    }
    public function info() { $this->index(); }
}
