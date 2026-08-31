# E-commerce sales performance analysis
SQL analysis of e-commerce sales data to identify sales trends, top-performing products and business opportunities.

## 1.- Business problem 
The goal of this project is to analyze and e-commerce sales dataset to understand sales performance, customer purchasing behaviour, and product performance.

The analysis aims to identify key sales trends, high-performing products and markets, and business opportunities These insights can help the company make more informed decisions about product strategy, and sales performance.

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

Monthly revenues were calculated by multiplying Quantity by UnitPrice and grouping transactions by month. The number of orders was also calculated using the number of distinct invoices.

This allowed us to analyze how both revenue and order volume changed over time.
| Month | Total Revenue |
|---|---:|
| 2011-01 | £689,811.61 |
| 2011-02 | £522,545.56 |
| 2011-03 | £716,215.26 |
| 2011-04 | £536,968.49 |
| 2011-05 | £769,296.61 |
| 2011-06 | £760,547.01 |
| 2011-07 | £718,076.12 |
| 2011-08 | £757,841.38 |
| 2011-09 | £1,056,435.19 |
| 2011-10 | £1,151,263.73 |
| 2011-11 | £1,503,866.78 |
| 2011-12 | £637,790.33 |

| Month | Number of Orders |
|---|---:|
| 2011-01 | 1,086 |
| 2011-02 | 1,100 |
| 2011-03 | 1,454 |
| 2011-04 | 1,246 |
| 2011-05 | 1,681 |
| 2011-06 | 1,533 |
| 2011-07 | 1,475 |
| 2011-08 | 1,361 |
| 2011-09 | 1,837 |
| 2011-10 | 2,040 |
| 2011-11 | 2,769 |
| 2011-12 | 819 |

The analysis shows a clear increase in sales activity towards the end of 2011. November was the strongest month, generating approximately £1.50 million in sales and 2,769 orders. October was the second strongest month, with approximately £1.15 million in sales and 2,040 orders.

In contrast, February was the weakest month, generating approximately £523,000 in sales.

### 4.2 High-Performing Products

Products were analyzed using two different measures: total revenue generated and total units sold.

| Rank | StockCode | Total Revenue |
|---:|---|---:|
| 1 | DOT | £206,248.77 |
| 2 | 22423 | £174,156.54 |
| 3 | 23843 | £168,469.60 |
| 4 | 85123A | £104,462.75 |
| 5 | 47566 | £99,445.23 |
| 6 | 85099B | £94,159.81 |
| 7 | 23166 | £81,700.92 |
| 8 | POST | £78,101.88 |
| 9 | M | £77,750.27 |
| 10 | 23084 | £66,870.03 |

| Rank | StockCode | Units Sold |
|---:|---|---:|
| 1 | 23843 | 80,995 |
| 2 | 23166 | 78,033 |
| 3 | 22197 | 56,898 |
| 4 | 84077 | 54,951 |
| 5 | 85099B | 48,371 |
| 6 | 85123A | 37,641 |
| 7 | 21212 | 36,396 |
| 8 | 84879 | 36,362 |
| 9 | 23084 | 30,739 |
| 10 | 22492 | 26,633 |

The product with the highest revenue was DOT, generating approximately £206,249, followed by 22423 and 23843.

When looking at units sold, the ranking was different. Product 23843 had the highest number of units sold, with approximately 80,995 units, followed by 23166 with approximately 78,033 units.

This comparison helps distinguish between products that generate high revenue and products that have high sales volume.

### 4.3 Market Performance

Sales and order volumes were analyzed by country to identify the strongest markets.

