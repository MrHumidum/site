<div class="bank-transfer" data-manual-step="1">
  <h2 class="bank-transfer_title"><?php echo $text_instruction; ?></h2>
  <p class="bank-transfer_total">К оплате: <strong><?php echo $payment_total; ?></strong></p>
  <p class="bank-transfer_lead"><?php echo $text_description; ?></p>

  <?php if ($cards) { ?>
  <ul class="bt_cards">
    <?php foreach ($cards as $card) { ?>
    <li class="bt_card">
      <div class="bt_card_info">
        <span class="bt_card_bank"><?php echo htmlspecialchars($card['bank'], ENT_QUOTES, 'UTF-8'); ?></span>
        <span class="bt_card_number"><?php echo htmlspecialchars($card['number'], ENT_QUOTES, 'UTF-8'); ?></span>
        <?php if ($card['holder']) { ?>
        <span class="bt_card_holder"><?php echo $text_card_holder; ?>: <?php echo htmlspecialchars($card['holder'], ENT_QUOTES, 'UTF-8'); ?></span>
        <?php } ?>
      </div>
      <button type="button" class="bt_copy" data-card="<?php echo $card['copy']; ?>"><?php echo $text_copy; ?></button>
    </li>
    <?php } ?>
  </ul>
  <?php } elseif ($bank) { ?>
  <div class="bt_plain"><?php echo $bank; ?></div>
  <?php } else { ?>
  <div class="alert alert-warning"><?php echo $text_no_cards; ?></div>
  <?php } ?>

  <div class="bt_receipt">
    <h3 class="bt_receipt_title"><?php echo $text_receipt; ?></h3>
    <p class="bt_receipt_help"><?php echo $text_receipt_help; ?></p>

    <input type="file" id="bt-receipt-file" <?php if (!$can_pay) { echo 'disabled'; } ?> accept=".jpg,.jpeg,.png,.pdf,image/jpeg,image/png,application/pdf" />
    <label for="bt-receipt-file" class="bt_receipt_btn"><?php echo $text_receipt_choose; ?></label>

    <div class="bt_receipt_state" id="bt-receipt-state"<?php echo ($receipt ? '' : ' style="display:none;"'); ?>>
      <?php echo $text_receipt_current; ?>: <span id="bt-receipt-name"><?php echo htmlspecialchars($receipt, ENT_QUOTES, 'UTF-8'); ?></span>
    </div>
    <div class="bt_receipt_error text-danger" id="bt-receipt-error" style="display:none;"></div>
  </div>

  <p class="bank-transfer_note"><?php echo $text_payment; ?></p>

  <div class="buttons">
    <input type="button" value="<?php echo $button_confirm; ?>" id="button-confirm" <?php if (!$can_pay) { echo 'disabled'; } ?> class="btn btn-primary cart_form_btn" data-loading-text="<?php echo $text_loading; ?>" />
  </div>

  <div class="bt_toast" id="bt-toast" aria-live="polite"></div>
</div>

<script type="text/javascript"><!--
(function($) {
  var uploadUrl = <?php echo json_encode(html_entity_decode($upload, ENT_QUOTES, 'UTF-8')); ?>;
  var paymentToken = <?php echo json_encode($payment_token); ?>;
  var uploading = false;
  var textCopied = '<?php echo addslashes($text_copied); ?>';
  var textCopyFailed = '<?php echo addslashes($text_copy_failed); ?>';
  var errorReceiptRequired = '<?php echo addslashes($error_receipt_required); ?>';
  var toastTimer;

  function toast(message) {
    var $toast = $('#bt-toast');
    $toast.text(message).addClass('a');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function() { $toast.removeClass('a'); }, 2500);
  }

  // Copy a card number without spaces.
  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }

    return new Promise(function(resolve, reject) {
      var helper = document.createElement('textarea');
      helper.value = text;
      helper.setAttribute('readonly', '');
      helper.style.position = 'fixed';
      helper.style.left = '-9999px';
      document.body.appendChild(helper);
      helper.select();

      try {
        document.execCommand('copy') ? resolve() : reject();
      } catch (e) {
        reject(e);
      }

      document.body.removeChild(helper);
    });
  }

  $(document).off('click.btCopy').on('click.btCopy', '.bt_copy', function() {
    copyText($(this).attr('data-card')).then(function() {
      toast(textCopied);
    }, function() {
      toast(textCopyFailed);
    });
  });

  $(document).off('change.btReceipt').on('change.btReceipt', '#bt-receipt-file', function() {
    if (!this.files || !this.files.length) {
      return;
    }

    var form = new FormData();
    form.append('file', this.files[0]);
    form.append('payment_token', paymentToken);
    uploading = true;
    $('#checkout-edit-order').prop('disabled', true);
    $('#button-confirm').prop('disabled', true);
    $('#bt-receipt-state').hide();

    $('#bt-receipt-error').hide().text('');

    $.ajax({
      url: uploadUrl,
      type: 'post',
      dataType: 'json',
      data: form,
      cache: false,
      contentType: false,
      processData: false,
      beforeSend: function() {
        $('.bt_receipt_btn').addClass('loading');
      },
      complete: function() {
        $('.bt_receipt_btn').removeClass('loading');
        uploading = false;
        $('#checkout-edit-order').prop('disabled', false);
        $('#button-confirm').prop('disabled', false);
      },
      success: function(json) {
        if (json.error) {
          $('#bt-receipt-error').text(json.error).show();
          return;
        }

        if (json.success) {
          $('#bt-receipt-name').text(json.filename);
          $('#bt-receipt-state').show();
          toast(json.success);
        }
      },
      error: function(xhr) {
        $('#bt-receipt-error').text(xhr.statusText).show();
      }
    });
  });

  $(document).off('click.btConfirm').on('click.btConfirm', '#button-confirm', function() {
    var $button = $(this);

    if (uploading || !$('#bt-receipt-state').is(':visible')) {
      $('#bt-receipt-error').text(errorReceiptRequired).show();
      return;
    }

    $.ajax({
      url: 'index.php?route=extension/payment/bank_transfer/confirm',
      type: 'post',
      data: {payment_token: paymentToken},
      dataType: 'json',
      beforeSend: function() {
        $button.prop('disabled', true);
        $('#checkout-edit-order').prop('disabled', true);
      },
      success: function(json) {
        if (json.error) {
          $button.prop('disabled', false);
          $('#checkout-edit-order').prop('disabled', false);
          $('#bt-receipt-error').text(json.error).show();
          return;
        }

        if (json.success) {
          location = json.success;
        }
      },
      error: function(xhr) {
        $button.prop('disabled', false);
          $('#checkout-edit-order').prop('disabled', false);
        $('#bt-receipt-error').text(xhr.statusText).show();
      }
    });
  });
})(jQuery);
//--></script>
