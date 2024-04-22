# Bank Customer Analysis

![image](https://github.com/jasondo-da/Bank_Customer_Analysis/assets/138195365/675fb646-7073-40a9-8e1d-fb53876fcbf3)

## Table of Contents

- [Project Introduction](#project-introduction)
    - [Bank Customer Analysis SQL Queries](#bank-customer-analysis-sql-queries)
    - [Bank Customer Analysis Dataset](#bank-customer-analysis-dataset)
- [Objective](#objective)
- [Analysis Outline](#analysis-outline)

## Project Introduction

This is a Kaggle-sourced dataset used to refine my data analytics skills further and gain more data science experience. The “Bank Customer Churn” contains a variety of intricate insights into customer characteristics, preferences, and purchasing mannerisms when interacting with their bank and bank products.

### Bank Customer Analysis SQL Queries
All SQL queries on GitHub.

Link: [Bank Customer Analysis](https://github.com/jasondo-da/Bank_Customer_Analysis/blob/main/queries.sql)

### Bank Customer Analysis Dataset
The Bank Customer Churn Dataset provides a detailed overview of the characteristics, preferences, and purchasing behaviors of their customers. It includes demographic information, geographic locations, credit scores, account balances, purchase history, and many more. This dataset is essential for the bank to tailor its growth, marketing strategies, and product offerings to meet its customers’ needs and enhance their banking experience, ultimately driving revenue and loyalty. This project was originally completed using the MySQL platform and the original dataset formatting has been adjusted and cleaned to work on the MySQL platform.

Link: [Original Kaggle Dataset](https://www.kaggle.com/datasets/radheshyamkollipara/bank-customer-churn)

Link: [Bank Customer Analysis Dataset](https://github.com/jasondo-da/Bank_Customer_Analysis/blob/main/customer_churn_records.csv)

| Bank Customer Analysis Dataset Tables | Table Description |
| :------------- | :------------ |
| RowNumber | corresponds to the record (row) number |
| CustomerId | customer identification |
| Surname | the customer surname |
| CreditScore | customer credit score |
| Geography | customer’s location |
| Gender | customer gender |
| Age | customer age |
| Tenure | the number of years that the customer has been with the bank |
| Balance | customer balance amount held at the bank |
| NumOfProducts | the number of products that a customer has purchased through the bank |
| HasCrCard | customer credit card ownership status |
| IsActiveMember | customer activity status |
| EstimatedSalary | customer estimated salary |
| Exited | customer departure status |
| Complain | customer complaint status |
| Satisfaction Score | Score provided by the customer for their complaint resolution |
| Card Type | type of card held by the customer |
| Points Earned | the credit card points earned by the customer from credit card usage| 

## Objective

The purpose of this project is to be part of an ongoing process to refine and develop my data analysis skills. In this analysis of bank customers, I will use SQL to clean, and discover new insights within the dataset to better understand current customer preferences and trends to identify characteristics of the ideal customer for a targeted marketing campaign. Key areas of focus include analysis on uncovering insights on signs of above-average customer product purchases, and elevated held balances with the intent for future targeting marketing campaigns to search for other similar customers.

## Analysis Outline

```sql
/* Who is the main demographic and where are they from? */
SELECT geography,
	gender,
	COUNT(gender) customer_count
FROM customer_profile
GROUP BY gender, geography
ORDER BY COUNT(gender) DESC
```

Output:
| geography | gender | customer_count |
| :----------: | :---------: | :---------: |
| france | male | 2753 |
| france | female | 2261 |
| spain | male | 1388 |
| germany | male | 1316 |
| germany | female | 1193 |
| spain | female | 1089 |


```sql
/* What are the differences in balances held and product purchases between different countries? */
SELECT geography,
	COUNT(DISTINCT customer_id) customer_count,
	SUM(balance) country_balances,
    SUM(products_purchased) total_purchases,
    ROUND(SUM(balance) / COUNT(DISTINCT customer_id), 2) balance_per_customer,
    ROUND(SUM(products_purchased) / COUNT(DISTINCT customer_id), 2) purchases_per_customer
FROM customer_profile
GROUP BY geography
ORDER BY COUNT(DISTINCT customer_id) DESC
```

Output:
| geography | customer_count | country_balances | total_purchases | customer_to_balance_ratio | customer_to_purchase_ratio |
| :----------: | :---------: | :---------: | :---------: | :---------: | :---------: |
| france | 5014 | 311332499 | 7676 | 62092.64 | 1.53 |
| germany | 2509 | 300402873 | 3813 | 119730.12 | 1.52 |
| spain | 2477 | 153123559 | 3813 | 61818.15 | 1.54 |


```sql
/* Do different customer age groups show different trends of elevated product purchases or larger held balances? */
SELECT FLOOR(
	(CASE WHEN age = mm.max_age
		THEN mm.max_age * 0.999999999 
		ELSE age 
		END - mm.min_age
	) / (
		mm.max_age - mm.min_age
		) * 10
		    ) + 1 cohort,
	MIN(age) min_age,
	MAX(age) max_age,
	COUNT(age) count,
    SUM(products_purchased) total_purchases,
    ROUND(SUM(products_purchased) / COUNT(DISTINCT customer_id), 2) purchases_per_customer,
    SUM(balance) total_balance_held,
    ROUND(SUM(balance) / COUNT(DISTINCT customer_id), 2) balance_per_customer
FROM customer_profile
CROSS JOIN (
    SELECT MAX(age) max_age,
        MIN(age) min_age
    FROM customer_profile) mm
WHERE age IS NOT NULL
GROUP BY cohort
ORDER BY cohort
```

Output:
| cohort | min_age | max_age | count | total_purchases | avg_purchases_per_customer | total_balance_held | avg_balance_per_customer |
| :----------: | :---------: | :---------: | :---------: | :---------: | :---------: | :---------: | :---------: |
| 1 | 18 | 25 | 611 | 947 | 1.55 | 45883541 | 75095.81 |
| 2 | 26 | 32 | 2179 | 3377 | 1.55 | 160316309 | 73573.34 |
| 3 | 33 | 40 | 3629 | 5566 | 1.53 | 274276896 | 75579.19 |
| 4 | 41 | 47 | 1871 | 2869 | 1.53 | 145360204 | 77691.18 |
| 5 | 48 | 54 | 828 | 1213 | 1.46 | 69859585 | 84371.48 |
| 6 | 55 | 62 | 523 | 788 | 1.51 | 42424945 | 81118.44 |
| 7 | 63 | 69 | 208 | 310 | 1.49 | 16487725 | 79267.91 |
| 8 | 70 | 77 | 127 | 196	 | 1.54 | 9017981 | 71007.72 |
| 9 | 78 | 84 | 20 | 29 | 1.45 | 984156 | 49207.80 |
| 10 | 85 | 92 | 4 | 7 | 1.75 | 247589 | 61897.25 |


```sql
/* Is there a correlation between credit scores and product purchases or larger held balances? */
SELECT FLOOR(
	(CASE WHEN credit_score = mm.max_credit_score
		THEN mm.max_credit_score * 0.999999999 
		ELSE credit_score END - mm.min_credit_score
	) / (
        mm.max_credit_score - mm.min_credit_score
		) * 10
		    ) + 1 cohort,
	MIN(credit_score) min_credit_score,
	MAX(credit_score) max_credit_score,
    COUNT(DISTINCT customer_id) customer_count,
    SUM(products_purchased) total_purchases,
    ROUND(SUM(products_purchased) / COUNT(DISTINCT customer_id), 2) purchase_per_customer,
    SUM(balance) total_balance_held,
    ROUND(SUM(balance) / COUNT(DISTINCT customer_id), 2) balance_per_customer
FROM customer_profile
CROSS JOIN (
    SELECT MAX(credit_score) max_credit_score,
        MIN(credit_score) min_credit_score
    FROM customer_profile) mm
WHERE age IS NOT NULL
GROUP BY cohort
ORDER BY cohort
```

Output:
| cohort | min_credit_score | max_credit_score | customer_count | total_purchases | purchase_per_customer | total_balance_held | balance_per_customer |
| :----------: | :---------: | :---------: | :---------: | :---------: | :---------: | :---------: | :---------: |
| 1 | 350 | 399 | 19 | 27 | 1.42 | 1752888 | 92257.26 |
| 2 | 401 | 449 | 166 | 251 | 1.51 | 11522348 | 69411.73 |
| 3 | 450 | 499 | 447 | 680 | 1.52 | 37470721 | 83827.12 |
| 4 | 500 | 549 | 958 | 1441 | 1.50 | 70309994 | 73392.48 |
| 5 | 550 | 599 | 1444 | 2212 | 1.53 | 108576738 | 75191.65 |
| 6 | 600 | 649 | 1866 | 2877 | 1.54 | 142740449 | 76495.42 |
| 7 | 650 | 699 | 1952 | 2980 | 1.53 | 151066252 | 77390.50 |
| 8 | 700 | 749 | 1525 | 2331 | 1.53 | 113365043 | 74337.73 |
| 9 | 750 | 799 | 968 | 1485 | 1.53 | 77634945 | 80201.39 |
| 10 | 800 | 850 | 655 | 1018 | 1.55 | 50419553 | 76976.42 |


```sql
/* Does customer tenure affect their likeliness to purchase a product? */
SELECT tenure,
	COUNT(tenure) count,
    SUM(products_purchased) total_purchases,
    ROUND(SUM(products_purchased) / COUNT(tenure), 2) purchases_per_customer
FROM customer_profile
GROUP BY tenure
ORDER BY tenure
```
Output:
| tenure | count | total_purchases | purchase_per_customer |
| :----------: | :---------: | :---------: | :---------: |
| 0 | 413 | 596 | 1.44 |
| 1 | 1035 | 1542 | 1.49 |
| 2 | 1048 | 1666 | 1.59 |
| 3 | 1009 | 1547 | 1.53 |
| 4 | 989 | 1500 | 1.52 |
| 5 | 1012 | 1573 | 1.55 |
| 6 | 967 | 1469 | 1.52 |
| 7 | 1028 | 1573 | 1.53 |
| 8 | 1025 | 1561 | 1.52 |
| 9 | 984 | 1511 | 1.54 |
| 10 | 490 | 764 | 1.56 |


```sql
/* Does customer balance affect customer purchases? */
SELECT FLOOR(
	(CASE WHEN balance = mm.max_balance
		THEN mm.max_balance * 0.999999999 
		ELSE balance END - mm.min_balance
	) / (
        mm.max_balance - mm.min_balance
		) * 10
		    ) + 1 cohort,
	MIN(balance) min_balance,
	MAX(balance) max_balance,
    COUNT(DISTINCT customer_id) customer_count,
    SUM(products_purchased) purchases_from_balance_cohorts,
    ROUND(SUM(products_purchased) / COUNT(DISTINCT customer_id), 2) purchases_per_customer
FROM customer_profile
CROSS JOIN (
    SELECT MAX(balance) max_balance,
        MIN(balance) min_balance
    FROM customer_profile) mm
WHERE age IS NOT NULL
GROUP BY cohort
ORDER BY cohort
```
Output:
| cohort | min_balance | max_balance | customer_count | purchases_from_balance_cohorts | purchases_per_customer |
| :----------: | :---------: | :---------: | :---------: | :---------: | :---------: |
| 1 | 0 | 24043 | 3623 | 6463 | 1.78 |
| 2 | 27288 | 49573 | 69 | 100 | 1.45 |
| 3 | 50195 | 75264 | 360 | 508 | 1.41 |
| 4 | 75303 | 100338 | 1173 | 1616 | 1.38 |
| 5 | 100360 | 125445 | 2081 | 2888 | 1.39 |
| 6 | 125456 | 150526 | 1747 | 2399 | 1.37 |
| 7 | 150556 | 175576 | 729 | 1020 | 1.40 |
| 8 | 175736 | 200322 | 186 | 266 | 1.43 |
| 9 | 200725 | 222268 | 30 | 38 | 1.27 |
| 10 | 238388 | 250898 | 2 | 4 | 2.00 |


```sql
/* Does credit card type influence customer purchases? */
SELECT card_type,
	COUNT(DISTINCT customer_id) total_customers,
	SUM(products_purchased) total_purchases,
    ROUND(SUM(products_purchased) / COUNT(DISTINCT customer_id), 2) purchases_per_cardtype
FROM customer_profile
GROUP BY card_type
```

Output:
| card_type | total_customers | total_purchases | purchases_per_cardtype |
| :----------: | :---------: | :---------: | :---------: |
| diamond | 2507 | 3789 | 1.51 |
| platinum | 2495 | 3870 | 1.55 |
| gold | 2502 | 3807 | 1.52 |
| silver | 2496 | 3836 | 1.54 |
