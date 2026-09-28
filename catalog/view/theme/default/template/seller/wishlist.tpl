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
                <div class="col-sm-3">
              <div class="form-group">
                <label class="control-label" for="input-date-added">Дата от</label>
                <div class="input-group date">
                  <input type="text" name="filter_date_added" value="<?php echo $filter_date_added; ?>" placeholder="от" data-date-format="YYYY-MM-DD" id="input-date-added" class="form-control"  />
                  <span class="input-group-btn">
                  <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                  </span></div>
              </div></div>
              <div class="col-sm-3">
              <div class="form-group">
                <label class="control-label" for="input-date-modified">Дата до</label>
                <div class="input-group date">
                  <input type="text" name="filter_date_modified" value="<?php echo $filter_date_modified; ?>" placeholder="до" data-date-format="YYYY-MM-DD" id="input-date-modified" class="form-control" />
                  <span class="input-group-btn">
                  <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                  </span></div>
              </div>
             
            </div>

 <div class="col-sm-3">
              <div class="form-group">
                 <label class="control-label" for="input-date-modified"> </label>
                <div class="input-group">
                   <input type="checkbox" name="mygames" value="1" <? if ($mygames) {?> checked<? } ?>> только мои товары</div>
              </div> </div>
        <div class="col-sm-3">  <br>   <button type="button" id="button-filter" class="btn btn-primary pull-right"><i class="fa fa-filter"></i> Применить</button></div>
           

 

<table class="table table-bordered table-hover">
          <thead>
            <tr>
              
              <td class="text-left"><?php echo $column_name; ?></td>
             
             <td class="text-left">Продаж</td>
              <td class="text-right">Цена</td>
    
            </tr>
          </thead>
          <tbody>
            <?php foreach ($products as $product) { ?>
            <tr>
             
              <td class="text-left"><a href="<?php echo $product['href']; ?>" target="_blank"><?php echo $product['name']; ?></a></td>
          
              <td class="text-right"><?php echo $product['prod']; ?></td>
              <td class="text-right"><?php if ($product['price']) { ?>
                <div class="price">
                  <?php if (!$product['special']) { ?>
                  <?php echo $product['price']; ?>
                  <?php } else { ?>
                  <b><?php echo $product['special']; ?></b> <s><?php echo $product['price']; ?></s>
                  <?php } ?>
                </div>
                <?php } ?></td>
             
            </tr>
            <?php } ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</section>
<script type="text/javascript"><!--
$('.date').datetimepicker({
  pickTime: false
});
//--></script> 

 <script type="text/javascript"><!--
$('#button-filter').on('click', function() {
  url = 'index.php?route=account/wishlist';

  var myg= $('input[name=\'mygames\']').val();

  if ($('input[name=\'mygames\']').is(":checked")) {
    url += '&mygames=1' ;
  }


  var filter_date_added = $('input[name=\'filter_date_added\']').val();

  if (filter_date_added) {
    url += '&filter_date_added=' + encodeURIComponent(filter_date_added);
  }

  var filter_date_modified = $('input[name=\'filter_date_modified\']').val();

  if (filter_date_modified) {
    url += '&filter_date_modified=' + encodeURIComponent(filter_date_modified);
  }

  location = url;
});
//--></script> 


 
<?php echo $footer; ?> 
