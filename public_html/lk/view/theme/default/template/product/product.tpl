<?php echo $header; ?>
<style>
  /* -- Убираем фиксированную высоту и позволяем блоку подстраиваться под размер картинки -- */
  .good_slide {
      /* Если вам нужна одинаковая высота на Desktop, а на мобильных – автоматическая, 
         то ниже в @media делаем min-height: auto */
      position: relative;
      min-height: 445px; /* Оставили для больших экранов */
  }
  .good_slide img {
      display: block;
      width: 100%;
      height: auto;
  }

  /* -- На мобильных отключаем фиксированную высоту, чтобы изображение не растягивалось и не появлялись большие пустые пространства -- */
  @media (max-width: 768px) {
    .good_slide {
      min-height: auto !important; /* Мобильная версия: убираем фиксированную высоту */
    }
  }

  /* -- Настраиваем отступ между большим изображением и блоком мини-превью -- */
  .good_dots_slider {
      margin-top: 20px; /* Увеличьте или уменьшите по вкусу */
  }
</style>

<div class="sticky_padding"></div>

<div id="breadcrumbs">
  <div class="container">
    <div class="breadcrumbs_list">
      <?php foreach ($breadcrumbs as $i => $breadcrumb) { ?>
        <?php if ($i + 1 < count($breadcrumbs)) { ?>
          <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
          <span><svg><use xlink:href="#arrow-3"></use></svg></span>
        <?php } else { ?>
          <p><?php echo $breadcrumb['text']; ?></p>
        <?php } ?>
      <?php } ?>
    </div>
  </div>
</div>

<div class="back_btn_box">
  <div class="container">
    <a href="<?=$back?>" onclick="javascript:history.back(); return false;">
      <svg><use xlink:href="#arrow-3"></use></svg>
      <span>Вернуться назад</span>
    </a>
  </div>
</div>

<section id="good">
  <div class="container">
    <div class="good_box">
      <div class="good_img_box">
        <div class="good_slider_box">
          <div class="good_slider_arrow prev">
            <svg><use xlink:href="#arrow-1"></use></svg>
          </div>
          <div class="good_slider_arrow next">
            <svg><use xlink:href="#arrow-1"></use></svg>
          </div>
          <div class="good_slider">
            <div class="good_slide">
              <a href="<?php echo $popup; ?>">
                <img src="<?php echo $thumb; ?>">
              </a>
            </div>
            <?php if ($images) { ?>
              <?php foreach ($images as $image) { ?>
                <div class="good_slide">
                  <a href="<?php echo $image['popup']; ?>">
                    <img src="<?php echo $image['thumb']; ?>">
                  </a>
                </div>
              <?php } ?>
            <?php } ?>
          </div>
        </div>

        <div class="good_dots_slider">
          <div class="good_dots_slide">
            <div>
              <img src="<?php echo $thumb; ?>">
            </div>
          </div>
          <?php if ($images) { ?>
            <?php foreach ($images as $image) { ?>
              <div class="good_dots_slide">
                <div>
                  <img src="<?php echo $image['thumb']; ?>">
                </div>
              </div>
            <?php } ?>
          <?php } ?>
        </div>

        <?php
          $original_upc = $upc;
          $embed_code = '';
          $embed_url = '';

          if (!empty($upc)) {
            if (stripos($upc, '<iframe') !== false) {
              $embed_code = $upc;
            } elseif (strpos($upc, 'youtube.com') !== false || strpos($upc, 'youtu.be') !== false) {
              $url_components = parse_url($upc);
              if (isset($url_components['query'])) {
                parse_str($url_components['query'], $params);
                if (isset($params['v'])) {
                  $upc = $params['v'];
                }
              } elseif (strpos($upc, 'youtu.be/') !== false) {
                $parts = explode('/', $upc);
                $upc = end($parts);
              }
              $embed_url = "https://www.youtube.com/embed/$upc";
            } elseif (strpos($upc, 'rutube.ru/video/') !== false) {
              if (preg_match('/rutube\\.ru\/video\/([^\/]+)/i', $upc, $matches)) {
                $upc = $matches[1];
              }
              $embed_url = "https://rutube.ru/play/embed/$upc";
            } elseif (strpos($upc, 'vk.com') !== false || strpos($upc, 'vkvideo.ru') !== false) {
              $oid = $id = $hash = '';
              $url_components = parse_url($upc);
              if (isset($url_components['query'])) {
                parse_str($url_components['query'], $params);
                $oid = $params['oid'] ?? '';
                $id = $params['id'] ?? '';
                $hash = $params['hash'] ?? '';
              } else {
                if (preg_match('/video([-0-9]+)_([0-9]+)/i', $upc, $matches)) {
                  $oid = $matches[1];
                  $id = $matches[2];
                }
              }
              if ($oid && $id) {
                $embed_url = "https://vk.com/video_ext.php?oid=$oid&id=$id";
                if (!empty($hash)) {
                  $embed_url .= "&hash=$hash";
                }
              }
            }
          }
        ?>

        <?php if (!empty($embed_code)): ?>
          <div class="good_video_box">
            <div class="good_video">
              <?php echo $embed_code; ?>
            </div>
          </div>
        <?php elseif (!empty($embed_url)): ?>
          <div class="good_video_box">
            <div class="good_video">
              <iframe src="<?php echo $embed_url; ?>" frameborder="0" allowfullscreen></iframe>
            </div>
          </div>
        <?php endif; ?>
      </div>

      <div class="good_content_box" id="product">
        <div class="good_content_block">
          <h1><?php echo $heading_title; ?></h1>
          <div class="g_c_data_box">
            <div class="g_c_data g_c_data_view">
              <img src="img/card/view.svg">
              <p><? echo $viewed;?> просмотра(ов)</p>
            </div>
            <div class="g_c_data g_c_data_download">
              <img src="img/card/download.svg">
              <p><? echo  $prodano;?> скачиваний</p>
            </div>
          </div>
          <div class="g_c_category_tags_list">
            <p>Категории:</p>
            <ul>
            
 <?php foreach ($product_categories  as $cat) { ?>
              <li><a href="<? echo $cat['href'];?>"><? echo $cat['name'];?></a></li>
             <? } ?>
            </ul>
          </div>
          <? if ($avtor_name) {?>
          <div class="g_c_author_box">
            <p>Автор:</p>
            <div class="good_author"> <a href="<? echo $avtor_href;?>">
              <img src="<? echo $avtor_image;?>">
              <span><? echo $avtor_name;?></span> </a>
            </div>
          </div> <? } ?>
