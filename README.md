# Сеть пекарен — PHP + Slim + MySQL (Docker)

Стартовый шаблон под учебный проект:

- PHP 8.2 + Slim 4 + Twig
- MySQL 8 + phpMyAdmin
- Nginx
- MailHog для тестовой отправки писем (http://localhost:8025)
- Подготовленные запросы (PDO), роли пользователей, авторизация через сессии + куки (учебно)

## Запуск

1) `docker compose up -d --build`

2) Установить зависимости (один раз):

`docker compose exec php composer install`

Откройте: http://localhost:8080  
phpMyAdmin: http://localhost:8081 (логин: bakery / пароль: bakery)  
MailHog: http://localhost:8025

Админ: `admin@bakery.local` / пароль: `admin` (см. sql/schema.sql)

## Структура

- `src/public` — публичные файлы (front controller `index.php`)
- `src/app` — код приложения
- `src/views` — Twig-шаблоны
- `sql` — схема БД (в т.ч. VIEW и процедуры)

## Что дальше

- Добавьте роли `employee`, `director` в интерфейсе
- Реализуйте CRUD для магазинов/категорий, мульти-удаление
- Добавьте графики продаж (например, через Chart.js)
- Замените простую куку на токен и хеш (продвинутый вариант)
