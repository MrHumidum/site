<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerCommonHeader extends Controller {
	public function index() {
		// Analytics
		$this->load->model('extension/extension');

		$data['analytics'] = array();

		$analytics = $this->model_extension_extension->getExtensions('analytics');

		foreach ($analytics as $analytic) {
			if ($this->config->get($analytic['code'] . '_status')) {
				$data['analytics'][] = $this->load->controller('extension/analytics/' . $analytic['code'], $this->config->get($analytic['code'] . '_status'));
			}
		}

		if ($this->request->server['HTTPS']) {
			$server = $this->config->get('config_ssl');
		} else {
			$server = $this->config->get('config_url');
		}

		if (is_file(DIR_IMAGE . $this->config->get('config_icon'))) {
			$this->document->addLink($server . 'image/' . $this->config->get('config_icon'), 'icon');
		}

		$data['title'] = $this->document->getTitle();

		$data['base'] = $server;
		$data['description'] = $this->document->getDescription();
		$data['keywords'] = $this->document->getKeywords();
		$data['links'] = $this->document->getLinks();
		$data['robots'] = $this->document->getRobots();
		$data['styles'] = $this->document->getStyles();
		$data['scripts'] = $this->document->getScripts();
		$data['lang'] = $this->language->get('code');
		$data['direction'] = $this->language->get('direction');
$data['latest'] = $this->url->link('product/latest');
		$data['name'] = $this->config->get('config_name');

		if (is_file(DIR_IMAGE . $this->config->get('config_logo'))) {
			$data['logo'] = $server . 'image/' . $this->config->get('config_logo');
		} else {
			$data['logo'] = '';
		}

		$this->load->language('common/header');

		$data['text_home'] = $this->language->get('text_home');

		// Wishlist
		if ($this->customer->isLogged()) {
			$this->load->model('account/wishlist');

			$data['text_wishlist'] = sprintf($this->language->get('text_wishlist'), $this->model_account_wishlist->getTotalWishlist());
		} else {
			$data['text_wishlist'] = sprintf($this->language->get('text_wishlist'), (isset($this->session->data['wishlist']) ? count($this->session->data['wishlist']) : 0));
		}

		$data['text_shopping_cart'] = $this->language->get('text_shopping_cart');
		$data['text_logged'] = sprintf($this->language->get('text_logged'), $this->url->link('account/account', '', true), $this->customer->getFirstName(), $this->url->link('account/logout', '', true));

		$data['text_account'] = $this->language->get('text_account');
		$data['text_register'] = $this->language->get('text_register');
		$data['text_login'] = $this->language->get('text_login');
		$data['text_order'] = $this->language->get('text_order');
		$data['text_transaction'] = $this->language->get('text_transaction');
		$data['text_download'] = $this->language->get('text_download');
		$data['text_logout'] = $this->language->get('text_logout');
		$data['text_checkout'] = $this->language->get('text_checkout');
		$data['text_category'] = $this->language->get('text_category');
		$data['text_all'] = $this->language->get('text_all');

		$data['home'] = $this->url->link('common/home');
		$data['wishlist'] = $this->url->link('account/wishlist', '', true);
		$data['logged'] = $this->customer->isLogged();
		$data['account'] = $this->url->link('account/account', '', true);
		$data['register'] = $this->url->link('account/register', '', true);
		$data['login'] = $this->url->link('account/login', '', true);
		$data['order'] = $this->url->link('account/order', '', true);
		$data['transaction'] = $this->url->link('account/transaction', '', true);
		$data['download'] = $this->url->link('account/download', '', true);
		$data['logout'] = $this->url->link('account/logout', '', true);
		$data['shopping_cart'] = $this->url->link('checkout/cart');
		$data['checkout'] = $this->url->link('checkout/checkout', '', true);
		$data['contact'] = $this->url->link('information/contact');
		$data['telephone'] = $this->config->get('config_telephone');

		// Menu
		$this->load->model('design/custommenu');
		$this->load->model('catalog/category');

		$this->load->model('catalog/product');

		$data['categories'] = array();
		$data['categories2'] = array();
		if ($this->config->get('configcustommenu_custommenu')) {
		$custommenus = $this->model_design_custommenu->getcustommenus();
        $custommenu_child = $this->model_design_custommenu->getChildcustommenus();

        foreach($custommenus as $id => $custommenu) {
			$children_data = array();
        
			foreach($custommenu_child as $child_id => $child_custommenu) {
                if (($custommenu['custommenu_id'] != $child_custommenu['custommenu_id']) or !is_numeric($child_id)) {
                    continue;
                }

                $child_name = '';

                if (($custommenu['custommenu_type'] == 'category') and ($child_custommenu['custommenu_type'] == 'category')){
                    $filter_data = array(
                        'filter_category_id'  => $child_custommenu['link'],
                        'filter_sub_category' => true
                    );

                    $child_name = ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : '');
                }

                $children_data[] = array(
                    'name' => $child_custommenu['name'] . $child_name,
                    'href' => $this->getcustommenuLink($custommenu, $child_custommenu)
                );
            }

			$data['categories'][] = array(
				'name'     => $custommenu['name'] ,
				'children' => $children_data,
				'column'   => $custommenu['columns'] ? $custommenu['columns'] : 1,
				'href'     => $this->getcustommenuLink($custommenu)
			);
        }
		
		}  

$data['total'] =  $this->model_catalog_category->getTotalGames();
$data['avtors'] =  $this->model_catalog_category->getTotalAvtors();
$data['Orders'] =  $this->model_catalog_category->getTotalOrders();


		$categories = $this->model_catalog_category->getCategories(0);

		foreach ($categories as $category) {
			 
				// Level 2
				$children_data = array();

				$children = $this->model_catalog_category->getCategories($category['category_id']);

				foreach ($children as $child) {
					$filter_data = array(
						'filter_category_id'  => $child['category_id'],
						'filter_sub_category' => true
					);

					$children_data[] = array(
						'category_id' => $child['category_id'],
						'name'  => $child['name'] . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : ''),
						'icon'  => $this->getCategoryIcon($child['category_id']),
						'href'  => $this->url->link('product/category', 'path=' . $category['category_id'] . '_' . $child['category_id'])
					);
				}

				// Level 1
				$data['categories2'][] = array(
					'category_id' => $category['category_id'],
					'name'     => $category['name'],
					'icon'     => $this->getCategoryIcon($category['category_id']),
					'children' => $children_data,
					'column'   => $category['column'] ? $category['column'] : 1,
					'href'     => $this->url->link('product/category', 'path=' . $category['category_id'])
				);
		 
		}
		
		 

		$data['language'] = $this->load->controller('common/language');
		$data['currency'] = $this->load->controller('common/currency');
		if ($this->config->get('configblog_blog_menu')) {
			$data['menu'] = $this->load->controller('blog/menu');
		} else {
			$data['menu'] = '';
		}
		// Delivery city selector (tech.md section 4.1: Mecca / Medina only)
		$data['text_city'] = $this->language->get('text_city');
		$data['cities'] = $this->getCities();
		$data['city'] = $this->getCity();
		$data['city_action'] = $this->url->link('common/header/city', '', true);
		$data['city_redirect'] = $this->getCurrentUrl();

		$data['search'] = $this->load->controller('common/search');

			if ($this->config->get('alphabetm_status')) {
			$data['alphabetm'] = $this->load->controller('extension/module/alphabetm');
		} else {
			$data['alphabetm'] = '';
		}
			

			if ($this->config->get('alphabetm_status')) {
			$data['alphabetm'] = $this->load->controller('extension/module/alphabetm');
		} else {
			$data['alphabetm'] = '';
		}
			
		$data['cart'] = $this->load->controller('common/cart');

		// For page specific css
		if (isset($this->request->get['route'])) {
			if (isset($this->request->get['product_id'])) {
				$class = '-' . $this->request->get['product_id'];
			} elseif (isset($this->request->get['path'])) {
				$class = '-' . $this->request->get['path'];
			} elseif (isset($this->request->get['manufacturer_id'])) {
				$class = '-' . $this->request->get['manufacturer_id'];
			} elseif (isset($this->request->get['information_id'])) {
				$class = '-' . $this->request->get['information_id'];
			} else {
				$class = '';
			}

			$data['class'] = str_replace('/', '-', $this->request->get['route']) . $class;
		} else {
			$data['class'] = 'common-home';
		}

