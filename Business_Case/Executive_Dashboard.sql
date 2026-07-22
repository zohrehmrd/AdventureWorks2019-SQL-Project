/*
========================================================

Executive Dashboard

This report was created as a final business dashboard
using AdventureWorks2019.

Unlike the previous SQL files, which contain solutions
to individual business case questions, this script
combines the most important KPIs into a single executive
report for management.

 KPIs:
 - Sales Performance
 - Customer Analysis
 - Product Analysis
 - Salesperson Performance
====================================================
*/


/*
====================================================
 1. SALES KPIs
====================================================
*/


-- Total Revenue

select 'Total Revenue' as KPI,
        SUM(TotalDue) as Value
from Sales.SalesOrderHeader


-- Total Orders

select 'Total Orders' as KPI,
       COUNT(SalesOrderID) as Value
from Sales.SalesOrderHeader


-- Average Order Value

select 'Average Order Value' as KPI,
       AVG(TotalDue) as Value
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
         SalesMonth


-- Year Over Year Growth

with YearlySales as
(
    select YEAR(OrderDate) as SalesYear,
           SUM(TotalDue) as Revenue
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate)
)

select
       SalesYear,
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


/*
====================================================
 2. CUSTOMER KPIs
====================================================
*/


-- Total Customers

select 'Total Customers' as KPI,
       COUNT(*) as Value
from Sales.Customer


-- Top 10 Customers by Purchase Amount

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
order by TotalPurchaseAmount desc


-- Active Customers (last two years)

select COUNT(distinct CustomerID) as ActiveCustomers
from Sales.SalesOrderHeader
where OrderDate >= DATEADD
(
    YEAR,
    -2,
    (select MAX(OrderDate)
     from Sales.SalesOrderHeader)
)


-- Inactive Customers

select COUNT(*) as InactiveCustomers
from Sales.Customer as c
where not exists
(
    select *
    from Sales.SalesOrderHeader as soh
    where soh.CustomerID = c.CustomerID
    AND soh.OrderDate >= DATEADD
    (
        YEAR,
        -2,
        (select MAX(OrderDate)
         from Sales.SalesOrderHeader)
    )
)


/*
====================================================
 3. PRODUCT KPIs
====================================================
*/


-- Top 10 Products by Revenue

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


-- Top 10 Best Selling Products by Quantity

select top 10
       p.ProductID,
       p.Name as ProductName,
       SUM(sod.OrderQty) as QuantitySold
from Production.Product as p
inner join Sales.SalesOrderDetail as sod
    on p.ProductID = sod.ProductID
group by
       p.ProductID,
       p.Name
order by QuantitySold desc


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


/*
====================================================
 4. SALESPERSON KPIs
====================================================
*/


-- Top 10 Salespersons by Revenue

select top 10
       sp.BusinessEntityID as SalesPersonID,
       per.FirstName + ' ' + per.LastName as SalesPersonName,
       SUM(soh.TotalDue) as TotalSalesAmount
from Sales.SalesPerson as sp
inner join Sales.SalesOrderHeader as soh
    on sp.BusinessEntityID = soh.SalesPersonID
inner join Person.Person as per
    on sp.BusinessEntityID = per.BusinessEntityID
group by sp.BusinessEntityID,
         per.FirstName,
         per.LastName
order by TotalSalesAmount desc


-- Top Salespersons by Number of Orders

select top 10
       sp.BusinessEntityID as SalesPersonID,
       per.FirstName + ' ' + per.LastName as SalesPersonName,
       COUNT(soh.SalesOrderID) as NumberOfOrders
from Sales.SalesPerson as sp
inner join Sales.SalesOrderHeader as soh
    on sp.BusinessEntityID = soh.SalesPersonID
inner join Person.Person as per
    on sp.BusinessEntityID = per.BusinessEntityID
group by sp.BusinessEntityID,
         per.FirstName,
         per.LastName
order by NumberOfOrders desc