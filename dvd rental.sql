--Write a SQL query to find those actors whose last name is 'Allen' and the last name is 'Allen'. Return actor ID
SELECT actor_id
FROM [dbo].[actor$]
WHERE l_name = 'Allen'

--When was the movie made by Angelina Astaire last updated?
SELECT last_update
FROM [dbo].[actor$]
WHERE f_name = 'Angelina' AND l_name = 'Astaire'

--list the description for all movies that starts with ‘B’
SELECT description
FROM [dbo].[film$]
WHERE film_title LIKE '%B'

--What address id has null second address?
SELECT address_id
FROM [dbo].[address$]
WHERE address2 IS NULL

--List the postal code, address, and phone numbers of districts that starts with ‘K’
SELECT postal_code, address1, phone
FROM [dbo].[address$]
WHERE district LIKE '%K'

--Find the amount generated from each film
SELECT film$.film_title,
SUM([dbo].[payment$].amount) AS total_amount
FROM [dbo].[film$]
JOIN [dbo].[inventory$] ON film$.film_id=[dbo].[inventory$].film_id
JOIN [dbo].[rental$] ON [dbo].[inventory$].inventory_id=[dbo].[rental$].inventory_id
JOIN [dbo].[payment$] ON [dbo].[rental$].rental_id=[dbo].[payment$].rental_id
GROUP BY film_title
ORDER BY total_amount DESC


--find the amount, customer id, first and last name of actors
SELECT [dbo].[customers$].cust_id, [dbo].[actor$].f_name, [dbo].[actor$].l_name,
SUM([dbo].[payment$].amount) AS total_amount
FROM [dbo].[actor$]
JOIN [dbo].[film_actor$] ON [dbo].[actor$].actor_id=[dbo].[film_actor$].actor_id
JOIN [dbo].[inventory$] ON [film_actor$].film_id=inventory$.film_id
JOIN [dbo].[rental$] ON [dbo].[inventory$].inventory_id=[dbo].[rental$].inventory_id
JOIN [dbo].[payment$] ON [dbo].[rental$].rental_id=[dbo].[payment$].rental_id
JOIN [dbo].[customers$] ON [dbo].[payment$].cust_id=[dbo].[customers$].cust_id
GROUP BY [dbo].[customers$].cust_id, [dbo].[actor$].f_name, [dbo].[actor$].l_name
ORDER BY total_amount DESC


--find the country with the largest sales
SELECT [dbo].[country$].country_name, COUNT(*) AS total_cust, SUM([dbo].[payment$].amount) AS total_sales
FROM [dbo].[country$]
JOIN [dbo].[city$] ON [dbo].[country$].country_id=[dbo].[city$].country_id
JOIN [dbo].[address$] ON [dbo].[city$].city_id=[dbo].[address$].city_id
JOIN [dbo].[customers$] ON [dbo].[address$].address_id=[dbo].[customers$].address_id
JOIN [dbo].[payment$] ON [dbo].[customers$].cust_id=[dbo].[payment$].cust_id
GROUP BY country_name
ORDER BY total_cust DESC

--Can we know how many distinct users have rented each genre?
SELECT[dbo].[category$].category_name, COUNT(DISTINCT [dbo].[customers$].cust_id) AS distinct_users
FROM [dbo].[category$]
JOIN [dbo].[film_category$] ON [dbo].[category$].category_id=[dbo].[film_category$].category_id
JOIN [dbo].[film$] ON [film_category$].film_id=[dbo].[film$].film_id
JOIN [dbo].[inventory$] ON [dbo].[film$].film_id=[dbo].[inventory$].film_id
JOIN [dbo].[rental$] ON [dbo].[inventory$].inventory_id=[dbo].[rental$].inventory_id
JOIN [dbo].[customers$] ON [dbo].[rental$].cust_id=[dbo].[customers$].cust_id
GROUP BY category_name
ORDER BY distinct_users DESC

--In which countries do Rent A Film have a presence in and what is the customer base in each country? What are the total sales in each country? (From most to least)
SELECT [dbo].[country$].country_name, COUNT(DISTINCT [dbo].[customers$].cust_id) AS customer_base, SUM([dbo].[payment$].amount) AS total_sales
FROM [dbo].[country$]
JOIN [dbo].[city$] ON [dbo].[country$].country_id=[dbo].[city$].country_id
JOIN address$ ON [dbo].[city$].city_id=address$.city_id
JOIN [dbo].[customers$] ON address$.address_id=[dbo].[customers$].address_id
JOIN [dbo].[payment$] ON [dbo].[customers$].cust_id=[dbo].[payment$].cust_id
GROUP BY [dbo].[country$].country_name
ORDER BY customer_base DESC


