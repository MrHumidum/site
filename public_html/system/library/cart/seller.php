<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

namespace Cart;
class seller {
	private $seller_id;
	private $firstname;
	private $lastname;
	private $seller_group_id;
	private $email;
	private $telephone;
	private $fax;
	private $newsletter;
	private $address_id;

	public function __construct($registry) {
		$this->config = $registry->get('config');
		$this->db = $registry->get('db');
		$this->request = $registry->get('request');
		$this->session = $registry->get('session');

		if (isset($this->session->data['seller_id'])) {
			$seller_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE seller_id = '" . (int)$this->session->data['seller_id'] . "' AND status = '1'");

			if ($seller_query->num_rows) {
				$this->seller_id = $seller_query->row['seller_id'];
				$this->firstname = $seller_query->row['firstname'];
				$this->lastname = $seller_query->row['lastname'];
				$this->seller_group_id = $seller_query->row['seller_group_id'];
				$this->email = $seller_query->row['email'];
				$this->telephone = $seller_query->row['telephone'];
				$this->fax = $seller_query->row['fax'];
				$this->newsletter = $seller_query->row['newsletter'];
				$this->address_id = $seller_query->row['address_id'];

				$this->db->query("UPDATE " . DB_PREFIX . "seller SET language_id = '" . (int)$this->config->get('config_language_id') . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "' WHERE seller_id = '" . (int)$this->seller_id . "'");

				$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_ip WHERE seller_id = '" . (int)$this->session->data['seller_id'] . "' AND ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "'");

				if (!$query->num_rows) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_ip SET seller_id = '" . (int)$this->session->data['seller_id'] . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "', date_added = NOW()");
				}
			} else {
				$this->logout();
			}
		}
	}

	public function login($email, $password, $override = false) {
		if ($override) {
			$seller_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "' AND status = '1'");
		} else {
			$seller_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "' AND (password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, SHA1('" . $this->db->escape($password) . "'))))) OR password = '" . $this->db->escape(md5($password)) . "') AND status = '1' AND approved = '1'");
		}

		if ($seller_query->num_rows) {
			$this->session->data['seller_id'] = $seller_query->row['seller_id'];

			$this->seller_id = $seller_query->row['seller_id'];
			$this->firstname = $seller_query->row['firstname'];
			$this->lastname = $seller_query->row['lastname'];
			$this->seller_group_id = $seller_query->row['seller_group_id'];
			$this->email = $seller_query->row['email'];
			$this->telephone = $seller_query->row['telephone'];
			$this->fax = $seller_query->row['fax'];
			$this->newsletter = $seller_query->row['newsletter'];
			$this->address_id = $seller_query->row['address_id'];

			$this->db->query("UPDATE " . DB_PREFIX . "seller SET language_id = '" . (int)$this->config->get('config_language_id') . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "' WHERE seller_id = '" . (int)$this->seller_id . "'");

			return true;
		} else {
			return false;
		}
	}

	public function logout() {
		unset($this->session->data['seller_id']);

		$this->seller_id = '';
		$this->firstname = '';
		$this->lastname = '';
		$this->seller_group_id = '';
		$this->email = '';
		$this->telephone = '';
		$this->fax = '';
		$this->newsletter = '';
		$this->address_id = '';
	}

	public function isLogged() {
		return $this->seller_id;
	}

	public function getId() {
		return $this->seller_id;
	}

	public function getFirstName() {
		return $this->firstname;
	}

	public function getLastName() {
		return $this->lastname;
	}

	public function getGroupId() {
		return $this->seller_group_id;
	}

	public function getEmail() {
		return $this->email;
	}

	public function getTelephone() {
		return $this->telephone;
	}

	public function getFax() {
		return $this->fax;
	}

	public function getNewsletter() {
		return $this->newsletter;
	}

	public function getAddressId() {
		return $this->address_id;
	}

	public function getBalance() {
		$query = $this->db->query("SELECT SUM(amount) AS total FROM " . DB_PREFIX . "seller_transaction WHERE seller_id = '" . (int)$this->seller_id . "'");

		return $query->row['total'];
	}

	public function getRewardPoints() {
		$query = $this->db->query("SELECT SUM(points) AS total FROM " . DB_PREFIX . "seller_reward WHERE seller_id = '" . (int)$this->seller_id . "'");

		return $query->row['total'];
	}
}
