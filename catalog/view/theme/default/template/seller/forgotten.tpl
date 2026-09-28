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
        <h1>Забыли пароль</h1>
      <p><?php echo $text_email; ?></p>
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" class="form-horizontal">
  
   <div class="input_block">
            <span>E-mail</span>
            <input required name="email" type="email" value="<?php echo $email; ?>" id="input-email">
          </div>
           
      
        <button><?php echo $button_continue; ?></button>
            
          
      </form>
     
</div></div></div> </section>
<script src="js/login.js"></script>
<?php echo $footer; ?>