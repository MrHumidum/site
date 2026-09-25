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


<section id="page">
  <div class="container">
    <div class="page_container">
      <h1 class="page_title">
      <?php echo $heading_title; ?>
      </h1>
      <div class="page_info_box">
        <div class="p_i_author">
      <? if ($userimage) {?>    <img src="<? echo $userimage;?>"> <? } ?>
          <p><? echo $user?></p>
        </div>
        <div class="p_i_date">
          <p>Дата публикации:</p> <span><? echo $date_added;?></span>
        </div>
        <div class="p_i_view"><svg><use xlink:href="#view_ico"></use></svg><span><? echo $viewed;?> просмотра(ов)</span></div>
      </div>

      <div class="page_box">
        <?php echo $description; ?>

      </div>
    </div>
  </div>
</section>


 
<?php echo $footer; ?>