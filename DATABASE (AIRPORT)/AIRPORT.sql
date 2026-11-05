-- Справочник стран
CREATE TABLE Countries (
    country_id      SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL
);

-- Справочник городов
CREATE TABLE Cities (
    city_id         SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    country_id      INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries (country_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Авиакомпании
CREATE TABLE Airlines (
    airline_id      SERIAL PRIMARY KEY,
    airline_name    VARCHAR(100) NOT NULL
);

-- Самолёты
CREATE TABLE Planes (
    plane_id        SERIAL PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    airline_id      INT NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines (airline_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Аэропорты 
CREATE TABLE Airports (
    airport_id      SERIAL PRIMARY KEY,
    airport_code    VARCHAR(3) NOT NULL UNIQUE,
    city_id         INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES Cities (city_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Пассажиры
CREATE TABLE Passengers (
    passenger_id    SERIAL PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    passport_number VARCHAR(15) NOT NULL UNIQUE,
    phone_number    VARCHAR(15) NOT NULL
);

-- Рейсы 
CREATE TABLE Flights (
    flight_id           SERIAL PRIMARY KEY,
    flight_number       VARCHAR(20) NOT NULL,
    airline_id          INT NOT NULL,
    plane_id            INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id  INT NOT NULL,
    departure_time      TIMESTAMP NOT NULL,
    arrival_time        TIMESTAMP NOT NULL,
    price               INT NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines (airline_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (plane_id) REFERENCES Planes (plane_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (departure_airport_id) REFERENCES Airports (airport_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports (airport_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_flight_time CHECK (arrival_time > departure_time),
    CONSTRAINT chk_price_positive CHECK (price > 0)
);

-- Места 
CREATE TABLE Seats (
    seat_id         SERIAL PRIMARY KEY,
    seat_number     VARCHAR(5) NOT NULL,
    flight_id       INT NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights (flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Билеты 
CREATE TABLE Tickets (
    ticket_id       SERIAL PRIMARY KEY,
    passenger_id    INT NOT NULL,
    flight_id       INT NOT NULL,
    seat_id         INT NOT NULL,
    booking_date    DATE NOT NULL,
    ticket_price    INT NOT NULL,
    is_cancelled    BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (passenger_id) REFERENCES Passengers (passenger_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES Flights (flight_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES Seats (seat_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_ticket_price CHECK (ticket_price > 0)
);

-- Страны
INSERT INTO Countries (name) VALUES
    ('Россия'),
    ('США'),
    ('ОАЭ'),
    ('Турция'),
    ('Франция');

-- Города
INSERT INTO Cities (name, country_id) VALUES
    ('Москва', 1),
    ('Санкт-Петербург', 1),
    ('Нью-Йорк', 2),
    ('Дубай', 3),
    ('Стамбул', 4),
    ('Париж', 5);

-- Авиакомпании
INSERT INTO Airlines (airline_name) VALUES
    ('Аэрофлот'),
    ('S7 Airlines'),
    ('Победа'),
    ('Emirates'),
    ('Turkish Airlines');

-- Самолёты
INSERT INTO Planes (name, airline_id) VALUES
    ('Boeing 737-800', 1),
    ('Airbus A320', 1),
    ('Boeing 777-300', 4),
    ('Airbus A321', 2),
    ('Boeing 737 MAX', 3);

-- Аэропорты
INSERT INTO Airports (airport_code, city_id) VALUES
    ('SVO', 1),
    ('LED', 2),
    ('JFK', 3),
    ('DXB', 4),
    ('IST', 5),
    ('CDG', 6);

-- Пассажиры
INSERT INTO Passengers (full_name, passport_number, phone_number) VALUES
    ('Иванов Иван Иванович', '4510 123456', '+79001112233'),
    ('Петрова Анна Сергеевна', '4510 654321', '+79002223344'),
    ('Сидоров Пётр Алексеевич', '4510 111222', '+79003334455'),
    ('Козлова Мария Дмитриевна', '4510 333444', '+79004445566');

-- Рейсы
INSERT INTO Flights (flight_number, airline_id, plane_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time, price) VALUES
    ('SU-100', 1, 1, 1, 2, '2026-11-10 08:00:00', '2026-11-10 09:30:00', 5000),
    ('SU-200', 1, 2, 1, 3, '2026-11-12 10:00:00', '2026-11-12 20:00:00', 35000),
    ('EK-500', 4, 3, 1, 4, '2026-11-15 14:00:00', '2026-11-15 20:00:00', 45000),
    ('TK-700', 5, 4, 1, 5, '2026-11-18 06:00:00', '2026-11-18 10:00:00', 15000),
    ('SU-100', 1, 1, 2, 1, '2026-11-20 11:00:00', '2026-11-20 12:30:00', 5000);

-- Места 
INSERT INTO Seats (seat_number, flight_id) VALUES
    ('1A', 1), ('1B', 1), ('2A', 1), ('2B', 1),
    ('1A', 2), ('1B', 2), ('2A', 2), ('2B', 2),
    ('1A', 3), ('1B', 3), ('2A', 3), ('2B', 3),
    ('1A', 4), ('1B', 4), ('2A', 4), ('2B', 4),
    ('1A', 5), ('1B', 5), ('2A', 5), ('2B', 5);

-- Билеты
INSERT INTO Tickets (passenger_id, flight_id, seat_id, booking_date, ticket_price, is_cancelled) VALUES
    (1, 1, 1, '2026-11-01', 5000, FALSE),
    (2, 2, 5, '2026-11-02', 35000, FALSE),
    (3, 3, 9, '2026-11-03', 45000, TRUE),
    (4, 4, 13, '2026-11-04', 15000, FALSE);