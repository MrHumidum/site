<div class="cart_form_box">
 
<h2 class="cart_form_title">
            <img src="img/man.svg">
            <span>Данные покупателя</span>
          </h2>
    <?php foreach ($setting['fields'] as $field) { ?>

      <?php if ($field['name'] === 'firstname') { ?>
        <div class="cart_form_input <? if (strlen($firstname)>2) {?> a <? } ?>" id="customer-field-firstname">
          <div><span  for="customer-input-firstname"><?php echo $entry_firstname; ?></span>
          <input type="text" name="customer_firstname" value="<?php echo $firstname; ?>" id="customer-input-firstname"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'lastname') { ?>
        <div class="cart_form_input" id="customer-field-lastname">
          <div><span  for="customer-input-lastname"><?php echo $entry_lastname; ?></span>
          <input type="text" name="customer_lastname" value="<?php echo $lastname; ?>" placeholder="<?php echo $entry_lastname; ?>" id="customer-input-lastname"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'email') { ?>
        <div class="cart_form_input <? if (strlen($email)>2) {?> a <? } ?>" id="customer-field-email">
          <div><span  for="customer-input-email"><?php echo $entry_email; ?></span>
          <input type="text" name="customer_email" value="<? echo $email;?>" id="customer-input-email"  data-validation="<?php echo $field['validation']; ?>" />
        </div><p>На E-mail придёт подтверждение заказа</p>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'telephone') { ?>
        <div class="cart_form_input <? if (strlen($telephone)>2) {?> a <? } ?> " id="customer-field-telephone">
          <div><span  for="customer-input-telephone"><?php echo $entry_telephone; ?></span>
          <input type="text" name="customer_telephone" value="<?  echo $telephone;?>" id="customer-input-telephone"  data-validation="<?php echo $field['validation']; ?>" />
        </div><p>Нужен курьеру для связи по доставке</p>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'fax') { ?>
        <div class="cart_form_input" id="customer-field-fax">
          <div><span  for="customer-input-fax"><?php echo $entry_fax; ?></span>
          <input type="text" name="customer_fax" value="<?php echo $fax; ?>" placeholder="<?php echo $entry_fax; ?>" id="customer-input-fax"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'password') { ?>
        <div class="cart_form_input" id="customer-field-password">
          <div><span  for="customer-input-password"><?php echo $entry_password; ?></span>
          <input type="password" name="customer_password" value="<?php echo $password; ?>" placeholder="<?php echo $entry_password; ?>" id="customer-input-password"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if ($field['name'] === 'confirm') { ?>
        <div class="cart_form_input" id="customer-field-confirm">
          <div><span  for="customer-input-confirm"><?php echo $entry_confirm; ?></span>
          <input type="password" name="customer_confirm" value="<?php echo $confirm; ?>" placeholder="<?php echo $entry_confirm; ?>" id="customer-input-confirm"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
       </div> <?php continue; ?>
      <?php } ?>

      <?php if (substr($field['name'], 0, 12) === 'custom_field') { ?>

        <?php $custom_field_id = (int)str_replace('custom_field', '', $field['name']); ?>

        <?php foreach ($custom_fields as $custom_field) { ?>
        <?php if ($custom_field['custom_field_id'] == $custom_field_id) { ?>
        
        <?php if ($custom_field['type'] == 'select') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <select name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>" >
            <option value=""><?php echo $text_select; ?></option>
            <?php foreach ($custom_field['custom_field_value'] as $custom_field_value) { ?>
            <option value="<?php echo $custom_field_value['custom_field_value_id']; ?>"><?php echo $custom_field_value['name']; ?></option>
            <?php } ?>
          </select>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'radio') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <span ><?php echo $custom_field['name']; ?></span>
          <div id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>">
            <?php foreach ($custom_field['custom_field_value'] as $custom_field_value) { ?>
            <div class="radio">
              <span>
                <input type="radio" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="<?php echo $custom_field_value['custom_field_value_id']; ?>" />
                <?php echo $custom_field_value['name']; ?></span>
            </div>
            <?php } ?>
          </div>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'checkbox') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <span ><?php echo $custom_field['name']; ?></span>
          <div id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>">
            <?php foreach ($custom_field['custom_field_value'] as $custom_field_value) { ?>
            <div class="checkbox">
              <span>
                <input type="checkbox" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>[]" value="<?php echo $custom_field_value['custom_field_value_id']; ?>" />
                <?php echo $custom_field_value['name']; ?></span>
            </div>
            <?php } ?>
          </div>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'text') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <input type="text" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="<?php echo $custom_field['value']; ?>" placeholder="<?php echo $custom_field['name']; ?>" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"  data-validation="<?php echo $field['validation']; ?>" />
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'textarea') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <textarea name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" rows="5" placeholder="<?php echo $custom_field['name']; ?>" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>" ><?php echo $custom_field['value']; ?></textarea>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'file') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <span ><?php echo $custom_field['name']; ?></span>
          <br />
          <button type="button" id="button-custom-field<?php echo $custom_field['custom_field_id']; ?>" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-default"><i class="fa fa-upload"></i> <?php echo $button_upload; ?></button>
          <input type="hidden" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>" />
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'date') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <div class="input-group date">
            <input type="text" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="<?php echo $custom_field['value']; ?>" placeholder="<?php echo $custom_field['name']; ?>" data-date-format="YYYY-MM-DD" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"  />
            <span class="input-group-btn">
            <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
            </span></div>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'time') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <div class="input-group time">
            <input type="text" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="<?php echo $custom_field['value']; ?>" placeholder="<?php echo $custom_field['name']; ?>" data-date-format="HH:mm" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"  />
            <span class="input-group-btn">
            <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
            </span></div>
        </div>
        <?php } ?>
        <?php if ($custom_field['type'] == 'datetime') { ?>
        <div id="customer-field-custom-field<?php echo $custom_field['custom_field_id']; ?>" class="cart_form_input custom-field" data-sort="<?php echo $custom_field['sort_order']; ?>">
          <div><span  for="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"><?php echo $custom_field['name']; ?></span>
          <div class="input-group datetime">
            <input type="text" name="customer_custom_field<?php echo $custom_field['custom_field_id']; ?>" value="<?php echo $custom_field['value']; ?>" placeholder="<?php echo $custom_field['name']; ?>" data-date-format="YYYY-MM-DD HH:mm" id="input-custom-field<?php echo $custom_field['custom_field_id']; ?>"  />
            <span class="input-group-btn">
            <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
            </span></div>
        </div>
        <?php } ?>
        <?php } ?>
        <?php } ?>

      <?php } ?>

    <?php } ?>

   
