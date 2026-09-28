

<footer id="footer">
  <div class="container">
    <div class="footer_box">
      <div class="foo_category_box">
        <ul>
         <?php foreach ($categories as $category) { ?>    
         <li><a href="<? echo $category['href'];?>"><? echo $category['name'];?></a></li>
            <? } ?>
        </ul>
      </div>
      <div class="foo_login_box">
       <a href="<? echo $loginseller;?>"> <button>
          <span>Вход для продавцов</span>
          <svg><use xlink:href="#login_ico"></use></svg>
        </button> </a>
        <ul>
        <?php foreach ($informations as $information) { ?>
          <li><a href="<?php echo $information['href']; ?>"><?php echo $information['title']; ?></a></li>
          <?php } ?>
        </ul>
      </div>
      <div class="foo_support_box">
        <p>Поддержка:</p>
        <a href="mailto:<? echo $email;?>"><? echo $email;?></a>
		
		<p>
		
		</p>
		
<div class="foo_social">
  <p>Мы в социальных сетях:</p>
  <a class="rutube" href="#" target="_blank" aria-label="Rutube">
    <svg width="32" height="32">
      <use xlink:href="#rutube"></use>
    </svg>
  </a>
  <a class="vk" href="#" target="_blank" aria-label="VK">
    <svg width="32" height="32">
      <use xlink:href="#vk"></use>
    </svg>
  </a>
</div>
      </div>
    </div>
  </div>
  <div class="footer_info_box">
    <div class="container">
      <div class="foo_info_flex">
        <p>© 2026 haramain.online. Все права защищены.</p>
        <ul>
          <li class="visa"><img src="img/visa.svg"></li>
          <li class="mastercart"><img src="img/mastercart.svg"></li>
          <li class="ipay"><img src="img/ipay.svg"></li>
        </ul>
       
      </div>
    </div>
  </div>
</footer>


