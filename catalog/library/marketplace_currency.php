<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

namespace Cart;
class MarketplaceCurrency {
	private $currencies = array();
    private $db;
    private $language;

	public function __construct($registry) {
		$this->db = $registry->get('db');
		$this->language = $registry->get('language');

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "currency");

		foreach ($query->rows as $result) {
			$this->currencies[$result['code']] = array(
				'currency_id'   => $result['currency_id'],
				'title'         => $result['title'],
				'symbol_left'   => $result['code'] === 'SAR' ? '⃁ ' : $result['symbol_left'],
				'symbol_right'  => $result['code'] === 'SAR' ? '' : $result['symbol_right'],
				'decimal_place' => $result['decimal_place'],
				'value'         => $result['value']
			);
		}
	}

	public function format($number, $currency, $value = '', $format = true) {
		$symbol_left = $this->currencies[$currency]['symbol_left'];
		$symbol_right = $this->currencies[$currency]['symbol_right'];
		$decimal_place = $this->currencies[$currency]['decimal_place'];

		if (!$value) {
			$value = $this->currencies[$currency]['value'];
		}

		$amount = $value ? (float)$number * $value : (float)$number;
		
		$amount = round($amount, (int)$decimal_place);
		
		if (!$format) {
			return $amount;
		}

        if ($currency === 'SAR') {
            return '<span class="sar-price" style="white-space:nowrap">' . $this->getDisplaySymbol($currency) . ' ' . number_format($amount, (int)$decimal_place, $this->language->get('decimal_point'), $this->language->get('thousand_point')) . '</span>';
        }
		$string = '';

		if ($symbol_left) {
			$string .= $symbol_left;
		}

		$string .= number_format($amount, (int)$decimal_place, $this->language->get('decimal_point'), $this->language->get('thousand_point'));
$string = '<span>'.$string.'</span>';
		if ($symbol_right) {
			$string .= $symbol_right;
		}

		return $string;
	}

    // Official SAMA outline; Unicode retained for copying/accessibility. No font dependency.
    public function getDisplaySymbol($currency) {
        if ($currency !== 'SAR') return $this->getSymbolLeft($currency) ?: $this->getSymbolRight($currency);
        return '<span role="img" aria-label="Саудовский риал" style="display:inline-block;position:relative"><span style="position:absolute;width:1px;height:1px;overflow:hidden;clip-path:inset(50%)">&#x20C1;</span><svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1124.14 1256.39" style="width:.9em;height:1em;vertical-align:-.1em;fill:currentColor"><path d="M699.62,1113.02h0c-20.06,44.48-33.32,92.75-38.4,143.37l424.51-90.24c20.06-44.47,33.31-92.75,38.4-143.37l-424.51,90.24Z"/><path d="M1085.73,895.8c20.06-44.47,33.32-92.75,38.4-143.37l-330.68,70.33v-135.2l292.27-62.11c20.06-44.47,33.32-92.75,38.4-143.37l-330.68,70.27V66.13c-50.67,28.45-95.67,66.32-132.25,110.99v403.35l-132.25,28.11V0c-50.67,28.44-95.67,66.32-132.25,110.99v525.69l-295.91,62.88c-20.06,44.47-33.33,92.75-38.42,143.37l334.33-71.05v170.26l-358.3,76.14c-20.06,44.47-33.32,92.75-38.4,143.37l375.04-79.7c30.53-6.35,56.77-24.4,73.83-49.24l68.78-101.97v-.02c7.14-10.55,11.3-23.27,11.3-36.97v-149.98l132.25-28.11v270.4l424.53-90.28Z"/></svg></span>';
    }

	public function convert($value, $from, $to) {
		if (isset($this->currencies[$from])) {
			$from = $this->currencies[$from]['value'];
		} else {
			$from = 1;
		}

		if (isset($this->currencies[$to])) {
			$to = $this->currencies[$to]['value'];
		} else {
			$to = 1;
		}

		return $value * ($to / $from);
	}
	
	public function getId($currency) {
		if (isset($this->currencies[$currency])) {
			return $this->currencies[$currency]['currency_id'];
		} else {
			return 0;
		}
	}

	public function getSymbolLeft($currency) {
		if (isset($this->currencies[$currency])) {
			return $this->currencies[$currency]['symbol_left'];
		} else {
			return '';
		}
	}

	public function getSymbolRight($currency) {
		if (isset($this->currencies[$currency])) {
			return $this->currencies[$currency]['symbol_right'];
		} else {
			return '';
		}
	}

	public function getDecimalPlace($currency) {
		if (isset($this->currencies[$currency])) {
			return $this->currencies[$currency]['decimal_place'];
		} else {
			return 0;
		}
	}

	public function getValue($currency) {
		if (isset($this->currencies[$currency])) {
			return $this->currencies[$currency]['value'];
		} else {
			return 0;
		}
	}

	public function has($currency) {
		return isset($this->currencies[$currency]);
	}
}
