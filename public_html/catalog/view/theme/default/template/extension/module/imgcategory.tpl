<section id="category">
    <div class="container">
        <h2 class="title category_title">Категории</h2>
        <h3 class="subtitle category_subtitle">Выберите интересующую категорию товаров</h3>
        <div id="carouselcat" class="owl-carousel">
          <?php $i = 0; ?>
          <?php foreach ($categories as $category) { $i++; ?>
            <a href="<?php echo $category['href']; ?>" class="item text-center category_items">
                <div class="ico_box color_<?php echo $i; ?>">
                    <img src="<?php echo $category['image']; ?>">
                </div>
                <p>
                 <?php echo $category['name']; ?>
                </p>
            </a>
          <?php } ?>
        </div>
    </div>
    <script type="text/javascript"><!--
$('#carouselcat').owlCarousel({
    items: 4,
    autoPlay: 3000,
    navigation: true,
    navigationText: ['<i class="fa fa-chevron-left fa-5x"></i>', '<i class="fa fa-chevron-right fa-5x"></i>'],
    pagination: false,
    responsive:{
            0:{
                items:1
            },
            600:{
                items:2
            },
            1000:{
                items:4
            }
        }
});
--></script>
</section>