<!-- svg -->
<svg display="none" xmlns="http://www.w3.org/2000/svg">
<symbol viewBox="0 0 31 26" id="cash-1">
    <path d="M25.6386 3.78929L0.803475 13.026L5.35322 25.1063L30.1884 15.8696L25.6386 3.78929ZM1.67973 13.425L25.2413 4.66185L29.3121 15.4706L5.75112 24.234L1.67973 13.425ZM17.1819 10.7456C16.1884 10.2933 15.0798 10.253 14.0595 10.6329C13.0387 11.0124 12.2285 11.7666 11.7784 12.7552C11.3283 13.7437 11.2914 14.85 11.6754 15.8692C12.0591 16.8875 12.817 17.6979 13.8106 18.1502C14.8035 18.6023 15.9123 18.6419 16.9323 18.2627C17.9532 17.8831 18.7633 17.1289 19.2134 16.1404C19.6638 15.1512 19.7005 14.0456 19.3164 13.0263C18.9333 12.0083 18.1754 11.198 17.1819 10.7456ZM16.6934 17.6272C15.8435 17.9438 14.9193 17.9103 14.0921 17.5336C13.2642 17.1567 12.633 16.4812 12.3128 15.6327C11.9929 14.7836 12.0231 13.8615 12.3984 13.0374C12.7736 12.2134 13.4486 11.5849 14.2997 11.2689C15.1493 10.9529 16.0738 10.9858 16.9017 11.3627C17.7295 11.7396 18.3607 12.4151 18.6809 13.2637C19.0008 14.1128 18.9706 15.0349 18.5954 15.859C18.2186 16.6831 17.5439 17.311 16.6934 17.6272ZM25.8051 10.9767C25.4855 10.1269 24.4646 9.66206 23.6145 9.97928C22.7363 10.3054 22.2907 11.284 22.6207 12.1603C22.7802 12.5851 23.0964 12.9223 23.5103 13.1108C23.9242 13.2992 24.3862 13.3163 24.8119 13.158C25.6892 12.8306 26.1348 11.852 25.8051 10.9767ZM24.5718 12.5219C24.0615 12.7114 23.449 12.4325 23.2568 11.9232C23.0595 11.3973 23.3265 10.8108 23.854 10.615C24.1086 10.5196 24.3857 10.5297 24.634 10.6427C24.8822 10.7557 25.0717 10.9581 25.1677 11.2131C25.366 11.7387 25.0984 12.3264 24.5718 12.5219ZM6.42067 16.374C5.54246 16.7001 5.0969 17.6787 5.42689 18.555C5.58638 18.9797 5.90258 19.317 6.3165 19.5054C6.73045 19.6939 7.19241 19.7109 7.61813 19.5527C8.49537 19.2254 8.94097 18.2467 8.61128 17.3714C8.29166 16.5216 7.27083 16.0568 6.42067 16.374ZM7.37864 18.9169C6.86831 19.1064 6.25578 18.8275 6.06365 18.3181C5.86626 17.7922 6.13327 17.2058 6.66013 17.0097C6.91485 16.9144 7.19194 16.9245 7.44078 17.0378C7.68899 17.1508 7.87856 17.3531 7.9745 17.6082C8.17213 18.1334 7.90456 18.7211 7.37864 18.9169ZM22.4296 1.05153L23.4889 3.8639L24.1256 3.62709L22.79 0.0821046L1.3556 11.7377L1.68307 12.3333L22.4296 1.05153ZM16.7697 13.9744L16.4512 14.0931C16.4341 14.0995 14.7261 14.7259 13.7759 13.8393C13.6825 13.7533 13.6563 13.6941 13.6626 13.6752C13.7415 13.413 14.8115 13.0146 15.9076 12.8386L15.7974 12.1689C15.2083 12.2632 13.2659 12.636 13.0112 13.4769C12.9489 13.683 12.9506 13.9984 13.3135 14.3352C14.2585 15.2083 15.6446 15.0092 16.3101 14.8425C16.3229 15.0349 16.2997 15.2865 16.1545 15.5201C15.8988 15.9303 15.3141 16.1975 14.4637 16.2929L14.5417 16.9674C15.6272 16.8458 16.366 16.4772 16.7391 15.8701C17.1951 15.127 16.9025 14.3263 16.8891 14.2932L16.7697 13.9744Z"/>
  </symbol>
  <symbol viewBox="0 0 9 9" id="arrow-3">
    <path d="M0.639376 4.44L3.25938 0.639998L4.25938 0.639999L1.99938 4.02L8.75938 4.02L8.75938 4.84L1.99938 4.84L4.25938 8.2L3.25938 8.2L0.639376 4.44Z"/>
  </symbol>
  <symbol viewBox="0 0 12 12" id="done">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 7l3 3 7-7"/>
  </symbol>
  <symbol viewBox="0 0 30 16" id="arrow-2">
    <path d="M29.6952 8.70711C30.0857 8.31658 30.0857 7.68342 29.6952 7.29289L23.3313 0.928932C22.9407 0.538408 22.3076 0.538408 21.917 0.928932C21.5265 1.31946 21.5265 1.95262 21.917 2.34315L27.5739 8L21.917 13.6569C21.5265 14.0474 21.5265 14.6805 21.917 15.0711C22.3076 15.4616 22.9407 15.4616 23.3313 15.0711L29.6952 8.70711ZM0.012207 9H28.9881V7H0.012207V9Z"/>
  </symbol>
  <symbol viewBox="0 0 32 30" id="card">
    <path d="M1.18382 2.36765H4.57743L9.4114 19.8488C9.54949 20.3618 10.023 20.7169 10.5557 20.7169H25.4127C25.8863 20.7169 26.3006 20.4407 26.4979 20.0066L31.904 7.57647C32.0619 7.20162 32.0224 6.78728 31.8053 6.45184C31.5883 6.1164 31.2134 5.91912 30.8188 5.91912H14.4032C13.7521 5.91912 13.2193 6.45184 13.2193 7.10294C13.2193 7.75405 13.7521 8.28677 14.4032 8.28677H29.0037L24.6235 18.3493H11.4436L6.60971 0.868161C6.47162 0.355147 5.99809 0 5.46537 0H1.18382C0.532721 0 0 0.532721 0 1.18382C0 1.83493 0.532721 2.36765 1.18382 2.36765Z"/>
    <path d="M9.43087 29.0431C10.9106 29.0431 12.1142 27.8396 12.1142 26.3598C12.1142 24.88 10.9106 23.6765 9.43087 23.6765C7.95109 23.6765 6.74756 24.88 6.74756 26.3598C6.74756 27.8395 7.95109 29.0431 9.43087 29.0431Z"/>
    <path d="M26.202 29.0431C26.2611 29.0431 26.34 29.0431 26.3992 29.0431C27.1095 28.9839 27.7606 28.6683 28.2342 28.1158C28.7077 27.5831 28.9247 26.8925 28.8853 26.1625C28.7866 24.7024 27.5042 23.5778 26.0244 23.6764C24.5446 23.7751 23.4397 25.0773 23.5384 26.5373C23.637 27.9382 24.8011 29.0431 26.202 29.0431Z"/>
  </symbol>
  <symbol viewBox="0 0 13 8" id="arrow-1">
    <path d="M1 1L6.5 6L12 1" stroke-width="2" stroke-linecap="round"/>
  </symbol>
  <symbol viewBox="0 0 18 18" id="search2">
    <path d="M17.5605 15.4395L13.7527 11.6318C14.5395 10.446 15 9.02625 15 7.5C15 3.3645 11.6355 0 7.5 0C3.3645 0 0 3.3645 0 7.5C0 11.6355 3.3645 15 7.5 15C9.02625 15 10.446 14.5395 11.6318 13.7527L15.4395 17.5605C16.0245 18.1462 16.9755 18.1462 17.5605 17.5605C18.1462 16.9747 18.1462 16.0253 17.5605 15.4395ZM2.25 7.5C2.25 4.605 4.605 2.25 7.5 2.25C10.395 2.25 12.75 4.605 12.75 7.5C12.75 10.395 10.395 12.75 7.5 12.75C4.605 12.75 2.25 10.395 2.25 7.5Z"/>
  </symbol>
  <symbol viewBox="0 0 12 14" id="login_ico">
    <path d="M5.554 8.94022C5.46292 9.03747 5.41252 9.16771 5.41366 9.30291C5.4148 9.43811 5.46739 9.56743 5.56009 9.66303C5.65279 9.75863 5.7782 9.81286 5.9093 9.81403C6.0404 9.81521 6.1667 9.76324 6.261 9.66931L8.928 6.90866C8.95128 6.88471 8.96975 6.85626 8.98236 6.82494C8.99496 6.79361 9.00145 6.76004 9.00145 6.72613C9.00145 6.69221 8.99496 6.65864 8.98236 6.62731C8.96975 6.59599 8.95128 6.56754 8.928 6.54359L6.261 3.78397C6.1667 3.69004 6.0404 3.63807 5.9093 3.63925C5.7782 3.64042 5.65279 3.69465 5.56009 3.79025C5.46739 3.88585 5.4148 4.01518 5.41366 4.15037C5.41252 4.28557 5.46292 4.41581 5.554 4.51306L7.2 6.21875H0.5C0.367392 6.21875 0.240215 6.27307 0.146447 6.36977C0.0526784 6.46647 0 6.59762 0 6.73438C0 6.87113 0.0526784 7.00228 0.146447 7.09898C0.240215 7.19568 0.367392 7.25 0.5 7.25H7.2L5.554 8.94022ZM11 0.03125H4.5C4.36739 0.03125 4.24021 0.0855746 4.14645 0.182273C4.05268 0.278971 4 0.410123 4 0.546875C4 0.683627 4.05268 0.814779 4.14645 0.911477C4.24021 1.00818 4.36739 1.0625 4.5 1.0625H10.5C10.6326 1.0625 10.7598 1.11682 10.8536 1.21352C10.9473 1.31022 11 1.44137 11 1.57812V11.8906C11 12.0274 10.9473 12.1585 10.8536 12.2552C10.7598 12.3519 10.6326 12.4062 10.5 12.4062H4.25C4.11739 12.4062 3.99021 12.4606 3.89645 12.5573C3.80268 12.654 3.75 12.7851 3.75 12.9219C3.75 13.0586 3.80268 13.1898 3.89645 13.2865C3.99021 13.3832 4.11739 13.4375 4.25 13.4375H11C11.2652 13.4375 11.5196 13.3289 11.7071 13.1355C11.8946 12.9421 12 12.6798 12 12.4062V1.0625C12 0.788995 11.8946 0.526693 11.7071 0.333296C11.5196 0.139899 11.2652 0.03125 11 0.03125Z"/>
  </symbol>
  <symbol viewBox="0 0 19 19" id="instagram">
    <g clip-path="url(#clip0_2_266)">
    <path d="M17.8397 9.09337C17.8397 10.3227 17.815 11.5556 17.8468 12.7849C17.8998 14.961 16.5327 16.6426 14.7911 17.3915C14.0916 17.6917 13.3569 17.8507 12.5973 17.8507C10.2199 17.8542 7.83892 17.886 5.46148 17.8401C3.67045 17.8048 2.19735 17.0559 1.1411 15.5792C0.586479 14.8021 0.321533 13.9189 0.321533 12.9616C0.321533 10.4287 0.321533 7.89934 0.321533 5.36646C0.321533 3.29989 1.32833 1.85505 3.11583 0.915375C3.893 0.509125 4.73729 0.336027 5.61691 0.332495C7.92371 0.332495 10.234 0.318364 12.5408 0.33956C14.3319 0.353691 15.8261 1.03902 16.9283 2.48032C17.543 3.28576 17.8397 4.2113 17.8397 5.22869C17.8397 6.51456 17.8397 7.80396 17.8397 9.09337ZM1.62507 9.09337C1.62507 10.3898 1.62507 11.6828 1.62507 12.9792C1.62507 13.5586 1.7593 14.1026 2.05958 14.5936C2.84735 15.883 4.03784 16.5118 5.51447 16.5366C7.88485 16.5719 10.2588 16.5507 12.6327 16.5436C13.2156 16.5436 13.7808 16.4235 14.3071 16.1727C15.7414 15.4874 16.5433 14.3958 16.5362 12.7567C16.5221 10.2485 16.5327 7.74038 16.5327 5.23222C16.5327 4.52217 16.3313 3.87217 15.9109 3.29989C15.0984 2.20125 13.9751 1.66076 12.6327 1.64663C10.2658 1.61836 7.89898 1.63603 5.53213 1.63956C5.02697 1.63956 4.53947 1.74201 4.0661 1.91864C2.7661 2.4026 1.55795 3.62842 1.61447 5.43358C1.65686 6.65586 1.62507 7.87462 1.62507 9.09337Z"/>
    <path d="M9.09998 12.8379C6.82145 12.8379 4.98449 11.0221 4.98096 8.76127C4.97743 6.53572 6.82852 4.7129 9.09292 4.7129C11.3644 4.70936 13.2084 6.52866 13.2119 8.77186C13.2119 11.0115 11.3715 12.8344 9.09998 12.8379ZM9.09998 11.5308C10.6508 11.5308 11.9084 10.2909 11.9049 8.7648C11.9013 7.25284 10.6437 6.01643 9.09998 6.01643C7.54917 6.01643 6.28449 7.24931 6.28449 8.77186C6.28803 10.298 7.54917 11.5344 9.09998 11.5308Z"/>
    <path d="M13.6889 3.47656C14.1658 3.47656 14.5544 3.88281 14.5544 4.38091C14.5508 4.87901 14.1587 5.28172 13.6818 5.27819C13.212 5.27466 12.8269 4.87194 12.8269 4.38444C12.8234 3.88634 13.212 3.47656 13.6889 3.47656Z"/>
    </g>
    <defs>
    <clipPath id="clip0_2_266">
    <rect width="18.087" height="18.087" fill="white" transform="translate(0 0.0146484)"/>
    </clipPath>
    </defs>
  </symbol>
