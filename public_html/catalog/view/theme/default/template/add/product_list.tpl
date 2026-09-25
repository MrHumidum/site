<?php echo $header; ?> <div class="sticky_padding"></div>
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


<section id="office">
  <div class="container">
 <a href="/index.php?route=add/product/add"><button class="add_product_btn">Добавить товар</button></a>
       <div class="office_box">
<?php echo $acc; ?> 
      <div class="office_block">
  <div class="page-header">
    <div class="container-fluid">
	<h1>Мои товары</h1>
      <div class="pull-right"> 
        <button type="submit" form="form-product" formaction="<?php echo $copy; ?>" data-toggle="tooltip" title="копировать" class="btn btn-default"><i class="fa fa-copy"></i></button>
        <button type="button" data-toggle="tooltip" title="Включить" class="btn btn-default" onclick="$('#form-product').attr('action', '<?php echo $enabled; ?>').submit()"><i class="fa fa-play"></i></button>
		 <button type="button" data-toggle="tooltip" title="Отключить" class="btn btn-default" onclick="$('#form-product').attr('action', '<?php echo $disabled; ?>').submit()"><i class="fa fa-pause"></i></button> 
		<button type="button" data-toggle="tooltip" title="удалить" class="btn btn-danger" onclick="confirm('Подтвердить удаление') ? $('#form-product').submit() : false;"><i class="fa fa-trash-o"></i></button>
      </div>
       
     
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <?php if ($success) { ?>
    <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <div class="panel panel-default">
       
      <div class="panel-body">

        <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form-product">
          <div class="table-responsive">
            <table class="table table-bordered table-hover">
              <thead>
                <tr>
                  <td style="width: 1px;" class="text-center"><input type="checkbox" onclick="$('input[name*=\'selected\']').prop('checked', this.checked);" /></td>
                  <td class="text-center"><?php echo $column_image; ?></td>
                  <td class="text-left"><?php if ($sort == 'pd.name') { ?>
                    <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">Название товары</a>
                    <?php } else { ?>
                    <a href="<?php echo $sort_name; ?>">Название товары</a>
                    <?php } ?></td>
                   <td class="text-center">Статус</td>
                  <td class="text-right"><?php if ($sort == 'p.price') { ?>
                    <a href="<?php echo $sort_price; ?>" class="<?php echo strtolower($order); ?>"><?php echo $column_price; ?></a>
                    <?php } else { ?>
                    <a href="<?php echo $sort_price; ?>"><?php echo $column_price; ?></a>
                    <?php } ?></td>
                   
                  
				 
                  <td class="text-right"><?php echo $column_action; ?></td>
                </tr>
              </thead>
              <tbody>
                <?php if ($products) { ?>
                <?php foreach ($products as $product) { ?>
                <tr>
                  <td class="text-center"><?php if (in_array($product['product_id'], $selected)) { ?>
                    <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" checked="checked" />
                    <?php } else { ?>
                    <input type="checkbox" name="selected[]" value="<?php echo $product['product_id']; ?>" />
                    <?php } ?></td>
                  <td class="text-center"><?php if ($product['image']) { ?>
                    <img src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" class="img-thumbnail" />
                    <?php } else { ?>
                    <span class="img-thumbnail list"><i class="fa fa-camera fa-2x"></i></span>
                    <?php } ?></td>
                  <td class="text-left"><?php echo $product['name']; ?></td>
                   <td class="text-left"><?php echo $product['status']; ?></td>
                  <td class="text-right"><?php if ($product['special']) { ?>
                    <span style="text-decoration: line-through;"><?php echo $product['price']; ?></span><br/>
                    <div class="text-danger"><?php echo $product['special']; ?></div>
                    <?php } else { ?>
                    <?php echo $product['price']; ?>
                    <?php } ?></td>
                   
                 
				  
                  <td class="text-right">
				  <a target="_blank" href="<?php echo $product['href_shop']; ?>" data-toggle="tooltip" title="<?php echo $button_shop; ?>" class="btn btn-success"><i class="fa fa-eye"></i></a>
				  <a href="<?php echo $product['edit']; ?>" data-toggle="tooltip" title="<?php echo $button_edit; ?>" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
				  </td>
                </tr>
                <?php } ?>
                <?php } else { ?>
                <tr>
                  <td class="text-center" colspan="8">Вы не добавили ни одной товары</td>
                </tr>
                <?php } ?>
              </tbody>
            </table>
          </div>
        </form>
        <div class="row">
          <div class="col-sm-9 text-left"><?php echo $pagination; ?></div>
          <div class="col-sm-3 text-right"><?php echo $results; ?></div>
        </div>
      </div>
    </div>
  </div>
  <script type="text/javascript"><!--
$('#button-filter').on('click', function() {
	var url = 'index.php?route=catalog/product&token=<?php echo $token; ?>';

	var filter_name = $('input[name=\'filter_name\']').val();

	if (filter_name) {
		url += '&filter_name=' + encodeURIComponent(filter_name);
	}

	var filter_model = $('input[name=\'filter_model\']').val();

	if (filter_model) {
		url += '&filter_model=' + encodeURIComponent(filter_model);
	}

	var filter_price_min = $('input[name=\'filter_price_min\']').val();

	if (filter_price_min) {
		url += '&filter_price_min=' + encodeURIComponent(filter_price_min);
	}

	var filter_price_max = $('input[name=\'filter_price_max\']').val();

	if (filter_price_max) {
		url += '&filter_price_max=' + encodeURIComponent(filter_price_max);
	}

	var filter_quantity_min = $('input[name=\'filter_quantity_min\']').val();

	if (filter_quantity_min) {
		url += '&filter_quantity_min=' + encodeURIComponent(filter_quantity_min);
	}

	var filter_quantity_max = $('input[name=\'filter_quantity_max\']').val();

	if (filter_quantity_max) {
		url += '&filter_quantity_max=' + encodeURIComponent(filter_quantity_max);
	}

	var filter_status = $('select[name=\'filter_status\']').val();

	if (filter_status != '*') {
		url += '&filter_status=' + encodeURIComponent(filter_status);
	}
	
	var filter_category = $('input[name=\'filter_category\']').val();

	if (filter_category) {
		url += '&filter_category=' + encodeURIComponent(filter_category);
	}

	var filter_sub_category = $('input[name=\'filter_sub_category\']');

	if (filter_sub_category.prop('checked')) {
		url += '&filter_sub_category';
	}

	var filter_manufacturer = $('input[name=\'filter_manufacturer\']').val();

	if (filter_manufacturer) {
		url += '&filter_manufacturer=' + encodeURIComponent(filter_manufacturer);
	}
	
	var filter_noindex = $('select[name=\'filter_noindex\']').val();
	
	if (filter_noindex != '*') {
		url += '&filter_noindex=' + encodeURIComponent(filter_noindex);
	}

  var filter_image = $('select[name=\'filter_image\']').val();

  if (filter_image != '*') {
    url += '&filter_image=' + encodeURIComponent(filter_image);
  }

	location = url;
});
$('#button-clear-filter').on('click', function() {
	location = 'index.php?route=catalog/product&token=<?php echo $token; ?>';
});
//--></script>
  <script type="text/javascript"><!--
$('input[name=\'filter_name\']').autocomplete({
	'source': function(request, response) {
		$.ajax({
			url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request),
			dataType: 'json',
			success: function(json) {
				response($.map(json, function(item) {
					return {
						label: item['name'],
						value: item['product_id']
					}
				}));
			}
		});
	},
	'select': function(item) {
		$('input[name=\'filter_name\']').val(item['label']);
	}
});
$('#button-clear-input-name').on('click',function(){
	$('input[name=\'filter_name\']').val('');
	$('#button-filter').trigger('click');
});