if (!isset($this->request->get['route']) || $this->request->get['route'] == 'common/home') {
		return $this->load->view('common/headerhome', $data);
	}
	else {
	return $this->load->view('common/header', $data);	
	}
	}
	
	/**
	 * Maps a marketplace category to an SVG sprite symbol declared in common/footer.tpl.
	 * Category ids are fixed by the tech.md v1.1.0 DB contract (section 7.4).
	 */
	public function getCategoryIcon($category_id) {
		$icons = array(
			100 => 'cat-marketplace',
			101 => 'cat-pilgrim',
			102 => 'cat-clothes',
			103 => 'cat-accessories',
			104 => 'cat-beauty',
			105 => 'cat-pharmacy',
			106 => 'cat-groceries',
			107 => 'cat-fruits',
			108 => 'cat-caucasian',
			109 => 'cat-asian',
			110 => 'cat-cuisine',
			111 => 'cat-home',
			112 => 'cat-electronics',
			113 => 'cat-digital',
			114 => 'cat-transport',
			115 => 'cat-kids',
			116 => 'cat-books',
			117 => 'cat-gifts'
		);

		return isset($icons[$category_id]) ? $icons[$category_id] : 'cat-default';
	}

	/**
	 * Allowed delivery cities. The storefront must never offer anything else.
	 */
	public function getCities() {
		$this->load->language('common/header');

		return array(
			'mecca'  => $this->language->get('text_city_mecca'),
			'medina' => $this->language->get('text_city_medina')
		);
	}

	/**
	 * Currently selected city code, falling back to the first allowed city.
	 */
	public function getCity() {
		$cities = $this->getCities();

		if (isset($this->session->data['city']) && isset($cities[$this->session->data['city']])) {
			return $this->session->data['city'];
		}

		$codes = array_keys($cities);

		return $codes[0];
	}

	/**
	 * Stores the chosen city in the session and returns the visitor to the same page.
	 */
	public function city() {
		$cities = $this->getCities();

		if (isset($this->request->post['city']) && isset($cities[$this->request->post['city']])) {
			$this->session->data['city'] = $this->request->post['city'];
            // Change the checkout copy only; never overwrite a stored address.
            if (isset($this->session->data['shipping_address'])) {
                $this->session->data['shipping_address']['city'] = $cities[$this->request->post['city']];
                unset($this->session->data['shipping_address']['address_id']);
            }

			// Shipping quotes and the stored address depend on the delivery city.
			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
		}

		$redirect = '';

		if (isset($this->request->post['redirect'])) {
			$url = $this->request->post['redirect'];

			// Only allow redirects back into this store.
			if (strpos($url, $this->config->get('config_url')) === 0 || strpos($url, $this->config->get('config_ssl')) === 0) {
				$redirect = $url;
			}
		}

		if ($redirect) {
			$this->response->redirect($redirect);
		} else {
			$this->response->redirect($this->url->link('common/home'));
		}
	}

	/**
	 * Absolute URL of the page being rendered, used as the city form redirect.
	 */
	public function getCurrentUrl() {
		if (!isset($this->request->get['route'])) {
			return $this->url->link('common/home');
		}

		$url_data = $this->request->get;

		unset($url_data['_route_']);

		$route = $url_data['route'];

		unset($url_data['route']);

		$url = '';

		if ($url_data) {
			$url = '&' . urldecode(http_build_query($url_data, '', '&'));
		}

		return $this->url->link($route, $url, $this->request->server['HTTPS']);
	}

	public function getcustommenuLink($parent, $child = null) {
		 if ($this->config->get('configcustommenu_custommenu')) {
        $item = empty($child) ? $parent : $child;

        switch ($item['custommenu_type']) {
            case 'category':
                $route = 'product/category';

                if (!empty($child)) {
                    $args = 'path=' . $parent['link'] . '_' . $item['link'];
                } else {
                    $args = 'path='.$item['link'];
                }
                break;
            case 'product':
                $route = 'product/product';
                $args = 'product_id='.$item['link'];
                break;
            case 'manufacturer':
                $route = 'product/manufacturer/info';
                $args = 'manufacturer_id='.$item['link'];
                break;
            case 'information':
                $route = 'information/information';
                $args = 'information_id='.$item['link'];
                break;
            default:
                $tmp = explode('&', str_replace('index.php?route=', '', $item['link']));

                if (!empty($tmp)) {
                    $route = $tmp[0];
                    unset($tmp[0]);
                    $args = (!empty($tmp)) ? implode('&', $tmp) : '';
                }
                else {
                    $route = $item['link'];
                    $args = '';
                }

                break;
        }

        $check = stripos($item['link'], 'http');
        $checkbase = strpos($item['link'], '/');
        if ( $check === 0 || $checkbase === 0 ) {
			$link = $item['link'];
        } else {
            $link = $this->url->link($route, $args);
        }
        return $link;
    }
	}
}
