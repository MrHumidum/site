const custom_block = {

	'render': function(block){
		$.ajax({
			url: 'index.php?route=checkout/custom/render',
			type: 'get',
			data: {'block': block},
			dataType: 'html',
			beforeSend: function(){
				$('#custom-' + block).addClass('custom_lock');
				//$('#button-custom-order').button('loading');
			},
			success: function(html) {
				setTimeout(function(){
					$('#custom-' + block).html(html).removeClass('custom_lock');
				}, 1000);
			},
      complete: function(){
        $('#button-custom-order').button('reset');
      },
			error: function(xhr, ajaxOptions, thrownError) {
				console.log(thrownError);
			}
		});
	},

  'customer': function(value){
    $.ajax({
      url: 'index.php?route=extension/module/custom/customer/update&customer_group_id=' + value,
      dataType: 'json',
      success: function(json) {
        $('[id^=customer-field]').hide();
        $('[id^=customer-field]').removeClass('required');

        for (i = 0; i < json.length; i++) {
          field = json[i];

          $('#customer-field-' + field.name).show();

          if (field['required']) {
            $('#customer-field-' + field.name).addClass('required');
          }
        }
      },
      error: function(xhr, ajaxOptions, thrownError) {
        console.log(thrownError);
      }
    });
  },

  'shipping': function(value){
    $.ajax({
      url: 'index.php?route=extension/module/custom/shipping/update&shipping_method=' + value,
      dataType: 'json',
      success: function(json) {

        if (json.length === 0) {
          $('#custom-shipping-address').hide();
        } else {
          $('#custom-shipping-address').show();
        }

        $('[id^=shipping-field]').hide();
        $('[id^=shipping-field]').removeClass('required');

        for (i = 0; i < json.length; i++) {
          field = json[i];

          $('#shipping-field-' + field['name']).show();

          if (field['required']) {
            $('#shipping-field-' + field['name']).addClass('required');
          }
        }

        setTimeout(function(){
          custom_block.render('total');
        }, 100);
      },
      error: function(xhr, ajaxOptions, thrownError) {
        console.log(thrownError);
      }
    });
  },

  'payment': function(value){
    $.ajax({
      url: 'index.php?route=extension/module/custom/payment/update&customer_group_id=' + value,
      dataType: 'json',
      success: function(json) {

        var methods = $('#custom-payment [name=payment_method]');
        methods.parents('.radio').show();
        var available = methods.filter(function() { return !this.disabled; });
        if (!available.filter(':checked').length) available.first().prop('checked', true);
        available.filter(':checked').trigger('change');
      },
      error: function(xhr, ajaxOptions, thrownError) {
        console.log(thrownError);
      }
    });
  }

}

function checkoutLogin(){

  return new Promise( (resolve, reject) => {

    $.ajax({
      url: 'index.php?route=extension/module/custom/login/save',
      type: 'post',
      data: $('#custom-login input[type=\'radio\']:checked'),
      dataType: 'json',
      beforeSend: function(){
        //$('#button-custom-order').button('loading');
      },
      success: function(json) {
        console.log(json);
        resolve();
      },
      complete: function(){
        // The complete checkout sequence controls the submit button.
      },
      error: function(xhr, ajaxOptions, thrownError) {
        reject('network');
      }
    });

  });

}

