<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ModelSellerSeller extends Model {

public function gatCart($data) {

}

	
    public function addseller($data) {
        $group_id = (int)$this->config->get('config_seller_group_id');
        $group = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_group WHERE seller_group_id = '" . $group_id . "'");
        if (!$group->num_rows) { throw new RuntimeException('Seller group is not configured.'); }
        $salt = bin2hex(random_bytes(4));
        $fields = array('seller_group_id' => $group_id, 'store_id' => (int)$this->config->get('config_store_id'),
            'language_id' => (int)$this->config->get('config_language_id'), 'firstname' => $data['firstname'],
            'lastname' => $data['lastname'], 'email' => $data['email'], 'telephone' => $data['telephone'],
            'fax' => '', 'custom_field' => '', 'salt' => $salt,
            'password' => sha1($salt . sha1($salt . sha1($data['password']))), 'newsletter' => 0,
            'ip' => $this->request->server['REMOTE_ADDR'], 'status' => 1, 'approved' => (int)!$group->row['approval'],
            'safe' => 0, 'token' => '', 'code' => '', 'image' => '', 'bonus' => 0);
        $values = array();
        foreach ($fields as $key => $value) { $values[] = "`" . $key . "` = '" . $this->db->escape((string)$value) . "'"; }
        $this->db->query("INSERT INTO " . DB_PREFIX . "seller SET " . implode(', ', $values) . ", date_added = NOW()");
        $seller_id = $this->db->getLastId();
        $this->saveProfileAddress($seller_id, $data);
        return $seller_id;
    }

    public function getProfileAddress($seller_id) {
        $query = $this->db->query("SELECT a.* FROM " . DB_PREFIX . "address a JOIN " . DB_PREFIX . "seller s ON s.address_id = a.address_id WHERE s.seller_id = '" . (int)$seller_id . "' AND a.seller_id = s.seller_id AND a.customer_id = 0");
        return $query->row;
    }

    public function saveProfileAddress($seller_id, $data) {
        $address = $this->getProfileAddress($seller_id);
        $values = array();
        foreach (array('firstname','lastname','address_1','city','country_id') as $key) {
            $values[] = "`" . $key . "` = '" . $this->db->escape((string)$data[$key]) . "'";
        }
        // Old zone values must not survive a country change.
        $values[] = "zone_id = " . ($address && (int)$address['country_id'] === (int)$data['country_id'] ? (int)$address['zone_id'] : 0);
        if ($address) {
            $this->db->query("UPDATE " . DB_PREFIX . "address SET " . implode(', ', $values) . " WHERE address_id = '" . (int)$address['address_id'] . "' AND seller_id = '" . (int)$seller_id . "' AND customer_id = 0");
        } else {
            $this->db->query("INSERT INTO " . DB_PREFIX . "address SET " . implode(', ', $values) . ", seller_id = '" . (int)$seller_id . "', customer_id = 0, company = '', address_2 = '', postcode = '', custom_field = ''");
            $address_id = $this->db->getLastId();
            $this->db->query("UPDATE " . DB_PREFIX . "seller SET address_id = '" . (int)$address_id . "' WHERE seller_id = '" . (int)$seller_id . "'");
        }
    }

	public function editseller($data) {
		$seller_id = $this->seller->getId();

		$this->db->query("UPDATE " . DB_PREFIX . "seller SET firstname = '" . $this->db->escape($data['firstname']) . "', lastname = '" . $this->db->escape($data['lastname']) . "', image= '" . $this->db->escape($data['avatar']) . "',  email = '" . $this->db->escape($data['email']) . "', telephone = '" . $this->db->escape($data['telephone']) . "',  custom_field = '" . $this->db->escape(isset($data['custom_field']) ? json_encode($data['custom_field']) : '') . "' WHERE seller_id = '" . (int)$seller_id . "'");
	}

	public function editPassword($email, $password) {
		$this->db->query("UPDATE " . DB_PREFIX . "seller SET salt = '" . $this->db->escape($salt = token(9)) . "', password = '" . $this->db->escape(sha1($salt . sha1($salt . sha1($password)))) . "', code = '' WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "'");
	}

	public function editCode($email, $code) {
		$this->db->query("UPDATE `" . DB_PREFIX . "seller` SET code = '" . $this->db->escape($code) . "' WHERE LCASE(email) = '" . $this->db->escape(utf8_strtolower($email)) . "'");
	}

	public function editNewsletter($newsletter) {
		$this->db->query("UPDATE " . DB_PREFIX . "seller SET newsletter = '" . (int)$newsletter . "' WHERE seller_id = '" . (int)$this->seller->getId() . "'");
	}

	public function getseller($seller_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row;
	}

	public function getsellerByEmail($email) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "'");

		return $query->row;
	}

	public function getsellerByCode($code) {
		$query = $this->db->query("SELECT seller_id, firstname, lastname, email FROM `" . DB_PREFIX . "seller` WHERE code = '" . $this->db->escape($code) . "' AND code != ''");

		return $query->row;
	}

	public function getsellerByToken($token) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE token = '" . $this->db->escape($token) . "' AND token != ''");

		$this->db->query("UPDATE " . DB_PREFIX . "seller SET token = ''");

		return $query->row;
	}

	public function getTotalsellersByEmail($email) {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "seller WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "'");

		return $query->row['total'];
	}

	public function getRewardTotal($seller_id) {
		$query = $this->db->query("SELECT SUM(points) AS total FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->row['total'];
	}

	public function getIps($seller_id) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "seller_ip` WHERE seller_id = '" . (int)$seller_id . "'");

		return $query->rows;
	}

	public function addLoginAttempt($email) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_login WHERE email = '" . $this->db->escape(utf8_strtolower((string)$email)) . "' AND ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "'");

		if (!$query->num_rows) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "seller_login SET email = '" . $this->db->escape(utf8_strtolower((string)$email)) . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "', total = 1, date_added = '" . $this->db->escape(date('Y-m-d H:i:s')) . "', date_modified = '" . $this->db->escape(date('Y-m-d H:i:s')) . "'");
		} else {
			$this->db->query("UPDATE " . DB_PREFIX . "seller_login SET total = (total + 1), date_modified = '" . $this->db->escape(date('Y-m-d H:i:s')) . "' WHERE seller_login_id = '" . (int)$query->row['seller_login_id'] . "'");
		}
	}

	public function getLoginAttempts($email) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "seller_login` WHERE email = '" . $this->db->escape(utf8_strtolower($email)) . "'");

		return $query->row;
	}

