<div class="c_tl_promocode_box">
						<div class="c_tl_promocode_btn">
							<input name="promocode" id="promocode" type="checkbox">
							<label for="promocode">
								<span><svg><use xlink:href="#done"></use></svg></span>
								<p>Активировать промокод</p>
							</label>
						</div>
						<form class="c_tl_promocode_form">
							<div class="c_tl_promocode_form_block">
								<div class="c_tl_promocode_input">
									<div>
										<span>Промокод</span>
										<input name="coupon" value="<?php echo $coupon; ?>" required="" type="text">
									</div>
								</div>
								<button id="button-coupon"><svg><use xlink:href="#done"></use></svg></button>
							</div>
						</form>
					</div>
 
      <script type="text/javascript"><!--
	  
	  
$( "#promocode" ).change(function() {
$('.c_tl_promocode_form').toggleClass('showed');
});

$('#button-coupon').on('click', function(e) {
e.preventDefault();
	$.ajax({
		url: 'index.php?route=extension/total/coupon/coupon',
		type: 'post',
		data: 'coupon=' + encodeURIComponent($('input[name=\'coupon\']').val()),
		dataType: 'json',
		beforeSend: function() {
			$('#button-coupon').button('loading');
		},
		complete: function() {
			$('#button-coupon').button('reset');
		},
		success: function(json) {
			$('.alert').remove();

			if (json['error']) {
				$('.c_tl_promocode_btn').after('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');

				//$('html, body').animate({ scrollTop: 0 }, 'slow');
			}

			if (json['redirect']) {
				location = json['redirect'];
			}
		}
	});
});
//--></script>
  
