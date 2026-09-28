

<div class="panel-body">
        <div class="well">
          <div class="row">
 <div class="col-sm-4">
             
                <label class="control-label" for="input-date-added">Дата от</label>
                <div class="input-group date">
                  <input type="text" name="filter_date_added" value="<?php echo $filter_date_added; ?>" placeholder="" data-date-format="YYYY-MM-DD" id="input-date-added" class="form-control" />
                  <span class="input-group-btn">
                  <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                  </span></div>
              </div>
 <div class="col-sm-4">             
             
                <label class="control-label" for="input-date-modified">до</label>
                <div class="input-group date">
                  <input type="text" name="filter_date_modified" value="<?php echo $filter_date_modified; ?>" placeholder=" " data-date-format="YYYY-MM-DD" id="input-date-modified" class="form-control" />
                  <span class="input-group-btn">
                  <button type="button" class="btn btn-default"><i class="fa fa-calendar"></i></button>
                  </span></div>
              </div>
               <div class="col-sm-4"> 
              <button type="button" id="button-filter" class="btn btn-primary pull-right"><i class="fa fa-filter"></i> Применить</button>
              </div>
            </div>
 </div></div>
<h1>Аналитика <? if ($filter_date_added) {?> за период с <b><? echo  $filter_date_added;?></b>  по <b><? echo  $filter_date_modified;?></b><? } ?></h1>
<div class="analitcinfo">
<p>Всего продано на сумму: <strong><? echo  round($summa);?> руб</strong></p>
<p>Комиссия на сайте составила: <strong><? echo  round($summa-$bonus);?> руб</strong></p>
</div>
<div class="panel panel-default">
   
  <div class="table-responsive">
    <table class="table">
      <thead>
        <tr>
          <td  >Автор</td>
          <td>Всего продано на сумму</td>
          <td>Комиссия сайта</td>
          <td>Выплачено</td>
          <td >Остаток на сайте</td>
         
        </tr>
      </thead>
      <tbody>
        <?php if ($customers) { ?>
        <?php foreach ($customers as $customer) { ?>
        <tr>
          <td  ><?php echo $customer['name']; ?></td>
          <td><?php echo $customer['costtotal']; ?></td>
          <td><?php echo $customer['komis']; ?></td>
          <td><?php echo $customer['vyvod']; ?></td>
          <td><?php echo $customer['ostatok']; ?></td>
           
        </tr>
        <?php } ?>
        <?php } else { ?>
        <tr>
          <td class="text-center" colspan="6"><?php echo $text_no_results; ?></td>
        </tr>
        <?php } ?>
      </tbody>
    </table>
  </div>
</div>

<script type="text/javascript"><!--
$('#button-filter').on('click', function() {
  url = 'index.php?route=common/dashboard&token=<?php echo $token; ?>';

  

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

<script src="view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.js" type="text/javascript"></script>
  <link href="view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" media="screen" />
  <script type="text/javascript"><!--
$('.date').datetimepicker({
  pickTime: false
});
//--></script>

<style>#button-filter {     float: left !important;
    margin-top: 20px;}
.analitcinfo { font-size:15px; color:#000;}
    </style>