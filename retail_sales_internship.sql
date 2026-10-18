-- SQL Internship Task: Retail Sales Database
-- Uses the existing retail_sales database and its existing tables/data.
-- This file contains SELECT-based analysis queries only.
-- It does NOT create/drop tables or insert/update/delete data.
-- Each query is followed by the business question it answers.

USE retail_sales;

-- BASIC QUERIES

-- Query 1
SELECT * FROM employees;
-- Business question: What employee records are currently available?

-- Query 2
SELECT employee_name, salary FROM employees;
-- Business question: What is each employee's name and salary?

-- Query 3
SELECT * FROM employees WHERE department = 'IT';
-- Business question: Which employees work in the IT department?

-- Query 4
SELECT * FROM employees WHERE salary > 40000;
-- Business question: Which employees earn more than 40000?

-- Query 5
SELECT * FROM employees ORDER BY salary ASC;
-- Business question: How do employees rank from lowest to highest salary?

-- Query 6
SELECT * FROM employees ORDER BY salary DESC;
-- Business question: How do employees rank from highest to lowest salary?


-- AGGREGATE FUNCTIONS AND GROUP BY

-- Query 7
SELECT COUNT(*) AS total_employees FROM employees;
-- Business question: How many employees are in the company?

-- Query 8
SELECT SUM(salary) AS total_salary FROM employees;
-- Business question: What is the combined salary of all employees?

-- Query 9
SELECT AVG(salary) AS average_salary FROM employees;
-- Business question: What is the average employee salary?

-- Query 10
SELECT MAX(salary) AS highest_salary FROM employees;
-- Business question: What is the highest employee salary?

-- Query 11
SELECT MIN(salary) AS lowest_salary FROM employees;
-- Business question: What is the lowest employee salary?

-- Query 12
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;
-- Business question: How many employees work in each department?

-- Query 13
SELECT department, AVG(salary) AS average_salary
FROM employees
GROUP BY department;
-- Business question: What is the average salary in each department?

-- Query 14
SELECT department, AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 40000;
-- Business question: Which departments have an average salary above 40000?


-- JOINS

-- Query 15
SELECT c.customer_name, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
-- Business question: Which customers have orders, and what are the order amounts?

-- Query 16
SELECT c.customer_name, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- Business question: Which customers have orders, and which customers have no orders?

-- Query 17
SELECT c.customer_name, o.order_id, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
-- Business question: What are the order IDs and amounts for each customer who ordered?

-- Query 18
SELECT c.customer_name, o.order_id, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- Business question: What are all recorded orders and their matching customer details?


-- SUBQUERIES AND CASE

-- Query 19
SELECT *
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);
-- Business question: Which orders are above the average order amount?

-- Query 20
SELECT customer_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);
-- Business question: Which customers have placed at least one order?

-- Query 21
SELECT order_id, total_amount,
       CASE
           WHEN total_amount >= 5000 THEN 'High'
           WHEN total_amount >= 3000 THEN 'Medium'
           ELSE 'Low'
       END AS order_category
FROM orders;
-- Business question: How can orders be categorized as High, Medium, or Low value?


-- ADDITIONAL FILTERING AND SORTING

-- Query 22
SELECT DISTINCT city FROM customers;
-- Business question: Which cities are represented in the customer data?

-- Query 23
SELECT * FROM customers WHERE customer_name LIKE 'A%';
-- Business question: Which customers have names that start with A?

-- Query 24
SELECT * FROM customers WHERE city IN ('Delhi', 'Patna');
-- Business question: Which customers live in Delhi or Patna?

-- Query 25
SELECT * FROM orders WHERE total_amount BETWEEN 2000 AND 5000;
-- Business question: Which orders are between 2000 and 5000, including both endpoints?

-- Query 26
SELECT * FROM orders WHERE total_amount > 2000 AND total_amount < 5000;
-- Business question: Which orders are strictly between 2000 and 5000?

-- Query 27
SELECT * FROM customers WHERE city = 'Delhi' OR city = 'Mumbai';
-- Business question: Which customers live in Delhi or Mumbai?

-- Query 28
SELECT * FROM customers WHERE NOT city = 'Delhi';
-- Business question: Which customers do not live in Delhi?

-- Query 29
SELECT * FROM orders ORDER BY total_amount DESC;
-- Business question: What is the order list from highest amount to lowest?

-- Query 30
SELECT * FROM customers LIMIT 5;
-- Business question: What are the first five customer records returned?

-- Query 31
SELECT COUNT(*) AS total_customers FROM customers;
-- Business question: How many customers are recorded?

-- Query 32
SELECT AVG(total_amount) AS average_order FROM orders;
-- Business question: What is the average order amount?

-- Query 33
SELECT MAX(total_amount) AS highest_order FROM orders;
-- Business question: What is the largest order amount?

-- Query 34
SELECT MIN(total_amount) AS lowest_order FROM orders;
-- Business question: What is the smallest order amount?

-- Query 35
SELECT SUM(total_amount) AS total_sales FROM orders;
-- Business question: What is the total sales value across all orders?


-- SUBQUERY: EMPLOYEES ABOVE AVERAGE SALARY

-- Query 36
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
-- Business question: Which employees earn more than the overall average salary?


-- WINDOW FUNCTIONS

-- Query 37
SELECT employee_id, employee_name, department, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
-- Business question: What is each employee's rank when salaries are ordered highest to lowest?

-- Query 38
SELECT employee_id, employee_name, department, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC, employee_id) AS row_num
FROM employees;
-- Business question: What unique row number does each employee receive in salary order?

-- Query 39
SELECT employee_id, employee_name, department, salary,
       DENSE_RANK() OVER (
           PARTITION BY department ORDER BY salary DESC
       ) AS department_salary_rank
FROM employees;
-- Business question: What is each employee's salary rank within their department, without gaps?

-- Query 40
SELECT employee_id, employee_name, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS department_average_salary
FROM employees;
-- Business question: How does each employee's salary compare with their department's average?


-- COMMON TABLE EXPRESSIONS (CTEs)

-- Query 41
WITH average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT e.employee_id, e.employee_name, e.department, e.salary
FROM employees e
CROSS JOIN average_salary a
WHERE e.salary > a.avg_salary;
-- Business question: Which employees earn above the overall average salary, using a CTE?

-- Query 42
WITH customer_sales AS (
    SELECT c.customer_id,
           c.customer_name,
           COUNT(o.order_id) AS number_of_orders,
           SUM(o.total_amount) AS total_spent
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, number_of_orders, total_spent
FROM customer_sales
ORDER BY total_spent DESC;
-- Business question: Which customers with orders spend the most, and how many orders did each place?
