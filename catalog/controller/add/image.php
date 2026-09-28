<?php
class ControllerAddImage extends Controller {
    public function upload() {
        $json = array();
        $image = false;
        $path = null;
        try {
            $token = $this->request->post['token'] ?? '';
            if (!$this->seller->isLogged() || ($this->request->server['REQUEST_METHOD'] ?? '') !== 'POST'
                || !is_string($token) || empty($this->session->data['token']) || !hash_equals($this->session->data['token'], $token)) {
                throw new RuntimeException('Обновите страницу и войдите в кабинет продавца.');
            }
            $file = $this->request->files['file'] ?? array();
            if (!is_array($file) || !isset($file['tmp_name']) || !is_string($file['tmp_name'])
                || !is_uploaded_file($file['tmp_name']) || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
                throw new RuntimeException('Выберите JPG или PNG размером до 10 МБ.');
            }
            $size = @filesize($file['tmp_name']);
            if ($size === false || $size < 1 || $size > 10485760) {
                throw new RuntimeException('Выберите JPG или PNG размером до 10 МБ.');
            }
            if (!class_exists('finfo') || !function_exists('getimagesize')) {
                throw new RuntimeException('Обработка фотографий временно недоступна. Повторите попытку позже.');
            }
            $info = @getimagesize($file['tmp_name']);
            $mime = @(new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);
            if (!$info || !in_array($mime, array('image/jpeg', 'image/png'), true)
                || $info['mime'] !== $mime || $info[0] * $info[1] > 25000000) {
                throw new RuntimeException('Файл должен быть фотографией JPG или PNG до 25 мегапикселей.');
            }
            $decode = $mime === 'image/png' ? 'imagecreatefrompng' : 'imagecreatefromjpeg';
            $encode = $mime === 'image/png' ? 'imagepng' : 'imagejpeg';
            if (!function_exists($decode) || !function_exists($encode) || !function_exists('imagedestroy')) {
                throw new RuntimeException('Обработка фотографий временно недоступна. Повторите попытку позже.');
            }
            $image = @$decode($file['tmp_name']);
            if (!$image) { throw new RuntimeException('Не удалось прочитать фотографию. Выберите другой JPG или PNG.'); }
            $dir = 'catalog/sellers/' . (int)$this->seller->getId() . '/';
            if ((!is_dir(DIR_IMAGE . $dir) && !@mkdir(DIR_IMAGE . $dir, 0755, true) && !is_dir(DIR_IMAGE . $dir))
                || !is_writable(DIR_IMAGE . $dir)) {
                throw new RuntimeException('Не удалось сохранить фотографию. Повторите попытку позже.');
            }
            $path = $dir . bin2hex(random_bytes(16)) . ($mime === 'image/png' ? '.png' : '.jpg');
            $saved = $mime === 'image/png' ? @imagepng($image, DIR_IMAGE . $path) : @imagejpeg($image, DIR_IMAGE . $path, 90);
            if (!$saved) { throw new RuntimeException('Не удалось сохранить фотографию. Повторите попытку позже.'); }
            $json['path'] = $path;
        } catch (RuntimeException $e) {
            $json['error'] = $e->getMessage();
        } catch (Throwable $e) {
            $json['error'] = 'Не удалось обработать фотографию. Повторите попытку позже.';
        } finally {
            if ($image) { imagedestroy($image); }
            if (isset($json['error']) && $path !== null && is_file(DIR_IMAGE . $path)) { @unlink(DIR_IMAGE . $path); }
        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }
}
