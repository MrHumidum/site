<section id="popular">
  <div class="local_container">
    <div class="popular_box">
      <div class="popular_head_box">
        <h2 class="title popular_title">Популярное</h2>
        <h3 class="subtitle popular_subtitle">Купленные максимальное количество раз за последние 7 дней</h3>
        <div class="popular_arrow_box">
          <button class="prev"><svg><use xlink:href="#arrow-2"></use></svg></button>
          <button class="next"><svg><use xlink:href="#arrow-2"></use></svg></button>
        </div>
      </div>
      <div class="popular_slider_box">
        <div class="popular_slider">
        <?php foreach ($products as $product) { ?>
          <a href="<?php echo $product['href']; ?>" class="popular_slide">
            <div class="card c_sale  item_<?php echo $product['product_id']; ?> <? if ($product['incart']) {?> incart <? } ?>">
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
      </div>
    </div>
  </div>
</section>
 