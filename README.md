# 🔍 Exploratory Data Analysis (EDA) in SQL

Hello and welcome to my second project! 
After building my [Data Warehouse](https://github.com/valeria-yagui/sql-data-warehouse-project), I moved into the **Exploratory Data Analysis (EDA)** phase to extract meaningful insights from the data.

The goal of this project was to dive deep into the **Gold Layer** (the star schema) using **SQL Server** to transform raw information into business intelligence.

### 🎯 The Approach: A Managerial Perspective
My workflow for this analysis followed two main steps:
1.  **Broad Exploration:** First, I performed a full scan of the tables (`dim_customers`, `dim_products`, and `fact_sales`) to get and overview of the data structure.
2.  **Managerial Inquiry:** I then asked myself: *"What would a manager need to know to make better decisions?"* This led to the creation of specific queries focused on KPIs, rankings, and performance trends.

### 📊 Key Analysis Areas
Using SQL queries, I explored several dimensions of the business:

* **Customer Insights:** Analyzed geographic distribution (finding that Canada and Australia are the top markets) and demographic profiles like gender and age ranges.
* **Product Portfolio:** Categorized the product offer, analyzed the number of products per subcategory, and calculated the average cost per category.
* **Sales Performance:** Calculated critical business metrics such as **Total Revenue**, **Total Cost**, and **Total Profit**.
* **Operational KPIs:** Investigated the "Average Order Value" (AOV), items per order, and the total volume of orders over a 4-year period.
* **Rankings (Top & Bottom):** Identified the Top 10 customers, the most profitable products, and the underperforming subcategories to highlight areas for improvement.

### 📋 Consolidated Metrics Report
I developed a comprehensive report using `UNION ALL` logic to provide a "one-stop" view of all high-level business measures, including total sales, profit, product count, and average prices.

Special thanks to [@DataWithBaraa](https://github.com/DataWithBaraa) for the guidance in this SQL series:
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=6cJ5Ji8zSDg)

---

## 💡 Key Findings & Insights

* **Customers:**
 1. The database contains 18,484 unique customers.
 2. Geographic concentration: The market is highly concentrated, with the USA (40%) and Australia (20%) accounting for 60% of the total customer base.
 3. Gender balance: The distribution between male and female customers is nearly 50/50, which indicates a gender-neutral appeal for the product lines.
 4. High engagement: A key technical finding is that 100% of registered customers have placed at least one order, suggesting high conversion.
* **Sales  and Performance:**
 1. Financial overview: Total sales reached USD 29.35M, with a total profit of USD 11.68M (representing an approximate 40% profit margin).
 2. Order efficiency: With 27,659 total orders, the Average Order Value (AOV) stands at USD 1,061, with an average of 2 items per order.
 3. Regional dominance: Matching the customer base, the USA and Australia account for over 50% of the total quantity of items sold.
 4. Profit drivers: Bikes is the primary category driving profit, followed by Accessories.
 5. Lowest grossing products: The Racing Socks (L & M) and Patch Kits are the lowest-performing items in the catalog, generating minimal profit compared to the bike lines.
 6. Clothing category, specifically Socks and Caps, shows the lowest market penetration, with total category profits for socks at just USD 3,408.
 7. Low-Margin items: The AWC Logo Cap, despite having higher sales volume (USD 19,710) than socks, yields a significantly lower profit margin (approx. 22%) compared to the company's 40% average.
 * **Products:** 
 1. Inventory breadth: The company manages 295 products across 4 categories and 36 subcategories.
 2. Premium strategy: Although Bikes have the highest production cost, they remain the most successful category in terms of revenue and profit.
 3. Top performers: The Mountain-200 model is the top-selling product. The most successful subcategories include Road Bikes, Mountain Bikes, and Touring Bikes.

* **Strategic Recommendations** 
 1. Cross-Selling opportunity: Since the average items per order is only 2, there is a significant opportunity to implement  strategies of "Frequently Bought Together" to attach more accessories (helmets, tires) to bike sales.
 2. Market expansion: Given that 60% of sales are concentrated in only two countries, a market penetration study for other regions could diversify the risk.
 3. Operational overhead: Regarding the Clothing and Cleaners subcategories, are they generating enough profit to justify their inventory and storage costs?
 4. Bundle strategy for low performers: To increase the total units per order and clear inventory of low-performing items, the company could offer "Starter Kits" that could be bundled with high-value Bike purchases
---

## 👩‍💻 About Me

Hi there! I’m **Valeria Yagui**, from Lima, Peru.  
I'm currently pursuing a **Master’s degree in Digital Business Management** at **Hochschule Pforzheim** in Germany.  
I enjoy working with data and learning new tools and technologies.  

Feel free to connect with me on LinkedIn:  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/valeria-yagui-nishii/)
