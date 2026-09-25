-- v1.1.4: Saudi default and seller address ownership. Run after v1.1.0-v1.1.3.
-- Back up the entire database first: MyISAM changes are not transactional.
-- Preflight must return one Saudi country and a configured seller group.
SET NAMES utf8mb4;
SET @sa = (SELECT country_id FROM oc_country WHERE iso_code_2 = 'SA' AND status = 1 LIMIT 1);
-- Fail before writes when prerequisites are absent (NULL violates NOT NULL).
CREATE TEMPORARY TABLE haramain_preflight (id INT NOT NULL);
INSERT INTO haramain_preflight VALUES (@sa), ((SELECT MIN(seller_group_id) FROM oc_seller_group));
DROP TEMPORARY TABLE haramain_preflight;

SET @add_seller_address = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'oc_address' AND column_name = 'seller_id') = 0,
  'ALTER TABLE oc_address ADD COLUMN seller_id INT NOT NULL DEFAULT 0, ADD INDEX seller_owner (seller_id)',
  'SELECT 1');
PREPARE haramain_stmt FROM @add_seller_address;
EXECUTE haramain_stmt;
DEALLOCATE PREPARE haramain_stmt;

-- Existing buyer addresses keep seller_id=0; never infer ownership by matching IDs.
UPDATE oc_setting SET value = @sa WHERE store_id = 0 AND code = 'config' AND `key` = 'config_country_id';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized)
SELECT 0, 'config', 'config_country_id', @sa, 0 WHERE NOT EXISTS
(SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'config' AND `key` = 'config_country_id');
UPDATE oc_setting SET value = 0 WHERE store_id = 0 AND code = 'config' AND `key` = 'config_zone_id'
AND NOT EXISTS (SELECT 1 FROM oc_zone WHERE zone_id = CAST(oc_setting.value AS UNSIGNED) AND country_id = @sa);

-- No changes to product prices, historical orders or other countries.
SELECT c.iso_code_2, s.value AS default_country FROM oc_setting s JOIN oc_country c ON c.country_id = s.value WHERE s.store_id = 0 AND s.`key` = 'config_country_id';
SELECT COUNT(*) AS seller_address_column FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'oc_address' AND column_name = 'seller_id';

INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'config', 'config_seller_group_id', MIN(seller_group_id), 0 FROM oc_seller_group HAVING COUNT(*) > 0 AND NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id=0 AND `key`='config_seller_group_id');

-- The compact checkout has no password fields; use the existing guest flow.
UPDATE oc_setting SET value='1' WHERE store_id=0 AND code='config' AND `key`='config_checkout_guest';

UPDATE oc_country SET name='Саудовская Аравия' WHERE iso_code_2='SA';
