<?php
declare(strict_types=1);

use DI\Container;
use Monolog\Handler\StreamHandler;
use Monolog\Logger;

$container = new Container();

$container->set(Logger::class, function () {
    $logger = new Logger('bakery');
    $logger->pushHandler(new StreamHandler('php://stdout'));
    return $logger;
});

return $container;
