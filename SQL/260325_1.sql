/*
[오늘의 미션] 3/25

sakila DB > 상대적으로 가장 최근에 영화를 반납한 상위 10명의 고객 이름과 해당 고객이 대여한 영화의 이름, 그리고 대여기간을 출력해주세요. (고객이름은 customer_name, 영화이름은 movie_title, 대여기간은 rental_duration으로 출력해주세요)
sakila DB > 각 직원별 달성한 매출을 찾고, 각 직원이 달성한 매출이 회사 전체 매출 중 어느 정도 비율을 차지하는지 찾아주세요. 결과값은 직원ID, 직원이름, 각 직원의 매출, 회사 전체 매출에 대한 비율(%)로 보여주세요
*/

USE sakila;


-- 상대적으로 가장 최근에 영화를 반납한 상위 10명의 고객 이름과 해당 고객이 대여한 영화의 이름, 그리고 대여기간을 출력해주세요. (고객이름은 customer_name, 영화이름은 movie_title, 대여기간은 rental_duration으로 출력해주세요)

SELECT * FROM rental LIMIT 10; -- retal_date, rental_id, customer_id, inventory_id
SELECT * FROM customer LIMIT 10; -- name, customer_id, store_id
SELECT * FROM film LIMIT 10; -- rental_duration, title, film_id
SELECT * FROM inventory LIMIT 10; -- inventory_id, film_id, store_id

SELECT 
	CONCAT(C.first_name, " ", C.last_name) customer_name,
    F.title movie_title,
    F.rental_duration rental_duration
FROM customer C
JOIN rental R USING (customer_id)
JOIN inventory I USING (inventory_id)
JOIN film F USING (film_id)
ORDER BY R.return_date DESC LIMIT 10;


-- 각 직원별 달성한 매출을 찾고, 각 직원이 달성한 매출이 회사 전체 매출 중 어느 정도 비율을 차지하는지 찾아주세요. 결과값은 직원ID, 직원이름, 각 직원의 매출, 회사 전체 매출에 대한 비율(%)로 보여주세요
SELECT * FROM staff;
SELECT * FROM payment LIMIT 10; -- patment_id, staff_id, rental_id, customer_id






SELECT 
	staff_id,
    CONCAT(first_name, " ", last_name) staff_name,
    SUM(amount) staff_total_amount
FROM payment
JOIN staff USING (staff_id)
GROUP BY staff_id
ORDER BY total_amount DESC;




