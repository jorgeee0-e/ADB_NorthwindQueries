SELECT e.FirstName + ' '+ LEFT(e.LastName,1) AS [Nombre Completo], SUM(d.UnitPrice*d.Quantity) AS [Venta Total]
From Employees e
JOIN Orders o ON e.EmployeeID= o.EmployeeID
JOIN [Order Details] d ON o.OrderID= d.OrderID
JOIN Products p ON p.ProductID= d.ProductID
GROUP BY e.FirstName, e.LastName
HAVING SUM(p.UnitPrice * d.Quantity) > 100000
ORDER BY e.FirstName ASC

