select
    SUM(TotalDue) as TotalRevenue,
    COUNT(SalesOrderID) as TotalOrders,
    COUNT(DISTINCT CustomerID) as TotalCustomers,
    AVG(TotalDue) as AverageOrderValue
from Sales.SalesOrderHeader