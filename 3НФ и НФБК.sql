-- 1: Приведение к Третьей нормальной форме (3НФ)
-- Таблица издательств
CREATE TABLE Publishers (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(255),
    publisher_city VARCHAR(100)
);

-- Таблица книг
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_name VARCHAR(255),
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- 2: Приведение к Третьей нормальной форме (3НФ)
-- Таблица моделей автомобилей
CREATE TABLE Cars (
    car_model VARCHAR(100) PRIMARY KEY,
    car_manufacturer VARCHAR(100)
);

-- Таблица результатов заездов
CREATE TABLE RaceResults (
    race_id INT,
    driver_id INT,
    car_model VARCHAR(100),
    finish_time TIME,
    PRIMARY KEY (race_id, driver_id),
    FOREIGN KEY (car_model) REFERENCES Cars(car_model)
);

-- 3: Приведение к Нормальной форме Бойса-Кодда (НФБК)
-- Таблица привязки типа мероприятия к комнате (здесь event_type — первичный ключ)
CREATE TABLE EventTypeRooms (
    event_type VARCHAR(50) PRIMARY KEY,
    room_name VARCHAR(100)
);

-- Таблица бронирований
CREATE TABLE RoomBookings (
    booking_time DATETIME,
    event_name VARCHAR(255),
    event_type VARCHAR(50),
    PRIMARY KEY (booking_time, event_name),
    FOREIGN KEY (event_type) REFERENCES EventTypeRooms(event_type)
);
