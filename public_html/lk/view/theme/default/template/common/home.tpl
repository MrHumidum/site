
<?php echo $header; ?>

<?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
<?php echo $content_top; ?><?php echo $content_bottom; ?>
    <?php echo $column_right; ?>


<section id="about">
  <div class="container">
    <div class="about_box">
      <h2 class="title about_title">
    <? echo $title;?>
      </h2>
      <div class="about_content_box">
        <div class="about_text_box">
    <? echo $html;?>
        </div>
        <div class="about_img">
         <? echo $image;?>
        </div>
      </div>
    </div>
  </div>
</section>

<?php echo $footer; ?>