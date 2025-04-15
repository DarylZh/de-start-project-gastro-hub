--Этап 1. Создание дополнительных таблиц
--Шаг 1. Создание enum cafe.restaurant_type

CREATE SCHEMA cafe;
CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

--Шаг 2. Создание таблицы cafe.restaurants
CREATE TABLE cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cafe_name VARCHAR NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu JSONB
);

--▎Шаг 3. Создание таблицы cafe.managers
CREATE TABLE cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manager_name VARCHAR NOT NULL,
    manager_phone VARCHAR
);

--- Шаг 4: Создание таблицы cafe.restaurant_manager_work_dates
CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID,
    manager_uuid UUID,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (restaurant_uuid, manager_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid)
);

--Шаг 5. Создание таблицы cafe.sales
CREATE TABLE cafe.sales (
    date DATE,
    restaurant_uuid UUID,
    avg_check NUMERIC(6, 2),
    PRIMARY KEY (date, restaurant_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid)
);
