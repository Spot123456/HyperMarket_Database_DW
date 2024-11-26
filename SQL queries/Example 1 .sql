/**
 ******************************************************************************
 * @file           : investigate hypermarket database
 * @version        : Version : 1:0:0
 * @Auther         : Ahmed Nour
 * @brief          : connect to hypermarketDB and get data from it
 ******************************************************************************
 */


use hypermarketDB

-- investigate the data
select * from [order]
where total_amount>100

select * from staff as c 

select * from store
select * from customer
---------------------------------------------------------------------------------

select f_name , l_name from staff as s
join staff_store as ss on s.staff_id = ss.staff_id
join store as se on se.store_id = ss.store_id
where city = 'New York'
---------------------------------------------------------------------------------

--List all orders placed by customers from a specific store city.


select c.customer_name , o.total_amount ,c.customer_address 
from customer as c 
join customer_order as co on co.customer_id = c.customer_id
join [order] as o on o.order_id = co.order_id
join store_order so on o.order_id = so.order_id
join store s on s.store_id= so.store_id
where city = 'new york'

---------------------------------------------------------------------------------
-- Get total sales ( number of sales) by store.
-- Identify which store generates the most sales.
select s.store_name ,sum(o.total_amount) as total_sales 
from store s 
join store_order so on so.store_id = s.store_id
join [order] as o on o.order_id = so.order_id
group by s.store_name
order by  total_sales DESC ;

---------------------------------------------------------------------------------

-- Retrieve all products that are low in stock (stock quantity < 10).
select product_name , stock_quantity 
from product
where stock_quantity<10

-- Helps the staff identify products that need restocking.
---------------------------------------------------------------------------------

-- functions 

create function get_revenue_byOrder (@order_number int)
returns decimal(10, 2)
As
begin 
	declare @total Decimal(10, 2)
	select @total = sum(quantity * price) 
	from order_item
	where order_id = @order_number
	return @total;

end;

-- function used 
select dbo.get_revenue_byOrder(1) as order_total;

-- confermation for testing 
select quantity , price , sum(price*quantity) as total
from order_item
where order_id = 1
group by quantity,price

-----------------------------------------------------------------
-- SUBSTRING ( expression, start, length )
-- expression as string ( full string) 
-- start the length of start Ex i start from pos = 7 
-- length : the new word length what Ex : 5  = world (it have 5 char)

-- ex Stored Procedure to Get Customer Orders from a Specific City:
/*
create procedure Get_customer_order_by_city
-- creat var called city 
	@city varchar(50)
As
begin
-- create var called start_pos for city
	declare @start_pos int
-- create var for length the word for city 
	declare @length	int
	-- we make +2 to skip the comma and the space after comma
	set @start_pos = len(customer_address)-charindex(',' , reverse(c.customer_address)+2);
	set @length = len(customer_address)-@start_pos+1;
	select c.customer_name ,o.order_id,o.order_data,o.total_amount
	from customer c
	join customer_order as co on co.custmer_id = c.customer_id
	join[order] as o on o.order_id = co.order_id
	where ltrim(substring(customer_address,@start_pos,@length))=@city;

end
*/

CREATE PROCEDURE Get_customer_order_by_city
    @city VARCHAR(50)
AS
BEGIN
    -- Select customer orders where the city is extracted from the address
    SELECT 
        c.customer_name,
        o.order_id,
        o.order_date,
        o.total_amount
    FROM customer c
    JOIN customer_order co ON c.customer_id = co.customer_id
    JOIN [order] o ON o.order_id = co.order_id
    WHERE LTRIM(SUBSTRING(
            c.customer_address,
            LEN(c.customer_address) - CHARINDEX(',', REVERSE(c.customer_address)) + 2, -- Start position
            LEN(c.customer_address) -- length
        )) = @city;
END;

-- used 
EXEC Get_customer_order_by_city 'new york';

----------------------------------------------------------------------------------------------------------------------

--Find all staff members who work at the store located in 'New York'.


select s.f_name, s.l_name, s.email --,count(s.staff_id) 
from staff s
join staff_store ss on ss.staff_id =s.staff_id
join store se on se.store_id= ss.store_id
where city = 'new york'
--group by s.f_name

----------------------------------------------------------------------------------------------------------------------

--List all orders placed by a specific customer.



----------------------------------------------------------------------------------------------------------------------

--Find the total quantity of a product sold in all orders.



----------------------------------------------------------------------------------------------------------------------

--Get the phone numbers of staff members who report to a specific manager.
--manager_id = 2.


----------------------------------------------------------------------------------------------------------------------

--Retrieve details of all orders made by customers in a particular city.


