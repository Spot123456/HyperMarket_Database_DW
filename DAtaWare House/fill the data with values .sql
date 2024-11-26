
-- fill the value from DB HypermarketDB

-- 1 - is used to populate the DimDate table with a range of dates, allowing for a "Date Dimension" in the Data Warehouse.
-- The Date Dimension is essential for analytical queries that involve time-based analysis,
-- such as finding trends over months, quarters, or years
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2024-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (DateKey, Date, Day, Month, Quarter, Year)
    VALUES (
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        DATEPART(QUARTER, @StartDate),
        YEAR(@StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;


--Populate DimStore
-- i get the data from transact sql 
INSERT INTO DimStore (StoreID, StoreName, City)
SELECT store_id, store_name, city FROM hypermarketDB.dbo.store;

-- Populate DimCustomer

INSERT INTO DimCustomer (CustomerID, CustomerName, Address, Email, Phone)
SELECT c.customer_id, c.customer_name, c.customer_address, c.email, p.phone
FROM hypermarketDB.dbo.customer AS c
LEFT JOIN hypermarketDB.dbo.customer_phone AS p ON c.customer_id = p.customer_id;

-- Populate DimStaff
INSERT INTO DimStaff (StaffID, Name, Email, Phone)
SELECT s.staff_id, CONCAT(s.f_name, ' ', s.l_name) AS Name, s.email, p.phone
FROM hypermarketDB.dbo.staff AS s
LEFT JOIN hypermarketDB.dbo.staff_phone AS p ON s.staff_id = p.staff_id;

-- Populate DimProduct
INSERT INTO DimProduct (ProductID, ProductName, Category, Price)
SELECT product_id, product_name, category, price
FROM hypermarketDB.dbo.product;

-- Populate Fact Table
-- Join the relevant tables from the transactional database to populate the FactSales table.

INSERT INTO FactSales (OrderID, OrderDate, StoreID, CustomerID, ProductID, Quantity, Price, TotalAmount, DateKey)
SELECT 
    o.order_id,
    o.order_date,
    so.store_id,
    co.customer_id,
    poi.product_id,
    oi.quantity,
    oi.price,
    o.total_amount,
    CAST(FORMAT(o.order_date, 'yyyyMMdd') AS INT) AS DateKey
FROM 
    hypermarketDB.dbo.[order] AS o
    JOIN hypermarketDB.dbo.store_order AS so ON o.order_id = so.order_id
    JOIN hypermarketDB.dbo.customer_order AS co ON o.order_id = co.order_id
    JOIN hypermarketDB.dbo.order_item AS oi ON o.order_id = oi.order_id
    JOIN hypermarketDB.dbo.product_order_item AS poi ON oi.order_item_id = poi.order_item_id;





