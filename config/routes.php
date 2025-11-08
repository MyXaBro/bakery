<?php

declare(strict_types=1);

use App\Controller\HomeController;
use App\Controller\QueueController;
use Slim\App;

return function (App $app): void {
    $app->get('/',HomeController::class);
    $app->get('/queue',QueueController::class);
};