| Rank | Country | Total Revenue |
|---:|---|---:|
| 1 | United Kingdom | £9,001,744.09 |
| 2 | Netherlands | £285,446.34 |
| 3 | EIRE | £283,140.52 |
| 4 | Germany | £228,678.40 |
| 5 | France | £209,625.37 |
| 6 | Australia | £138,453.81 |
| 7 | Spain | £61,558.56 |
| 8 | Switzerland | £57,067.60 |
| 9 | Belgium | £41,196.34 |
| 10 | Sweden | £38,367.83 |
| 11 | Japan | £37,416.37 |
| 12 | Norway | £36,165.44 |
| 13 | Portugal | £33,683.05 |
| 14 | Finland | £22,546.08 |
| 15 | Singapore | £21,279.29 |
| 16 | Channel Islands | £20,440.54 |
| 17 | Denmark | £18,955.34 |
| 18 | Italy | £17,483.24 |
| 19 | Hong Kong | £15,483.00 |
| 20 | Cyprus | £13,502.85 |
| 21 | Austria | £10,198.68 |
| 22 | Israel | £8,129.41 |
| 23 | Poland | £7,334.65 |
| 24 | Greece | £4,760.52 |
| 25 | Unspecified | £4,740.94 |
| 26 | Iceland | £4,310.00 |
| 27 | Canada | £3,666.38 |
| 28 | USA | £3,580.39 |
| 29 | Malta | £2,725.59 |
| 30 | United Arab Emirates | £1,902.28 |
| 31 | Lebanon | £1,693.88 |
| 32 | Lithuania | £1,661.06 |
| 33 | European Community | £1,300.25 |
| 34 | Brazil | £1,143.60 |
| 35 | RSA | £1,002.31 |
| 36 | Czech Republic | £826.74 |
| 37 | Bahrain | £754.14 |
| 38 | Saudi Arabia | £145.92 |

| Rank | Country | Number of Orders |
|---:|---|---:|
| 1 | United Kingdom | 18,019 |
| 2 | Germany | 457 |
| 3 | France | 392 |
| 4 | EIRE | 288 |
| 5 | Belgium | 98 |
| 6 | Netherlands | 94 |
| 7 | Spain | 90 |
| 8 | Portugal | 58 |
| 9 | Australia | 57 |
| 10 | Switzerland | 54 |
| 11 | Finland | 41 |
| 12 | Italy | 38 |
| 13 | Sweden | 36 |
| 14 | Norway | 36 |
| 15 | Channel Islands | 26 |
| 16 | Poland | 19 |
| 17 | Japan | 19 |
| 18 | Denmark | 18 |
| 19 | Austria | 17 |
| 20 | Cyprus | 16 |
| 21 | Unspecified | 13 |
| 22 | Hong Kong | 11 |
| 23 | Israel | 8 |
| 24 | Iceland | 7 |
| 25 | Singapore | 7 |
| 26 | Canada | 6 |
| 27 | Malta | 5 |
| 28 | Greece | 5 |
| 29 | USA | 5 |
| 30 | Lithuania | 4 |
| 31 | European Community | 4 |
| 32 | Bahrain | 3 |
| 33 | United Arab Emirates | 3 |
| 34 | Czech Republic | 2 |
| 35 | Brazil | 1 |
| 36 | Lebanon | 1 |
| 37 | Saudi Arabia | 1 |
| 38 | RSA | 1 |

The United Kingdom was by far the largest market, generating approximately £9.0 million in revenue and more than 18,000 orders.

Germany was the second-largest market by number of orders, with 457 orders, followed by France with 392 orders and EIRE with 288 orders.

The analysis also shows that the UK dominates the dataset in both revenue and order volume, while other European markets represent considerably smaller portions of total sales.

### 4.4 Average Order Value
Revenue and order volume show very different patterns across markets, which highlights the importance of analyzing multiple KPIs together.

The United Kingdom is clearly the largest market, generating approximately £9.0 million in revenue from more than 18,000 orders. Its performance is therefore primarily driven by a very high order volume.

However, other markets show a different pattern. For example, the Netherlands generated approximately £285,000 in revenue from only 94 orders. This is considerably fewer orders than Germany (457) or France (392), yet the Netherlands generated more total revenue than both countries. This suggests that customers in the Netherlands place orders with a substantially higher average value.

