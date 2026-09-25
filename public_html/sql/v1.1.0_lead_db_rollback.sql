-- ============================================================================
-- haramain.online — ROLLBACK for v1.1.0_lead_db_setup.sql (v1.1.0 -> v1.0.0)
-- Restores the state captured in localhost.sql (2026-09-10).
-- NOTE: tables are MyISAM, so there is no transactional atomicity; run as a
-- whole and re-check with the verification block at the end.
-- ============================================================================
SET NAMES utf8mb4;

-- 4. category tree (reverse order: dependants first)
DELETE FROM `oc_url_alias`          WHERE `query` IN (
  'category_id=100','category_id=101','category_id=102','category_id=103','category_id=104','category_id=105',
  'category_id=106','category_id=107','category_id=108','category_id=109','category_id=110','category_id=111',
  'category_id=112','category_id=113','category_id=114','category_id=115','category_id=116','category_id=117');
DELETE FROM `oc_category_to_layout` WHERE `category_id` BETWEEN 100 AND 117;
DELETE FROM `oc_category_to_store`  WHERE `category_id` BETWEEN 100 AND 117;
DELETE FROM `oc_category_path`      WHERE `category_id` BETWEEN 100 AND 117;
DELETE FROM `oc_category_description` WHERE `category_id` BETWEEN 100 AND 117;
DELETE FROM `oc_category`           WHERE `category_id` BETWEEN 100 AND 117;

-- 3. order statuses and settings
DELETE FROM `oc_order_status` WHERE `order_status_id` IN (4, 5) AND `language_id` = 1;
UPDATE `oc_setting` SET `value` = '1'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_order_status_id';
UPDATE `oc_setting` SET `value` = '["1"]', `serialized` = 1
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_processing_status';
UPDATE `oc_setting` SET `value` = '["2"]', `serialized` = 1
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_complete_status';

-- 2. currency
UPDATE `oc_currency` SET `status` = 1 WHERE `code` IN ('GBP', 'EUR', 'UAH', 'RUB');
UPDATE `oc_setting` SET `value` = 'RUB'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_currency';
UPDATE `oc_setting` SET `value` = '1'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_currency_auto';
DELETE FROM `oc_currency` WHERE `code` = 'SAR';

-- 1. receipt column (data in it is lost)
ALTER TABLE `oc_order` DROP COLUMN `receipt_file`;

-- ---- verification -----------------------------------------------------------
-- SHOW COLUMNS FROM `oc_order` LIKE 'receipt_file';           -- expect empty
-- SELECT * FROM `oc_currency`;                                 -- 4 rows, all status 1
-- SELECT * FROM `oc_order_status`;                             -- ids 1..3
-- SELECT COUNT(*) FROM `oc_category` WHERE category_id >= 100; -- 0
