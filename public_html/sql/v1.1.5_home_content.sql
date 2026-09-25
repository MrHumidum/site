-- Update the existing editable introduction; preserve other module settings.
SET NAMES utf8mb4;
UPDATE oc_module SET setting = JSON_SET(setting,
 '$.module_description."1".title', 'haramain.online',
 '$.module_description."1".description', '<p>Маркетплейс для русскоязычных жителей и паломников Мекки и Медины.</p><p>Выбирайте товары для паломничества, одежду, продукты, технику, книги и подарки у местных продавцов. Доставка доступна в Мекке и Медине. Цены указаны в саудовских риалах.</p><p>После оформления заказа переведите оплату по указанным реквизитам и приложите чек. Администратор проверит перевод и подтвердит заказ.</p><p>Хотите предложить свои товары? Зарегистрируйтесь как продавец и добавьте товары в каталог.</p>')
WHERE module_id = 40 AND code = 'html' AND JSON_VALID(setting);

-- Retire the old Turkey promotion without deleting the article.
UPDATE oc_article a JOIN oc_article_description d ON d.article_id=a.article_id SET a.status=0 WHERE d.name='Почему стоит покупать лекарства в Турции';
