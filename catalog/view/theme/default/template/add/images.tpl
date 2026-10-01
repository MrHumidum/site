<?php
// Keep the saved main image first; additional images follow their stored order.
$seller_gallery = array();
$seller_seen = array();
if (!empty($image)) {
    $seller_gallery[] = array('path' => $image, 'url' => $thumb);
    $seller_seen[$image] = true;
}
$seller_additional = isset($product_images) ? $product_images : array();
usort($seller_additional, function($a, $b) { return (int)$a['sort_order'] - (int)$b['sort_order']; });
foreach ($seller_additional as $seller_photo) {
    if ($seller_photo['image'] !== '' && !isset($seller_seen[$seller_photo['image']])) {
        $seller_gallery[] = array('path' => $seller_photo['image'], 'url' => $seller_photo['thumb']);
        $seller_seen[$seller_photo['image']] = true;
    }
}
?>
<style>
#seller-photo-preview { display:block; margin-top:12px; }
#seller-photo-preview::after { content:""; display:block; clear:both; }
#seller-images .seller-photo-card { float:left; margin:0 12px 12px 0; width:160px; padding:8px; border:1px solid #ddd; border-radius:6px; background:#fff; }
#seller-images .seller-photo-card img { display:block; width:100%; height:120px; object-fit:contain; background:#f6f6f6; }
#seller-images .seller-photo-main { display:block; min-height:24px; padding:4px 0; font-size:12px; font-weight:600; color:#287348; }
#seller-images .seller-photo-handle { display:block; padding:8px 0; cursor:grab; font-size:12px; user-select:none; }
#seller-images .seller-photo-actions { display:flex; flex-wrap:wrap; gap:4px; }
#seller-images .seller-photo-actions button { min-height:36px; min-width:36px; }
#seller-images .seller-photo-placeholder { float:left; margin:0 12px 12px 0; width:160px; min-height:225px; border:2px dashed #999; border-radius:6px; }
#seller-photo-message { white-space:pre-line; }
#seller-images .seller-photo-error { color:#a94442; font-size:12px; }
</style>
<div class="form-group" id="seller-images">
  <label class="col-sm-2 control-label" for="seller-photo">Фотографии товара</label>
  <div class="col-sm-10">
    <input id="seller-photo" type="file" accept="image/jpeg,image/png" multiple>
    <p>JPG или PNG, до 10 МБ. Первая фотография — основная. Перетащите фотографии или используйте стрелки для изменения порядка.</p>
    <div id="seller-photo-message" role="status" aria-live="polite"></div>
    <div id="seller-photo-preview" role="list" aria-label="Фотографии товара"></div>
    <div id="seller-photo-fields">
      <input type="hidden" name="image" id="input-image" value="<?php echo htmlspecialchars(count($seller_gallery) ? $seller_gallery[0]['path'] : '', ENT_QUOTES, 'UTF-8'); ?>">
      <?php foreach (array_slice($seller_gallery, 1) as $seller_index => $seller_photo) { ?>
      <input type="hidden" name="product_image[<?php echo $seller_index; ?>][image]" value="<?php echo htmlspecialchars($seller_photo['path'], ENT_QUOTES, 'UTF-8'); ?>">
      <input type="hidden" name="product_image[<?php echo $seller_index; ?>][sort_order]" value="<?php echo $seller_index; ?>">
      <?php } ?>
    </div>
  </div>
