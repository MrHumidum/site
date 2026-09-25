# Доработка haramain.online

Изменения выполнены в существующем проекте. На рабочий сервер не опубликованы. Локальный просмотр: http://127.0.0.1:8099/ (отдельная копия файлов и отдельная база).

## Что сделано

- Категории маркетплейса и название haramain.online задаются миграциями; старые аптечные категории перенесены внутрь «Аптеки».
- Саудовская Аравия выбирается по умолчанию, остальные страны сохранены. Оформление доставки ограничено Меккой и Мединой, в том числе при использовании сохранённого адреса.
- Цены отображаются в SAR. Числовые цены товаров не конвертируются автоматически.
- Восстановлены регистрация, вход, профиль, адрес продавца, управление собственными товарами и загрузка фотографий. Доступ к чужим товарам ограничен. Продавец видит свои позиции заказов.
- Оплата переводом: реквизиты с копированием, загрузка чека, подтверждение покупателем, проверка администратором. Без заполненных реквизитов подтверждение оплаты недоступно. Повторное подтверждение не добавляет повторную историю. Чеки хранятся вне публичного доступа и выдаются администратору с проверкой прав.
- Исправлена кнопка увеличения количества: значение передаётся в корзину и учитывается в сумме. Обновление корзины больше не заменяет кнопку кабинета второй корзиной.
- Закрыта обнаруженная выдача адресов продавцов незарегистрированному покупателю. Удалён вывод содержимого сессии на странице оплаты.

## Настройка перед публикацией

Порядок миграций и резервного копирования описан в sql/README.md. После загрузки файлов обновите модификации OpenCart и очистите кэш через админку: старые сгенерированные модификации могут перекрывать новые контроллеры.

В разделе оплаты «Перевод на карту» внесите реальные реквизиты: Банк | Номер карты | Имя получателя. Уточните контакты поддержки, фирменный логотип, старые рекламные баннеры и тариф доставки: унаследованные значения требуют решения владельца. Не используйте тестовые реквизиты или тестовые учётные записи из временной базы на рабочем сайте.

Для Apache используются правила .htaccess. Для Nginx отдельно запретите HTTP-доступ к system/storage, sql, tests, tools, скрытым файлам, дампам, резервным копиям и full.php. Каталог хранения чеков должен быть закрыт от прямой выдачи веб-сервером.

## Проверки и ограничения

До просьбы прекратить тестирование изменения проверялись локально на PHP 7.4.33 и MySQL 9.5: регистрация продавца, создание товара, загрузка изображения, ограничения доступа, корзина, оформление заказа, загрузка чека и подтверждение оплаты администратором. В браузере проверены изменение количества и отсутствие второй корзины. После просьбы пользователя новые тесты не запускались; последние изменения текстов и документации дополнительно не проверялись. Совместимость с PHP 8 и конфигурацией рабочего хостинга не подтверждена.

Оригинальные config.php и каталоги system/, lk/, catalog/model-/ не редактировались. Для корзины и валюты добавлены адаптеры в catalog/library, подключаемые при запуске приложения. Исходная резервная копия находится во временной локальной папке /private/tmp/haramain-work-20260919/baseline; перед публикацией необходима отдельная резервная копия рабочего сервера.

## Изменённые файлы

