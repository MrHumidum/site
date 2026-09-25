<?php
// *	@copyright	OPENCART.PRO 2011 - 2017.
// *	@forum	http://forum.opencart.pro
// *	@source		See SOURCE.txt for source and other copyright.
// *	@license	GNU General Public License version 3; see LICENSE.txt

class ControllerExtensionPaymentBankTransfer extends Controller {
	// Receipt upload limits (tech.md section 4.4).
	const RECEIPT_MAX_BYTES = 10485760; // 10 MB
	const RECEIPT_EXTENSIONS = 'jpg,jpeg,png,pdf';

	public function index() {
		$this->load->language('extension/payment/bank_transfer');

		$data['text_instruction'] = $this->language->get('text_instruction');
		$data['text_description'] = $this->language->get('text_description');
		$data['text_payment'] = $this->language->get('text_payment');
		$data['text_loading'] = $this->language->get('text_loading');
		$data['text_card_number'] = $this->language->get('text_card_number');
		$data['text_card_holder'] = $this->language->get('text_card_holder');
		$data['text_card_bank'] = $this->language->get('text_card_bank');
		$data['text_copy'] = $this->language->get('text_copy');
		$data['text_copied'] = $this->language->get('text_copied');
		$data['text_copy_failed'] = $this->language->get('text_copy_failed');
		$data['text_receipt'] = $this->language->get('text_receipt');
		$data['text_receipt_help'] = sprintf($this->language->get('text_receipt_help'), round(self::RECEIPT_MAX_BYTES / 1048576));
		$data['text_receipt_choose'] = $this->language->get('text_receipt_choose');
		$data['text_receipt_current'] = $this->language->get('text_receipt_current');
		$data['text_no_cards'] = $this->language->get('text_no_cards');
		$data['error_receipt_required'] = $this->language->get('error_receipt_required');

		$data['button_confirm'] = $this->language->get('button_confirm');

		$raw = $this->config->get('bank_transfer_bank' . $this->config->get('config_language_id'));

		$data['cards'] = $this->parseCards($raw);
		$data['bank'] = nl2br(htmlspecialchars((string)$raw, ENT_QUOTES, 'UTF-8'));
        $binding = isset($this->session->data['manual_order']) ? $this->session->data['manual_order'] : array();
        $data['payment_token'] = isset($binding['token']) ? $binding['token'] : '';
        $this->load->model('checkout/order');
        $order = !empty($binding['id']) ? $this->model_checkout_order->getOrder($binding['id']) : array();
        if (!$order || (int)$binding['id'] !== (int)($this->session->data['order_id'] ?? 0) || (int)$order['customer_id'] !== (int)$this->customer->getId() || (int)$order['store_id'] !== (int)$this->config->get('config_store_id') || $order['payment_code'] !== 'bank_transfer') { $order = array(); }
        $data['payment_total'] = $order ? $this->currency->format($order['total'], $order['currency_code'], $order['currency_value']) : '';
        $data['can_pay'] = $order && (int)$order['order_status_id'] === 4 && !empty($data['cards']);

		// A receipt may already be attached if the customer re-opened the step.
		$data['receipt'] = '';

		if ($order) {
			$this->load->model('extension/payment/bank_transfer');

			$data['receipt'] = $this->model_extension_payment_bank_transfer->getReceipt($this->session->data['order_id']);
		}

		$data['upload'] = $this->url->link('extension/payment/bank_transfer/upload', '', true);
		$data['continue'] = $this->url->link('checkout/success');

		return $this->load->view('extension/payment/bank_transfer', $data);
	}

	/**
	 * Splits the admin setting into card rows.
	 * Expected format, one card per line: bank | card number | holder.
	 * Lines without separators are returned as a plain note.
	 */
	public function parseCards($raw) {
		$cards = array();

		foreach (preg_split('/\r\n|\r|\n/', (string)$raw) as $line) {
			$line = trim($line);

			if ($line === '') {
				continue;
			}

			$parts = array_map('trim', explode('|', $line));

			if ((isset($parts[1]) && !preg_match('/[1-9]/', $parts[1])) || count($parts) !== 3 || $parts[0] === '' || $parts[2] === '' || !preg_match('/^[0-9 -]{12,30}$/', $parts[1]) || strlen(preg_replace('/\D/', '', $parts[1])) < 12 || strlen(preg_replace('/\D/', '', $parts[1])) > 19) {
				continue;
			}

			$number = $parts[1];

			$cards[] = array(
				'bank'   => $parts[0],
				'number' => $number,
				// Digits only, for the clipboard button.
				'copy'   => preg_replace('/\D+/', '', $number),
				'holder' => isset($parts[2]) ? $parts[2] : ''
			);
		}

		return $cards;
	}

