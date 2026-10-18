-- SQL Internship Task: Retail Sales Database
-- Each query is followed by the business question it answers.
-- Assumes the existing retail_sales database and its employees, customers, and orders tables/data.
-- This script does not create/drop tables or insert/delete data.

USE retail_sales;

-- BASIC QUERIES
-- Query 1
SELECT * FROM employees;
-- Shows all employee records.

-- Query 2
SELECT employee_name, salary FROM employees;
-- Shows each employee's name and salary.

-- Query 3
SELECT * FROM employees WHERE department = 'IT';
-- Finds employees working in the IT department.

-- Query 4
SELECT * FROM employees WHERE salary > 40000;
-- Finds employees earning more than 40000.

-- Query 5
SELECT * FROM employees ORDER BY salary ASC;
-- Lists employees from lowest salary to highest.

-- Query 6
SELECT * FROM employees ORDER BY salary DESC;
-- Lists employees from highest salary to lowest.


-- AGGREGATE FUNCTIONS AND GROUP BY
-- Query 7
SELECT COUNT(*) AS total_employees FROM employees;
-- Counts all employees.

-- Query 8
SELECT SUM(salary) AS total_salary FROM employees;
-- Calculates the total salary of all employees.

-- Query 9
SELECT AVG(salary) AS average_salary FROM employees;
-- Calculates the average employee salary.

-- Query 10
SELECT MAX(salary) AS highest_salary FROM employees;
-- Finds the highest salary.

-- Query 11
SELECT MIN(salary) AS lowest_salary FROM employees;
-- Finds the lowest salary.

-- Query 12
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;
-- Counts employees in each department.

-- Query 13
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;
-- Calculates the average salary in each department.

-- Query 14
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department HAVING AVG(salary) > 40000;
-- Shows departments with an average salary above 40000.


-- JOINS
-- Query 15
SELECT c.customer_name, o.total_amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id;
-- Shows customers with matching orders and each order amount.

-- Query 16
SELECT c.customer_name, o.total_amount FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- Shows all customers, including customers without orders.

-- Query 17
SELECT c.customer_name, o.order_id, o.total_amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id;
-- Shows customer names with their order IDs and amounts.

-- Query 18
SELECT c.customer_name, o.order_id, o.total_amount FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- Shows all orders with matching customer details.


-- SUBQUERIES AND CASE
-- Query 19
SELECT * FROM orders WHERE total_amount > (SELECT AVG(total_amount) FROM orders);
-- Finds orders above the average order amount.

-- Query 20
SELECT customer_name FROM customers WHERE customer_id IN (SELECT customer_id FROM orders);
-- Lists customers who have placed orders.

-- Query 21
SELECT order_id, total_amount, CASE WHEN total_amount >= 5000 THEN 'High' WHEN total_amount >= 3000 THEN 'Medium' ELSE 'Low' END AS order_category FROM orders;
-- Classifies each order as High, Medium, or Low by amount.


-- ADDITIONAL QUERIES
-- Query 22
SELECT DISTINCT city FROM customers;
-- Lists each customer city once.

-- Query 23
SELECT * FROM customers WHERE customer_name LIKE 'A%';
-- Finds customers whose names start with A.

-- Query 24
SELECT * FROM customers WHERE city IN ('Delhi', 'Patna');
-- Finds customers from Delhi or Patna.

-- Query 25
SELECT * FROM orders WHERE total_amount BETWEEN 2000 AND 5000;
-- Finds orders from 2000 to 5000, including both limits.

-- Query 26
SELECT * FROM orders WHERE total_amount > 2000 AND total_amount < 5000;
-- Finds orders strictly between 2000 and 5000.

-- Query 27
SELECT * FROM customers WHERE city = 'Delhi' OR city = 'Mumbai';
-- Finds customers from Delhi or Mumbai.

-- Query 28
SELECT * FROM customers WHERE NOT city = 'Delhi';
-- Finds customers who are not from Delhi.

-- Query 29
SELECT * FROM orders ORDER BY total_amount DESC;
-- Lists orders from highest amount to lowest.

-- Query 30
SELECT * FROM customers LIMIT 5;
-- Displays up to five customer records.

-- Query 31
SELECT COUNT(*) AS total_customers FROM customers;
-- Counts all customers.

-- Query 32
SELECT AVG(total_amount) AS average_order FROM orders;
-- Calculates the average order amount.

-- Query 33
SELECT MAX(total_amount) AS highest_order FROM orders;
-- Finds the highest order amount.

-- Query 34
SELECT MIN(total_amount) AS lowest_order FROM orders;
-- Finds the lowest order amount.

-- Query 35
SELECT SUM(total_amount) AS total_sales FROM orders;
-- Calculates total sales across all orders.

-- Query 36
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;
-- Counts employees in each department.

-- Query 37
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;
-- Calculates average salary by department.

-- Query 38
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department HAVING AVG(salary) > 40000;
-- Shows departments whose average salary is above 40000.

-- Query 39
SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
-- Finds employees earning above the overall average salary.

-- Query 40
SELECT c.customer_name, o.total_amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id;
-- Shows customers with matching orders and their order amounts.

-- Query 41
SELECT order_id, total_amount, CASE WHEN total_amount >= 5000 THEN 'High' WHEN total_amount >= 3000 THEN 'Medium' ELSE 'Low' END AS order_category FROM orders;
-- Classifies orders as High, Medium, or Low.


-- WINDOW FUNCTIONS
-- Query 42
SELECT employee_id, employee_name, department, salary, RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM employees;
-- Ranks employees by salary from highest to lowest; ties share the same rank.

-- Query 43
SELECT employee_id, employee_name, department, salary, ROW_NUMBER() OVER (ORDER BY salary DESC, employee_id) AS row_num FROM employees;
-- Assigns a unique row number in descending salary order.

-- Query 44
SELECT employee_id, employee_name, department, salary, DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS department_salary_rank FROM employees;
-- Ranks employees by salary within each department without gaps in rank values.

-- Query 45
SELECT employee_id, employee_name, department, salary, AVG(salary) OVER (PARTITION BY department) AS department_average_salary FROM employees;
-- Shows each employee alongside their department's average salary.


-- COMMON TABLE EXPRESSIONS (CTE)
-- Query 46
WITH average_salary AS (SELECT AVG(salary) AS avg_salary FROM employees) SELECT e.employee_id, e.employee_name, e.department, e.salary FROM employees e CROSS JOIN average_salary a WHERE e.salary > a.avg_salary;
-- Finds employees earning above the overall average salary using a CTE.

-- Query 47
WITH customer_sales AS (SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS number_of_orders, SUM(o.total_amount) AS total_spent FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.customer_name) SELECT customer_id, customer_name, number_of_orders, total_spent FROM customer_sales ORDER BY total_spent DESC;
-- Shows each customer with orders, their order count, and total spending.