public function getBonusAll($userid) {
		$query = $this->db->query("SELECT SUM(summ) AS total  FROM `" . DB_PREFIX . "bonus` b LEFT JOIN `" . DB_PREFIX . "order` o ON (o.order_id=b.order_id) where o.order_status_id IN (1, 2) AND user_id = '" . $userid . "'");
$bonus = $query->row['total'];

		return $bonus ;
	}

	public function getBonustotal($userid) {
		$query = $this->db->query("SELECT SUM(summ) AS total  FROM `" . DB_PREFIX . "bonus` b LEFT JOIN `" . DB_PREFIX . "order` o ON (o.order_id=b.order_id) where o.order_status_id IN (1, 2) AND user_id = '" . $userid . "'");
$bonus = $query->row['total'];
$query = $this->db->query("SELECT SUM(summ) AS totalv FROM `" . DB_PREFIX . "vyvod` WHERE user_id = '" . $userid . "'");
$vyvod = $query->row['totalv'];

		return $bonus - $vyvod;
	}

 	public function getVyvodtotal($userid) {
		
$query = $this->db->query("SELECT SUM(summ) AS totalv FROM `" . DB_PREFIX . "vyvod` WHERE user_id = '" . $userid . "'");
$vyvod = $query->row['totalv'];

		return  $vyvod;
	}

	public function deleteLoginAttempts($email) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_login` WHERE email = '" . $this->db->escape(utf8_strtolower($email)) . "'");
	}
}
