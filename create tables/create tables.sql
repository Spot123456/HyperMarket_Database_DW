/**
 ******************************************************************************
 * @file           : create hypermarket database
 * @version        : Version : 1:0:0
 * @Auther         : Ahmed Nour
 * @brief          : create DB from mapped ER diagram
 ******************************************************************************
 */

create database hypermarketDB ;
use hypermarketDB;


----------------------------------------------------------------------------------------------
-- create table for staff if not exist in this db 
create table staff
(
	staff_id int primary key identity(1,1) ,
	f_name varchar(20)	not null ,
	l_name varchar(20), 
	Email  varchar(50) ,
	manager_id int ,

	-- we need to define the manager_id as a foreign key to staff_if
	-- due to self referancing relationship 
	-- self ref. relationship made when column have a relation with 2nd col
	-- like manager is actually staff
	constraint fk_manager			-- Defines a name for the foreign key constraint ("fk_manager" in this case).
	foreign key (manager_id)
	references staff (staff_id)		-- staff its the table name and staff_id the col
	on delete no action			-- if reference manager is deleting set its value with null

);
----------------------------------------------------------------------------------------------
create table staff_phone
(
	staff_id int ,
	phone varchar(12),

	-- Defining a composite primary key using staff_id and phone
	primary key (staff_id,phone),

	constraint FK_staff
	foreign key (staff_id)
	references staff (staff_id)
	on delete cascade					-- if we delete any from parent automatic deleting from child 

);
----------------------------------------------------------------------------------------------
create table store
(
	store_id int primary key identity(1,1),
	store_name varchar(20) not null ,
	city varchar(20) ,
	states varchar(20),


);
----------------------------------------------------------------------------------------------
create table [order]
(
	order_id int primary key identity(1,1),
	order_date date ,
	total_amount int

);
----------------------------------------------------------------------------------------------
-- we have error
create table store_order
(
	order_id int not null , 
	store_id int null,
	primary key (order_id),
	foreign key (order_id) references [order] (order_id) on delete set null,
	foreign key (store_id) references store (store_id) on delete set null,

);

-- solved

create table store_order
(
	order_id int not null,  -- Cannot be null because it's part of the primary key
	store_id int null,
	primary key (order_id),
	foreign key (order_id) references [order](order_id) on delete cascade,  -- Change to CASCADE
	foreign key (store_id) references store(store_id) on delete set null
);


----------------------------------------------------------------------------------------------
--we have error
create table  staff_store 
(
	store_id INT primary key,
    staff_id INT,
    
    FOREIGN KEY (store_id) REFERENCES store(storeID) ON DELETE SET NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staffID) ON DELETE SET NULL
);

-- solved
create table staff_store 
(
    store_id INT primary key,  -- store_id cannot be set to NULL, as it's the primary key
    staff_id INT,
    
    foreign key (store_id) references store(store_id) on delete cascade,  -- Use CASCADE instead
    foreign key (staff_id) references staff(staff_id) on delete cascade   -- Use CASCADE instead
);

----------------------------------------------------------------------------------------------
create table customer 
(
	customer_id int primary key identity(1,1), 
	customer_name varchar(50),
	customer_address varchar(100), 
	email varchar(30),
);
----------------------------------------------------------------------------------------------
--error 
create table  customer_phone
(
	customer_id int ,
	phone varchar(15) ,
	
	-- we make composite primary key due to multi value phone 
	primary key (customer_id , phone ),
	foreign key (customer_id) references customer (customer_id) on delete set null,

);

/*
--solved
create table customer_phone
(
	customer_phone_id int identity(1,1) primary key,  -- New surrogate key
	customer_id int null,  -- Make this nullable
	phone varchar(15),
	
	-- Foreign key constraint
	foreign key (customer_id) references customer(customer_id) on delete set null
);
*/

-- Create the customer table if it does not exist
IF OBJECT_ID('customer', 'U') IS NULL
CREATE TABLE customer
(
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    customer_name VARCHAR(50) NOT NULL,
    customer_address VARCHAR(100),
    email VARCHAR(50)
);


-- Recreate customer_phone table after ensuring customer table exists
IF OBJECT_ID('customer_phone', 'U') IS NOT NULL
    DROP TABLE customer_phone;

CREATE TABLE customer_phone
(
    customer_id INT,
    phone VARCHAR(15),

    -- Composite primary key
    PRIMARY KEY (customer_id, phone),

    -- Foreign key to customer table
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);





----------------------------------------------------------------------------------------------
--error
create table  customer_order 
(
	order_id int primary key,
	customer_id int , 

	foreign key (order_id) references [order](order_id) on delete set null,
	foreign key (customer_id) references customer(customer_id) on delete set null,

);


