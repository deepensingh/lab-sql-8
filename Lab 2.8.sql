-- Lab | SQL Join (Part II)
-- In this lab, you will be using the Sakila database of movie rentals.
Use Sakila;

-- Instructions
-- Write a query to display for each store its store ID, city, and country.
Select * from Sakila.store;

SELECT store_id, city, country FROM store s
JOIN address a
ON (s.address_id=a.address_id)
JOIN city c 
ON (a.city_id=c.city_id)
JOIN country ct 
ON (c.country_id=ct.country_id);

-- Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) AS 'Total Revenue $ ' 
FROM payment p
JOIN staff s 
ON (p.staff_id = s.staff_id)
GROUP BY (store_id);


-- Which film categories are longest? SPORTS 
-- " By using clause"

select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
having avg(length) > (select avg(length) from film)
order by avg(length) desc;


-- Display the most frequently rented movies in descending order.

select fm.title as 'Movie', count(r.rental_date) as "Frequent Rented Movies"
from film as fm
join inventory as i 
on (i.film_id = fm.film_id)
join rental as r 
on (r.inventory_id = i.inventory_id)
group by fm.title
order by count(r.rental_date) desc;

-- List the top five genres in gross revenue in descending order.
select c.name as 'Top 5 Genres', sum(p.amount) as 'By Category Gross Revenue'
from category as c
join film_category as fc on fc.category_id = c.category_id
join inventory as i
on i.film_id = fc.film_id
join rental as r 
on r.inventory_id = i.inventory_id
join payment as p 
on p.rental_id = r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?

SELECT i.store_id, fm.title, i.inventory_id
FROM sakila.film fm
JOIN sakila.inventory i USING(film_id)
Having fm.title = 'Academy Dinosaur' and i.store_id = 1;


-- Get all pairs of actors that worked together.
SELECT fa.film_id, f.title, concat(a.first_name, ":-:", a.last_name) AS 'Actor worked Together'
FROM sakila.actor a
RIGHT JOIN sakila.film_actor fa USING(actor_id)
JOIN sakila.film f USING(film_id);


-- Get all pairs of customers that have rented the same film more than 3 times.
SELECT c.first_name, c.last_name, COUNT(DISTINCT(r.rental_id))
FROM sakila.customer c
JOIN sakila.rental r USING (customer_id)
GROUP BY c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 3
ORDER BY COUNT(DISTINCT(r.rental_id)) DESC;



-- For each film, list actor that has acted in more films.
SELECT count(film_actor.actor_id) AS "Actor Acted in more than one movie" , Concat(actor.first_name,  " ", actor.last_name) As "Actor_Name"
FROM actor
INNER JOIN film_actor 
ON (actor.actor_id = film_actor.actor_id)
GROUP BY film_actor.actor_id;

