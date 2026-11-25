BEGIN;

CREATE TABLE accounts (
    id INT PRIMARY KEY,
    owner_name VARCHAR(255),
    balance DECIMAL(12, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts (id, owner_name, balance) VALUES
(1, 'Иван', 1000.00),
(2, 'Мария', 2500.00);
COMMIT;

-- Задание 1: Пессимистичная блокировка с FOR UPDATE
-- 1-ый пользователь начинает операцию 
BEGIN ISOLATION LEVEL READ COMMITTED;
-- блокируем счет Ивана, чтобы никто другой его не изменил
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;

UPDATE accounts 
SET balance = balance * 1.10 
WHERE id = 1;

-- Проверяем
SELECT balance FROM accounts WHERE id = 1; -- 1000 * 1.10 = 1100
COMMIT; -- пока не делаем 

-- 2-ой пользователь сможет увидеть изменения только после COMMIT'а первого пользователя
BEGIN ISOLATION LEVEL READ COMMITTED;
-- пытаемся прочитать баланс
SELECT balance FROM accounts WHERE id = 1; -- 1000 
-- пытаемся обновить баланс
UPDATE accounts 
SET balance = balance - 200 
WHERE id = 1;
-- FOR UPDATE не дает обновить баланс - делаем COMMIT в первой сессии, а затем UPDATE
-- Проверяем
SELECT balance FROM accounts WHERE id = 1; -- 1100 - 200 = 900

COMMIT; 
-- Сессия №2 зависла на UPDATE, потому что Сессия №1 держала блокировку FOR UPDATE. После COMMIT'а в Сессии №1, Сессиия №2 получила доступ

-- Задание 2: Создание взаимоблокировки (Deadlock)
-- Сессия №1:
BEGIN ISOLATION LEVEL READ COMMITTED;
-- блокировка счета Ивана
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
-- работаем со счетом Марии (id = 2), однако он уже заблокирован
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- Сессия №2:
BEGIN ISOLATION LEVEL READ COMMITTED;
-- блокируем счет Марии 
SELECT * FROM accounts WHERE id = 2 FOR UPDATE;
-- работаем со счетом Ивана (id = 1), однако он уже заблокирован
UPDATE accounts SET balance = balance - 300 WHERE id = 2;
UPDATE accounts SET balance = balance + 300 WHERE id = 1;
--ERROR: deadlock detected
--DETAIL: Process 12345 waits for ShareLock on transaction 67890; blocked by process 54321.

-- Правильно: обе сессии блокируют сначала id=1, потом id=2
-- Сессия 1:
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE; -- сначала Иван
SELECT * FROM accounts WHERE id = 2 FOR UPDATE; -- потом Мария
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;
COMMIT;

-- Сессия 2:
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE; -- сначала Иван (ждёт Сессию 1)
SELECT * FROM accounts WHERE id = 2 FOR UPDATE; -- потом Мария
UPDATE accounts SET balance = balance - 300 WHERE id = 2;
UPDATE accounts SET balance = balance + 300 WHERE id = 1;
COMMIT;