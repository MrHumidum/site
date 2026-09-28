-- ============================================================================
-- haramain.online — LEAD DB migration v1.0.0 -> v1.1.0
-- Target: OpenCart 2.3.0.2.4 (opencart.pro), MySQL 5.7, table prefix `oc_`
-- Verified against dump: localhost.sql (2026-09-10)
--
-- Facts used from the dump:
--   * Single language: oc_language.language_id = 1 (ru-ru)
--   * Single store:    store_id = 0
--   * Existing order statuses: 1 'В обработке', 2 'Оплачен', 3 'Отменен'
--   * Existing currencies: GBP(1) EUR(3) UAH(4) RUB(5); config_currency = RUB
--   * Existing categories: ids 73..92 (old pharmacy tree), AUTO_INCREMENT = 93
--   * oc_order has no `receipt_file` column
--
-- Run as a whole in phpMyAdmin / mysql CLI. Make a backup first (LEAD.md §2).
-- ============================================================================

SET NAMES utf8mb4;
START TRANSACTION;

-- ----------------------------------------------------------------------------
-- 1. CONTRACT GAP: receipt file for manual bank-transfer payment (DEV_B B3/B4)
-- ----------------------------------------------------------------------------
ALTER TABLE `oc_order`
  ADD COLUMN `receipt_file` VARCHAR(255) DEFAULT NULL AFTER `comment`;

-- ----------------------------------------------------------------------------
-- 2. CURRENCY: Saudi Riyal (SAR) as the only active, default currency
-- ----------------------------------------------------------------------------
INSERT INTO `oc_currency`
  (`title`, `code`, `symbol_left`, `symbol_right`, `decimal_place`, `value`, `status`, `date_modified`)
VALUES
  ('Саудовский риал', 'SAR', '', ' риал', '2', 1.00000000, 1, NOW());

-- Default store currency -> SAR (oc_setting has no unique key on (code,key),
-- so update in place; row exists in the dump as setting_id 3594).
UPDATE `oc_setting`
   SET `value` = 'SAR'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_currency';

-- Disable automatic exchange-rate refresh: SAR is the base (value = 1) and
-- the rate updater would otherwise overwrite `value` of every currency.
UPDATE `oc_setting`
   SET `value` = '0'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_currency_auto';

-- Hide legacy currencies from the storefront (prices are shown in SAR only).
UPDATE `oc_currency`
   SET `status` = 0
 WHERE `code` IN ('GBP', 'EUR', 'UAH', 'RUB');

-- ----------------------------------------------------------------------------
-- 3. ORDER STATUSES (language_id = 1)
--    1 = В обработке   (Processing)          -- existing, kept
--    2 = Оплачен       (legacy "Paid")       -- existing, kept for old orders
--    3 = Отменен       (Cancelled)           -- existing, kept
--    4 = Ожидает оплаты (Pending Payment)    -- new
--    5 = Проверка чека  (Payment Verification) -- new
-- ----------------------------------------------------------------------------
UPDATE `oc_order_status` SET `name` = 'В обработке' WHERE `order_status_id` = 1 AND `language_id` = 1;
UPDATE `oc_order_status` SET `name` = 'Отменен'     WHERE `order_status_id` = 3 AND `language_id` = 1;

INSERT INTO `oc_order_status` (`order_status_id`, `language_id`, `name`) VALUES
  (4, 1, 'Ожидает оплаты'),
  (5, 1, 'Проверка чека');

-- Default status of a freshly created order -> Pending Payment.
UPDATE `oc_setting`
   SET `value` = '4'
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_order_status_id';

-- "Processing" statuses (stock is subtracted, order is visible to customer):
-- Processing, legacy Paid, Pending Payment, Payment Verification.
UPDATE `oc_setting`
   SET `value` = '["1","2","4","5"]', `serialized` = 1
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_processing_status';

-- "Complete" statuses stay: legacy Paid (2). Add Processing (1) so that
-- reports treat a confirmed bank transfer as a completed sale.
UPDATE `oc_setting`
   SET `value` = '["1","2"]', `serialized` = 1
 WHERE `store_id` = 0 AND `code` = 'config' AND `key` = 'config_complete_status';

-- ----------------------------------------------------------------------------
-- 4. CATEGORY TREE (tech.md §4.2). Explicit ids 100..117 (dump AUTO_INCREMENT = 93).
--    Emoji from tech.md are icon hints for the SVG sprite (DEV_A A2), not names.
--    Old pharmacy categories 73..92 are left untouched (see optional block below).
-- ----------------------------------------------------------------------------
INSERT INTO `oc_category`
  (`category_id`, `image`, `parent_id`, `top`, `column`, `sort_order`, `status`, `noindex`, `date_added`, `date_modified`)
