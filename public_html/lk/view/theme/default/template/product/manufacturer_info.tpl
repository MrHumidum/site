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

<section id="author">
  <div class="container">
    <div class="author_box">
      <div class="author_img">
        <img src="<? echo $image;?>">
      </div>
      <div class="author_content">
        <div class="author_content_block">
          <h1>
<?php echo $heading_title; ?>
          </h1>
          <div class="author_text_box">
            <?php echo $description; ?>
          </div>
          <div class="author_action_box">
             <a href="<? echo $allproduct;?>">
              Смотреть все игры автора
            </a>
            <div>
              <p>Всего у автора игр:</p><span><? echo $count;?> шт.</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>



<section id="author_game">
  <div class="container">
    <h2 class="author_game_title">
      Игры автора
    </h2>
   
      <?php if ($products) { ?>
      <div class="author_game_box">
        <?php foreach ($products as $product) { ?>
      <a href="<?php echo $product['href']; ?>">
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
                    <strike><span><?php echo $product['price']; ?></span></strike>
        
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
     
      <?php } else { ?>
      <p><?php echo $text_empty; ?></p>
      
      <?php } ?>
      <?php echo $content_bottom; ?>
	 <a href="<? echo $allproduct;?>"> <button class="author_game_all_btn">Смотреть все игры автора</button> </a>
	  </div>
   </section>
 
<?php echo $footer; ?>