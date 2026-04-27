-- HAVING절
-- 그룹화가 되어진 요소를 집계함수를 가지고 조건비교를 할 때 사용한다 => HAVING절은 반드시 GROUP BY와 써야한다
-- 기본적인 조건절 문법 (WHERE) -> 이건 컬럼 속에서 조건을 적용하는 것


-- GMARKET 인기판매 TOP상품들
-- 능력있는 상품 판매업체라면, 인기판매 상품 리스트에 복수의 상품을 랭크에 올리지 않을까?
-- 능력있는 상품 판매업체라면, 100개 정도 올리지 않을까? 라는 가정
CREATE DATABASE IF NOT EXISTS bestproducts;
USE bestproducts;
SELECT COUNT(*) FROM items; -- 10201개 상품이 업체마다 하나씩이 아니라 업체마다 여러개 올렸을수도 있다
SELECT * FROM items LIMIT 10;
SELECT * FROM ranking LIMIT 10;

SELECT provider
FROM items
WHERE COUNT(*) >= 100
GROUP BY provider;
-- 그룹화 되어있는데 WHERE절로 조건를 걸려고 했기때문에 에러가 난다

SELECT provider, COUNT(*) provider_items
FROM items
GROUP BY provider
HAVING COUNT(*) >= 100
ORDER BY provider_items DESC
LIMIT 3;
-- 그룹화된 것에 조건을 걸지 않았기때문에 WHERE 가능


SELECT provider, COUNT(*) provider_items
FROM items
WHERE 
	provider != "스마일배송" AND 
    provider != ""
GROUP BY provider
HAVING COUNT(*) >= 100
ORDER BY provider_items DESC
LIMIT 5;
