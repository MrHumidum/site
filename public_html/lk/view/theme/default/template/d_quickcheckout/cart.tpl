<div id="cart_view" class="cart_product_box" data-col="<?php echo $col; ?>" data-row="<?php echo $row; ?>"></div>
<script type="text/html" id="cart_template">

 

					<% _.each(model.products, function(product) { %>
					
		<div class="cart_product c_p_sale">
						<div class="c_p_content">
							<div class="c_p_img_box">
								<img src="<%= product.image %>">
							</div>
							<h2 class="c_p_title">
								<%= product.name %>
							</h2>
							<div class="c_p_prise_box">
								<%= product.price %>
							</div>
						</div>
						<div class="c_p_close">
							<span></span>
							<span></span>
						</div>
					</div>				

					
					
						

					<% }) %>
					<% _.each(model.vouchers, function(voucher) { %>
			       
			        <% }) %>
					
				

			<div class="form-horizontal">
				<div class=" form-group qc-coupon <%= parseInt(model.config.option.coupon.display) ? '' : 'hidden' %>">
					<% if(model.errors.coupon){ %>
						<div class="col-sm-12">
							<div class="alert alert-danger">
								<i class="fa fa-exclamation-circle"></i> <%= model.errors.coupon %>
							</div>
						</div>
					<% } %>
					<% if(model.successes.coupon){ %>
						<div class="col-sm-12">
							<div class="alert alert-success">
								<i class="fa fa-exclamation-circle"></i> <%= model.successes.coupon %>
							</div>
						</div>
					<% } %>
					<label class="col-sm-4 control-label" >
						<?php echo $text_use_coupon; ?>
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input type="text" value="<%= model.coupon ? model.coupon : '' %>" name="coupon" id="coupon" <% if(Number(config.design.placeholder)) {  %>placeholder="<?php echo $text_use_coupon; ?>" <% } %>  class="form-control"/>
							<span class="input-group-btn">
								<button class="btn btn-primary" id="confirm_coupon" type="button"><i class="fa fa-check"></i></button>
							</span>
						</div>
					</div>
					<% _.each(model.coupon, function(voucher) { %>
			        
			        <% }) %>
				</div>
				<div class=" form-group qc-voucher <%= parseInt(model.config.option.voucher.display) ? '' : 'hidden' %>">
					<% if(model.errors.voucher){ %>
						<div class="col-sm-12">
							<div class="alert alert-danger">
								<i class="fa fa-exclamation-circle"></i> <%= model.errors.voucher %>
							</div>
						</div>
					<% } %>
					<% if(model.successes.voucher){ %>
						<div class="col-sm-12">
							<div class="alert alert-success">
								<i class="fa fa-exclamation-circle"></i> <%= model.successes.voucher %>
							</div>
						</div>
					<% } %>

					<label class="col-sm-4 control-label" >
						<?php echo $text_use_voucher; ?>
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input type="text" value="<%= model.voucher ? model.voucher : '' %>" name="voucher" id="voucher" <% if(Number(config.design.placeholder)) {  %>placeholder="<?php echo $text_use_voucher; ?>" <% } %>  class="form-control"/>
							<span class="input-group-btn">
								<button class="btn btn-primary" id="confirm_voucher" type="button"><i class="fa fa-check"></i></button>
							</span>
						</div>
					</div>
				</div>
				<?php if($reward_points) {?>
				<div class=" form-group qc-reward <%= parseInt(model.config.option.reward.display) ? '' : 'hidden' %>">
					<% if(model.errors.reward){ %>
						<div class="col-sm-12">
							<div class="alert alert-danger">
								<i class="fa fa-exclamation-circle"></i> <%= model.errors.reward %>
							</div>
						</div>
					<% } %>
					<% if(model.successes.reward){ %>
						<div class="col-sm-12">
							<div class="alert alert-success">
								<i class="fa fa-exclamation-circle"></i> <%= model.successes.reward %>
							</div>
						</div>
					<% } %>
					<label class="col-sm-4 control-label" >
						<?php echo $text_use_reward; ?>
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input type="text" value="<%= model.reward ? model.reward : '' %>" name="reward" id="reward" <% if(Number(config.design.placeholder)) {  %>placeholder="<?php echo $text_use_reward; ?>" <% } %> class="form-control"/>
							<span class="input-group-btn">
								<button class="btn btn-primary" id="confirm_reward" type="button"><i class="fa fa-check"></i></button>
							</span>

						</div>
						<small><?php echo $entry_reward; ?></small>
					</div>

				</div>
				<?php } ?>
			</div>
			<% if(model.show_price){ %>
			<div class="form-horizontal qc-totals">
				<% _.each(model.totals, function(total) { %>
				<div class="row">
					<label class="col-sm-9 col-xs-6 control-label" ><%= total.title %></label>
					<div class="col-sm-3 col-xs-6 form-control-static text-right"><%= total.text %></div>
				</div>
				<% }) %>
			</div>
			<% } %>
			<div class="preloader row"><img class="icon" src="image/<%= config.general.loader %>" /></div>
		
		</div>
	</div>

</script>
<script>
$(function() {
	qc.cart = $.extend(true, {}, new qc.Cart(<?php echo $json; ?>));
	qc.cartView = $.extend(true, {}, new qc.CartView({
		el:$("#cart_view"), 
		model: qc.cart, 
		template: _.template($("#cart_template").html())
	}));

});

</script>