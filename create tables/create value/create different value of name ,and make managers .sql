-- Create temporary tables to store first names and last names for generating variety
DECLARE @FirstNames TABLE (FirstName VARCHAR(50));
DECLARE @LastNames TABLE (LastName VARCHAR(50));

-- Populate temporary tables with sample first names and last names
INSERT INTO @FirstNames VALUES ('John'), ('Michael'), ('Sarah'), ('Jessica'), ('David'), 
                               ('Emily'), ('Daniel'), ('Sophia'), ('James'), ('Emma'), 
                               ('Robert'), ('Olivia'), ('William'), ('Ava'), ('Joseph'),
                               ('Isabella'), ('Thomas'), ('Mia'), ('Charles'), ('Grace');
                               
INSERT INTO @LastNames VALUES ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), 
                              ('Garcia'), ('Miller'), ('Davis'), ('Rodriguez'), ('Martinez'),
                              ('Hernandez'), ('Lopez'), ('Gonzalez'), ('Wilson'), ('Anderson'),
                              ('Thomas'), ('Taylor'), ('Moore'), ('Jackson'), ('Martin');

-- Generate and insert new records into the staff table
-- 1. First, calculate the existing number of records
DECLARE @existingCount INT;
SELECT @existingCount = COUNT(*) FROM staff;

-- 2. Insert additional records until the table has 500 rows
DECLARE @counter INT = @existingCount + 1;

WHILE @counter <= 500
BEGIN
    -- Randomly select a first name and last name from the temporary tables
    DECLARE @FirstName VARCHAR(50), @LastName VARCHAR(50);
    
    SELECT TOP 1 @FirstName = FirstName FROM @FirstNames ORDER BY NEWID();
    SELECT TOP 1 @LastName = LastName FROM @LastNames ORDER BY NEWID();
    
    -- Create a unique email address using the first and last name
    DECLARE @Email VARCHAR(100);
    SET @Email = LOWER(@FirstName + '.' + @LastName + CAST(@counter AS VARCHAR) + '@company.com');

    -- Insert the new staff record with generated values
    INSERT INTO staff (f_name, l_name, Email, manager_id)
    VALUES (
        @FirstName, -- First Name
        @LastName,  -- Last Name
        @Email,     -- Email Address
        NULL        -- Assuming manager_id is set to NULL; can be adjusted based on requirements
    );

    -- Increment the counter
    SET @counter = @counter + 1;
END;

-- Verify that the staff table now has 500 rows
SELECT COUNT(*) AS TotalStaff FROM staff;
SELECT * FROM staff ORDER BY f_name, l_name;


------------------------------------------------------------------------------------------------------------------------------------
-- Step 1: Create or update 10 specific staff records to act as managers
-- Ensure these 10 records are marked as managers with a unique manager ID (manager_id is NULL initially for all staff)

-- Select 10 unique staff members and set them as managers
WITH ManagerCTE AS (
    SELECT TOP 10 s.staff_id
    FROM staff s
    WHERE s.manager_id IS NULL  -- Only consider rows with NULL manager_id
    ORDER BY NEWID()            -- Select randomly to ensure randomness
)
UPDATE s
SET s.manager_id = s.staff_id -- Each of these 10 staff members becomes their own manager
FROM staff s
INNER JOIN ManagerCTE m ON s.staff_id = m.staff_id;

-- Step 2: Assign these managers to other staff members
-- Get the list of 10 managers we just created
DECLARE @ManagerList TABLE (ManagerID INT);

INSERT INTO @ManagerList (ManagerID)
SELECT s.staff_id FROM staff s WHERE s.staff_id = s.manager_id;

-- Step 3: Update the remaining staff to assign them one of the 10 managers
-- Leave exactly 10 rows with manager_id = NULL and update the rest
WITH NonManagerCTE AS (
    SELECT s.staff_id,
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNum
    FROM staff s
    WHERE s.manager_id IS NULL -- Only consider rows with NULL manager_id
)
UPDATE s
SET s.manager_id = (SELECT TOP 1 m.ManagerID FROM @ManagerList m ORDER BY NEWID()) -- Randomly assign a manager
FROM staff s
INNER JOIN NonManagerCTE n ON s.staff_id = n.staff_id
WHERE n.RowNum > 10; -- Skip the first 10 rows to leave them with NULL manager_id

-- Step 4: Verify the changes
SELECT COUNT(*) AS TotalStaffWithManager FROM staff WHERE manager_id IS NOT NULL;
SELECT COUNT(*) AS TotalStaffWithoutManager FROM staff WHERE manager_id IS NULL;
SELECT * FROM staff ORDER BY f_name, l_name;