	/**
	 * Receives the payment receipt (image or PDF) and attaches it to the current order.
	 */
	public function upload() {
		$this->load->language('extension/payment/bank_transfer');

		$json = array();

		if (!$this->validRequest()) {
			$json['error'] = $this->language->get('error_order');
		}

		if (!$json && (!isset($this->request->files['file']) || !is_uploaded_file($this->request->files['file']['tmp_name']))) {
			$json['error'] = $this->language->get('error_receipt_upload');
		}

		if (!$json) {
			$file = $this->request->files['file'];

			if ($file['error'] != UPLOAD_ERR_OK) {
				$json['error'] = $this->language->get('error_receipt_upload');
			}

			$filename = basename(html_entity_decode($file['name'], ENT_QUOTES, 'UTF-8'));

			if (!$json && (utf8_strlen($filename) < 3 || utf8_strlen($filename) > 128)) {
				$json['error'] = $this->language->get('error_receipt_filename');
			}

			$extension = utf8_strtolower(substr($filename, strrpos($filename, '.') + 1));

			if (!$json && !in_array($extension, explode(',', self::RECEIPT_EXTENSIONS))) {
				$json['error'] = $this->language->get('error_receipt_type');
			}

			if (!$json && (filesize($file['tmp_name']) > self::RECEIPT_MAX_BYTES || filesize($file['tmp_name']) < 1)) {
				$json['error'] = sprintf($this->language->get('error_receipt_size'), round(self::RECEIPT_MAX_BYTES / 1048576));
			}

            if (!$json) {
                $types = array('jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png', 'pdf' => 'application/pdf');
                $mime = (new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);
                if ($mime !== $types[$extension] || ($extension !== 'pdf' && !@getimagesize($file['tmp_name']))) {
                    $json['error'] = $this->language->get('error_receipt_type');
                }
            }

            if (!$json) {
                // Store in the protected upload directory with a non-executable, unguessable name.
				$this->load->model('extension/payment/bank_transfer');
                $order_id = (int)$this->session->data['order_id'];
                $lock = $this->db->query("SELECT GET_LOCK('haramain_order_" . $order_id . "', 5) AS acquired");
                if (empty($lock->row['acquired'])) {
                    $json['error'] = $this->language->get('error_order');
                    $this->response->addHeader('Content-Type: application/json');
                    $this->response->setOutput(json_encode($json));
                    return;
                }
                try {
                if (!$this->validRequest()) {
                    $json['error'] = $this->language->get('error_order');
                } else {
                $stored = 'receipt_' . (int)$this->session->data['order_id'] . '_' . token(16) . '.' . $extension;

				if (!move_uploaded_file($file['tmp_name'], DIR_UPLOAD . $stored)) {
					$json['error'] = $this->language->get('error_receipt_upload');
				} else {
					$this->load->model('extension/payment/bank_transfer');
					$this->load->model('checkout/order');

					$this->model_extension_payment_bank_transfer->addReceipt($this->session->data['order_id'], $stored);

					$json['success'] = sprintf($this->language->get('text_receipt_uploaded'), $filename);
					$json['filename'] = $filename;
				}
                }
                } finally {
                    $this->db->query("SELECT RELEASE_LOCK('haramain_order_" . $order_id . "')");
                }
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	/**
	 * Customer states the transfer is done: the order goes to "Payment verification".
	 */
	public function confirm() {
		$this->load->language('extension/payment/bank_transfer');

		$json = array();

		if (!$this->validRequest(true)) {
			$json['error'] = $this->language->get('error_order');
		}


		if (!$json) {
			$this->load->model('extension/payment/bank_transfer');

			$receipt = $this->model_extension_payment_bank_transfer->getReceipt($this->session->data['order_id']);

			if (!$receipt || !is_file(DIR_UPLOAD . basename($receipt))) {
				$json['error'] = $this->language->get('error_receipt_required');
			}
		}

		if (!$json) {
			$this->load->model('checkout/order');

			$comment  = $this->language->get('text_instruction') . "\n\n";
			$comment .= $this->config->get('bank_transfer_bank' . $this->config->get('config_language_id')) . "\n\n";
			$comment .= $this->language->get('text_payment');

			if (!$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->getVerificationStatusId(), $comment, true)) {
                $json['error'] = $this->language->get('error_order');
            }

			if (!$json) { $json['success'] = $this->url->link('checkout/success'); }
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	/**
	 * "Payment verification" status, see the tech.md v1.1.0 DB contract (section 7.3).
	 */
	public function getVerificationStatusId() {
		return 5;
	}
    private function validRequest($allow_verified = false) {
        $binding = isset($this->session->data['manual_order']) ? $this->session->data['manual_order'] : array();
        $posted = isset($this->request->post['payment_token']) ? $this->request->post['payment_token'] : '';
        if (($this->request->server['REQUEST_METHOD'] ?? '') !== 'POST' || !is_string($posted)
            || empty($binding['token']) || !hash_equals($binding['token'], $posted)
            || empty($binding['id']) || (int)$binding['id'] !== (int)($this->session->data['order_id'] ?? 0)) {
            return false;
        }
        $this->load->model('checkout/order');
        $order = $this->model_checkout_order->getOrder($binding['id']);
        if (!$order || $order['payment_code'] !== 'bank_transfer'
            || (int)$order['store_id'] !== (int)$this->config->get('config_store_id')
            || (int)$order['customer_id'] !== (int)$this->customer->getId()
            || !in_array((int)$order['order_status_id'], $allow_verified ? array(4, 5) : array(4), true)) {
            return false;
        }
        return (bool)$this->parseCards($this->config->get('bank_transfer_bank' . $order['language_id']));
    }

}
