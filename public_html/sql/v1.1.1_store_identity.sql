-- ============================================================================
-- haramain.online — store identity cleanup (run after v1.1.0_lead_db_setup.sql)
-- Removes the leftover "Farm Shop / из Турции" branding from oc_setting.
--
-- ATTENTION: the three values marked TODO are yours to confirm before running
-- (support e-mail and phone). Everything else is safe as written.
-- ============================================================================
SET NAMES utf8mb4;

-- Store name, owner and SEO defaults
UPDATE `oc_setting` SET `value` = 'haramain.online'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_name';

UPDATE `oc_setting` SET `value` = 'haramain.online'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_owner';

UPDATE `oc_setting` SET `value` = 'haramain.online — маркетплейс Мекки и Медины'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_meta_title';

UPDATE `oc_setting` SET `value` = 'Товары с доставкой по Мекке и Медине: для паломника, одежда, аптека, продукты и другое.'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_meta_description';

-- Logo: the placeholder shipped with this release (replace with the final artwork).
UPDATE `oc_setting` SET `value` = 'catalog/logo-haramain.svg'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_logo';

-- ---------------------------------------------------------------------------
-- TODO: confirm the contact details, then uncomment and run.
-- config_invoice_prefix is what the storefront footer prints as the support e-mail.
-- ---------------------------------------------------------------------------
-- UPDATE `oc_setting` SET `value` = 'support@haramain.online'
--  WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_email';
-- UPDATE `oc_setting` SET `value` = 'support@haramain.online'
--  WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_invoice_prefix';
-- UPDATE `oc_setting` SET `value` = '+966 00 000 0000'
--  WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_telephone';

-- ---- verification ----------------------------------------------------------
-- SELECT `key`, `value` FROM `oc_setting`
--  WHERE `store_id` = 0 AND `code` = 'config'
--    AND `key` IN ('config_name','config_owner','config_meta_title','config_meta_description','config_logo','config_email','config_invoice_prefix','config_telephone');
