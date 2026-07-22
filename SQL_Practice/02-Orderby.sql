
-- << ORDER BY >>--

use AdventureWorks2019

-- Q_01: Sort products by price ascending  

select *
from Production.Product
order by ListPrice

--------------------------------------------------------------------------------
-- Q_02: Sort products by price descending  

select *
from Production.Product
order by ListPrice desc

--------------------------------------------------------------------------------
-- Q_03: Sort products alphabetically by name  

select *
from Production.Product
order by name

--------------------------------------------------------------------------------
-- Q_04: Display the 10 most expensive products  

select top 10 *
from Production.Product
order by ListPrice desc

--------------------------------------------------------------------------------
/** Sort products by price (ascending) and display only:
    - ProductID
	- Name
	- ListPrice
**/

select ProductID,
       Name,
       ListPrice
from Production.Product
order by ListPrice

--------------------------------------------------------------------------------
-- Q_06: Sort products first by color and then by price  

select *
from Production.Product
order by Color, ListPrice

--------------------------------------------------------------------------------
-- Q_07: Display the 5 heaviest products  

select top 5 *
from Production.Product
order by weight desc

--------------------------------------------------------------------------------
-- Q_08: Display the first 20 products ordered by name  

select top 20 *
from Production.Product
order by name asc

--------------------------------------------------------------------------------
-- Q_09: Display the 15 most expensive Black products  

select top 15 *
from Production.Product
where color = 'Black'
order by ListPrice desc

--------------------------------------------------------------------------------
-- Q_10: Sort products by sale date  

select p.ProductID, p.Name, soh.OrderDate
from Production.Product p
join Sales.SalesOrderDetail sod
    on p.ProductID = sod.ProductID
join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
order by soh.OrderDate

--------------------------------------------------------------------------------
-- Q_11: Display the 5 lightest products  

select top 5 *
from Production.Product
where weight is not null
order by weight asc

--------------------------------------------------------------------------------
-- Q_12: Sort products by color descending and price ascending  

select *
from Production.Product
order by color desc, ListPrice asc

--------------------------------------------------------------------------------
-- Q_13: Display the top 3 products for each color 

with RankedProducts as (
    select *,
           ROW_NUMBER() over (partition by Color order by ListPrice desc) as rn
   from Production.Product
    where Color IS NOT NULL
)
select *
from RankedProducts
where rn <= 3

--------------------------------------------------------------------------------
-- Q_14: Display products from row 5 to row 15  

with OrderedProducts as (
    select *,
           ROW_NUMBER() over (order by ProductID) as rn
    from Production.Product
)
select *
from OrderedProducts
where rn between 5 and 15

--------------------------------------------------------------------------------
-- Q_15: Display the 20 products with the longest names  

select top 20 *
from Production.Product
order by LEN(Name) desc