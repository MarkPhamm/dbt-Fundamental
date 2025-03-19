{{ config(
    materialized = 'table'
) }}

WITH customerorders AS 
(
SELECT 
    c.customerid, 
    CONCAT(c.firstname, ' ', c.lastname) AS customername, 
    COUNT(o.orderid) AS no_of_orders
FROM l1_landing.customers c
JOIN l1_landing.orders o 
    ON c.customerid = o.customerid
GROUP BY c.customerid, customername
ORDER BY no_of_orders DESC
)
SELECT customerid, customername, no_of_orders FROM customerorders