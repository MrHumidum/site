<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ModelSellerSellerField extends Model {
	public function addsellerField($data) {
		$this->db->query("INSERT INTO `" . DB_PREFIX . "seller_field` SET type = '" . $this->db->escape($data['type']) . "', value = '" . $this->db->escape($data['value']) . "', validation = '" . $this->db->escape($data['validation']) . "', location = '" . $this->db->escape($data['location']) . "', status = '" . (int)$data['status'] . "', sort_order = '" . (int)$data['sort_order'] . "'");

		$seller_field_id = $this->db->getLastId();

		foreach ($data['seller_field_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_description SET seller_field_id = '" . (int)$seller_field_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "'");
		}

		if (isset($data['seller_field_sellerer_group'])) {
			foreach ($data['seller_field_sellerer_group'] as $seller_field_sellerer_group) {
				if (isset($seller_field_sellerer_group['sellerer_group_id'])) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_sellerer_group SET seller_field_id = '" . (int)$seller_field_id . "', sellerer_group_id = '" . (int)$seller_field_sellerer_group['sellerer_group_id'] . "', required = '" . (int)(isset($seller_field_sellerer_group['required']) ? 1 : 0) . "'");
				}
			}
		}

		if (isset($data['seller_field_value'])) {
			foreach ($data['seller_field_value'] as $seller_field_value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_value SET seller_field_id = '" . (int)$seller_field_id . "', sort_order = '" . (int)$seller_field_value['sort_order'] . "'");

				$seller_field_value_id = $this->db->getLastId();

				foreach ($seller_field_value['seller_field_value_description'] as $language_id => $seller_field_value_description) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_value_description SET seller_field_value_id = '" . (int)$seller_field_value_id . "', language_id = '" . (int)$language_id . "', seller_field_id = '" . (int)$seller_field_id . "', name = '" . $this->db->escape($seller_field_value_description['name']) . "'");
				}
			}
		}
		
		return $seller_field_id;
	}

	public function editsellerField($seller_field_id, $data) {
		$this->db->query("UPDATE `" . DB_PREFIX . "seller_field` SET type = '" . $this->db->escape($data['type']) . "', value = '" . $this->db->escape($data['value']) . "', validation = '" . $this->db->escape($data['validation']) . "', location = '" . $this->db->escape($data['location']) . "', status = '" . (int)$data['status'] . "', sort_order = '" . (int)$data['sort_order'] . "' WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_field_description WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		foreach ($data['seller_field_description'] as $language_id => $value) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_description SET seller_field_id = '" . (int)$seller_field_id . "', language_id = '" . (int)$language_id . "', name = '" . $this->db->escape($value['name']) . "'");
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_field_sellerer_group WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		if (isset($data['seller_field_sellerer_group'])) {
			foreach ($data['seller_field_sellerer_group'] as $seller_field_sellerer_group) {
				if (isset($seller_field_sellerer_group['sellerer_group_id'])) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_sellerer_group SET seller_field_id = '" . (int)$seller_field_id . "', sellerer_group_id = '" . (int)$seller_field_sellerer_group['sellerer_group_id'] . "', required = '" . (int)(isset($seller_field_sellerer_group['required']) ? 1 : 0) . "'");
				}
			}
		}

		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_field_value WHERE seller_field_id = '" . (int)$seller_field_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "seller_field_value_description WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		if (isset($data['seller_field_value'])) {
			foreach ($data['seller_field_value'] as $seller_field_value) {
				if ($seller_field_value['seller_field_value_id']) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_value SET seller_field_value_id = '" . (int)$seller_field_value['seller_field_value_id'] . "', seller_field_id = '" . (int)$seller_field_id . "', sort_order = '" . (int)$seller_field_value['sort_order'] . "'");
				} else {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_value SET seller_field_id = '" . (int)$seller_field_id . "', sort_order = '" . (int)$seller_field_value['sort_order'] . "'");
				}

				$seller_field_value_id = $this->db->getLastId();

				foreach ($seller_field_value['seller_field_value_description'] as $language_id => $seller_field_value_description) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "seller_field_value_description SET seller_field_value_id = '" . (int)$seller_field_value_id . "', language_id = '" . (int)$language_id . "', seller_field_id = '" . (int)$seller_field_id . "', name = '" . $this->db->escape($seller_field_value_description['name']) . "'");
				}
			}
		}
	}

	public function deletesellerField($seller_field_id) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_field` WHERE seller_field_id = '" . (int)$seller_field_id . "'");
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_field_description` WHERE seller_field_id = '" . (int)$seller_field_id . "'");
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_field_sellerer_group` WHERE seller_field_id = '" . (int)$seller_field_id . "'");
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_field_value` WHERE seller_field_id = '" . (int)$seller_field_id . "'");
		$this->db->query("DELETE FROM `" . DB_PREFIX . "seller_field_value_description` WHERE seller_field_id = '" . (int)$seller_field_id . "'");
	}

	public function getsellerField($seller_field_id) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "seller_field` cf LEFT JOIN " . DB_PREFIX . "seller_field_description cfd ON (cf.seller_field_id = cfd.seller_field_id) WHERE cf.seller_field_id = '" . (int)$seller_field_id . "' AND cfd.language_id = '" . (int)$this->config->get('config_language_id') . "'");

		return $query->row;
	}

	public function getSellerFields($data = array()) {
		if (empty($data['filter_sellerer_group_id'])) {
			$sql = "SELECT * FROM `" . DB_PREFIX . "seller_field` cf LEFT JOIN " . DB_PREFIX . "seller_field_description cfd ON (cf.seller_field_id = cfd.seller_field_id) WHERE cfd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
		} else {
			$sql = "SELECT * FROM " . DB_PREFIX . "seller_field_sellerer_group cfcg LEFT JOIN `" . DB_PREFIX . "seller_field` cf ON (cfcg.seller_field_id = cf.seller_field_id) LEFT JOIN " . DB_PREFIX . "seller_field_description cfd ON (cf.seller_field_id = cfd.seller_field_id) WHERE cfd.language_id = '" . (int)$this->config->get('config_language_id') . "'";
		}

		if (!empty($data['filter_name'])) {
			$sql .= " AND cfd.name LIKE '" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (!empty($data['filter_sellerer_group_id'])) {
			$sql .= " AND cfcg.sellerer_group_id = '" . (int)$data['filter_sellerer_group_id'] . "'";
		}

		$sort_data = array(
			'cfd.name',
			'cf.type',
			'cf.location',
			'cf.status',
			'cf.sort_order'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY cfd.name";
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

	public function getsellerFieldDescriptions($seller_field_id) {
		$seller_field_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_field_description WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		foreach ($query->rows as $result) {
			$seller_field_data[$result['language_id']] = array('name' => $result['name']);
		}

		return $seller_field_data;
	}
	
	public function getsellerFieldValue($seller_field_value_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_field_value cfv LEFT JOIN " . DB_PREFIX . "seller_field_value_description cfvd ON (cfv.seller_field_value_id = cfvd.seller_field_value_id) WHERE cfv.seller_field_value_id = '" . (int)$seller_field_value_id . "' AND cfvd.language_id = '" . (int)$this->config->get('config_language_id') . "'");

		return $query->row;
	}
	
	public function getsellerFieldValues($seller_field_id) {
		$seller_field_value_data = array();

		$seller_field_value_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_field_value cfv LEFT JOIN " . DB_PREFIX . "seller_field_value_description cfvd ON (cfv.seller_field_value_id = cfvd.seller_field_value_id) WHERE cfv.seller_field_id = '" . (int)$seller_field_id . "' AND cfvd.language_id = '" . (int)$this->config->get('config_language_id') . "' ORDER BY cfv.sort_order ASC");

		foreach ($seller_field_value_query->rows as $seller_field_value) {
			$seller_field_value_data[$seller_field_value['seller_field_value_id']] = array(
				'seller_field_value_id' => $seller_field_value['seller_field_value_id'],
				'name'                  => $seller_field_value['name']
			);
		}

		return $seller_field_value_data;
	}
	
	public function getsellerFieldsellererGroups($seller_field_id) {
		$query = $this->db->query("SELECT * FROM `" . DB_PREFIX . "seller_field_sellerer_group` WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		return $query->rows;
	}

	public function getsellerFieldValueDescriptions($seller_field_id) {
		$seller_field_value_data = array();

		$seller_field_value_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_field_value WHERE seller_field_id = '" . (int)$seller_field_id . "'");

		foreach ($seller_field_value_query->rows as $seller_field_value) {
			$seller_field_value_description_data = array();

			$seller_field_value_description_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "seller_field_value_description WHERE seller_field_value_id = '" . (int)$seller_field_value['seller_field_value_id'] . "'");

			foreach ($seller_field_value_description_query->rows as $seller_field_value_description) {
				$seller_field_value_description_data[$seller_field_value_description['language_id']] = array('name' => $seller_field_value_description['name']);
			}

			$seller_field_value_data[] = array(
				'seller_field_value_id'          => $seller_field_value['seller_field_value_id'],
				'seller_field_value_description' => $seller_field_value_description_data,
				'sort_order'                     => $seller_field_value['sort_order']
			);
		}

		return $seller_field_value_data;
	}

	public function getTotalsellerFields() {
		$query = $this->db->query("SELECT COUNT(*) AS total FROM `" . DB_PREFIX . "seller_field`");

		return $query->row['total'];
	}
}