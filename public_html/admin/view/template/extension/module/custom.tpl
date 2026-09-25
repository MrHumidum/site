<?php echo $header; ?>
<?php echo $column_left; ?>
<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="submit" form="form-latest" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
        <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <?php if (isset($success)) { ?>
    <div class="alert alert-success"><i class="fa fa-exclamation-circle"></i> <?php echo $success; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3>
      </div>
      <div class="panel-body">
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-module" class="form-horizontal">
					<ul class="nav nav-tabs">
						<li class="active"><a href="#tab-general" data-toggle="tab"><?php echo $tab_general; ?></a></li>
						<li><a href="#tab-login" data-toggle="tab"><?php echo $tab_login; ?></a></li>
						<li><a href="#tab-cart" data-toggle="tab"><?php echo $tab_cart; ?></a></li>
						<li><a href="#tab-customer" data-toggle="tab"><?php echo $tab_customer; ?></a></li>
						<li><a href="#tab-shipping" data-toggle="tab"><?php echo $tab_shipping; ?></a></li>
						<li><a href="#tab-payment" data-toggle="tab"><?php echo $tab_payment; ?></a></li>
						<li><a href="#tab-comment" data-toggle="tab"><?php echo $tab_comment; ?></a></li>
						<li><a href="#tab-module" data-toggle="tab"><?php echo $tab_module; ?></a></li>
						<li><a href="#tab-total" data-toggle="tab"><?php echo $tab_total; ?></a></li>
						<li><a href="#tab-about" data-toggle="tab"><?php echo $tab_about; ?></a></li>
					</ul>
					<div class="tab-content">
						<div class="tab-pane active" id="tab-general">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
								<div class="col-sm-10">
									<select name="custom_status" id="input-status" class="form-control">
										<?php if ($custom_status) { ?>
										<option value="1" selected="selected"><?php echo $text_enabled; ?></option>
										<option value="0"><?php echo $text_disabled; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_enabled; ?></option>
										<option value="0" selected="selected"><?php echo $text_disabled; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-general-theme"><span data-toggle="tooltip" title="<?php echo $help_theme; ?>"><?php echo $entry_theme; ?></span></label>
								<div class="col-sm-10">
									<select name="custom_general[theme]" id="input-general-theme" class="form-control" readonly>
										<option value="bootstrap3" selected="selected">Bootstrap 3</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-general-setting"><span data-toggle="tooltip" title="<?php echo $help_setting; ?>"><?php echo $entry_setting; ?></span></label>
								<div class="col-sm-10">
									<select name="custom_general[setting]" id="input-general-setting" class="form-control" readonly>
										<option value="0" selected="selected">Без настроек</option>
									</select>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="tab-login">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-login-status"><span data-toggle="tooltip" title="<?php echo $help_login; ?>"><?php echo $entry_view; ?></span></label>
								<div class="col-sm-10">
									<select name="custom_login[status]" id="input-login-status" class="form-control">
										<?php if ($custom_login['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="tab-cart">
							<?php if (!empty($error_cart)) { ?>
								<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_cart; ?>
									<button type="button" class="close" data-dismiss="alert">&times;</button>
								</div>
							<?php } ?>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-cart-status"><?php echo $entry_view; ?></label>
								<div class="col-sm-10">
									<select name="custom_cart[status]" id="input-cart-status" class="form-control">
										<?php if ($custom_cart['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>
							<br>
							<table id="cart-column" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<td class="text-left">
											<?= $column_column; ?>
										</td>
										<td width="56px"></td>
									</tr>
								</thead>
								<tbody>
									<?php $cartKey = 0; ?>
									<?php if (!empty($custom_cart['column'])) { ?>
									<?php foreach($custom_cart['column'] as $column){ ?>
										<tr id="cart-column-<?= $cartKey ?>">
											<td>
												<select name="custom_cart[column][<?= $cartKey ?>]" id="input-cart-column-<?= $cartKey ?>" class="form-control">
													<?php foreach($custom_cart['list'] as $name => $item){ ?>

														<?php $item['selected'] = ''; ?>

														<?php if ($column === $name) { ?>	
															<?php $item['selected'] = 'selected="selected"'; ?>
														<?php } ?>

														<option value="<?= $name ?>" <?= $item['selected'] ?> ><?= $item['label'] ?></option>

													<?php } ?>
												</select>
											</td>
											<td>
												<button type="button" onclick="$('#cart-column-<?= $cartKey ?>').remove();" data-toggle="tooltip" title="<?= $entry_remove ?>" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>
											</td>
										</tr>
										<?php $cartKey++; ?>
									<?php } ?>
									<?php } ?>
								</tbody>
								<tfoot>
									<td ></td>
									<td>
										<button type="button" onclick="addCartColumn();" data-toggle="tooltip" title="" class="btn btn-primary" data-original-title="Добавить поле"><i class="fa fa-plus-circle"></i></button>
									</td>
								</tfoot>
							</table>
							<script>
								var cartKey = <?= $cartKey ?>;
								function addCartColumn(){

									html  = '<tr id="cart-column-' + cartKey + '">';
									html += '<td><select name="custom_cart[column][' + cartKey + ']" id="input-cart-column-' + cartKey + '" class="form-control">';
										<?php foreach($custom_cart['list'] as $name => $item){ ?>
											html += '<option value="<?= $name ?>" ><?= $item['label'] ?>';
										<?php } ?>
									html += '</select></td>';

									html += '<td><button type="button" onclick="$(\'#cart-column-' + cartKey + '\').remove();" data-toggle="tooltip" title="Удалить" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button></td>';
									html += '</tr>';

									$('#cart-column').append(html);
									cartKey++;
								};
							</script>

						</div>
						<div class="tab-pane" id="tab-customer">
							<?php if (!empty($error_customer)) { ?>
								<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_customer; ?>
									<button type="button" class="close" data-dismiss="alert">&times;</button>
								</div>
							<?php } ?>
							<input type="hidden" name="custom_customer[status]" value="1">
							<table id="customer-field" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<td class="text-left">
											<?= $column_field; ?>
										</td>
										<td>
											<?= $column_custumer_group; ?>
										</td>
										<td>
											<?= $column_required; ?>
										</td>
										<td>
											<?= $column_validation; ?>
										</td>
										<td width="56px"></td>
									</tr>
								</thead>
								<tbody>
									<?php $customerKey = 0; ?>
									<?php if (!empty($custom_customer['fields'])) { ?>
									<?php foreach($custom_customer['fields'] as $field){ ?>
										<tr id="customer-field-<?= $customerKey ?>">
											<td>
												<select name="custom_customer[fields][<?= $customerKey ?>][name]" id="input-customer-fields-<?= $customerKey ?>" class="form-control">
													<?php foreach($custom_customer['list'] as $name => $item){ ?>

														<?php $item['disabled'] = ''; ?>
														<?php $item['selected'] = ''; ?>

														<?php if ($field['name'] === $name) { ?>	
															<?php $item['selected'] = 'selected="selected"'; ?>
														<?php } ?>	

														<option value="<?= $name ?>" <?= $item['disabled'] ?> <?= $item['selected'] ?> ><?= $item['label'] ?></option>

													<?php } ?>
												</select>
											</td>
											<td>
												<?php $customer_group_row = 0; ?>
												<?php foreach ($customer_groups as $customer_group) { ?>
												<div class="checkbox">
													<label>
														<?php if (isset($field['customer_group']) && in_array($customer_group['customer_group_id'], $field['customer_group'])) { ?>
															<input type="checkbox" name="custom_customer[fields][<?= $customerKey ?>][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" checked="checked" />
														<?php } else { ?>
															<input type="checkbox" name="custom_customer[fields][<?= $customerKey ?>][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" />
														<?php } ?>
														<?php echo $customer_group['name']; ?>
													</label>
												</div>
												<?php $customer_group_row++; ?>
												<?php } ?>
											</td>
											<td>
												<?php $customer_group_row = 0; ?>
												<?php foreach ($customer_groups as $customer_group) { ?>
												<div class="checkbox">
													<label>
														<?php if (isset($field['required']) && in_array($customer_group['customer_group_id'], $field['required'])) { ?>
															<input type="checkbox" name="custom_customer[fields][<?= $customerKey ?>][required][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" checked="checked" />
														<?php } else { ?>
															<input type="checkbox" name="custom_customer[fields][<?= $customerKey ?>][required][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" />
														<?php } ?>
														<?php echo $customer_group['name']; ?>
													</label>
												</div>
												<?php $customer_group_row++; ?>
												<?php } ?>
											</td>
											<td>
												<input type="text" name="custom_customer[fields][<?= $customerKey ?>][validation]" value="<?php echo $field['validation']; ?>" placeholder="<?= $entry_validate ?>" id="input-customer-sort" class="form-control"/>
											</td>
											<td>
												<button type="button" onclick="$('#customer-field-<?= $customerKey ?>').remove();" data-toggle="tooltip" title="<?= $entry_remove ?>" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>
											</td>
										</tr>
										<?php $customerKey++; ?>
									<?php } ?>
									<?php } ?>
								</tbody>
								<tfoot>
									<td colspan="4"></td>
									<td>
										<button type="button" onclick="addcustomerField();" data-toggle="tooltip" title="" class="btn btn-primary" data-original-title="Добавить поле"><i class="fa fa-plus-circle"></i></button>
									</td>
								</tfoot>
							</table>



							<script>
								var customerField = <?= $customerKey ?>;
								function addcustomerField(){

									html  = '<tr id="customer-field-' + customerField + '">';
									html += '<td><select name="custom_customer[fields][' + customerField + '][name]" id="input-customer-fields-' + customerField + '" class="form-control">';
										<?php foreach($custom_customer['list'] as $name => $item){ ?>
											html += '<option value="<?= $name ?>" ><?= $item['label'] ?>';
										<?php } ?>
									html += '</select></td>';

									html += '<td>';
										<?php $customer_group_row = 0; ?>
										<?php foreach ($customer_groups as $customer_group) { ?>
											html += '<div class="checkbox"><label><input type="checkbox" name="custom_customer[fields][' + customerField + '][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" /><?php echo $customer_group['name']; ?></label></div>';
											html += '';
										<?php $customer_group_row++; ?>
										<?php } ?>
									html += '</td>';

									html += '<td>';
										<?php $customer_group_row = 0; ?>
										<?php foreach ($customer_groups as $customer_group) { ?>
											html += '<div class="checkbox"><label><input type="checkbox" name="custom_customer[fields][' + customerField + '][required][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" /><?php echo $customer_group['name']; ?></label></div>';
											html += '';
										<?php $customer_group_row++; ?>
										<?php } ?>
									html += '</td>';

									html += '<td><input type="text" name="custom_customer[fields][' + customerField + '][validation]" placeholder="<?= $entry_validate ?>" id="input-customer-sort" class="form-control"/></td>';

									html += '<td><button type="button" onclick="$(\'#customer-field-' + customerField + '\').remove();" data-toggle="tooltip" title="Удалить" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button></td>';
									html += '</tr>';

									$('#customer-field').append(html);
									customerField++;
								};
							</script>


						</div>
						<div class="tab-pane" id="tab-shipping">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-shipping-status"><?php echo $entry_view; ?></label>
								<div class="col-sm-10">
									<select name="custom_shipping[status]" id="input-shipping-status" class="form-control">
										<?php if ($custom_shipping['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>
							<br>
							<table id="shipping-field" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<td class="text-left">
											<?= $column_field; ?>
										</td>
										<td>
											<?= $column_shipping_method; ?>
										</td>
										<td>
											<?= $column_required; ?>
										</td>
										<td>
											<?= $column_validation; ?>
										</td>
										<td width="56px"></td>
									</tr>
								</thead>
								<tbody>
									<?php $shippingKey = 0; ?>
									<?php if (!empty($custom_shipping['fields'])) { ?>
									<?php foreach($custom_shipping['fields'] as $field){ ?>
										<tr id="shipping-field-<?= $shippingKey ?>">
											<td>
												<select name="custom_shipping[fields][<?= $shippingKey ?>][name]" id="input-shipping-fields-<?= $shippingKey ?>" class="form-control">
													<?php foreach($custom_shipping['list'] as $name => $item){ ?>

														<?php $item['selected'] = ''; ?>

														<?php if ($field['name'] === $name) { ?>	
															<?php $item['selected'] = 'selected="selected"'; ?>
														<?php } else { ?>	
															<?php $item['selected'] = 'data-field-name="'.$field['name'].'"'; ?>
														<?php } ?>

														<option value="<?= $name ?>" <?= $item['selected'] ?> ><?= $item['label'] ?></option>

													<?php } ?>
												</select>
											</td>
											<td>
												<?php $method_row = 0; ?>
												<?php foreach ($custom_shipping['methods'] as $method) { ?>
												<div class="checkbox">
													<label>
														<?php if (isset($field['method']) && in_array($method['code'], $field['method'])) { ?>
															<input type="checkbox" name="custom_shipping[fields][<?= $shippingKey ?>][method][<?= $method_row; ?>]" value="<?= $method['code']; ?>" checked="checked" />
														<?php } else { ?>
															<input type="checkbox" name="custom_shipping[fields][<?= $shippingKey ?>][method][<?= $method_row; ?>]" value="<?= $method['code']; ?>" />
														<?php } ?>
														<?= $method['label']; ?>
													</label>
												</div>
												<?php $method_row++; ?>
												<?php } ?>
											</td>
											</td>
											<td>
												<?php $method_row = 0; ?>
												<?php foreach ($custom_shipping['methods'] as $method) { ?>
												<div class="checkbox">
													<label>
														<?php if (isset($field['required']) && in_array($method['code'], $field['required'])) { ?>
															<input type="checkbox" name="custom_shipping[fields][<?= $shippingKey ?>][required][<?= $method_row; ?>]" value="<?= $method['code']; ?>" checked="checked" />
														<?php } else { ?>
															<input type="checkbox" name="custom_shipping[fields][<?= $shippingKey ?>][required][<?= $method_row; ?>]" value="<?= $method['code']; ?>" />
														<?php } ?>
														<?php echo $method['label']; ?>
													</label>
												</div>
												<?php $method_row++; ?>
												<?php } ?>
											</td>
											<td>
												<input type="text" name="custom_shipping[fields][<?= $shippingKey ?>][validation]" value="<?php echo $field['validation']; ?>" placeholder="<?= $entry_validate ?>" id="input-shipping-sort" class="form-control"/>
											</td>
											<td>
												<button type="button" onclick="$('#shipping-field-<?= $shippingKey ?>').remove();" data-toggle="tooltip" title="<?= $entry_remove ?>" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>
											</td>
										</tr>
										<?php $shippingKey++; ?>
									<?php } ?>
									<?php } ?>
								</tbody>
								<tfoot>
									<td colspan="4"></td>
									<td>
										<button type="button" onclick="addShippingField();" data-toggle="tooltip" title="" class="btn btn-primary" data-original-title="Добавить поле"><i class="fa fa-plus-circle"></i></button>
									</td>
								</tfoot>
							</table>

							<script>
								var shippingField = <?= $shippingKey ?>;
								function addShippingField(){

									html  = '<tr id="shipping-field-' + shippingField + '">';
									html += '<td><select name="custom_shipping[fields][' + shippingField + '][name]" id="input-shipping-fields-' + shippingField + '" class="form-control">';
										<?php foreach($custom_shipping['list'] as $name => $item){ ?>
											html += '<option value="<?= $name ?>" ><?= $item['label'] ?>';
										<?php } ?>
									html += '</select></td>';

									html += '<td>';
										<?php $method_row = 0; ?>
										<?php foreach ($custom_shipping['methods'] as $method) { ?>
										html += '<div class="checkbox"><label>	<input type="checkbox" name="custom_shipping[fields][' + shippingField + '][method][<?= $method_row; ?>]" value="<?= $method["code"]; ?>" /><?php echo $method["label"]; ?></label></div>';
										<?php $method_row++; ?>
										<?php } ?>
									html += '</td>';

									html += '<td>';
										<?php $method_row = 0; ?>
										<?php foreach ($custom_shipping['methods'] as $method) { ?>
										html += '<div class="checkbox"><label>	<input type="checkbox" name="custom_shipping[fields][' + shippingField + '][required][<?= $method_row; ?>]" value="<?= $method["code"]; ?>" /><?php echo $method["label"]; ?></label></div>';
										<?php $method_row++; ?>
										<?php } ?>
									html += '</td>';

									html += '<td><input type="text" name="custom_shipping[fields][' + shippingField + '][validation]" value="" placeholder="<?= $entry_validate ?>" id="input-shipping-sort" class="form-control"/></td>';

									html += '<td><button type="button" onclick="$(\'#shipping-field-' + shippingField + '\').remove();" data-toggle="tooltip" title="Удалить" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button></td>';
									html += '</tr>';

									$('#shipping-field').append(html);
									shippingField++;
								};
							</script>

						</div>
						<div class="tab-pane" id="tab-payment">
							<?php if (!empty($error_payment)) { ?>
								<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_payment; ?>
									<button type="button" class="close" data-dismiss="alert">&times;</button>
								</div>
							<?php } ?>
							<input type="hidden" name="custom_payment[status]" value="1">
							<br>
							<table id="payment-methods" class="table table-striped table-bordered table-hover">
								<thead>
									<tr>
										<td class="text-left">
											<?= $column_field; ?>
										</td>
										<td >
											<?= $column_custumer_group; ?>
										</td>
										<td width="56px"></td>
									</tr>
								</thead>
								<tbody>
									<?php $paymentKey = 0; ?>
									<?php if (!empty($custom_payment['methods'])) { ?>
									<?php foreach($custom_payment['methods'] as $method){ ?>
										<tr id="payment-method-<?= $paymentKey ?>">
											<td>
												<select name="custom_payment[methods][<?= $paymentKey ?>][name]" id="input-customer-method-<?= $paymentKey ?>" class="form-control">
													<?php foreach($custom_payment['list'] as $item){ ?>

														<?php $item['selected'] = ''; ?>

														<?php	if ($item['code'] == $method['name']) {
																$item['selected'] = " selected='selected'";
														} ?>

														<option value="<?= $item['code'] ?>" <?= $item['selected']; ?>><?= $item['label'] ?></option>

													<?php } ?>
												</select>
											</td>
											<td>
												<?php $customer_group_row = 0; ?>
												<?php foreach ($customer_groups as $customer_group) { ?>
												<div class="checkbox">
													<label>
														<?php if (isset($method['customer_group']) && in_array($customer_group['customer_group_id'], $method['customer_group'])) { ?>
															<input type="checkbox" name="custom_payment[methods][<?= $paymentKey ?>][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" checked="checked" />
														<?php } else { ?>
															<input type="checkbox" name="custom_payment[methods][<?= $paymentKey ?>][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" />
														<?php } ?>
														<?php echo $customer_group['name']; ?>
													</label>
												</div>
												<?php $customer_group_row++; ?>
												<?php } ?>
											</td>
											<td>
												<button type="button" onclick="$('#payment-method-<?= $paymentKey ?>').remove();" data-toggle="tooltip" title="<?= $entry_remove ?>" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>
											</td>
										</tr>
										<?php $paymentKey++; ?>
									<?php } ?>
									<?php } ?>
								</tbody>
								<tfoot>
									<td colspan="2"></td>
									<td>
										<button type="button" onclick="addPaymentMethod();" data-toggle="tooltip" title="" class="btn btn-primary" data-original-title="Добавить поле"><i class="fa fa-plus-circle"></i></button>
									</td>
								</tfoot>
							</table>

							<script>
								var paymentKey = <?= $paymentKey ?>;
								function addPaymentMethod(){

									html  = '<tr id="payment-method-' + paymentKey + '">';
									html += '<td><select name="custom_payment[methods][' + paymentKey + '][name]" id="input-payment-method-' + paymentKey + '" class="form-control">';
										<?php foreach($custom_payment['list'] as $name => $item){ ?>
											html += '<option value="<?= $item['code'] ?>" ><?= $item['label'] ?>';
										<?php } ?>
									html += '</select></td>';

									html += '<td>';
										<?php $customer_group_row = 0; ?>
										<?php foreach ($customer_groups as $customer_group) { ?>
											html += '<div class="checkbox"><label><input type="checkbox" name="custom_payment[methods][' + paymentKey + '][customer_group][<?= $customer_group_row; ?>]" value="<?= $customer_group['customer_group_id']; ?>" /><?php echo $customer_group['name']; ?></label></div>';
											html += '';
										<?php $customer_group_row++; ?>
										<?php } ?>
									html += '</td>';

									html += '<td><button type="button" onclick="$(\'#payment-method-' + paymentKey + '\').remove();" data-toggle="tooltip" title="Удалить" class="btn btn-danger"><i class="fa fa-minus-circle"></i></button></td>';
									html += '</tr>';

									$('#payment-methods').append(html);
									paymentKey++;
								};
							</script>

						</div>
						<div class="tab-pane" id="tab-comment">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-comment-status"><?php echo $entry_view; ?></label>
								<div class="col-sm-10">
									<select name="custom_comment[status]" id="input-comment-status" class="form-control">
										<?php if ($custom_comment['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="tab-module">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-module-status"><?php echo $entry_view; ?></label>
								<div class="col-sm-10">
									<select name="custom_module[status]" id="input-module-status" class="form-control">
										<?php if ($custom_module['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>

						</div>
						<div class="tab-pane" id="tab-total">

							<div class="form-group">
								<label class="col-sm-2 control-label" for="input-total-status"><?php echo $entry_view; ?></label>
								<div class="col-sm-10">
									<select name="custom_total[status]" id="input-total-status" class="form-control">
										<?php if ($custom_total['status']) { ?>
										<option value="1" selected="selected"><?php echo $text_yes; ?></option>
										<option value="0"><?php echo $text_no; ?></option>
										<?php } else { ?>
										<option value="1"><?php echo $text_yes; ?></option>
										<option value="0" selected="selected"><?php echo $text_no; ?></option>
										<?php } ?>
									</select>
								</div>
							</div>

						</div>
						<div class="tab-pane" id="tab-about">
							<p><?php echo $version; ?></p>
							<p><?php echo $about_module; ?></p>
						</div>
					</div>
	    	</form>
      </div>
    </div>
  </div>
</div>
<?php echo $footer; ?>
