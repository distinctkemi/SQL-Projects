/****** Script for SelectTopNRows command from SSMS  ******/
--Cleansed Dim_CustomersTable
SELECT 
  c.customerkey AS CustomerKey, 
  c.FirstName AS [First Name], 
  c.lastname AS [Last Name], 
  c.lastname + ' ' + c.FirstName AS [Full Name],
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
	  C.gender as Test,  
  c.datefirstpurchase AS DateFirstPurchase,
  g.city AS [Customer City]
FROM 
    dbo.DimCustomer as c
    LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey --Joined the customer table and geography table 
ORDER BY 
CustomerKey ASC -- Ordered resulting table by customer Key

