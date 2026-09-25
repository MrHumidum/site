<section id="latest">
    <div class="container">

<h2 class="title popular_title"><?php echo $heading_title; ?></h2>
<div class="row">
  <?php foreach ($products as $product) { ?>
  <div class="product-layout col-lg-3 col-md-3 col-sm-6 col-xs-12">
    <a href="<?php echo $product['href']; ?>" class="popular_slide">
            <div class="card c_sale  item_<?php echo $product['product_id']; ?> <?php if (($product['incart'] ?? false)) { ?> incart <?php } ?>">
             <?php if ($product['special']) { ?> <div class="card_sale_number"><p>-<span><?php echo ($product['skidka'] ?? ''); ?></span>%</p></div> <?php } ?>
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
  </div>
  <?php } ?>
</div>
</div>
</section>