<symbol id="rutube" viewBox="0 0 132 132">
  <path d="M81.5361 62.9865H42.5386V47.5547H81.5361C83.814 47.5547 85.3979 47.9518 86.1928 48.6451C86.9877 49.3385 87.4801 50.6245 87.4801 52.5031V58.0441C87.4801 60.0234 86.9877 61.3094 86.1928 62.0028C85.3979 62.6961 83.814 62.9925 81.5361 62.9925V62.9865ZM84.2115 33.0059H26V99H42.5386V77.5294H73.0177L87.4801 99H106L90.0546 77.4287C95.9333 76.5575 98.573 74.7559 100.75 71.7869C102.927 68.8179 104.019 64.071 104.019 57.7359V52.7876C104.019 49.0303 103.621 46.0613 102.927 43.7857C102.233 41.51 101.047 39.5307 99.362 37.7528C97.5824 36.0698 95.6011 34.8845 93.2223 34.0904C90.8435 33.3971 87.8716 33 84.2115 33V33.0059Z" fill="currentColor"/>
</symbol>

<symbol id="vk" viewBox="0 0 101 100">
  <g clip-path="url(#clip0_2_2)">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M7.52944 7.02944C0.5 14.0589 0.5 25.3726 0.5 48V52C0.5 74.6274 0.5 85.9411 7.52944 92.9706C14.5589 100 25.8726 100 48.5 100H52.5C75.1274 100 86.4411 100 93.4706 92.9706C100.5 85.9411 100.5 74.6274 100.5 52V48C100.5 25.3726 100.5 14.0589 93.4706 7.02944C86.4411 0 75.1274 0 52.5 0H48.5C25.8726 0 14.5589 0 7.52944 7.02944ZM17.3752 30.4169C17.9168 56.4169 30.9167 72.0418 53.7084 72.0418H55.0003V57.1668C63.3753 58.0001 69.7082 64.1252 72.2498 72.0418H84.0835C80.8335 60.2085 72.2914 53.6668 66.9581 51.1668C72.2914 48.0835 79.7915 40.5835 81.5831 30.4169H70.8328C68.4995 38.6669 61.5836 46.1668 55.0003 46.8751V30.4169H44.2499V59.2501C37.5833 57.5835 29.1668 49.5002 28.7918 30.4169H17.3752Z" fill="white"/>
  </g>
  <defs>
    <clipPath id="clip0_2_2">
      <rect width="100" height="100" fill="white" transform="translate(0.5)"/>
    </clipPath>
  </defs>
