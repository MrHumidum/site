      <div class="office_sidebar">
        <div class="office_balance">
          <p>На балансе:</p><span><?php echo $bonustotal; ?></span>
       
        </div> 
     <div class="office_balance">
      <p>Всего заработано:</p><span><?php echo $bonusall; ?></span>
      </div>
        <hr>
        <div class="office_menu_list">
          <ul>
            <li><a href="/index.php?route=seller/edit">Личные данные и адрес</a></li>
            <li><a href="/index.php?route=seller/order">Баланс и статистика</a></li>
          </ul>
        </div>
        <hr>
        <div class="office_all_products">
          <a href="/index.php?route=add/product">Мои товары</a>
        </div>
        <hr>
        <div class="office_exit">
          <a href="/index.php?route=seller/logout">Выход</a>
        </div>
      </div>
