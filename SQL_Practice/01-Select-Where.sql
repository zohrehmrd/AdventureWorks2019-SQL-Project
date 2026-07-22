
--<< SELECT & WHERE >>--

use AdventureWorks2019

-- Q_01.Display all product information  

select *
from production.product

--------------------------------------------------------------------------------
-- Q_02.Display only ProductID, Name, and ListPrice 

select ProductID,
       Name as ProductName,
       ListPrice as Price
from Production.Product

--------------------------------------------------------------------------------
-- Q_03.Display all distinct product names  

select distinct Name
from Production.Product

--------------------------------------------------------------------------------
-- Q_04.Display the first 10 products  

select top 10 *
from Production.product
order by ProductID

--------------------------------------------------------------------------------
-- Q_05.Display products with a price greater than 1000  

select *
from Production.Product
where ListPrice > 1000

--------------------------------------------------------------------------------
-- Q_06.Display products with a price less than 100  

select *
from Production.Product
where ListPrice < 100

--------------------------------------------------------------------------------
-- Q_07.Display products whose color is Red  

select *
from Production.product
where Color = 'Red'

--------------------------------------------------------------------------------
-- Q_08.Display products with no color assigned 

select *
from Production.product
where Color is Null

--------------------------------------------------------------------------------
-- Q_09.Display products priced between 500 and 1500  

select *
from Production.Product
where ListPrice between 500 and 1500

--------------------------------------------------------------------------------
-- Q_10.Display products whose names start with the letter Be  

select *
from production.product
where name like 'B%'

--------------------------------------------------------------------------------
-- Q_11.Display products whose names end with the letter A  

select *
from production.product
where name like '%A'

--------------------------------------------------------------------------------
-- Q_12.Display products whose weight is not NULL  

select *
from Production.product
where Weight is not null 

--------------------------------------------------------------------------------
-- Q_13.Display products whose weight is NULL  

select *
from Production.product
where Weight is null 

--------------------------------------------------------------------------------
-- Q_14.Display products whose color is Red or Black  

select *
from Production.product
where Color in ('red','black')

--------------------------------------------------------------------------------
-- Q_15.Display products with a price greater than 1000 and weight greater than 500  

select *
from Production.Product
where ListPrice > 1000 and weight > 500

--------------------------------------------------------------------------------
-- Q_16.Display products whose ProductNumber starts with BK 

select *
from Production.Product
where ProductNumber like 'BK%'

--------------------------------------------------------------------------------
-- Q_17.Display products sold in 2013  

select distinct p.Name
from Production.Product p
join Sales.SalesOrderDetail sod
    on p.ProductID = sod.ProductID
join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2013

--------------------------------------------------------------------------------
-- Q_18.Display the first 20 products that have a color assigned  

select top 20 *
from Production.Product
where Color is not null
order by Name

--------------------------------------------------------------------------------
-- Q_19.Display products whose price is a multiple of 100  

select *
from Production.Product
where ListPrice % 100 = 0

--------------------------------------------------------------------------------
-- Q_20.Display products whose name contains the word "Mountain  

select *
from Production.Product
where Name like '%Mountain%'