</div>

<script><!--


 
  const cartInputBlock = $(".cart_form_input"),
      cartInput = $(".cart_form_input input"),
      cartBtn = $(".cart_form_btn");

  const focusInput = function() {
    $(this).parents(".cart_form_input").addClass("a");
  }

  const clickFocusInput = function() {
    
    let thisInput = $(this).find("input"),  
      thisText = $(this).find("span");

    $(this).addClass("a");
    thisInput.focus();
  }

  const unFocusInput = function() {
    if ( $(this).val() == "" ){
      let thisInputBlock = $(this).parents(".cart_form_input");
      thisInputBlock.removeClass("a");
    }
  }

  cartInputBlock.click(clickFocusInput);
  cartInput.focus(focusInput);
  cartInput.blur(unFocusInput);




$('#custom-customer [name^=customer]').on('input', function() {
  $(this).parent().find('.text-danger').remove();
  $(this).parent().removeClass('has-error');
});
//--></script>

<script><!--
$('#custom-customer input[name=\'customer_group_id\']').on('change', function() {

  // Customer
  custom_block.customer(this.value);

  // Payment Methods
  custom_block.payment(this.value);

});

$('#custom-customer input[name=\'customer_group_id\']:checked').trigger('change');
//--></script>

<script><!--
$('#custom-customer button[id^=\'button-custom-field\']').on('click', function() {
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
						$(node).parent().parent().parent().find('input[name^=\'custom_field\']').after('<div class="text-danger">' + json['error'] + '</div>');
					}

					if (json['success']) {
						alert(json['success']);

						$(node).parent().find('input[name^=\'custom_field\']').val(json['code']);
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