$('input[name=\'filter_model\']').autocomplete({
	'source': function(request, response) {
		$.ajax({
			url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_model=' +  encodeURIComponent(request),
			dataType: 'json',
			success: function(json) {
				response($.map(json, function(item) {
					return {
						label: item['model'],
						value: item['product_id']
					}
				}));
			}
		});
	},
	'select': function(item) {
		$('input[name=\'filter_model\']').val(item['label']);
	}
});

$('#button-clear-input-model').on('click',function(){
	$('input[name=\'filter_model\']').val('');
	$('#button-filter').trigger('click');
});
$('input[name=\'filter_category_name\']').autocomplete({
	'source': function(request, response) {
		if ($('input[name=\'filter_category_name\']').val().length==0) {
			$('input[name=\'filter_category\']').val(null);
		}
		$.ajax({
			url: 'index.php?route=catalog/category/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request),
			dataType: 'json',
			success: function(json) {
				if (json.length>0) {
					json.unshift({'category_id':null,'name':'<?php echo $text_all; ?>'},{'category_id':0,'name':'<?php echo $text_none_category; ?>'});
				}
				response($.map(json, function(item) {
					return {
						label: item['name'],
						value: item['category_id']
					}
				}));
			}
		});
	},
	'select': function(item) {
		if (item['label']!='<?php echo $text_all; ?>') {
			$('input[name=\'filter_category_name\']').val(item['label']);
		} else {
			$('input[name=\'filter_category_name\']').val('');
		}
		$('input[name=\'filter_category\']').val(item['value']);
	}
});

