--Практическая работа 3-5:
--1 (Схема)
--2 (Создание таблиц):
CREATE TABLE Readers (
    reader_id SERIAL PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE Books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    CONSTRAINT chk_books_year CHECK (year > 0 AND year <=2026)
);

CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE Book_Authors (
    author_id INT NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    PRIMARY KEY (author_id, isbn),
    FOREIGN KEY (author_id) REFERENCES Authors (author_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (isbn) REFERENCES Books (isbn)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Loans (
    loan_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL,
    reader_id INT NOT NULL,
    date_of_giving DATE NOT NULL,
    planned_date_of_returning DATE NOT NULL,
    real_date_of_returning DATE, 
    FOREIGN KEY (isbn) REFERENCES Books (isbn),
    FOREIGN KEY (reader_id) REFERENCES Readers (reader_id),
    CONSTRAINT chk_givings_return CHECK (real_date_of_returning IS NULL OR real_date_of_returning >= date_of_giving),
    CONSTRAINT chk_givings_planned CHECK (planned_date_of_returning >= date_of_giving)
);


--3 (Наполнение баз данных):
--3.1:
--Читатели:
INSERT INTO Readers (reader_name, phone_number) VALUES
('Анна Петрова', '+79001112233'),      --1
('Иван Соколов', '+79002223344'),      --2
('Мария Ким', '+79003334455'),         --3
('Олег Васильев', '+79004445566');     --4

--3.2:
--Книги:
INSERT INTO Books (isbn, title, year) VALUES
('978-5-17-118366-8', 'Мастер и Маргарита', 1967),
('978-5-389-06256-6', 'Преступление и наказание', 1866),
('978-5-04-116716-3', 'Война и мир', 1869),
('978-5-699-12014-7', 'Золотой теленок', 1931),
('978-5-389-03713-7', 'Пикник на обочине', 1972);

--3.3:
--Авторы:
INSERT INTO Authors (author_name) VALUES
('Михаил Булгаков'),                    --1
('Федор Достоевский'),                  --2
('Лев Толстой'),                        --3
('Илья Ильиф'),                         --4
('Евгений Петров'),                     --5
('Аркадий Стругацкий'),                 --6
('Борис Стругацкий');                   --7

--Авторы и их книги:
INSERT INTO Book_Authors (author_id, isbn) VALUES
(1, '978-5-17-118366-8'),
(2, '978-5-389-06256-6'),
(3, '978-5-04-116716-3'),
(4, '978-5-699-12014-7'),
(5, '978-5-699-12014-7'),
(6, '978-5-389-03713-7'),
(7, '978-5-389-03713-7');

--3.4:
--Выдачи книг:
INSERT INTO Loans (isbn, reader_id, date_of_giving, planned_date_of_returning, real_date_of_returning) VALUES
('978-5-17-118366-8', 1, '2024-01-10', '2024-01-24', '2024-01-23'),
('978-5-389-06256-6', 2, '2024-01-12', '2024-01-26', '2024-01-25'),
('978-5-04-116716-3', 1, '2024-01-14', '2024-01-28', NULL),
('978-5-699-12014-7', 3, '2024-01-18', '2024-02-02', NULL),
('978-5-389-03713-7', 4, '2024-01-24', '2024-02-08', NULL);


--4 (Изменение и удаление данных):
--4.1 (Обновляем телефон читателя)
UPDATE Readers
SET phone_number = '+79001119999'
WHERE reader_name = 'Анна Петрова';

--4.2 (Завершаем выдачу)
UPDATE Loans
SET real_date_of_returning = '2024-01-28'
WHERE loan_id = 3
AND real_date_of_returning IS NULL;

--4.3 (Удаляем читателя без активных выдач)
INSERT INTO Readers (reader_name, phone_number)
VALUES ('Тестовый читатель', '+790000000');

DELETE FROM Readers
WHERE reader_name = 'Тестовый читатель';

--Практическая работа 7:
--1 (Список читателей)
SELECT * FROM Readers;

--2 (Книги и годы издания)
SELECT title, year FROM Books;

--3 (Книги 19-го века)
SELECT title, year 
FROM Books 
WHERE year BETWEEN 1801 AND 1900;

--4 (Книги советского периода)
SELECT title, year 
FROM Books 
WHERE year BETWEEN 1917 AND 1991;

--5 (Читатель по номеру телефона)
SELECT * 
FROM Readers 
WHERE phone_number = '+79002223344';

--6 (Читатель по фрагменту ФИО)
SELECT * 
FROM Readers 
WHERE reader_name LIKE '%Иван%';

--7 (Активные выдачи)
SELECT * 
FROM Loans 
WHERE real_date_of_returning IS NULL;

--8 (Сортировка книг по названию)
SELECT title, year 
FROM Books 
ORDER BY title;

--9 (Ближайшие возвраты)
SELECT * 
FROM Loans 
WHERE real_date_of_returning IS NULL 
ORDER BY planned_date_of_returning ASC;

--10 (Поиск 3-х самых старых книг)
SELECT * 
FROM Books 
ORDER BY year ASC 
LIMIT 3;