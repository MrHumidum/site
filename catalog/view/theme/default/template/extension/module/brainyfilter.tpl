<?php
/**
 * Brainy Filter Ultimate 5.1.2 OC2.3, November 4, 2016 / brainyfilter.com 
 * Copyright 2015-2016 Giant Leap Lab / www.giantleaplab.com 
 * License: Commercial. Reselling of this software or its derivatives is not allowed. You may use this software for one website ONLY including all its subdomains if the top level domain belongs to you and all subdomains are parts of the same OpenCart store. 
 * Support: http://support.giantleaplab.com
 */
$isHorizontal = $layout_position === 'content_top' || $layout_position === 'content_bottom';
$isResponsive = (bool) $settings['style']['responsive']['enabled'];
$responsivePos = $settings['style']['responsive']['position'] === 'right' ? 'bf-right' : 'bf-left';

if (!function_exists('totalsDecorator')) {
    function totalsDecorator($groupId, $val, $totals = array(), $selected = array()) {
        if (!isset($totals[$groupId][$val]) && !isset($selected[$groupId])) {
            return '';
        }

        $total = isset($totals[$groupId][$val]) ? $totals[$groupId][$val] : 0;
        $addPlusSign = isset($selected[$groupId]);

        return '<span class="bf-count ' . (!$total ? 'bf-empty' : '') . '">' . ($addPlusSign ? '+' : '') . $total . '</span>';
    }
}
if (!function_exists('isEmptyStock')) {
    function isEmptyStock($groupId, $val, $postponedCount, $totals = array(), $selected = array()) {
        $inStock = $postponedCount || (isset($totals[$groupId][$val]) && $totals[$groupId][$val]);
        $inSelected = isset($selected[$groupId]) && in_array($val, $selected[$groupId]);
        return !$inStock && !$inSelected;
    }
}

?>
<style type="text/css">
.category_list_box ul li label input { opacity: 0; position: absolute; }
.category_list_box ul li label span {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-pack: center;
    -ms-flex-pack: center;
    justify-content: center;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    -ms-flex-negative: 0;
    flex-shrink: 0;
    width: 24px;
    height: 24px;
    border-radius: 6px;
    overflow: hidden;
}
.category_list_box ul li label span img { width:100%; }
.category_list_box ul li label input:checked + span + p { font-weight: bold; }
.category_list_box ul li label {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    width: 100%;
    -webkit-box-pack: start;
    -ms-flex-pack: start;
    justify-content: flex-start;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    padding: 8px 0 8px 30px; 
}
.category_list_box ul li label p {
    font-size: 16px;
    line-height: 1;
    color: #000;
    padding-left: 14px;     font-weight: normal;
}
    .bf-responsive.bf-active.bf-layout-id-<?php echo $layout_id;?> .bf-check-position {
        top: <?php echo (int)$settings['style']['responsive']['offset']; ?>px;
    }
    .bf-responsive.bf-active.bf-layout-id-<?php echo $layout_id;?> .bf-btn-show, 
    .bf-responsive.bf-active.bf-layout-id-<?php echo $layout_id;?> .bf-btn-reset {
        top: <?php echo (int)$settings['style']['responsive']['offset']; ?>px;
    }
    .bf-layout-id-<?php echo $layout_id;?> .bf-btn-show {
    <?php if (isset($settings['style']['resp_show_btn_color']['val'])) : ?>
        background: <?php echo $settings['style']['resp_show_btn_color']['val']; ?>;
    <?php endif; ?>
    }
    .bf-layout-id-<?php echo $layout_id;?> .bf-btn-reset {
    <?php if (isset($settings['style']['resp_reset_btn_color']['val'])) : ?>
        background: <?php echo $settings['style']['resp_reset_btn_color']['val']; ?>;
    <?php endif; ?>
    }
    .bf-layout-id-<?php echo $layout_id;?> .bf-attr-header{
       <?php echo isset($settings['style']['block_header_background']['val'])  ? 'background: '.$settings['style']['block_header_background']['val'].';':''; ?> 
       <?php echo isset($settings['style']['block_header_text']['val']) ? 'color: '.$settings['style']['block_header_text']['val'].';':''; ?> 
    }
    .bf-layout-id-<?php echo $layout_id;?> .bf-count{
        <?php echo isset($settings['style']['product_quantity_background']['val']) ? 'background: '.$settings['style']['product_quantity_background']['val'].';':''; ?> 
       <?php echo isset($settings['style']['product_quantity_text']['val']) ? 'color: '.$settings['style']['product_quantity_text']['val'].';':''; ?> 
    }
   .bf-layout-id-<?php echo $layout_id;?> .ui-widget-header {
        <?php echo isset($settings['style']['price_slider_area_background']['val']) ? 'background: '.$settings['style']['price_slider_area_background']['val'].';':''; ?> 
   }
   .bf-layout-id-<?php echo $layout_id;?> .ui-widget-content {
         <?php echo isset($settings['style']['price_slider_background']['val']) ? 'background: '.$settings['style']['price_slider_background']['val'].';':''; ?> 
         <?php echo isset($settings['style']['price_slider_border']['val']) ? 'border:1px solid '.$settings['style']['price_slider_border']['val'].';':''; ?> 
   }
