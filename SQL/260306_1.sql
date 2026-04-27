/*
서브쿼리 : 어떤 쿼리문을 작성하는데 있어서 필요한 자료를 독립적으로 취합함으로서 전체 쿼리문의 가독성을 높여주는 문법 (연결성x, 독립적) 내부 쿼리문 작성 시, 독립적으로 쿼리문을 작성한다
상관서브쿼리 : 쿼리문안에 별도의 쿼리문 (쿼리문들이 연결되어있다 -> 쿼리문 안에 쿼리문이 있는데 안에 있는 쿼리문이 밖에 있는 쿼리문의 내용을 참조한다)
*/


-- 각 고객이 그 동안 결제한 평균 금액보다 큰 금액으로 결제한 정보 찾기
USE sakila;
SHOW TABLES;
SELECT * FROM payment LIMIT 10;


SELECT 
	p1.customer_id, p1.amount, p1.payment_date
FROM payment p1
WHERE p1.amount > (
	SELECT AVG(amount)
	FROM payment p2
	WHERE p2.customer_id = p1.customer_id
);


-- film테이블에서 영화 길이의 평균값을 구해서 해당 영화 길이보다 영화들의 제목을 찾아주세요 (서브쿼리)
SELECT title, length 
FROM film 
WHERE length > (
	SELECT
		AVG(length)
    FROM film
);


-- rental테이블에서 고객별 평균 대여 횟수보다 더 많은 대여를 한 고객들의 이름을 찾아주세요 (상관서브쿼리)
SELECT  * FROM customer LIMIT 10;
SELECT  * FROM rental LIMIT 10;

SELECT 
	first_name, 
    last_name,
    CONCAT(first_name," ", last_name) full_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > (
		SELECT AVG(rental_count)
		FROM (
			SELECT COUNT(*) rental_count
			FROM rental
			GROUP BY customer_id
		) rental_counts
    )
);


-- 가장 많은 영화를 대여한 고객의 이름을 찾아보세요
-- 테이블의 컬럼들을 확인한다

SELECT  * FROM customer LIMIT 10; # 고객데이터
SELECT  * FROM rental LIMIT 10; # 렌탈정보

SELECT 
	first_name,
    last_name,
    CONCAT(first_name," ", last_name) full_name
FROM customer
WHERE  customer_id = (
	SELECT MAX(customer_id) 
    FROM rental
);

SELECT
	CONCAT(first_name," ", last_name) full_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM (
	SELECT customer_id, COUNT(*) rental_count
	FROM rental
	GROUP BY customer_id
	ORDER BY rental_count DESC
	LIMIT 1
	) t
);


-- 각 고객별 자신이 대여한 영화들의 평균 상영시간보다 긴 영화제목들을 찾아주세요
-- 고객별로 데이터가 나와야하니까 상관서브쿼리 사용
-- 1) 고객별로 묶는다
-- 2) 대여한 영화들의 상영시간을 확인한다
-- 3) 상영시간들의 평균을 구한다
-- 4) 구한 값보다 큰 값을 가진 영화들을 찾는다

SHOW TABLES;
SELECT  * FROM customer LIMIT 10; # 고객데이터 / customer_id
SELECT  * FROM rental LIMIT 10; # 렌탈정보 / customer_id, inventory_id, rental_id
SELECT  * FROM inventory LIMIT 10; # 재고관련정보 / film_id, inventory_id
SELECT  * FROM film LIMIT 10; # 영화정보 / film_id


SELECT 
	C.first_name,
    C.last_name,
    F.title
FROM customer C
JOIN rental R ON C.customer_id = R.customer_id
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE F.length > (
		SELECT AVG(F.length)
		FROM customer CUS
		JOIN rental REN ON CUS.customer_id = REN.customer_id
		JOIN inventory INV ON REN.inventory_id = INV.inventory_id
		JOIN film FIL ON INV.film_id = FIL.film_id
        WHERE CUS.customer_id = REN.customer_id
);