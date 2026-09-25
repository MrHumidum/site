<!DOCTYPE html>
<!--[if IE]><![endif]-->
<!--[if IE 8 ]><html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" class="ie8"><![endif]-->
<!--[if IE 9 ]><html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" class="ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>">
<!--<![endif]-->
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<?php if ($description) { ?>
<meta name="description" content="<?php echo $description; ?>" />
<?php } ?>
<?php if ($keywords) { ?>
<meta name="keywords" content= "<?php echo $keywords; ?>" />
<?php } ?>
<script src="catalog/view/javascript/jquery/jquery-2.1.1.min.js" type="text/javascript"></script>
<script src="js/slick.min.js"></script>
<script src="js/preloader.js?v=432"></script>
<link href="catalog/view/javascript/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen" />
<script src="catalog/view/javascript/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="catalog/view/javascript/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
<link href="//fonts.googleapis.com/css?family=Open+Sans:400,400i,300,700" rel="stylesheet" type="text/css" />
<link href="catalog/view/theme/default/stylesheet/stylesheet.css?<? echo time();?>" rel="stylesheet">
<?php foreach ($styles as $style) { ?>
<link href="<?php echo $style['href']; ?>" type="text/css" rel="<?php echo $style['rel']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>
<script src="catalog/view/javascript/common.js?<? echo time();?>" type="text/javascript"></script>
<?php foreach ($links as $link) { ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<?php foreach ($scripts as $script) { ?>
<script src="<?php echo $script; ?>" type="text/javascript"></script>
<?php } ?>
<?php foreach ($analytics as $analytic) { ?>
<?php echo $analytic; ?>
<?php } ?>

<link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="css/bootstrap.grid.css">
  <link rel="stylesheet" href="css/font-awesome.min.css">
  <link rel="stylesheet" href="css/slick-theme.css">
  <link rel="stylesheet" href="css/slick.css">
  <link rel="stylesheet" href="css/style.css?v=001">
  <link rel="stylesheet" href="media/media.css">
<link rel="stylesheet" href="css/office/style.css">
  <link rel="stylesheet" href="media/office/media.css">
  <link rel="stylesheet" href="css/main/style.css">
  <link rel="stylesheet" href="media/main/media.css">

  <link rel="icon" href ="img/fav.ico" type= "image/x-icon" > 
  <link rel="shortcut icon" href ="img/fav.ico" type="image/x-icon">

</head>
<body class="<?php echo $class; ?>">
  <div id="preloader" class="preloader_visible">
  <span></span>
</div>

<div id="mob-menu">
  <div class="mm_bg"></div>
  <div class="mob-menu">
    <div class="mob-menu_box">
      <ul class="mm_menu">
        <li><a href="#">
          <span>Категории игр</span>
          <svg><use xlink:href="#arrow-1"></use>
        </a>
        <div class="mm_menu_dop-menu">
          <div class="mm_menu_dop-menu_close">
            <span></span>
            <span></span>
          </div>
          <ul>
         <?php foreach ($categories2 as $category) { ?>    
         <li><a href="<? echo $category['href'];?>"><? echo $category['name'];?></a></li>
            <? } ?>
          </ul>
        </div>
        </li>
        <li><a class="ap_btn" href="/avtory">
          <span>Авторы</span>
        </a>
        </li>
        <li><a href="<? echo $latest;?>"><span>Все игры</span></a></li>
        <li><a href="/blog"><span>Статьи</span></a></li>
      </ul>
      <div class="mm_search">
        <div class="form">
          <input name="search" required type="text" placeholder="Поиск">
          <button><svg><use xlink:href="#search2"></use></svg></button>
        </div>
      </div>
      <div class="mm_info_btn sip_btn">
        <p>Как купить игру на сайте?</p>
        <img src="img/info_btn_ico.svg">
      </div>
    </div>
  </div>
</div>

<section id="main" class="sticky_padding">
<img class="main_img_bg" src="img/main/offer_bg.png">
<header id="header" class="bg_transparent">
  <div class="container">
    <div class="header_box">
      <div class="h_btn_mob-menu_box">
        <div class="h_btn_mob-menu">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
      <div class="h_logo_box">
        <a href="#"><img src="img/logo.svg"></a>
        <p>Авторские конкурсы, сценарии, игры для любого события</p>
      </div>
      <div class="h_action_box">
        <div class="h_act_info_btn sip_btn">
          <p>Как купить игру на сайте?</p>
          <img src="img/info_btn_ico.svg">
        </div>
        <div class="h_card_box">
          <? echo $cart;?>
        </div>
      </div>
    </div>
    <div class="d_menu_box">
      <ul class="d_menu">
        <li><a href="#">
          <span>Категории игр</span>
          <svg><use xlink:href="#arrow-1"></use></svg>
        </a>
        <ul class="d_menu_dop-menu">
          <?php foreach ($categories2 as $category) { ?>    
         <li><a href="<? echo $category['href'];?>"><? echo $category['name'];?></a></li>
            <? } ?>
        </ul>
        </li>
        <li><a class="ap_btn" href="/avtory">
          <span>Авторы</span>
        </a>
        </li>
        <li><a href="<? echo $latest;?>">
          <span>Все игры</span>
        </a></li>
        <li><a href="/blog">
          <span>Статьи</span>
        </a></li>
      </ul>

<?php echo $search; ?>
    </div>
  </div>
</header>
<div class="offer">
  <div class="container">
    <div class="offer_box">
      <div class="offer_text_box">
        <h1 class="offer_title">
          <span>Маркетплейс игр</span> для ведущих
        </h1>
        <h2 class="offer_subtitle">
          На сайте вы найдёте всё, что нужно для фантастической вечеринки.  Авторские Конкурсы, Сценарии, Игры для любого события.
        </h2>
        <button class="offer_btn">Вперед к покупкам</button>
        <div class="offer_bullets_box">
          <div class="offer_bullet">
            <b><? echo $Orders;?></b>
            <p>покупок</p>
          </div>
          <div class="offer_bullet">
            <b><? echo $total;?></b>
            <p>игры в каталоге</p>
          </div>
          <div class="offer_bullet">
            <b><? echo $avtors;?></b>
            <p>авторов</p>
          </div>
        </div>
      </div>
      <div class="offer_img_box">
        <img src="img/main/microphone_img.png">
      </div>
    </div>
  </div>
</div>
</section>


 