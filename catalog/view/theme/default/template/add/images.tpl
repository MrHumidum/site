<div class="form-group" id="seller-images">
  <label class="col-sm-2 control-label" for="seller-photo">Фотографии товара</label>
  <div class="col-sm-10">
    <input id="seller-photo" type="file" accept="image/jpeg,image/png" multiple>
    <p>JPG или PNG, до 10 МБ. Первая фотография станет основной.</p>
    <div id="seller-photo-message" role="status"></div>
    <div id="seller-photo-preview"></div>
  </div>
</div>
<script>
(function($) {
  var uploading = false;
  $(function() {
    $('#form-product').on('submit', function(event) {
      if (uploading) {
        event.preventDefault();
        $('#seller-photo-message').text('Дождитесь завершения загрузки фотографий.');
      }
    });
  });
  $('#seller-photo').on('change', async function() {
    if (uploading) { return; }
    var files = Array.from(this.files || []);
    var $buttons = $('#form-product button[type=submit], button[form="form-product"]');
    if (!files.length) { return; }
    uploading = true;
    $(this).prop('disabled', true);
    $buttons.prop('disabled', true);
    $('#seller-photo-message').text('Загрузка фотографий…');
    try {
      for (var file of files) {
        var form = new FormData(); form.append('file', file); form.append('token', <?php echo json_encode($token); ?>);
        var json = await $.ajax({url:'index.php?route=add/image/upload',type:'POST',data:form,dataType:'json',processData:false,contentType:false,timeout:60000});
        if (!json || json.error || typeof json.path !== 'string' || !/^catalog\/sellers\/[0-9]+\/[a-f0-9]+\.(jpg|png)$/.test(json.path)) {
          $('#seller-photo-message').text(json && json.error ? json.error : 'Не удалось загрузить фотографию. Повторите попытку.');
          break;
        }
        if (!$('#input-image').val()) {
          $('#input-image').val(json.path); $('#thumb-image img').attr('src','image/'+json.path);
        } else {
          var row = $('#images tbody tr').length;
          while ($('#image-row'+row).length) { row++; }
          var $tr = $('<tr>').attr('id','image-row'+row);
          $('<td>').append($('<img>').attr('src','image/'+json.path).css('width','80px')).append($('<input type="hidden">').attr('name','product_image['+row+'][image]').val(json.path)).appendTo($tr);
          $('<td>').append($('<input type="number">').attr('name','product_image['+row+'][sort_order]').val(row)).appendTo($tr);
          $('<td>').append($('<button type="button">').text('Удалить').on('click',function(){$(this).closest('tr').remove();})).appendTo($tr);
          $('#images tbody').append($tr);
        }
        $('#seller-photo-preview').append($('<img>').attr('src','image/'+json.path).css({width:'80px',margin:'5px'}));
        $('#seller-photo-message').text('Фотография загружена. Сохраните товар.');
      }
    } catch(e) { $('#seller-photo-message').text('Не удалось загрузить фотографию. Повторите попытку.'); }
    finally {
      uploading = false;
      $(this).val('').prop('disabled', false);
      $buttons.prop('disabled', false);
    }
  });
})(jQuery);
</script>
