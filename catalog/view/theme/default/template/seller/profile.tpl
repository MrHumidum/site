<?php echo $header; ?><div class="sticky_padding"></div>
<section class="container" style="max-width:720px;padding-top:30px;padding-bottom:40px">
<h1><?php echo $title; ?></h1>
<?php if ($error) { ?><div class="alert alert-danger" role="alert"><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></div><?php } ?>
<form method="post" action="<?php echo $action; ?>">
<input type="hidden" name="form_token" value="<?php echo $form_token; ?>">
<?php foreach (array('firstname'=>'Имя','lastname'=>'Фамилия','email'=>'E-mail','telephone'=>'Телефон','address_1'=>'Адрес') as $key=>$label) { ?>
<div class="form-group"><label for="seller-<?php echo $key; ?>"><?php echo $label; ?></label>
<input class="form-control" id="seller-<?php echo $key; ?>" name="<?php echo $key; ?>" type="<?php echo $key === 'email' ? 'email' : 'text'; ?>" required value="<?php echo htmlspecialchars((string)$values[$key], ENT_QUOTES, 'UTF-8'); ?>"></div>
<?php } ?>
<div class="form-group"><label for="seller-country">Страна</label><select class="form-control" id="seller-country" name="country_id" required>
<?php foreach ($countries as $country) { ?><option value="<?php echo (int)$country['country_id']; ?>" <?php if ((int)$country['country_id'] === (int)$values['country_id']) { echo 'selected'; } ?>><?php echo htmlspecialchars($country['name'], ENT_QUOTES, 'UTF-8'); ?></option><?php } ?>
</select></div>
<div class="form-group"><label for="seller-city">Город работы</label><select class="form-control" id="seller-city" name="city" required>
<?php foreach (array('Мекка','Медина') as $city) { ?><option <?php if ($values['city'] === $city) { echo 'selected'; } ?>><?php echo $city; ?></option><?php } ?>
</select></div>
<?php if ($register) { foreach (array('password'=>'Пароль','confirm'=>'Повторите пароль') as $key=>$label) { ?>
<div class="form-group"><label for="seller-<?php echo $key; ?>"><?php echo $label; ?></label><input class="form-control" id="seller-<?php echo $key; ?>" name="<?php echo $key; ?>" type="password" autocomplete="new-password" minlength="8" maxlength="72" required></div>
<?php }} ?>
<button class="btn btn-primary" type="submit"><?php echo $register ? 'Зарегистрироваться' : 'Сохранить'; ?></button>
<?php if ($register) { ?><a href="<?php echo $login; ?>">Уже есть аккаунт? Войти</a><?php } ?>
</form></section><?php echo $footer; ?>
