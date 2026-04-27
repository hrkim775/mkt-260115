/*
[오늘의 미션] 3/12

Sakila DB > 카테고리별 대여횟수 TOP3인 영화 조회.찾기
Sakila DB > 월별 매출에 따른 증감률 구해서.출력 (현재매출 - 전월매출 / 전월매출) * 100

*/
SELECT * FROM category LIMIT 10; -- category_id
SELECT * FROM rental LIMIT 10; -- rental_id, inventory_id, customer_id, staff_id
SELECT * FROM film_category LIMIT 10; -- film_id, category_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id
SELECT * FROM film LIMIT 10; -- film_id, language_id, original_language_id
SELECT * FROM customer LIMIT 10; -- customer_id, store_id, address_id
SELECT * FROM film_text LIMIT 10; -- film_id
SELECT * FROM film_actor LIMIT 10; 
 SELECT * FROM payment LIMIT 10; 



-- 1) Sakila DB > 카테고리별 대여횟수 TOP3인 영화 조회.찾기
SELECT
	I.film_id,
	C.name, 
    COUNT(*) rental_count
FROM category C
JOIN film_category F USING (category_id)
JOIN inventory I USING (film_id) 
JOIN rental R USING (inventory_id)
GROUP BY C.name, I.film_id;



-- 2) 월별 매출에 따른 증감률 구해서.출력 (현재매출 - 전월매출 / 전월매출) * 100
 SELECT * FROM payment LIMIT 10; 
 
 SELECT 
	amount
FROM payment
