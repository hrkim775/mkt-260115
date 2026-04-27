CREATE DATABASE IF NOT EXISTS wconsept_db
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE wconsept_db;

CREATE TABLE IF NOT EXISTS brands(
	brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

SHOW TABLES;
SELECT * FROM brands;

CREATE TABLE IF NOT EXISTS products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    rank_no INT,
    product_name VARCHAR(255) NOT NULL,
    original_price INT,
    sale_price INT,
    discount_rate INT,
    rating FLOAT,
    review_count INT,
	like_count INT,
    product_url VARCHAR(500),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

SELECT * FROM products;


-- 1. 판매가 기준, 상위 20개 브랜드와 상품 조회
SELECT 
	P.product_id,
    B.brand_name,
    P.product_name,
    P.sale_price
FROM products P
JOIN brands B USING (brand_id)
ORDER BY P.sale_price DESC LIMIT 20;


-- 2. 할인율이 30% 이상인 상품 조회 & 내림차순 정렬
SELECT 
	P.product_id,
    B.brand_name,
    P.product_name,
    P.original_price,
    P.sale_price,
    P.discount_rate
FROM products P
JOIN brands B USING (brand_id)
WHERE P.discount_rate >= 30
ORDER BY P.discount_rate DESC, P.sale_price DESC;


-- 3. 특정 브랜드 (임의) 상품만 조회, 판매가 기준 오름차순 정렬
SELECT 
	P.product_id,
    B.brand_name,
    P.product_name,
    P.sale_price,
	P.discount_rate,
    p.review_count
FROM products P
JOIN brands B USING (brand_id)
WHERE B.brand_name = "프론트로우"
ORDER BY P.sale_price;


-- 4. 리뷰수가 100이상인 상품의 평균 판매가 조회
 SELECT 
    ROUND(AVG(P.sale_price), 2) avg_price
FROM products P
WHERE p.review_count >= 100
ORDER BY p.review_count DESC;


-- 5. 브랜드별 상품수 & 평균할인률 구하고 상품수가 많은 브랜드 10개 조회
SELECT 
	B.brand_id,
    B.brand_name,
    COUNT(P.product_id) product_count,
    ROUND(AVG(P.discount_rate), 1) avg_discount_rate
FROM brands B
JOIN products P USING (brand_id)
GROUP BY B.brand_id
ORDER BY product_count DESC
LIMIT 10;