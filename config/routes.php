<?php

declare(strict_types=1);

use App\Controller\HomeController;
use Slim\App;

return function (App $app): void {
    $app->get('/',HomeController::class);
};
