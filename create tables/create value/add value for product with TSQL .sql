-- Enable IDENTITY_INSERT to allow inserting values into the identity column 'product_id'
SET IDENTITY_INSERT product ON;

-- Insert 200 products into the 'product' table
DECLARE @counter INT = 21;

WHILE @counter <= 200
BEGIN
    INSERT INTO product (product_id, product_name, category, stock_quantity, price)
    VALUES (
        @counter, -- product_id (manually inserting values)
        CASE 
            WHEN @counter % 5 = 1 THEN 'T-shirt Model ' + CAST(@counter AS VARCHAR)
            WHEN @counter % 5 = 2 THEN 'Smartphone'
            WHEN @counter % 5 = 3 THEN 'Laptop'
            WHEN @counter % 5 = 4 THEN 'Glossary Item ' + CAST(@counter AS VARCHAR)
            ELSE 'Vegetables'
        END, -- product_name
        CASE 
            WHEN @counter % 5 = 1 THEN 'Clothing'
            WHEN @counter % 5 = 2 OR @counter % 5 = 3 THEN 'Electronics'
            WHEN @counter % 5 = 4 THEN 'Miscellaneous'
            ELSE 'Groceries'
        END, -- category
        FLOOR(RAND(CHECKSUM(NEWID())) * 101), -- Random stock_quantity between 0 and 100
        FLOOR(RAND(CHECKSUM(NEWID())) * (15000 - 20 + 1)) + 20 -- Random price between 20 and 15000
    );
    
    SET @counter = @counter + 1;
END;

-- Disable IDENTITY_INSERT after the insert operation
SET IDENTITY_INSERT product OFF;

-- Verify that 200 rows were inserted
SELECT * FROM product;
