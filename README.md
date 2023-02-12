# DVD-rental-analysis
Microsoft SQL server
The database DvdRental has 15 tables. Below are the different tables and a brief description of them.
●	actor — contains actors data including first name and last name.
●	film — contains films data such as title, release year, length, rating, etc.
●	film_actor — contains the relationships between films and actors.
●	category — contains film’s categories data.
●	film_category — containing the relationships between films and categories.
●	store — contains the store data including manager staff and address.
●	inventory — stores inventory data.
●	rental — stores rental data.
●	payment — stores customer’s payments.
●	staff — stores staff data.
●	customer — stores customer’s data.
●	address — stores address data for staff and customers
●	city — stores the city names.
●	country — stores the country names.

QUESTIONS
●	As a data analyst, explain how the result of the queries you wrote is going to help the company.
●	Curate more insights that would improve rentals in the company
1.	Write a SQL query to find those actors whose last name is 'Allen' and the last name is 'Allen'. Return actor ID
2.	When was the movie made by Angelina Astaire last updated?
3.	list the description for all movies that starts with ‘B’
SELECT description
FROM film
WHERE film_title LIKE %B
4.	What address id has null second address?
5.	List the postal code, address, and phone numbers of districts that starts with ‘K’
SELECT postal_code, address1, phone
FROM address
WHERE district LIKE %K
6.	Find the amount generated from each film
7.	find the amount, customer id, first and last name of actors
8.	find the country with the largest sales
9.	Can we know how many distinct users have rented each genre?
10.	In which countries do Rent A Film have a presence in and what is the customer base in each country? What are the total sales in each country? (From most to least)
SELECT country
11.	Who are the top 5 customers per total sales and can we get their details just in case Rent A Film wants to reward them?
12.	Identify the top 10 customers and their email so we can reward them
13.	Identify the bottom 10 customers and their emails
14.	What are the most profitable movie genres (ratings)? 
15.	How many rented movies were returned late, early, and on time?
16.	What is the customer base in the countries where we have a presence?
17.	Which country is the most profitable for the business?
18.	What is the average rental rate per movie genre (rating)?
