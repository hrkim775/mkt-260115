/*
1. comedy, sports, family 카테고리의 category_id 아이디를 찾아서 카테고리명과 아이디를 같이 출력
*/

SELECT * FROM category LIMIT 10;
SELECT * FROM customer LIMIT 10;

SELECT category_id, name
FROM category
WHERE name = "Comedy" OR name = "Sports" OR name = "Family";

SELECT category_id, name
FROM category
WHERE name IN ("Comedy", "Sports", "Family");


/*
2. film_category 테이블 안에서 film_id가 2인 영화의 카테고리 아이디를 조회해서 출력
*/

SELECT * FROM film_category LIMIT 10;

SELECT film_id, category_id
FROM film_category
WHERE film_id = 2;


/*
3. film_category 테이블에서 카테고리 id별 영화 수 조회
*/

SELECT * FROM film_category LIMIT 10;

SELECT category_id, count(*) 
FROM film_category
GROUP BY category_id;


/*
4. 카테고리가 코메디 영화의 갯수 조회하고 출력
*/

SELECT COUNT(*) Comedy_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
WHERE name = "Comedy";


-- 같은 문제를 서브쿼리 구문으로 해결
SELECT COUNT(*) Comedy_count
FROM film_category
WHERE category_id IN (
	SELECT category_id FROM category
	WHERE name = "Comedy"
);

/*
5. 코메디, 스포츠, 패밀리 각각의 카테고리별 영화 갯수 조회, 출력
*/

SELECT name, COUNT(*) film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY name
HAVING name = "Comedy" OR name = "Sports" OR name = "Family";


-- 서브쿼리 이용
SELECT c.name, COUNT(*) film_count
FROM (
	SELECT category_id, name
	FROM category c
	WHERE name IN ("Comedy", "Sports", "Family")
) C
JOIN film_category fc USING (category_id)
GROUP BY c.category_id, c.name;


-- 상관서브쿼리 이용
SELECT c.name,
	(
		SELECT COUNT(*)
        FROM film_category f
        WHERE c.category_id = f.category_id
    ) film_count
FROM category c
WHERE c.name IN ("Comedy", "Sports", "Family");



/*
6. 카테고리별 영화의  수가 70 이상인 카테고리명을 조회하고 출력
*/

SELECT * FROM category LIMIT 10;
SELECT * FROM film LIMIT 10;
SELECT * FROM film_category LIMIT 10;

SELECT C.name, COUNT(*) category_count
FROM category C
JOIN film_category F USING (category_id)
GROUP BY C.category_id
HAVING category_count >= 70;



/*
7. 각 카테고리별 영화 렌탈 횟수 조회, 출력
*/

SELECT * FROM category LIMIT 10; -- category_id
SELECT * FROM rental LIMIT 10; -- rental_id, inventory_id, customer_id
SELECT * FROM film_category LIMIT 10; -- film_id, category_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id

SELECT 
	C.name,
    COUNT(*) rental_count
FROM category C
JOIN film_category F USING (category_id)
JOIN inventory I USING (film_id)
JOIN rental R USING (inventory_id)
GROUP BY category_id
ORDER BY rental_count DESC;