</symbol>
  <symbol viewBox="0 0 30 16" id="arrow-2">
    <path d="M29.6952 8.70711C30.0857 8.31658 30.0857 7.68342 29.6952 7.29289L23.3313 0.928932C22.9407 0.538408 22.3076 0.538408 21.917 0.928932C21.5265 1.31946 21.5265 1.95262 21.917 2.34315L27.5739 8L21.917 13.6569C21.5265 14.0474 21.5265 14.6805 21.917 15.0711C22.3076 15.4616 22.9407 15.4616 23.3313 15.0711L29.6952 8.70711ZM0.012207 9H28.9881V7H0.012207V9Z"/>
  </symbol>

  <symbol viewBox="0 0 24 24" id="city-pin" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 21.2s6.6-6 6.6-11.2A6.6 6.6 0 0 0 5.4 10c0 5.2 6.6 11.2 6.6 11.2z"/><circle cx="12" cy="9.8" r="2.5"/>
  </symbol>
  <!-- Marketplace category icons (see ControllerCommonHeader::getCategoryIcon) -->
  <symbol viewBox="0 0 24 24" id="cat-marketplace" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3 9.5 4.6 4h14.8L21 9.5"/><path d="M4.8 9.5V20h14.4V9.5"/><path d="M3 9.5a3 3 0 0 0 6 0 3 3 0 0 0 6 0 3 3 0 0 0 6 0"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-pilgrim" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 3.2 20 7v10l-8 3.8L4 17V7z"/><path d="M4 7l8 3.8L20 7"/><path d="M12 10.8V20.8"/><path d="M4.4 12.6 12 16l7.6-3.4"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-clothes" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M8.4 3.4 4 5.8 5.6 9.4l2.1-1V20.6h8.6V8.4l2.1 1L20 5.8l-4.4-2.4-1.9 1.7a3 3 0 0 1-3.8 0z"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-accessories" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4.2 8h15.6l-1.1 12H5.3z"/><path d="M9 8V6.2a3 3 0 0 1 6 0V8"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-beauty" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M10 3.4h4v2.8h-4z"/><path d="M9.2 6.2h5.6l1.2 4.2v10.2H8V10.4z"/><path d="M8.6 13.6h6.8"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-pharmacy" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <rect x="2.8" y="8" width="18.4" height="8" rx="4"/><path d="M12 8v8"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-groceries" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M2.8 5h2.4l2.4 9.6h9.2L20 8.2H6.2"/><circle cx="9" cy="18.6" r="1.5"/><circle cx="16.6" cy="18.6" r="1.5"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-fruits" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 8.4c-2.8-2-7.6 0-6.6 4.8.6 3.4 2.9 7.6 4.8 7.6.9 0 1.2-.7 1.8-.7s.9.7 1.8.7c1.9 0 4.2-4.2 4.8-7.6 1-4.8-3.8-6.8-6.6-4.8z"/><path d="M12 8.4V5.6a3 3 0 0 1 3-3"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-caucasian" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 9.6h16v5.6a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4z"/><path d="M4 11.6H2.2M20 11.6h1.8"/><path d="M9.4 6.6c0-1.2 1-1.2 1-2.4M13.4 6.6c0-1.2 1-1.2 1-2.4"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-asian" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3.2 11.4h13.6a6.8 6.8 0 0 1-6.8 6.8 6.8 6.8 0 0 1-6.8-6.8z"/><path d="M13.6 4.6 21 7.4M15 8.2 21.2 5"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-cuisine" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M7 3.2v7.2a2 2 0 0 0 4 0V3.2M9 10.4v10.4"/><path d="M17.4 3.2c-1.6 1.6-2.2 3.2-2.2 5.2s.8 2.6 2.2 2.6v9.8"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-home" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3 11.2 12 4l9 7.2"/><path d="M5.6 9.6V20.4h12.8V9.6"/><path d="M10 20.4v-5.2h4v5.2"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-electronics" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <rect x="7" y="2.6" width="10" height="18.8" rx="2.4"/><path d="M10.6 5.4h2.8"/><path d="M11 18.4h2"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-digital" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <rect x="4" y="5" width="16" height="10.4" rx="1.6"/><path d="M2.2 18.6h19.6"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-transport" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M3.8 16.6v-4.4l1.9-4.4h12.6l1.9 4.4v4.4z"/><path d="M3.8 12.2h16.4"/><circle cx="7.6" cy="16.6" r="1.6"/><circle cx="16.4" cy="16.6" r="1.6"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-kids" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 20.4S4.8 16 4.8 11.2A4.2 4.2 0 0 1 12 8.4a4.2 4.2 0 0 1 7.2 2.8c0 4.8-7.2 9.2-7.2 9.2z"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-books" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 5.6A2 2 0 0 1 6 3.6h5.2v16.8H6a2 2 0 0 0-2 2z"/><path d="M20 5.6a2 2 0 0 0-2-2h-5.2v16.8H18a2 2 0 0 1 2 2z"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-gifts" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <rect x="3.2" y="9" width="17.6" height="11.4" rx="1.6"/><path d="M3.2 13.2h17.6M12 9v11.4"/><path d="M12 9S10.6 4 8.2 4a2.2 2.2 0 0 0 0 5M12 9s1.4-5 3.8-5a2.2 2.2 0 0 1 0 5"/>
  </symbol>
  <symbol viewBox="0 0 24 24" id="cat-default" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12.6 3.2H20.4v7.8L11.2 20.2 3.6 12.6z"/><circle cx="16.6" cy="7.4" r="1.3"/>
  </symbol>