function checkoutCustomer(){

  return new Promise( (resolve, reject) => {

    $.ajax({
      url: 'index.php?route=extension/module/custom/customer/save',
      type: 'post',
      data: $('#custom-customer input[type=\'text\'], #custom-customer input[type=\'date\'], #custom-customer input[type=\'datetime-local\'], #custom-customer input[type=\'time\'], #custom-customer input[type=\'checkbox\']:checked, #custom-customer input[type=\'radio\']:checked, #custom-customer input[type=\'hidden\'], #custom-customer input[type=\'password\'], #custom-customer textarea, #custom-customer select'),
      dataType: 'json',
      beforeSend: function(){
        //$('#button-custom-order').button('loading');
      },
      success: function(json) {

        console.log(json)

        $('.alert, .text-danger').remove();
        $('.has-error').removeClass('has-error');
        
        if (json['redirect']) {
          // location = json['redirect'];
        } else if (json['error']) {

          if (json['error']['warning']) {
              $('#custom-customer').prepend('<div class="alert alert-warning">' + json['error']['warning'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
          }

          for (i in json['error']) {
            var element = $('#customer-field-' + i.replace('_', '-'));
            $(element).append('<div class="text-danger">' + json['error'][i] + '</div>');

          }

          $('.text-danger').parent().addClass('has-error');

          reject('customer');

        }

        resolve();

      },
      complete: function(){
        // The complete checkout sequence controls the submit button.
      },
      error: function(xhr, ajaxOptions, thrownError) {
        reject('network');
      }
    });

  });

}

function checkoutShipping(){

  return new Promise( (resolve, reject) => {
    $.ajax({
      url: 'index.php?route=extension/module/custom/shipping/save',
      type: 'post',
      data: $('#custom-shipping input[type=\'text\'], #custom-shipping input[type=\'date\'], #custom-shipping input[type=\'datetime-local\'], #custom-shipping input[type=\'time\'], #custom-shipping input[type=\'checkbox\']:checked, #custom-shipping input[type=\'radio\']:checked, #custom-shipping input[type=\'hidden\'], #custom-shipping textarea, #custom-shipping select'),
      dataType: 'json',
      beforeSend: function(){
       // $('#button-custom-order').button('loading');
      },
      success: function(json) {

        console.log(json)

        $('.alert, .text-danger').remove();
        $('.has-error').removeClass('has-error');
        
        if (json['redirect']) {
           // location = json['redirect'];
        } else if (json['error']) {

          if (json['error']['warning']) {
              $('#custom-shipping').prepend('<div class="alert alert-warning">' + json['error']['warning'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
          }

          for (i in json['error']) {
            var element = $('#shipping-field-' + i.replace('_', '-'));
            $(element).append('<div class="text-danger">' + json['error'][i] + '</div>');

          }

          $('.text-danger').parent().addClass('has-error');

          reject('shipping');
        }
        
        resolve();

      },
      complete: function(){
        // The complete checkout sequence controls the submit button.
      },
      error: function(xhr, ajaxOptions, thrownError) {
        reject('network');
      }
    });
  });  
}

function checkoutPayment(){
  return new Promise( (resolve, reject) => {
    $.ajax({
      url: 'index.php?route=extension/module/custom/payment/save',
      type: 'post',
      data: $('#custom-payment input[name=\'payment_method\']:checked, #custom-control input[name=\'agree\']:checked'),
      dataType: 'json',
      beforeSend: function(){
        //$('#button-custom-order').button('loading');
      },
      success: function(json) {

        console.log(json)

        $('#custom-payment .alert, #ccustom-control .alert').remove();
        
        if (json['redirect']) {
           // location = json['redirect'];
        } else if (json['error']) {

          if (json['error']['payment_method']) {
            $('#custom-payment').prepend('<div class="alert alert-warning">' + json['error']['payment_method'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
            reject('payment');
          }

          if (json['error']['agree']) {
            $('#custom-control').prepend('<div class="alert alert-warning">' + json['error']['agree'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
            reject('control');
          }

        }

        resolve();

      },
      complete: function(){
        // The complete checkout sequence controls the submit button.
      },
      error: function(xhr, ajaxOptions, thrownError) {
        reject('network');
      }
    });
  });  
}

function checkoutComment(){
  return new Promise( (resolve, reject) => {
    $.ajax({
      url: 'index.php?route=extension/module/custom/comment/save',
      type: 'post',
      data: $('#custom-comment textarea'),
      dataType: 'json',
      beforeSend: function(){
       // $('#button-custom-order').button('loading');
      },
      success: function(json) {

        console.log(json)

        $('.alert').remove();
        
        if (json['error']) {

          if (json['error']['warning']) {
              $('#custom-comment').prepend('<div class="alert alert-warning">' + json['error']['warning'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
          }

          reject('comment');
        }

        resolve();

      },
      complete: function(){
        // The complete checkout sequence controls the submit button.
      },
      error: function(xhr, ajaxOptions, thrownError) {
        reject('network');
      }
    });
  });
}

function checkoutConfirm() {
  return new Promise(function(resolve, reject) {
    $.ajax({
      url: 'index.php?route=checkout/confirm',
      dataType: 'html',
      success: function(html) {
        $('#custom-confirm').html(html).show();
        $('#checkout-payment-stage').show();
        $('#custom-customer, #custom-login, #custom-shipping, #custom-payment, #custom-comment, #custom-control, #custom-cart, #custom-module').hide();
        $('#checkout-details-step').removeClass('is-current');
        $('#checkout-payment-step').addClass('is-current');
        $('html, body').animate({scrollTop: $('#checkout-payment-stage').offset().top - 30}, 250);
        resolve();
      },
      error: function() { reject('network'); }
    });
  });
}

function checkoutRelease() {
  window.haramainCheckoutBusy = false;
  $('#button-custom-order').prop('disabled', false).find('span').text('Перейти к оплате');
}

function checkoutEditOrder() {
  if ($('#checkout-edit-order').prop('disabled')) return;
  $('#checkout-payment-stage').hide();
  $('#custom-confirm').empty();
  $('#custom-customer, #custom-login, #custom-shipping, #custom-payment, #custom-comment, #custom-control, #custom-cart, #custom-module').show();
  $('#checkout-details-step').addClass('is-current');
  $('#checkout-payment-step').removeClass('is-current');
  checkoutRelease();
}

function failureCallback(id) {
  var target = $('#custom-' + id);
  if (id === 'network' || !target.length) {
    target = $('#checkout-error');
    target.text('Не удалось сохранить заказ. Проверьте соединение и попробуйте ещё раз.').show();
  }
  if (target.length) $('html, body').animate({scrollTop: target.offset().top - 30}, 250);
}
