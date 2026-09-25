# Отчёт: DEV_A + DEV_B (haramain.online, tech.md v1.1.0)

## DEV_A

### A1. Ребрендинг
| Файл | Изменение |
|---|---|
| `common/header.tpl`, `common/headerhome.tpl` | логотип из `config_logo` с фолбэком `image/catalog/logo-haramain.png`, alt/title `haramain.online`; слоган «Маркетплейс: Мекка и Медина» |
| `common/footer.tpl` | копирайт «© 2026 haramain.online. Все права защищены.» |
| `product/category.tpl` | «Игр в категории» → «Товаров в категории» |
| 13 шаблонов + `css/office/style.css`, `media/office/media.css` | классы `add_game_btn` → `add_product_btn`, `office_all_game` → `office_all_products`, мёртвый `error_game_btn` удалён |
| `js/script.js` | комментарий переведён на английский |
| `information/contact.php` | тема письма «Проблемы с игрой» → «Проблема с заказом (%s)» |
| `image/catalog/logo-haramain.png` | новый файл (пока копия старого логотипа) |

### A2. Дерево категорий
* `common/header.php`: метод `getCategoryIcon()` — карта `category_id` (100–117 из контракта tech.md §7.4) → id символа в SVG-спрайте; `category_id` и `icon` добавлены в `categories2` и в детей.
* `common/footer.tpl`: 19 новых `<symbol>` (18 категорий + `cat-default`).
* `header.tpl`, `headerhome.tpl`: двухуровневое меню с иконками — десктоп (сетка) и бургер.
* `css/style.css`: блок стилей меню; дропдаун переведён на CSS grid, иконки 20×20.

### A3. Селектор города
* `common/header.php`: `getCities()`, `getCity()`, `city()` (пишет `$this->session->data['city']`, сбрасывает выбранную доставку, редирект только внутрь магазина), `getCurrentUrl()`.
* `header.tpl`, `headerhome.tpl`: селектор в шапке + дубль в бургер-меню (на ≤770px шапка переполнялась).
* `footer.tpl`: символ `#city-pin`. `css/style.css`: стили.
* Языки: `ru-ru/common/header.php`, `en-gb/common/header.php`.

### A4. Форма товара продавца
* `add/product.php`: `getCities()`, `$data['cities']`, `error_city`, обязательная валидация города; строки для валюты.
* `add/product_form.tpl`: поле «Расположение» (`location`) → обязательный select «Город нахождения товара» (Мекка/Медина); поля цены получили суффикс «риал».
* `ru-ru/add/product.php`: `entry_city`, `error_city`, `text_city_*`, `text_currency_sar`.
* Категории: форма берёт их из `model/add/category::getAllCategories()`, новые id 100–117 подхватываются после сброса кэша.

## DEV_B

### B1. Валюта SAR
* `startup/startup.php`: отключённая валюта больше не может остаться в сессии/cookie (иначе старые сессии продолжали показывать рубли).
* `common/currency.php`: переключение только на валюту со статусом 1.
* `custom/cart.php` + `custom/cart.tpl`: старая цена форматируется через `currency->format`, хардкод `₽` убран.
* `product/special.tpl`: убрана вторая валюта (цена уже отформатирована).
* Балансы кабинета (`extension/module/seller.php`, `seller/coupon.php`, `account/coupon.php` + 4 шаблона): формат через валюту вместо `₽`.

### B2. Город в оформлении заказа
* `custom/shipping.php`: `getCities()`, `getSelectedCity()` (подставляет город из шапки), серверный whitelist города в `getAddress()`.
* `custom/shipping.tpl`: текстовое поле города → обязательный select из двух опций.
* `custom/customer.tpl`: убраны тексты про «скачивание игр», исправлен текст про телефон.
* Язык `custom/shipping.php`: `text_city_*`, понятная ошибка.

### B3. Оплата переводом на карту
* `extension/payment/bank_transfer.php` переписан: `parseCards()` (формат `Банк | Номер | Получатель`), `upload()` (JPG/PNG/PDF ≤10 МБ, имя `receipt_<order_id>_<token>.<ext>`, запись в `oc_order.receipt_file`), `confirm()` (требует чек, ставит статус проверки), `getVerificationStatusId()`.
* `model/extension/payment/bank_transfer.php`: `addReceipt()`, `getReceipt()`.
* `extension/payment/bank_transfer.tpl`: реквизиты карт, кнопка «Скопировать» + toast, загрузка чека, кнопка «Я оплатил».
* `custom/checkout.js`: шаг с `data-manual-step` показывается покупателю вместо авто-подтверждения.
* `custom/payment.tpl` + контроллер + язык: подсказка при выборе способа оплаты.
* `css/cart/style.css`: стили блока, тоста, подсказки.

### B4. Чек в админке
* `admin/controller/sale/order.php`: константы статусов, данные чека в `info()`, метод `receipt()` (отдаёт файл с проверкой прав, `basename` против traversal, `nosniff`).
* `admin/view/template/sale/order_info.tpl`: панель «Чек об оплате» с превью и кнопками «Подтвердить оплату» / «Отклонить» (переиспользуют существующую отправку истории).
* `admin/language/ru-ru/sale/order.php`: строки чека.

## Проверки
* `php -l` — 36 изменённых PHP/TPL файлов, ошибок нет.
* `node --check` — `js/script.js`, `custom/checkout.js`.
* Визуально в браузере: шапка 1440px и 375px, меню категорий (десктоп + бургер), селектор города, блок оплаты — копирование номера с тостом и блокировка подтверждения без чека.

## Что сделано дополнительно (после отчёта DEV_A/DEV_B)

* `catalog/model/seller/seller.php`, `admin/model/sale/order.php`: условие оплаченного заказа `order_status_id > 1` заменено на `IN (1, 2)` — иначе статусы 4 «Ожидает оплаты» и 5 «Проверка чека» засчитывались бы продавцу как выручка (5 мест).
* `image/catalog/logo-haramain.svg`: временный текстовый логотип вместо чужого «FARM SHOPPING»; шапка использует `config_logo`, а этот файл как фолбэк.
* `sql/v1.1.1_store_identity.sql`: название магазина, владелец, SEO-мета, путь к логотипу.
* `sql/v1.1.2_move_legacy_categories.sql`: старые категории 73–92 переносятся под «Аптека» (105).
* `sql/v1.1.3_bank_transfer_setup.sql`: регистрация и включение способа оплаты «Перевод на карту», статусы 4/5, отключение `cod` и `free_checkout`.
* Локально очищены логи (145 МБ) и файлы кэша OpenCart.
* Все четыре миграции проверены на боевом дампе во временном MySQL: меню верхнего уровня даёт ровно 11 пунктов, старые категории показывают путь «Маркетплейс > Аптека», настройки и платёжный модуль на месте.

## Осталось за вами

1. Применить миграции и залить файлы на сервер — порядок в `sql/README.md`. После заливки обязательно `rm -f system/storage/cache/cache.*`.
2. Вписать реквизиты карт в админке: Модули → Оплата → Перевод на карту, формат `Банк | Номер карты | Имя получателя` (tech.md §7.5).
3. Подтвердить контакты поддержки: в `sql/v1.1.1_store_identity.sql` три `UPDATE` закомментированы, сейчас в БД стоят `aptekaturk1@gmail.com` и российский номер.
4. Заменить `image/catalog/logo-haramain.svg` на фирменный логотип.
5. По желанию: удалить `full.php` в корне (печатает пути сервера) и мусорные файлы `catalog/controller/product/account.tpl`, `extension/module/seller (2).tpl`, ярлыки `*.lnk`. Я их не трогал.
