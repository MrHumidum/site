<?php echo $header; ?>
<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <div class="row">
    <?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>">
      <?php echo $content_top; ?>
      <div class="catalog-header">
        <div class="catalog-info-user">
          <h1><?php echo $heading_title; ?></h1>
          <div class="item-stats">
			<?php if (!$special) { ?>
			<?php } else { ?>
			<div class="icon-special">
			  <img src="/image/catalog/icon-svg/sale.svg" alt="sale">
			</div>
			<?php } ?>
			<?php if ($sku) { ?>  
            <div class="sku-block"><span class="text-muted"><?php echo $text_sku; ?></span> &nbsp; <?php echo $sku; ?></div>
            <?php } ?>
            <?php if ($review_status) { ?>
            <div class="rating">
              <?php for ($i = 1; $i <= 5; $i++) { ?>
              <?php if ($rating < $i) { ?>
              <span class="star-empty"><i class="fa fa-star"></i></span>
              <?php } else { ?>
              <span class="star"><i class="fa fa-star"></i></span>
              <?php } ?>
              <?php } ?>
              <a class="review-link" href="" onclick="$('a[href=\'#tab-review\']').trigger('click');  $('html, body').animate({ scrollTop: $('a[href=\'#tab-review\']').offset().top - 5}, 250); return false;"><?php echo $reviews; ?></a> / <a class="review-write" href="" onclick="$('a[href=\'#tab-review\']').trigger('click');  $('html, body').animate({ scrollTop: $('a[href=\'#tab-review\']').offset().top - 5}, 250); return false;"><?php echo $text_write; ?></a>         
            </div>
            <?php } ?>
          </div>
          <div class="product-btn">
            <button type="button" class="btn btn-default btn-sm btn-wishlist" onclick="wishlist.add('<?php echo $product_id; ?>');"><?php echo $button_wishlist; ?></button>
           
          </div>
        </div>
      </div>
      <div class="card noborder">
        <div id="product" class="row">
          <?php if ($column_left || $column_right) { ?>
          <?php $class = 'col-md-6 col-lg-8'; ?>
          <?php } else { ?>
          <?php $class = 'col-md-7 col-lg-8'; ?>
          <?php } ?>
          <div class="<?php echo $class; ?>">
            <div class="thumbnails-block">
              <?php if ($thumb || $images) { ?>
              <ul class="thumbnails">
                <?php if ($thumb) { ?>
                <li><a class="thumbnail main-photo" href="<?php echo $popup; ?>" title="<?php echo $heading_title; ?>"><img src="<?php echo $thumb; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" /></a></li>
                <?php } ?>
                <?php if ($images) { ?>
                <?php foreach ($images as $image) { ?>
                <li class="image-additional"><a class="thumbnail" href="<?php echo $image['popup']; ?>" title="<?php echo $heading_title; ?>"> <img src="<?php echo $image['thumb']; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" /></a></li>
                <?php } ?>
                <?php } ?>
              </ul>
              <?php } ?>         
            </div>
          </div>
          <?php if ($column_left || $column_right) { ?>
          <?php $class = 'col-md-6 col-lg-4'; ?>
          <?php } else { ?>
          <?php $class = 'col-md-5 col-lg-4'; ?>
          <?php } ?>
          <div class="<?php echo $class; ?>">
            <div class="catalog-detail">
              <?php if ($price) { ?>
              <div class="product-price">
                <div class="price">
                  <div class="price-caption">Цена:</div>
                  <div class="price-panel">
                    <?php if (!$special) { ?>
                    <div class="main-price new-price"><?php echo $price; ?></div>
                    <?php } else { ?>
                    <div class="price-old">
                      <span class="value"><?php echo $price; ?></span>
                      <?php if ($action_percent) { ?>
                      <span class="sale sale-sticker product-sticker"><?php echo "-". $action_percent . "%"; ?></span>
                      <?php }?>
                    </div>
                    <span class="main-price"><?php echo $special; ?></span>
                    <?php } ?>
                  </div>
                  <?php if ($tax) { ?>
                  <div class="tax-block">
                    <span class="price-tax"><?php echo $text_tax; ?> <?php echo $tax; ?></span>
                  </div>
                  <?php } ?>                               				
                </div>
                <?php if ($discounts) { ?>
                <div class="form-group text-right">
                  <?php foreach ($discounts as $discount) { ?>
                  <div class="discount-price">
                    <span><?php echo $discount['quantity']; ?><?php echo $text_discount; ?></span> <?php echo $discount['price']; ?>
                  </div>
                  <?php } ?>
                </div>
                <?php } ?>
                <?php if ($points) { ?>
                <div class="form-group text-right">
                  <div class="discount-price">
                    <span><?php echo $text_points; ?></span> <?php echo $points; ?>
                  </div>
                </div>
                <?php } ?> 	
              </div>
              <?php } ?>
              <div class="product-buy-btn">
                <div class="product-quantity">
                  <label class="control-label" for="input-quantity"><?php echo $entry_qty; ?></label>
                  <div class="plus-minus">
                    <button type="button" class="btn btn-default btn-pls" data-dir="dwn" aria-label="Уменьшить количество">-</button>
                    <input type="number" min="<?php echo max(1, (int)$minimum); ?>" step="1" inputmode="numeric" name="quantity" value="<?php echo $minimum; ?>" id="input-quantity" class="product-form-quantity" />
                    <button type="button" class="btn btn-default btn-mns" data-dir="up" aria-label="Увеличить количество">+</button>
                  </div>
                  <br />
                  <button type="button" id="button-cart" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-primary btn-lg"><?php echo $button_cart; ?></button>
                  <input type="hidden" name="product_id" value="<?php echo $product_id; ?>" />
                  <div class="quantity-form">
					<?php if ($quantity <= 0) { ?>
				    <span class="text-danger stock"><i class="fa fa-exclamation-circle"></i> <?php echo $stock; ?></span>
                    <?php } else { ?>
				    <span class="text-success stock"><i class="fa fa-check-circle"></i> <?php echo $stock; ?></span>
			        <?php } ?>
				  </div>
				</div>
                <?php if ($minimum > 1) { ?>
                <div class="alert alert-info"><i class="fa fa-info-circle"></i> <?php echo $text_minimum; ?></div>
                <?php } ?>
                <div class="product-btn hidden-sm hidden-md hidden-lg">
                  <button type="button" class="btn btn-default btn-sm btn-wishlist" onclick="wishlist.add('<?php echo $product_id; ?>');"><?php echo $button_wishlist; ?></button>
                  
				</div>
              </div>             
              <div class="product-options">
                <?php if ($options) { ?>
                <hr>
                <h3 class="cont-title"><?php echo $text_option; ?></h3>
                <?php foreach ($options as $option) { ?>
                <?php if ($option['type'] == 'select') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <select name="option[<?php echo $option['product_option_id']; ?>]" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control">
                    <option value=""><?php echo $text_select; ?></option>
                    <?php foreach ($option['product_option_value'] as $option_value) { ?>
                    <option value="<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                      <?php if ($option_value['price']) { ?>
                      (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                      <?php } ?>
                    </option>
                    <?php } ?>
                  </select>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'radio') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label"><?php echo $option['name']; ?></label>
                  <div id="input-option<?php echo $option['product_option_id']; ?>">
                    <?php foreach ($option['product_option_value'] as $option_value) { ?>
                    <div class="radio">
                      <input type="radio" class="product-radio" id="<?php echo $option_value['product_option_value_id']; ?>" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option_value['product_option_value_id']; ?>" />
                      <label for="<?php echo $option_value['product_option_value_id']; ?>">                          
					    <?php if ($option_value['image']) { ?>
                        <img src="<?php echo $option_value['image']; ?>" alt="<?php echo $option_value['name'] . ($option_value['price'] ? ' ' . $option_value['price_prefix'] . $option_value['price'] : ''); ?>" /> 
                        <?php } ?>                    
                        <span class="radio-text">
					      <?php echo $option_value['name']; ?>
                          <?php if ($option_value['price']) { ?>
                          <span class="checkbox-price"><?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?></span>
                          <?php } ?>						  
                        </span>
				      </label>
                    </div>
                    <?php } ?>
                  </div>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'checkbox') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label"><?php echo $option['name']; ?></label>
                  <div id="input-option<?php echo $option['product_option_id']; ?>">
                    <?php foreach ($option['product_option_value'] as $option_value) { ?>
                    <div class="checkbox">										
                      <input type="checkbox" class="product-checkbox" id="<?php echo $option_value['product_option_value_id']; ?>" name="option[<?php echo $option['product_option_id']; ?>][]" value="<?php echo $option_value['product_option_value_id']; ?>" />
                      <label for="<?php echo $option_value['product_option_value_id']; ?>">                        
						<?php if ($option_value['image']) { ?>
                        <img src="<?php echo $option_value['image']; ?>" alt="<?php echo $option_value['name'] . ($option_value['price'] ? ' ' . $option_value['price_prefix'] . $option_value['price'] : ''); ?>" /> 
                        <?php } ?>
                        <span class="checkbox-text">
						<?php echo $option_value['name']; ?>
                          <?php if ($option_value['price']) { ?>
                          <span class="checkbox-price"><?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?></span>
                          <?php } ?>
				        </span>
                      </label>
                    </div>
                    <?php } ?>
                  </div>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'text') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['value']; ?>" placeholder="<?php echo $option['name']; ?>" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control" />
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'textarea') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <textarea name="option[<?php echo $option['product_option_id']; ?>]" rows="5" placeholder="<?php echo $option['name']; ?>" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control"><?php echo $option['value']; ?></textarea>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'file') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label"><?php echo $option['name']; ?></label>
                  <button type="button" id="button-upload<?php echo $option['product_option_id']; ?>" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-default btn-block"><i class="fa fa-upload"></i> <?php echo $button_upload; ?></button>
                  <input type="hidden" name="option[<?php echo $option['product_option_id']; ?>]" value="" id="input-option<?php echo $option['product_option_id']; ?>" />
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'date') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <div class="input-group date">
                    <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['value']; ?>" data-date-format="YYYY-MM-DD" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control" />
                    <span class="input-group-btn">
                    <button class="btn btn-default" type="button"><i class="fa fa-calendar"></i></button>
                    </span>
                  </div>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'datetime') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <div class="input-group datetime">
                    <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['value']; ?>" data-date-format="YYYY-MM-DD HH:mm" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control" />
                    <span class="input-group-btn">
                    <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                    </span>
                  </div>
                </div>
                <?php } ?>
                <?php if ($option['type'] == 'time') { ?>
                <div class="form-group<?php echo ($option['required'] ? ' required' : ''); ?>">
                  <label class="control-label" for="input-option<?php echo $option['product_option_id']; ?>"><?php echo $option['name']; ?></label>
                  <div class="input-group time">
                    <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['value']; ?>" data-date-format="HH:mm" id="input-option<?php echo $option['product_option_id']; ?>" class="form-control" />
                    <span class="input-group-btn">
                    <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                    </span>
                  </div>
                </div>
                <?php } ?>
                <?php } ?>
                <?php } ?>
                <?php if ($recurrings) { ?>
                <hr>
                <h3><?php echo $text_payment_recurring; ?></h3>
                <div class="form-group required">
                  <select name="recurring_id" class="form-control">
                    <option value=""><?php echo $text_select; ?></option>
                    <?php foreach ($recurrings as $recurring) { ?>
                    <option value="<?php echo $recurring['recurring_id']; ?>"><?php echo $recurring['name']; ?></option>
                    <?php } ?>
                  </select>
                  <div class="help-block" id="recurring-description"></div>
                </div>
                <?php } ?>              
              </div>             
            </div>
			<div class="detail-bottom">
			  <ul class="list-unstyled list-product">
               
                <li><span><?php echo $text_model; ?></span> <?php echo $model; ?></li>
                <?php if ($reward) { ?>
                <li><span><?php echo $text_reward; ?></span> <?php echo $reward; ?></li>
                <?php } ?>                
			  </ul>
			  <hr>
			  <!-- Add Yandex Share -->
              <script src="https://yastatic.net/es5-shims/0.0.2/es5-shims.min.js"></script>
              <script src="https://yastatic.net/share2/share.js"></script>
              <div class="ya-share2" data-services="vkontakte,facebook,odnoklassniki,viber,whatsapp,skype,telegram"></div>
              <!-- Add Yandex Share END -->
			  <?php if ($attribute_groups) { ?>
			  <div class="short-attr">                
                <?php $i = 0; ?>
                <?php foreach ($attribute_groups as $attribute_group) { ?>
                <?php if ($i < 8) { ?>
                <?php foreach ($attribute_group['attribute'] as $attribute) { ?>
                <?php if ($i < 8) { ?>
                <span><?php echo $attribute['name']; ?></span>
                <span><?php echo $attribute['text']; ?>,</span>
                <?php } ?>
                <?php $i++ ?>
                <?php } ?>
                <?php } ?>
                <?php $i++ ?>
                <?php } ?>
              </div>
			  <?php } ?>			  
			</div>
          </div>
        </div>
      </div>
      <div class="tabs-container tabs-theme">
      <ul class="nav nav-tabs">
        <li class="active"><a href="#tab-description" data-toggle="tab"><?php echo $tab_description; ?></a></li>
        <?php if ($attribute_groups) { ?>
        <li><a href="#tab-specification" data-toggle="tab"><?php echo $tab_attribute; ?></a></li>
        <?php } ?>
        <?php if ($review_status) { ?>
        <li><a href="#tab-review" data-toggle="tab"><?php echo $tab_review; ?></a></li>
        <?php } ?>
      </ul>
      <div class="card noborder">
        <div class="tab-content">
          <div class="tab-pane active" id="tab-description"><?php echo $description; ?></div>
          <?php if ($attribute_groups) { ?>        
          <div class="tab-pane" id="tab-specification">
            <h2 class="tab-pane-title"><?php echo $tab_attribute; ?> <?php echo $heading_title; ?></h2>
            <table class="table table-striped table-attributes">
              <?php foreach ($attribute_groups as $attribute_group) { ?>
              <thead>
                <tr>
                  <td colspan="2"><strong><?php echo $attribute_group['name']; ?></strong></td>
                </tr>
              </thead>
              <tbody>
                <?php foreach ($attribute_group['attribute'] as $attribute) { ?>
                <tr>
                  <td><?php echo $attribute['name']; ?></td>
                  <td><?php echo $attribute['text']; ?></td>
                </tr>
                <?php } ?>
              </tbody>
              <?php } ?>
            </table>
          </div>
          <?php } ?>
          <?php if ($review_status) { ?>
          <div class="tab-pane" id="tab-review">
            <?php if ($reviews > 0 ) { ?>
            <div class="rating-info-block">
              <div class="rating-info-wrapper">
                <div class="average-rating">Средний рейтинг:</div>
                <?php if ($review_status) { ?>
                <div class="rating">
                  <?php for ($i = 1; $i <= 5; $i++) { ?>
                  <?php if ($rating < $i) { ?>
                  <span class="star-empty"><i class="fa fa-star"></i></span>
                  <?php } else { ?>
                  <span class="star"><i class="fa fa-star"></i></span>
                  <?php } ?>
                  <?php } ?>      
                </div>
                <?php } ?>			
                <div class="based-review">
                  <div class="based-review-text">
				    <span>На основании</span> <?php echo $reviews; ?>
				  </div>
                </div>
              </div>
            </div>
            <?php } ?>		  
            <form class="form-review" id="form-review">
              <div id="review"></div>
              <a href="#CollapseReview" class="btn btn-border" data-toggle="collapse" aria-expanded="false" aria-controls="CollapseReview"><?php echo $text_write; ?></a>
              <?php if ($review_guest) { ?>
              <div id="CollapseReview" class="form-review-entry collapse">
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group required">              
                      <label class="control-label" for="input-name"><?php echo $entry_name; ?></label>
                      <input type="text" name="name" value="<?php echo $customer_name; ?>" id="input-name" class="form-control" />
                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="form-group required">             
                      <label class="control-label" for="input-review"><?php echo $entry_review; ?></label>
                      <textarea name="text" rows="5" id="input-review" class="form-control"></textarea>               
                    </div>
                    <div class="help-block"><?php echo $text_note; ?></div>
                  </div>
                  <div class="col-sm-12">
                    <div class="form-group required row">
                      <div class="col-sm-12">
                        <span class="input-title"><?php echo $entry_rating; ?></span>
                        <div class="review-rating">
                          <input id="rating_1" type="radio" name="rating" value="1">
                          <label class="review-star" for="rating_1">
                          <i class="fa fa-star"></i>
                          </label>
                          <input id="rating_2" type="radio" name="rating" value="2">
                          <label class="review-star" for="rating_2">
                          <i class="fa fa-star"></i>
                          </label>
                          <input id="rating_3" type="radio" name="rating" value="3">
                          <label class="review-star" for="rating_3">
                          <i class="fa fa-star"></i>
                          </label>
                          <input id="rating_4" type="radio" name="rating" value="4">
                          <label class="review-star" for="rating_4">
                          <i class="fa fa-star"></i>
                          </label>
                          <input id="rating_5" type="radio" name="rating" value="5">
                          <label class="review-star" for="rating_5">
                          <i class="fa fa-star"></i>
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <?php echo $captcha; ?>
                <div class="buttons clearfix">
                  <div class="pull-right">
                    <button type="button" id="button-review" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-primary"><?php echo $button_continue; ?></button>
                  </div>
                </div>
              </div>
              <?php } else { ?>
              <?php echo $text_login; ?>
              <?php } ?>
            </form>
          </div>
          <?php } ?>
        </div>
      </div>
        </div>
      <?php if ($products) { ?>
      <div class="product-card">
        <h3 class="cont-title"><?php echo $text_related; ?></h3>
        <div class="row">
          <?php $i = 0; ?>
          <?php foreach ($products as $product) { ?>
          <?php if ($column_left && $column_right) { ?>
          <?php $class = 'col-xs-8 col-sm-6'; ?>
          <?php } elseif ($column_left || $column_right) { ?>
          <?php $class = 'col-sm-6 col-lg-3 col-md-4 col-xs-6'; ?>
          <?php } else { ?>
          <?php $class = 'col-lg-20 col-sm-3 col-xs-6'; ?>
          <?php } ?>
          <div class="<?php echo $class; ?>">
            <div class="product-thumb transition">
              <div class="image">
                <a href="<?php echo $product['href']; ?>"><img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" title="<?php echo $product['name']; ?>" class="img-responsive" /></a>
                <div class="toolbar-icons">
                  <div class="wishlist-btn">
                    <span class="wishlist-item" title="<?php echo $button_wishlist; ?>" onclick="wishlist.add('<?php echo $product['product_id']; ?>');"><i></i></span>
                  </div>
                  
                </div>
              </div>
              <div class="caption">
                <a href="<?php echo $product['href']; ?>" class="product-name"><?php echo $product['name']; ?></a>
                <div class="product-des"><?php echo $product['description']; ?></div>
                <div class="rating">
                  <?php for ($i = 1; $i <= 5; $i++) { ?>
                  <?php if ($product['rating'] < $i) { ?>
                  <span class="star-empty"><i class="fa fa-star"></i></span>
                  <?php } else { ?>
                  <span class="star"><i class="fa fa-star"></i></span>
                  <?php } ?>
                  <?php } ?>
                </div>
              </div>
              <div class="price-button">
                <?php if ($product['price']) { ?>
                <div class="price">
                  <?php if (!$product['special']) { ?>
                  <span class="main-price"><?php echo $product['price']; ?></span>
                  <?php } else { ?>
                  <span class="price-new main-price">
                  <?php echo $product['special']; ?>
                  </span> 
                  <span class="price-old"><?php echo $product['price']; ?></span>				  
                  <?php } ?>
                  <?php if ($product['tax']) { ?>
                  <div class="tax-block">
                    <span class="price-tax"><?php echo $text_tax; ?> <?php echo $product['tax']; ?></span>
                  </div>
                  <?php } ?>
                </div>
                <?php } ?>				
                <div class="button-group">
                  <button type="button" class="btn btn-primary" onclick="cart.add('<?php echo $product['product_id']; ?>', '<?php echo $product['minimum']; ?>');"><i></i><span><?php echo $button_cart; ?></span></button>
                </div>
              </div>
            </div>
          </div>
          <?php if (($column_left && $column_right) && (($i+1) % 2 == 0)) { ?>
          <div class="clearfix visible-md visible-sm"></div>
          <?php } elseif (($column_left || $column_right) && (($i+1) % 3 == 0)) { ?>
          <div class="clearfix visible-md"></div>
          <?php } elseif (($i+1) % 4 == 0) { ?>
          <div class="clearfix visible-md"></div>
          <?php } ?>
          <?php $i++; ?>
          <?php } ?>
        </div>
      </div>
      <?php } ?>
      <?php if ($tags) { ?>
      <!-- Блок тегов -->
      <div class="tags-group">
        <h3><?php echo $text_tags; ?></h3>
        <ul class="tags-list">
          <?php for ($i = 0; $i < count($tags); $i++) { ?>
          <?php if ($i < (count($tags) - 1)) { ?>
          <li class="tags-item"><a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a></li>
          <?php } else { ?>
          <li class="tags-item"><a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a></li>
          <?php } ?>
          <?php } ?>
        </ul>
      </div>
      <!-- // Блок тегов  -->
      <?php } ?>
      <?php echo $content_bottom; ?>
    </div>
    <?php echo $column_right; ?>
  </div>
