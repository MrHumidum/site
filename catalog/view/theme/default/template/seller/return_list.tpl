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
       <div class="office_box">
<?php echo $acc; ?>
      <div class="office_block">
      <h1><?php echo $heading_title; ?></h1>


<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" class="form-horizontal">
        <fieldset>
         <legend>Заявка на вывод средств (Минимальная сумма для вывода 3000 рублей)</legend>
		 
		   <div class="form-group required">
            <label class="col-sm-gr control-label" for="input-lastname">укажите банк который выпустил карту</label>
            <div class="col-sm-gr">
              <input type="text"  name="bank" value="<? echo $bank;?>" placeholder="" id="input-bank" class="form-control" />
               <?php if ($error_bank) { ?>
              <div class="text-danger"><?php echo $error_bank; ?></div>
			   <? } ?>
            </div>
			
          </div>
		 
          <div class="form-group required">
            <label class="col-sm-gr control-label" for="input-firstname">Куда вывести</label>
            <div class="col-sm-gr">
              <input type="text" name="rek" value="<? echo $rek;?>" placeholder="Укажите реквизиты для вывода средств" id="input-firstname" class="form-control" />
               <?php if ($error_rek) { ?>
              <div class="text-danger"><?php echo $error_rek; ?></div>
              <?php } ?>
            </div>
          </div>
          <div class="form-group required">
            <label class="col-sm-gr control-label" for="input-lastname">Сумма</label>
            <div class="col-sm-gr">
              <input type="text"  name="summ" value="<? echo $summvyv;?>" placeholder="" id="input-lastname" class="form-control" />
              <?php if ($summ) { ?>
              <div class="text-danger"><?php echo $summ; ?></div>
              <?php } ?>
			    <?php if ($summ2) { ?>
              <div class="text-danger"><?php echo $summ2; ?></div>
              <?php } ?>
            </div>
			
          </div>
 

 
 
 
 <div class="pull-right">
            <input type="submit" value="Отправить" class="btn btn-primary" />
          </div>

</fieldset></form>

<br>

      <?php if ($returns) { ?>
      <div class="table-responsive">
        <table class="table table-bordered table-hover">
          <thead>
            <tr>
              <td class="text-right">Номер заявки</td>
             
              <td class="text-left"><?php echo $column_date_added; ?></td>
             
              <td class="text-left">Сумма</td>
                <td class="text-left"><?php echo $column_status; ?></td>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($returns as $return) { ?>
            <tr>
              <td class="text-right">#<?php echo $return['return_id']; ?></td>
             
              <td class="text-left"><?php echo $return['date_added']; ?></td>
           
              <td class="text-left"><?php echo $return['summ']; ?></td>
                <td class="text-left"><?php echo $return['status']; ?></td>
            </tr>
            <?php } ?>
          </tbody>
        </table>
      </div>
      <div class="row">
        
        <div class="col-sm-12 text-left"><b>Всего выплачено <?php echo $Vyvodtotal; ?></b><br><br></div><br></div>
 <div class="row">
          <div class="col-sm-9 text-left"><?php echo $pagination; ?></div>
          <div class="col-sm-3 text-right"><?php echo $results; ?></div>
        </div>
      <?php } else { ?>
      <p>У Вас пока не было заявок на вывод средств</p>
      <?php } ?>
      
  </div>
  </div>
</section>
<style>
.all-g_view_btn_box {
    display: none;
}
  </style>
<?php echo $footer; ?>
