<section id="author">
  <div class="container">
    <h2 class="title author_title">Авторы на площадке</h2>
    <div class="author_box">
     <?php foreach ($manufacturers as $manufacturer) { ?>
      <a href="<?php echo $manufacturer['href']; ?>" class="author_item">
        <img src="<?php echo $manufacturer['image']; ?>">
        <h4><?php echo $manufacturer['name']; ?></h4>
      </a>
       <?php } ?>
    </div>
  </div>
</section>

 