/*
--solved
create table customer_order
(
	customer_order_id int identity(1,1) primary key,  -- New surrogate key
	order_id int null,         -- Allow this to be null
	customer_id int null,      -- Allow this to be null

	foreign key (order_id) references [order](order_id) on delete set null,
	foreign key (customer_id) references customer(customer_id) on delete set null
);
*/
IF OBJECT_ID('[order]', 'U') IS NULL
CREATE TABLE [order]
(
    order_id INT PRIMARY KEY IDENTITY(1,1),
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

IF OBJECT_ID('customer_order', 'U') IS NOT NULL
    DROP TABLE customer_order;

-- Recreate table with composite primary key
CREATE TABLE customer_order
(
    order_id INT,
    customer_id INT,

    -- Composite primary key
    PRIMARY KEY (order_id, customer_id),

    -- Foreign key constraints with ON DELETE CASCADE
    FOREIGN KEY (order_id) REFERENCES [order](order_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);



----------------------------------------------------------------------------------------------
create table product
(
	product_id int primary key identity(1,1),
	product_name varchar(50),
	category varchar(50),
	stock_quantity int, 
	price int 

)


----------------------------------------------------------------------------------------------
-- weak entity 

	-- error
	create table order_item 
	(
		order_item_id int,
		order_id int ,
		quantity int , 
		price int ,

		-- composite primary key
		primary key (order_item_id,order_id),
		foreign key (order_id) references [order](order_id) on delete set null, 

	)
/*
	-- solved in this
	create table order_item 
	(
		order_item_auto_id int identity(1,1) primary key,  -- New surrogate key
		order_item_id int, 
		order_id int null,    -- Allow this to be null
		quantity int, 
		price int,
	
		-- Foreign key constraint
		foreign key (order_id) references [order](order_id) on delete set null
	);
*/

-- Drop the table if it already exists
IF OBJECT_ID('order_item', 'U') IS NOT NULL
    DROP TABLE order_item;

-- Recreate the table with a composite primary key
CREATE TABLE order_item 
(
    order_item_id INT,  -- Part of composite primary key
    order_id INT,       -- Part of composite primary key
    quantity INT, 
    price DECIMAL(10, 2),

    -- Composite primary key
    PRIMARY KEY (order_item_id, order_id),

    -- Foreign key constraint using ON DELETE CASCADE (no SET NULL for composite key)
    FOREIGN KEY (order_id) REFERENCES [order](order_id) ON DELETE CASCADE
);


--
--------------------------------------------------------------------------------------------
-- error 
create table product_order_item
(
	order_item_id int not null, 
	order_id int not null ,
	product_id int,

	primary key(order_item_id,order_id),
	foreign key (order_id) references [order](order_id) on delete set null, 
	foreign key (product_id) references product(product_id) on delete set null, 
	foreign key (order_item_id) references order_item(order_item_id) on delete set null, 

);


/*
-- solved 
create table product_order_item
(
	product_order_item_id int identity(1,1) primary key,  -- New surrogate key
	order_item_auto_id int null,   -- Refer to the primary key of order_item
	order_id int null,             -- Make this nullable
	product_id int null,           -- Make this nullable

	foreign key (order_id) references [order](order_id) on delete set null, 
	foreign key (product_id) references product(product_id) on delete set null, 
	foreign key (order_item_auto_id) references order_item(order_item_auto_id) on delete set null  -- Correct reference
);
*/


-- Drop the product_order_item table if it exists
IF OBJECT_ID('product_order_item', 'U') IS NOT NULL
    DROP TABLE product_order_item;

-- Recreate the product_order_item table
CREATE TABLE product_order_item
(
    order_item_id INT,  -- Composite primary key part 1
    order_id INT,       -- Composite primary key part 2
    product_id INT,     -- Normal foreign key

    -- Composite primary key using order_item_id and order_id
    PRIMARY KEY (order_item_id, order_id),

    -- Foreign key constraints
    FOREIGN KEY (order_id, order_item_id) REFERENCES order_item(order_item_id,order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

---------------------------------------

USE master;
SELECT * FROM sys.tables;
USE master;  -- Switch to master
IF OBJECT_ID('product_order_item', 'U') IS NOT NULL
    DROP TABLE product_order_item;

IF OBJECT_ID('order_item', 'U') IS NOT NULL
    DROP TABLE order_item;

IF OBJECT_ID('product', 'U') IS NOT NULL
    DROP TABLE product;

-- Continue dropping other user-defined tables if they exist...

USE master;  -- Switch to the master database
ALTER DATABASE hypermarketDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;




DROP DATABASE hypermarketDB;

ALTER DATABASE hypermarketDB SET MULTI_USER;
