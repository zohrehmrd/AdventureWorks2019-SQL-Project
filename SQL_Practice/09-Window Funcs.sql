
--<< WINDOW FUNCTIONS >>--

/*
===================================
>> Part1: ROW_NUMBER (Q1 - Q5)
===================================
*/

use AdventureWorks2019

-- Q_01: Assign a row number to all products based on descending price  

select ROW_NUMBER() over (order by ListPrice desc) as RowNumber,
       ProductID,
	   Name as ProductName,
	   ListPrice
from Production.Product

--------------------------------------------------------------------------------
-- Q_02: Generate a separate row number for each product color  

select ROW_NUMBER() over (partition by Color order by ProductID asc) as RowNumber,
       ProductID,
	   Name as ProductName,
	   Color
from Production.Product

--------------------------------------------------------------------------------
-- Q_03: Display the first product of each color  

select ProductID,
       ProductName,
	   Color
from (
       select ROW_NUMBER() over (partition by Color order by ProductID asc) as RowNumber,
       ProductID,
	   Name as ProductName,
	   Color
       from Production.Product
	   ) as p
where RowNumber = 1

--------------------------------------------------------------------------------
-- Q_04: Display the first three products of each color  

select RowNumber,
       ProductID,
       ProductName,
	   Color
from (
       select ROW_NUMBER() over (partition by Color order by ProductID asc) as RowNumber,
       ProductID,
	   Name as ProductName,
	   Color
       from Production.Product
	   ) as p
where RowNumber between 1 and 3

--------------------------------------------------------------------------------
-- Q_05: Number each customer's orders based on order date  

select ROW_NUMBER () over (partition by CustomerID order by OrderDate, SalesOrderID) as RowNumber,
	   CustomerID,
	   SalesOrderID,
	   OrderDate
from Sales.SalesOrderHeader

/*
===================================
>> Part2: RANK() (Q6 - Q10)
===================================
*/

-- Q_06: Rank products by price  

select ProductID,
       Name as ProductName,
       ListPrice,
       RANK() over
       (
           order by ListPrice desc
       ) as PriceRank
from Production.Product
order by PriceRank

--------------------------------------------------------------------------------
-- Q_07: Calculate product rankings within each color  

select ProductID,
       Name as ProductName,
       Color,
       ListPrice,
       RANK() over
       (
           partition by Color
           order by ListPrice desc
       ) as ProductRank
from Production.Product
where Color is not null
order by Color,
         ProductRank

--------------------------------------------------------------------------------
-- Q_08: Display the top five products by price  

with ProductRanking as
(
    select ProductID,
           Name as ProductName,
           ListPrice,
           RANK() over
           (
               order by ListPrice desc
           ) as PriceRank
    from Production.Product
)

select ProductID,
       ProductName,
       ListPrice,
       PriceRank
from ProductRanking
where PriceRank <= 5
order by PriceRank

--------------------------------------------------------------------------------
-- Q_09: Rank products by price within each category  

select pc.Name as CategoryName,
       p.ProductID,
       p.Name as ProductName,
       p.ListPrice,
       RANK() over
       (
           partition by pc.Name
           order by p.ListPrice desc
       ) as PriceRank
from Production.Product as p
inner join Production.ProductSubcategory as psc
    on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Production.ProductCategory as pc
    on psc.ProductCategoryID = pc.ProductCategoryID
order by CategoryName,
         PriceRank

--------------------------------------------------------------------------------
-- Q_10: Display products whose rank within their category is less than or equal to 3  

with ProductRanking as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           p.ListPrice,
           RANK() over
           (
               partition by pc.Name
               order by p.ListPrice desc
           ) as PriceRank
    from Production.Product as p
    inner join Production.ProductSubcategory as psc
        on p.ProductSubcategoryID = psc.ProductSubcategoryID
    inner join Production.ProductCategory as pc
        on psc.ProductCategoryID = pc.ProductCategoryID
)

select CategoryName,
       ProductID,
       ProductName,
       ListPrice,
       PriceRank
from ProductRanking
where PriceRank <= 3
order by CategoryName,
         PriceRank

/*
===================================
>> Part3: DENSE_RANK() (Q11 - Q13)
===================================
*/

-- Q_11: Rank products by price using DENSE_RANK  

select ProductID,
       Name as ProductName,
       ListPrice,
       DENSE_RANK() over
       (
           order by ListPrice desc
       ) as PriceRank
from Production.Product
order by PriceRank

--------------------------------------------------------------------------------
-- Q_12: Display the top three ranks of products within each color  

with ProductRanking as
(
    select ProductID,
           Name as ProductName,
           Color,
           ListPrice,
           DENSE_RANK() over
           (
               partition by Color
               order by ListPrice desc
           ) as PriceRank
    from Production.Product
    where Color is not null
)

