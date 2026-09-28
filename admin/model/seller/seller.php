<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class Modelsellerseller extends Model {


public function getVyvods($data = array()) {

$query = $this->db->query("SELECT DISTINCT *, vt.status as status FROM `" . DB_PREFIX . "vyvod` vt LEFT JOIN " . DB_PREFIX . "seller cust ON (vt.user_id = cust.seller_id)  WHERE vt.user_id >0  ORDER BY vt.id DESC ");

		return $query->rows;

}

	public function addseller($data) {
		$this->db->query("INSERT INTO " . DB_PREFIX . "seller SET seller_group_id = '1', firstname = '" . $this->db->escape($data['firstname']) . "', lastname = '" . $this->db->escape($data['lastname']) . "', email = '" . $this->db->escape($data['email']) . "', telephone = '" . $this->db->escape($data['telephone']) . "', fax = '" . $this->db->escape($data['fax']) . "', custom_field = '" . $this->db->escape(isset($data['custom_field']) ? json_encode($data['custom_field']) : '') . "', newsletter = '" . (int)$data['newsletter'] . "', salt = '" . $this->db->escape($salt = token(9)) . "', password = '" . $this->db->escape(sha1($salt . sha1($salt . sha1($data['password'])))) . "', status = '" . (int)$data['status'] . "', approved = '" . (int)$data['approved'] . "', safe = '" . (int)$data['safe'] . "', date_added = NOW()");

		$seller_id = $this->db->getLastId();

$this->cache->delete('seo_pro');
		$this->cache->delete('seo_url');
		
		if (isset($data['keyword'])) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'manufacturer_id=" . (int)$seller_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}

		if (isset($data['address'])) {
			foreach ($data['address'] as $address) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "address SET seller_id = '" . (int)$seller_id . "', firstname = '" . $this->db->escape($address['firstname']) . "', lastname = '" . $this->db->escape($address['lastname']) . "', company = '" . $this->db->escape($address['company']) . "', address_1 = '" . $this->db->escape($address['address_1']) . "', address_2 = '" . $this->db->escape($address['address_2']) . "', city = '" . $this->db->escape($address['city']) . "', postcode = '" . $this->db->escape($address['postcode']) . "', country_id = '" . (int)$address['country_id'] . "', zone_id = '" . (int)$address['zone_id'] . "', custom_field = '" . $this->db->escape(isset($address['custom_field']) ? json_encode($address['custom_field']) : '') . "'");

				if (isset($address['default'])) {
					$address_id = $this->db->getLastId();

					$this->db->query("UPDATE " . DB_PREFIX . "seller SET address_id = '" . (int)$address_id . "' WHERE seller_id = '" . (int)$seller_id . "'");
				}
			}
		}
		
		return $seller_id;
	}

	public function editseller($seller_id, $data) {
		if (!isset($data['custom_field'])) {
			$data['custom_field'] = array();
		}

		$this->db->query("UPDATE " . DB_PREFIX . "seller SET seller_group_id = '" . (int)$data['seller_group_id'] . "', firstname = '" . $this->db->escape($data['firstname']) . "', lastname = '" . $this->db->escape($data['lastname']) . "', email = '" . $this->db->escape($data['email']) . "', telephone = '" . $this->db->escape($data['telephone']) . "', fax = '" . $this->db->escape($data['fax']) . "', custom_field = '" . $this->db->escape(isset($data['custom_field']) ? json_encode($data['custom_field']) : '') . "', newsletter = '" . (int)$data['newsletter'] . "', status = '" . (int)$data['status'] . "', approved = '" . (int)$data['approved'] . "', safe = '" . (int)$data['safe'] . "' WHERE seller_id = '" . (int)$seller_id . "'");

		if ($data['password']) {
			$this->db->query("UPDATE " . DB_PREFIX . "seller SET salt = '" . $this->db->escape($salt = token(9)) . "', password = '" . $this->db->escape(sha1($salt . sha1($salt . sha1($data['password'])))) . "' WHERE seller_id = '" . (int)$seller_id . "'");
		}


	$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'manufacturer_id=" . (int)$seller_id . "'");
		
		$this->cache->delete('seo_pro');
		$this->cache->delete('seo_url');

		if ($data['keyword']) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "url_alias SET query = 'manufacturer_id=" . (int)$seller_id . "', keyword = '" . $this->db->escape($data['keyword']) . "'");
		}
