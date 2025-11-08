<?php

namespace App\Controller;

use App\Services\QueueService;
use Monolog\Logger;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

readonly class QueueController
{
    public function __construct(private Logger $logger, private QueueService $queueService)
    {}

    public function __invoke(Request $request, Response $response): Response
    {
        $logger = $this->logger;

        $logger->info("Работа с RabbitMQ");

        $queue = $this->queueService;
        $queue->publish('Привет из Bakery!', 'shop');

        $response->getBody()->write('Сообщение отправлено в очередь!');
        return $response;
    }
}