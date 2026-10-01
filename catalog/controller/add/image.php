<?php
class ControllerAddImage extends Controller {
    public function upload() {
        $json = array();
        $image = false;
        $path = null;
        try {
            // PHP discards both POST fields and files when post_max_size is exceeded.
            $post_limit = trim(ini_get('post_max_size'));
            $post_bytes = (float)$post_limit;
            switch (strtolower(substr($post_limit, -1))) {
                case 'g': $post_bytes *= 1024;
                case 'm': $post_bytes *= 1024;
                case 'k': $post_bytes *= 1024;
            }
            if ($this->seller->isLogged() && ($this->request->server['REQUEST_METHOD'] ?? '') === 'POST'
                && $post_bytes > 0 && (float)($this->request->server['CONTENT_LENGTH'] ?? 0) > $post_bytes) {
                throw new RuntimeException('Размер запроса превышает лимит сервера (' . $post_limit . '). Выберите файл меньшего размера, до 10 МБ.');
            }
            $token = $this->request->post['token'] ?? '';
            if (!$this->seller->isLogged() || ($this->request->server['REQUEST_METHOD'] ?? '') !== 'POST'
                || !is_string($token) || empty($this->session->data['token']) || !hash_equals($this->session->data['token'], $token)) {
                throw new RuntimeException('Обновите страницу и войдите в кабинет продавца.');
            }
            $file = $this->request->files['file'] ?? array();
            // Request::clean() converts scalar upload fields to strings.
            $upload_error = is_array($file) && isset($file['error']) && is_scalar($file['error'])
                ? (int)$file['error'] : UPLOAD_ERR_NO_FILE;
            $upload_errors = array(
                UPLOAD_ERR_INI_SIZE => 'Файл превышает лимит загрузки сервера (' . ini_get('upload_max_filesize') . '). Выберите файл меньшего размера, до 10 МБ.',
                UPLOAD_ERR_FORM_SIZE => 'Файл превышает допустимый размер. Выберите JPG или PNG до 10 МБ.',
                UPLOAD_ERR_PARTIAL => 'Файл загружен не полностью. Повторите попытку.',
                UPLOAD_ERR_NO_FILE => 'Выберите JPG или PNG размером до 10 МБ.',
                UPLOAD_ERR_NO_TMP_DIR => 'На сервере недоступна временная папка загрузки. Обратитесь в поддержку.',
                UPLOAD_ERR_CANT_WRITE => 'Сервер не смог записать загруженный файл. Обратитесь в поддержку.',
                UPLOAD_ERR_EXTENSION => 'Загрузка остановлена расширением сервера. Обратитесь в поддержку.'
            );
            if ($upload_error !== UPLOAD_ERR_OK) {
                throw new RuntimeException(isset($upload_errors[$upload_error])
                    ? $upload_errors[$upload_error] : 'Неизвестная ошибка загрузки файла (код ' . $upload_error . ').');
            }
            if (empty($file['tmp_name']) || !is_string($file['tmp_name'])) {
                throw new RuntimeException('PHP не передал временный файл загрузки.');
            }
            if (!is_file($file['tmp_name'])) {
                throw new RuntimeException('Временный файл загрузки не найден.');
            }
            if (!is_uploaded_file($file['tmp_name'])) {
                throw new RuntimeException('PHP не распознал файл как HTTP-загрузку.');
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
            clearstatcache(true, DIR_IMAGE . $path);
            if (!$saved || !is_file(DIR_IMAGE . $path) || @filesize(DIR_IMAGE . $path) < 1) { throw new RuntimeException('Не удалось сохранить фотографию. Повторите попытку позже.'); }
            $json['path'] = $path;
            // Match the application's image URL contract; never resolve against the seller route.
            $base = $this->config->get(!empty($this->request->server['HTTPS']) ? 'config_ssl' : 'config_url');
            $json['url'] = rtrim($base, '/') . '/image/' . $path;
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
