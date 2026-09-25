<div class="panel panel-default">
  <div class="panel-heading"><?= $heading_payment ?></div>
  <div class="panel-body">

    <?php if ($error_warning) { ?>
    <div class="alert alert-warning"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?></div>
    <?php } ?>

    <?php if ($payment_methods) { ?>
    <?php foreach ($payment_methods as $payment_method) { ?>
    <div class="radio">
      <label>
        <?php if ($payment_method['code'] == $code || !$code) { ?>
        <?php $code = $payment_method['code']; ?>
        <input type="radio" name="payment_method" value="<?php echo $payment_method['code']; ?>" checked="checked" />
        <?php } else { ?>
        <input type="radio" name="payment_method" value="<?php echo $payment_method['code']; ?>" />
        <?php } ?>
        <?php echo $payment_method['title']; ?>
        <?php if ($payment_method['terms']) { ?>
        (<?php echo $payment_method['terms']; ?>)
        <?php } ?>
        <?php if (isset($payment_method['description'])) { ?>
        <br /><small><?php echo $payment_method['description']; ?></small>
        <?php } ?>
      </label>
    </div>
    <?php } ?>
    <?php } ?>

    <script>
    $(function(){

        let customer_group_id = <?php echo $customer_group_id ?>;
        
        if ( $('#custom-customer input[name=\'customer_group_id\']:checked').val() != undefined ) {
            customer_group_id = $('#custom-customer input[name=\'customer_group_id\']:checked').val();
        }

        custom_block.payment( customer_group_id );
        
    });
    </script>

  </div>
</div>