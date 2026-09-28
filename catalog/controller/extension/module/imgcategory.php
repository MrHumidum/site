<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerExtensionModuleImgcategory extends Controller {
	
	public function index($setting) {
		
		$this->load->language('extension/module/imgcategory');

    	$data['heading_title'] = $this->language->get('heading_title');

		$this->load->model('catalog/category');

		$this->load->model('tool/image');
        $this->load->model('marketplace/category_image');

		$data['categories'] = array();
		
		$results = $this->model_catalog_category->getCategories($setting['category_id']);
		
				$this->document->addStyle('catalog/view/javascript/jquery/owl-carousel/owl.carousel.css');
		$this->document->addScript('catalog/view/javascript/jquery/owl-carousel/owl.carousel.min.js');
		foreach ($results as $result) {
			
            $data['categories'][] = array (
				'href' 	=> $this->url->link('product/category', 'path=' . $result['category_id']),
				'image' => $this->model_marketplace_category_image->getImage($result) ,
				'name' 	=> $result['name'],
			);
		}
	
		return $this->load->view('extension/module/imgcategory', $data);
  	}
	
}
?>