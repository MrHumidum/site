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
<section id="cart" class="haramain-checkout">
	<div class="container">
		<h1 class="cart_title">
			Оформление заказа
		</h1>
        <p class="checkout-intro">Заполните данные, выберите доставку и перейдите к оплате. Доставка доступна в Мекке и Медине.</p>
        <ol class="checkout-progress"><li class="is-current" id="checkout-details-step">1. Оформление</li><li id="checkout-payment-step">2. Оплата</li><li>3. Проверка перевода</li></ol>
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
		<div id="custom-cart" class="checkout-section">
            <h2 class="checkout-section-title">Ваш заказ</h2>
			<?php echo $cart; ?>
		</div>
	<?php } ?>



			<?php echo $column_left; ?>

			<?php if (isset($login) && !$logged) { ?>
				<div id="custom-login">
					<?php echo $login; ?>
				</div>
			<?php } ?>

			 <?php if (isset($customer)) { ?>
				<div id="custom-customer"> 
					<?php echo $customer; ?>
				</div>
		 <?php } ?>

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

  <?php if (!empty($text_agree)) { ?>
  <label class="checkout-agreement"><input type="checkbox" name="agree" value="1" id="chagree" <?php echo !empty($agree) ? 'checked' : ''; ?> /> <span><?php echo $text_agree; ?></span></label>
  <?php } ?>
  <p class="checkout-payment-note">На следующем шаге появятся реквизиты для перевода и загрузка чека. Заказ подтвердит администратор после проверки оплаты.</p>
  <div id="checkout-error" class="alert alert-warning" role="alert" style="display:none"></div>
  <button type="button" class="cart_form_btn" id="button-custom-order">
    <svg><use xlink:href="#cash-1"></use></svg>
    <span>Перейти к оплате</span>
  </button>
  <div class="clearfix"></div>
</div>
	<?php } ?>

	<?php echo $content_bottom; ?>

	<section id="checkout-payment-stage" style="display:none" aria-label="Оплата заказа">
<h2 class="checkout-section-title">Оплата заказа</h2>
<button type="button" class="btn btn-default" id="checkout-edit-order">Изменить данные заказа</button>
<div id="custom-confirm" aria-live="polite"></div>
</section>
		</div>

	<div class="cart_total_box">
<div class="cart_total_block">
<h2 class="checkout-section-title">Итого</h2>
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

<script>
$(document).ready(function($) {
  $('#button-custom-order').on('click', function(){

    if (window.haramainCheckoutBusy) return;
    $('#checkout-error').hide().empty();
    if ($('#chagree').length && !$('#chagree').is(':checked')) {
      $('#checkout-error').text('Примите условия оформления заказа.').show();
      return;
    }
    window.haramainCheckoutBusy = true;
    $('#button-custom-order').prop('disabled', true).find('span').text('Оформляем заказ…');

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
        .catch(failureCallback).then(checkoutRelease);
    <?php } else { ?>
      <?php if (isset($shipping) && $shipping !== false) { ?>
        checkoutShipping()
          .then(checkoutPayment)
          <?php if (isset($comment) && $comment !== false) { ?>
            .then(checkoutComment)
          <?php } ?>
          .then(checkoutConfirm)
          .catch(failureCallback).then(checkoutRelease);
      <?php } else { ?>
        checkoutPayment()
          <?php if (isset($comment) && $comment !== false) { ?>
            .then(checkoutComment)
          <?php } ?>
          .then(checkoutConfirm)
          .catch(failureCallback).then(checkoutRelease);
      <?php } ?>
    <?php } ?>

  });
  $('#checkout-edit-order').on('click', checkoutEditOrder);
});
</script>

<?php echo $footer; ?>