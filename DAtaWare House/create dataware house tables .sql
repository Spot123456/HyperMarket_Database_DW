-- create dataware house 

CREATE DATABASE HypermarketDW;
GO
USE HypermarketDW;
GO

-- we need Create Dimension Tables the tables are  Date, Store, Customer, Staff, and Product.
-- Date Dimension
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT
);

-- Store Dimension
CREATE TABLE DimStore (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(50),
    City NVARCHAR(50)
);

-- Customer Dimension
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Address NVARCHAR(200),
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

-- Staff Dimension
CREATE TABLE DimStaff (
    StaffID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

-- Product Dimension
CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10, 2)
);


--Create Fact Table Create a fact table for sales, where you consolidate data from order, order_item, and product_order_item.

-- Sales Fact Table
CREATE TABLE FactSales (
    SalesID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    OrderDate DATE,
    StoreID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    TotalAmount DECIMAL(15, 2),
    DateKey INT, -- Foreign Key to DimDate
    FOREIGN KEY (StoreID) REFERENCES DimStore(StoreID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
);


