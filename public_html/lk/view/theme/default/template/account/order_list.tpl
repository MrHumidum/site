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
  <div class="container"><a href="/index.php?route=add/product/add"><button class="add_game_btn error_game_btn">Добавить игру</button></a>
         <div class="office_box">
<?php echo $acc; ?>
      <div class="office_block">

      <h1>Баланс и статистика</h1> <br>
      <?php if ($orders) { ?>
      <div class="table-responsive">
        <table class="table table-bordered table-hover">
          <thead>
            <tr><td class="text-left"><?php echo $column_date_added; ?></td>
              <td class="text-right"><?php echo $column_order_id; ?></td>
            
              <td class="text-right"><?php echo $column_product; ?></td>
            
               <td class="text-left">Начислено</td>
              
            </tr>
          </thead>
          <tbody>
            <?php foreach ($orders as $order) { ?>
            <tr>
              <td class="text-left"><?php echo $order['date_added']; ?></td>
              <td class="text-right">#<?php echo $order['order_id']; ?></td>
            
              <td class="text-right"><?php echo $order['product']; ?></td>
             
              
               <td class="text-left"><?php echo $order['bonus']; ?></td>
               
            </tr>
            <?php } ?>
          </tbody>
        </table>
      </div>
      <div class="row">
        <div class="col-sm-6 text-left nomore"><?php echo $pagination; ?></div>
        <div class="col-sm-6 text-right"><?php echo $results; ?></div>
      </div>
      <?php } else { ?>
      <p>У вас нет действующих продаж игр</p>
      <?php } ?>
      
      <?php echo $content_bottom; ?>
    
  </div>
  </div>
</section>
<?php echo $footer; ?>
