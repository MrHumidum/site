<?php echo $header; ?><div class="sticky_padding"></div>
<section id="office"><div class="container"><h1>Заказы и статистика</h1><div class="office_box"><?php echo $acc; ?><div class="office_block">
<p>Доход учитывается после подтверждения оплаты администратором.</p>
<div class="table-responsive"><table class="table"><thead><tr><th>Заказ</th><th>Товар</th><th>Статус</th><th>Сумма</th><th>Доход</th></tr></thead><tbody>
<?php foreach ($orders as $order) { ?><tr><td>#<?php echo (int)$order['order_id']; ?></td><td><?php echo htmlspecialchars($order['prname'], ENT_QUOTES, 'UTF-8'); ?></td><td><?php echo htmlspecialchars($order['status'], ENT_QUOTES, 'UTF-8'); ?></td><td><?php echo $order['amount']; ?></td><td><?php echo $order['earned']; ?></td></tr><?php } ?>
<?php if (!$orders) { ?><tr><td colspan="5">Заказов пока нет.</td></tr><?php } ?>
</tbody></table></div>
<?php if ($previous) { ?><a class="btn btn-default" href="<?php echo $previous; ?>">Назад</a><?php } ?>
<?php if ($next) { ?><a class="btn btn-default" href="<?php echo $next; ?>">Далее</a><?php } ?>
</div></div></div></section><?php echo $footer; ?>
