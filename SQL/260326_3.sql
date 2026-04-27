/*
[오늘의 미션] 3/26

sakila DB > 고객별 결제 날짜에 따른 누적 결제 금액을 출력. 출력 시, 나타나야 하는 값 : 결제 id, 고객 id, 결제 날짜, 결제 금액, 누적 결제 금액
sakila DB > 영화 등급별 대여기간의 평균을 출력. 출력 시, 나타나야 하는 값 : 영화 id, 등급, 평균대여기간(대여시점 ~ 반납시점)
sakila DB > 각 직원별 대여날짜에 따른 대여횟수, 누적 대여횟수를 구하세요. 출력 시 나타나야 하는 값 : 대여 id, 직원 id, 대여날짜, 대여횟수, 누적 대여횟수
*/


-- 고객별 결제 날짜에 따른 누적 결제 금액을 출력. 출력 시, 나타나야 하는 값 : 결제 id, 고객 id, 결제 날짜, 결제 금액, 누적 결제 금액
USE sakila;

SELECT * FROM customer LIMIT 10; -- customer_id, store_id, name, address_id
SELECT * FROM payment LIMIT 10; -- payment_id, customer_id, rental_id, amount

SELECT
	payment_id,
    customer_id,
    payment_date,
    amount,
	SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_payment_amount
FROM payment;


-- 영화 등급별 대여기간의 평균을 출력. 출력 시, 나타나야 하는 값 : 영화 id, 등급, 평균대여기간(대여시점 ~ 반납시점)

SELECT * FROM rental LIMIT 10;
SELECT * FROM film LIMIT 10;
SELECT * FROM inventory LIMIT 10;

SELECT
	F.film_id,
    F.rating,
    AVG(rental_date) OVER (PARTITION BY rating ORDER BY rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) avg_rental_date
FROM rental R
JOIN inventory I USING (inventory_id)
JOIN film F USING (film_id);


-- 각 직원별 대여날짜에 따른 대여횟수, 누적 대여횟수를 구하세요. 출력 시 나타나야 하는 값 : 대여 id, 직원 id, 대여날짜, 대여횟수, 누적 대여횟수

SELECT * FROM rental LIMIT 10; -- rental_id, inventory_id, customer_id
SELECT * FROM staff LIMIT 10; -- staff_id, address_id, store_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id
SELECT * FROM payment LIMIT 10; -- payment_id, customer_id, rental_id, amount

SELECT 
	R.rental_id,
    S.staff_id,
    R.rental_date,
	SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_payment_amount
FROM rental R
JOIN inventory I USING (inventory_id)
JOIN staff S USING (store_id);