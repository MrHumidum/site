<div class="checkout-totals">
<?php foreach ($totals as $total) { ?>
<div class="checkout-total-row<?php echo isset($total['code']) && $total['code'] === 'total' ? ' checkout-total-final' : ''; ?>">
<span><?php echo $total['title']; ?></span><strong><?php echo $total['text']; ?></strong>
</div>
<?php } ?>
</div>
