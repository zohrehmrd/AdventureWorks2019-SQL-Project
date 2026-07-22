
--<< JOIN >>--

/*
=========================================
>> Part1: Left/Right/Inner Join (Q1 - Q20)
=========================================
*/

use AdventureWorks2019

-- Q_01: Display the product name and its subcategory name 

select pp.ProductID,
       pp.Name as ProductName,
       psc.Name as SubCategoryName
from Production.Product as pp
left join Production.ProductSubcategory as psc
   on pp.ProductSubcategoryID = psc.ProductSubcategoryID

--------------------------------------------------------------------------------
-- Q_02: Display the product name and its category name  

select pp.ProductID,
       pp.Name as ProductName,
       pc.Name as CategoryName
from Production.Product as pp
left join Production.ProductSubcategory as psc
   on pp.ProductSubcategoryID = psc.ProductSubcategoryID
left join Production.ProductCategory as pc
   on psc.ProductCategoryID = pc.ProductCategoryID

--------------------------------------------------------------------------------
-- Q_03: Display customer names and their sales order numbers  

select soh.SalesOrderID,
       CONCAT(p.FirstName, ' ', p.LastName) as CustomerName
from Sales.SalesOrderHeader soh
inner join Sales.Customer as sc
    on soh.CustomerID = sc.CustomerID
inner join Person.Person as p
    on sc.PersonID = p.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_04: Display customer names and their order dates  

select 
       CONCAT(p.FirstName, ' ', p.LastName) as CustomerName,
       soh.OrderDate
from Sales.SalesOrderHeader as soh
inner join Sales.Customer as sc
    on soh.CustomerID = sc.CustomerID
inner join Person.Person as p
    on sc.PersonID = p.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_05: Display sales order numbers and their salesperson names   

select soh.SalesOrderNumber,
       CONCAT(p.FirstName, ' ', p.LastName) as SalesPersonName
from Sales.SalesOrderHeader as soh
left join Sales.SalesPerson as sp
   on soh.SalesPersonID = sp.BusinessEntityID
left join Person.Person as p
   on sp.BusinessEntityID = p.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_06: Display employee names and their job titles  

select CONCAT(p.FirstName, ' ', p.LastName) as EmployeeName,
       e.JobTitle
from HumanResources.Employee as e 
inner join person.Person as p
    on p.BusinessEntityID = e.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_07: Display product names and their product model names  

select p.Name as ProductName,
       pm.Name as ModelName
from Production.Product as p
left join Production.ProductModel as pm
   on p.ProductModelID = pm.ProductModelID

--------------------------------------------------------------------------------
-- Q_08: Display product names and their vendor names  

select pp.Name as ProductName,
       v.Name as VendorName
from Production.Product as pp
inner join Purchasing.ProductVendor as pv
    on pp.ProductID = pv.ProductID
inner join Purchasing.Vendor as v
    on pv.BusinessEntityID = v.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_09: Display customer names and their order line items  

select CONCAT(p.FirstName, ' ', p.LastName) as CustomerName,
       sod.SalesOrderID,
       sod.SalesOrderDetailID,
       sod.ProductID,
       sod.OrderQty
from Sales.SalesOrderHeader as soh
inner join Sales.Customer as sc
    on soh.CustomerID = sc.CustomerID
inner join Person.Person as p
    on sc.PersonID = p.BusinessEntityID
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID

--------------------------------------------------------------------------------
-- Q_10: Display product name, quantity sold, and unit price  

select p.Name as ProductName,
       sod.OrderQty,
	   sod.UnitPrice
from Sales.SalesOrderDetail as sod
inner join Production.Product as p
    on sod.ProductID = p.ProductID

--------------------------------------------------------------------------------
-- Q_11: Display all products, even if they do not belong to a subcategory  

select p.ProductID,
       p.Name as ProductName,
	   psc.Name as SubcategoryName
from Production.Product as p
left join Production.ProductSubcategory as psc
   on p.ProductSubcategoryID = psc.ProductSubcategoryID

--------------------------------------------------------------------------------
-- Q_12: Display all subcategories, even if they have no products  

select psc.Name as SubcategoryName,
       p.ProductID,
       p.Name as ProductName
from Production.ProductSubcategory as psc 
left join Production.Product as p
   on p.ProductSubcategoryID = psc.ProductSubcategoryID

--------------------------------------------------------------------------------
-- Q_13: Display all customers, even if they have never placed an order  

select sc.CustomerID,
       soh.SalesOrderID
from Sales.Customer as sc
left join Sales.SalesOrderHeader as soh
   on sc.CustomerID = soh.CustomerID

--------------------------------------------------------------------------------
-- Q_14: Find customers who have never placed an order  

select sc.CustomerID
from Sales.Customer as sc
left join Sales.SalesOrderHeader as soh
   on sc.CustomerID = soh.CustomerID
where soh.SalesOrderID IS NULL

--------------------------------------------------------------------------------
-- Q_15: Display all salespersons, even if they have no sales **/

select sp.BusinessEntityID,
       CONCAT(p.FirstName, ' ', p.LastName) as SalesPersonName
from Sales.SalesPerson as sp
left join Person.Person as p
   on sp.BusinessEntityID = p.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_16: Find salespersons who have never made a sale  

select sp.BusinessEntityID,
       CONCAT(p.FirstName, ' ', p.LastName) as SalesPersonName
from Sales.SalesPerson as sp
left join Sales.SalesOrderHeader as soh
   on sp.BusinessEntityID = soh.SalesPersonID
left join Person.Person as p
   on sp.BusinessEntityID = p.BusinessEntityID
