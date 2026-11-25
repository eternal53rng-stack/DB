BEGIN;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0) 
);

CREATE TABLE order_history (
    log_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products (product_id),
    quantity_changed INT NOT NULL,
    notes VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_id, name, quantity) VALUES
(1, 'Ноутбук', 20),
(2, 'Смартфон', 50);
COMMIT;

-- Задание 1: Успешная продажа (COMMIT):
BEGIN;

UPDATE products 
SET quantity = quantity - 5 
WHERE product_id = 1;

INSERT INTO order_history (product_id, quantity_changed, notes) 
VALUES (1, -5, 'Продажа 5 ноутбуков');

COMMIT;

-- Проверка (осталось 15 товаров с ID = 1, а в истории появилась соответствующая запись):
SELECT * FROM products WHERE product_id = 1;
SELECT * FROM order_history;

-- Задание 2: Неудачная продажа (ROLLBACK):
BEGIN;

UPDATE products 
SET quantity = quantity - 100 
WHERE product_id = 2;

INSERT INTO order_history (product_id, quantity_changed, notes) 
VALUES (2, -100, 'Попытка продажи 100 смартфонов');

SELECT quantity FROM products WHERE product_id = 2;

ROLLBACK;

-- Проверка (осталось 50 товаров с ID = 2, а в истории нет новых записей)
SELECT * FROM products WHERE product_id = 2;

SELECT * FROM order_history WHERE product_id = 2;

-- Задание 3: Ручной откат
BEGIN;

UPDATE products 
SET quantity = quantity - 2 
WHERE product_id = 1;

SELECT quantity FROM products WHERE product_id = 1;

INSERT INTO order_history (product_id, quantity_changed, notes) 
VALUES (1, -2, 'Продажа 2 ноутбуков');

COMMIT; -- если все верно
ROLLBACK; -- если не верно

--Задание 4: Демонстрация уровня изоляции
-- Сессия №1:
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE products 
SET quantity = quantity - 10 
WHERE product_id = 2;

SELECT quantity FROM products WHERE product_id = 2;

COMMIT;

-- Сессия №2 может запросить актуальные данные с базы только после COMMIT'а Сессии №1
BEGIN ISOLATION LEVEL READ COMMITTED;

SELECT * FROM products WHERE product_id = 2;
SELECT * FROM products WHERE product_id = 2;

COMMIT;