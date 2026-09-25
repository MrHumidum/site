-- Read-only checks. Do not print credentials or customer data.
SELECT VERSION() AS database_version;
SELECT COUNT(*) AS receipt_column FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='oc_order' AND column_name='receipt_file';
SELECT COUNT(*) AS marketplace_categories FROM oc_category WHERE category_id BETWEEN 100 AND 117;
SELECT code, status FROM oc_currency WHERE code='SAR';
SELECT order_status_id, name FROM oc_order_status WHERE order_status_id IN (4,5);
SELECT country_id, iso_code_2, status FROM oc_country WHERE iso_code_2='SA';
SELECT seller_group_id, approval FROM oc_seller_group;
SELECT `key`, value FROM oc_setting WHERE store_id=0 AND `key` IN ('config_country_id','config_currency','config_seller_group_id');
