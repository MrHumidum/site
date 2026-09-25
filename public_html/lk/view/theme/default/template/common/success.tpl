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
<div class="container">
   
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
      <h1><?php echo $heading_title; ?></h1>
      <?php echo $text_message; ?>
      <? if (isset($products)) {?>
	  
<div style="font-weight: 700;    color: darkorange;
"> Важно: если вы не получили игру, проверьте папку “Спам”, иногда письма попадают туда по независящим от нас причинам. </div>
	 <p>Также можете скачать купленные файлы по ссылке ниже:</p> 
	  <div class="g_c_kit_box">
<ul>
        <?php foreach ($products as $product) { ?>
<li><?php echo $product['name']; ?>. Ссылка:<a href="<?php echo $product['href']; ?>" target="_blank"> <?php echo $product['href']; ?></a><li>

        <? } ?>
      </ul></div>
	  <div class="textonsuccess">ВНИМАНИЕ: после обновления страницы ссылки исчезнут и будут доступны в только в вашей почте</div>
	  <?}?>

      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<?php echo $footer; ?>