</div>
<script><!--
  $('select[name=\'recurring_id\'], input[name="quantity"]').change(function(){
  	$.ajax({
  		url: 'index.php?route=product/product/getRecurringDescription',
  		type: 'post',
  		data: $('input[name=\'product_id\'], input[name=\'quantity\'], select[name=\'recurring_id\']'),
  		dataType: 'json',
  		beforeSend: function() {
  			$('#recurring-description').html('');
  		},
  		success: function(json) {
  			$('.alert, .text-danger').remove();
  
  			if (json['success']) {
  				$('#recurring-description').html(json['success']);
  			}
  		}
  	});
  });
  //-->
</script>
<script><!--
  $('#button-cart').on('click', function() {
  	$.ajax({
  		url: 'index.php?route=checkout/cart/add',
  		type: 'post',
  		data: $('#product input[type=\'text\'], #product input[type=\'number\'], #product input[type=\'hidden\'], #product input[type=\'radio\']:checked, #product input[type=\'checkbox\']:checked, #product select, #product textarea'),
  		dataType: 'json',
  		beforeSend: function() {
			$('#cart > button').html('<i class="fa fa-circle-o-notch fa-spin"></i>');				
		},
		complete: function() {
			$('.fa-spin').remove();
			$('#cart > button').load('index.php?route=common/cart/info #cart > button > *');
		},
  		success: function(json) {
  			$('.alert, .text-danger').remove();
  			$('.form-group').removeClass('has-error');
  
  			if (json['error']) {
  				if (json['error']['option']) {
  					for (i in json['error']['option']) {
  						var element = $('#input-option' + i.replace('_', '-'));
  
  						if (element.parent().hasClass('input-group')) {
  							element.parent().after('<div class="text-danger">' + json['error']['option'][i] + '</div>');
  						} else {
  							element.after('<div class="text-danger">' + json['error']['option'][i] + '</div>');
  						}
  					}
  				}
  
  				if (json['error']['recurring']) {
  					$('select[name=\'recurring_id\']').after('<div class="text-danger">' + json['error']['recurring'] + '</div>');
  				}
  
  				// Highlight any found errors
  				$('.text-danger').parent().addClass('has-error');
  			}
  
  			if (json['success']) {
  				 
  
  				setTimeout(function() {
					$('.alert').animate({
						bottom: '-100%',
						opacity: '0',
					}, 1000);
				}, 10000);
				
				$('.js-cart-summary').html(json['total']);
				$("#add_card_popup").addClass("a");
  			}
  		},
          error: function(xhr, ajaxOptions, thrownError) {
              alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
          }
  	});
  });
  //-->
