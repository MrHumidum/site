<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerCommonCron extends Controller {
	public function index() {
		$this->document->setTitle($this->config->get('config_meta_title'));
		$this->document->setDescription($this->config->get('config_meta_description'));
		$this->document->setKeywords($this->config->get('config_meta_keyword'));
$this->document->addScript('js/main/script.js');

		if (isset($this->request->get['route'])) {
			$this->document->addLink($this->config->get('config_url'), 'canonical');
		}

 

$this->load->model('account/order');

$orders= $this->model_account_order->getOrdersNull($this->request->get['mycart']);
 
foreach ($orders as $order) {
	echo $order['email'].'<br>';
$orderid = $order['order_id'];
$mail = new Mail();
			$mail->protocol = $this->config->get('config_mail_protocol');
			$mail->parameter = $this->config->get('config_mail_parameter');
			$mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
			$mail->smtp_username = $this->config->get('config_mail_smtp_username');
			$mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
			$mail->smtp_port = $this->config->get('config_mail_smtp_port');
			$mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');
$cupon = $this->model_account_order->getRandomString(5);
$this->model_account_order->addCouponV($cupon);
$mess = 'У вас остался незавершенный заказ на сайте prokonkurs.com. Для завершения покупки перейдите по ссылке и получите скидку
<a href="'.HTTPS_CATALOG.'?mycart='.$orderid.'&cupon='.$cupon.'">перейти к заказу</a>';

echo $orderid;
$this->model_account_order->updateOrder($orderid);

$mail->setTo($order['email']);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender(html_entity_decode('prokonkurs.com', ENT_QUOTES, 'UTF-8'));
			$mail->setSubject(html_entity_decode(sprintf('Завершите покупку', $order['firstname']), ENT_QUOTES, 'UTF-8'));
			$mail->setHtml($mess);
			$mail->setText('');
			$mail->send();

			}

	 
 
	}
}
