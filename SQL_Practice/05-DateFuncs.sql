
--<< DATE FUNCTIONS >>--

/*
===================================
>> Part 1: YEAR / MONTH / DAY 
===================================
*/

use AdventureWorks2019

-- Q_01: Display all orders placed in 2013  

select *
from Sales.SalesOrderHeader
where Year(OrderDate) = 2013

--------------------------------------------------------------------------------
-- Q_02: Display all orders placed in June  

select *
from Sales.SalesOrderHeader
where MONTH(OrderDate) = 6

--------------------------------------------------------------------------------
-- Q_03: Display the number of orders placed in each year  

select YEAR (OrderDate) as OrderYear,
       COUNT(*) as TotalOrders
from Sales.SalesOrderHeader
group by YEAR (OrderDate)

--------------------------------------------------------------------------------
-- Q_04: Display the number of orders placed in each month of 2013  

select MONTH (OrderDate) as OrderMonth,
       COUNT(*) as TotalOrders
from Sales.SalesOrderHeader
where  YEAR (OrderDate) = 2013
group by MONTH (OrderDate)

/*
===================================
>> Part 2: DATEADD 
===================================
*/

-- Q_05: Display the order date and the date 30 days after the order date  

select OrderDate,
       DATEADD (day, 30, OrderDate) as DateAfter30Days
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_06: Display the order date and the date one year after the order date  

select OrderDate,
       DATEADD (year, 1, OrderDate) as DateAfter1Year
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_07: Display orders along with a date that is 7 days after the order date  

select OrderDate,
       DATEADD(day, 7, OrderDate) as DateAfter7Days
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_08: Display a date that is 3 months before each order date  

select OrderDate,
       DATEADD(Month, -3, OrderDate) as Date3MonthsBefore
from Sales.SalesOrderHeader

/*
===================================
>> Part 3: DATEDIFF 
===================================
*/

-- Q_09: Display the number of days between OrderDate and ShipDate  

select OrderDate,
       ShipDate,
	   DATEDIFF(day, OrderDate, ShipDate) as ShippingDays
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_10: Display orders that took more than 10 days to ship  

select SalesOrderID
from Sales.SalesOrderHeader
where DATEDIFF(day, OrderDate, ShipDate) > 10

--------------------------------------------------------------------------------
-- Q_11: Calculate the average shipping duration in days  

select Avg(DATEDIFF(day, OrderDate, ShipDate)) as AvgShippingDays
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_12: Find the order with the longest shipping duration  

select top 1
       SalesOrderID,
       OrderDate,
       ShipDate,
       DATEDIFF(day, OrderDate, ShipDate) as ShippingDays
from Sales.SalesOrderHeader
where ShipDate IS NOT NULL
order by ShippingDays desc

/*
===================================
>> Part 4: DATENAME 
===================================
*/

-- Q_13: Display the weekday name of each order  

select SalesOrderID,
       DATENAME(weekday, OrderDate) as WeekDay
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_14: Display the number of orders by weekday name  

select DATENAME(weekday, OrderDate) as WeekDay,
       COUNT(*) as TotalOrders
from Sales.SalesOrderHeader
group by DATENAME(weekday, OrderDate) 

--------------------------------------------------------------------------------
-- Q_15: Display all orders placed on Monday  

select  SalesOrderID,
        OrderDate
from Sales.SalesOrderHeader
where DATENAME(weekday, OrderDate) = 'Monday'

--------------------------------------------------------------------------------
-- Q_16: Display the month name of each order  

select SalesOrderID,
       DATENAME(month, orderdate) as OrderMonth
from Sales.SalesOrderHeader

/*
===================================
>> Part 5: CAST 
===================================
*/

-- Q_17: Display the order date as a DATE only  

select CAST(OrderDate as date) as OrderDate
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_18: Convert product prices to INT  

select ListPrice,
       CAST(ListPrice as int) as PriceAsInt
from Production.Product

--------------------------------------------------------------------------------
-- Q_19: Convert the order date to VARCHAR  

select OrderDate,
       CAST(OrderDate as varchar(20)) as OrderDateText
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_20: Convert shipping days to VARCHAR  

select ShipDate,
       CAST(DATEDIFF(day, OrderDate, ShipDate) as varchar(20)) as ShippingDaysText
from Sales.SalesOrderHeader

/*
===================================
>> Part 6: CONVERT 
===================================
*/

-- Q_21: Display the order date in yyyy-mm-dd format 

select OrderDate,
       CONVERT(varchar(10), OrderDate, 23) as FormattedDate
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_22: Display the order date in dd/mm/yyyy format  

select OrderDate,
       CONVERT(varchar(10), OrderDate, 103) as FormattedDate
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_23: Display the order date in Mon dd, yyyy format  

select
    OrderDate,
    LEFT(DATENAME(month, OrderDate), 3) + ' ' +
    CAST(DAY(OrderDate) as VARCHAR) + ', ' +
    CAST(YEAR(OrderDate) as VARCHAR) as FormattedDate
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_24: Display the order date and time in yyyy-mm-dd hh:mm:ss format  

select
    OrderDate,
    CONVERT(VARCHAR(19), OrderDate, 120) as FormattedDateTime
from Sales.SalesOrderHeader

/*
===================================
>> Part 7: GitHub Challenges 
===================================
*/

-- Q_25: Display the number of orders per month along with the month name  

select
    DATENAME(month, OrderDate) as MonthName,
    COUNT(*) as TotalOrders
from Sales.SalesOrderHeader
group by
    DATENAME(month, OrderDate),
    MONTH(OrderDate)
order by
    MONTH(OrderDate)

--------------------------------------------------------------------------------
-- Q_26: Display all orders placed on weekends  

select OrderDate,
       DATENAME(weekday, OrderDate)
from Sales.SalesOrderHeader
where DATENAME(weekday, OrderDate) in ('Saturday', 'Sunday')

--------------------------------------------------------------------------------
-- Q_27: Display orders shipped within 8 days  

select *
from Sales.SalesOrderHeader
where ShipDate <= DATEADD(day, 8, OrderDate)

--------------------------------------------------------------------------------
-- Q_28: Display the oldest and newest order dates  

select MIN(OrderDate) as OldestOrderDate,
       MAX(OrderDate) as NewestOrderDate
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_29: Calculate the number of days since each order until today  

select OrderDate,
       DATEDIFF(day, OrderDate, GETDATE()) as DaysSinceOrder
from Sales.SalesOrderHeader

--------------------------------------------------------------------------------
-- Q_30: Display the number of years since each order date until today 

select OrderDate,
       DATEDIFF(year, OrderDate, GETDATE()) as YearsSinceOrder
from Sales.SalesOrderHeader