.bf-layout-id-<?php echo $layout_id;?> .ui-state-default {
         <?php echo isset($settings['style']['price_slider_handle_background']['val']) ? 'background: '.$settings['style']['price_slider_handle_background']['val'].';':''; ?> 
         <?php echo isset($settings['style']['price_slider_handle_border']['val']) ? 'border:1px solid '.$settings['style']['price_slider_handle_border']['val'].';':''; ?> 
   }
  .bf-layout-id-<?php echo $layout_id;?> .bf-attr-group-header{
        <?php echo isset($settings['style']['group_block_header_background']['val']) ? 'background: '.$settings['style']['group_block_header_background']['val'].';':''; ?> 
       <?php echo isset($settings['style']['group_block_header_text']['val']) ? 'color: '.$settings['style']['group_block_header_text']['val'].';':''; ?> 
  }
  <?php if ($settings['behaviour']['hide_empty']) : ?>
  .bf-layout-id-<?php echo $layout_id;?> .bf-row.bf-disabled, 
  .bf-layout-id-<?php echo $layout_id;?> .bf-horizontal .bf-row.bf-disabled {
      display: none;
  }
  <?php endif; ?>
</style>
<?php if (count($filters)) : ?>
<div class="bf-panel-wrapper<?php if($isResponsive) : ?> bf-responsive<?php endif; ?> <?php echo $responsivePos; ?> bf-layout-id-<?php echo $layout_id;?>">
    <div class="bf-btn-show"></div>
    <a class="bf-btn-reset" onclick="BrainyFilter.reset();"></a>
    <div class="box bf-check-position <?php if ($isHorizontal) : ?>bf-horizontal<?php endif; ?>">

        <div class="brainyfilter-panel box-content <?php if ($settings['submission']['hide_panel']) : ?>bf-hide-panel<?php endif; ?>">
            <form class="bf-form 
                    <?php if ($settings['behaviour']['product_count']) : ?> bf-with-counts<?php endif; ?> 
                    <?php if ($sliding) : ?> bf-with-sliding<?php endif; ?>
                    <?php if ($settings['submission']['submit_type'] === 'button' && $settings['submission']['submit_button_type'] === 'float') : ?> bf-with-float-btn<?php endif; ?>
                    <?php if ($limit_height) : ?> bf-with-height-limit<?php endif; ?>"
                  data-height-limit="<?php echo $limit_height_opts; ?>"
                  data-visible-items="<?php echo $slidingOpts; ?>"
                  data-hide-items="<?php echo $slidingMin; ?>"
                  data-submit-type="<?php echo $settings['submission']['submit_type']; ?>"
                  data-submit-delay="<?php echo (int)$settings['submission']['submit_delay_time']; ?>"
                  data-resp-max-width="<?php echo (int)$settings['style']['responsive']['max_width']; ?>"
                  data-resp-collapse="<?php echo (int)$settings['style']['responsive']['collapsed']; ?>"
                  data-resp-max-scr-width ="<?php echo (int)$settings['style']['responsive']['max_screen_width']; ?>"
                  method="get" action="index.php">
                <?php if ($currentRoute === 'product/search') : ?>
                <input type="hidden" name="route" value="product/search" />
                <?php else : ?>
                <input type="hidden" name="route" value="product/category" />
                <?php endif; ?>
                <?php if ($currentPath) : ?>
                <input type="hidden" name="path" value="<?php echo $currentPath; ?>" />
                <?php endif; ?>
                <?php if ($manufacturerId) : ?>
                <input type="hidden" name="autor_id" value="<?php echo $manufacturerId; ?>" />
                <?php endif; ?>
<div class="category_filter_box ">

