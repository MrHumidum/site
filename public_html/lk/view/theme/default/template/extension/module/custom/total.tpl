<?
if (count($totals)>2) {
 foreach ($totals as $total) {?>
					<p class="c_tl_title"><? echo $total['title'];?></p>
					<p class="c_tl_prise"><? echo $total['text'];?> </p>
					<? }
} else {?>
<p class="c_tl_title"><? echo $totals[0]['title'];?></p>
					<p class="c_tl_prise"><? echo $totals[0]['text'];?> </p>
<? } ?>