$this->cache->delete('manufacturer');

		//$this->db->query("DELETE FROM " . DB_PREFIX . "address WHERE seller_id = '" . (int)$seller_id . "'");

		if (isset($data['address'])) {
			foreach ($data['address'] as $address) {
				if (!isset($address['custom_field'])) {
					$address['custom_field'] = array();
				}

				$this->db->query("INSERT INTO " . DB_PREFIX . "address SET address_id = '" . (int)$address['address_id'] . "', seller_id = '" . (int)$seller_id . "', firstname = '" . $this->db->escape($address['firstname']) . "', lastname = '" . $this->db->escape($address['lastname']) . "', company = '" . $this->db->escape($address['company']) . "', address_1 = '" . $this->db->escape($address['address_1']) . "', address_2 = '" . $this->db->escape($address['address_2']) . "', city = '" . $this->db->escape($address['city']) . "', postcode = '" . $this->db->escape($address['postcode']) . "', country_id = '" . (int)$address['country_id'] . "', zone_id = '" . (int)$address['zone_id'] . "', custom_field = '" . $this->db->escape(isset($address['custom_field']) ? json_encode($address['custom_field']) : '') . "'");

				if (isset($address['default'])) {
					$address_id = $this->db->getLastId();

					$this->db->query("UPDATE " . DB_PREFIX . "seller SET address_id = '" . (int)$address_id . "' WHERE seller_id = '" . (int)$seller_id . "'");
				}
			}
		}
	}

	public function editToken($seller_id, $token) {
		$this->db->query("UPDATE " . DB_PREFIX . "seller SET token = '" . $this->db->escape($token) . "' WHERE seller_id = '" . (int)$seller_id . "'");
	}

	public function deleteseller($seller_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_activity WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_transaction WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_ip WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "address WHERE seller_id = '" . (int)$seller_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "url_alias WHERE query = 'manufacturer_id=" . (int)$seller_id . "'");
	}

	public function getseller($seller_id) {
		$query = $this->db->query("SELECT DISTINCT *,(SELECT keyword FROM " . DB_PREFIX . "url_alias WHERE query = 'manufacturer_id=" . (int)$seller_id . "') AS keyword FROM " . DB_PREFIX . "seller WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row;
	}

	public function getsellerByEmail($email) {
		$query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "seller WHERE LCASE(email) = '" . $this->db->escape(utf8_strtolower($email)) . "'");

		return $query->row;
	}

	public function getsellers($data = array()) {
		$sql = "SELECT *, CONCAT(c.firstname) AS name, cgd.name AS seller_group FROM " . DB_PREFIX . "seller c LEFT JOIN " . DB_PREFIX . "seller_group_description cgd ON (c.seller_group_id = cgd.seller_group_id) WHERE cgd.language_id = '" . (int)$this->config->get('config_language_id') . "'";

		$implode = array();

		if (!empty($data['filter_name'])) {
			$implode[] = "CONCAT(c.firstname, ' ', c.lastname) LIKE '%" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (!empty($data['filter_email'])) {
			$implode[] = "c.email LIKE '" . $this->db->escape($data['filter_email']) . "%'";
		}

		if (isset($data['filter_newsletter']) && !is_null($data['filter_newsletter'])) {
			$implode[] = "c.newsletter = '" . (int)$data['filter_newsletter'] . "'";
		}

		if (!empty($data['filter_seller_group_id'])) {
			$implode[] = "c.seller_group_id = '" . (int)$data['filter_seller_group_id'] . "'";
		}

		if (!empty($data['filter_ip'])) {
			$implode[] = "c.seller_id IN (SELECT seller_id FROM " . DB_PREFIX . "seller_ip WHERE ip = '" . $this->db->escape($data['filter_ip']) . "')";
		}

		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$implode[] = "c.status = '" . (int)$data['filter_status'] . "'";
		}

		if (isset($data['filter_approved']) && !is_null($data['filter_approved'])) {
			$implode[] = "c.approved = '" . (int)$data['filter_approved'] . "'";
		}

		if (!empty($data['filter_date_added'])) {
			$implode[] = "DATE(c.date_added) = DATE('" . $this->db->escape($data['filter_date_added']) . "')";
		}

		if ($implode) {
			$sql .= " AND " . implode(" AND ", $implode);
		}

		$sort_data = array(
			'name',
			'c.email',
			'seller_group',
			'c.status',
			'c.approved',
			'c.ip',
			'c.date_added'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY name";
		}

		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}

		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}

			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}

		$query = $this->db->query($sql);

		return $query->rows;
	}