- `.htaccess`
- `css/cart/style.css`
- `catalog/library/marketplace_cart.php`
- `catalog/library/marketplace_currency.php`
- `catalog/controller/seller/order.php`
- `catalog/controller/seller/address.php`
- `catalog/controller/seller/register.php`
- `catalog/controller/seller/logout.php`
- `catalog/controller/seller/profile.php`
- `catalog/controller/seller/edit.php`
- `catalog/controller/extension/payment/bank_transfer.php`
- `catalog/controller/extension/module/custom/shipping.php`
- `catalog/controller/extension/module/custom/payment.php`
- `catalog/controller/module/easyphoto.php`
- `catalog/controller/checkout/confirm.php`
- `catalog/controller/common/header.php`
- `catalog/controller/add/product.php`
- `catalog/controller/add/image.php`
- `catalog/controller/api/order.php`
- `catalog/controller/startup/startup.php`
- `catalog/model/seller/seller.php`
- `catalog/model/catalog/product.php`
- `catalog/model/marketplace/location.php`
- `catalog/model/checkout/order.php`
- `catalog/model/add/download.php`
- `catalog/model/add/product.php`
- `catalog/model/add/option.php`
- `catalog/model/add/attribute.php`
- `catalog/model/add/recurring.php`
- `catalog/model/account/address.php`
- `catalog/view/theme/default/template/seller/login.tpl`
- `catalog/view/theme/default/template/seller/account.tpl`
- `catalog/view/theme/default/template/seller/profile.tpl`
- `catalog/view/theme/default/template/seller/orders.tpl`
- `catalog/view/theme/default/template/extension/payment/bank_transfer.tpl`
- `catalog/view/theme/default/template/extension/module/seller.tpl`
- `catalog/view/theme/default/template/extension/module/featured.tpl`
- `catalog/view/theme/default/template/extension/module/imgcategory.tpl`
- `catalog/view/theme/default/template/extension/module/latest.tpl`
- `catalog/view/theme/default/template/extension/module/custom/cart.tpl`
- `catalog/view/theme/default/template/product/product.tpl`
- `catalog/view/theme/default/template/common/cart.tpl`
- `catalog/view/theme/default/template/common/footer.tpl`
- `catalog/view/theme/default/template/add/images.tpl`
- `catalog/view/javascript/common.js`
- `catalog/view/javascript/custom/cart.js`
- `admin/controller/sale/order.php`
- `admin/controller/startup/startup.php`
- `admin/model/sale/order.php`
- `admin/view/template/sale/order_info.tpl`
- `sql/v1.1.4_marketplace_completion.sql`
- `sql/v1.1.5_home_content.sql`
- `sql/v1.1.3_bank_transfer_setup.sql`
- `sql/preflight.sql`
- `sql/README.md`
- `COMPLETION.md`
- `tech.md`

## Оформление по образцу filemgr — 2026-09-22

На haramain адаптирована структура SimpleCheckout из filemgr: единая страница с данными покупателя, доставкой, способом оплаты, товарами и полной разбивкой итоговой суммы. После сохранения открывается отдельный видимый блок оплаты, без автоматического нажатия платёжных кнопок. Можно вернуться к редактированию заказа; во время отправки чека и подтверждения возврат временно блокируется. Условия заказа берутся из настроенной страницы OpenCart. Убраны три прежних разрозненных флажка с жёстко заданными ссылками. Добавлены блокировка повторного нажатия при оформлении и обработка сетевых ошибок. Исправлена опечатка чтения адреса при выборе способов оплаты.

Сохранены SAR, ограничения доставки и перевод с чеком/проверкой администратором. PayKeeper и Telegram-уведомления из filemgr не подключались: текущая задача реализована как перенос сценария оформления, с прежним согласованным способом оплаты. Это адаптация, а не точная копия темы Journal3: настройки её блоков хранятся в отсутствующей базе. Тесты и запуск приложения не выполнялись по просьбе пользователя.

Изменённые файлы этого этапа:
- `catalog/view/theme/default/template/checkout/custom.tpl`
- `catalog/view/theme/default/template/extension/module/custom/total.tpl`
- `catalog/view/javascript/custom/checkout.js`
- `catalog/controller/extension/module/custom/payment.php`
- `catalog/controller/checkout/custom.php`
- `catalog/view/theme/default/stylesheet/haramain-checkout.css`
- `catalog/view/theme/default/template/extension/payment/bank_transfer.tpl`

## Результаты проверок — 2026-09-22

По последующему разрешению пользователя тесты выполнены на изолированной базе haramain_test и локальном PHP 7.4.33. Синтаксическая проверка изменённых PHP/TPL и JavaScript checkout.js прошла. Проверены создание заказа, отклонение другого города/страны, 20 сценариев оплаты и 18 сценариев доступа/корзины. В браузере проверены увеличение количества 1→2, одна корзина в шапке, переход к оплате, возврат с сохранением данных и итог 50 + 500 доставки = 550 SAR. После удаления тестовых реквизитов подтверждение оплаты недоступно.

В ходе проверок исправлены старые правила CSS, скрывавшие способ оплаты и форму перевода; устаревшая фильтрация скрытого способа оплаты; отключённый учёт доставки в итогах. Добавлена миграция sql/v1.1.6_shipping_total.sql: её необходимо применить при переносе на рабочий сервер. Промокод скрывается на шаге оплаты, чтобы нельзя было менять сумму уже созданного заказа без возврата к редактированию.

Тестовые реквизиты удалены из локальной базы. Денежных переводов, отправки писем и изменений рабочей базы не выполнялось. PHP 8 и рабочий хостинг не проверялись.
