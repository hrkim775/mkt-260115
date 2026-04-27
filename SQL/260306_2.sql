-- rental & inventory 테이블을 join하고 film테이블에 잇는 replacment_cost가 20달러 이상인 영화를 대여한 고객의 이름을 찾아서 출력. 단 고객의 이름은 소문자로 
SHOW TABLES;
SELECT  * FROM customer LIMIT 10; # 고객데이터 / customer_id
SELECT  * FROM rental LIMIT 10; # 렌탈정보 / customer_id, inventory_id, rental_id
SELECT  * FROM inventory LIMIT 10; # 재고관련정보 / film_id, inventory_id
SELECT  * FROM film LIMIT 10; # 영화정보 / film_id


SELECT 
	F.replacement_cost,
    C.first_name,
    C.last_name,
    LOWER(CONCAT(first_name," ", last_name)) full_name
FROM customer C
JOIN rental R ON C.customer_id = R.customer_id
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE F.replacement_cost > (
		SELECT 
		F.replacement_cost
	FROM customer C
	JOIN rental R ON C.customer_id = R.customer_id
	JOIN inventory I ON R.inventory_id = I.inventory_id
	JOIN film F ON I.film_id = F.film_id
	WHERE F.replacement_cost > 20
);


-- 정답
SELECT 
    C.first_name,
    C.last_name,
	LOWER(CONCAT(first_name," ", last_name)) full_name
FROM customer C
JOIN rental R ON C.customer_id = R.customer_id
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE F.replacement_cost > 20;



/*
영화 등급이 PG-13인 영화들 중, 영화의 설명문구의 길이가 평균이상(평균: 동일한 등급 속에 속해있는 영화들의 설명문구)인 영화들의 제목만 찾아서 출력해주세요
*/

SELECT  * FROM film LIMIT 10;

SELECT rating FROM film;


SELECT  
    title
FROM film
WHERE rating = "PG-13"
AND LENGTH(description) > (
	SELECT AVG(description)
    FROM film
);

SELECT  
    title
FROM film
WHERE rating = "PG-13"
AND LENGTH(description) > (
	SELECT AVG(LENGTH(description))
	FROM film
	WHERE rating = "PG-13"
    );
    
    
/*
2005년 8월에 대여된 모든 DVD 중 "R" 등급에 해당하는 영화만 추출해서 해당 영화들의 제목과 그 영화를 대여한 고객들의 이메일을 찾아서 출력해주세요
*/ 

SELECT  * FROM film LIMIT 10; -- 등급, 영화제목 / film_id, language_id, 
SELECT  * FROM rental LIMIT 10; -- rental_id, customer_id
SELECT  * FROM customer LIMIT 10; -- 이메일 / customer_id, store_id, address_id
SELECT  * FROM inventory LIMIT 10; # 재고관련정보 / film_id, inventory_id


-- 정석문법
SELECT 
	F.title, C.email
FROM customer C
JOIN rental R ON C.customer_id = R.customer_id
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE
	MONTH(R.rental_date) = 8
    AND YEAR(R.rental_date) = 2005
    AND F.rating = "R";
    
    
-- 실무문법
SELECT 
	F.title, C.email
FROM customer C
JOIN rental R USING(customer_id) -- 축약문법 : 어차피 동일한 요소로 연결되기 때문에 이렇게 축약해서 사용해도된다
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
WHERE
	MONTH(R.rental_date) = 8
    AND YEAR(R.rental_date) = 2005
    AND F.rating = "R";
    
    
/*
각 고객별 가장 마지막에 결제한 날짜에서 30일 이전까지의 모든 결제 내역을 찾고 해당 결제내역에 대해 총 결제 금액에 합과 평균 결제금액의 평균값을 소수점 둘째 자리에서 반올림해서 출력해주세요
1) 고객별로 GROUP BY로 묶는다
2) 마지막에 결제한 날짜를 찾는다 -> 결제한 날 중에서 가장 큰 값(MAX)
3) 날짜를 찾았다면, 30일 이전까지의 결제 내역을 찾는다 -> DATE_SUB(date, INTERVAL unit) : 특정기간 앞으로
4) 찾은 결제 내역의 금액을 모두 합한다 -> SUM
5) 찾은 결제 내역의 평균값을 구한다 -> AVG
6) 평균 값을 소수점 둘째 자리에서 반올림한다 -> ROUND(number, decimals)
*/ 

SELECT  * FROM customer LIMIT 10; -- 이메일 / customer_id, store_id, address_id
SELECT  * FROM payment LIMIT 10; # last_update, amount / customer_id

SELECT 
	customer_id,
    ROUND(SUM(amount), 1),
    ROUND(AVG(amount), 1)
FROM payment
WHERE payment_date >= DATE_SUB(
	(SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY
)
GROUP BY customer_id;


/*
영화 장르 중 공상과학영화 장르에 출연한 영화배우의 이름을 찾아서 출력해주세요. 출력시 배우의 이름은 성과 이름을 연결해서 대문자로 출력해주세요
*/ 
SHOW TABLES;
SELECT  * FROM film; 
SELECT  * FROM actor LIMIT 10; 

SELECT
	UPPER(CONCAT(first_name," ", last_name)) full_name
FROM actor A
JOIN film_actor USING(actor_id)
JOIN film_category USING(film_id)
JOIN category USING(category_id)
WHERE name = 'Sci-Fi';



