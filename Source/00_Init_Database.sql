/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\ACER\Documents\EDA Progect\flat-files\dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\ACER\Documents\EDA Progect\flat-files\dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\ACER\Documents\EDA Progect\flat-files\fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

--DAY 2

Select * from gold.dim_products
Select category from gold.dim_products
Select product_name from gold.dim_products

Select * from gold.fact_sales
Select 
sales_amount,
quantity,
price
from gold.fact_sales

Select * from [gold].[dim_customers]

Select * from INFORMATION_SCHEMA.TABLES

Select 
TABLE_NAME,
TABLE_SCHEMA
from INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'Sales'
Order by TABLE_NAME

Select 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'DIM_CUSTOMERS'

Select 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'DIM_PRODUCTS'

Select 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'FACT_SALES'

---nb: Granularity: with the highest level of details ie:Marital staus here is the least
---1. Marital STATUS, 2. Gender 3. Countries 4. Age

Select 
Country
from gold.DIM_CUSTOMERS

Select 
distinct
Country
from gold.DIM_CUSTOMERS

--Aggregate Categories And Producr
Select 
Category,
Count(product_name) NumofProducts
from gold.DIM_products
group by category
Order by count(product_name) desc

Select * from gold.DIM_CUSTOMERS

Select 
Country,
Count(customer_id) NumofCustomers
from gold.DIM_CUSTOMERS
group by Country
Order by Count(customer_id) desc
