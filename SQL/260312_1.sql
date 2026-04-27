/*
8. 코미디, 스포츠, 패밀리 카테고리에 해당되는 영화들의 렌탈 횟수를 조회, 출력
출력시 카테고리 이름, 렌탈횟수 출력되어야한다
*/

USE sakila;
SHOW TABLES;

SELECT * FROM category LIMIT 10; -- category_id
SELECT * FROM rental LIMIT 10; -- rental_id, inventory_id, customer_id
SELECT * FROM film_category LIMIT 10; -- film_id, category_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id
SELECT * FROM film LIMIT 10; -- film_id, language_id, original_language_id


SELECT 
	C.name,
	COUNT(*) rental_count
FROM category C
JOIN film_category F USING (category_id)
JOIN inventory I USING (film_id) 
JOIN rental R USING (inventory_id)
GROUP BY category_id
HAVING name = "Comedy" OR name = "Sports" OR name = "Family"
ORDER BY rental_count DESC; 


SELECT 
	C.name,
	COUNT(*) rental_count
FROM category C
JOIN film_category F USING (category_id)
JOIN inventory I USING (film_id) 
JOIN rental R USING (inventory_id)
WHERE name IN ("Comedy", "Sports",  "Family")
GROUP BY category_id
ORDER BY rental_count DESC; 


/*
9. 코메디 카테고리인 영화들의 렌탈 횟수를 조회, 출력 (서브쿼리로)
*/

SELECT
	name,
    COUNT(*) Comedy_count
FROM category 
WHERE name IN (
	SELECT name
	FROM category 
	WHERE name = "Comedy"
);

SELECT COUNT(*)
FROM rental
WHERE inventory_id IN (
	SELECT inventory_id
	FROM inventory
	WHERE fime_id IN(
		SELECT fime_id FROM film_category
		WHERE category_id IN (
			SELECT category_id FROM category
			WHERE name = "Comedy"
)
)
);


/*
10. 코메디 카테고리 영화의 갯수를 조회, 추력해주세요 (INNER JOIN으로)
*/

SELECT name, COUNT(*)
FROM film_category
JOIN category USING (category_id)
WHERE name = "Comedy";


/*
11. address 테이블에는 address_id가 존재하지만, customer 테이블에는 address_id가 존재하지 않는 데이터의 갯수를 출력해주세요 
*/

SELECT * FROM address LIMIT 10;
SELECT * FROM customer LIMIT 10;

SELECT 
	COUNT(*)
FROM customer C
RIGHT JOIN address A USING(address_id)
WHERE customer_id IS NULL;


/*
12. 캐나다 고객들에게 이메일을 활용한 CRM마케팅을 진행하려고 합니다 캐나다 지역의 고객들의 이름, 이메일주소가 필요합니다 각 테이블을 조회 후 출력해주세요
*/
SELECT * FROM address LIMIT 10; -- address_id
SELECT * FROM customer LIMIT 10; -- address_id, city_id
SELECT * FROM country; -- country_id
SELECT * FROM city LIMIT 10; -- country_id, city_id


SELECT
	customer_id,
	CONCAT(first_name, " ", last_name) full_name,
    email
FROM customer 
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id)
WHERE country = 'Canada'
GROUP BY customer_id;