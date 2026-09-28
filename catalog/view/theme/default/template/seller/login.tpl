<?php echo $header; ?> <div class="sticky_padding"></div>
<div id="breadcrumbs">
  <div class="container">
    <div class="breadcrumbs_list">

<?php foreach ($breadcrumbs as $i=> $breadcrumb) { ?>
<?php if($i+1<count($breadcrumbs)) { ?>
  <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a> <span><svg><use xlink:href="#arrow-3"></use></svg></span><?php } else { ?>
<p><?php echo $breadcrumb['text']; ?></p>
<?php } ?>
<?php } ?>

     
      
    </div>
  </div>
</div>
<link rel="stylesheet" href="css/login/style.css">
  <link rel="stylesheet" href="media/login/media.css">


<section id="login">
  <div class="container">
    <div class="login_box">
      <div class="login_block">
        <h1>Вход для продавцов</h1>
         <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
  <?php } ?>
  <?php if ($error_warning) { ?>
  <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?></div>
  <?php } ?>
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data">
          <div class="input_block">
            <span>E-mail</span>
            <input required name="email" type="email" value="<?php echo $email; ?>">
          </div>
          <div class="input_block">
            <span>Пароль</span>
            <input required name="password" type="password">
          </div>
          <?php if ($redirect) { ?>
              <input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
              <?php } ?>
          <a href="<?php echo $forgotten; ?>">Забыли пароль?</a>
          <button>Войти</button>
          <a href="index.php?route=seller/register">Зарегистрироваться как продавец</a>
        </form>
      </div>
    </div>
  </div>
</section>

<script src="js/login.js"></script>

<?php echo $footer; ?>