<div class="category_filter_mob_btn_box hidden-xs">
          <div class="c_f_m-btn c_f_m-btn_category">Категории</div>
          <div class="c_f_m-btn c_f_m-btn_filter">Фильтры <img src="img/filter_ico.svg"></div>
        </div>
		 
	<? if ($manufacturerId) {
		$groupUID='c0';
		?>	
<div class="category_list_box" id="category_list_box2">
          <ul>
    <?php $i=0; foreach ($categoriesar as $category) { $i++;?>
	 <?php $isSelected = isset($selected[$groupUID]) && in_array($category['category_id'], $selected[$groupUID]); ?>
    <li><label>
<input id="bf-attr-c0_<?php echo $category['category_id']; ?>_42" data-filterid="bf-attr-c0_<?php echo $category['category_id']; ?>" type="checkbox" name="bfp_c0_<?php echo $category['category_id']; ?>" <?php if ($isSelected) : ?>checked="true"<?php endif; ?> value="<?php echo $category['category_id']; ?>"  >
<span class="color_<?=$i?>"><img src="<?php echo $category['image']; ?>"></span>
              <p><?php echo $category['name']; ?></p>
          </label>
           </li>
<?php } ?>
</ul>
</div>
	<? } ?>




                <?php foreach ($filters as $i => $section) : ?>
                        
                    <?php if ($section['type'] == 'price') : ?>
                       
                    <?php elseif ($section['type'] == 'search') : ?>
                
                      
                        
                    <?php elseif ($section['type'] == 'category') : ?>
    
                    <?php else : ?>
                        
                        <?php $curGroupId = null; ?>
                        <?php foreach ($section['array'] as $groupId => $group) : ?>
                            <?php if (isset($group['group_id']) && $settings['behaviour']['attribute_groups']) : ?>
                                <?php if ($curGroupId != $group['group_id']) : ?>
                                    <div class="bf-attr-group-header"><?php echo $group['group']; ?></div>
                                    <?php $curGroupId = $group['group_id']; ?>
                                <?php endif; ?>
                                
                            <?php endif; ?>
                            <?php $groupUID = substr($section['type'], 0, 1) . $groupId; ?>
                                <div class="category_block">
                    <div class="category_head">
                        <h5><?php echo $group['name']; ?></h5>
                        <span>
                            <svg><use xlink:href="#arrow-1"></use></svg>
                        </span>
                    </div>
    
                          
          
                                <?php $group['type'] = isset($group['type']) ? $group['type'] : 'checkbox'; ?>
                                
                                <?php if ($group['type'] == 'select') : ?>
                                
                                
                                <?php elseif (in_array($group['type'], array('slider', 'slider_lbl', 'slider_lbl_inp'))) : ?>
                              
                                
                                <?php elseif ($group['type'] === 'grid') : ?>
                               
                                
                                <?php else : ?>
                                <div class="category_filter">
                        <div class="category_filter_wrap">
                            <ul class="c_f_checkbox">
                                    <?php foreach ($group['values'] as $value) : ?>
                                    <?php $valueId  = $value['id']; ?>
                                    <li class="bf-attr-filter bf-attr-<?php echo $groupUID; ?> bf-row <?php 
                                    if (isset($totals) && isEmptyStock($groupUID, $valueId, $postponedCount, $totals, $selected) && $settings['behaviour']['hide_empty']):
                                        ?>bf-disabled<?php endif; ?>">
                                        
                                            <input id="bf-attr-<?php echo $groupUID . '_' . $valueId . '_' . $layout_id; ?>"
                                                   data-filterid="bf-attr-<?php echo $groupUID . '_' . $valueId; ?>"
                                                   type="<?php echo $group['type']; ?>" 
                                                   name="<?php echo "bfp_{$groupUID}"; ?><?php if ($group['type'] === 'checkbox') { echo "_{$valueId}"; } ?>"
                                                   value="<?php echo $valueId; ?>" 
                                                   <?php if (isset($selected[$groupUID]) && in_array($valueId, $selected[$groupUID])) : ?>checked="true"<?php endif; ?> />
                                             <label for="bf-attr-<?php echo $groupUID . '_' . $valueId . '_' . $layout_id; ?>"><span><svg><use xlink:href="#done"></use></svg></span>
                                                <?php if ($section['type'] === 'option') : ?>
                                                    <?php if ($group['mode'] === 'img' || $group['mode'] === 'img_label') : ?>
                                                        <img src="image/<?php echo $value['image'];?>" alt="<?php echo $value['name']; ?>" />
                                                    <?php endif; ?>
                                                    <?php if ($group['mode'] === 'label' || $group['mode'] === 'img_label') : ?>
                                                     <p> <?php echo $value['name']; ?></p>
                                                    <?php endif; ?>
                                                <?php else : ?>
                                                   <p> <?php echo $value['name']; ?></p>
                                                <?php endif; ?>
                                            </label>
                                        <span class="bf-cell bf-c-2 <?php if ($section['type'] == 'rating') echo 'bf-rating-' . $valueId; ?>">
                                            <span class="bf-hidden bf-attr-val"><?php echo $valueId; ?></span>
                                      
                                        </span>
                                        <span class="bf-cell bf-c-3"><?php if (isset($totals)) echo totalsDecorator($groupUID, $valueId, $totals, $selected); ?></span>
                                    </li>
                                    <?php endforeach; ?>

                                </ul></div></div>
                                <?php endif; ?>
                            </div>
                             
                        <?php endforeach; ?>
                    <?php endif; ?>
                    
                <?php endforeach; ?>
                <div class="hidden">
                <?php if (!$isHorizontal || $settings['submission']['submit_type'] == 'button') : ?><div class="bf-buttonclear-box"<?php if ($isHorizontal && $settings['submission']['submit_button_type'] == 'float') : ?>style="display:none;"<?php endif; ?>>
                         <input type="button" value="<?php echo $lang_submit; ?>" class="btn btn-primary bf-buttonsubmit" onclick="BrainyFilter.sendRequest(jQuery(this));BrainyFilter.loadingAnimation();return false;" <?php if ($settings['submission']['submit_button_type'] != 'fix' && $settings['submission']['submit_type'] != 'button' )  : ?>style="display:none;" <?php endif; ?> />
                   <?php if (!$isHorizontal) : ?><input type="reset" class="bf-buttonclear" onclick="BrainyFilter.reset();return false;" value="<?php echo $reset; ?>" /><?php endif; ?>  
                </div><?php endif; ?>    </div>
            </div>
            </form>
        </div>
    </div>
