DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO staff (f_name, l_name, Email, manager_id)
    VALUES 
    (
        CASE WHEN @i % 2 = 0 THEN 'John' ELSE 'Jane' END, 
        CASE WHEN @i % 3 = 0 THEN 'Doe' ELSE 'Smith' END, 
        CONCAT(CASE WHEN @i % 2 = 0 THEN 'john' ELSE 'jane' END, '.', CASE WHEN @i % 3 = 0 THEN 'doe' ELSE 'smith' END, '@example.com'),
        CASE WHEN @i % 5 = 0 THEN NULL ELSE (@i / 10 + 1) END  -- Every 5th person is a manager
    );

    SET @i = @i + 1;
END;

-------------------------------------------------------------error
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO staff_phone (staff_id, phone)
    VALUES 
    (@i, CONCAT('(555) ', RIGHT('000' + CAST(FLOOR(RAND() * 1000) AS VARCHAR), 3), '-', RIGHT('0000' + CAST(FLOOR(RAND() * 10000) AS VARCHAR), 4)));

    SET @i = @i + 1;
END;
------------------------------------------------------------------

DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    INSERT INTO store (store_name, city, states)
    VALUES 
    (
        CASE WHEN @i % 2 = 0 THEN 'ElectroWorld' ELSE 'Fashion Hub' END, 
        CASE @i 
            WHEN 1 THEN 'New York'
            WHEN 2 THEN 'Los Angeles'
            WHEN 3 THEN 'Chicago'
            WHEN 4 THEN 'Houston'
            WHEN 5 THEN 'Phoenix'
            WHEN 6 THEN 'Philadelphia'
            WHEN 7 THEN 'San Antonio'
            WHEN 8 THEN 'San Diego'
            WHEN 9 THEN 'Dallas'
            WHEN 10 THEN 'San Jose'
        END, 
        CASE @i 
            WHEN 1 THEN 'NY'
            WHEN 2 THEN 'CA'
            WHEN 3 THEN 'IL'
            WHEN 4 THEN 'TX'
            WHEN 5 THEN 'AZ'
            WHEN 6 THEN 'PA'
            WHEN 7 THEN 'TX'
            WHEN 8 THEN 'CA'
            WHEN 9 THEN 'TX'
            WHEN 10 THEN 'CA'
        END
    );

    SET @i = @i + 1;
END;

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO customer (customer_name, customer_address, email)
    VALUES 
    (
        CASE WHEN @i % 2 = 0 THEN 'Michael' ELSE 'Emily' END + ' ' + CASE WHEN @i % 3 = 0 THEN 'Brown' ELSE 'Davis' END,
        CONCAT(CAST(FLOOR(RAND() * 1000) AS VARCHAR), ' ', CASE WHEN @i % 2 = 0 THEN 'Maple St' ELSE 'Oak St' END, ', Apt ', CAST(FLOOR(RAND() * 100) AS VARCHAR)),
        CONCAT(CASE WHEN @i % 2 = 0 THEN 'michael' ELSE 'emily' END, '.', CASE WHEN @i % 3 = 0 THEN 'brown' ELSE 'davis' END, '@mail.com')
    );

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO customer_phone (customer_id, phone)
    VALUES 
    (@i, CONCAT('(666) ', RIGHT('000' + CAST(FLOOR(RAND() * 1000) AS VARCHAR), 3), '-', RIGHT('0000' + CAST(FLOOR(RAND() * 10000) AS VARCHAR), 4)));

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    INSERT INTO product (product_name, category, stock_quantity, price)
    VALUES 
    (
        CASE 
            WHEN @i % 2 = 0 THEN 'Smartphone' 
            WHEN @i % 3 = 0 THEN 'Laptop' 
            ELSE 'T-shirt' 
        END + ' Model ' + CAST(@i AS VARCHAR), 
        CASE 
            WHEN @i % 2 = 0 THEN 'Electronics' 
            ELSE 'Clothing' 
        END, 
        FLOOR(RAND() * 100), 
        FLOOR(RAND() * 500) + 50
    );

    SET @i = @i + 1;
END;

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO [order] (order_date, total_amount)
    VALUES 
    (
        DATEADD(DAY, @i, '2023-01-01'), 
        FLOOR(RAND() * 1000) + 100
    );

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO order_item (order_item_id, order_id, quantity, price)
    VALUES 
    (@i, @i, FLOOR(RAND() * 5) + 1, FLOOR(RAND() * 200) + 50);

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO staff_store (store_id, staff_id)
    VALUES 
    ((@i % 10) + 1, @i);

    SET @i = @i + 1;
END;