</script>
<script><!--
  $('.date').datetimepicker({
  	pickTime: false
  });
  
  $('.datetime').datetimepicker({
  	pickDate: true,
  	pickTime: true
  });
  
  $('.time').datetimepicker({
  	pickDate: false
  });
  
  $('button[id^=\'button-upload\']').on('click', function() {
  	var node = this;
  
  	$('#form-upload').remove();
  
  	$('body').prepend('<form enctype="multipart/form-data" id="form-upload" style="display: none;"><input type="file" name="file" /></form>');
  
  	$('#form-upload input[name=\'file\']').trigger('click');
  
  	if (typeof timer != 'undefined') {
      	clearInterval(timer);
  	}
  
  	timer = setInterval(function() {
  		if ($('#form-upload input[name=\'file\']').val() != '') {
  			clearInterval(timer);
  
  			$.ajax({
  				url: 'index.php?route=tool/upload',
  				type: 'post',
  				dataType: 'json',
  				data: new FormData($('#form-upload')[0]),
  				cache: false,
  				contentType: false,
  				processData: false,
  				beforeSend: function() {
  					$(node).button('loading');
  				},
  				complete: function() {
  					$(node).button('reset');
  				},
  				success: function(json) {
  					$('.text-danger').remove();
  
  					if (json['error']) {
  						$(node).parent().find('input').after('<div class="text-danger">' + json['error'] + '</div>');
  					}
  
  					if (json['success']) {
  						alert(json['success']);
  
  						$(node).parent().find('input').val(json['code']);
  					}
  				},
  				error: function(xhr, ajaxOptions, thrownError) {
  					alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
  				}
  			});
  		}
  	}, 500);
  });
  //-->
