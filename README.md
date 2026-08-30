# E-commerce sales performance analysis
SQL and Tableau analysis of e-commerce sales data to identify sales trends, top-performing products and business opportunities.

## 1.- Business problem 
The goal of this project is to analyze and e-commerce sales dataset to understand sales performance, customer purchasing behaviour, and product performance.

The analysis aims to identify key sales trends, high-performing products and markets, and customer purchasing patterns. These insights can help the company make more informed decisions about product strategy, customer targeting, and sales performance.

## 2.- Dataset  
### 2.1 Dataset Understanding

The dataset used in this project was obtained from Kaggle and contains transactional data from an online retail business.

Dataset source: [Dataset in Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

The original dataset contains 541,909 rows and 8 variables.

Each row represents a transaction line, meaning a specific product purchased within an invoice. Therefore, one invoice can contain multiple rows when a customer purchases multiple products.

| Variable | Description |
|----------|-------------|
| InvoiceNo | Unique invoice number identifying a transaction. |
| StockCode | Unique code identifying the product. |
| Description | Description or name of the product. |
| Quantity | Number of units of the product included in the transaction line. |
| InvoiceDate | Date and time when the transaction occurred. |
| UnitPrice | Price of one unit of the product. |
| CustomerID | Unique identifier of the customer. |
| Country | Country where the customer is located. |

### 2.2 Data Quality Checks

Before performing the analysis, several data quality checks were carried out using SQL in Google BigQuery.

#### Dataset size

The original dataset contains: 541,909 rows

#### Missing values

Missing values were checked for all variables using COUNTIF().

The analysis showed that the main missing values were found in CustomerID and Description, while the other variables contained very few or no missing values.

Missing values were not automatically replaced because variables such as CustomerID cannot be meaningfully inferred from the available information. Instead, the decision to exclude or retain these records was considered based on their relevance to the subsequent analysis.

#### Duplicate records

Exact duplicate rows were identified by grouping the data across all available variables and counting their occurrences.

Duplicate records were found in the original dataset. These records were removed from the analytical dataset, keeping only the first occurrence of each exact duplicate.

#### Invalid values

The dataset was also checked for invalid numerical values.

Negative quantities were identified. In a retail dataset, negative quantities can represent returns or cancellations rather than standard sales transactions. Since the main objective of this project is to analyse positive sales performance, these records were excluded from the main analytical dataset.

Records with Quantity <= 0 were therefore removed.

Similarly, records with UnitPrice <= 0 were considered invalid for the main sales analysis and were excluded.

The minimum and maximum values of Quantity and UnitPrice were also checked to identify potentially unusual values before creating the cleaned dataset.

### 2.3 Data Cleaning

After completing the data quality checks, a new cleaned table called retail_data_clean was created in BigQuery.

The cleaning process consisted of:

Removing records with Quantity <= 0.
Removing records with UnitPrice <= 0.
Identifying and removing exact duplicate rows.
Keeping the original dataset unchanged and creating a separate cleaned table for the analysis.

The cleaned dataset contains 524,878 rows, compared with 541,909 rows in the original dataset.

This means that 17,031 rows were removed during the cleaning process.

The cleaned dataset will be used for the subsequent Exploratory Data Analysis, SQL analysis, KPI calculation, and Tableau dashboard.

## 3.- SQL analysis 
After cleaning the dataset, SQL was used in Google BigQuery to analyze different areas like: sales trends, high-performing products and markets, average order value. 

### 4.1 Sales Trends

Monthly sales were calculated by multiplying Quantity by UnitPrice and grouping transactions by month. The number of orders was also calculated using the number of distinct invoices.

This allowed us to analyse how both revenue and order volume changed over time.

The analysis shows a clear increase in sales activity towards the end of 2011. November was the strongest month, generating approximately £1.50 million in sales and 2,769 orders. October was the second strongest month, with approximately £1.15 million in sales and 2,040 orders.

In contrast, February was the weakest month, generating approximately £523,000 in sales.

### 4.2 High-Performing Products

Products were analysed using two different measures: total revenue generated and total units sold.

The product with the highest revenue was DOT, generating approximately £206,249, followed by 22423 and 23843.

When looking at units sold, the ranking was different. Product 23843 had the highest number of units sold, with approximately 80,995 units, followed by 23166 with approximately 78,033 units.

This comparison helps distinguish between products that generate high revenue and products that have high sales volume.

### 4.3 Market Performance

Sales and order volumes were analysed by country to identify the strongest markets.

The United Kingdom was by far the largest market, generating approximately £9.0 million in revenue and more than 18,000 orders.

Germany was the second-largest market by number of orders, with 457 orders, followed by France with 392 orders and EIRE with 288 orders.

The analysis also shows that the UK dominates the dataset in both revenue and order volume, while other European markets represent considerably smaller portions of total sales.

### 4.4 Average Order Value
Revenue and order volume show very different patterns across markets, which highlights the importance of analyzing multiple KPIs together.

The United Kingdom is clearly the largest market, generating approximately £9.0 million in revenue from more than 18,000 orders. Its performance is therefore primarily driven by a very high order volume.

However, other markets show a different pattern. For example, the Netherlands generated approximately £285,000 in revenue from only 94 orders. This is considerably fewer orders than Germany (457) or France (392), yet the Netherlands generated more total revenue than both countries. This suggests that customers in the Netherlands place orders with a substantially higher average value.

A similar pattern can be observed in Australia, which generated approximately £138,000 from only 57 orders. In contrast, EIRE generated approximately £283,000 from 288 orders, meaning that a similar level of revenue was achieved through a much larger number of orders.

These differences demonstrate that a market with fewer orders is not necessarily less valuable. Some markets may have a smaller customer base or lower purchase frequency but generate significantly higher-value orders.

Therefore, market performance should be evaluated using Revenue, Number of Orders and Average Order Value together. This can help distinguish between high-volume markets such as the UK and potentially high-value markets such as the Netherlands and Australia.

From a business perspective, the high-AOV markets could represent an opportunity for targeted expansion, while high-volume markets could benefit from strategies focused on increasing customer spending per order.

## 5.- Limitations of the dataset 
The dataset provides a large amount of transactional data, but it has some limitations. Customer information is limited to CustomerID, with no demographic or behavioural information available, which restricts the depth of customer-level analysis. Some transactions also have missing CustomerID values, making it impossible to link them to a specific customer. In addition, the dataset does not include structured product categories, only StockCode and Description. Profitability cannot be analysed because there is no information about costs or profit margins. Finally, negative quantities, which can represent returns or cancellations, were excluded from the main sales analysis to focus on positive sales transactions.

## 6.- Business analysis and recommendations 
The analysis of sales trends, products, markets and purchasing behaviour provides several insights that could support business decision-making.

### Sales Trends

Sales show a clear seasonal pattern, with a significant increase towards the end of 2011. November was the strongest month, generating approximately £1.50 million in revenue and 2,769 orders, while February was the weakest month, with approximately £523,000 in revenue.

This suggests that the business should prepare for increased demand towards the end of the year by planning inventory, marketing campaigns and operational resources in advance.

### Product Performance

Product performance differs depending on whether we measure revenue or units sold. DOT generated the highest revenue, at approximately £206,249, while 23843 was the best-performing product by volume, with approximately 80,995 units sold.

This difference shows that high-volume products are not necessarily the products generating the most revenue. The business should therefore monitor both metrics when making product and inventory decisions.

### Market Performance

The United Kingdom is by far the most important market in the dataset, generating approximately £9.0 million in revenue from 18,019 orders. This suggests that the UK should remain a key market for the business.

However, the analysis also reveals interesting differences between smaller markets. For example, the Netherlands generated approximately £285,000 from only 94 orders, while Germany generated approximately £229,000 from 457 orders. This suggests that Dutch orders have a considerably higher average value.

Similarly, Australia generated approximately £138,000 from only 57 orders, indicating another potentially high-value market despite its low order volume.

These results suggest that smaller markets should not be evaluated only by total revenue or number of orders. Markets with relatively few orders but high-value purchases could represent opportunities for targeted expansion.

### Final recommendations 
Based on the analysis, the business could focus on the following actions:

- Prepare for seasonal demand by increasing inventory and marketing activity before the strongest sales period.
- Monitor product performance using both revenue and units sold to identify high-value and high-volume products.
- Protect the UK market, as it represents the largest source of revenue and orders.
- Investigate high-value smaller markets, such as the Netherlands and Australia, to understand why their average order values are relatively high and assess opportunities for further growth.
- Use multiple KPIs when evaluating markets, combining revenue, order volume and Average Order Value rather than relying on a single metric.

## Results visualization 
You can check the results in the provided dashboard in the repository 
