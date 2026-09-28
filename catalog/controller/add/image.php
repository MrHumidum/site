<?php
class ControllerAddImage extends Controller {
    public function upload() {
        $json = array();
        $token = $this->request->post['token'] ?? '';
        if (!$this->seller->isLogged() || ($this->request->server['REQUEST_METHOD'] ?? '') !== 'POST'
            || !is_string($token) || empty($this->session->data['token']) || !hash_equals($this->session->data['token'], $token)) {
            $json['error'] = 'Обновите страницу и войдите в кабинет продавца.';
        } else {
            $file = $this->request->files['file'] ?? array();
            if (empty($file['tmp_name']) || !is_uploaded_file($file['tmp_name']) || (int)$file['error'] !== UPLOAD_ERR_OK || filesize($file['tmp_name']) > 10485760) {
                $json['error'] = 'Выберите JPG или PNG размером до 10 МБ.';
            } else {
                $info = @getimagesize($file['tmp_name']);
                $mime = (new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);
                if (!$info || !in_array($mime, array('image/jpeg', 'image/png'), true) || $info[0] * $info[1] > 25000000) {
                    $json['error'] = 'Файл должен быть фотографией JPG или PNG до 25 мегапикселей.';
                } else {
                    $image = $mime === 'image/png' ? @imagecreatefrompng($file['tmp_name']) : @imagecreatefromjpeg($file['tmp_name']);
                    $dir = 'catalog/sellers/' . (int)$this->seller->getId() . '/';
                    if (!is_dir(DIR_IMAGE . $dir)) { mkdir(DIR_IMAGE . $dir, 0755, true); }
                    $path = $dir . bin2hex(random_bytes(16)) . ($mime === 'image/png' ? '.png' : '.jpg');
                    $saved = $image && ($mime === 'image/png' ? imagepng($image, DIR_IMAGE . $path) : imagejpeg($image, DIR_IMAGE . $path, 90));
                    if ($image) { imagedestroy($image); }
                    if ($saved) { $json['path'] = $path; } else { $json['error'] = 'Не удалось сохранить фотографию.'; }
                }
            }
        }
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }
}