<div class="g_c_prise_box item_<?php echo $product_id; ?> <? if ($incart) {?> incart <? } ?>">
 <input type="hidden" name="product_id" value="<?php echo $product_id; ?>" />
<? if ($special) {?>
<div class="card_prise">
								<p><? echo $special;?></p>
								<strike><? echo $price;?></strike>
							</div>
<? } else {?>           
<p><? echo $price;?></p> <? } ?>

<button class="addcart" onclick="cart.add('<?php echo $product_id; ?>');"><svg><use xlink:href="#card"></use></svg><span>В корзину</span></button>
 <button class="removecart"  onclick="cart.removep('<?php echo $product_id; ?>');">
                    <svg><use xlink:href="#done"></use></svg><span>Уже в корзине</span>
                  </button>
          </div>
          <div class="g_c_text_box">
          <? echo $description;?>
          </div>
          <div class="g_c_kit_box">
            <h2>Комплект игры</h2>
       <? echo $description2;?>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>




      <?php if ($products) { ?>
<section id="good_alike">
  <div class="container">
    <h2 class="title good_alike_title">Похожие игры</h2>
    <div class="good_alike_box">
<?php foreach ($products as $product) { ?>
          <a href="<?php echo $product['href']; ?>" class="good_alike_item">
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

  </div> </div> </section>    


      <?php } ?>

      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<script type="text/javascript"><!--
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
//--></script>
<script type="text/javascript"><!--
$('#button-cart').on('click', function() {
	$.ajax({
		url: 'index.php?route=checkout/cart/add',
		type: 'post',
		data: $('#product input[type=\'text\'], #product input[type=\'hidden\'], #product input[type=\'radio\']:checked, #product input[type=\'checkbox\']:checked, #product select, #product textarea'),
		dataType: 'json',
		beforeSend: function() {
			$('#button-cart').button('loading');
		},
		complete: function() {
			$('#button-cart').button('reset');
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
		 
 $("#add_card_popup").addClass("a");
				$('.h_card').html( json['total'] );

				 
			}
		},
        error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
        }
	});
});
//--></script>
<script type="text/javascript"><!--
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
//--></script>
<script type="text/javascript"><!--
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
});

$(document).ready(function() {
	$('.good_slider').magnificPopup({
		type:'image',
		delegate: 'a',
		gallery: {
			enabled:true
		}
	});
});
//--></script>
<script src="js/card/card.js"></script>
<?php echo $footer; ?>