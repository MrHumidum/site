<div class="category_filter_mob_btn_box">
          <div class="c_f_m-btn c_f_m-btn_category">Категории</div>
          
        </div>
<div class="category_list_box hidemanuf" id="category_list_box1">
          <ul>
    <?php $i=0; foreach ($categories as $category) { $i++;?>
    <li><a href="<?php echo $category['href']; ?>">
              <span class="color_<?=$i?>"><img src="<?php echo htmlspecialchars($category['image'], ENT_QUOTES, 'UTF-8'); ?>" alt="" onerror="this.parentNode.style.display='none'"></span>
              <p><?php echo $category['name']; ?></p>
            </a></li>
<?php } ?>
</ul>
</div>
