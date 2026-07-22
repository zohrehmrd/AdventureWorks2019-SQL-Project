select top (10)
       pp.FirstName + ' ' + pp.LastName as Salesperson,
       SUM(soh.TotalDue) as TotalSales
from Sales.SalesOrderHeader as soh
inner join Sales.SalesPerson as sp
    on soh.SalesPersonID = sp.BusinessEntityID
inner join Person.Person as pp
    on sp.BusinessEntityID = pp.BusinessEntityID
group by
       pp.FirstName,
       pp.LastName
order by
       TotalSales desc