/*
window 함수
그룹 내 연산처리를 하기 위한 목적으로 나온 신 문법

1) RANK() : 특정 컬럼 내 순위를 부여하는 함수 동률이 나오면 동률만큼 숫자를 건너뛴다
> 순위를 부여하는데, 동일한 값이 발생해서 공동 2등이 3명이 나왔다 1등 1명, 2등 3명이면 다음번째 등장하는 사람은 5등이다
2) DENSE_RANK() : 특정 컬럼 내 순위를 부여하는 함수 단, 빠진 순위 없이 모두 매긴다
3) ROW_NUMBER() : 무조건 순번을 지정. 동률의 값이 나오더라도 숫자를 매긴다
*/

/* 
PARTITTON : 칸막이. 부분집합을 만들어낸다
UNBOUNDED PRECEDING : 파티션처리가 되어있는 부분 집합(그룹) 내 첫번째 행부터 
UNBOUNDED FOLLOWING : 파티션처리가 되어있는 부분 집합(그룹) 내 마지막행번째까지
CURRENT ROW : 파티션처리가 되어있는 부분 집합(그룹) 내부에 위치한 각각의 값을 순회
n PRECENDING/FOLLOWING : 현재 순회중인 해당 값을 기준으로 N번째 앞 또는 N번째 뒤

동일한 파티션으로 구분이 되어있고, 정렬의 기준도 동일하다
하지만 각각의 값을 인식하는 관점이 개별적인 행인가(row), 혹은 각 행들의 공통된 그룹부모요소(range)인가에 따라 출력값이 달라질 수 있다
*/

/*
집계 함수의 대표 : SUM() -> 특정 컬럼 안에 있는 값을 모두 더하기 위한 함수
SUM() OVER() : 값을 모두 더할 뿐만 아니라 각각의 컬럼에 그 값을 넣는다
LEAD() : 특정 열을 기준으로 N번째 뒤에 있는 값을 가져올 때 사용
LAG() : 특정 열을 기준으로 N번째 앞에 있는 값을 가져올 때 사용
FIRST_VALUE() : 특정 열 안에 파티션 된 요소 안에서 첫번째 값을 가져올 때 사용 
LSAT_VALUE() : 특정 열 안에 파티션 된 요소 안에서 마지막번째 값을 가져올 때 사용 
DATEDIFF() : 서로 다른 2개 날짜의 갭 차이를 확인하고자 할 때
PERCENT_RANK() : 각 행의 백분위 순위를 계산할 때 사용. 0 ~ 1 사이로 표현 (전체중에 몇 %에 해당 되냐) -> 몇 번째냐를 보려고 하는게 아니라, 전체를 기준으로 몇 번째 구간(위치)에 도달해있는가를 본다
CUME_DIST() : 각 행의 누적분포를 계산. 0 ~ 1 사이로 표현 -> CUMULATIVE(누적된) DISTRIBUTION(본포)
NTILE() : 각 행을 N개의 그룹으로 분할, 각 그룹에는 거의 같은 수가 분포되게 맞춘다
*/

WITH genres_revenue AS (
	SELECT
		C. name genre,
        SUM(P.amount) revenue
    FROM payment P
		JOIN rental R USING (rental_id)
		JOIN inventory I USING (inventory_id)
		JOIN film f ON I.film_id = F.film_id
		JOIN film_category FC ON F.film_id = FC.film_id
		JOIN category C USING (category_id)
	GROUP BY C.name
)
SELECT
	genre, revenue,
    SUM(revenue) OVER(
		ORDER BY revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) cumulative_revenue,
    revenue / SUM(revenue) OVER() revenue_ratio -- OVER() 에 아무 값도 주지 않으면 전체값이라는 뜻
FROM genres_revenue
ORDER BY revenue DESC;



SELECT
	rental_id,
    rental_date,
    LAG(rental_id, 1, 0) OVER (ORDER BY rental_date) prev_rental, -- 기본 디폴트 값은 0이다
    LEAD(rental_id, 1, 0) OVER (ORDER BY rental_date) next_rental
FROM rental;


SELECT
	rental_id,
    rental_date,
    LAG(rental_id) OVER (ORDER BY rental_date) prev_rental, 
    LEAD(rental_id) OVER (ORDER BY rental_date) next_rental
FROM rental;


SELECT
	rental_id,
    rental_date,
    LAG(rental_id, 0, 0) OVER (ORDER BY rental_date) prev_rental, 
    LEAD(rental_id, 0, 0) OVER (ORDER BY rental_date) next_rental
FROM rental;



SELECT
	DISTINCT I.film_id,
    FIRST_VALUE(R. rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date) first_rental,
    LAST_VALUE(R. rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_rental
FROM rental R
JOIN inventory I USING(inventory_id);
-- 베스트상품을 찾을 수 있다


SELECT	
	customer_id,
    rental_id,
    rental_date,
    DATEDIFF(
		rental_date,
        LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)
    ) days_since_dast_rental
FROM rental
ORDER BY customer_id, rental_date;

-- PERCENT_RANK() = (rank-1)/(전체행수-1)
-- 왜 굳이 분자 1을 빼야할까? -> 최소순위 = 1등의 포지션 표기를 0%지점에서 하기 위해 빼야한다
-- 왜 굳이 분모 1을 빼야할까? -> 
SELECT 
	title,
    length,
    PERCENT_RANK() OVER (ORDER BY length) percent,
    CUME_DIST() OVER (ORDER BY length) cume,
    NTILE(4) OVER (ORDER BY length) group_movie
FROM film;


SELECT 
	customer_id,
    CONCAT(first_name, " ", last_name) customer_name,
    NTILE(4) OVER (ORDER BY customer_id) customer_group
FROM customer;





