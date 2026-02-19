-- Active: 1771080877515@@127.0.0.1@3306@sakila

## SAKILA PROJECT ONE
SELECT * FROM payment;

## REVENUE


#1 Calculate total revenue
select sum(`amount`) as 'total revenue' from payment;

#2 Calc Revenue per month
select YEAR(`payment_date`) as `Year`, MONTH(`payment_date`) as `Month`, sum(`amount`) as `rev_per_mon`
    FROM `payment`
    GROUP BY `Year`, `Month`;

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS year_month,
       SUM(amount) AS revenue
FROM payment
GROUP BY year_month
ORDER BY year_month;


#3 Revenue per store
SELECT s.store_id AS `store`, sum(p.amount) AS `revenue`
FROM payment AS p
JOIN customer AS c ON p.customer_id = c.customer_id
JOIN store AS s ON c.store_id = s.store_id
GROUP BY `store`
ORDER BY `revenue`;

#4 Revenue by film category
SELECT ca.name AS `category`, sum(p.amount) AS `revenue`
FROM payment p 
JOIN rental AS r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
GROUP BY `category`
ORDER BY `revenue` DESC;

#5 Top 10 highest revenue films
SELECT f.title AS `film`, sum(p.amount) AS `revenue`
FROM payment p 
JOIN rental AS r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY `film`
ORDER BY `revenue` DESC
LIMIT 10;

SELECT f.film_id,
       f.title,
       SUM(p.amount) AS revenue
FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY revenue DESC
LIMIT 10;

# Advance analysis 6. Running Total Revenue (Window Function)
SELECT 
    `year_month`,
    `monthly_revenue`,
    SUM(`monthly_revenue`) OVER (
        ORDER BY `year_month` ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW --running window, the addition can be removed
    ) AS `running_total_revenue`

FROM ( -- here we subquery with monthly revenue as above
       SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS `year_month`,
        SUM(amount) AS monthly_revenue
    FROM payment
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')

) AS monthly_data

ORDER BY `year_month`;

# Month-over-month growth rate
SELECT 
    `year_month`,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY `year_month`) AS previous_month,
    
    ROUND(
        (
            (monthly_revenue - LAG(monthly_revenue) 
             OVER (ORDER BY `year_month`))
            / LAG(monthly_revenue) 
              OVER (ORDER BY `year_month`)
        ) * 100, 
        2
    ) AS mom_growth_percent

FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS `year_month`,
           SUM(amount) AS monthly_revenue
    FROM payment
    GROUP BY `year_month`
) AS monthly_data;



# Combine the 5th and 6th task
SELECT 
    `year_month`,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY `year_month`) AS running_total,
    LAG(monthly_revenue) OVER (ORDER BY `year_month`) AS previous_month,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY `year_month`))
        / LAG(monthly_revenue) OVER (ORDER BY `year_month`) * 100,
        2
    ) AS mom_growth_percent
FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS `year_month`,
           SUM(amount) AS monthly_revenue
    FROM payment
    GROUP BY `year_month`
) AS monthly_data;

# Myself
# Running total revenue (window functions)
SELECT `Year_Month`, `Monthly_Revenue`, SUM(`Monthly_Revenue`) OVER (ORDER BY `Year_Month`) AS `Moving_Average`
FROM (
SELECT DATE_FORMAT(`payment_date`, '%Y-%M') AS `Year_Month`, SUM(`amount`) AS `Monthly_Revenue`
FROM payment
GROUP BY `Year_Month`
ORDER BY `Year_Month`) AS `Moving Revenue`;

# Month-over-month growth rate
SELECT `Year_Month`, `Monthly_Revenue`, `Lag_Month`, -- the outer query cannot reference the alias Lag_Month inside the same SELECT list.
ROUND(
    (`Monthly_Revenue` - `Lag_Month`)/`Lag_Month`*100,
2) AS `MOM GRT_Rate`
FROM(
SELECT DATE_FORMAT(`payment_date`, '%Y-%m') AS `Year_Month`, SUM(`amount`) AS `Monthly_Revenue`,
LAG(SUM(`amount`)) OVER (ORDER BY DATE_FORMAT(`payment_date`, '%Y-%m')) AS `Lag_Month`
FROM payment
GROUP BY `Year_Month`
) AS `GROWTH_RATE`;