</div>
<script>
(function($) {
  $(function() {
    var gallery = <?php echo json_encode($seller_gallery, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>;
    var uploading = false;
    var $gallery = $('#seller-photo-preview');
    var $fields = $('#seller-photo-fields');
    var $message = $('#seller-photo-message');
    if (!$gallery.length || $gallery.data('sellerPhotosReady')) { return; }
    $gallery.data('sellerPhotosReady', true);

    function rebuildFields() {
      $fields.empty();
      $('<input>', {type:'hidden', name:'image', id:'input-image'}).val(gallery.length ? gallery[0].path : '').appendTo($fields);
      gallery.slice(1).forEach(function(photo, index) {
        $('<input>', {type:'hidden', name:'product_image[' + index + '][image]'}).val(photo.path).appendTo($fields);
        $('<input>', {type:'hidden', name:'product_image[' + index + '][sort_order]'}).val(index).appendTo($fields);
      });
    }
    function movePhoto(from, to) {
      if (to < 0 || to >= gallery.length || from === to) { return; }
      gallery.splice(to, 0, gallery.splice(from, 1)[0]);
      render();
      $gallery.children().eq(to).find('.seller-photo-move').filter(':enabled').first().focus();
    }
    function render() {
      rebuildFields();
      $gallery.empty();
      gallery.forEach(function(photo, index) {
        var $card = $('<div>', {'class':'seller-photo-card', role:'listitem'}).data('path', photo.path);
        $('<img>', {alt:'Фотография ' + (index + 1), draggable:false}).on('error', function() {
          if (!$card.find('.seller-photo-error').length) {
            $('<p>', {'class':'seller-photo-error', role:'alert'}).text('Не удалось показать фотографию. Удалите её и загрузите снова.').appendTo($card);
          }
        }).attr('src', photo.url).appendTo($card);
        $('<span>', {'class':'seller-photo-main'}).text(index === 0 ? 'Основное фото' : 'Фото ' + (index + 1)).appendTo($card);
        $('<span>', {'class':'seller-photo-handle', title:'Перетащить фотографию'}).text('↔ Перетащить').appendTo($card);
        var $actions = $('<div>', {'class':'seller-photo-actions'}).appendTo($card);
        $('<button>', {type:'button', 'class':'btn btn-default btn-sm seller-photo-move', 'aria-label':'Переместить фото ' + (index + 1) + ' раньше', disabled:index === 0}).text('←').on('click', function() { movePhoto(index, index - 1); }).appendTo($actions);
        $('<button>', {type:'button', 'class':'btn btn-default btn-sm seller-photo-move', 'aria-label':'Переместить фото ' + (index + 1) + ' позже', disabled:index === gallery.length - 1}).text('→').on('click', function() { movePhoto(index, index + 1); }).appendTo($actions);
        $('<button>', {type:'button', 'class':'btn btn-danger btn-sm', 'aria-label':'Удалить фото ' + (index + 1)}).text('Удалить').on('click', function() {
          gallery.splice(index, 1); render();
        }).appendTo($actions);
        $card.appendTo($gallery);
      });
      if ($gallery.hasClass('ui-sortable')) { $gallery.sortable('refresh'); }
    }
    render();
    // jQuery UI is already loaded by the seller form. Arrow controls also work on touch and keyboard.
    if ($.fn.sortable) {
      $gallery.sortable({items:'.seller-photo-card', handle:'.seller-photo-handle', placeholder:'seller-photo-placeholder', tolerance:'pointer',
        update:function() {
          var paths = $gallery.children('.seller-photo-card').map(function() { return $(this).data('path'); }).get();
          gallery = paths.map(function(path) { return gallery.filter(function(photo) { return photo.path === path; })[0]; });
          render();
        }
      });
    }
    $('#form-product').off('submit.sellerPhotos').on('submit.sellerPhotos', function(event) {
      if (uploading) {
        event.preventDefault();
        $message.text('Дождитесь завершения загрузки фотографий.');
      } else { rebuildFields(); }
    });
    $('#seller-photo').off('change.sellerPhotos').on('change.sellerPhotos', async function() {
      if (uploading) { return; }
      var files = Array.from(this.files || []);
      if (!files.length) { return; }
      var $buttons = $('#form-product button[type=submit], button[form="form-product"]');
      var buttonStates = $buttons.map(function() { return this.disabled; }).get();
      var errors = [];
      uploading = true;
      $(this).prop('disabled', true);
      $buttons.prop('disabled', true);
      $('#seller-images').attr('aria-busy', 'true');
      $message.removeClass('text-danger');
      try {
        for (var i = 0; i < files.length; i++) {
          var file = files[i];
          $message.text('Загрузка фотографий: ' + (i + 1) + ' из ' + files.length + '…' + (errors.length ? '\n' + errors.join('\n') : ''));
          try {
            if (!file.size || file.size > 10485760 || (file.type && !/^(image\/jpeg|image\/png)$/.test(file.type))) {
              throw new Error('Выберите JPG или PNG размером до 10 МБ.');
            }
            var form = new FormData();
            form.append('file', file);
            form.append('token', <?php echo json_encode($token, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT); ?>);
            var json = await $.ajax({url:'index.php?route=add/image/upload', type:'POST', data:form, dataType:'json', processData:false, contentType:false, timeout:60000});
            if (!json || json.error || typeof json.path !== 'string' || !/^catalog\/sellers\/[0-9]+\/[a-f0-9]+\.(jpg|png)$/.test(json.path) || typeof json.url !== 'string' || !/^https?:\/\//.test(json.url)) {
              throw new Error(json && json.error ? json.error : 'Не удалось загрузить фотографию. Повторите попытку.');
            }
            if (!gallery.some(function(photo) { return photo.path === json.path; })) {
              gallery.push({path:json.path, url:json.url});
              render();
            }
          } catch(e) {
            errors.push(file.name + ': ' + (e.message || 'Ошибка сети или ответа сервера. Повторите попытку.'));
          }
        }
      } catch(e) { errors.push('Не удалось загрузить фотографии. Повторите попытку.'); }
      finally {
        uploading = false;
        $(this).val('').prop('disabled', false);
        $buttons.each(function(index) { this.disabled = buttonStates[index]; });
        $('#seller-images').attr('aria-busy', 'false');
        $message.toggleClass('text-danger', errors.length > 0).text(errors.length ? errors.join('\n') : 'Фотографии загружены. Сохраните товар.');
      }
    });
  });
})(jQuery);
</script>