public function approvevyvod($id) {
$this->db->query("UPDATE " . DB_PREFIX . "vyvod SET status = '1' WHERE id = '" . (int)$id . "'");
}


	public function approve($seller_id) {
		$seller_info = $this->getseller($seller_id);

		if ($seller_info) {
			$this->db->query("UPDATE " . DB_PREFIX . "seller SET approved = '1' WHERE seller_id = '" . (int)$seller_id . "'");

			$this->load->model('setting/store');

			$store_info = $this->model_setting_store->getStore($seller_info['store_id']);

			if ($store_info) {
				$store_name = $store_info['name'];
				$store_url = $store_info['url'] . 'index.php?route=account/login';
			} else {
				$store_name = $this->config->get('config_name');
				$store_url = HTTP_CATALOG . 'index.php?route=account/login';
			}

			$this->load->model('localisation/language');
			
			$language_info = $this->model_localisation_language->getLanguage($seller_info['language_id']);

			if ($language_info) {
				$language_code = $language_info['code'];
			} else {
				$language_code = $this->config->get('config_language');
			}

			$language = new Language($language_code);
			$language->load($language_code);
			$language->load('mail/seller');
				
			$message  = sprintf($language->get('text_approve_welcome'), html_entity_decode($store_name, ENT_QUOTES, 'UTF-8')) . "\n\n";
			$message .= $language->get('text_approve_login') . "\n";
			$message .= $store_url . "\n\n";
			$message .= $language->get('text_approve_services') . "\n\n";
			$message .= $language->get('text_approve_thanks') . "\n";
			$message .= html_entity_decode($store_name, ENT_QUOTES, 'UTF-8');

			$mail = new Mail();
			$mail->protocol = $this->config->get('config_mail_protocol');
			$mail->parameter = $this->config->get('config_mail_parameter');
			$mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
			$mail->smtp_username = $this->config->get('config_mail_smtp_username');
			$mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
			$mail->smtp_port = $this->config->get('config_mail_smtp_port');
			$mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');

			$mail->setTo($seller_info['email']);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender(html_entity_decode($store_name, ENT_QUOTES, 'UTF-8'));
			$mail->setSubject(sprintf($language->get('text_approve_subject'), html_entity_decode($store_name, ENT_QUOTES, 'UTF-8')));
			$mail->setText($message);
			$mail->send();
		}
	}

	public function getAddress($address_id) {
		$address_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "address WHERE address_id = '" . (int)$address_id . "'");

		if ($address_query->num_rows) {
			$country_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "country` WHERE country_id = '" . (int)$address_query->row['country_id'] . "'");

			if ($country_query->num_rows) {
				$country = $country_query->row['name'];
				$iso_code_2 = $country_query->row['iso_code_2'];
				$iso_code_3 = $country_query->row['iso_code_3'];
				$address_format = $country_query->row['address_format'];
			} else {
				$country = '';
				$iso_code_2 = '';
				$iso_code_3 = '';
				$address_format = '';
			}

			$zone_query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "zone` WHERE zone_id = '" . (int)$address_query->row['zone_id'] . "'");

			if ($zone_query->num_rows) {
				$zone = $zone_query->row['name'];
				$zone_code = $zone_query->row['code'];
			} else {
				$zone = '';
				$zone_code = '';
			}

			return array(
				'address_id'     => $address_query->row['address_id'],
				'seller_id'    => $address_query->row['seller_id'],
				'firstname'      => $address_query->row['firstname'],
				'lastname'       => $address_query->row['lastname'],
				'company'        => $address_query->row['company'],
				'address_1'      => $address_query->row['address_1'],
				'address_2'      => $address_query->row['address_2'],
				'postcode'       => $address_query->row['postcode'],
				'city'           => $address_query->row['city'],
				'zone_id'        => $address_query->row['zone_id'],
				'zone'           => $zone,
				'zone_code'      => $zone_code,
				'country_id'     => $address_query->row['country_id'],
				'country'        => $country,
				'iso_code_2'     => $iso_code_2,
				'iso_code_3'     => $iso_code_3,
				'address_format' => $address_format,
				'custom_field'   => json_decode($address_query->row['custom_field'], true)
			);
		}
	}

	public function getAddresses($seller_id) {
		$address_data = array();

		$query = $this->db->query("SELECT address_id FROM " . DB_PREFIX . "address WHERE seller_id = '" . (int)$seller_id . "'");

		foreach ($query->rows as $result) {
			$address_info = $this->getAddress($result['address_id']);

			if ($address_info) {
				$address_data[$result['address_id']] = $address_info;
			}
		}

		return $address_data;
	}

	public function getTotalsellers($data = array()) {
		$sql = "SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller";

		$implode = array();

		if (!empty($data['filter_name'])) {
			$implode[] = "CONCAT(firstname, ' ', lastname) LIKE '%" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (!empty($data['filter_email'])) {
			$implode[] = "email LIKE '" . $this->db->escape($data['filter_email']) . "%'";
		}

		if (isset($data['filter_newsletter']) && !is_null($data['filter_newsletter'])) {
			$implode[] = "newsletter = '" . (int)$data['filter_newsletter'] . "'";
		}

		if (!empty($data['filter_seller_group_id'])) {
			$implode[] = "seller_group_id = '" . (int)$data['filter_seller_group_id'] . "'";
		}

		if (!empty($data['filter_ip'])) {
			$implode[] = "seller_id IN (SELECT seller_id FROM " . DB_PREFIX . "seller_ip WHERE ip = '" . $this->db->escape($data['filter_ip']) . "')";
		}

		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$implode[] = "status = '" . (int)$data['filter_status'] . "'";
		}

		if (isset($data['filter_approved']) && !is_null($data['filter_approved'])) {
			$implode[] = "approved = '" . (int)$data['filter_approved'] . "'";
		}

		if (!empty($data['filter_date_added'])) {
			$implode[] = "DATE(date_added) = DATE('" . $this->db->escape($data['filter_date_added']) . "')";
		}

		if ($implode) {
			$sql .= " WHERE " . implode(" AND ", $implode);
		}

		$query = $this->db->query($sql);

		return $query->row['total'];
	}

	public function getTotalsellersAwaitingApproval() {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller WHERE status = '0' OR approved = '0'");

		return $query->row['total'];
	}

	public function getTotalAddressesBysellerId($seller_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "address WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getTotalAddressesByCountryId($country_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "address WHERE country_id = '" . (int)$country_id . "'");

		return $query->row['total'];
	}

	public function getTotalAddressesByZoneId($zone_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "address WHERE zone_id = '" . (int)$zone_id . "'");

		return $query->row['total'];
	}

	public function getTotalsellersBysellerGroupId($seller_group_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller WHERE seller_group_id = '" . (int)$seller_group_id . "'");

		return $query->row['total'];
	}

	public function addHistory($seller_id, $comment) {
		$this->db->query("INSERT INTO " . DB_PREFIX . "seller_history SET seller_id = '" . (int)$seller_id . "', comment = '" . $this->db->escape(strip_tags($comment)) . "', date_added = NOW()");
	}

	public function getHistories($seller_id, $start = 0, $limit = 10) {
		if ($start < 0) {
			$start = 0;
		}

		if ($limit < 1) {
			$limit = 10;
		}

		$query = $this->db->query("SELECT comment, date_added FROM " . DB_PREFIX . "seller_history WHERE seller_id = '" . (int)$seller_id . "' ORDER BY date_added DESC LIMIT " . (int)$start . "," . (int)$limit);

		return $query->rows;
	}

	public function getTotalHistories($seller_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_history WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function addTransaction($seller_id, $description = '', $amount = '', $order_id = 0) {
		$seller_info = $this->getseller($seller_id);

		if ($seller_info) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "seller_transaction SET seller_id = '" . (int)$seller_id . "', order_id = '" . (int)$order_id . "', description = '" . $this->db->escape($description) . "', amount = '" . (float)$amount . "', date_added = NOW()");

			$this->load->language('mail/seller');

			$this->load->model('setting/store');

			$store_info = $this->model_setting_store->getStore($seller_info['store_id']);

			if ($store_info) {
				$store_name = $store_info['name'];
			} else {
				$store_name = $this->config->get('config_name');
			}

			$message  = sprintf($this->language->get('text_transaction_received'), $this->currency->format($amount, $this->config->get('config_currency'))) . "\n\n";
			$message .= sprintf($this->language->get('text_transaction_total'), $this->currency->format($this->getTransactionTotal($seller_id), $this->session->data['currency']));

			$mail = new Mail();
			$mail->protocol = $this->config->get('config_mail_protocol');
			$mail->parameter = $this->config->get('config_mail_parameter');
			$mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
			$mail->smtp_username = $this->config->get('config_mail_smtp_username');
			$mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
			$mail->smtp_port = $this->config->get('config_mail_smtp_port');
			$mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');

			$mail->setTo($seller_info['email']);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender(html_entity_decode($store_name, ENT_QUOTES, 'UTF-8'));
			$mail->setSubject(sprintf($this->language->get('text_transaction_subject'), html_entity_decode($this->config->get('config_name'), ENT_QUOTES, 'UTF-8')));
			$mail->setText($message);
			$mail->send();
		}
	}

	public function deleteTransaction($order_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_transaction WHERE order_id = '" . (int)$order_id . "'");
	}

	public function getTransactions($seller_id, $start = 0, $limit = 10) {
		if ($start < 0) {
			$start = 0;
		}

		if ($limit < 1) {
			$limit = 10;
		}

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_transaction WHERE seller_id = '" . (int)$seller_id . "' ORDER BY date_added DESC LIMIT " . (int)$start . "," . (int)$limit);

		return $query->rows;
	}

	public function getTotalTransactions($seller_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total  FROM " . DB_PREFIX . "seller_transaction WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getTransactionTotal($seller_id) {
		$query = $this->db->query("SELECT SUM(amount) AS total FROM " . DB_PREFIX . "seller_transaction WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getTotalTransactionsByOrderId($order_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_transaction WHERE order_id = '" . (int)$order_id . "'");

		return $query->row['total'];
	}

	public function addReward($seller_id, $description = '', $points = '', $order_id = 0) {
		$seller_info = $this->getseller($seller_id);

		if ($seller_info) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "seller_reward SET seller_id = '" . (int)$seller_id . "', order_id = '" . (int)$order_id . "', points = '" . (int)$points . "', description = '" . $this->db->escape($description) . "', date_added = NOW()");

			$this->load->language('mail/seller');

			$this->load->model('setting/store');

			$store_info = $this->model_setting_store->getStore($seller_info['store_id']);

			if ($store_info) {
				$store_name = $store_info['name'];
			} else {
				$store_name = $this->config->get('config_name');
			}

			$message  = sprintf($this->language->get('text_reward_received'), $points) . "\n\n";
			$message .= sprintf($this->language->get('text_reward_total'), $this->getRewardTotal($seller_id));

			$mail = new Mail();
			$mail->protocol = $this->config->get('config_mail_protocol');
			$mail->parameter = $this->config->get('config_mail_parameter');
			$mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
			$mail->smtp_username = $this->config->get('config_mail_smtp_username');
			$mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
			$mail->smtp_port = $this->config->get('config_mail_smtp_port');
			$mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');

			$mail->setTo($seller_info['email']);
			$mail->setFrom($this->config->get('config_email'));
			$mail->setSender(html_entity_decode($store_name, ENT_QUOTES, 'UTF-8'));
			$mail->setSubject(sprintf($this->language->get('text_reward_subject'), html_entity_decode($store_name, ENT_QUOTES, 'UTF-8')));
			$mail->setText($message);
			$mail->send();
		}
	}

	public function deleteReward($order_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_reward WHERE order_id = '" . (int)$order_id . "' AND points > 0");
	}

	public function getRewards($seller_id, $start = 0, $limit = 10) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$seller_id . "' ORDER BY date_added DESC LIMIT " . (int)$start . "," . (int)$limit);

		return $query->rows;
	}

	public function getTotalRewards($seller_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getRewardTotal($seller_id) {
		$query = $this->db->query("SELECT SUM(points) AS total FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getTotalsellerRewardsByOrderId($order_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_reward WHERE order_id = '" . (int)$order_id . "' AND points > 0");

		return $query->row['total'];
	}

	public function getIps($seller_id, $start = 0, $limit = 10) {
		if ($start < 0) {
			$start = 0;
		}
		if ($limit < 1) {
			$limit = 10;
		}

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_ip WHERE seller_id = '" . (int)$seller_id . "' ORDER BY date_added DESC LIMIT " . (int)$start . "," . (int)$limit);
		
		return $query->rows;
	}

	public function getTotalIps($seller_id) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_ip WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getTotalsellersByIp($ip) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller_ip WHERE ip = '" . $this->db->escape($ip) . "'");

		return $query->row['total'];
	}

	public function getTotalLoginAttempts($email) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "seller_login` WHERE `email` = '" . $this->db->escape($email) . "'");

		return $query->row;
	}

	public function deleteLoginAttempts($email) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_login` WHERE `email` = '" . $this->db->escape($email) . "'");
	}
}
