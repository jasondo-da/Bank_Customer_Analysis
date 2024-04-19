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

/*  */
