select top (10)
       soh.CustomerID,
       SUM(soh.TotalDue) as TotalPurchase
from Sales.SalesOrderHeader as soh
group by
       soh.CustomerID
order by
       TotalPurchase desc