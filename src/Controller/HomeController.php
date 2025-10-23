<?php

namespace App\Controller;

use Monolog\Logger;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

readonly class HomeController
{
    public function __construct(private Logger $logger)
    {}

    public function __invoke(Request $request, Response $response): Response
    {
        $this->logger->info("HomeController: index");

        $response->getBody()->write('Добро пожаловать в Bakery!');

        return $response;
    }
}