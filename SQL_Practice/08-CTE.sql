
-- << COMMAN TABLE EXPRESSION >>--

/*
===================================
>> Part1: Basic CTE (Q1 - Q10)
===================================
*/

use AdventureWorks2019

-- Q_01: Using a CTE, display products whose price is greater than the average price of all products  

with AvgPrice as
(
    select AVG(ListPrice) as AveragePrice
    from Production.Product
)

select p.ProductID,
       p.Name as ProductName,
       p.ListPrice
from Production.Product as p
cross join AvgPrice
where p.ListPrice > AvgPrice.AveragePrice
order by p.ListPrice desc

--------------------------------------------------------------------------------
-- Q_02: Using a CTE, calculate the number of products for each color  

with ProductColors as
(
    select Color,
           COUNT(ProductID) as NumberOfProducts
    from Production.Product
    where Color is not null
    group by Color
)

select Color,
       NumberOfProducts
from ProductColors
order by NumberOfProducts desc

--------------------------------------------------------------------------------
-- Q_03: Using a CTE, calculate the average price of products for each color  

with ProductAveragePrice as
(
    select Color,
           AVG(ListPrice) as AveragePrice
    from Production.Product
    where Color is not null
    group by Color
)

select Color,
       AveragePrice
from ProductAveragePrice
order by AveragePrice desc

--------------------------------------------------------------------------------
-- Q_04: Using a CTE, display customers who have placed more than 5 orders  

with CustomerOrders as
(
    select CustomerID,
           COUNT(SalesOrderID) as NumberOfOrders
    from Sales.SalesOrderHeader
    group by CustomerID
)

select CustomerID,
       NumberOfOrders
from CustomerOrders
where NumberOfOrders > 5
order by NumberOfOrders desc

--------------------------------------------------------------------------------
-- Q_05: Using a CTE, calculate the total purchase amount for each customer 

with CustomerPurchases as
(
    select CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by CustomerID
)

select CustomerID,
       TotalPurchaseAmount
from CustomerPurchases
order by TotalPurchaseAmount desc

--------------------------------------------------------------------------------
-- Q_06: Using a CTE, display the top 10 customers by total purchase amount  

with CustomerPurchases as
(
    select
           CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by CustomerID
)

select top 10
       CustomerID,
       TotalPurchaseAmount
from CustomerPurchases
order by TotalPurchaseAmount desc

--------------------------------------------------------------------------------
-- Q_07: Using a CTE, calculate the sales count for each product  

with ProductSalesCount as
(
    select ProductID,
           COUNT(SalesOrderID) as SalesCount
    from Sales.SalesOrderDetail
    group by ProductID
)

select ProductID,
       SalesCount
from ProductSalesCount
order by SalesCount desc

--------------------------------------------------------------------------------
-- Q_08: Using a CTE, display the top 5 best-selling products  

with ProductSales as
(
    select ProductID,
           SUM(OrderQty) as TotalQuantitySold
    from Sales.SalesOrderDetail
    group by ProductID
)

select top 5
       ProductID,
       TotalQuantitySold
from ProductSales
order by TotalQuantitySold desc

--------------------------------------------------------------------------------
-- Q_09: Using a CTE, calculate total sales for each year  

with YearlySales as
(
    select YEAR(OrderDate) as SalesYear,
           SUM(TotalDue) as TotalSales
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate)
)

select SalesYear,
       TotalSales
from YearlySales
order by SalesYear

--------------------------------------------------------------------------------
/** Q_10: Using two separate CTEs:
          - Order count per customer
		  - Total purchase amount per customer
		  Combine them into a single result
**/

with CustomerOrderCount as
(
    select CustomerID,
           COUNT(SalesOrderID) as NumberOfOrders
    from Sales.SalesOrderHeader
    group by CustomerID
),

CustomerPurchaseAmount as
(
    select CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by CustomerID
)

select coc.CustomerID,
       coc.NumberOfOrders,
       cpa.TotalPurchaseAmount
from CustomerOrderCount as coc
inner join CustomerPurchaseAmount as cpa
    on coc.CustomerID = cpa.CustomerID
order by TotalPurchaseAmount desc

/*
=========================================
>> Part2: Multi CTE Challenges (Q11 - Q12)
=========================================
*/

-- Q_11: Find the top three products in each category using CTEs (without using Window Functions) 