</svg>
<!-- /svg -->



 

<!-- Положил в корзину -->
<div id="add_card_popup">
  <div class="acp_bg"></div>
  <div class="add_card_popup">
    <img src="img/add_card_ico.svg">
    <h2>
      Товар успешно добавлен в корзину
    </h2>
    <a href="/index.php?route=checkout/checkout">Оформить заказ</a>
    <button>
      Продолжить покупки
    </button>
  </div>
</div>



<div id="author_popup">
  <div class="ap_bg"></div>
  <div class="author_popup">
    <div class="ap_head">
      <h2 class="title ap_title">Продавцы на площадке</h2>
      <div class="ap_close">
        <span></span>
        <span></span>
      </div>
    </div>
    <div class="ap_box">

 <?php foreach ($manufacturers as $manufacturer) { ?>
      <a href="<?php echo $manufacturer['href']; ?>" class="ap_item">
        <img src="<?php echo $manufacturer['image']; ?>">
        <h4><?php echo $manufacturer['name']; ?></h4>
      </a>
       <?php } ?>

      
    </div>
  </div>
</div>
<script src="js/mobmenu.js"></script>
<script src="js/script.js?v=00643da"></script>
<script src="js/error_popup.js?v=00643da"></script>
<script src="catalog/view/javascript/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script>
if ($(window).width()<868) {
$('a').each(function() {
  var href = $(this).attr('href');
  $(this).attr('onclick', "window.location='" + href + "'")
         .removeAttr('href');
});
}
</script>
</body></html>