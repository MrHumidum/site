-- ============================================================================
-- haramain.online — move the 20 legacy pharmacy categories (73..92) under
-- "Аптека" (105), so the storefront menu shows the tech.md tree only.
-- Run after v1.1.0_lead_db_setup.sql. Products keep their category links.
-- ============================================================================
SET NAMES utf8mb4;

UPDATE `oc_category`
   SET `parent_id` = 105, `top` = 0, `date_modified` = NOW()
 WHERE `category_id` BETWEEN 73 AND 92;

-- Rebuild the closure rows for those categories: Маркетплейс > Аптека > <category>
DELETE FROM `oc_category_path` WHERE `category_id` BETWEEN 73 AND 92;

INSERT INTO `oc_category_path` (`category_id`, `path_id`, `level`)
  SELECT c.category_id, 100, 0 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92
  UNION ALL
  SELECT c.category_id, 105, 1 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92
  UNION ALL
  SELECT c.category_id, c.category_id, 2 FROM `oc_category` c WHERE c.category_id BETWEEN 73 AND 92;

-- ---- verification ----------------------------------------------------------
-- SELECT COUNT(*) AS top_level FROM `oc_category` WHERE parent_id = 0 AND status = 1;  -- expect 11
-- SELECT c.category_id, cd.name,
--        (SELECT GROUP_CONCAT(cd1.name ORDER BY cp.level SEPARATOR ' > ')
--           FROM `oc_category_path` cp
--           LEFT JOIN `oc_category_description` cd1
--             ON (cp.path_id = cd1.category_id AND cp.category_id != cp.path_id)
--          WHERE cp.category_id = c.category_id AND cd1.language_id = 1) AS path
--   FROM `oc_category` c
--   JOIN `oc_category_description` cd ON (cd.category_id = c.category_id AND cd.language_id = 1)
--  WHERE c.category_id BETWEEN 73 AND 92 ORDER BY c.category_id;
