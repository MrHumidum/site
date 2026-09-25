<?php
class ControllerModuleEasyphoto extends Controller {
    public function __construct($registry) {
        parent::__construct($registry);
        http_response_code(404);
        exit;
    }
}
