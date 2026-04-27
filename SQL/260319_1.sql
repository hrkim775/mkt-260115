USE sakila;

/*
18. 영화 Alone Trip에 출현하는 배우들의 이름을 모두 출력해주세요 (서브쿼리로 문제를 해결해주세요)
*/

SELECT * FROM film LIMIT 10; -- film_id
SELECT * FROM actor LIMIT 10; -- actor_id
SELECT * FROM film_actor LIMIT 10; -- film_id, actor_id


-- SELECT 
-- 	title,
--     full_name
-- FROM film
-- SELECT
-- 	CONCAT(first_name, " ", last_name) full_name
-- FROM actor


SELECT 
	CONCAT(first_name, " ", last_name) full_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
	)
);

/*
19. 2005년 8월 한달간 발생된 매출에 한대서, 매출을 발생시킨 스텝의 이름과 해당 스텝이 발생시킨 매출의 데이터를 조회해서 출력해주세요
*/
SELECT * FROM staff;
SELECT * FROM payment LIMIT 10; -- patment_id, staff_id, rental_id, customer_id

SELECT 
	CONCAT(first_name, " ", last_name) staff_name,
    SUM(amount) total_amount
FROM payment
JOIN staff USING (staff_id)
WHERE YEAR(payment_date) = 2005 AND MONTH(payment_date) = 8
GROUP BY staff_id
ORDER BY total_amount DESC;


/*
20. 각 영화 장르별 평균 러닝타임이 존재하는데, 해당 장르별 러닝타임이 모든 장르를 통합했을때의 평균 러닝타임보다 큰 경우에 한해 해당 장르와 상영시간을 조회 및 출력하세요
*/
SELECT * FROM film LIMIT 10; -- film_id
SELECT * FROM film_category LIMIT 10;
SELECT * FROM category LIMIT 10; -- category_id

SELECT
	C.name,
    ROUND(AVG(F.length) ,2) avg_film_length
FROM film F
JOIN film_category FC USING (film_id)
JOIN category C USING (category_id)
GROUP BY C.name
HAVING avg_film_length > (SELECT AVG(length) FROM film)
ORDER BY avg_film_length DESC;

