select
    YEAR(OrderDate) as SalesYear,
    MONTH(OrderDate) as SalesMonth,
    SUM(TotalDue) as MonthlyRevenue
from Sales.SalesOrderHeader
group by
    YEAR(OrderDate),
    MONTH(OrderDate)
order by
    SalesYear,
    SalesMonth