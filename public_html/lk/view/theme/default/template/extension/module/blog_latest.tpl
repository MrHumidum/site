<section id="blog">
  <div class="container">
    <div class="blog_head">
      <div>
        <h2 class="title blog_title">Идеи для ведущих</h2>
        <h3 class="subtitle blog_subtitle">Множество полезных идей и возможностей для каждого от авторов маркетплейса</h3>
      </div>
      <a href="/blog">В раздел “Статьи”</a>
    </div>

    <div class="blog_box">
       <?php foreach ($articles as $article) { ?>
      <div class="blog_item">
        <div class="bl_img_box">
         <a href="<?php echo $article['href']; ?>">  <img src="<?php echo $article['thumb']; ?>"></a>
          <div class="bl_author_box">
            <div>
              <img src="<?php echo $article["userimage"];?>">
              <span><?php echo $article["user"];?></span>
            </div>
            <p><?php echo $article["date_added"];?></p>
          </div>
        </div>
        <div class="blog_content">
          <h4>
          <?php echo $article['name']; ?>
          </h4>
          <p>
            <?php echo $article['description']; ?>
          </p>
          <a href="<?php echo $article['href']; ?>">Подробнее</a>
        </div>
      </div>
      <? } ?>
    </div>
  </div>
</section>

 