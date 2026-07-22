
-- << BUSINESS CASE >>--


use AdventureWorks2019

-- Q_01: Find the top 10 customers by total purchase amount  

select top 10
       c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       SUM(soh.TotalDue) as TotalPurchaseAmount
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by SUM(soh.TotalDue) desc

--------------------------------------------------------------------------------
-- Q_02: Display the top 10 best-selling products by quantity sold   

select top 10
       p.ProductID,
       p.Name as ProductName,
       SUM(sod.OrderQty) as TotalQuantitySold
from Production.Product as p
inner join Sales.SalesOrderDetail as sod
    on p.ProductID = sod.ProductID
group by p.ProductID,
         p.Name
order by SUM(sod.OrderQty) desc

--------------------------------------------------------------------------------
-- Q_03: Display the top 10 best-selling products by sales amount  

select top 10
       p.ProductID,
       p.Name as ProductName,
       SUM(sod.LineTotal) as TotalSalesAmount
from Production.Product as p
inner join Sales.SalesOrderDetail as sod
    on p.ProductID = sod.ProductID
group by p.ProductID,
         p.Name
order by SUM(sod.LineTotal) desc

--------------------------------------------------------------------------------
-- Q_04: Calculate monthly company sales  

select YEAR(soh.OrderDate) as SalesYear,
       MONTH(soh.OrderDate) as SalesMonth,
       SUM(sod.LineTotal) as MonthlySales
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
group by YEAR(soh.OrderDate),
         MONTH(soh.OrderDate)
order by SalesYear,
         SalesMonth

--------------------------------------------------------------------------------
-- Q_05: Calculate yearly company sales  

select YEAR(soh.OrderDate) as SalesYear,
       SUM(sod.LineTotal) as YearlySales
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
group by YEAR(soh.OrderDate)
order by SalesYear

--------------------------------------------------------------------------------
-- Q_06: Find the month with the highest sales  

select top 1
       YEAR(soh.OrderDate) as SalesYear,
       MONTH(soh.OrderDate) as SalesMonth,
       SUM(sod.LineTotal) as TotalSales
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
group by YEAR(soh.OrderDate),
         MONTH(soh.OrderDate)
order by SUM(sod.LineTotal) desc

--------------------------------------------------------------------------------
-- Q_07: Find the year with the highest sales  

select top 1
       YEAR(soh.OrderDate) as SalesYear,
       SUM(sod.LineTotal) as TotalSales
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
group by YEAR(soh.OrderDate)
order by SUM(sod.LineTotal) desc

--------------------------------------------------------------------------------
-- Q_08: Calculate month-over-month sales growth  

with MonthlySales as
(
    select YEAR(soh.OrderDate) as SalesYear,
           MONTH(soh.OrderDate) as SalesMonth,
           SUM(sod.LineTotal) as MonthlySales
    from Sales.SalesOrderHeader as soh
    inner join Sales.SalesOrderDetail as sod
        on soh.SalesOrderID = sod.SalesOrderID
    group by YEAR(soh.OrderDate),
             MONTH(soh.OrderDate)
)
select SalesYear,
       SalesMonth,
       MonthlySales,
       LAG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
       ) as PreviousMonthSales,
       (MonthlySales - LAG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
       )) * 100.0 
       /
       LAG(MonthlySales) over
       (
           order by SalesYear, SalesMonth
       ) as GrowthPercentage
from MonthlySales

--------------------------------------------------------------------------------
-- Q_09: Calculate year-over-year sales growth  

with YearlySales as
(
    select YEAR(soh.OrderDate) as SalesYear,
           SUM(sod.LineTotal) as YearlySales
    from Sales.SalesOrderHeader as soh
    inner join Sales.SalesOrderDetail as sod
        on soh.SalesOrderID = sod.SalesOrderID
    group by YEAR(soh.OrderDate)
)
select SalesYear,
       YearlySales,
       LAG(YearlySales) over
       (
           order by SalesYear
       ) as PreviousYearSales,
       (YearlySales - LAG(YearlySales) over
       (
           order by SalesYear
       )) * 100.0
       /
       LAG(YearlySales) over
       (
           order by SalesYear
       ) as GrowthPercentage
from YearlySales

--------------------------------------------------------------------------------
-- Q_10: Calculate average order value 

select SUM(sod.LineTotal) / COUNT(distinct soh.SalesOrderID) as AverageOrderValue
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID

--------------------------------------------------------------------------------
-- Q_11: Find customers with the highest number of orders  

