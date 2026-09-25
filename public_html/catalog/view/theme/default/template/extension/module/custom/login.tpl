<div class="panel panel-default hidden">
  <div class="panel-heading"><?= $heading_login ?></div>
  <div class="panel-body">
    <div class="radio">
      <label>
        <?php if ($account == 'register') { ?>
        <input type="radio" name="account" value="register"  />
        <?php } else { ?>
        <input type="radio" name="account" value="register" />
        <?php } ?>
        <?php echo $text_register; ?></label>
    </div>

    <?php if ($checkout_guest) { ?>
    <div class="radio">
      <label>
        <?php if ($account == 'guest') { ?>
        <input type="radio" name="account" value="guest" checked="checked" />
        <?php } else { ?>
        <input type="radio" name="account" value="guest" checked="checked" />
        <?php } ?>
        <?php echo $text_guest; ?></label>
    </div>
    <?php } ?>

    <div class="radio">
      <label>
        <?php if ($account == 'auth') { ?>
        <input type="radio" name="account" value="auth"  />
        <?php } else { ?>
        <input type="radio" name="account" value="auth" />
        <?php } ?>
        <?php echo $text_auth; ?></label>
    </div>

    <form id="auth-form" <?= $account !== 'auth' ? 'style="display: none;"' : '' ?> >
      <div class="form-group">
        <label class="control-label" for="input-email"><?php echo $entry_email; ?></label>
        <input type="text" name="email" value="" placeholder="<?php echo $entry_email; ?>" id="input-email" class="form-control" />
      </div>
      <div class="form-group">
        <label class="control-label" for="input-password"><?php echo $entry_password; ?></label>
        <input type="password" name="password" value="" placeholder="<?php echo $entry_password; ?>" id="input-password" class="form-control" />
        <a href="<?php echo $forgotten; ?>"><?php echo $text_forgotten; ?></a></div>
        <input type="submit" value="<?php echo $button_login; ?>" id="button-login" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-primary" />
    </form>

  </div>
</div>  

<script>
  $('[name=account]').on('change', function(event){

    $('#custom-login .panel-body').find('.alert').remove();
    let account = event.target.value;

    $.ajax({
      url: 'index.php?route=extension/module/custom/login/save',
      data: {'account': account},
      dataType: 'json',
      type: 'post',
      success: function(){
        custom_block.render('customer');
      },
      error: function(xhr, ajaxOptions, thrownError) {
        console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
      }
    });

    if (account === 'auth') {

      $('#auth-form').show();

      $('#custom-customer').hide();
      $('#custom-shipping').hide();
      $('#custom-payment').hide();
      $('#custom-comment').hide();
      $('#custom-module').hide();
      $('#custom-total').hide();
      $('#custom-confirm').hide();

    } else {

      $('#auth-form').hide();

      $('#custom-customer').show();
      $('#custom-shipping').show();
      $('#custom-payment').show();
      $('#custom-comment').show();
      $('#custom-module').show();
      $('#custom-total').show();
      $('#custom-confirm').show();

    }

  });
  $(document).ready(function($) {
    $('[name=account]:checked').trigger('change'); 
  });

  $('#auth-form').on('submit', function(event){

    event.preventDefault();

    $.ajax({
      url: 'index.php?route=checkout/login/save',
      data: $(this).serialize(),
      dataType: 'json',
      type: 'post',
      success: function(json){

        if (json['redirect']) {
          location = json['redirect'];
        } else if (json['error']) {
          if (json['error']['warning']) {
            $('#custom-login .panel-body').prepend('<div class="alert alert-danger">' + json['error']['warning'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
          }
        }
      },
      error: function(xhr, ajaxOptions, thrownError) {
        console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
      }
    });

  });

</script>