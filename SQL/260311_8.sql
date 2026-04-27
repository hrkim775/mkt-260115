/*
[오늘의 미션] 3/11

Sakila DB > 한 번도 대여되지 않은 영화 찾기
고객별 누적 결제금액을 등급 분류 & 등급별 상위 3명씩만 조회.출력

총 결제액 100이상 : VIP / 100미만 50이하 : GOLD / 50미만 : SILVER
JOIN (INNER), SubQuery, 상관 SubQuery, WITH, VIEW 어떤 것을 사용해도 무관함!!!
커피를 제공. 동일한 문제를 최대한 다양한 방법으로 해결하신 분께!!!
*/
USE sakila;
SHOW TABLES;

SELECT * FROM category LIMIT 10; -- category_id
SELECT * FROM rental LIMIT 10; -- rental_id, inventory_id, customer_id
SELECT * FROM film_category LIMIT 10; -- film_id, category_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id
SELECT * FROM film LIMIT 10; -- film_id, language_id, original_language_id


-- 한 번도 대여되지 않은 영화 찾기
SELECT 
	C.name,
    COUNT(*) rental_count
FROM category C
JOIN film_category F USING (category_id)
JOIN inventory I USING (film_id)
JOIN rental R USING (inventory_id)
GROUP BY category_id
ORDER BY rental_count DESC;

SELECT 
	F.title,
    COUNT(*) rental_count
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE rental_count < 1
GROUP BY film_id;


SELECT 
	F.title, COUNT(*) rental_count
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY film_id
HAVING rental_count < 1;


-- 고객별 누적 결제금액을 등급 분류 & 등급별 상위 3명씩만 조회.출력
-- 총 결제액 100이상 : VIP / 100미만 50이하 : GOLD / 50미만 : SILVER
-- 분류 후 상위 3명씩 골라야하니까 상관서브쿼리 써야할듯

SELECT * FROM customer LIMIT 10;
SELECT * FROM payment LIMIT 10;

SELECT 
	customer_id,
    SUM(amount) customer_sumamout
FROM customer C
JOIN payment USING(customer_id)
GROUP BY customer_id;


SELECT 
	customer_id,
    SUM(amount) customer_sumamout,
    CASE
		WHEN SUM(amount) BETWEEN 50 AND 100 THEN "SILVER" 
        WHEN SUM(amount) BETWEEN 50 AND 100 THEN "GOLD"
        ELSE "VIP"
	END customer_rate
FROM customer 
JOIN payment USING(customer_id)
GROUP BY customer_id;



SELECT 
	customer_id, 
	customer_sumamout
WHERE customer_sumamout IN 
	(
	SELECT 
		customer_id,
		SUM(amount) customer_sumamout,
		CASE
			WHEN SUM(amount) BETWEEN 50 AND 100 THEN "SILVER" 
			WHEN SUM(amount) BETWEEN 50 AND 100 THEN "GOLD"
			ELSE "VIP"
		END customer_rate
	FROM customer
	JOIN payment USING(customer_id)
	GROUP BY customer_id
) A
FROM customer
GROUP BY customer_rate
ORDER BY DESC LIMIT 3;