--Who are the top 5 customers per total sales and can we get their details just in case Rent A Film wants to reward them?
WITH F1 AS(
SELECT *, CONCAT(f_name,' ',l_name) AS names
FROM [dbo].[customers$]
)
SELECT names, email, [dbo].[address$].address1, [dbo].[address$].phone, [dbo].[city$].city_name, [dbo].[country$].country_name, 
SUM([dbo].[payment$].amount) AS total_sales
FROM [dbo].[country$]
JOIN [dbo].[city$] ON [dbo].[country$].country_id=[dbo].[city$].country_id
JOIN [dbo].[address$] ON [dbo].[city$].city_id=[dbo].[address$].city_id
JOIN F1 ON  [dbo].[address$].address_id=F1.address_id
JOIN [dbo].[payment$] ON F1.cust_id=[dbo].[payment$].cust_id
GROUP BY names, email,[dbo].[address$].address1, [dbo].[address$].phone, [dbo].[city$].city_name, [dbo].[country$].country_name
ORDER BY total_sales DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY 

--Identify the top 10 customers and their email so we can reward them
ALTER TABLE [dbo].[customers$]
ADD full_name VARCHAR(200)

UPDATE [dbo].[customers$]
SET full_name = CONCAT(f_name,' ',l_name)

SELECT full_name, email, SUM([dbo].[payment$].amount) AS total_spent
FROM [dbo].[customers$]
JOIN [dbo].[payment$] ON [dbo].[customers$].cust_id=[dbo].[payment$].cust_id
GROUP BY full_name, email
ORDER BY total_spent DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY 

--Identify the bottom 10 customers and their emails
SELECT full_name, email, SUM([dbo].[payment$].amount) AS total_spent
FROM [dbo].[customers$]
JOIN [dbo].[payment$] ON [dbo].[customers$].cust_id=[dbo].[payment$].cust_id
GROUP BY full_name ,email
ORDER BY total_spent 
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY 


--What are the most profitable movie genres (ratings)?
SELECT[dbo].[category$].category_name, 
COUNT([dbo].[customers$].cust_id) AS cust_demand,
SUM(payment$.amount) AS total_sales
FROM [dbo].[category$]
JOIN [dbo].[film_category$] ON [dbo].[category$].category_id=[dbo].[film_category$].category_id
JOIN [dbo].[film$] ON [film_category$].film_id=[dbo].[film$].film_id
JOIN [dbo].[inventory$] ON [dbo].[film$].film_id=[dbo].[inventory$].film_id
JOIN [dbo].[rental$] ON [dbo].[inventory$].inventory_id=[dbo].[rental$].inventory_id
JOIN [dbo].[customers$] ON [dbo].[rental$].cust_id=[dbo].[customers$].cust_id
JOIN payment$ ON [dbo].[rental$].rental_id=[dbo].[payment$].rental_id
GROUP BY [dbo].[category$].category_name
ORDER BY cust_demand DESC

--How many rented movies were returned late, early, and on time?
WITH A AS (SELECT *, DATEPART(DAY, return_date-rental_date) AS date_diff
FROM [dbo].[rental$]),
B AS (SELECT rental_duration,date_diff,
CASE 
WHEN rental_duration>date_diff THEN 'early'
WHEN rental_duration=date_diff THEN 'on_time'
ELSE 'late'
END AS time_of_return
FROM [dbo].[film$]
JOIN [dbo].[inventory$] ON [dbo].[film$].film_id=[dbo].[inventory$].film_id
JOIN A ON [dbo].[inventory$].inventory_id=A.inventory_id)
SELECT time_of_return, COUNT(*) AS total_films
FROM B
GROUP BY time_of_return
ORDER BY total_films DESC


--What is the customer base in the countries where we have a presence?
SELECT country_name, COUNT(cust_id) AS total_cust
FROM [dbo].[country$]
JOIN [dbo].[city$] ON [dbo].[country$].country_id=[dbo].[city$].country_id
JOIN [dbo].[address$] ON [dbo].[city$].city_id=[dbo].[address$].city_id
JOIN [dbo].[customers$] ON [dbo].[address$].address_id=[dbo].[customers$].address_id
GROUP BY country_name
ORDER BY total_cust DESC


--Which country is the most profitable for the business?
SELECT country_name, COUNT(*) AS total_cust, SUM(payment$.amount) AS total_sales
FROM [dbo].[country$]
JOIN [dbo].[city$] ON [dbo].[country$].country_id=[dbo].[city$].country_id
JOIN [dbo].[address$] ON [dbo].[city$].city_id=[dbo].[address$].city_id
JOIN [dbo].[customers$] ON [dbo].[address$].address_id=[dbo].[customers$].address_id
JOIN [dbo].[payment$] ON [dbo].[customers$].cust_id=[dbo].[payment$].cust_id
GROUP BY country_name
ORDER BY total_sales DESC


--What is the average rental rate per movie genre (rating)?
SELECT [dbo].[category$].category_name, ROUND(AVG([dbo].[film$].rental_rate),2) AS avg_rental_rate
FROM [dbo].[category$]
JOIN [dbo].[film_category$] ON [dbo].[category$].category_id=[dbo].[film_category$].category_id
JOIN [dbo].[film$] ON [dbo].[film_category$].film_id=[dbo].[film$].film_id
GROUP BY [dbo].[category$].category_name
ORDER BY avg_rental_rate DESC