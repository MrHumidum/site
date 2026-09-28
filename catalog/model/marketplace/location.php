<?php
class ModelMarketplaceLocation extends Model {
    public function getCountryId() {
        $query = $this->db->query("SELECT country_id FROM " . DB_PREFIX . "country WHERE iso_code_2 = 'SA' AND status = 1 LIMIT 1");
        return $query->num_rows ? (int)$query->row['country_id'] : 0;
    }

    public function isDeliverable($address) {
        return is_array($address) && $this->getCountryId() > 0
            && isset($address['country_id'], $address['city'])
            && (int)$address['country_id'] === $this->getCountryId()
            && in_array($address['city'], array('Мекка', 'Медина'), true);
    }
}
