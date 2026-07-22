
--<< SUBQUERIES >>--

/*
======================================
>> Part1: Basic Subqueries (Q1 - Q10)
======================================
*/

-- Q_01: Display products whose price is greater than the average price of all products

select ProductID,
       Name as ProductName,
	   ListPrice
from Production.Product
where ListPrice > (select AVG(ListPrice) from Production.Product)

--------------------------------------------------------------------------------
-- Q_02: Display the most expensive product

select ProductID,
       Name as ProductName,
	   ListPrice
from Production.Product
where ListPrice =
(
      select MAX(ListPrice)
	  from Production.Product
)

--------------------------------------------------------------------------------
-- Q_03: Display the cheapest product 

select ProductID,
       Name as ProductName,
	   ListPrice
from Production.Product
where ListPrice =
(
      select MIN(ListPrice)
	  from Production.Product
)

--------------------------------------------------------------------------------
-- Q_04: Display products whose price equals the highest price 

select ProductID,
       Name as ProductName,
	   ListPrice
from Production.Product
where ListPrice =
(
      select MAX(ListPrice)
	  from Production.Product
)

--------------------------------------------------------------------------------
-- Q_05: Display products whose weight is greater than the average product weight 

select ProductID,
       Name as ProductName,
	   Weight
from Production.Product
where Weight >
(
     select AVG(Weight)
	 from Production.Product 
)

--------------------------------------------------------------------------------
-- Q_06: Display customers who placed more orders than the average customer 

select CustomerID,
       COUNT(SalesOrderID) as NumberOfOrders
from Sales.SalesOrderHeader
group by CustomerID
having COUNT(SalesOrderID) >
(
    select AVG(OrderCount)
    from
    (
        select COUNT(*) as OrderCount
        from Sales.SalesOrderHeader
        group by CustomerID
    ) as t
)

--------------------------------------------------------------------------------
-- Q_07: Display products that belong to the Bikes category using a subquery 

select ProductID,
       Name as ProductName
from Production.Product
where ProductSubcategoryID in 
(
      select ProductSubcategoryID
	  from Production.ProductSubcategory
	  where ProductCategoryID =
      (
      select ProductCategoryID
      from Production.ProductCategory
	  where Name = 'Bikes'
	  )
)

--------------------------------------------------------------------------------
-- Q_08: Display orders whose total amount is greater than the average order amount 

select SalesOrderID,
       CustomerID,
       TotalDue
from Sales.SalesOrderHeader
where TotalDue >
(
    select AVG(TotalDue)
    from Sales.SalesOrderHeader
)

--------------------------------------------------------------------------------
-- Q_09: Display employees whose vacation hours are above average 

select e.BusinessEntityID,
       CONCAT(p.FirstName, ' ', p.LastName) as EmployeeName,
       e.VacationHours
from HumanResources.Employee as e
inner join Person.Person as p
on e.BusinessEntityID = p.BusinessEntityID
where VacationHours > 
(
      select AVG(VacationHours)
      from HumanResources.Employee
)

--------------------------------------------------------------------------------
-- Q_10: Display products whose price is greater than the minimum price of red products 

select ProductID,
       Name as ProductName,
	   ListPrice
from Production.Product
where ListPrice >
(
      select MIN(ListPrice)
      from Production.Product
      where Color = 'Red'
)

/*
==========================================
>> Part2: Correlated Subqueries (Q11 - Q15)
==========================================
*/

-- Q_11: For each product, determine whether its price is greater than the average price of products with the same color

select p1.ProductID,
       p1.Name as ProductName,
       p1.Color,
       p1.ListPrice
from Production.Product as p1
where p1.ListPrice >
(
      select AVG(p2.ListPrice)
	  from Production.Product as p2
	  where p1.Color = p2.Color
)

--------------------------------------------------------------------------------
-- Q_12: Display products that are the most expensive within their color group

select p1.ProductID,
       p1.Name as ProductName,
       p1.Color,
       p1.ListPrice
from Production.Product as p1
where p1.ListPrice =
(
    select MAX(p2.ListPrice)
    from Production.Product as p2
    where p2.Color = p1.Color
)

--------------------------------------------------------------------------------
-- Q_13: Display the latest order for each customer

select soh1.SalesOrderID,
       soh1.OrderDate
from Sales.SalesOrderHeader as soh1
where soh1.OrderDate = 
(
      select MAX(soh2.OrderDate)
	  from Sales.SalesOrderHeader as soh2
	  where soh2.CustomerID = soh1.CustomerID
)

--------------------------------------------------------------------------------
-- Q_14: Display products whose price is above the average price of their subcategory

select p1.ProductID,
       p1.Name as ProductName,
	   p1.ProductSubcategoryID,
	   p1.ListPrice