A similar pattern can be observed in Australia, which generated approximately £138,000 from only 57 orders. In contrast, EIRE generated approximately £283,000 from 288 orders, meaning that a similar level of revenue was achieved through a much larger number of orders.

| Metric (AOV) | Value |
|---|---:|
| Average Order Value | £53.32 |

| Rank | Country | Average Order Value |
|---:|---|---:|
| 1 | Singapore | £3,039.90 |
| 2 | Netherlands | £3,036.66 |
| 3 | Australia | £2,429.01 |
| 4 | Japan | £1,969.28 |
| 5 | Lebanon | £1,693.88 |
| 6 | Hong Kong | £1,407.55 |
| 7 | Brazil | £1,143.60 |
| 8 | Sweden | £1,065.77 |
| 9 | Switzerland | £1,056.81 |
| 10 | Denmark | £1,053.07 |
| 11 | Israel | £1,016.18 |
| 12 | Norway | £1,004.60 |
| 13 | RSA | £1,002.31 |
| 14 | EIRE | £983.13 |
| 15 | Greece | £952.10 |
| 16 | Cyprus | £843.93 |
| 17 | Channel Islands | £786.17 |
| 18 | USA | £716.08 |
| 19 | Spain | £683.98 |
| 20 | United Arab Emirates | £634.09 |
| 21 | Iceland | £615.71 |
| 22 | Canada | £611.06 |
| 23 | Austria | £599.92 |
| 24 | Portugal | £580.74 |
| 25 | Finland | £549.90 |
| 26 | Malta | £545.12 |
| 27 | France | £534.76 |
| 28 | Germany | £500.39 |
| 29 | United Kingdom | £499.57 |
| 30 | Italy | £460.09 |
| 31 | Belgium | £420.37 |
| 32 | Lithuania | £415.27 |
| 33 | Czech Republic | £413.37 |
| 34 | Poland | £386.03 |
| 35 | Unspecified | £364.69 |
| 36 | European Community | £325.06 |
| 37 | Bahrain | £251.38 |
| 38 | Saudi Arabia | £145.92 |

These differences demonstrate that a market with fewer orders is not necessarily less valuable. Some markets may have a smaller customer base or lower purchase frequency but generate significantly higher-value orders.

Therefore, market performance should be evaluated using Revenue, Number of Orders and Average Order Value together. This can help distinguish between high-volume markets such as the UK and potentially high-value markets such as Singapore, the Netherlands and Australia.

From a business perspective, the high-AOV markets could represent an opportunity for targeted expansion, while high-volume markets could benefit from strategies focused on increasing customer spending per order.

## 5.- Limitations of the dataset 
The dataset provides a large amount of transactional data, but it has some limitations. Customer information is limited to CustomerID, with no demographic or behavioural information available, which restricts the depth of customer-level analysis. Some transactions also have missing CustomerID values, making it impossible to link them to a specific customer. In addition, the dataset does not include structured product categories, only StockCode and Description. Profitability cannot be analyzed because there is no information about costs or profit margins. Finally, negative quantities, which can represent returns or cancellations, were excluded from the main sales analysis to focus on positive sales transactions.

## 6.- Business analysis and recommendations 
The analysis of sales trends, products, markets and purchasing behaviour provides several insights that could support business decision-making.

### Sales Trends

Sales show a clear seasonal pattern, with a significant increase towards the end of 2011. November was the strongest month, generating approximately £1.50 million in revenue and 2,769 orders, while February was the weakest month, with approximately £523,000 in revenue.

This suggests that the business should prepare for increased demand towards the end of the year by planning inventory, marketing campaigns and operational resources in advance.

### Product Performance

Product performance differs depending on whether we measure revenue or units sold. DOT generated the highest revenue, at approximately £206,249, while 23843 was the best-performing product by volume, with approximately 80,995 units sold.

However, the dataset provides limited information about the products, as they are mainly identified by StockCode and Description, without structured product categories or detailed product characteristics. This limits the depth of product-level analysis and makes it difficult to understand why certain products perform better than others.

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
