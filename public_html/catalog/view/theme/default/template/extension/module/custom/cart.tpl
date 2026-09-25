<?php if (!empty($products)) { ?>

<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" class="cart_product_box">
  
        <?php foreach ($products as $product) { ?>
<div class="cart_product c_p_sale">
            <div class="c_p_content">
              <div class="c_p_img_box">
                <img src="<?php echo $product['thumb']; ?>">
              </div>
              <h2 class="c_p_title">
               <?php echo $product['name']; ?>
              </h2>
              <div class="c_p_prise_box">
              <p> <?php echo $product['price']; ?> <? if ($product['oldprice']) {?>

						
								<strike><?php echo $product['oldprice']; ?></strike>
							
<? }?>   </p>
			  
              </div>
            </div>
            <div class="cart_quantity_controls">
              <label for="cart-quantity-<?php echo (int)$product['cart_id']; ?>">Количество</label>
              <input id="cart-quantity-<?php echo (int)$product['cart_id']; ?>" data-cart-id="<?php echo (int)$product['cart_id']; ?>" type="number" min="1" step="1" value="<?php echo (int)$product['quantity']; ?>" onchange="custom_cart.change('<?php echo (int)$product['cart_id']; ?>', event)">
              <span>Сумма: <?php echo $product['total']; ?></span>
            </div>
            <div class="c_p_close" onclick="custom_cart.remove('<?php echo $product['cart_id']; ?>');">
              <span></span>
              <span></span>
            </div>
          </div>

        <?php } ?>
     
</form>
<?php } ?>