from Production.Product as p1
where p1.ListPrice >
(
      select AVG(p2.ListPrice)
	  from Production.Product as p2
	  where p2.ProductSubcategoryID = p1.ProductSubcategoryID
)

--------------------------------------------------------------------------------
-- Q_15: Display employees whose vacation hours are above the average of their department

select e1.BusinessEntityID,
       e1.VacationHours
from HumanResources.Employee as e1
inner join HumanResources.EmployeeDepartmentHistory as edh1
on e1.BusinessEntityID = edh1.BusinessEntityID
where e1.VacationHours >
(
      select AVG(e2.VacationHours)
	  from HumanResources.Employee as e2
      inner join HumanResources.EmployeeDepartmentHistory as edh2
      on e2.BusinessEntityID = edh2.BusinessEntityID
	  where edh2.DepartmentID = edh1.DepartmentID
)
and edh1.EndDate is Null

/*
======================================
>> Part3: Exists/Not Exists (Q16 - Q20)
======================================
*/

-- Q_16: Display customers who have placed at least one order using EXISTS

select c.CustomerID
from Sales.Customer as c
where EXISTS 
(
      select soh.CustomerID
	  from Sales.SalesOrderHeader as soh
	  where soh.CustomerID = c.CustomerID
)

--------------------------------------------------------------------------------
-- Q_17: Display customers who have never placed an order using NOT EXISTS 

select c.CustomerID
from Sales.Customer as c
where NOT EXISTS 
(
      select soh.CustomerID
	  from Sales.SalesOrderHeader as soh
	  where soh.CustomerID = c.CustomerID
)

--------------------------------------------------------------------------------
-- Q_18: Display products that have been sold at least once

select p.ProductID,
       p.Name as ProductName
from Production.Product as p
where EXISTS 
(  
      select *
	  from Sales.SalesOrderDetail as sod
	  where sod.ProductID = p.ProductID
)

--------------------------------------------------------------------------------
-- Q_19: Display products that have never been sold 

select p.ProductID,
       p.Name as ProductName
from Production.Product as p
where NOT EXISTS 
(  
      select *
	  from Sales.SalesOrderDetail as sod
	  where sod.ProductID = p.ProductID
)

--------------------------------------------------------------------------------
/** Q_20: Display products that:
          - Have been sold at least once
		  - Have a price greater than the average product price
		  - Belong to the Bikes category
		  Implement all conditions using a combination of:
		  - Subqueries
		  - EXISTS
**/

select p.ProductID,
       p.Name as ProductName,
       p.ListPrice
from Production.Product as p
where exists
    (
        select sod.ProductID
        FROM Sales.SalesOrderDetail sod
        WHERE sod.ProductID = p.ProductID
    )

     and p.ListPrice >
    (
        select AVG(ListPrice)
        from Production.Product
    )

     and p.ProductSubcategoryID in
    (
        select ProductSubcategoryID
        from Production.ProductSubcategory
        where ProductCategoryID =
        (
              select ProductCategoryID
              from Production.ProductCategory
              where Name = 'Bikes'
        )
    )

/*
===================================
>> Bonus Challenges
===================================
*/

-- Bonus_01: Find customers whose total purchase amount is above the average customer purchase amount

select CustomerID,
       SUM(TotalDue) as TotalPurchase
from Sales.SalesOrderHeader
group by CustomerID
having SUM(TotalDue) >
(
    select AVG(TotalPurchase)
    from
    (
        select SUM(TotalDue) as TotalPurchase
        from Sales.SalesOrderHeader
        group by CustomerID
    ) as t
)

--------------------------------------------------------------------------------
-- Bonus_02: Find products that fall within the top 10% of prices without using Window Functions

select ProductID,
       Name as ProductName,
       ListPrice
from Production.Product
where ListPrice >=
(
    select MIN(ListPrice)
    from
    (
        select top 10 percent ListPrice
        from Production.Product
        order by ListPrice desc
    ) as t
)

--------------------------------------------------------------------------------
-- Bonus_03: Display the most expensive product in each category using only a correlated subquery

select p1.ProductID,
       p1.Name as ProductName,
       pc1.Name as CategoryName,
       p1.ListPrice
from Production.Product as p1
inner join Production.ProductSubcategory as psc1
    on p1.ProductSubcategoryID = psc1.ProductSubcategoryID
inner join Production.ProductCategory as pc1
    on psc1.ProductCategoryID = pc1.ProductCategoryID
where p1.ListPrice =
(
    select MAX(p2.ListPrice)
    from Production.Product as p2
    inner join Production.ProductSubcategory as psc2
        on p2.ProductSubcategoryID = psc2.ProductSubcategoryID
    where psc2.ProductCategoryID = psc1.ProductCategoryID
)





