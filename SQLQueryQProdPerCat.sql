SELECT c.CategoryName,COUNT(p.CategoryID) AS 'Numero de productos'
FROM Categories c
JOIN Products p ON c.CategoryID=p.CategoryID
GROUP BY C.CategoryName;
