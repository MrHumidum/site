<section id="category">
    <div class="container">
        <h2 class="title category_title">Категории игр</h2>
        <h3 class="subtitle category_subtitle">Подготовь лучший праздник за считанные минуты</h3>
        <div class="category_box"> <? $i=0;?>
          <?php foreach ($categories as $category) { $i++;?>
            <a href="<?php echo $category['href']; ?>" class="category_item">
                <div class="ico_box color_<?=$i?>">
                    <img src="<?php echo $category['image']; ?>">
                </div>
                <p>
                 <?php echo $category['name']; ?>
                </p>
            </a>
<? } ?>
        </div>
    </div>
</section>
 