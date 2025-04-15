/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/
--Шаг 6. Наполнение таблиц данными из дампа
-- Заполнение таблицы cafe.restaurants
INSERT INTO cafe.restaurants (cafe_name, type, menu)
SELECT DISTINCT
    s.cafe_name,
    CASE
        WHEN s.cafe_name LIKE '%coffee%' THEN 'coffee_shop'
        WHEN s.cafe_name LIKE '%restaurant%' THEN 'restaurant'
        WHEN s.cafe_name LIKE '%bar%' THEN 'bar'
        WHEN s.cafe_name LIKE '%pizzeria%' THEN 'pizzeria'
        ELSE NULL
    END AS type,
    '{}'::JSONB  -- Предполагаем, что меню изначально пустое
FROM raw_data.sales s;

-- Заполнение таблицы cafe.managers
INSERT INTO cafe.managers (manager_name, manager_phone)
SELECT DISTINCT
    manager,
    manager_phone
FROM raw_data.sales;

-- Заполнение таблицы cafe.restaurant_manager_work_dates
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT 
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_date,
    MAX(s.report_date) AS end_date
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name
JOIN cafe.managers m ON s.manager = m.manager_name
GROUP BY r.restaurant_uuid, m.manager_uuid;

-- Заполнение таблицы cafe.sales
INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT 
    report_date,
    r.restaurant_uuid,
    avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name;
