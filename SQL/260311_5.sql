/*
CASE WHEN : ~경우 일 때 ~을 실행해라
CASE WHEN절은 항상 끝에 END로 끝나야한다
*/

SELECT * FROM film LIMIT 10;
SELECT title FROM film LIMIT 10;

 
SELECT title,
CASE
	WHEN rental_rate < 1 THEN "Cheap"
    WHEN rental_rate BETWEEN 1 AND 3 THEN "Moderate"
    ELSE "Expensive" -- ELSE는 옵션
END AS price_category -- END는 필수
FROM film;


-- WITH절 활용, 각 등급별 영화 상영시간의 평균길이를 출력하세요

SELECT * FROM film;


WITH avgfilmlength AS (
	SELECT 
		rating,
		AVG(length) film_length
	FROM film
	GROUP BY rating
)
SELECT * FROM avgfilmlength;


-- customer 테이블의 고객별 active 여부에 따라 active 혹은 inactive로 출력되도록 해주세요

SELECT * FROM customer LIMIT 10;

SELECT active,
CASE 
	WHEN active = 0 THEN "inactive"
    WHEN active = 1 THEN "active"
END AS customer_active
FROM customer;


SELECT customer_id,
CASE 
	WHEN active = 0 THEN "inactive"
    ELSE "active"
END AS customer_active
FROM customer;


-- 영화 등급별 평균 대여기간을 WITH 가상 테이블을 활용해서 계산 및 출력해주세요
SELECT * FROM film LIMIT 10;


WITH avgrental_duration AS (
	SELECT 
		rating,
		AVG(rental_duration) avg_duration
	FROM film
	GROUP BY rating
)

SELECT * FROM avgrental_duration;


-- with절을 사용해서 고객별 총 결제액을 계산 후 총 해당 금액 구간에 따라 다음과 같이 카테고리를 분류해주세요
-- 0~50 : LOW / 51~100 MEDIUM / 100~ : HIGT
SHOW TABLES;
SELECT * FROM payment;


WITH customer_pay AS (
	SELECT 
		customer_id,
		SUM(amount) sum_amount
	FROM payment
	GROUP BY customer_id
)
SELECT
	customer_id, sum_amount,
    CASE 
		WHEN sum_amount BETWEEN 0 AND 50 THEN "LOW"
        WHEN sum_amount BETWEEN 50 AND 100 THEN "MEDIUM"
        ELSE "HIGT"
	END payment_status
FROM customer_pay;
