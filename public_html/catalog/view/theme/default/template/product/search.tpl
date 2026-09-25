<?php echo $header; ?>
<link rel="stylesheet" href="css/search/style.css">
  <link rel="stylesheet" href="media/search/media.css">
<div class="sticky_padding"></div>
<div id="breadcrumbs">
  <div class="container">
    <div class="breadcrumbs_list">

<?php foreach ($breadcrumbs as $i=> $breadcrumb) { ?>
<?php if($i+1<count($breadcrumbs)) { ?>
  <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a> <span><svg><use xlink:href="#arrow-3"></use></svg></span><?php } else { ?>
<p><?php echo $breadcrumb['text']; ?></p>
<?php } ?>
<?php } ?>

     
      
    </div>
  </div>
</div>


 
      
<section id="search">
  <div class="container">
    <div class="search_wrap">
      <div class="search_card_box">
        <div class="search_head">
          <div>
            <h2 class="title search_title"><?php echo $heading_title; ?></h2>
          </div>
          <p>Найдено: <span><?=$totals?> шт.</span></p>
        </div>

          <div class="search_card_list" id="listitem">
          
<?php foreach ($products as $product) { ?>
          <a href="<?php echo $product['href']; ?>" class="search_card_item">
            <div class="card c_sale item_<?php echo $product['product_id']; ?> <? if ($product['incart']) {?> incart <? } ?>">
             <?php if ($product['special']) { ?> <div class="card_sale_number"><p>-<span><?php echo $product['skidka']; ?></span>%</p></div> <? } ?>
              <img src="<?php echo $product['thumb']; ?>">
              <div class="card_content">
                <h3>
                 <?php echo $product['name']; ?>
                </h3>
                <p>
                 <?php echo $product['description']; ?>
                </p>
                <div class="card_action_box">
                  <div class="card_prise">
<?php if (!$product['special']) { ?>
            <p><span> <?php echo $product['price']; ?></span> </p>
          <?php } else { ?>
           <p><span><?php echo $product['special']; ?></span> </p>
                    <strike><span><?php echo $product['price']; ?></span> </strike>
        
          <?php } ?>

                   
                  </div>
                 <button class="card_btn addcart"  onclick="cart.add('<?php echo $product['product_id']; ?>');">
                    <svg><use xlink:href="#card"></use></svg>
                  </button>
                  <button class="card_btn removecart"  onclick="cart.removep('<?php echo $product['product_id']; ?>');">
                    <svg><use xlink:href="#done"></use></svg>
                  </button>
                </div>
              </div>
            </div>
          </a>
  <?php } ?>       
</div>
 <div class="category_pagination_box ">
<?php echo $pagination; ?>
        </div>
         
      </div>
    </div>
  </div>
</section>







<script type="text/javascript"><!--
$('#button-search').bind('click', function() {
	url = 'index.php?route=product/search';

	var search = $('#content input[name=\'search\']').prop('value');

	if (search) {
		url += '&search=' + encodeURIComponent(search);
	}

	var category_id = $('#content select[name=\'category_id\']').prop('value');

	if (category_id > 0) {
		url += '&category_id=' + encodeURIComponent(category_id);
	}

	var sub_category = $('#content input[name=\'sub_category\']:checked').prop('value');

	if (sub_category) {
		url += '&sub_category=true';
	}

	var filter_description = $('#content input[name=\'description\']:checked').prop('value');

	if (filter_description) {
		url += '&description=true';
	}

	location = url;
});

$('#content input[name=\'search\']').bind('keydown', function(e) {
	if (e.keyCode == 13) {
		$('#button-search').trigger('click');
	}
});

$('select[name=\'category_id\']').on('change', function() {
	if (this.value == '0') {
		$('input[name=\'sub_category\']').prop('disabled', true);
	} else {
		$('input[name=\'sub_category\']').prop('disabled', false);
	}
});

$('select[name=\'category_id\']').trigger('change');
--></script>
<?php echo $footer; ?>