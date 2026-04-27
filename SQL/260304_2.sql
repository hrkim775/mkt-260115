-- SubQuery = 서브쿼리
-- SQL 구문 안에 또 하나의 SQL 구문을 작성하는 것
-- 1) 동일한 테이블 안에서 조건식을 생성하고자 하는데, 조건의 기준값을 먼저 만들어놓고 시작해야하는 경우
-- 1) 예를 들어 열 사람의 나이값을 가지고 있는 테이블이 존재한다
-- 전체 나이 평균값을 기준으로 각각의 나이가 많은지, 적은지 판단하고자할때는 평균값을 먼저 구하고 각각의 열 사람의 나이값과 비교를 해야한다 이럴때 사용한다

-- SELECT *
-- FROM users
-- WHERE age > (
-- 		SELECT AVG(AGE) FROM users
-- );

-- 대부분의 구문이 JOIN & SubQuery가 모두 통용되는 경우
-- INNER JOIN -> 모두 다 합친 후 해당 테이블에서 값을 찾아낸다
-- A테이블 : 20개 // B테이블 : 50개 => A+B => 특정조건 매칭값
-- 컬럼의 값이 많으면 많을수록 속도, 효율성 면에서 취약하다
-- 그러니, 서로 다른 2개의 테이블에서 특정 1개 컬럼을 교집합으로 간주하고, 조건에 맞는 컬럼을 찾아오는게 좋다
-- SubQuery가 단순히 1~ㅈ개 정도면 어렵지 않지만 수가 많아지고 상관서브쿼리가 나오면 어려워진다
-- 문법의 가독성이 안 좋아진다는 단점이 있다 그래서 상황에 맞게 사용해야한다

USE bestproducts;

SELECT * FROM items LIMIT 1;
SELECT DISTINCT sub_category FROM ranking;

SELECT title
FROM items I
INNER JOIN ranking R ON I.item_code = R.item_code
WHERE R.sub_category = "여성신발";


SELECT title
FROM items
WHERE item_code IN 
	(SELECT item_code FROM ranking
    WHERE sub_category = "여성신발");
-- 위에 구문은 join, 이 구문은 서브쿼리를 사용한 것
-- 


SELECT * FROM items
WHERE 
	item_code = "102425348" OR
    item_code = "104914497" OR
    item_code = "106332300";

SELECT * FROM items
WHERE item_code IN 
    ("102425348", "104914497", "106332300");
-- 위에 있는 구문이랑 똑같은데 이렇게 축약해서 쓸 수도 있다
-- 대부분의 구문이 JOIN & SubQuery가 모두 통용된다

-- DESC items; 


SELECT MAX(dis_price)
FROM items
WHERE item_code IN 
	(SELECT item_code FROM ranking
    WHERE sub_category = "여성신발");
    
    
    
USE sakila;
SHOW TABLES;

SELECT * FROM film_category LIMIT 10;
DESC film_category;

SELECT * FROM category LIMIT 10;
DESC film_category;


-- 각각의 장르가 몇번씩 사용되었는지 찾기
SELECT category_id, COUNT(*) film_count 
FROM film_category FC
WHERE FC.category_id > 
	(SELECT C.category_id FROM category C
    WHERE name = "Comedy")
GROUP BY FC.category_id;


-- 메인 카테고리에서 할인가격이 10만원 이상인 상품이 몇개있는지 출력 (JOIN사용)
-- 1) 데이터 테이블 선택
-- 2) 테이블 확인 후, 메인 카테고리가 어디에 있는지 확인 SELECT * FROM
-- 3) 메인 카테고리의 위치 확인되었으면 두개의 테이블을 INNER JOIN으로 묶기
-- 4) 그룹으로 묶기
-- 5) 조건절을 이용해 값 찾기

USE bestproducts;
SHOW TABLES;
SELECT * FROM items;
SELECT * FROM ranking;

SELECT main_category, COUNT(*) dis_item_count
FROM ranking R
INNER JOIN items I ON R.item_code = I.item_code
WHERE I.dis_price >= 100000
GROUP BY main_category
ORDER BY dis_item_count DESC;


-- 방금 위 문제를 서브쿼리로 해결하기
SELECT main_category, COUNT(*) dis_item_count
FROM ranking R
WHERE R.item_code IN
	(SELECT I.item_code FROM items I
    WHERE I.dis_price >= 100000)
GROUP BY R.main_category;


-- dis_price가 20만원 이상인 아이템들의 갯수를 서브카테고리별로 취합해서 출력하기
-- join / 서브쿼리 두개 모두

SELECT sub_category, count(*) item_count
FROM ranking R
INNER JOIN items I ON R.item_code = I.item_code
WHERE dis_price >= 200000
GROUP BY sub_category
ORDER BY item_count DESC;

SELECT sub_category, count(*) item_count
FROM ranking R
WHERE R.item_code IN
	(SELECT I.item_code FROM items I
    WHERE I.dis_price >= 200000)
GROUP BY sub_category
ORDER BY item_count DESC;


-- 메인카테고리와 서브카테고리별 평균 할인가격과 평균할인율을 출력
-- SELECT 
-- 	AVG(dis_price) avg_price,
--     ROUND(AVG(dis_price), 2) avg_price_rate
-- FROM ranking R
-- INNER JOIN items I ON R.item_code = I.item_code
-- GROUP BY main_category, sub_category;

SELECT 
	main_category, 
    sub_category,
    ROUND(AVG(dis_price) , 2) avg_price,
    ROUND(AVG(discount_percent), 2) avg_disciunt
FROM ranking R
INNER JOIN items I ON R.item_code = I.item_code
GROUP BY main_category, sub_category;


-- 판매자별 베스트상품갯수, 평균할인가격, 평균할인률을 내림차순으로 출력
SELECT 
	provider, 
    COUNT(*) item_count,
    ROUND(AVG(dis_price) , 2) avg_dis_price,
    ROUND(AVG(discount_percent), 2) avg_disciunt_percent
FROM items
WHERE provider <> "" AND provider IS NOT NULL
GROUP BY provider
ORDER BY item_count DESC;
-- 결측치가 나왔을때 셀 수 있는것은 IS NULL | IS NOT NULL 밖에 없다


-- 메인 카테고리별 상품갯수가 20개 이상인 판매자의 판매자별 평균할인가격, 평균할인률, 상품갯수 출력
SELECT	
	R.main_category, 
    ROUND(AVG(dis_price) , 2) avg_dis_price,
    ROUND(AVG(discount_percent), 2) avg_disciunt_percent,
	COUNT(*) item_count
FROM ranking R
INNER JOIN items I ON R.item_code = I.item_code
GROUP BY main_category, provider
HAVING item_count >= 20;


-- dis_price가 5만원 이상인 상품들 중 main_category별 평균dis_price, 평균discount_percent 출력
SELECT 
	main_category,
    ROUND(AVG(dis_price) , 2) avg_dis_price,
    ROUND(AVG(discount_percent), 2) avg_disciunt_percent
FROM items I
INNER JOIN ranking R ON I.item_code = R.item_code
WHERE dis_price >= 50000
GROUP BY main_category;