select ProductID,
       ProductName,
       Color,
       ListPrice,
       PriceRank
from ProductRanking
where PriceRank <= 3
order by Color,
         PriceRank

--------------------------------------------------------------------------------
-- Q_13: Calculate product price rankings within each category  

select pc.Name as CategoryName,
       p.ProductID,
       p.Name as ProductName,
       p.ListPrice,
       DENSE_RANK() over
       (
           partition by pc.Name
           order by p.ListPrice desc
       ) as PriceRank
from Production.Product as p
inner join Production.ProductSubcategory as psc
    on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Production.ProductCategory as pc
    on psc.ProductCategoryID = pc.ProductCategoryID
order by CategoryName,
         PriceRank

/*
===================================
>> Part4: NTILE() (Q14 - Q16)
===================================
*/

-- Q_14: Divide products into four equal groups based on price  

select ProductID,
       Name as ProductName,
       ListPrice,
       NTILE(4) over
       (
           order by ListPrice desc
       ) as PriceGroup
from Production.Product
where ListPrice > 0
order by PriceGroup, ListPrice desc

--------------------------------------------------------------------------------
-- Q_15: Divide customers into five groups based on purchase amount  

with CustomerPurchases as
(
    select CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by CustomerID
)

select CustomerID,
       TotalPurchaseAmount,
       NTILE(5) over
       (
           order by TotalPurchaseAmount desc
       ) as PurchaseGroup
from CustomerPurchases
order by PurchaseGroup, TotalPurchaseAmount desc

--------------------------------------------------------------------------------
-- Q_16: Display products that fall into the top 25% by price  

with ProductPriceGroups as
(
    select ProductID,
           Name as ProductName,
           ListPrice,
           NTILE(4) over
           (
               order by ListPrice desc
           ) as PriceGroup
    from Production.Product
    where ListPrice > 0
)

select ProductID,
       ProductName,
       ListPrice,
       PriceGroup
from ProductPriceGroups
where PriceGroup = 1
order by ListPrice desc

/*
===================================
>> Part5: LAG() & LEAD() (Q17 - Q20)
===================================
*/

-- Q_17: Display each month's sales along with the previous month's sales  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       LAG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
       ) as PreviousMonthSales
from MonthlySales
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_18: Display each month's sales along with the next month's sales  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       LEAD(MonthlySales) over
       (
           order by SalesYear, SalesMonth
       ) as NextMonthSales
from MonthlySales
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_19: Calculate the difference between each month's sales and the previous month's sales  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
),

SalesComparison as
(
    select SalesYear,
           SalesMonth,
           MonthlySales,
           LAG(MonthlySales) over
           (
               order by SalesYear, SalesMonth
           ) as PreviousMonthSales
    from MonthlySales
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       PreviousMonthSales,
       MonthlySales - PreviousMonthSales as SalesDifference
from SalesComparison
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_20: Calculate the sales growth percentage compared to the previous month  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
),

SalesGrowth as
(
    select
           SalesYear,
           SalesMonth,
           MonthlySales,
           LAG(MonthlySales) over
           (
               order by SalesYear, SalesMonth
           ) as PreviousMonthSales
    from MonthlySales
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       PreviousMonthSales,
       ((MonthlySales - PreviousMonthSales) * 100.0 
        / PreviousMonthSales) as SalesGrowthPercentage
from SalesGrowth
where PreviousMonthSales is not null
order by SalesYear,
         SalesMonth

/*
===================================
>> Part6: Running Total (Q21 - Q22)
===================================
*/

-- Q_21: Calculate the running total of monthly sales  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       SUM(MonthlySales) over
       (
           order by SalesYear, SalesMonth
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) as RunningTotalSales
from MonthlySales
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_22: Calculate the running total of purchases for each customer  

select CustomerID,
       SalesOrderID,
       OrderDate,
       TotalDue,
       SUM(TotalDue) over
       (
           partition by CustomerID
           order by OrderDate, SalesOrderID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) as RunningTotalPurchase
from Sales.SalesOrderHeader
order by CustomerID,
         OrderDate

/*
===================================
>> Part7: Moving Average (Q23 - Q24)
===================================
*/

-- Q_23: Calculate the 3-month moving average of sales   

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       AVG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) as ThreeMonthMovingAverage
from MonthlySales
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_24: Calculate the 6-month moving average of sales  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
)

select SalesYear,
       SalesMonth,
       MonthlySales,
       AVG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
           ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
       ) as SixMonthMovingAverage
from MonthlySales
order by SalesYear,
         SalesMonth

/*
===================================
>> Part8: Challenge (Q25)
===================================
*/

