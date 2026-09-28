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
<section id="cart">
  <div class="container">
    <h1 class="cart_title">
      Корзина
    </h1>
<div class="cart_flex" id="container">
   
  <?php if ($error_warning) { ?>
  <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
  </div>
  <?php } ?>
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>

  <?php echo $d_quickcheckout; ?>

      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<?php echo $footer; ?>