$('#button-clear-input-category-name').on('click',function(){
	$('input[name=\'filter_category_name\']').val('');
	$('input[name=\'filter_category\']').val(null);
	$('#button-filter').trigger('click');
});

$('input[name=\'filter_manufacturer_name\']').autocomplete({
	'source': function(request, response) {
		if ($('input[name=\'filter_manufacturer_name\']').val().length==0) {
			$('input[name=\'filter_manufacturer\']').val(null);
		}
		$.ajax({
			url: 'index.php?route=catalog/manufacturer/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request),
			dataType: 'json',
			success: function(json) {
				if (json.length>0) {
					json.unshift({'manufacturer_id':null,'name':'<?php echo $text_all; ?>'},{'manufacturer_id':0,'name':'<?php echo $text_none_manufacturer; ?>'});
				}
				response($.map(json, function(item) {
					return {
						label: item['name'],
						value: item['manufacturer_id']
					}
				}));
			}
		});
	},
	'select': function(item) {
		if (item['label']!='<?php echo $text_all; ?>') {
			$('input[name=\'filter_manufacturer_name\']').val(item['label']);
		} else {
			$('input[name=\'filter_manufacturer_name\']').val('');
		}
		$('input[name=\'filter_manufacturer\']').val(item['value']);
	}
});

$('#button-clear-input-manufacturer-name').on('click',function(){
	$('input[name=\'filter_manufacturer_name\']').val('');
	$('input[name=\'filter_manufacturer\']').val(null);
	$('#button-filter').trigger('click');
});

$('#button-clear-input-price-min').on('click',function(){
	$('input[name=\'filter_price_min\']').val('');
	$('#button-filter').trigger('click');
});

$('#button-clear-input-price-max').on('click',function(){
	$('input[name=\'filter_price_max\']').val('');
	$('#button-filter').trigger('click');
});

$('#button-clear-input-quantity-min').on('click',function(){
	$('input[name=\'filter_quantity_min\']').val('');
	$('#button-filter').trigger('click');
});

$('#button-clear-input-quantity-max').on('click',function(){
	$('input[name=\'filter_quantity_max\']').val('');
	$('#button-filter').trigger('click');
});

$('input[name=\'filter_name\'], input[name=\'filter_model\'], input[name=\'filter_category_name\'], input[name=\'filter_manufacturer_name\'], input[name=\'filter_price_min\'], input[name=\'filter_price_max\'], input[name=\'filter_quantity_min\'], input[name=\'filter_quantity_max\']').keypress(function (e) {
	if (e.which == 13) {
		$('#button-filter').trigger('click');
		return false;
	}
});
//--></script></div>
  </div>
    </div>
  <style>
.all-g_view_btn_box { display: none; }
  </style>
}
</section>
<?php echo $footer; ?>