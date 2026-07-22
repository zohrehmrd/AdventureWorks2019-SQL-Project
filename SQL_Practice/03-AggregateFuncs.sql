
-- << AGGREGATE FUNCTIONS >>--

use AdventureWorks2019

-- Q_01: Calculate the total number of products 

select COUNT(ProductID) as TotalNumberOfProducts
from Production.Product

--------------------------------------------------------------------------------
-- Q_02: Calculate the average product price 

select AVG(ListPrice) as AveragePrice
from Production.Product

--------------------------------------------------------------------------------
-- Q_03: Find the highest product price  

select MAX(ListPrice) as MaxPrice
from Production.Product

--------------------------------------------------------------------------------
-- Q_04: Find the lowest product price  

select MIN(ListPrice) as MinPrice
from Production.Product

--------------------------------------------------------------------------------
-- Q_05: Calculate the sum of all product prices 

select SUM(ListPrice) as TotalPrice
from Production.Product

--------------------------------------------------------------------------------
-- Q_06: Calculate the average product weight 

select AVG(Weight) as AverageWeight
from Production.Product

--------------------------------------------------------------------------------
-- Q_07: Count products with a color assigned 

select COUNT(ProductID) as CountOfProducts
from Production.Product
where Color IS NOT NULL

--------------------------------------------------------------------------------
-- Q_08: Count products without a color assigned  

select COUNT(ProductID) as CountOfProducts
from Production.Product
where Color IS NULL

--------------------------------------------------------------------------------
-- Q_09: Calculate the difference between the highest and lowest prices 

select MAX(ListPrice) - MIN(ListPrice) as PriceDifference
from Production.Product

--------------------------------------------------------------------------------
-- Q_10: Count products priced above the average price 

select COUNT(ProductID) as CountOfProducts
from Production.Product
where ListPrice >
(
      select AVG(ListPrice)
	  from Production.Product
)

--------------------------------------------------------------------------------
-- Q_11: Calculate the total weight of all products  

select SUM(Weight) as TotalWeight
from Production.Product

--------------------------------------------------------------------------------
-- Q_12: Count distinct product colors 

select COUNT(Distinct Color) as DistinctColors
from Production.Product

--------------------------------------------------------------------------------
-- Q_13: Calculate the average price of Red products  

select AVG(ListPrice) as AveragePrice
from Production.Product
where Color = 'Red'

--------------------------------------------------------------------------------
-- Q_14: Find the maximum product weight  

select MAX(Weight) as MaxWeight
from Production.Product

--------------------------------------------------------------------------------
-- Q_15: Find the minimum product weight  

select MIN(Weight) as MinWeight
from Production.Product