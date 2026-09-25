<?php echo $header; ?> <div class="sticky_padding"></div>
<link rel="stylesheet" href="css/all_game/style.css">
  <link rel="stylesheet" href="media/all_game/media.css">
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


<section id="all-g">
  <div class="container">
    <div class="all-g_wrap">
      <div class="all-g_card_box">
        <div class="all-g_head">
          <div>
            <h2 class="title all-g_title">Все игры</h2>
            <h3 class="subtitle all-g_subtitle">Просто листай вниз и выбирай из всех, представленных на сайте игр</h3>
          </div>
          <p>Игр в категории: <span><?=$totals?> шт.</span></p>
        </div>
        <div class="all-g_card_list" id="listitem">
<?php foreach ($products as $product) { ?>
          <a href="<?php echo $product['href']; ?>" class="all-g_card_item">
            <div class="card c_sale item_<?php echo $product['product_id']; ?> <? if ($product['incart']) {?> incart <? } ?>">
             <?php if ($product['special']) { ?> <div class="card_sale_number"><p>-<span><?php echo $product['skidka']; ?></span>%</p></div> <? } ?>
             <div class="card_img_box"><div class="card_tags_list">
                  <ul>
                     <?php foreach (array_slice($product['product_categories'], 0, 2)  as $cat) { ?>
              <li><? echo $cat['name'];?></li>
             <? } ?>
                   
                  </ul>
                  <? if ($product['also']>0) {?><p>и ещё <? echo $product['also'];?></p> <? } ?>
                </div>
              <img src="<?php echo $product['thumb']; ?>">
</div>
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
                    <strike><span><?php echo $product['price']; ?></span> ₽</strike>
        
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
 <div class="category_pagination_box hidepage">
<?php echo $pagination; ?>
        </div>
         
      </div>
    </div>
  </div>
</section>
<?php echo $footer; ?>