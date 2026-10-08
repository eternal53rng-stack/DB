-- Создание таблицы Покупателей
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    recommended_by INT,
    FOREIGN KEY (recommended_by) REFERENCES Customers(customer_id)
);

-- Создание таблицы Товаров
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Создание таблицы Заказов
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Создание таблицы Состава Заказа
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Наполнение таблиц данными
INSERT INTO Customers (customer_id, full_name, email, registration_date, recommended_by) VALUES
(1, 'Иван Иванов', 'ivan.ivanov@example.com', '2023-01-15', NULL),
(2, 'Мария Петрова', 'maria.petrova@example.com', '2023-02-20', 1),
(3, 'Алексей Смирнов', 'alex.smirnov@example.com', '2023-03-10', 1),
(4, 'Елена Васильева', 'elena.v@example.com', '2023-04-01', 2),
(5, 'Андрей Николаев', 'andrey.n@example.com', '2023-05-01', NULL);

INSERT INTO Products (product_name, category, price) VALUES
('Смартфон', 'Электроника', 70000.00),
('Ноутбук', 'Электроника', 120000.00),
('Кофемашина', 'Бытовая техника', 25000.00),
('Книга "Основы SQL"', 'Книги', 1500.00),
('Фен', 'Бытовая техника', 4500.00),
('Пылесос', 'Бытовая техника', 15000.00);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-05-10', 'Доставлен'),
(2, '2024-05-12', 'В обработке'),
(1, '2024-05-15', 'Отправлен'),
(3, '2024-05-16', 'Доставлен');

INSERT INTO Order_Items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 70000.00),  -- Иван купил Смартфон
(1, 4, 2, 1400.00),   -- и 2 книги
(2, 2, 1, 120000.00), -- Мария купила Ноутбук
(3, 3, 1, 25000.00),  -- Иван купил Кофемашину
(4, 1, 1, 70000.00),  -- Алексей купил Смартфон
(4, 5, 1, 4500.00);   -- и Фен

-- 1. Количество товаров по категориям
SELECT category, COUNT(product_id) AS items_count
FROM Products
GROUP BY category;

-- 2. Общая выручка
SELECT SUM(quantity * price_per_unit) AS total_revenue
FROM Order_Items;

-- 3. Количество заказов на клиента
SELECT c.full_name, COUNT(o.order_id) AS orders_count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- 4. Средний чек
SELECT SUM(quantity * price_per_unit) / COUNT(DISTINCT order_id) AS average_check
FROM Order_Items;

-- 5. Статус заказов
SELECT status, COUNT(order_id) AS status_count
FROM Orders
GROUP BY status;

-- 6. "Крупные" категории (HAVING)
SELECT category
FROM Products
GROUP BY category
HAVING COUNT(product_id) > 1;

-- 7. "Лояльные" клиенты (HAVING)
SELECT c.full_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING COUNT(o.order_id) > 1;

-- 8. Самый продаваемый товар
SELECT p.product_name
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY SUM(oi.quantity) DESC
LIMIT 1;