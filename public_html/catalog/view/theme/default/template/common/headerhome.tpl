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
  <link rel="stylesheet" href="css/main/style.css?v=1">
  <link rel="stylesheet" href="media/main/media.css?v=2">

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
          <span>Категории</span>
          <svg><use xlink:href="#arrow-1"></use>
        </a>
        <div class="mm_menu_dop-menu">
          <div class="mm_menu_dop-menu_close">
            <span></span>
            <span></span>
          </div>
          <ul>
            <?php foreach ($categories2 as $category) { ?>
            <li class="mm_cat">
              <a href="<?php echo $category['href']; ?>" class="mm_cat_link">
                <svg class="mm_cat_ico" width="20" height="20" aria-hidden="true"><use xlink:href="#<?php echo $category['icon']; ?>"></use></svg>
                <span><?php echo $category['name']; ?></span>
              </a>
              <?php if ($category['children']) { ?>
              <ul class="mm_cat_sub">
                <?php foreach ($category['children'] as $child) { ?>
                <li><a href="<?php echo $child['href']; ?>"><?php echo $child['name']; ?></a></li>
                <?php } ?>
              </ul>
              <?php } ?>
            </li>
            <?php } ?>
          </ul>
        </div>
        </li>
        
        <li><a href="<? echo $latest;?>"><span>Все товары</span></a></li>
        <li><a href="/blog"><span>Статьи</span></a></li>
      </ul>
      <div class="mm_city_box">
        <form action="<?php echo $city_action; ?>" method="post" id="form-city-mobile">
          <svg class="h_city_ico" width="16" height="16" aria-hidden="true"><use xlink:href="#city-pin"></use></svg>
          <select name="city" aria-label="<?php echo $text_city; ?>" onchange="document.getElementById('form-city-mobile').submit();">
            <?php foreach ($cities as $city_code => $city_name) { ?>
            <option value="<?php echo $city_code; ?>"<?php echo ($city_code == $city ? ' selected="selected"' : ''); ?>><?php echo $city_name; ?></option>
            <?php } ?>
          </select>
          <input type="hidden" name="redirect" value="<?php echo $city_redirect; ?>" />
        </form>
      </div>
      <div class="mm_search">
        <div class="form">
          <input name="search" required type="text" placeholder="Поиск">
          <button><svg><use xlink:href="#search2"></use></svg></button>
        </div>
      </div>

    </div>
  </div>
</div>

<section id="main" class="sticky_padding">
 
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
        <a href="/"><img src="<?php echo $logo ? $logo : 'image/catalog/logo-haramain.svg'; ?>" alt="haramain.online" title="haramain.online"></a>
        <p>Маркетплейс: Мекка и Медина</p>
      </div>
      <div class="h_action_box">
        <div class="h_city_box">
          <form action="<?php echo $city_action; ?>" method="post" id="form-city">
            <svg class="h_city_ico" width="16" height="16" aria-hidden="true"><use xlink:href="#city-pin"></use></svg>
            <select name="city" aria-label="<?php echo $text_city; ?>" onchange="document.getElementById('form-city').submit();">
              <?php foreach ($cities as $city_code => $city_name) { ?>
              <option value="<?php echo $city_code; ?>"<?php echo ($city_code == $city ? ' selected="selected"' : ''); ?>><?php echo $city_name; ?></option>
              <?php } ?>
            </select>
            <input type="hidden" name="redirect" value="<?php echo $city_redirect; ?>" />
          </form>
        </div>
        <div class="h_card_box lkbox">
         <a href="<?=$login?>" class="h_card"><i class="fa fa-user-circle" aria-hidden="true"></i> <span class="hidden-xs">Кабинет</span></a>
        </div>
        <div class="h_card_box">
          <? echo $cart;?>
        </div>
      </div>
    </div>
    <div class="d_menu_box">
      <ul class="d_menu">
        <li><a href="#">
          <span>Категории</span>
          <svg><use xlink:href="#arrow-1"></use></svg>
        </a>
        <ul class="d_menu_dop-menu">
          <?php foreach ($categories2 as $category) { ?>
          <li class="d_menu_cat">
            <a href="<?php echo $category['href']; ?>" class="d_menu_cat_link">
              <svg class="d_menu_cat_ico" width="20" height="20" aria-hidden="true"><use xlink:href="#<?php echo $category['icon']; ?>"></use></svg>
              <span><?php echo $category['name']; ?></span>
            </a>
            <?php if ($category['children']) { ?>
            <ul class="d_menu_sub">
              <?php foreach ($category['children'] as $child) { ?>
              <li><a href="<?php echo $child['href']; ?>"><?php echo $child['name']; ?></a></li>
              <?php } ?>
            </ul>
            <?php } ?>
          </li>
          <?php } ?>
        </ul>
        </li>
       
        <li><a href="<? echo $latest;?>">
          <span>Все товары</span>
        </a></li>
        <li><a href="/blog">
          <span>Статьи</span>
        </a></li>
      </ul>

<?php echo $search; ?>
    </div>
  </div>
</header>

</section>


 