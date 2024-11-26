-- Define 20 unique city and state combinations
DECLARE @CityState TABLE (RowNum INT, City VARCHAR(100), States VARCHAR(100));
INSERT INTO @CityState VALUES 
(1, 'New York', 'New York'),
(2, 'Los Angeles', 'California'),
(3, 'Chicago', 'Illinois'),
(4, 'Houston', 'Texas'),
(5, 'Phoenix', 'Arizona'),
(6, 'Philadelphia', 'Pennsylvania'),
(7, 'San Antonio', 'Texas'),
(8, 'San Diego', 'California'),
(9, 'Dallas', 'Texas'),
(10, 'San Jose', 'California'),
(11, 'Austin', 'Texas'),
(12, 'Jacksonville', 'Florida'),
(13, 'Fort Worth', 'Texas'),
(14, 'Columbus', 'Ohio'),
(15, 'Indianapolis', 'Indiana'),
(16, 'Charlotte', 'North Carolina'),
(17, 'San Francisco', 'California'),
(18, 'Seattle', 'Washington'),
(19, 'Denver', 'Colorado'),
(20, 'Boston', 'Massachusetts');

-- Update the store table with new city and state combinations
WITH StoreCTE AS (
    SELECT store_id,
           ROW_NUMBER() OVER (ORDER BY store_id) AS RowNum -- Assign a unique row number to each store
    FROM store
)
UPDATE store
SET 
    city = cs.City,
    states = cs.States
FROM StoreCTE s
JOIN @CityState cs ON s.RowNum % 20 = cs.RowNum % 20 -- Match each store row number to a city/state row number cyclically
WHERE store.store_id = s.store_id;