</script>
<script><!--
  $('#review').delegate('.pagination a', 'click', function(e) {
      e.preventDefault();
  
      $('#review').fadeOut('slow');
  
      $('#review').load(this.href);
  
      $('#review').fadeIn('slow');
  });
  
  $('#review').load('index.php?route=product/product/review&product_id=<?php echo $product_id; ?>');
  
  $('#button-review').on('click', function() {
  	$.ajax({
  		url: 'index.php?route=product/product/write&product_id=<?php echo $product_id; ?>',
  		type: 'post',
  		dataType: 'json',
  		data: $("#form-review").serialize(),
  		beforeSend: function() {
  			$('#button-review').button('loading');
  		},
  		complete: function() {
  			$('#button-review').button('reset');
  		},
  		success: function(json) {
  			$('.alert-success, .alert-danger').remove();
  
  			if (json['error']) {
  				$('#review').after('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error'] + '</div>');
  			}
  
  			if (json['success']) {
  				$('#review').after('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + json['success'] + '</div>');
  
  				$('input[name=\'name\']').val('');
  				$('textarea[name=\'text\']').val('');
  				$('input[name=\'rating\']:checked').prop('checked', false);
  			}
  		}
  	});
      grecaptcha.reset();
  });
  
  $(document).ready(function() {
  	$('.thumbnails').magnificPopup({
  		type:'image',
  		delegate: 'a',
  		gallery: {
  			enabled:true
  		}
  	});
  });
  
  $(document).ready(function() {
  	var hash = window.location.hash;
  	if (hash) {
  		var hashpart = hash.split('#');
  		var  vals = hashpart[1].split('-');
  		for (i=0; i<vals.length; i++) {
  			$('#product').find('select option[value="'+vals[i]+'"]').attr('selected', true).trigger('select');
  			$('#product').find('input[type="radio"][value="'+vals[i]+'"]').attr('checked', true).trigger('click');
  			$('#product').find('input[type="checkbox"][value="'+vals[i]+'"]').attr('checked', true).trigger('click');
  		}
  	}
  })
  //-->
</script>
<?php echo $footer; ?>