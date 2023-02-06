CREATE DATABASE SQL_VERY_ADVANCE

--Use Adv_casestudy

 --1. List all customers

SELECT * FROM Customer

--2. List the first name, last name, and city of all customers

SELECT FirstName,LastName,City FROM CUSTOMER

--3. List the customers in Sweden. Remember it is "Sweden" and NOT "sweden" because filtering value is case sensitive in Redshift.

Select * from Customer
where Country = 'Sweden'

--4. Create a copy of Supplier table. Update the city to Sydney for supplier starting with letter P.

SELECT Id,CompanyName,ContactName,Country,Phone,Fax,
	CASE
		WHEN City LIKE 'P%' THEN 'Sydney' 
		ELSE City  
	END [City] INTO Copy_of_supplier
FROM Supplier

-- Changing the datatype of unitprice column of product table

 alter table product 
 alter column UnitPrice decimal

--5. Create a copy of Products table and Delete all products with unit price higher than $50.

select * into Copy_of_Products
from Product
where UnitPrice <= 50

--6. List the number of customers in each country

select Country,count(Id)[No Of Customers] 
from customer
group by Country

--7. List the number of customers in each country sorted high to low

select Country,count(Id)[No Of Customers] 
from customer
group by Country
order by [No Of Customers] desc

-- Changing the datatype of CustomerId column of Orders table

alter table Orders
 alter column Customerid int

 -- Changing the datatype of TotalAmount column of Orders table


 alter table Orders
 alter column TotalAmount decimal

--8. List the total amount for items ordered by each customer

select CustomerId,sum(TotalAmount) [Total Amount]
from Orders 
group by CustomerId

--9. List the number of customers in each country. Only include countries with more than 10 customers.

select Country,count(Id)[No Of Customers] 
from customer
group by Country
having count(Id) > 10

--10. List the number of customers in each country, except the USA, sorted high to low. Only include countries with 9 or more customers.

select Country,count(Id)[No Of Customers] 
from customer
where Country != 'USA'
group by Country
having count(Id) >= 9
order by [No Of Customers] desc

-- 11. List all customers whose first name or last name contains "ill". 

SELECT * FROM Customer
where FirstName like '%ill%' or LastName like '%ill%'

-- 12. List all customers whose average of their total order amount is between $1000 and $1200.Limit your output to 5 results.

SELECT top 5 CustomerId, avg(TotalAmount) [Average Spend] 
from Orders 
GROUP by CustomerId
HAVING AVG(TotalAmount) BETWEEN 1000 and 1200

-- 13. List all suppliers in the 'USA', 'Japan', and 'Germany', ordered by country from A-Z, and then by company name in reverse order.

select * from Supplier
where Country in ('USA','Japan','Germany')
order by Country asc,CompanyName desc

-- 14. Show all orders, sorted by total amount (the largest amount first), within each year.

select *,YEAR(OrderDate) [Year] 
from Orders
order by [Year], TotalAmount desc

-- 15. Products with UnitPrice greater than 50 are not selling despite promotions. You are asked to 
-- discontinue products over $25. Write a query to relfelct this. Do this in the copy of the Product 
-- table. DO NOT perform the update operation in the Product table.

Delete from copy_of_Products
where UnitPrice > 25

-- 16. List top 10 most expensive products

SELECT top 10 * 
from Product
order by UnitPrice desc

-- 17. Get all but the 10 most expensive products sorted by price

SELECT * from Product
order by UnitPrice desc
OFFSET 10 ROWS

-- 18. Get the 10th to 15th most expensive products sorted by price

SELECT * from Product
order by UnitPrice desc
OFFSET 9 ROWS
fetch next 6 ROWS only

-- 19. Write a query to get the number of supplier countries. Do not count duplicate values.

SELECT COUNT(distinct Country) from Supplier [Count of unique countries]

-- 20. Find the total sales cost in each month of the year 2013.

select MONTH(OrderDate) [Month] ,sum(TotalAmount) [Total Sales] from Orders o
where YEAR(OrderDate) = 2013
GROUP by MONTH(OrderDate)

--21. List all products with names that start with 'Ca'.

select * from product
where ProductName like 'Ca%'

--22. List all products that start with 'Cha' or 'Chan' and have one more character.

select * from product
where ProductName like 'Cha_' or ProductName like 'Chan_'

--23. Your manager notices there are some suppliers without fax numbers. He seeks your help to 
--get a list of suppliers with remark as "No fax number" for suppliers who do not have fax 
--numbers (fax numbers might be null or blank).Also, Fax number should be displayed for customer with fax numbers.

select Id,CompanyName,ContactName,ContactTitle,City,Country,Phone,
	case
		when len(Fax) ='' or Fax IS NULL then 'No Fax Number'
		else Fax
	end [Fax]
from Supplier

--24. List all orders, their orderDates with product names, quantities, and prices.

select * 
from Orders a left join OrderItem b on	a.id = b.orderid left join Product c on b.ProductId = c.Id

--25. List all customers who have not placed any Orders.

select * from Customer
where Customer.Id not in ( select CustomerId from Orders )

--26. List suppliers that have no customers in their country, and customers that have no suppliers 
--in their country, and customers and suppliers that are from the same country. 
--Hint: See sample output for your reference.

 select c.FirstName , c.LastName , c.Country 'CustomerCountry' , s.Country'SupplierCountry' , s.ContactName 
    from Customer c full outer join Supplier s 
         on c.Country = s.Country

--27. Match customers that are from the same city and country. That is you are asked to give a list 
--of customers that are from same country and city. Display firstname, lastname, city and 
--coutntry of such customers. 
--Hint See sample output for your reference.AnalytixLabs, Website: www.analytixlabs.co.in Email: info@analytixlabs.co.in phone: +91-88021-73069

