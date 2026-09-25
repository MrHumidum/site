<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerExtensionModuleFeatured extends Controller {
	public function index($setting) {
		$this->load->language('extension/module/featured');

		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_tax'] = $this->language->get('text_tax');

		$data['button_cart'] = $this->language->get('button_cart');
		$data['button_wishlist'] = $this->language->get('button_wishlist');
		$data['button_compare'] = $this->language->get('button_compare');

		$this->load->model('catalog/product');

		$this->load->model('tool/image');

		$data['products'] = array();

		if (!$setting['limit']) {
			$setting['limit'] = 4;
		}
$product_data = array();
		if (!empty($setting['product'])) {
			$products = array_slice($setting['product'], 0, (int)$setting['limit']);

		$query = $this->db->query("SELECT p.product_id FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) WHERE p.jan=1 AND p.status = '1' AND p.date_available <= NOW() AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "'  LIMIT " . (int)$setting['limit']);
		
		
		
		foreach ($query->rows as $result) { 		
			$product_data[$result['product_id']] = $this->model_catalog_product->getProduct($result['product_id']);
		}
					 	 		
		$results = $product_data;
		$results = $this->model_catalog_product->getBestSellerProducts(24);
		$results = $this->model_catalog_product->getBestSellerProducts(8);
			if ($results) {
		foreach ($results as $result) {
			
				$product_info = $this->model_catalog_product->getProduct($result['product_id']);

				if ($product_info) {
					if ($product_info['image']) {
						$image = $this->model_tool_image->resize($product_info['image'], $setting['width'], $setting['height']);
					} else {
						$image = $this->model_tool_image->resize('placeholder.png', $setting['width'], $setting['height']);
					}

					if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
						$price = $this->currency->format($this->tax->calculate($product_info['price'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
					} else {
						$price = false;
					}

					if ((float)$product_info['special']) {
						$special = $this->currency->format($this->tax->calculate($product_info['special'], $product_info['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
						$skidka = round(($product_info['price']-$product_info['special'])/$product_info['price']*100);
					} else {
						$special = false;
						$skidka =  false;
					}

					if ($this->config->get('config_tax')) {
						$tax = $this->currency->format((float)$product_info['special'] ? $product_info['special'] : $product_info['price'], $this->session->data['currency']);
					} else {
						$tax = false;
					}

					if ($this->config->get('config_review_status')) {
						$rating = $product_info['rating'];
					} else {
						$rating = false;
					}
					
					 

$incart = false;
foreach ($this->cart->getProducts() as $ppro) {
            if ($ppro['product_id'] == $product_info['product_id']) {
$incart = true;
            }
        }


					$data['products'][] = array(
						'product_id'  => $product_info['product_id'],
						'thumb'       => $image,
						'name'        => $product_info['name'],
						'description' => utf8_substr(strip_tags(html_entity_decode($product_info['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get($this->config->get('config_theme') . '_product_description_length')) . '..',
						'price'       => $price,
						'skidka' => $skidka,
						'incart' => $incart,
						'special'     => $special,
						'tax'         => $tax,
						 
						'rating'      => $rating,
						'href'        => $this->url->link('product/product', 'product_id=' . $product_info['product_id'])
					);
				}
			}
		}
// ——— Вставляем товар 1124 на второе место ———
$forced_id   = 1124;
$forced_info = $this->model_catalog_product->getProduct($forced_id);

if ($forced_info) {
    // 1) удалить, если уже есть
    foreach ($data['products'] as $k => $p) {
        if ($p['product_id'] == $forced_id) {
            unset($data['products'][$k]);
        }
    }
    // 2) реиндексировать
    $data['products'] = array_values($data['products']);

    // 3) собрать один “принудительный” элемент в том же формате
    if ($forced_info['image']) {
        $thumb = $this->model_tool_image->resize(
          $forced_info['image'], 
          $setting['width'], 
          $setting['height']
        );
    } else {
        $thumb = $this->model_tool_image->resize(
          'placeholder.png', 
          $setting['width'], 
          $setting['height']
        );
    }

    $price = ($this->customer->isLogged() || !$this->config->get('config_customer_price'))
      ? $this->currency->format(
          $this->tax->calculate($forced_info['price'], $forced_info['tax_class_id'], $this->config->get('config_tax')),
          $this->session->data['currency']
        )
      : false;

    $special = ((float)$forced_info['special'])
      ? $this->currency->format(
          $this->tax->calculate($forced_info['special'], $forced_info['tax_class_id'], $this->config->get('config_tax')),
          $this->session->data['currency']
        )
      : false;

    $skidka = $special
      ? round(100 - ($forced_info['special'] / ($forced_info['price'] / 100)))
      : false;

    $tax = $this->config->get('config_tax')
      ? $this->currency->format(
          ((float)$forced_info['special'] ? $forced_info['special'] : $forced_info['price']),
          $this->session->data['currency']
        )
      : false;

    $rating = $this->config->get('config_review_status')
      ? $forced_info['rating']
      : false;

    $incart = false;
    foreach ($this->cart->getProducts() as $cp) {
        if ($cp['product_id'] == $forced_id) {
            $incart = true;
            break;
        }
    }

    $forced = [
        'product_id'  => $forced_id,
        'thumb'       => $thumb,
        'name'        => $forced_info['name'],
        'description' => utf8_substr(
            strip_tags(html_entity_decode($forced_info['description'], ENT_QUOTES, 'UTF-8')),
            0,
            $this->config->get($this->config->get('config_theme') . '_product_description_length')
          ) . '..',
        'price'       => $price,
        'skidka'      => $skidka,
        'incart'      => $incart,
        'special'     => $special,
        'tax'         => $tax,
        'rating'      => $rating,
        'href'        => $this->url->link('product/product', 'product_id=' . $forced_id),
    ];

    // 4) вставить строго на вторую позицию
    array_splice($data['products'], 1, 0, [$forced]);
}
// ——— /конец вставки ———

		if ($data['products']) {
			return $this->load->view('extension/module/featured', $data);
		}
	}
	
	}
}