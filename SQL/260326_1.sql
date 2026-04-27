/*
window 함수
그룹 내 연산처리를 하기 위한 목적으로 나온 신 문법

1) RANK() : 특정 컬럼 내 순위를 부여하는 함수 동률이 나오면 동률만큼 숫자를 건너뛴다
> 순위를 부여하는데, 동일한 값이 발생해서 공동 2등이 3명이 나왔다 1등 1명, 2등 3명이면 다음번째 등장하는 사람은 5등이다
2) DENSE_RANK() : 특정 컬럼 내 순위를 부여하는 함수 단, 빠진 순위 없이 모두 매긴다
3) ROW_NUMBER() : 무조건 순번을 지정. 동률의 값이 나오더라도 숫자를 매긴다
*/

USE sakila;
SELECT * FROM film LIMIT 10;

-- title, length
SELECT 
	title, length,
    RANK() OVER (ORDER BY length DESC) ranking, 
    DENSE_RANK() OVER (ORDER BY length DESC) dense_ranking,
    ROW_NUMBER() OVER (ORDER BY length DESC) row_numbers
FROM film
ORDER BY length DESC;


SELECT * FROM customer LIMIT 10;
SELECT * FROM payment LIMIT 10;

SELECT
	C.customer_id,
    CONCAT(C.first_name, " ", C.last_name) customer_name,
    SUM(P.amount) total_amount,
    RANK() OVER (ORDER BY SUM(P.amount) DESC) ranking,
    DENSE_RANK() OVER (ORDER BY SUM(P.amount) DESC) dense_ranking,
    ROW_NUMBER() OVER (ORDER BY SUM(P.amount) DESC) row_numbers
FROM customer C
JOIN payment P USING (customer_id)
GROUP BY C.customer_id;



/* 
PARTITTON : 칸막이. 부분집합을 만들어낸다
UNBOUNDED PRECEDING : 파티션처리가 되어있는 부분 집합(그룹) 내 첫번째 행부터 
UNBOUNDED FOLLOWING : 파티션처리가 되어있는 부분 집합(그룹) 내 마지막행번째까지
CURRENT ROW : 파티션처리가 되어있는 부분 집합(그룹) 내부에 위치한 각각의 값을 순회
n PRECENDING/FOLLOWING : 현재 순회중인 해당 값을 기준으로 N번째 앞 또는 N번째 뒤
*/

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) cumulative_rentals -- WINDOW 함수를 사용하면 그룹을 하지 않아도 COUNT()를 사용할 수 있다
FROM rental;
-- 파티션을 나누고, 아무런 옵션을 주지 않은 상태

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) cumulative_rentals -- 사용자가 전체 이용한 누적 횟수를 알고 싶을때 사용 (토탈 값만 알고 싶을때)
FROM rental;
-- 파티션을 나누고, 나눠진 값들의 토탈 값을 찾음

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_rentals 
FROM rental;
-- 파티션을 나누고, 각각의 값들에 값을주는 것 (1번이랑 값은 같음)


SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) cumulative_rentals 
FROM rental;


SELECT * FROM payment LIMIT 10;

SELECT
	R.customer_id,
    R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_payment_amount, -- 아이디별 합계금액
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) avg_payment_amount, -- 아이디별 평균금액
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) total_payment_amount -- 평균을 기준으로 각각의 값이 얼마나 분산되어있는가 -> 표준편차
FROM rental R
JOIN payment P USING (rental_id)
ORDER BY R.customer_id;



SELECT
	R.customer_id,
    R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date)
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_payment_amount_01, 
    DATE(R.rental_date),
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date)
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_payment_amount_02, 
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) avg_payment_amount, 
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) total_payment_amount 
FROM rental R
JOIN payment P USING (rental_id)
ORDER BY R.customer_id;


# 동일한 파티션으로 구분이 되어있고, 정렬의 기준도 동일하다
# 하지만 각각의 값을 인식하는 관점이 개별적인 행인가(row), 혹은 각 행들의 공통된 그룹부모요소(range)인가에 따라 출력값이 달라질 수 있다
