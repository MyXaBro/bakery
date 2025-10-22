CREATE TABLE IF NOT EXISTS cities (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS stores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  address VARCHAR(255) NOT NULL,
  city_id INT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120),
  email VARCHAR(190) NOT NULL UNIQUE,
  role ENUM('guest','client','employee','admin','director') NOT NULL DEFAULT 'client',
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  store_id INT NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  store_id INT NOT NULL,
  status ENUM('new','paid','ready','delivered','cancelled') NOT NULL DEFAULT 'new',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  qty INT NOT NULL DEFAULT 1,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

INSERT INTO cities (name) VALUES ('Москва'),('Санкт-Петербург') ON DUPLICATE KEY UPDATE name=VALUES(name);
INSERT INTO stores (name,address,city_id) VALUES ('Магазин №1','Тверская 1',1) ON DUPLICATE KEY UPDATE name=VALUES(name);
INSERT INTO categories (name) VALUES ('Хлеб'),('Выпечка') ON DUPLICATE KEY UPDATE name=VALUES(name);

CREATE OR REPLACE VIEW v_products AS
SELECT p.id, p.name, p.price, c.name AS category_name, s.name AS store_name
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN stores s ON s.id = p.store_id
WHERE p.is_active = 1;

CREATE OR REPLACE VIEW v_orders_summary AS
SELECT o.id, u.email AS customer, s.name AS store, o.status,
       SUM(oi.qty * oi.price) AS total, o.created_at
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN stores s ON s.id = o.store_id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, u.email, s.name, o.status, o.created_at;
