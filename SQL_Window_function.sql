
-- WINDOW FUNCTION

-- Find the total sales across all orders

USE SalesDB;

SELECT
	SUM(Sales) AS TotalSales
FROM Sales.Orders;

-- Find the total sales for each product

SELECT
	ProductID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY productID;

-- Find the total sales for each product
-- additionally provide details such as order id and order date

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

-- Find the total sales across all orders
-- Additionally provide details such as order id , order date.

SELECT
	OrderID,
	OrderDate,
 SUM(Sales) Over () totalSales
From Sales.Orders;

-- Find the total sales for each product
-- Additionally provide details such as order id , order date.

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSumByProductID
FROM Sales.Orders

-- Find the total sales across all orders
-- Find the total sales for each product
-- Additionally provide details such as order id , order date.

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProductID
FROM Sales.Orders

-- Find the total sales for each combination of products and order status
--OR
-- Find the total sales across all orders
-- Find the total sales for each product
-- Find the total sales for each combination of product and other status
-- Additionally provide details such as order id , order date

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) salesbyorderstatus,
	SUM(Sales) OVER (PARTITION BY ProductID) salebyproductid
FROM Sales.Orders;

-- Rank Each order based on their sales from highest to lowest
-- Additionally provide details such as Order ID, Order Date

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders;

--EXAMPLE for FRAME

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders;

--Find the total Sales for each orders status, only for two products 101 and 102

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN(101, 102);

--Rank the Customers Based on their total Sales

SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER (ORDER BY SUM(Sales) DESC) RankCustomers 
FROM Sales.Orders
GROUP BY CustomerID


-- Find the total Numbers of orders

SELECT
	COUNT(*) Totalorders
FROM Sales.Orders

-- Find the total Numbers of orders
-- Additionally provide details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalOrders
FROM Sales.Orders;

-- Find the total Numbers of orders
-- Find the total Number of orders for each customer
-- Additionally provide details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(OrderID) OVER (PARTITION BY CustomerID) OrdersByCustomer
FROM Sales.Orders;

-- Find the total number of Customers
-- Additionally provide all customers details

SELECT
	*,
	COUNT(CustomerID) OVER() TotalCustomers
FROM Sales.Customers;

-- Find the total number of Customers
-- Find the total number of score for the customers
-- Additionally provide all customers details

SELECT
	*,
	COUNT(CustomerID) OVER() TotalCustomers,
	Count(Score) OVER () TotalScore
FROM Sales.Customers;

-- Find the total number of Customers
-- Find the total number of score for the customers
-- Find the total number of Countries
-- Additionally provide all customers details

SELECT
	*,
	COUNT(CustomerID) OVER() TotalCustomers,
	Count(Score) OVER () TotalScore,
	COUNT(Country) OVER() TotalCountry
FROM Sales.Customers;

-- Check whether the table 'order' contains any Duplicate rows
/* ANS : for checking duplicate in any table, first we should what is the primary key in that table,
	then count it with the help of window function,
	IF there is more than 1 primary key is there that means that is a duplicate value */

SELECT
	orderID,
	COUNT(*) OVER (PARTITION BY OrderID) CheckPrimaryKey
FROM Sales.Orders

-- Check whether the table 'orderArchive' contains any Duplicate rows

SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
FROM Sales.OrdersArchive

-- Check whether the table 'orderArchive' contains any Duplicate rows and find them all

SELECT
	*
FROM (
SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
FROM Sales.OrdersArchive
)t WHERE CheckPK > 1

-- Find the total sales across all orders
-- Find the total sales for each product
-- Additionally provide details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProduct
FROM Sales.Orders

--Find the Percentage Contribution of each product's sales to the total sales

SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	ROUND (CAST (Sales AS FLOAT) / SUM(Sales) OVER () * 100, 2) PercentageOfTotalSales
FROM Sales.Orders


-- Find the Average Sales across all orders and the average sales for each product
-- Additionally provide details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY ProductID) TootalSalesByProduct,
	AVG(Sales) OVER () AvgSales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders

-- Find the Average score of Customers
-- Additionally provide details such as CustomerID and lastName
-- ANS :- NOTES : We use COALESCE to replace NULL with value zero

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score, 0) CustomerScore,
	AVG(Score) OVER () AvgScoreWithNull,
	AVG(COALESCE(Score, 0)) OVER () AvgScoreWithOutNull
FROM Sales.Customers

-- Question Based on Compare to Average
-- Find all orders where sales are higher than the average sales across all orders
-- Additionally provide details such as OrderID and ProductID, Sales

SELECT
	*
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER () AvgSales
	FROM Sales.Orders
)t
WHERE Sales > AvgSales

-- Question based on Range
-- Find the Highest and Lowest sales of all orders
-- Find the Highest and Lowesr sales for each orders
-- Additionally provide details such as OrderID and OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER () HighestSales,
	MIN(Sales) OVER () LowestSales,
	MAX(Sales) OVER (PARTITION BY ProductID) HighestSalesByProduct,
	MIN(Sales) OVER (PARTITION BY ProductID) LowestSalesByProduct
FROM Sales.Orders

-- Question Based ON - Filer the Data Using MIN and MAX function
-- Show the employees who has the highest Salaries

SELECT
	*
FROM (
	SELECT
		*,
		MAX(Salary) OVER () HighestSalary
	FROM Sales.Employees
)t
WHERE Salary = HighestSalary

-- Question Based on, How to find the EXTREMES in our date, means how far the date from min and max
-- Calculate the deviation of each sale from both the minimum and maximum sales amount

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER () HighestSals,
	MIN(Sales) OVER () LowestSales,
	Sales - MAX(Sales) OVER () DeviationFromMin,
	MAX(Sales) OVER () - Sales DeviationFromMax
FROM Sales.Orders


-- Topic : RUNNING TOTAL and ROLLING TOTAL

-- Question
-- Calculate the MOVING AVERAGE of sales for each product over time

-- Explanation : We can see that for every product id , their average is growing, 
-- as it starts from 10 and then 15 because when we add 10 + 20, its 30 and their average will be 15 and it will go on and on till the last of the product

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAverage
FROM Sales.Orders 

-- Calculate the moving average of sales for each product over time, including only the next order

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAverage,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders

-- Rank the orders based on their sales from highest to lowest (Using ROW_NUMBER)

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row_Number
FROM Sales.Orders

-- Rank the orders based on their sales from highest to lowest (Using RANK)

SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders

-- Rank the orders based on their sales from highest to lowest (Using DENSE_RANK)

SELECT
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_Dense_Rank
FROM Sales.Orders

-- ALL IN ONE
-- Rank the orders based on their sales from highest to lowest (Using ROW_NUMBER)
-- Rank the orders based on their sales from highest to lowest (Using RANK)
-- Rank the orders based on their sales from highest to lowest (Using DENSE_RANK)

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row_Number,
	RANK() OVER (ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_Dense_Rank
FROM Sales.Orders


--Find the top highest sales for each product

SELECT
	*
FROM
	(
	SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
	FROM Sales.Orders
	)t
WHERE RankByProduct = 1;


--Find the Lowest 2 Customers based on their total Sales

SELECT
	*
FROM
	(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
	)t
WHERE RankCustomers <= 2

-- Assign unique IDs to the rows of the 'Orders Archive' Table

SELECT
	ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive
