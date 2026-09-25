<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ModelCatalogManufacturer extends Model {
	
	public function getManufacturerLayoutId($manufacturer_id) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "manufacturer_to_layout WHERE manufacturer_id = '" . (int)$manufacturer_id . "' AND store_id = '" . (int)$this->config->get('config_store_id') . "'");

		if ($query->num_rows) {
			return $query->row['layout_id'];
		} else {
			return 0;
		}
	}
	
	public function getManufacturer($manufacturer_id) {
		$query = $this->db->query("SELECT  * FROM " . DB_PREFIX . "customer where customer_id = '" . (int)$manufacturer_id . "' ");

		return $query->row;
	}
	public function getManufacturerTotal($manufacturer_id) {
		$sql = "SELECT COUNT(DISTINCT product_id) AS total FROM " . DB_PREFIX . "product where status = '1' AND manufacturer_id='".$manufacturer_id."'";
$query = $this->db->query($sql);

		return $query->row['total'];
	}
	public function getManufacturers($data = array()) {

//$sql = "SELECT cust.* FROM " . DB_PREFIX . "customer cust INNER JOIN " . DB_PREFIX ."product pr  ON ( pr.manufacturer_id = cust.customer_id)  group by cust.customer_id ";
$sql = "SELECT oc_customer.*, count(oc_product.product_id) as total FROM oc_customer left outer join oc_product ON oc_product.manufacturer_id = oc_customer.customer_id WHERE oc_customer.status=1 GROUP BY oc_customer.customer_id order by total DESC ";
		 
			$query = $this->db->query($sql);

			return $query->rows;
		
	}
}