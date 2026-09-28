-- Include the selected delivery fee in the order total.
-- Preserve the configured delivery tariff.
SET NAMES utf8mb4;
UPDATE oc_setting SET value='1' WHERE store_id=0 AND code='shipping' AND `key`='shipping_status';
INSERT INTO oc_setting (store_id,code,`key`,value,serialized)
SELECT 0,'shipping','shipping_status','1',0 WHERE NOT EXISTS
(SELECT 1 FROM oc_setting WHERE store_id=0 AND code='shipping' AND `key`='shipping_status');
UPDATE oc_setting SET value='3' WHERE store_id=0 AND code='shipping' AND `key`='shipping_sort_order' AND (value='' OR value='0');
