<div class="tab-pane" id="tab-easyphoto">
  <?php if($easyphoto_status){ ?>
  <link href="<?php echo HTTPS_SERVER; ?>view/javascript/easyphoto/easyphoto.css?v=3.0" rel="stylesheet">
  <script src="<?php echo HTTPS_SERVER; ?>view/javascript/easyphoto/easyphoto.js?v=3.0"></script>
  <script>
    var photo_row = '3274';

    function easyphoto_add(photo, all, counter, manual_class = "") {
      $.ajax({
          url: '<?php echo $resize_link; ?>&token=<?php echo $token; ?>&photo=' + photo + '<?php echo $easy_product_id; ?>',
          dataType: 'json',
          success: function(image) {

            html  = '<div class="' + manual_class + '" style="display:none;" id="photo-row' + photo_row + '">';
            html += '  	<a href="" id="thumb-image' + photo_row + '" data-toggle="image_off" class="img-thumbnail">';
            html += '  		<img src="' + image['thumb'] + '?mt=' + image['mt'] + '" data-placeholder="" />';
            html += '  	</a>';
            html += '  	<input type="hidden" class="image_for_main" name="product_image[' + photo_row + '][image]" value="' + image['image'] + '" id="input-photo' + photo_row + '" />';
            html += '  	<input type="hidden" name="product_image[' + photo_row + '][sort_order]" value="' + photo_row + '" class="sort_order" />';
            html += '  	<button type="button" title="<?php echo $text_change; ?>" data-toggle="tooltip" class="easy_change btn btn-warning"><i class="fa fa-pencil"></i></button>';
            html += '  	<a href="<?php echo HTTPS_CATALOG . 'image/'; ?>' + image['image'] + '" data-toggle="tooltip" title="<?php echo $text_popup; ?>" class="easy_popup btn btn-success"><i class="fa fa-search-plus"></i></a>';
            html += '  	<button type="button" title="<?php echo $text_rotate_right; ?>" data-toggle="tooltip" class="easy_rotate_right btn btn-info"><i class="fa fa-repeat" aria-hidden="true"></i></button>';
            html += '  	<button type="button" title="<?php echo $text_rotate_left; ?>" data-toggle="tooltip" class="easy_rotate_left btn btn-info"><i class="fa fa-undo"></i></button>';
            html += '   <button class="btn btn-danger delete_item" title="<?php echo $text_delete_server; ?>" data-toggle="title"><i class="fa fa-times" aria-hidden="true"></i></button>';
            html += '</div>';
            $(html).appendTo('#photos').fadeIn(200);

            if(manual_class == "new_photo_manual"){ //added from manual button
              $('.new_photo_manual .easy_change').click();
              $('#photos>div.unsortable').remove().appendTo('#photos');
              $('.easy_popup').magnificPopup({type: 'image'});
              $('#photo-row-add-new').find('i').addClass('fa-plus-square-o').removeClass('fa-spinner fa-spin');
            }

            photo_row++;

            <?php if($easyphoto_main){ ?>
                if($('#input-image').val() == ''){
                  $('#input-image').val(image['image']); //назначаем главное фото из загруженного
                  $('#main_photo>div').remove(); //убираем с главного фото
                  setTimeout(function(){
                    $('#photos>div:first-child').appendTo('#main_photo'); //вставляем загруженное фото
                  }, 200);
                  setTimeout(function(){
                    easyphoto_update();
                    $('#main_photo input').each(function(index, value){ //main_photo
                      $(this).attr('name', $(this).attr('name').replace('product_image', 'product_image_delete'));
                    });
                  }, 300);
                }
            <?php } ?>

            if(all == counter){ //uploaded_all_photo
              easyphoto_update()
              easyphoto_sortable();
              $('#fileuploader').removeClass('loading');
            }
          }
      });
    }

    function easyphoto_update(){
      $('#photos>div').each(function(index, value){
        $(this).find('.sort_order').val(index);
      });
      $('#photos_count').text($("#photos").children().length - 1);
      $('#trash_count').text($("#trash").children().length);
    }

    function easyphoto_sortable(){
      $('.easy_popup').magnificPopup({type: 'image'});
      $('#photos>div.unsortable').remove().appendTo('#photos');
      $('#photos, #main_photo, #trash').sortable({
          cursor: 'move',
          items: "div:not(.unsortable)",
          connectWith: "#photos, #main_photo, #trash",
          receive: function(event, ui) {
            if($("#main_photo").children().length > 1) { //main_photo
              if($("#main_photo>div:last-child .image_for_main").val().length){
                $("#main_photo>div:last-child").appendTo("#photos");
              }else{
                $("#main_photo>div:last-child").remove();
              }
              //$('#photos>div.unsortable').remove().appendTo('#photos');
            }
          },
          placeholder: 'highlight',
          start: function (event, ui) {
            ui.item.toggleClass('highlight');
          },
          stop: function (event, ui) {
            ui.item.toggleClass('highlight');
            if(ui.item.find('.image_for_main').val().length == 0){
              ui.item.remove();
            }
            $('#photos>div.unsortable').remove().appendTo('#photos');
            easyphoto_update();
          },
          update: function () {
            setTimeout(function(){
              $('#input-image').val($('#main_photo .image_for_main').val());
            }, 300);
            setTimeout(function(){
              if($('#input-image').val().length > 0){
                $('#main_photo').removeClass('disable_button');
              }else{
                $('#main_photo').addClass('disable_button');
              }
            }, 500);

            $('#main_photo input').each(function(index, value){ //main_photo
              $(this).attr('name', $(this).attr('name').replace('product_image_delete', 'product_image'));
              $(this).attr('name', $(this).attr('name').replace('product_image', 'product_image_delete'));
            });

            $('#photos input').each(function(index, value){ //added_photo
              $(this).attr('name', $(this).attr('name').replace('product_image_delete', 'product_image'));
            });

            $('#trash input').each(function(index, value){ //trash_photo
              $(this).attr('name', $(this).attr('name').replace('product_image_delete', 'product_image'));
              $(this).attr('name', $(this).attr('name').replace('product_image', 'product_image_delete'));
            });
            easyphoto_update();
          }
      }).disableSelection();
    }

    $(document).ready(function(){
      easyphoto_update()
      <?php if(!$main_photo){ ?>
        $('#main_photo .img-thumbnail img').attr('src', '<?php echo HTTPS_SERVER; ?>view/javascript/easyphoto/easyphoto_placeholder.png');
      <?php } ?>
      $('.easy_popup').magnificPopup({type: 'image'});
      $('#thumb-image').remove(); //remove main photo //3.0
      $('input[name="image"]').appendTo('.easyphoto_main'); //appendTo main photo
      $('a[href="#tab-image"]').parent().remove(); //remove tab link
      $("#tab-image").remove(); //remove image block
      easyphoto_sortable();

      $('.easyphoto_container').on('click', '.easy_rotate_right, .easy_rotate_left', function() {
        parent_id = $(this).parent().parent().attr('id');
        parent_easy_popup = $(this).parent().find('.easy_popup');
        id = $(this).parent().attr("id");
        $('#' + id).append('<img class="rotate_loader" src="<?php echo HTTPS_SERVER; ?>view/javascript/easyphoto/load.gif" style="position:absolute;width:124px;top:0px;">'); //loader
        photo = $(this).parent().find('.image_for_main').val();
        degrees = 90; //left
        if($(this).hasClass('easy_rotate_right')){
          degrees = 270; //right
        }
        $.ajax({
            url: '<?php echo $rotate_link; ?>&token=<?php echo $token; ?>&photo=' + photo + '&degrees=' + degrees,
            dataType: 'json',
            success: function(image) {
              $('#' + id  + ' .image_for_main').val(image['image']);
              if(parent_id == "main_photo"){
                $('#input-image').val(image['image']);
              }
              $('#' + id  + ' a img').attr("src", image['thumb'] + "?mt=" + image['mt']);
              parent_easy_popup.attr('href', '<?php echo HTTPS_CATALOG; ?>/image/' + image['image']);
              $('.rotate_loader').remove();
            }
        });
      });

      $('.easyphoto_container').on('click', '#photo-row-add-new', function(){
        $(this).find('i').removeClass('fa-plus-square-o').addClass('fa-spinner fa-spin');
        easyphoto_add('', 1, 1, 'new_photo_manual');
      });

      $('.easyphoto_container').on('click', '.delete_item', function(e){
        e.preventDefault();
        this_block = $(this).parent();
        this_image = $(this).parent().find('.image_for_main');
        $.ajax({
            url: '<?php echo $clear_cart_link; ?>&token=<?php echo $token; ?>',
            dataType: 'json',
            data: this_image,
            success: function(clear_cart_items) {
              this_block.fadeOut('500');
              setTimeout(function(){
                this_block.remove();
              }, 1000);
              $('#trash_count').text($('#trash_count').text() - 1);
            }
        });
      });

      $('.easyphoto_container').on('click', '#clear_cart', function(e){
        e.preventDefault();
        if(confirm('<?php echo $text_server_realy; ?>')){
          $.ajax({
              url: '<?php echo $clear_cart_link; ?>&token=<?php echo $token; ?>',
              dataType: 'json',
              data: $('#trash .image_for_main'),
              beforeSend: function() {
                $('#trash>div').addClass('opacity50');
                $('#trash').append('<img class="rotate_loader" src="<?php echo HTTPS_SERVER; ?>view/javascript/easyphoto/load.gif" style="position:absolute;width:124px;">'); //loader
              },
              success: function(clear_cart_items) {
                $('#trash').html('<h3><?php echo $text_clear; ?> ' + clear_cart_items + ' <?php echo $text_sht; ?>.</h3>');
                setTimeout(function(){
                  $('#trash h3').remove();
                }, 3000);
                $('#trash_count').text('0');
              }
          });
        }
      });

      $('.easyphoto_container').on('click', '#photos .img-thumbnail, #main_photo .img-thumbnail', function(e){
        e.preventDefault();
        $(this).parent().find('.easy_change').click();
        easyphoto_update()
      });

      $('.easyphoto_container').on('click', '#trash .img-thumbnail', function(e){
        e.preventDefault();
        $(this).parent().find('.easy_popup').click();
        easyphoto_update()
      });

      $('.easyphoto_container').on('click', '.easy_change', function() {
        $('.tooltip').remove();
        easy_this = $(this);
        $('#modal-image').remove();
        $.ajax({
          url: 'index.php?route=common/filemanager&token=' + getURLVar('token') + '&target=' + $(this).parent().find('input').attr('id') + '&thumb=' + $(this).parent().find('.img-thumbnail').attr('id'),
          dataType: 'html',
          beforeSend: function() {
            $('#button-image i').replaceWith('<i class="fa fa-circle-o-notch fa-spin"></i>');
            $('#button-image').prop('disabled', true);
          },
          complete: function() {
            $('#button-image i').replaceWith('<i class="fa fa-pencil"></i>');
            $('#button-image').prop('disabled', false);
          },
          success: function(html) {
            $('body').append('<div id="modal-image" class="modal">' + html + '</div>');
            $('#modal-image').modal('show');
            $('#modal-image').on('click', 'a.thumbnail', function(e){
              easy_this.parent().find('.easy_popup').attr('href', '<?php echo HTTPS_CATALOG; ?>image/' + easy_this.parent().find('input').val());
              $('#photos>div').removeClass('new_photo_manual');
            });
            $("#modal-image").on("hidden.bs.modal", function () {
              $('#input-image').val($('#main_photo .image_for_main').val());
              setTimeout(function(){
                $('.new_photo_manual').remove();
                easyphoto_update();
              },500);
            });
          }
        });
        easy_this.popover('hide', function() {
  				$('.popover').remove();
  			});
      });

      $("#fileuploader").uploadFile({
        url:"<?php echo $upload_link; ?>&token=<?php echo $token; ?>",
        multiple:true,
        dragDrop:true,
        acceptFiles:"image/*",
        dragDropStr: "<span><b><?php echo $text_drop_photo; ?></b></span>",
        uploadStr: '<i class="fa fa-upload" aria-hidden="true"></i> <?php echo $text_select_photo; ?>',
        fileName:"easyphoto",
        onSubmit:function(files){
            $('#fileuploader').addClass('loading');
        },
        onSuccess:function(files,data,xhr,pd){
            length = files.length - 1;
            jQuery.each(files, function(index) {
                easyphoto_add(this, length, index);
                $('#photos>div.unsortable').remove().appendTo('#photos');
            });
            setTimeout(function(){
              $('#photos>div').removeClass('new_photo_manual');
            },500);
        }
      });
    }); //document ready function
  </script>
  <div class="easyphoto_container">
    <div class="easyphoto_top row">

      <div class="col-sm-8">
        <?php if($easyphoto_for){ ?>
          <h3 class="text_ellipsis"><?php echo $text_photo_for; ?> <?php echo $easyphoto_for; ?></h3>
        <?php }else{ ?>
          <h3 id="photo_for" class="text_ellipsis"></h3>
          <script>
            $(document).on('click', 'a[href="#tab-easyphoto"]', function(){
              $('input[id^="input-name"]').each(function(i,elem) {
                if($(this).val() != ""){
                  name = $(this).val();
                }
              });
              $('#photo_for').text("<?php echo $text_photo_for; ?> " + name);
            });
          </script>
        <?php } ?>
        <div id="fileuploader"></div>
      </div>

      <div class="easyphoto_main col-sm-4 text-center">
        <h3><?php echo $text_main_photo; ?></h3>
        <div id="main_photo" class="photo_style <?php if(!$main_photo){ ?>disable_button<?php } ?>">
          <div id="photo-row327450">
            <a href="" id="thumb-photo327450" data-toggle="image_main_off" class="img-thumbnail">
              <img src="<?php echo $main_thumb; ?>?mt=<?php echo microtime(true); ?>" alt="" title="" data-placeholder="<?php echo $placeholder; ?>" />
            </a>
            <input type="hidden" class="image_for_main" name="product_image_delete[327450][image]" value="<?php echo $main_photo; ?>" id="input-photo327450" />
            <input type="hidden" name="product_image_delete[327450][sort_order]" class="sort_order" value="" />
            <button type="button" title="<?php echo $text_change; ?>" data-toggle="tooltip" class="easy_change btn btn-warning"><i class="fa fa-pencil" aria-hidden="true"></i></button>
            <a <?php if($main_photo){ ?>href="<?php echo HTTPS_CATALOG . 'image/' . $main_photo; ?>"<?php } ?> title="<?php echo $text_popup; ?>" data-toggle="tooltip" class="easy_popup btn btn-success"><i class="fa fa-search-plus" aria-hidden="true"></i></a>
            <button type="button" title="<?php echo $text_rotate_right; ?>" data-toggle="tooltip" class="easy_rotate_right btn btn-info"><i class="fa fa-repeat" aria-hidden="true"></i></button>
            <button type="button" title="<?php echo $text_rotate_left; ?>" data-toggle="tooltip" class="easy_rotate_left btn btn-info"><i class="fa fa-undo"></i></button>
            <button class="btn btn-danger delete_item" title="<?php echo $text_delete_server; ?>" data-toggle="title"><i class="fa fa-times" aria-hidden="true"></i></button>
          </div>
        </div>
      </div>

    </div>
    <div class="row">

      <div class="col-sm-8 paddingr0">
        <h3><?php echo $text_dop_photo; ?> (<span id="photos_count"><?php echo count($product_images); ?></span>)</h3>
        <div class="photo_style" id="photos">
          <?php $photo_row = 1000; ?>
          <?php foreach ($product_images as $product_photo) { ?>
           <?php if($product_photo['image']){ ?>
            <div id="photo-row<?php echo $photo_row; ?>">
              <a href="" id="thumb-photo<?php echo $photo_row; ?>" class="img-thumbnail">
                <img src="<?php echo $product_photo['thumb']; ?>?mt=<?php echo microtime(true); ?>" alt="" title="" data-placeholder="<?php echo $placeholder; ?>" />
              </a>
              <input type="hidden" class="image_for_main" name="product_image[<?php echo $photo_row; ?>][image]" value="<?php echo $product_photo['image']; ?>" id="input-photo<?php echo $photo_row; ?>" />
              <input type="hidden" name="product_image[<?php echo $photo_row; ?>][sort_order]" class="sort_order" value="<?php echo $product_photo['sort_order']; ?>" />
              <button type="button" title="<?php echo $text_change; ?>" data-toggle="tooltip" class="easy_change btn btn-warning"><i class="fa fa-pencil" aria-hidden="true"></i></button>
              <a href="<?php echo HTTPS_CATALOG . 'image/' . $product_photo['image']; ?>" title="<?php echo $text_popup; ?>" data-toggle="tooltip" class="easy_popup btn btn-success"><i class="fa fa-search-plus" aria-hidden="true"></i></a>
              <button type="button" title="<?php echo $text_rotate_right; ?>" data-toggle="tooltip" class="easy_rotate_right btn btn-info"><i class="fa fa-repeat" aria-hidden="true"></i></button>
              <button type="button" title="<?php echo $text_rotate_left; ?>" data-toggle="tooltip" class="easy_rotate_left btn btn-info"><i class="fa fa-undo"></i></button>
              <button class="btn btn-danger delete_item" title="<?php echo $text_delete_server; ?>" data-toggle="title"><i class="fa fa-times" aria-hidden="true"></i></button>
            </div>
            <?php $photo_row++; ?>
           <?php } ?>
          <?php } ?>

          <div id="photo-row-add-new" class="unsortable" title="<?php echo $text_add_from_server; ?>" data-toggle="tooltip">
            <i class="fa fa-plus-square-o" aria-hidden="true"></i> <?php echo $text_add; ?>
          </div>

        </div>
      </div>
      <div class="col-sm-4 text-center position_relative">
        <h3><?php echo $text_trash; ?> (<span id="trash_count"><?php echo count($trash_photos); ?></span>)</h3>
        <a href="#" id="clear_cart" title="<?php echo $text_delete_all; ?>" data-toggle="tooltip"><?php echo $text_clear_all; ?></a>
        <div id="trash" class="photo_style trash">
          <?php if($trash_photos){ ?>
            <?php $photo_row = 7000; ?>
            <?php foreach($trash_photos as $product_photo){ ?>
              <div id="photo-row<?php echo $photo_row; ?>">
                <a href="" id="thumb-photo<?php echo $photo_row; ?>" class="img-thumbnail">
                  <img src="<?php echo $product_photo['thumb']; ?>?mt=<?php echo microtime(true); ?>" alt="" title="" data-placeholder="<?php echo $placeholder; ?>" />
                </a>
                <input type="hidden" class="image_for_main" name="product_image_delete[<?php echo $photo_row; ?>][image]" value="<?php echo $product_photo['image']; ?>" id="input-photo<?php echo $photo_row; ?>" />
                <input type="hidden" name="product_image_delete[<?php echo $photo_row; ?>][sort_order]" class="sort_order" value="" />
                <button type="button" title="<?php echo $text_change; ?>" data-toggle="tooltip" class="easy_change btn btn-warning"><i class="fa fa-pencil" aria-hidden="true"></i></button>
                <a href="<?php echo HTTPS_CATALOG . 'image/' . $product_photo['image']; ?>" title="<?php echo $text_popup; ?>" data-toggle="tooltip" class="easy_popup btn btn-success"><i class="fa fa-search-plus" aria-hidden="true"></i></a>
                <button type="button" title="<?php echo $text_rotate_right; ?>" data-toggle="tooltip" class="easy_rotate_right btn btn-info"><i class="fa fa-repeat" aria-hidden="true"></i></button>
                <button type="button" title="<?php echo $text_rotate_left; ?>" data-toggle="tooltip" class="easy_rotate_left btn btn-info"><i class="fa fa-undo"></i></button>
                <button class="btn btn-danger delete_item" title="<?php echo $text_delete_server; ?>" data-toggle="tooltip"><i class="fa fa-times" aria-hidden="true"></i></button>
              </div>
              <?php $photo_row++; ?>
            <?php } ?>
          <?php } ?>
        </div>
      </div>
    </div>
  </div>
  <?php }else{ ?>
    <?php echo $text_easyphoto_off; ?>
  <?php } ?>
</div>
