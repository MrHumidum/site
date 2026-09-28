 <div class="blog_sidebar_mob-btn_box">
        <button>Категории:</button>
      </div>
      <div class="blog_sidebar">
        <ul>
<?php foreach ($categories as $category) { ?>
<li><a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a></li>
     <?php } ?>      
        </ul>
      </div>