with ProductSales as
(
    select
           pc.Name as CategoryName,
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

ProductRanking as
(
    select p1.CategoryName,
           p1.ProductID,
           p1.ProductName,
           p1.TotalSales,
           COUNT(p2.ProductID) + 1 as ProductRank
    from ProductSales as p1
    left join ProductSales as p2
        on p1.CategoryName = p2.CategoryName
        and p2.TotalSales > p1.TotalSales
    group by p1.CategoryName,
             p1.ProductID,
             p1.ProductName,
             p1.TotalSales
)

select CategoryName,
       ProductID,
       ProductName,
       TotalSales,
       ProductRank
from ProductRanking
where ProductRank <= 3
order by CategoryName,
         ProductRank

--------------------------------------------------------------------------------
-- Q_12: Find customers whose total purchase amount exceeds the average purchase amount of all customers (Using multiple CTEs.)  

with CustomerPurchases as
(
    select CustomerID,
           SUM(TotalDue) as TotalPurchaseAmount
    from Sales.SalesOrderHeader
    group by CustomerID
),

AveragePurchase as
(
    select AVG(TotalPurchaseAmount) as AveragePurchaseAmount
    from CustomerPurchases
)

select cp.CustomerID,
       cp.TotalPurchaseAmount,
       ap.AveragePurchaseAmount
from CustomerPurchases as cp
cross join AveragePurchase as ap
where cp.TotalPurchaseAmount > ap.AveragePurchaseAmount
order by cp.TotalPurchaseAmount desc

/*
===================================
>> Part3: MRecursive CTE (Q13 - Q15) 
===================================
*/

-- Q_13: Generate numbers from 1 to 20 using a recursive CTE  

with Numbers as
(
    -- Anchor Member (شروع از 1)
    select 1 as NumberValue

    union all

    -- Recursive Member (اضافه کردن 1 به مقدار قبلی)
    select NumberValue + 1
    from Numbers
    where NumberValue < 20
)

select NumberValue
from Numbers

--------------------------------------------------------------------------------
-- Q_14: Display the employee-manager hierarchy using a recursive CTE  

with EmployeeHierarchy as
(
    -- Anchor Member: Top level employees
    select e.BusinessEntityID,
           p.FirstName + ' ' + p.LastName as EmployeeName,
           e.JobTitle,
           e.OrganizationNode,
           0 as level
    from HumanResources.Employee as e
    inner join Person.Person as p
        on e.BusinessEntityID = p.BusinessEntityID
    where e.OrganizationLevel = 0


    union all


    -- Recursive Member: Find employees under each manager
    select e.BusinessEntityID,
           p.FirstName + ' ' + p.LastName as EmployeeName,
           e.JobTitle,
           e.OrganizationNode,
           eh.level + 1
    from HumanResources.Employee as e
    inner join Person.Person as p
        on e.BusinessEntityID = p.BusinessEntityID
    inner join EmployeeHierarchy as eh
        on e.OrganizationNode.GetAncestor(1) = eh.OrganizationNode
)

select BusinessEntityID,
       EmployeeName,
       JobTitle,
       level
from EmployeeHierarchy
order by level, EmployeeName

--------------------------------------------------------------------------------
/** Q_15: Display the organizational hierarchy and show:
          - Employee Name
		  - Manager Name
		  - Level In Hierarchy
		  Sort the output from top level to lowest level.
**/

with EmployeeHierarchy as
(
    -- Anchor Member
    select e.BusinessEntityID,
           CAST(p.FirstName + ' ' + p.LastName AS VARCHAR(200)) as EmployeeName,
           CAST(NULL as varchar(200)) as ManagerName,
           e.OrganizationNode,
           0 as HierarchyLevel
    from HumanResources.Employee as e
    inner join Person.Person as p
        on e.BusinessEntityID = p.BusinessEntityID
    where e.OrganizationLevel = 0


    union all


    -- Recursive Member
    select
           e.BusinessEntityID,
           CAST(p.FirstName + ' ' + p.LastName as varchar(200)) as EmployeeName,
           CAST(eh.EmployeeName as varchar(200)) as ManagerName,
           e.OrganizationNode,
           eh.HierarchyLevel + 1
    from HumanResources.Employee as e
    inner join Person.Person as p
        on e.BusinessEntityID = p.BusinessEntityID
    inner join EmployeeHierarchy as eh
        on e.OrganizationNode.GetAncestor(1) = eh.OrganizationNode
)

select EmployeeName,
       ManagerName,
       HierarchyLevel
from EmployeeHierarchy
order by HierarchyLevel,
         EmployeeName

/*
===================================
>> Bonus Challenges
===================================
*/

-- Bonus_01: Calculate monthly sales and display months whose sales exceed the average monthly sales (Using at least two CTEs.)  

with MonthlySales as
(
    select YEAR(OrderDate) as SalesYear,
           MONTH(OrderDate) as SalesMonth,
           SUM(TotalDue) as MonthlySalesAmount
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate),
             MONTH(OrderDate)
),

AverageMonthlySales as
(
    select AVG(MonthlySalesAmount) as AverageSales
    from MonthlySales
)

select ms.SalesYear,
       ms.SalesMonth,
       ms.MonthlySalesAmount,
       ams.AverageSales
from MonthlySales as ms
cross join AverageMonthlySales as ams
where ms.MonthlySalesAmount > ams.AverageSales
order by ms.SalesYear,
         ms.SalesMonth

--------------------------------------------------------------------------------
-- Bonus_02: Find products whose sales exceed the average sales of products in the same category  

with ProductSales as
(
    select pc.Name as CategoryName,
           p.ProductID,
           p.Name as ProductName,
           SUM(sod.LineTotal) as ProductSalesAmount
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

CategoryAverageSales as
(
    select CategoryName,
           AVG(ProductSalesAmount) as AverageCategorySales
    from ProductSales
    group by CategoryName
)

select ps.CategoryName,
       ps.ProductID,
       ps.ProductName,
       ps.ProductSalesAmount,
       cas.AverageCategorySales
from ProductSales as ps
inner join CategoryAverageSales as cas
    on ps.CategoryName = cas.CategoryName
where ps.ProductSalesAmount > cas.AverageCategorySales
order by ps.CategoryName,
         ps.ProductSalesAmount desc

--------------------------------------------------------------------------------
/** Bonus_03: Build a report showing:
              - CustomerID
			  - Total Orders
			  - Total Sales
			  - Average Order Value
			  using CTEs.
**/

with CustomerReport as
(
    select CustomerID,
           COUNT(SalesOrderID) as TotalOrders,
           SUM(TotalDue) as TotalSales,
           AVG(TotalDue) as AverageOrderValue
    from Sales.SalesOrderHeader
    group by CustomerID
)

select CustomerID,
       TotalOrders,
       TotalSales,
       AverageOrderValue
from CustomerReport
order by TotalSales desc