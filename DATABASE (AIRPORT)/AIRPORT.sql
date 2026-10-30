CREATE TABLE Airlines (
    airline_id   SERIAL PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL
);

CREATE TABLE Airports (
    airport_id   SERIAL PRIMARY KEY,
    airport_code VARCHAR(3)   NOT NULL UNIQUE,  
    city         VARCHAR(100) NOT NULL,
    country      VARCHAR(100) NOT NULL
);

CREATE TABLE Passengers (
    passenger_id   SERIAL PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    passport_number VARCHAR(15) NOT NULL UNIQUE,
    phone_number   VARCHAR(15)  NOT NULL
);

CREATE TABLE Flights (
    flight_id          SERIAL PRIMARY KEY,
    flight_number      VARCHAR(20)  NOT NULL,
    airline_id         INT          NOT NULL,
    departure_airport_id INT        NOT NULL,
    arrival_airport_id   INT        NOT NULL,
    departure_time     TIMESTAMP    NOT NULL,
    arrival_time       TIMESTAMP    NOT NULL,
    price              DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines (airline_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (departure_airport_id) REFERENCES Airports (airport_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports (airport_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_flight_time CHECK (arrival_time > departure_time),
    CONSTRAINT chk_price_positive CHECK (price > 0)
);

CREATE TABLE Tickets (
    ticket_id      SERIAL PRIMARY KEY,
    passenger_id   INT           NOT NULL,
    flight_id      INT           NOT NULL,
    seat_number    VARCHAR(5)    NOT NULL,
    booking_date   DATE          NOT NULL,
    ticket_price   DECIMAL(10,2) NOT NULL,
    is_cancelled   BOOLEAN       DEFAULT FALSE,
    FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES Flights (flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_ticket_price CHECK (ticket_price > 0)
);

-- Авиакомпании:
INSERT INTO Airlines (airline_name) VALUES
    ('Аэрофлот'),
    ('S7 Airlines'),
    ('Победа'),
    ('Emirates'),
    ('Turkish Airlines');

-- Аэропорты:
INSERT INTO Airports (airport_code, city, country) VALUES
    ('SVO', 'Москва', 'Россия'),
    ('LED', 'Санкт-Петербург', 'Россия'),
    ('JFK', 'Нью-Йорк', 'США'),
    ('DXB', 'Дубай', 'ОАЭ'),
    ('IST', 'Стамбул', 'Турция'),
    ('CDG', 'Париж', 'Франция');

-- Пассажиры:
INSERT INTO Passengers (full_name, passport_number, phone_number) VALUES
    ('Иванов Иван Иванович',   '4510 123456', '+79001112233'),
    ('Петрова Анна Сергеевна',  '4510 654321', '+79002223344'),
    ('Сидоров Пётр Алексеевич', '4510 111222', '+79003334455'),
    ('Козлова Мария Дмитриевна','4510 333444', '+79004445566');

-- Рейсы:
INSERT INTO Flights (flight_number, airline_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time, price) VALUES
    ('SU-100', 1, 1, 3, '2026-11-15 10:00:00', '2026-11-15 18:00:00', 45000.00),
    ('SU-200', 1, 1, 4, '2026-11-16 12:00:00', '2026-11-16 19:00:00', 38000.00),
    ('S7-300', 2, 2, 5, '2026-11-17 08:00:00', '2026-11-17 13:00:00', 22000.00),
    ('EK-400', 4, 4, 1, '2026-11-18 23:00:00', '2026-11-19 05:00:00', 52000.00),
    ('TK-500', 5, 5, 6, '2026-11-20 14:00:00', '2026-11-20 17:00:00', 18000.00),
    ('SU-600', 1, 1, 2, '2026-11-21 07:00:00', '2026-11-21 09:00:00',  8000.00);

-- Билеты:
INSERT INTO Tickets (passenger_id, flight_id, seat_number, booking_date, ticket_price, is_cancelled) VALUES
    (1, 1, '12A', '2026-10-25', 45000.00, FALSE),
    (2, 2, '5C',  '2026-10-26', 38000.00, FALSE),
    (1, 3, '8B',  '2026-10-27', 22000.00, TRUE),
    (3, 4, '22F', '2026-10-28', 52000.00, FALSE),
    (4, 5, '15D', '2026-10-29', 18000.00, FALSE),
    (2, 6, '3A',  '2026-10-30',  8000.00, FALSE),
    (3, 1, '14B', '2026-10-30', 45000.00, FALSE);