</div>
<script>
var bfLang = {
    show_more : '<?php echo $lang_show_more; ?>',
    show_less : '<?php echo $lang_show_less; ?>',
    empty_list : '<?php echo $lang_empty_list; ?>'
};
BrainyFilter.requestCount = BrainyFilter.requestCount || <?php echo $settings['behaviour']['product_count'] ? 'true' : 'false'; ?>;
BrainyFilter.requestPrice = BrainyFilter.requestPrice || <?php echo $settings['behaviour']['sections']['price']['enabled'] ? 'true' : 'false'; ?>;
BrainyFilter.separateCountRequest = BrainyFilter.separateCountRequest || <?php echo $postponedCount ? 'true' : 'false'; ?>;
BrainyFilter.min = BrainyFilter.min || <?php echo $priceMin; ?>;
BrainyFilter.max = BrainyFilter.max || <?php echo $priceMax; ?>;
BrainyFilter.lowerValue = BrainyFilter.lowerValue || <?php echo $lowerlimit; ?>; 
BrainyFilter.higherValue = BrainyFilter.higherValue || <?php echo $upperlimit; ?>;
BrainyFilter.currencySymb = BrainyFilter.currencySymb || '<?php echo $currency_symbol; ?>';
BrainyFilter.hideEmpty = BrainyFilter.hideEmpty || <?php echo (int)$settings['behaviour']['hide_empty']; ?>;
BrainyFilter.baseUrl = BrainyFilter.baseUrl || "<?php echo $base; ?>";
BrainyFilter.currentRoute = BrainyFilter.currentRoute || "<?php echo $currentRoute; ?>";
BrainyFilter.selectors = BrainyFilter.selectors || {
    'container' : '<?php echo $settings['behaviour']['containerSelector']; ?>',
     'resultscount' : '.totalcount',
    'paginator' : '<?php echo $settings['behaviour']['paginatorSelector']; ?>'
};
<?php if ($redirectToUrl) : ?>
BrainyFilter.redirectTo = BrainyFilter.redirectTo || "<?php echo $redirectToUrl; ?>";
<?php endif; ?>
jQuery(function() {
    if (! BrainyFilter.isInitialized) {  
        BrainyFilter.isInitialized = true;
        var def = jQuery.Deferred();
        def.then(function() {
            if('ontouchend' in document && jQuery.ui) {
                jQuery('head').append('<script src="catalog/view/javascript/jquery.ui.touch-punch.min.js"></script' + '>');
            }
        });
        if (typeof jQuery.fn.slider === 'undefined') {
            jQuery.getScript('catalog/view/javascript/jquery-ui.slider.min.js', function(){
                def.resolve();
                jQuery('head').append('<link rel="stylesheet" href="catalog/view/theme/default/stylesheet/jquery-ui.slider.min.css" type="text/css" />');
                BrainyFilter.init();
            });
        } else {
            def.resolve();
            BrainyFilter.init();
        }
    }
});
BrainyFilter.sliderValues = BrainyFilter.sliderValues || {};
<?php if (count($filters)) : ?>
<?php foreach ($filters as $i => $section) : ?>
<?php if (isset($section['array']) && count($section['array'])) : ?>
<?php foreach ($section['array'] as $groupId => $group) : ?>
<?php $groupUID = substr($section['type'], 0, 1) . $groupId; ?>
<?php if (in_array($group['type'], array('slider', 'slider_lbl', 'slider_lbl_inp'))) : ?>
BrainyFilter.sliderValues['<?php echo $groupUID; ?>'] = <?php echo json_encode($group['values']); ?>;
<?php endif; ?>
<?php endforeach; ?>
<?php endif; ?>
<?php endforeach; ?>
<?php endif; ?>
</script>
<?php endif; 