select top 10
       c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       COUNT(soh.SalesOrderID) as NumberOfOrders
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by COUNT(soh.SalesOrderID) desc

--------------------------------------------------------------------------------
-- Q_12: Find customers with the highest purchase amounts  

select top 10
       c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       SUM(soh.TotalDue) as TotalPurchaseAmount
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by SUM(soh.TotalDue) desc

--------------------------------------------------------------------------------
-- Q_13: Find customers who placed only one order  

select c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       COUNT(soh.SalesOrderID) as NumberOfOrders
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
having COUNT(soh.SalesOrderID) = 1

--------------------------------------------------------------------------------
-- Q_14: Find customers with no purchases in the last two years  

select c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName
from Sales.Customer as c
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
where not exists
(
    select *
    from Sales.SalesOrderHeader as soh
    where soh.CustomerID = c.CustomerID
      and soh.OrderDate >= DATEADD(YEAR, -2,
          (select MAX(OrderDate) from Sales.SalesOrderHeader))
)

--------------------------------------------------------------------------------
/** Q_15: Segment customers into:
          - Gold
		  - Silver
		  - Bronze
		  based on purchase amount.
**/

select c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       SUM(soh.TotalDue) as TotalPurchaseAmount,
       case
            when SUM(soh.TotalDue) >= 100000 then 'Gold'
            when SUM(soh.TotalDue) >= 50000 then 'Silver'
            else 'Bronze'
       end as CustomerSegment
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by TotalPurchaseAmount desc

--------------------------------------------------------------------------------
-- Q_16: Find customers whose purchase amount is above average  

with CustomerPurchases as
(
    select c.CustomerID,
           p.FirstName + ' ' + p.LastName as CustomerName,
           SUM(soh.TotalDue) as TotalPurchaseAmount
    from Sales.Customer as c
    inner join Sales.SalesOrderHeader as soh
        on c.CustomerID = soh.CustomerID
    inner join Person.Person as p
        on c.PersonID = p.BusinessEntityID
    group by c.CustomerID,
             p.FirstName,
             p.LastName
)
select CustomerID,
       CustomerName,
       TotalPurchaseAmount
from CustomerPurchases
where TotalPurchaseAmount >
(
    select AVG(TotalPurchaseAmount)
    from CustomerPurchases
)
order by TotalPurchaseAmount desc

--------------------------------------------------------------------------------
-- Q_17: Display the first and last order for each customer  

with Orders as
(
    select CustomerID,
           SalesOrderID,
           OrderDate,
           ROW_NUMBER() over
           (
               partition by CustomerID
               order by OrderDate asc
           ) as FirstOrder,

           ROW_NUMBER() over
           (
               partition by CustomerID
               order by OrderDate desc
           ) as LastOrder
    from Sales.SalesOrderHeader
)
select CustomerID,
       SalesOrderID,
       OrderDate,
       case
            when FirstOrder = 1 then 'First Order'
            when LastOrder = 1 then 'Last Order'
       end as OrderType
from Orders
where FirstOrder = 1
   or LastOrder = 1
order by CustomerID, OrderDate

--------------------------------------------------------------------------------
-- Q_18: Calculate the time span between the first and last order of each customer  

select CustomerID,
       MIN(OrderDate) as FirstOrderDate,
       MAX(OrderDate) as LastOrderDate,
       DATEDIFF(DAY,
                MIN(OrderDate),
                MAX(OrderDate)) as TimeSpanInDays
from Sales.SalesOrderHeader
group by CustomerID
order by TimeSpanInDays desc

--------------------------------------------------------------------------------
-- Q_19: Find customers with the highest purchase growth  

with CustomerOrders as
(
    select CustomerID,
           SalesOrderID,
           TotalDue,
           OrderDate,
           ROW_NUMBER() over
           (
               partition by CustomerID
               order by OrderDate asc
           ) as FirstOrder,

           ROW_NUMBER() over
           (
               partition by CustomerID
               order by OrderDate desc
           ) as LastOrder
    from Sales.SalesOrderHeader
),
CustomerGrowth as
(
    select CustomerID,
           MAX(case when FirstOrder = 1 then TotalDue end) as FirstPurchase,
           MAX(case when LastOrder = 1 then TotalDue end) as LastPurchase
    from CustomerOrders
    group by CustomerID
)
select top 10
       CustomerID,
       FirstPurchase,
       LastPurchase,
       LastPurchase - FirstPurchase as PurchaseGrowth
from CustomerGrowth
order by PurchaseGrowth desc

--------------------------------------------------------------------------------
-- Q_20: Calculate Customer Lifetime Value (CLV)  