where soh.SalesOrderID is null

--------------------------------------------------------------------------------
-- Q_17: Display all products, even if they have never been sold  

select p.Name as ProductName
from Production.Product as p
left join Sales.SalesOrderDetail as sod
   on p.ProductID = sod.ProductID

--------------------------------------------------------------------------------
-- Q_18: Find products that have never been sold  

select p.Name as ProductName
from Production.Product as p
left join Sales.SalesOrderDetail as sod
   on p.ProductID = sod.ProductID
where sod.ProductID is null

--------------------------------------------------------------------------------
-- Q_19: Display all product categories, even if they contain no products  

select pc.Name as ProductCategory
from Production.ProductCategory as pc
left join Production.ProductSubcategory as psc
   on pc.ProductCategoryID = psc.ProductCategoryID
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID

--------------------------------------------------------------------------------
-- Q_20: Find categories that contain no products  

select pc.Name as ProductCategory
from Production.ProductCategory as pc
left join Production.ProductSubcategory as psc
   on pc.ProductCategoryID = psc.ProductCategoryID
left join Production.Product as p
   on psc.ProductSubcategoryID = p.ProductSubcategoryID
group by pc.ProductCategoryID, pc.Name
having COUNT(p.ProductID) = 0

/*
===================================
>> Part2: Self Join (Q21 - Q25) 
===================================
*/

-- Q_21: Display employees who work in the same department  

select e1.BusinessEntityID as Employee1,
       e2.BusinessEntityID as Employee2,
       e1.DepartmentID
from HumanResources.EmployeeDepartmentHistory as e1
inner join HumanResources.EmployeeDepartmentHistory as e2
    on e1.DepartmentID = e2.DepartmentID
    and e1.BusinessEntityID <> e2.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_22: Display each department and the number of employees working in it  

select m.BusinessEntityID as ManagerID,
       COUNT(e.BusinessEntityID) as NumberOfEmployees
from HumanResources.Employee as e
inner join HumanResources.Employee as m
    on e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
group by m.BusinessEntityID 

--------------------------------------------------------------------------------
-- Q_23: Display pairs of employees working in the same department  

select e1.BusinessEntityID as Employee1,
       e2.BusinessEntityID as Employee2,
       e1.DepartmentID
from HumanResources.EmployeeDepartmentHistory as e1
inner join HumanResources.EmployeeDepartmentHistory as e2
    on e1.DepartmentID = e2.DepartmentID
    and e1.BusinessEntityID < e2.BusinessEntityID
where e1.EndDate IS NULL
    and e2.EndDate IS NULL

--------------------------------------------------------------------------------
-- Q_24: Display products that have the same list price  

select p1.ProductID as Product1ID,
       p1.Name as Product1Name,
       p2.ProductID as Product2ID,
       p2.Name as Product2Name,
       p1.ListPrice
from Production.Product as p1
inner join Production.Product as p2
    on p1.ListPrice = p2.ListPrice
    and p1.ProductID < p2.ProductID

--------------------------------------------------------------------------------
-- Q_25: Display products that have a higher price than other products in the same subcategory  

select p1.ProductID,
       p1.Name as ProductName,
       p1.ProductSubcategoryID,
       p1.ListPrice
from Production.Product as p1
inner join Production.Product as p2
    on p1.ProductSubcategoryID = p2.ProductSubcategoryID
    and p1.ListPrice > p2.ListPrice

--------------------------------------------------------------------------------
-- Part4: Multi-Table Join Challenges (Q26 - Q30)  

/** Q_26: For each order display:
          - Order Number
		  - Customer Name
		  - Product Name
		  - Quantity
		  - Unit Price
**/

select soh.SalesOrderID as OrderNumber,
       p.FirstName + ' ' + p.LastName as CustomerName,
       pr.Name as ProductName,
       sod.OrderQty as Quantity,
       sod.UnitPrice
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID
inner join Production.Product as pr
    on sod.ProductID = pr.ProductID
inner join Sales.Customer as c
    on soh.CustomerID = c.CustomerID
inner join Person.Person as p
    on c.PersonID = p.BusinessEntityID

--------------------------------------------------------------------------------
-- Q_27: Calculate total purchase amount for each customer  

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

--------------------------------------------------------------------------------
-- Q_28: Display the top 10 customers by purchase amount  

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
-- Q_29: Display the top 10 best-selling products by quantity sold  

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
/** Q_30: Create a sales report including:
          - Customer Name
		  - Order Number
		  - Order Date
		  - Product Name
		  - Category Name
		  - Quantity
		  - Unit Price
		  - Line Total
		  Sort the result by sales amount in descending order.
**/

select per.FirstName + ' ' + per.LastName as CustomerName,
       soh.SalesOrderID as OrderNumber,
       soh.OrderDate,
       pr.Name as ProductName,
       pc.Name as CategoryName,
       sod.OrderQty as Quantity,
       sod.UnitPrice,
       sod.LineTotal
from Sales.SalesOrderHeader as soh
inner join Sales.SalesOrderDetail as sod
    on soh.SalesOrderID = sod.SalesOrderID

inner join Production.Product as pr
    on sod.ProductID = pr.ProductID

inner join Production.ProductSubcategory as psc
    on pr.ProductSubcategoryID = psc.ProductSubcategoryID

inner join Production.ProductCategory as pc
    on psc.ProductCategoryID = pc.ProductCategoryID

inner join Sales.Customer as c
    on soh.CustomerID = c.CustomerID

inner join Person.Person as per
    on c.PersonID = per.BusinessEntityID

order by sod.LineTotal desc