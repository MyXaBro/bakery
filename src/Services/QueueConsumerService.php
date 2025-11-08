<?php

namespace App\Services;

use Monolog\Logger;

class QueueConsumerService
{
    private QueueService $queue;

    public function __construct(QueueService $queue, private readonly Logger $logger)
    {
        $this->queue = $queue;
    }

    public function run(): void
    {
        $this->logger->info('Запуск QueueConsumerService...');

        $this->queue->consume(function ($message) {
            $this->logger->info("Получено сообщение: $message");
            $this->handleMessage($message);
        });
    }

    private function handleMessage(string $message): void
    {
        $this->logger->info("Обработка общего сообщения: $message");
    }
}
