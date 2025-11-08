<?php
declare(strict_types=1);

use App\Services\QueueConsumerService;
use App\Services\QueueService;
use DI\Container;
use Monolog\Handler\StreamHandler;
use Monolog\Logger;
use PhpAmqpLib\Connection\AMQPStreamConnection;

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

$container = new Container();

$container->set(Logger::class, function () {
    $logger = new Logger('bakery');
    $logger->pushHandler(new StreamHandler('php://stdout'));
    return $logger;
});

$container->set(AMQPStreamConnection::class, function () {

    return new AMQPStreamConnection(
        $_ENV['RABBIT_HOST'],
        $_ENV['RABBIT_PORT'],
        $_ENV['RABBIT_USER'],
        $_ENV['RABBIT_PASS']
    );
});

$container->set(QueueService::class, function ($c) {
    return new QueueService(
        $c->get(AMQPStreamConnection::class),
        $_ENV['RABBIT_QUEUE']
    );
});

$container->set(QueueConsumerService::class, function ($c) {
    return new QueueConsumerService(
        $c->get(QueueService::class),
        $c->get(Logger::class)
    );
});

return $container;