VALUES
  -- level 0
  (100, NULL,   0, 1, 1,  1, 1, 1, NOW(), NOW()),  -- Маркетплейс
  (108, NULL,   0, 1, 1,  2, 1, 1, NOW(), NOW()),  -- Кавказская кухня
  (109, NULL,   0, 1, 1,  3, 1, 1, NOW(), NOW()),  -- Азиатская кухня
  (110, NULL,   0, 1, 1,  4, 1, 1, NOW(), NOW()),  -- Другая кухня
  (111, NULL,   0, 1, 1,  5, 1, 1, NOW(), NOW()),  -- Дом и быт
  (112, NULL,   0, 1, 1,  6, 1, 1, NOW(), NOW()),  -- Цифровая техника
  (113, NULL,   0, 1, 1,  7, 1, 1, NOW(), NOW()),  -- Цифровые товары
  (114, NULL,   0, 1, 1,  8, 1, 1, NOW(), NOW()),  -- Транспортные средства
  (115, NULL,   0, 1, 1,  9, 1, 1, NOW(), NOW()),  -- Дети и мама
  (116, NULL,   0, 1, 1, 10, 1, 1, NOW(), NOW()),  -- Книги и обучение
  (117, NULL,   0, 1, 1, 11, 1, 1, NOW(), NOW()),  -- Подарки и сувениры
  -- level 1 (children of Маркетплейс = 100)
  (101, NULL, 100, 0, 1,  1, 1, 1, NOW(), NOW()),  -- Для паломника
  (102, NULL, 100, 0, 1,  2, 1, 1, NOW(), NOW()),  -- Одежда
  (103, NULL, 100, 0, 1,  3, 1, 1, NOW(), NOW()),  -- Аксессуары
  (104, NULL, 100, 0, 1,  4, 1, 1, NOW(), NOW()),  -- Красота и уход
  (105, NULL, 100, 0, 1,  5, 1, 1, NOW(), NOW()),  -- Аптека
  (106, NULL, 100, 0, 1,  6, 1, 1, NOW(), NOW()),  -- Продукты
  (107, NULL, 100, 0, 1,  7, 1, 1, NOW(), NOW());  -- Овощи и фрукты

INSERT INTO `oc_category_description`
  (`category_id`, `language_id`, `name`, `description`, `description_bottom`, `meta_title`, `meta_description`, `meta_keyword`, `meta_h1`)
VALUES
  (100, 1, 'Маркетплейс',            '', '', 'Маркетплейс',            '', '', 'Маркетплейс'),
  (101, 1, 'Для паломника',          '', '', 'Для паломника',          '', '', 'Для паломника'),
  (102, 1, 'Одежда',                 '', '', 'Одежда',                 '', '', 'Одежда'),
  (103, 1, 'Аксессуары',             '', '', 'Аксессуары',             '', '', 'Аксессуары'),
  (104, 1, 'Красота и уход',         '', '', 'Красота и уход',         '', '', 'Красота и уход'),
  (105, 1, 'Аптека',                 '', '', 'Аптека',                 '', '', 'Аптека'),
  (106, 1, 'Продукты',               '', '', 'Продукты',               '', '', 'Продукты'),
  (107, 1, 'Овощи и фрукты',         '', '', 'Овощи и фрукты',         '', '', 'Овощи и фрукты'),
  (108, 1, 'Кавказская кухня',       '', '', 'Кавказская кухня',       '', '', 'Кавказская кухня'),
  (109, 1, 'Азиатская кухня',        '', '', 'Азиатская кухня',        '', '', 'Азиатская кухня'),
  (110, 1, 'Другая кухня',           '', '', 'Другая кухня',           '', '', 'Другая кухня'),
  (111, 1, 'Дом и быт',              '', '', 'Дом и быт',              '', '', 'Дом и быт'),
  (112, 1, 'Цифровая техника',       '', '', 'Цифровая техника',       '', '', 'Цифровая техника'),
  (113, 1, 'Цифровые товары',        '', '', 'Цифровые товары',        '', '', 'Цифровые товары'),
  (114, 1, 'Транспортные средства',  '', '', 'Транспортные средства',  '', '', 'Транспортные средства'),
  (115, 1, 'Дети и мама',            '', '', 'Дети и мама',            '', '', 'Дети и мама'),
  (116, 1, 'Книги и обучение',       '', '', 'Книги и обучение',       '', '', 'Книги и обучение'),
  (117, 1, 'Подарки и сувениры',     '', '', 'Подарки и сувениры',     '', '', 'Подарки и сувениры');

-- Closure table (required by OpenCart for breadcrumbs / path=100_105 URLs)
INSERT INTO `oc_category_path` (`category_id`, `path_id`, `level`) VALUES
  (100, 100, 0),
  (101, 100, 0), (101, 101, 1),
  (102, 100, 0), (102, 102, 1),
  (103, 100, 0), (103, 103, 1),
  (104, 100, 0), (104, 104, 1),
  (105, 100, 0), (105, 105, 1),
  (106, 100, 0), (106, 106, 1),
  (107, 100, 0), (107, 107, 1),
  (108, 108, 0),
  (109, 109, 0),
  (110, 110, 0),
  (111, 111, 0),
  (112, 112, 0),
  (113, 113, 0),
  (114, 114, 0),
  (115, 115, 0),
  (116, 116, 0),
  (117, 117, 0);