select  T1.FirstName 'FirstName1',T1.LastName'LastName1',T2.FirstName'FirstName2',T2.LastName'LastName2', T1.City,T1.Country from Customer T1 inner join Customer T2
	on T1.City = T2.City and T1.Country = T2.Country
 	Order by Country,City

--28. List all Suppliers and Customers. Give a Label in a separate column as 'Suppliers' if he is a 
--supplier and 'Customer' if he is a customer accordingly. Also, do not display firstname and 
--lastname as twoi fields; Display Full name of customer or supplier. 
--Hint: See sample output for your reference.
 
Select 'Customer'[Type],CONCAT(FirstName,' ' ,LastName) 'ContactName' ,City ,Country,Phone
from  Customer 
Union  
Select 'Supplier'[Type],ContactName,City,Country,Phone from Supplier

--29. Create a copy of orders table. In this copy table, now add a column city of type varchar (40). 
--Update this city column using the city info in customers table.

SELECT o.*,c.City into copy_of_orders
from Orders o LEFT JOIN Customer c on o.CustomerId = c.Id

ALTER TABLE copy_of_orders
ALTER COLUMN City VARCHAR(40)

--30. Suppose you would like to see the last OrderID and the OrderDate for this last order that 
--was shipped to 'Paris'. Along with that information, say you would also like to see the 
--OrderDate for the last order shipped regardless of the Shipping City. In addition to this, you 
--would also like to calculate the difference in days between these two OrderDates that you get. Write a single query which performs this.
--(Hint: make use of max (columnname) function to get the last order date and the output is a single row output.)

SELECT * , DATEDIFF(DAY,t1.[Overall Paris Order],t1.[Overall Last Order]) [Difference]
FROM (SELECT (SELECT MAX(OrderDate) from copy_of_orders) [Overall Last Order],(SELECT MAX(OrderDate) from copy_of_orders WHERE City = 'Paris') [Overall Paris Order] ) t1

-- 31. Find those customer countries who do not have suppliers. This might help you provide 
-- better delivery time to customers by adding suppliers to these countires. Use SubQueries.

SELECT distinct Country FROM Customer
where Country not in (SELECT distinct Country FROM Supplier)

-- 32. Suppose a company would like to do some targeted marketing where it would contact 
-- customers in the country with the fewest number of orders. It is hoped that this targeted 
-- marketing will increase the overall sales in the targeted country. You are asked to write a query 
-- to get all details of such customers from top 5 countries with fewest numbers of orders. Use 
-- Subqueries.

SELECT * from Customer
where Country in (select top 5 Country from orders o LEFT JOIN Customer c on o.CustomerId= c.Id GROUP by Country Order by count(o.Id)) 

-- 33. Let's say you want report of all distinct "OrderIDs" where the customer did not purchase 
-- more than 10% of the average quantity sold for a given product. This way you could review 
-- these orders, and possibly contact the customers, to help determine if there was a reason for 
-- the low quantity order. Write a query to report such orderIDs.

SELECT Distinct o.OrderId
from OrderItem o LEFT JOIN (select ProductId, AVG( CAST(Quantity as float) )[Average Qty for Prod] from OrderItem GROUP BY ProductId) q1 on o.ProductId = q1.ProductId
WHERE o.Quantity  < q1.[Average Qty for Prod] * 1.1

-- 34. Find Customers whose total orderitem amount is greater than 7500$ for the year 2013. The 
-- total order item amount for 1 order for a customer is calculated using the formula UnitPrice * 
-- Quantity * (1 - Discount). DO NOT consider the total amount column from 'Order' table to 
-- calculate the total orderItem for a customer.

SELECT CustomerId, SUM(UnitPrice * Quantity * (1- Discount))[Calc Total Order Amount ]
from Orders a inner JOIN OrderItem b on a.Id = b.OrderId
where YEAR(OrderDate) = 2013 
GROUP BY CustomerId
HAVING SUM(UnitPrice * Quantity * (1- Discount)) > 7500

-- 35. Display the top two customers, based on the total dollar amount associated with their 
-- orders, per country. The dollar amount is calculated as OI.unitprice * OI.Quantity * (1 -
-- OI.Discount). You might want to perform a query like this so you can reward these customers, 
-- since they buy the most per country. 
-- Please note: if you receive the error message for this question "This type of correlated subquery 
-- pattern is not supported yet", that is totally fine.
-- Sample output is as below for your response
select *
from	(select Country,CustomerId,SUM(TotalAmount) [Dollar Amount], RANK() OVER(PARTITION by Country ORDER by Country, SUM(TotalAmount) DESC ) [Country rank]
		from Orders o inner join Customer c on  o.customerid = c.id
		group by Country,CustomerId) t1
WHERE [Country Rank] <=2
ORDER by Country

-- 36. Create a View of Products whose unit price is above average Price.

CREATE VIEW [test1]
as  (select * from Product where UnitPrice > (select AVG(UnitPrice) from Product))

-- 37. Write a store procedure that performs the following action:
-- Check if Product_copy table (this is a copy of Product table) is present. If table exists, the 
-- procedure should drop this table first and recreated.
-- Add a column Supplier_name in this copy table. Update this column with that of 
-- 'CompanyName' column from Supplier ta

CREATE PROCEDURE q37 as 
	if 'copy_of_products' IN (select TABLE_NAME from  INFORMATION_SCHEMA.TABLES)
	begin 
		drop TABLE copy_of_products
		select p.*,s.Country into copy_of_Products 
		from Product p LEFT JOIN Supplier s on p.SupplierId = s.Id 
	END

EXEC q37

