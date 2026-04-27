-- JOIN // 매우매우 중요
-- JOIN : 가입하다, 결합하다
-- 서로 다른 테이블을 결합하고자 할 때 사용
-- A테이블, B테이블이 있을때 둘을 연결하는 키가 존재한다 그 키를 기준으로 두개의 테이블을 붙일 수 있다
-- 테이블을 나눠서 관리하는 이유는, 비효율적으로 너무 많은 컬럼을 사용하지 않기 위함

-- JOIN은 2가지 종류
-- INNER JOIN : JOIN이라고만 쓸수도 있다
-- OUTER JOIN : LEFT OUTER JOIN / RIGHT OUTER JOIN

SELECT * FROM items LIMIT 10;
SELECT * FROM ranking;

SELECT * FROM items A
JOIN ranking B ON A.item_code = B.item_code
WHERE B.main_category = "ALL";
-- ORDER BY, HAVING, JOIN은 AS 쓸수있다

SELECT * FROM items A
JOIN ranking B ON A.item_code = B.item_code
WHERE main_category = "ALL";
-- WHERE에 B도 생략가능하다 // JOIN한 테이블 안에 B가 하나 밖에 없으니까 가능 // main_category가 A 테이블에도 있다면 명시해줘야함
-- INNER JOIN에서 WHERE -> 컬럼 내 조건을 따지고자 할 때, 원칙적으로는 어떤 테이블에 컬럼인지 작성하는데 맞지만
-- 만약에 해당 컬럼이 특정 테이블 한 곳에만 사용중이었다면 굳이 어떤 테이블인지 작성하지 않아도 된다


-- 메인카테고리가 ALL인 상품을 기준으로 판매자별 상품 갯수 출력하기
SELECT provider, COUNT(*) provider_count
FROM ranking R
JOIN items I ON R.item_code = I.item_code
WHERE main_category = "ALL"
GROUP BY provider
ORDER BY provider_count DESC;


-- 메인카테고리가 패션의류, 판매자별 상품갯수가 5이상인 경우에 한해서 판매자 이름과 상품갯수를 출력하기
-- 어떤 테이블에 메인카메고리와 판매자 이름이 있는지 확인
-- 하나의 테이블 안에 두 가지 컬럼이 없다면 JOIN으로 묶어주기
-- 묶었다면, 메인카테고리가 패션의류인 것을 찾기
-- 찾았다면, 상품 갯수가 5개 이상이라는 조건을 걸기
-- 그 후 판매자 이름과 갯수를 출력하기
-- 내림차순으로 정렬해서 보기 좋게 만들기

SELECT provider, COUNT(*) provider_items
FROM ranking R
JOIN items I ON R.item_code = I.item_code
WHERE main_category = "패션의류" 
GROUP BY provider HAVING provider_items >= 5
ORDER BY provider_items DESC;


-- 메인카테고리가 신발잡화, 판매자별 상품갯수가 10개 이상인 경우에 한해서 판매자 이름과 상품갯수를 내림차순으로 출력하기
SELECT provider, COUNT(*) provider_items
FROM ranking R
JOIN items I ON R.item_code = I.item_code
WHERE main_category = "신발/잡화"
GROUP BY provider HAVING provider_items >= 10
ORDER BY provider_items DESC; 

-- 메인카테고리가 화장품/헤어, 평균할인가격, 최대할인가격, 최소할인가격을 출력하기
SELECT 
	AVG(dis_price),
    MAX(dis_price),
    MIN(dis_price)
FROM ranking R
JOIN items I ON R.item_code = I.item_code
WHERE main_category = "화장품/헤어";

SELECT 
	ROUND (AVG(dis_price), 2) avg_price,
    MAX(dis_price) max_price,
    MIN(dis_price) min_price
FROM ranking R
JOIN items I ON R.item_code = I.item_code
WHERE main_category = "화장품/헤어";