-- Store binding (catalog model filters by c2s.store_id = 0)
INSERT INTO `oc_category_to_store` (`category_id`, `store_id`) VALUES
  (100, 0), (101, 0), (102, 0), (103, 0), (104, 0), (105, 0), (106, 0), (107, 0),
  (108, 0), (109, 0), (110, 0), (111, 0), (112, 0), (113, 0), (114, 0), (115, 0),
  (116, 0), (117, 0);

-- Layout binding (0 = default layout, same as existing categories)
INSERT INTO `oc_category_to_layout` (`category_id`, `store_id`, `layout_id`) VALUES
  (100, 0, 0), (101, 0, 0), (102, 0, 0), (103, 0, 0), (104, 0, 0), (105, 0, 0),
  (106, 0, 0), (107, 0, 0), (108, 0, 0), (109, 0, 0), (110, 0, 0), (111, 0, 0),
  (112, 0, 0), (113, 0, 0), (114, 0, 0), (115, 0, 0), (116, 0, 0), (117, 0, 0);

-- SEO aliases (config_seo_url = 1, seo_pro is active)
INSERT INTO `oc_url_alias` (`query`, `keyword`, `seomanager`) VALUES
  ('category_id=100', 'marketplace',           0),
  ('category_id=101', 'dlya-palomnika',        0),
  ('category_id=102', 'odezhda',               0),
  ('category_id=103', 'aksessuary',            0),
  ('category_id=104', 'krasota-i-uhod',        0),
  ('category_id=105', 'apteka',                0),
  ('category_id=106', 'produkty',              0),
  ('category_id=107', 'ovoshchi-i-frukty',     0),
  ('category_id=108', 'kavkazskaya-kuhnya',    0),
  ('category_id=109', 'aziatskaya-kuhnya',     0),
  ('category_id=110', 'drugaya-kuhnya',        0),
  ('category_id=111', 'dom-i-byt',             0),
  ('category_id=112', 'cifrovaya-tehnika',     0),
  ('category_id=113', 'cifrovye-tovary',       0),
  ('category_id=114', 'transportnye-sredstva', 0),
  ('category_id=115', 'deti-i-mama',           0),
  ('category_id=116', 'knigi-i-obuchenie',     0),
  ('category_id=117', 'podarki-i-suveniry',    0);

COMMIT;

-- ============================================================================
-- OPTIONAL (not part of tech.md v1.1.0, run only after LEAD decision):
-- move the 20 old pharmacy categories (73..92) under "Аптека" (105) so the
-- existing products stay reachable instead of showing as extra top-level items.
-- ============================================================================
-- START TRANSACTION;
-- UPDATE `oc_category` SET `parent_id` = 105, `top` = 0 WHERE `category_id` BETWEEN 73 AND 92;
-- DELETE FROM `oc_category_path` WHERE `category_id` BETWEEN 73 AND 92;
-- INSERT INTO `oc_category_path` (`category_id`, `path_id`, `level`)
--   SELECT c.category_id, 100, 0 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92
--   UNION ALL
--   SELECT c.category_id, 105, 1 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92
--   UNION ALL
--   SELECT c.category_id, c.category_id, 2 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92;
-- COMMIT;

-- ============================================================================
-- OPTIONAL (DEV_B B3, after the "Bank Transfer" payment module is installed
-- via admin -> Extensions -> Payments): make it drop orders into Pending Payment.
-- oc_setting has no unique key on (store_id, code, key): delete, then insert.
-- ============================================================================
-- DELETE FROM `oc_setting` WHERE `store_id` = 0 AND `code` = 'bank_transfer' AND `key` = 'bank_transfer_order_status_id';
-- INSERT INTO `oc_setting` (`store_id`, `code`, `key`, `value`, `serialized`)
--   VALUES (0, 'bank_transfer', 'bank_transfer_order_status_id', '4', 0);

-- ============================================================================
-- VERIFICATION (read-only)
-- ============================================================================
-- SHOW COLUMNS FROM `oc_order` LIKE 'receipt_file';
-- SELECT * FROM `oc_currency`;
-- SELECT `key`, `value` FROM `oc_setting` WHERE `key` IN ('config_currency','config_currency_auto','config_order_status_id','config_processing_status','config_complete_status');
-- SELECT * FROM `oc_order_status` ORDER BY order_status_id;
-- SELECT c.category_id, c.parent_id, c.top, c.sort_order, cd.name
--   FROM `oc_category` c JOIN `oc_category_description` cd USING (category_id)
--  WHERE c.category_id >= 100 ORDER BY c.parent_id, c.sort_order;
-- SELECT * FROM `oc_category_path` WHERE category_id >= 100 ORDER BY category_id, level;
