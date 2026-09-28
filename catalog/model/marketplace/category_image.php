<?php
class ModelMarketplaceCategoryImage extends Model {
    public function getImage($category) {
        $file = isset($category['image']) ? $category['image'] : '';
        if (!$file || !is_file(DIR_IMAGE . $file)) {
            $file = 'catalog/haramain-categories/' . (int)$category['category_id'] . '.svg';
            if (!is_file(DIR_IMAGE . $file)) $file = 'catalog/haramain-categories/default.svg';
        }
        return 'image/' . implode('/', array_map('rawurlencode', explode('/', $file)));
    }
}
