<?php

namespace App\Services;

use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

class QueueService
{
    private AMQPStreamConnection $connection;
    private string $queue;

    public function __construct(AMQPStreamConnection $connection, string $queue)
    {
        $this->connection = $connection;
        $this->queue = $queue;
    }

    public function publish(string $message, ?string $queueOverride = null): void
    {
        $channel = $this->connection->channel();
        $queueName = $queueOverride ?? $this->queue;

        $channel->queue_declare($queueName, false, true, false, false);

        $msg = new AMQPMessage($message);
        $channel->basic_publish($msg, '', $queueName);

        $channel->close();
    }

    public function consume(callable $callback): void
    {
        $channel = $this->connection->channel();
        $channel->queue_declare($this->queue, false, true, false, false);

        $channel->basic_consume(
            $this->queue,
            '',
            false,
            true,
            false,
            false,
            function ($msg) use ($callback) {
                $callback($msg->body);
            }
        );

        while ($channel->is_open()) {
            $channel->wait();
        }
    }

    public function __destruct()
    {
        $this->connection->close();
    }
}
