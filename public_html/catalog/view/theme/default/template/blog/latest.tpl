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

<section id="blog">
  <div class="container">
    <h1 class="blog_title_mob"><?php echo $heading_title; ?></h1>
    <div class="blog_box">
      <?php echo $column_left; ?>
  <div class="blog_list_box">
        <h1><?php echo $heading_title; ?></h1>   


<div class="blog_list">
      <?php if ($articles) { ?>
      
        <?php foreach ($articles as $article) { ?> 
      <div class="blog_item">
            <div class="bl_img_box">
              <a href="<?php echo $article['href']; ?>"> <img src="<?php echo $article['thumb']; ?>"> </a>
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

        <?php } ?>
      </div>
   <div class="category_pagination_box">
<?php echo $pagination; ?>
        </div>
      <?php } else { ?>
      <p><?php echo $text_empty; ?></p>
      
      <?php } ?>
      </div>
    </div>
  </div>
</section>
<?php echo $footer; ?>