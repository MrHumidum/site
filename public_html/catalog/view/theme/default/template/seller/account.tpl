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


<section id="office">
  <div class="container">
    <a href="/index.php?route=add/product/add"><button class="add_product_btn">Добавить товар</button></a>
    <h1 class="office_mob_title">
      Добро пожаловать, <? echo $firstname;?>
    </h1>
    <div class="office_box">
<?php echo $acc; ?>
      <div class="office_block">
        <h1>
          Добро пожаловать, <? echo $firstname;?>
        </h1>
        <div class="office_options">
          <a href="/index.php?route=seller/edit" class="office_option">
            <h2>Личные данные</h2>
            <p>Имя, фамилия и контакты</p>
          </a>
          <a href="/index.php?route=seller/order" class="office_option">
            <h2>Баланс и статистика</h2>
            <p>Баланс и история зачислений</p>
          </a>
          <a href="/index.php?route=seller/address" class="office_option">
            <h2>Адрес продавца</h2>
            <p>Страна, город и адрес</p>
          </a>
          <a href="/index.php?route=add/product" class="office_option">
            <h2>Мои товары</h2>
            <p>Управление товарами</p>
          </a>
        </div>
      </div>
    </div>
  </div>
</section>



 
<?php echo $footer; ?> 