/** Q-25 Create a monthly sales report containing:
    - Year
	- Month
	- Monthly Sales
	- Previous Month Sales
	- Sales Difference
	- Growth Percentage
	- Running Total
	- 3-Month Moving Average
	All calculations must be implemented using Window Functions
	**/

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
),

SalesAnalysis as
(
    select SalesYear,
           SalesMonth,
           MonthlySales,

           LAG(MonthlySales) over
           (
               order by SalesYear, SalesMonth
           ) as PreviousMonthSales,

           SUM(MonthlySales) over
           (
               order by SalesYear, SalesMonth
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) as RunningTotal,

           AVG(MonthlySales) over
           (
               order by SalesYear, SalesMonth
               ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
           ) as ThreeMonthMovingAverage

    from MonthlySales
)

select SalesYear as Year,
       SalesMonth as Month,
       MonthlySales,
       PreviousMonthSales,

       MonthlySales - PreviousMonthSales as SalesDifference,

       ((MonthlySales - PreviousMonthSales) * 100.0 
        / PreviousMonthSales) as GrowthPercentage,

       RunningTotal,

       ThreeMonthMovingAverage

from SalesAnalysis
order by Year,
         Month

/*
===================================
>> Part9: Bonus Challenge 
===================================
*/

-- Bonus_01: Find the top 3 best-selling products in each category 

with ProductSales as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           SUM(sod.OrderQty) as TotalQuantitySold,
           SUM(sod.LineTotal) as TotalSales
    from Production.Product as p
    inner join Sales.SalesOrderDetail as sod
        on p.ProductID = sod.ProductID
    inner join Production.ProductSubcategory as psc
        on p.ProductSubcategoryID = psc.ProductSubcategoryID
    inner join Production.ProductCategory as pc
        on psc.ProductCategoryID = pc.ProductCategoryID
    group by pc.Name,
             p.ProductID,
             p.Name
),

ProductRanking as
(
    select CategoryName,
           ProductID,
           ProductName,
           TotalQuantitySold,
           TotalSales,
           DENSE_RANK() over
           (
               partition by CategoryName
               order by TotalQuantitySold desc
           ) as ProductRank
    from ProductSales
)

select CategoryName,
       ProductID,
       ProductName,
       TotalQuantitySold,
       TotalSales,
       ProductRank
from ProductRanking
where ProductRank <= 3
order by CategoryName,
         ProductRank

--------------------------------------------------------------------------------
-- Bonus_02: Display the latest order for each customer  

with CustomerOrders as
(
    select CustomerID,
           SalesOrderID,
           OrderDate,
           TotalDue,
           ROW_NUMBER() over
           (
               partition by CustomerID
               order by OrderDate desc, SalesOrderID desc
           ) as OrderRank
    from Sales.SalesOrderHeader
)

select CustomerID,
       SalesOrderID,
       OrderDate,
       TotalDue
from CustomerOrders
where OrderRank = 1
order by CustomerID

--------------------------------------------------------------------------------
-- Bonus_03: Display the top 5 customers by purchase amount for each year 

with CustomerYearlySales as
(
    select YEAR(OrderDate) as SalesYear,
           CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             CustomerID
),

CustomerRanking as
(
    select SalesYear,
           CustomerID,
           TotalPurchaseAmount,
           DENSE_RANK() over
           (
               partition by SalesYear
               order by TotalPurchaseAmount desc
           ) as CustomerRank
    from CustomerYearlySales
)

select SalesYear,
       CustomerID,
       TotalPurchaseAmount,
       CustomerRank
from CustomerRanking
where CustomerRank <= 5
order by SalesYear,
         CustomerRank

--------------------------------------------------------------------------------
-- Bonus_04: Find products whose sales exceed the average sales of their category  

with ProductSales as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           SUM(sod.LineTotal) as TotalSales
    from Production.Product as p
    inner join Sales.SalesOrderDetail as sod
        on p.ProductID = sod.ProductID
    inner join Production.ProductSubcategory as psc
        on p.ProductSubcategoryID = psc.ProductSubcategoryID
    inner join Production.ProductCategory as pc
        on psc.ProductCategoryID = pc.ProductCategoryID
    group by pc.Name,
             p.ProductID,
             p.Name
),

CategoryAverage as
(
    select CategoryName,
           ProductID,
           ProductName,
           TotalSales,
           AVG(TotalSales) over
           (
               partition by CategoryName
           ) as AverageCategorySales
    from ProductSales
)

select CategoryName,
       ProductID,
       ProductName,
       TotalSales,
       AverageCategorySales
from CategoryAverage
where TotalSales > AverageCategorySales
order by CategoryName,
         TotalSales desc
