      <div class="office_sidebar">
        <div class="office_balance">
          <p>На балансе:</p><span><? echo $bonustotal;?> ₽</span>
       
        </div> 
     <div class="office_balance">
      <p>Всего заработано:</p><span><? echo $bonusall;?>₽</span>
      </div>
        <hr>
        <div class="office_menu_list">
          <ul>
            <li><a href="/index.php?route=account/edit">Личные данные</a></li>
            <li><a href="/index.php?route=account/order">Баланс и статистика</a></li>
            <li><a href="/index.php?route=account/return">Вывод средств</a></li>
            <li><a href="/index.php?route=account/coupon">Мои купоны</a></li>
            <li><a href="/index.php?route=account/wishlist">Лидеры продаж</a></li>
          </ul>
        </div>
        <hr>
        <div class="office_all_game">
          <a href="/index.php?route=add/product">Мои игры</a>
        </div>
        <hr>
        <div class="office_exit">
          <a href="/index.php?route=account/logout">Выход</a>
        </div>
      </div>
