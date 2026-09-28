<?php
class ModelToolImage extends Model {
	public function resize($filename, $width, $height, $type = "") {

        if (!file_exists(DIR_IMAGE . $filename) || !is_file(DIR_IMAGE . $filename)) {
            return;
        }

        $info = pathinfo($filename);

        $extension = $info['extension'];

        $old_image = $filename;

        $new_image = 'cache/' . utf8_substr($filename, 0, utf8_strrpos($filename, '.')) . '-' . $width . 'x' . $height . $type .'.' . $extension;
$image_new = $new_image;
        if (!file_exists(DIR_IMAGE . $new_image) || (filemtime(DIR_IMAGE . $old_image) > filemtime(DIR_IMAGE . $new_image))) {
            $path = '';           

            $directories = explode('/', dirname(str_replace('../', '', $new_image)));

            foreach ($directories as $directory) {
                $path = $path . '/' . $directory;

                if (!file_exists(DIR_IMAGE . $path)) {
                    @mkdir(DIR_IMAGE . $path, 0777);
                }
            }

            list($width_orig, $height_orig) = getimagesize(DIR_IMAGE . $old_image);

            if ($width_orig != $width || $height_orig != $height) {

                $scaleW = $width_orig/$width;
                $scaleH = $height_orig/$height;

                $image = new Image(DIR_IMAGE . $old_image);

                if ($scaleH > $scaleW) {
                    $_height = $height * $scaleW;

                    $top_x = 0;
                    $top_y = ($height_orig - $_height) / 2;

                    $bottom_x = $width_orig;
                    $bottom_y = $top_y + $_height;

                    $image->crop($top_x, $top_y, $bottom_x, $bottom_y);
                } elseif ($scaleH < $scaleW) {
                    $_width = $width * $scaleH;

                    $top_x = ($width_orig - $_width) / 2;
                    $top_y = 0;

                    $bottom_x = $top_x + $_width;
                    $bottom_y = $height_orig;

                    $image->crop($top_x, $top_y, $bottom_x, $bottom_y);
                }

                $image->resize($width, $height, $type);
                $image->save(DIR_IMAGE . $new_image);
            } else {
                copy(DIR_IMAGE . $old_image, DIR_IMAGE . $new_image);
            }
        }        
$image_old = $old_image;

		if (mime_content_type(DIR_IMAGE . $image_old) != 'image/svg+xml' && in_array($extension, array('svg', 'SVG'))) {
			$dom = new DOMDocument;
			$dom->loadXML(file_get_contents(DIR_IMAGE . $image_old));

			if ($dom) {
				$svg = simplexml_import_dom($dom);
			}
		} elseif (mime_content_type(DIR_IMAGE . $image_old) == 'image/svg+xml') {
			$svg = simplexml_load_file(DIR_IMAGE . $image_old);
		}

		if (isset($svg)) {
			if ($svg['width'] && $svg['height']) {
				$width_orig = (string)$svg['width'];
				$height_orig = (string)$svg['height'];

				if (is_numeric($width_orig) && is_numeric($height_orig)) {
					$width_orig = (string)$svg['width'];
					$height_orig = (string)$svg['height'];
				} elseif (substr($width_orig, -2) == 'px' && substr($height_orig, -2) == 'px') {
					$width_orig = str_replace('px', '', $width_orig);
					$height_orig = str_replace('px', '', $height_orig);

					if (!is_numeric($width_orig) && !is_numeric($height_orig)) {
						$width_orig = '';
						$height_orig = '';
					}
				}
			} elseif ($svg['viewBox']) {
				$viewbox = explode(' ', $svg['viewBox']);

				$height_orig = array_pop($viewbox);
				$width_orig = array_pop($viewbox);
			} else {
				$width_orig = '';
				$height_orig = '';
			}

			if (($width_orig && $height_orig) && ($width_orig != $width || $height_orig != $height)) {
				$scale_w = $width / $width_orig;
				$scale_h = $height / $height_orig;

				$scale = min($scale_w, $scale_h);

				$new_width = (int)($width_orig * $scale);
				$new_height = (int)($height_orig * $scale);

				$svg['width'] = $new_width;
				$svg['height'] = $new_height;

				$svg->asXML(DIR_IMAGE . $image_new);
			} else {
				$svg['width'] = $width;
				$svg['height'] = $height;

				$svg->asXML(DIR_IMAGE . $image_new);
			}
		}
      
        if ($this->request->server['HTTPS']) {
            return $this->config->get('config_ssl') . 'image/' . $new_image;
        } else {
            return $this->config->get('config_url') . 'image/' . $new_image;
        }
    }
}