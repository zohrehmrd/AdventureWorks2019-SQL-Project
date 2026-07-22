select top (10)
       p.Name as ProductName,
       SUM(sod.LineTotal) as TotalSales
from Sales.SalesOrderDetail as sod
inner join Production.Product as p
    on sod.ProductID = p.ProductID
group by
       p.Name
order by
       TotalSales desc