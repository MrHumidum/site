<?php
/** CLI-only, repeatable seed. Run from site root: php tools/haramain_demo_v120.php apply|remove-demo */
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
chdir(dirname(__DIR__)); require 'config.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$db = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE, defined('DB_PORT') ? DB_PORT : 3306);
$db->set_charset('utf8mb4');
function q($s) { global $db; return $db->query($s); }
function v($s) { global $db; return "'".$db->real_escape_string((string)$s)."'"; }
function t($s) { return '`'.DB_PREFIX.$s.'`'; }
function insertRow($table, $data) {
    global $db; $cols=q('SHOW COLUMNS FROM '.t($table)); $parts=[];
    while($c=$cols->fetch_assoc()) {
        $key=$c['Field']; if(strpos($c['Extra'],'auto_increment')!==false && !isset($data[$key])) continue;
        if(array_key_exists($key,$data)) $value=$data[$key];
        elseif($c['Default']!==null || $c['Null']==='YES') continue;
        elseif(preg_match('/int|decimal|float|double/',$c['Type'])) $value=0;
        elseif(strpos($c['Type'],'date')!==false) $value=date('Y-m-d H:i:s');
        else $value='';
        $parts[]='`'.$key.'`='.v($value);
    }
    q('INSERT INTO '.t($table).' SET '.implode(',',$parts)); return $db->insert_id;
}
function aliasId($key) { $r=q('SELECT query FROM '.t('url_alias').' WHERE keyword='.v($key))->fetch_assoc(); return $r?(int)substr($r['query'],strpos($r['query'],'=')+1):0; }
function aliasSet($query,$key) { $r=q('SELECT query FROM '.t('url_alias').' WHERE keyword='.v($key))->fetch_assoc(); if($r && $r['query']!==$query) throw new Exception('Alias collision: '.$key); if(!$r) insertRow('url_alias',['query'=>$query,'keyword'=>$key]); }
$langs=[];$r=q('SELECT language_id FROM '.t('language'));while($a=$r->fetch_assoc())$langs[]=(int)$a['language_id'];
if(($argv[1]??'')==='remove-demo') {
    // Retain order history and product IDs; disable only this seed's products.
    q('UPDATE '.t('product')." SET status=0 WHERE model LIKE 'HARAMAIN-DEMO-V120-%'");
    $r=q('SELECT setting_id,value FROM '.t('setting')." WHERE code='bank_transfer' AND `key` LIKE 'bank_transfer_bank%'");
    while($a=$r->fetch_assoc()) {
        $lines=preg_split('/\R/',$a['value']); $lines=array_filter($lines,function($s){return !preg_match('/\|\s*TEST 0000 0000 000[1-3]\s*\|/',$s);});
        q('UPDATE '.t('setting').' SET value='.v(implode("\n",$lines)).' WHERE setting_id='.(int)$a['setting_id']);
    }
    foreach(glob(DIR_CACHE.'cache.*')?:[] as $file)if(is_file($file))unlink($file);
    echo "Demo products disabled; demo payment rows removed. Orders and category tree retained.\n"; exit;
}
if(($argv[1]??'')!=='apply') exit("Usage: php tools/haramain_demo_v120.php apply|remove-demo\n");
if((int)q('SELECT COUNT(*) n FROM '.t('category').' WHERE category_id IN (105,106,108,109,110)')->fetch_assoc()['n'] !== 5) throw new Exception('Apply migrations v1.1.0 through v1.1.6 first.');
if(!q("SELECT GET_LOCK('haramain_seed_v120',10) AS l")->fetch_assoc()['l']) throw new Exception('Seed busy');
function category($key,$name,$parent,$order=0) {
    global $langs; $id=aliasId('hm-'.$key);
    if(!$id) {
        $id=insertRow('category',['parent_id'=>$parent,'top'=>1,'column'=>1,'sort_order'=>$order,'status'=>1,'noindex'=>0,'image'=>'catalog/haramain-categories/default.svg']);
        foreach($langs as $l) insertRow('category_description',['category_id'=>$id,'language_id'=>$l,'name'=>$name,'meta_title'=>$name]);
        insertRow('category_to_store',['category_id'=>$id,'store_id'=>0]);
        aliasSet('category_id='.$id,'hm-'.$key);
    }
    return $id;
}
$g=[];foreach(['dairy'=>'Молочные продукты','meat'=>'Мясо и птица','fish'=>'Рыба и морепродукты','pantry'=>'Бакалея','beverages'=>'Напитки','water'=>'Вода','sweets'=>'Сладости','snacks'=>'Снеки','bread'=>'Хлеб и выпечка','frozen'=>'Замороженные продукты','spices'=>'Соусы и специи','tea'=>'Чай и кофе'] as $k=>$name)$g[$k]=category('grocery-'.$k,$name,106,count($g));
$cuisine=category('cuisine','Кухня',0,8);
// IDs and existing aliases survive. Rebuild only paths in the affected trees below.
q('UPDATE '.t('category').' SET parent_id='.$cuisine.' WHERE category_id IN (108,109,110)');
$c=[];foreach(['arabic'=>'Арабская кухня','european'=>'Европейская кухня','fastfood'=>'Фастфуд','bakery'=>'Выпечка','desserts'=>'Десерты'] as $k=>$name)$c[$k]=category('cuisine-'.$k,$name,$cuisine,count($c));
$pilaf=category('caucasian-pilaf','Плов',108);$manti=category('caucasian-manti','Манты',108,1);$noodles=category('asian-noodles','Рис и лапша',109);
$parents=[];$r=q('SELECT category_id,parent_id FROM '.t('category'));while($a=$r->fetch_assoc())$parents[(int)$a['category_id']]=(int)$a['parent_id'];
foreach($parents as $id=>$parent) {
    $path=[$id];$next=$parent;while($next){if(in_array($next,$path,true))throw new Exception('Category cycle');array_unshift($path,$next);$next=$parents[$next]??0;}
    if(!in_array(106,$path,true) && !in_array($cuisine,$path,true))continue;
    q('DELETE FROM '.t('category_path').' WHERE category_id='.$id);
    foreach($path as $level=>$ancestor)insertRow('category_path',['category_id'=>$id,'path_id'=>$ancestor,'level'=>$level]);
}
// [slug, name, price, leaf category, description]
$products=[
 ['paracetamol','Парацетамол, 10 таблеток',12,80,'Демонстрационная упаковка для проверки заказа. Не является предложением лекарственного средства.'],
 ['vitamin-c','Витамин C, 20 таблеток',18,74,'Демонстрационная упаковка витамина C.'],
 ['bandages','Бинт стерильный, 5 м',5,76,'Демонстрационная упаковка перевязочного материала.'],
 ['milk','Молоко, 1 л',6,$g['dairy'],'Молоко в картонной упаковке, 1 литр.'],
 ['rice','Рис басмати, 1 кг',15,$g['pantry'],'Длиннозёрный рис басмати, упаковка 1 кг.'],
 ['water','Вода питьевая, 1,5 л',2,$g['water'],'Негазированная питьевая вода, 1,5 литра.'],
 ['dates','Финики, 500 г',20,$g['sweets'],'Финики в упаковке, 500 граммов.'],
 ['juice','Апельсиновый сок, 1 л',8,$g['beverages'],'Апельсиновый сок, упаковка 1 литр.'],
 ['pilaf','Плов, порция 350 г',25,$pilaf,'Порция плова с рисом, мясом и морковью.'],
 ['shawarma','Шаурма с курицей',15,$c['fastfood'],'Лаваш с курицей и овощами.'],
 ['manti','Манты, 5 шт.',22,$manti,'Пять мантов с мясной начинкой.'],
 ['samsa','Самса, 2 шт.',10,$c['bakery'],'Две самсы из слоёного теста.'],
 ['noodles','Лапша с овощами, 300 г',18,$noodles,'Лапша с овощами, порция 300 граммов.']
];
foreach($products as $p) {
    [$slug,$name,$price,$cat,$desc]=$p;$model='HARAMAIN-DEMO-V120-'.strtoupper($slug);
    $existing=q('SELECT product_id FROM '.t('product').' WHERE model='.v($model))->fetch_assoc();
    if($existing) {echo "Existing demo ".$existing['product_id']."\n";continue;}
    $id=insertRow('product',['model'=>$model,'sku'=>$model,'quantity'=>100,'stock_status_id'=>7,'image'=>'catalog/haramain-demo-v120/'.$slug.'.png','manufacturer_id'=>0,'shipping'=>1,'price'=>$price,'date_available'=>date('Y-m-d'),'subtract'=>1,'minimum'=>1,'status'=>1,'noindex'=>1]);
    foreach($langs as $l) insertRow('product_description',['product_id'=>$id,'language_id'=>$l,'name'=>'ДЕМО · '.$name,'description'=>'<p><strong>Демонстрационный товар. Не для продажи. Не переводите реальные деньги.</strong></p><p>'.$desc.'</p>','meta_title'=>'ДЕМО · '.$name,'tag'=>'демо']);
    insertRow('product_to_store',['product_id'=>$id,'store_id'=>0]);
    insertRow('product_to_category',['product_id'=>$id,'category_id'=>$cat,'main_category'=>1]);
    aliasSet('product_id='.$id,'hm-demo-'.$slug);
    echo 'Demo '.$id.' '.$slug."\n";
}
foreach($langs as $l) {
    $key='bank_transfer_bank'.$l;$r=q('SELECT setting_id,value FROM '.t('setting')." WHERE store_id=0 AND `key`=".v($key))->fetch_assoc();
    $demo="ДЕМО Test Bank | TEST 0000 0000 0001 | ДЕМО — не переводите деньги\nДЕМО Test Bank | TEST 0000 0000 0002 | ДЕМО — не переводите деньги\nДЕМО Test Bank | TEST 0000 0000 0003 | ДЕМО — не переводите деньги";
    if(!$r)insertRow('setting',['store_id'=>0,'code'=>'bank_transfer','key'=>$key,'value'=>$demo,'serialized'=>0]);
    elseif(trim($r['value'])==='')q('UPDATE '.t('setting').' SET value='.v($demo).' WHERE setting_id='.(int)$r['setting_id']);
}
q('UPDATE '.t('currency')." SET symbol_left='⃁ ',symbol_right='' WHERE code='SAR'");
foreach(glob(DIR_CACHE.'cache.*')?:[] as $file)if(is_file($file))unlink($file);
q("SELECT RELEASE_LOCK('haramain_seed_v120')");
echo "Seed complete. Cuisine category: $cuisine\n";
