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
<section id="cart">
	<div class="container">
		<h1 class="cart_title">
			Корзина
		</h1>
		<div class="cart_flex">
<div class="cart_box">
  <?php echo $content_top; ?>
	
	<?php if (isset($errors)) { ?>
		<?php foreach($errors as $error) { ?>
			<div class="alert alert-warning"><?= $error; ?></div>
		<?php } ?>
	<?php } elseif (isset($empty)) {?>
		<div class="alert alert-info">Корзина пуста!</div>
	<?php } ?>

	<?php if (isset($cart)) { ?>
		<div id="custom-cart">
			<?php echo $cart; ?>
		</div>
	<?php } ?>



			<?php echo $column_left; ?>

			<?php if (isset($login) && !$logged) { ?>
				<div id="custom-login">
					<?php echo $login; ?>
				</div>
			<?php } ?>

			 <? if (isset($customer)) { ?>
				<div id="custom-customer"> 
					<?php echo $customer; ?>
				</div>
		 <? } ?>

			<?php if (isset($shipping) && $shipping !== false) { ?>
				<div id="custom-shipping">
					<?php echo $shipping; ?>
				</div>
			<?php } ?>

			<?php if (isset($payment)) { ?>
				<div id="custom-payment">
					<?php echo $payment; ?>
				</div>
			<?php } ?>	

			<?php if (isset($comment) && $comment !== false) { ?>
				<div id="custom-comment">
					<?php echo $comment; ?>
				</div>
			<?php } ?>
	<?php if (isset($payment)) { ?>
		<div class="buttons" id="custom-control">

  <div class="c_tl_promocode_btn">
    <input type="checkbox" name="agree" value="0" id="chagree" required>
    <label for="chagree">
      <span><svg><use xlink:href="#done"></use></svg></span>
      <p>Я проверил свой адрес e-mail, он введен верно</p>
    </label>
  </div>

  <div class="c_tl_promocode_btn">
    <input type="checkbox" name="consent_personal_data" id="consent_personal_data" required>
    <label for="consent_personal_data">
      <span><svg><use xlink:href="#done"></use></svg></span>
      <p>
        Я даю
        <a href="https://prokonkurs.com/privacy" target="_blank" style="color: #FF6A00; text-decoration: underline;">Согласие</a>
        на обработку своих персональных данных в соответствии с
        <a href="https://prokonkurs.com/privacy" target="_blank" style="color: #FF6A00; text-decoration: underline;">Политикой конфиденциальности</a>
      </p>
    </label>
  </div>

  <div class="c_tl_promocode_btn">
    <input type="checkbox" name="consent_public_offer" id="consent_public_offer" required>
    <label for="consent_public_offer">
      <span><svg><use xlink:href="#done"></use></svg></span>
      <p>
        Я принимаю условия
        <a href="https://prokonkurs.com/agreement" target="_blank" style="color: #FF6A00; text-decoration: underline;">оферты</a>
      </p>
    </label>
  </div>

  <button class="cart_form_btn" id="button-custom-order">
    <svg><use xlink:href="#cash-1"></use></svg>
    <span>Перейти к оплате</span>
  </button>
  <div class="clearfix"></div>
</div>
	<?php } ?>

	<?php echo $content_bottom; ?>

	<div id="custom-confirm" style="display: none;"></div>
		</div>

	<div class="cart_total_box">
<div class="cart_total_block">
			<?php echo $column_right; ?>

			

			<?php if (isset($total) && $total !== false) { ?>
				<div id="custom-total">
					<?php echo $total; ?>
				</div>
			<?php } ?>
			<?php if (isset($module) && $module !== false) { ?>
				<div id="custom-module">
					<?php echo $module; ?>
				</div>
			<?php } ?>
		</div>	</div>

	


	
</div>
	</div>
</section>
<script src="js/cart/script.js?<? echo time();?>"></script>
<script>
$(document).ready(function($) {
  $('#button-custom-order').on('click', function(){

    if (!$('#chagree').is(':checked')) {
      alert('Пожалуйста, подтвердите, что ваш e-mail указан верно.');
      return false;
    }
    if (!$('#consent_personal_data').is(':checked')) {
      alert('Пожалуйста, дайте согласие на обработку персональных данных.');
      return false;
    }
    if (!$('#consent_public_offer').is(':checked')) {
      alert('Пожалуйста, подтвердите согласие с офертой.');
      return false;
    }

    <?php if (!$logged) { ?>
      checkoutCustomer()
        <?php if (isset($login) && $login !== false) { ?>
          .then(checkoutLogin)
        <?php } ?>
        <?php if (isset($shipping) && $shipping !== false) { ?>
          .then(checkoutShipping)
        <?php } ?>
        .then(checkoutPayment)
        <?php if (isset($comment) && $comment !== false) { ?>
          .then(checkoutComment)
        <?php } ?>
        .then(checkoutConfirm)
        .catch(failureCallback);
    <?php } else { ?>
      <?php if (isset($shipping) && $shipping !== false) { ?>
        checkoutShipping()
          .then(checkoutPayment)
          <?php if (isset($comment) && $comment !== false) { ?>
            .then(checkoutComment)
          <?php } ?>
          .then(checkoutConfirm)
          .catch(failureCallback);
      <?php } else { ?>
        checkoutPayment()
          <?php if (isset($comment) && $comment !== false) { ?>
            .then(checkoutComment)
          <?php } ?>
          .then(checkoutConfirm)
          .catch(failureCallback);
      <?php } ?>
    <?php } ?>

  });
});
</script>

<?php echo $footer; ?>