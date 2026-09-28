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

<section id="category">
  <div class="container">
    <div class="category_wrap">
      <div class="c_c_head mob">
        <h2 class="title c_c_title"><?php echo $heading_title; ?></h2>
       
      </div>

<?php echo $column_left; ?>

<div class="category_card_box">
        <div class="c_c_head desk">
          <h2 class="title c_c_title"><?php echo $heading_title; ?></h2>
         
        </div>
  <?php if ($products) { ?>
<div class="category_card_list" id="listitem">
 <?php foreach ($products as $product) { ?>
          <a href="<?php echo $product['href']; ?>" class="category_card_item">
            <div class="card c_sale item_<?php echo $product['product_id']; ?> ">
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

        <div class="category_pagination_box">
<?php echo $pagination; ?>
        </div>

<?php } ?> 

      
<div class="category_text_box">
          
           <?php if (!$products) { ?>
      <p><?php echo $text_empty; ?></p>

      <?php } ?>
        </div>
      </div>
    </div>
  </div>
</section>
<style>
.hidemanuf { display: none !important;}
</style>
     
      <?php //echo $content_bottom; ?>


    <?php //echo $column_right; ?>
<script src="js/category/category.js"></script>
<?php echo $footer; ?>
