****************************
-- Bank Customer Analysis --
****************************

	
----------------
-- Schema SQL --
----------------
	
/* Creating schema for project */
CREATE SCHEMA bank_customers

	
/* Creating a table with more efficient data types for analysis */
CREATE TABLE bank_customers.customer_profile (
  row_id SMALLINT UNSIGNED,
  customer_id INT UNSIGNED,
  sur_name VARCHAR(25),
  credit_score SMALLINT UNSIGNED,
  geography VARCHAR(25),
  gender ENUM('male', 'female'),
  age TINYINT UNSIGNED,
  tenure TINYINT UNSIGNED,
  balance INT,
  products_purchased TINYINT UNSIGNED,
  credit_card_holder TINYINT UNSIGNED,
  active_member TINYINT UNSIGNED,
  est_salary MEDIUMINT UNSIGNED,
  exited TINYINT UNSIGNED,
  has_complained TINYINT UNSIGNED,
  satisfaction_score TINYINT UNSIGNED,
  card_type ENUM('diamond', 'platinum', 'gold', 'silver'),
  points_earned SMALLINT UNSIGNED,
  
  CONSTRAINT unique_id PRIMARY KEY (customer_id)
)

	
/* Importing data into new table with more efficient data types */
INSERT INTO bank_customers.customer_profile (
	row_id,
	customer_id,
	sur_name,
	credit_score,
	geography,
	gender,
	age,
	tenure,
	balance,
	products_purchased,
	credit_card_holder,
	active_member,
	est_salary,
	exited,
	has_complained,
	satisfaction_score,
	card_type,
	points_earned
)

SELECT RowNumber,
	CustomerId,
	Surname,
	CreditScore,
	Geography,
	Gender,
	Age,
	Tenure,
	Balance,
	NumOfProducts,
	HasCrCard,
	IsActiveMember,
	EstimatedSalary,
	Exited,
	Complain,
	SatisfactionScore,
	CardType,
	PointEarned
FROM customer_churn_records

	
/* Cleaning data for consistent formatting */
UPDATE customer_profile
SET sur_name = LOWER(sur_name),
	geography = LOWER(geography)
WHERE customer_id > 0

	
---------------
-- Query SQL --
---------------

/* Finding the customer tenure distribution */
SELECT tenure, COUNT(tenure)
FROM customer_profile
GROUP BY tenure
ORDER BY tenure

	
/* Uncovering customer age distribution */
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
    	COUNT(age) count
FROM customer_profile
CROSS JOIN (
    SELECT MAX(age) max_age,
        MIN(age) min_age
    FROM customer_profile) mm
WHERE age IS NOT NULL
GROUP BY cohort
ORDER BY cohort


/*  */