select c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       SUM(soh.TotalDue) as CustomerLifetimeValue
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by CustomerLifetimeValue desc

--------------------------------------------------------------------------------
-- Q_21: Find products that have never been sold  

select p.ProductID,
       p.Name as ProductName
from Production.Product as p
where not exists
(
    select *
    from Sales.SalesOrderDetail as sod
    where sod.ProductID = p.ProductID
)

--------------------------------------------------------------------------------
-- Q_22: Find products generating the highest revenue  

select top 10
       p.ProductID,
       p.Name as ProductName,
       SUM(sod.LineTotal) as TotalRevenue
from Production.Product as p
inner join Sales.SalesOrderDetail as sod
    on p.ProductID = sod.ProductID
group by p.ProductID,
         p.Name
order by TotalRevenue desc

--------------------------------------------------------------------------------
-- Q_23: Find the best-selling product in each category  

with ProductSales as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           SUM(sod.OrderQty) as TotalQuantitySold
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
RankedProducts as
(
    select CategoryName,
           ProductID,
           ProductName,
           TotalQuantitySold,
           RANK() over
           (
               partition by CategoryName
               order by TotalQuantitySold desc
           ) as ProductRank
    from ProductSales
)
select CategoryName,
       ProductID,
       ProductName,
       TotalQuantitySold
from RankedProducts
where ProductRank = 1

--------------------------------------------------------------------------------
-- Q_24: Find the top three products in each category  

with ProductSales as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           SUM(sod.OrderQty) as TotalQuantitySold
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
RankedProducts as
(
    select CategoryName,
           ProductID,
           ProductName,
           TotalQuantitySold,
           RANK() over
           (
               partition by CategoryName
               order by TotalQuantitySold desc
           ) as ProductRank
    from ProductSales
)
select CategoryName,
       ProductID,
       ProductName,
       TotalQuantitySold
from RankedProducts
where ProductRank <= 3
order by CategoryName,
         ProductRank

--------------------------------------------------------------------------------
-- Q_25: Find products whose sales are below their category average  

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
           ) as CategoryAverageSales
    from ProductSales
)
select CategoryName,
       ProductID,
       ProductName,
       TotalSales,
       CategoryAverageSales
from CategoryAverage
where TotalSales < CategoryAverageSales
order by CategoryName, TotalSales

--------------------------------------------------------------------------------
-- Q_26: Find the best salesperson by sales amount  

select top 1
       sp.BusinessEntityID as SalesPersonID,
       p.FirstName + ' ' + p.LastName as SalesPersonName,
       SUM(soh.TotalDue) as TotalSalesAmount
from Sales.SalesPerson as sp
inner join Sales.SalesOrderHeader as soh
    on sp.BusinessEntityID = soh.SalesPersonID
inner join Person.Person as p
    on sp.BusinessEntityID = p.BusinessEntityID
group by sp.BusinessEntityID,
         p.FirstName,
         p.LastName
order by SUM(soh.TotalDue) desc

--------------------------------------------------------------------------------
-- Q_27: Find the best salesperson by number of orders  

select top 1
       sp.BusinessEntityID as SalesPersonID,
       p.FirstName + ' ' + p.LastName as SalesPersonName,
       COUNT(soh.SalesOrderID) as NumberOfOrders
from Sales.SalesPerson as sp
inner join Sales.SalesOrderHeader as soh
    on sp.BusinessEntityID = soh.SalesPersonID
inner join Person.Person as p
    on sp.BusinessEntityID = p.BusinessEntityID
group by sp.BusinessEntityID,
         p.FirstName,
         p.LastName
order by COUNT(soh.SalesOrderID) desc

--------------------------------------------------------------------------------
-- Q_28: Rank salespersons by sales amount  

with SalesPersonSales as
(
    select sp.BusinessEntityID as SalesPersonID,
           p.FirstName + ' ' + p.LastName as SalesPersonName,
           SUM(soh.TotalDue) as TotalSalesAmount
    from Sales.SalesPerson as sp
    inner join Sales.SalesOrderHeader as soh
        on sp.BusinessEntityID = soh.SalesPersonID
    inner join Person.Person as p
        on sp.BusinessEntityID = p.BusinessEntityID
    group by sp.BusinessEntityID,
             p.FirstName,
             p.LastName
)
select SalesPersonID,
       SalesPersonName,
       TotalSalesAmount,
       RANK() over
       (
           order by TotalSalesAmount desc
       ) as SalesRank
from SalesPersonSales
order by SalesRank

