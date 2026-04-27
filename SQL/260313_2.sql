USE sakila;

-- 한 번도 대여되지 않은 영화 찾기
SELECT * FROM inventory LIMIT 10;
SELECT * FROM rental LIMIT 10;

SELECT 
	F.film_id,
	F.title
FROM film F
JOIN inventory I USING (film_id)
LEFT JOIN rental R USING(inventory_id)
WHERE R.rental_id IS NULL
GROUP BY F.title, F.film_id;


-- 고객별 누적 결제금액을 등급 분류 & 등급별 상위 3명씩만 조회.출력
-- 총 결제액 100이상 : VIP / 100미만 50이하 : GOLD / 50미만 : SILVER

SELECT * FROM customer LIMIT 10;
SELECT * FROM payment LIMIT 10;

SELECT 
	CONCAT(C.first_name, " ", C.last_name) full_name,
    SUM(P.amount) total_payment,
    CASE
		WHEN SUM(P.amount) >= 100 THEN "VIP"
        WHEN SUM(P.amount) >= 50 THEN "GOLD"
        ELSE "SILVER"
	END grade
FROM customer C
JOIN payment P USING (customer_id)
GROUP BY C.customer_id;




-- 상위 몇명 구하기
-- 어떤 값을 조회, 기본 베이스를 만들어놓고, 해당 베이스를 기반으로 비교한다 (서브쿼리)


SELECT
	T.customer_id,
    T.full_name,
    T.total_payment,
    T.grade,
    (
		SELECT COUNT(*)
        FROM (
			SELECT
				C.customer_id,
                SUM(P.amount) total_payment,
                CASE
					WHEN SUM(P.amount) >= 100 THEN "VIP"
                    WHEN SUM(P.amount) >= 50 THEN "GOLD"
                    ELSE "SILVER"
                END grade
            FROM customer C
            JOIN payment P USING(customer_id)
            GROUP BY C.customer_id
        ) T2
        WHERE T2.grade = T.grade AND T2.total_payment > T.total_payment
    ) + 1 grade_rank -- 값을 비교하면서 순위를 매겨야하니까 비교한 값이 나보다 크면 +1을 해준다
FROM (
	SELECT 
		C.customer_id,
		CONCAT(C.first_name, " ", C.last_name) full_name,
		SUM(P.amount) total_payment,
		CASE
			WHEN SUM(P.amount) >= 100 THEN "VIP"
			WHEN SUM(P.amount) >= 50 THEN "GOLD"
			ELSE "SILVER"
		END grade
	FROM customer C
	JOIN payment P USING (customer_id)
	GROUP BY C.customer_id
) T
HAVING grade_rank <= 3
ORDER BY grade, grade_rank;



