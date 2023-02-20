-- Aufgaben

-- Aufgaben
-- https://www.w3schools.com/sql/trysql.asp?filename=trysql_select_join
/*
SELECT Orders.OrderID, Orders.OrderDate, Customers.CustomerName, OrderDetails.ProductID FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
INNER JOIN OrderDetails
ON Orders.OrderID = OrderDetails.OrderID
*/
-- Aufgabe Alexander
-- Zeigen Sie von der Tabelle Orders die OrderID und das Bestelldatum an, Zeigen Sie Zusätzlich noch den CustomerName an.
-- Lösung:
/*
SELECT Orders.OrderID, Orders.OrderDate, Customers.CustomerName FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
*/

--Raphael
/*
SELECT Orders.ShipperID, Shippers.ShipperName, Shippers.Phone
FROM Orders
INNER JOIN Shippers
ON (Orders.ShipperID = Shippers.ShipperID)
*/

-- Linus
/*
SELECT Orders.OrderID, Customers.CustomerName, Orders.ShipperID, Customers.Country FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
*/

-- Sasa
/*
SELECT ProductID, ProductName, Suppliers.SupplierName, Categories.CategoryName FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
*/

-- Simon
/*
SELECT Orders.OrderID, Orders.OrderDate, OrderDetails.Quantity FROM Orders
INNER JOIN OrderDetails
ON Orders.OrderID = OrderDetails.OrderID
ORDER BY OrderDetails.Quantity DESC
*/

--Lenny
/*
SELECT CustomerName, Country FROM Customers
WHERE Country = 'Germany'
*/

-- Leon
/*
SELECT Orders.OrderID, Customers.CustomerName, Products.ProductName FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
INNER JOIN OrderDetails
ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products
ON OrderDetails.ProductID = Products.ProductID
*/

-- David
/*
SELECT OrderID, Customers.CustomerName FROM Orders 
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.CustomerName NOT like '%C%'
ORDER BY CustomerName ASC
*/

-- Senthooran
/*
SELECT OrderID, Shippers.ShipperName
FROM Orders
INNER JOIN Shippers
ON Orders.ShipperID = Shippers.ShipperID
ORDER BY OrderID
*/