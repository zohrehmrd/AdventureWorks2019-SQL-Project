
-- << GROUP BY & HAVING >>--

use AdventureWorks2019

-- Q_01: Display the number of products for each color 

select color,
	   COUNT(ProductID) as NumberOfProducts
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_02: Display the average price of products for each color 

select color,
	   AVG(ListPrice) as AveragePrice
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_03: Display the highest price for each color 

select color,
	   MAX(ListPrice) as HighestPrice
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_04: Display the lowest price for each color 

select color,
	   MIN(ListPrice) as LowestPrice
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_05: Display the number of products in each subcategory 

select psc.Name as ProductSubCategory,
       COUNT(p.ProductID) as NumberOfProducts
from Production.ProductSubcategory as psc 
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by psc.Name

--------------------------------------------------------------------------------
-- Q_06: Display the average weight of products for each color

select color,
	   AVG(Weight) as AverageWeight
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_07: Display the number of products for each class  

select Class,
       COUNT(*) as NumberOfProducts
from Production.Product
group by Class

--------------------------------------------------------------------------------
-- Q_08: Display the number of products for each style 

select Style,
       COUNT(*) as NumberOfProducts
from Production.Product
group by Style

--------------------------------------------------------------------------------
-- Q_09: Calculate the total price of products for each color

select color,
	   SUM(ListPrice) as TotalPrice
from Production.Product
group by Color

--------------------------------------------------------------------------------
-- Q_10: Display the total weight of products for each subcategory 

select psc.Name as ProductSubCategory,
       SUM(Weight) as TotalWeight
from Production.ProductSubcategory as psc 
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by psc.Name

--------------------------------------------------------------------------------
-- Q_11: Display only colors that have more than 10 products 

select Color,
       COUNT(ProductID) NumberOfProducts
from Production.Product
group by Color
having COUNT(ProductID) > 10

--------------------------------------------------------------------------------
-- Q_12: Display only subcategories that contain more than 20 products 

select psc.Name as ProductSubCategory,
       COUNT(ProductID) as NumberOfProducts
from Production.ProductSubcategory as psc 
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by psc.Name
having COUNT(ProductID) > 20

--------------------------------------------------------------------------------
-- Q_13: Display colors whose average product price is greater than 1000 

select color,
	   AVG(ListPrice) as AveragePrice
from Production.Product
group by Color
having AVG(ListPrice) > 1000

--------------------------------------------------------------------------------
-- Q_14: Display subcategories whose total product price exceeds 50,000 

select psc.Name as ProductSubCategory,
       SUM(ListPrice) as TotalPrice
from Production.ProductSubcategory as psc 
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by psc.Name
having SUM(ListPrice)  > 50000

--------------------------------------------------------------------------------
-- Q_15: Display classes that contain at least 5 products 

select Class,
       COUNT(ProductID) as NumberOfProducts
from Production.Product
group by Class
having COUNT(ProductID) >= 5 

--------------------------------------------------------------------------------
-- Q_16: Display the number of products for each color and sort the result by product count in descending order 

select color,
	   COUNT(ProductID) as NumberOfProducts
from Production.Product
group by Color
order by COUNT(ProductID) desc

--------------------------------------------------------------------------------
-- Q_17: Find the three colors with the highest number of products 

select 
       Top 3 with TIES
	   color,
	   COUNT(ProductID) as NumberOfProducts
from Production.Product
group by Color
order by COUNT(ProductID) desc

--------------------------------------------------------------------------------
-- Q_18: Find the subcategory with the highest average product price 

select Top 1 with TIES
       psc.Name as ProductSubCategory,
       AVG(p.ListPrice) as AveragePrice
from Production.ProductSubcategory as psc 
left join Production.Product as p
on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by psc.Name
order by AVG(p.ListPrice) desc

--------------------------------------------------------------------------------
-- Q_19: Display colors whose product count is greater than the average product count across all colors 

select Color,
       COUNT(*) as NumberOfProducts
from Production.Product
group by Color
having COUNT(*) >
(
    select AVG(ProductCount)
    from
    (
        select COUNT(*) as ProductCount
        from Production.Product
        group by Color
    ) as T
)

--------------------------------------------------------------------------------
/** Q_20: Create a report for each color containing:
          - Color
		  - Product Count
		  - Average Price
		  - Minimum Price
		  - Maximum Price
		  - Total Price
		  Then show only colors that:
		  - Have at least 5 products
		  - Have an average price greater than 500
		  Sort the output by Average Price in descending order.
**/

select Color,
       COUNT(*) as ProductCount,
       AVG(ListPrice) as AveragePrice,
       MIN(ListPrice) as MinimumPrice,
       MAX(ListPrice) as MaximumPrice,
       SUM(ListPrice) as TotalPrice
from Production.Product
group by Color
having COUNT(*) >= 5
   and AVG(ListPrice) > 500
order by AveragePrice desc


