<?php

/**
 * @var \YooMoneyModule\Model\KassaModel $kassa
 */
?>
<style type="text/css">

    .yoomoney-pay-button {
        font-family: YandexSansTextApp-Regular, Arial, Helvetica, sans-serif;
        text-align: center;
        height: 60px;
        width: 155px;
        border-radius: 4px;
        transition: 0.1s ease-out 0s;
        color: #000;
        box-sizing: border-box;
        outline: 0;
        border: 0;
        background: #FFDB4D;
        cursor: pointer;
        font-size: 12px;
    }

    .yoomoney-pay-button:hover, .yoomoney-pay-button:active {
        background: #f2c200;
    }

    .yoomoney-pay-button span {
        display: block;
        font-size: 20px;
        line-height: 20px;
    }

    .yoomoney-pay-button_type_fly {
        box-shadow: 0 1px 0 0 rgba(0, 0, 0, 0.12), 0 5px 10px -3px rgba(0, 0, 0, 0.3);
    }
</style>

<?php if ($fullView) : ?>
<?php echo $header; ?>
<?php echo $column_left; ?>
<?php echo $column_right; ?>
<div class="container">
    <?php echo $content_top; ?>
    <?php endif; ?>
    <?php if (!$kassa->getEPL()) : ?>
    <h3><?php echo $kassa->getDisplayName(); ?></h3>
    <?php endif; ?>
    <form method="post" action="" id="yoomoney-payment-form">
        <?php if ($kassa->getEPL()) : ?>
            <input type="hidden" name="kassa_payment_method" value="" />
        <?php endif; ?>

        <?php if (!$kassa->getEPL() || ($kassa->getEPL())) : ?>
        <div class="buttons">
            <div class="pull-right">
                <button class="btn btn-primary" id="continue-button" type="button" data-loading-text="<?php echo $language->get('text_loading'); ?>"><?php echo $language->get('text_continue'); ?></button>
            </div>
        </div>
        <?php endif; ?>
    </form>
    <div id="payment-form" style="display: none;"></div>
    <script type="text/javascript">
        var paymentType = jQuery('input[name=kassa_payment_method]');
        paymentType.change(function () {
            var id = '#payment-' + jQuery(this).val();
            jQuery('.additional').css('display', 'none');
            jQuery(id).css('display', 'block');
        });

        var continueButton = '#quick-checkout-button-confirm, #continue-button';
        jQuery(document).off('click.j3', continueButton).on('click.j3', continueButton, function (e) {
            e.preventDefault();
            e.stopPropagation();
            createPayment(jQuery(this));
        });

        function buttonAction(button, action) {
            if (jQuery.fn.button && button) {
                button.button(action);
            }
        }

        function createPayment(button) {
            button = button || null;
            var form = jQuery("#yoomoney-payment-form")[0];
            jQuery('#payment-form').hide();
            jQuery.ajax({
                url: "<?php echo $validate_url; ?>",
                dataType: "json",
                method: "GET",
                data: {
                    paymentType: form.kassa_payment_method.value
                },
                beforeSend: function() {
                    buttonAction(button, 'loading');
                },
                success: function (data) {
                    if (data.success) {
                        document.location = data.redirect;
                    } else {
                        onValidateError(data.error);
                        buttonAction(button, 'reset');
                    }
                },
                failure: function () {
                    onValidateError('Failed to create payment');
                    buttonAction(button, 'reset');
                }
            });
        }

        function onValidateError(errorMessage) {
            var warning = jQuery('#yoomoney-payment-form .alert');
            if (warning.length > 0) {
                warning.fadeOut(300, function () {
                    warning.remove();
                    var content = '<div class="alert alert-danger">' + errorMessage + '<button type="button" class="close" data-dismiss="alert">×</button></div>';
                    jQuery('#yoomoney-payment-form').prepend(content);
                    jQuery('#yoomoney-payment-form .alert').fadeIn(300);
                });
            } else {
                var content = '<div class="alert alert-danger">' + errorMessage + '<button type="button" class="close" data-dismiss="alert">×</button></div>';
                jQuery('#yoomoney-payment-form').prepend(content);
                jQuery('#yoomoney-payment-form .alert').fadeIn(300);
            }
        }
        </script>
    <?php if ($fullView) : ?>
    <?php echo $content_bottom; ?>
</div>
<?php echo $footer; ?>
<?php endif; ?>
