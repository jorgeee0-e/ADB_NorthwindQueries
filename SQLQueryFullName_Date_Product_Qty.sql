SELECT e.FirstName + ' '+ e.LastName AS FullName, o.OrderDate, p.ProductName, d.Quantity
From Employees e
JOIN Orders o ON e.EmployeeID= o.EmployeeID
JOIN [Order Details] d ON o.OrderID= d.OrderID
JOIN Products p ON p.ProductID= d.ProductID
ORDER BY e.FirstName,o.OrderDate, p.ProductName ASC