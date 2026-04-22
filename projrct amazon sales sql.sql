sp_help salesdata

drop table amazonsales


CREATE TABLE amazonsales(
    Order_ID VARCHAR(50),
    Date varchar(20),
    Clean_date varchar(20),
    Month VARCHAR(20),
    Status VARCHAR(50),
    Status_Clean VARCHAR(50),
    Fulfilment VARCHAR(50),
    Sales_Channel VARCHAR(50),
    ship_service_level VARCHAR(50),
    Category VARCHAR(100),
    Size VARCHAR(20),
    Courier_Status VARCHAR(50),
    Qty varchar(20),
    currency VARCHAR(10),
    Amount varchar(20),
    Sales varchar(50),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(50),
    ship_country VARCHAR(50),
    B2B VARCHAR(20),
    fulfilled_by VARCHAR(50)
);


BULK INSERT AmazonSales
FROM 'C:\Users\Vinod kumar\OneDrive\Desktop\aksh\amazon_cleaned 3.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select top 10 *from amazonsales_clean_final




SELECT Clean_date
FROM AmazonSales
WHERE Clean_date IS NOT NULL;

CAST(Clean_date AS DATETIME)

/* cleaned data */
SELECT 
    Order_ID,
    
    TRY_CAST(Date AS DATE) AS Order_Date,
    TRY_CONVERT(DATE, Clean_date, 105) AS Clean_Date,
    
    Month,
    Status,
    Status_Clean,
    Fulfilment,
    Sales_Channel,
    ship_service_level,
    Category,
    Size,
    Courier_Status,
    
    TRY_CAST(Qty AS INT) AS Qty,
    currency,
    
    TRY_CAST(Amount AS DECIMAL(10,2)) AS Amount,
    TRY_CAST(Sales AS DECIMAL(10,2)) AS Sales,
    
    ship_city,
    ship_state,
    ship_postal_code,
    ship_country,
    B2B,
    fulfilled_by

INTO AmazonSales_Clean_Final
FROM AmazonSales;

/* total sales*/
select sum(sales) as total_Sales
from AmazonSales_Clean_Final

/* total orders */
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM AmazonSales_Clean_Final;

/* total quantity */
SELECT SUM(Qty) AS Total_Quantity
FROM AmazonSales_Clean_Final;

/* Average Order Value*/
SELECT 
    SUM(Sales) / COUNT(DISTINCT Order_ID) AS Avg_Order_Value
FROM AmazonSales_Clean_Final;

/* sales by category */

SELECT 
    Category, 
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY Category
ORDER BY Total_Sales DESC;

/* top 10 cities by sales */

SELECT TOP 10 
    ship_city, 
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY ship_city
ORDER BY Total_Sales DESC;


/* courier performance */

SELECT 
    Courier_Status, 
    COUNT(*) AS Total_Orders
FROM AmazonSales_Clean_Final
GROUP BY Courier_Status
ORDER BY Total_Orders DESC;

/* order status analysis */
SELECT 
    Status, 
    COUNT(*) AS Total_Orders
FROM AmazonSales_Clean_Final
GROUP BY Status
ORDER BY Total_Orders DESC;

/* most sold sizes */
SELECT 
    Size,
    SUM(Qty) AS Total_Quantity
FROM AmazonSales_Clean_Final
GROUP BY Size
ORDER BY Total_Quantity DESC;

/* top  selling products*/

SELECT TOP 10
    Category,
    Size,
    SUM(Qty) AS Total_Quantity
FROM AmazonSales_Clean_Final
GROUP BY Category, Size
ORDER BY Total_Quantity DESC;

/*fulfillment analysis */
/* orders by fullfillment type*/

SELECT 
    Fulfilment,
    COUNT(*) AS Total_Orders
FROM AmazonSales_Clean_Final
GROUP BY Fulfilment;

/* Courier Status Analysis */

SELECT 
    Courier_Status,
    COUNT(*) AS Total_Orders
FROM AmazonSales_Clean_Final
GROUP BY Courier_Status
ORDER BY Total_Orders DESC;

/*Cancellation Rate Analysis*/

SELECT 
    COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100.0 
    / COUNT(*) AS Cancellation_Percentage
FROM AmazonSales_Clean_Final;

/* Geographic Analysis*/

/* Top States by Sales*/
SELECT TOP 10
    ship_state,
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY ship_state
ORDER BY Total_Sales DESC;

/*Top Cities by Sales*/
SELECT TOP 10
    ship_city,
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY ship_city
ORDER BY Total_Sales DESC;

/* customer segmentation */

/*
B2B vs B2C Segmentation*/
SELECT 
    B2B,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    AVG(Sales) AS Avg_Order_Value
FROM AmazonSales_Clean_Final
GROUP BY B2B;

/*
Customer Segmentation by Order Value*/
SELECT 
    CASE 
        WHEN Sales > 1000 THEN 'High Value'
        WHEN Sales BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY 
    CASE 
        WHEN Sales > 1000 THEN 'High Value'
        WHEN Sales BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END;

/*
State-wise Customer Segmentation*/
SELECT 
    ship_state,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales
FROM AmazonSales_Clean_Final
GROUP BY ship_state
ORDER BY Total_Sales DESC;

