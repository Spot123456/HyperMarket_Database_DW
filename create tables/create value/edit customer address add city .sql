-- Step 1: Create a temporary table for the cities
CREATE TABLE #Cities (CityName NVARCHAR(50));

-- Step 2: Insert the list of cities into the temporary table
INSERT INTO #Cities (CityName) VALUES 
('New York'), 
('Cairo'), 
('Los Angeles'), 
('Chicago'), 
('Houston'), 
('Phoenix'), 
('Philadelphia'), 
('San Antonio'), 
('San Diego'), 
('Dallas'), 
('San Jose'), 
('Austin'), 
('Jacksonville'), 
('Fort Worth'), 
('Columbus'), 
('Indianapolis'), 
('Charlotte'), 
('San Francisco'), 
('Seattle'), 
('Denver'), 
('Boston');

-- Step 3: Declare a cursor to loop through each customer
DECLARE customer_cursor CURSOR FOR
SELECT customer_id, customer_address FROM customer;

DECLARE @customer_id INT;
DECLARE @customer_address NVARCHAR(100);
DECLARE @random_city NVARCHAR(50);

OPEN customer_cursor;
FETCH NEXT FROM customer_cursor INTO @customer_id, @customer_address;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Get a random city from the temporary #Cities table
    SELECT TOP 1 @random_city = CityName
    FROM #Cities
    ORDER BY NEWID(); -- Randomize the selection

    -- Update the customer's address with the random city
    UPDATE customer
    SET customer_address = @customer_address + ', ' + @random_city
    WHERE customer_id = @customer_id;

    FETCH NEXT FROM customer_cursor INTO @customer_id, @customer_address;
END

CLOSE customer_cursor;
DEALLOCATE customer_cursor;

-- Step 4: Drop the temporary table (optional, will be dropped automatically at session end)
DROP TABLE #Cities;