--------------------------------------------------------------------------------
/** Q_29: Create a KPI dashboard containing:
          - Total Revenue
		  - Total Orders
		  - Total Customers
		  - Average Order Value
		  - Top Product
**/

with TopProduct as
(
    select top 1
           p.Name as TopProductName
    from Production.Product as p
    inner join Sales.SalesOrderDetail as sod
        on p.ProductID = sod.ProductID
    group by p.Name
    order by SUM(sod.LineTotal) desc
)

select
       (select SUM(TotalDue)
        from Sales.SalesOrderHeader) as TotalRevenue,

       (select COUNT(SalesOrderID)
        from Sales.SalesOrderHeader) as TotalOrders,

       (select COUNT(distinct CustomerID)
        from Sales.SalesOrderHeader) as TotalCustomers,

       (select AVG(TotalDue)
        from Sales.SalesOrderHeader) as AverageOrderValue,

       (select TopProductName
        from TopProduct) as TopProduct

--------------------------------------------------------------------------------
/** Q_30: Create a complete executive report including: Sales KPIs:
- Total Revenue
- Monthly Revenue 
- YoY Growth

Customer KPIs:
- Top Customers
- Active Customers
- Inactive Customers

Product KPIs:
- Top Products
- Unsold Products

Salesperson KPIs:
- Top Salespersons
using only SQL and AdventureWorks2019.
**/

-- Sales KPIs:

-- Total Revenue

select SUM(TotalDue) as TotalRevenue
from Sales.SalesOrderHeader


-- Monthly Revenue

select YEAR(soh.OrderDate) as SalesYear,
       MONTH(soh.OrderDate) as SalesMonth,
       SUM(sod.LineTotal) as MonthlyRevenue
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
group by YEAR(soh.OrderDate),
         MONTH(soh.OrderDate)
order by SalesYear,
         SalesMonth;


-- YoY Growth

with YearlySales as
(
    select YEAR(OrderDate) as SalesYear,
           SUM(TotalDue) as Revenue
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate)
)

select SalesYear,
       Revenue,
       LAG(Revenue) over
       (
           order by SalesYear
       ) as PreviousYearRevenue,

       (Revenue -
        LAG(Revenue) over
        (
            order by SalesYear
        )) * 100.0
        /
        LAG(Revenue) over
        (
            order by SalesYear
        ) as YoYGrowthPercentage

from YearlySales

-- Customer KPIs:

-- Top Customers

select top 10
       c.CustomerID,
       p.FirstName + ' ' + p.LastName as CustomerName,
       SUM(soh.TotalDue) as TotalPurchase
from Sales.Customer as c
inner join Sales.SalesOrderHeader as soh
    on c.CustomerID = soh.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID
group by c.CustomerID,
         p.FirstName,
         p.LastName
order by TotalPurchase desc


-- Active Customers

select COUNT(distinct CustomerID) as ActiveCustomers
from Sales.SalesOrderHeader
where OrderDate >= DATEADD(YEAR,-2,
      (select MAX(OrderDate)
       from Sales.SalesOrderHeader))


-- Inactive Customers

select COUNT(*) as InactiveCustomers
from Sales.Customer as c
where not exists
(
    select *
    from Sales.SalesOrderHeader as soh
    where soh.CustomerID = c.CustomerID
      and soh.OrderDate >= DATEADD(YEAR,-2,
          (select MAX(OrderDate)
           from Sales.SalesOrderHeader))
)

-- Product KPIs:

-- Top Products by Revenue

select top 10
       p.ProductID,
       p.Name as ProductName,
       SUM(sod.LineTotal) as Revenue
from Production.Product as p
inner join Sales.SalesOrderDetail as sod
    on p.ProductID = sod.ProductID
group by p.ProductID,
         p.Name
order by Revenue desc


-- Unsold Products

select p.ProductID,
       p.Name as ProductName
from Production.Product as p
where not exists
(
    select *
    from Sales.SalesOrderDetail as sod
    where sod.ProductID = p.ProductID
)

-- Salesperson KPIs:

-- Top Salespersons

select top 10
       sp.BusinessEntityID as SalesPersonID,
       per.FirstName + ' ' + per.LastName as SalesPersonName,
       SUM(soh.TotalDue) as TotalSales
from Sales.SalesPerson as sp
inner join Sales.SalesOrderHeader as soh
    on sp.BusinessEntityID = soh.SalesPersonID
inner join Person.Person as per
    on sp.BusinessEntityID = per.BusinessEntityID
group by sp.BusinessEntityID,
         per.FirstName,
         per.LastName
order by TotalSales desc

