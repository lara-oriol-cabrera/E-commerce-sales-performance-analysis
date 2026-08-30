SELECT COUNT(*) AS total_rows
FROM `smiling-basis-507109-m6.retail_datasset.retail_data` ;

SELECT
    COUNTIF(InvoiceNo IS NULL) AS missing_InvoiceNo,
    COUNTIF(StockCode IS NULL) AS missing_StockCode,
    COUNTIF(Description IS NULL) AS missing_Description,
    COUNTIF(Quantity IS NULL) AS missing_Quantity,
    COUNTIF(InvoiceDate IS NULL) AS missing_InvoiceDate,
    COUNTIF(UnitPrice IS NULL) AS missing_UnitPrice,
    COUNTIF(CustomerID IS NULL) AS missing_CustomerID,
    COUNTIF(Country IS NULL) AS missing_Country
FROM `smiling-basis-507109-m6.retail_datasset.retail_data`;

SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    COUNT(*) AS occurrences
FROM `smiling-basis-507109-m6.retail_datasset.retail_data`
GROUP BY
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT
    COUNT(*) AS negative_quantity
FROM `smiling-basis-507109-m6.retail_datasset.retail_data`
WHERE Quantity < 0;

SELECT
    COUNT(*) AS invalid_price
FROM `smiling-basis-507109-m6.retail_datasset.retail_data`
WHERE UnitPrice <= 0;

SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    MIN(UnitPrice) AS min_price,
    MAX(UnitPrice) AS max_price
FROM `smiling-basis-507109-m6.retail_datasset.retail_data`;

CREATE OR REPLACE TABLE `smiling-basis-507109-m6.retail_datasset.retail_data_clean` AS

SELECT * EXCEPT(row_num)
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                InvoiceNo,
                StockCode,
                Description,
                CAST(Quantity AS STRING),
                InvoiceDate,
                CAST(UnitPrice AS STRING),
                CustomerID,
                Country
        ) AS row_num
    FROM `smiling-basis-507109-m6.retail_datasset.retail_data`
    WHERE Quantity > 0
      AND UnitPrice > 0
)
WHERE row_num = 1;

SELECT COUNT(*) AS total_rows
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean` ;

SELECT
    DATE_TRUNC(DATE(InvoiceDate), MONTH) AS Month,
    SUM(Quantity * UnitPrice) AS Total_Sales
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY Month
ORDER BY Total_Sales;

SELECT
    DATE_TRUNC(DATE(InvoiceDate), MONTH) AS Month,
    COUNT(DISTINCT InvoiceNo) AS Number_of_Orders
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY Month 
ORDER BY Number_of_Orders;

SELECT
    StockCode,
    SUM(Quantity * UnitPrice) AS Total_Revenue
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY
    StockCode
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    StockCode,
    SUM(Quantity) AS Units_Sold
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY
    StockCode
ORDER BY Units_Sold DESC
LIMIT 10;

SELECT
    Country,
    SUM(Quantity * UnitPrice) AS Total_Revenue
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY Country
ORDER BY Total_Revenue DESC;

SELECT
    Country,
    COUNT(DISTINCT InvoiceNo) AS Number_of_Orders
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY Country
ORDER BY Number_of_Orders DESC;

SELECT
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS Average_Order_Value
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`;

SELECT
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS Average_Order_Value,
    Country
FROM `smiling-basis-507109-m6.retail_datasset.retail_data_clean`
GROUP BY Country;