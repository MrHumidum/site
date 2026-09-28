-- Repeatable payment setup. Existing card details are preserved.
SET NAMES utf8mb4;
INSERT INTO oc_extension (type, code) SELECT 'payment', 'bank_transfer'
WHERE NOT EXISTS (SELECT 1 FROM oc_extension WHERE type = 'payment' AND code = 'bank_transfer');
UPDATE oc_setting SET value = '1', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_status';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_status', '1', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_status');
UPDATE oc_setting SET value = '1', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_sort_order';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_sort_order', '1', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_sort_order');
UPDATE oc_setting SET value = '0', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_geo_zone_id';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_geo_zone_id', '0', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_geo_zone_id');
UPDATE oc_setting SET value = '0', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_total';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_total', '0', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_total');
UPDATE oc_setting SET value = '4', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_order_status_id';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_order_status_id', '4', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_order_status_id');
UPDATE oc_setting SET value = '5', serialized = 0 WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_verification_status_id';
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_verification_status_id', '5', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_verification_status_id');
INSERT INTO oc_setting (store_id, code, `key`, value, serialized) SELECT 0, 'bank_transfer', 'bank_transfer_bank1', '', 0 WHERE NOT EXISTS (SELECT 1 FROM oc_setting WHERE store_id = 0 AND code = 'bank_transfer' AND `key` = 'bank_transfer_bank1');
UPDATE oc_setting SET value = '' WHERE code = 'bank_transfer' AND `key` LIKE 'bank_transfer_bank%' AND value = 'Банк | 0000 0000 0000 0000 | ИМЯ ПОЛУЧАТЕЛЯ';
UPDATE oc_setting SET value = '0' WHERE store_id = 0 AND `key` IN ('cod_status','free_checkout_status');
