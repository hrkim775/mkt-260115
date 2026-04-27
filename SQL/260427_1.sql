USE wconcept_db_260423;

SELECT * FROM brands;
SELECT * FROM products;
SELECT * FROM product_metrics;
SELECT * FROM product_reviews;

SELECT COUNT(*) AS total_product_count
FROM products; # 197개

SELECT COUNT(*) AS total_brands_count
FROM brands; # 106개

SELECT COUNT(*) AS total_review_count
FROM product_reviews; # 5728개

/*
JOIN을 많이 사용하면 컴퓨터 로딩이 오래걸림
*/

SELECT 
	B.brand_name,
	P.product_name,
    P.product_url
FROM products P
JOIN brands B ON P.brand_id = B.brand_id;

SELECT
	P.product_name,
    M.original_price,
    M.sale_price,
    M.discount_rate
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id;

SELECT 
	P.product_name,
    M.sale_price
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id
ORDER BY M.sale_price DESC;

SELECT 
	P.product_name,
    M.original_price,
    M.sale_price,
    M.discount_rate
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id
ORDER BY M.discount_rate DESC;


SELECT 
	P.product_name,
    M.rating,
	M.review_count
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id
ORDER BY M.rating DESC
LIMIT 20;


SELECT 
	P.product_name,
    M.rating,
	M.review_count
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id
ORDER BY M.review_count DESC
LIMIT 20;


SELECT 
	P.product_name,
    M.rating,
	M.like_count
FROM products P
JOIN product_metrics M ON P.product_id = M.product_id
ORDER BY M.like_count DESC
LIMIT 20;


SELECT
	B.brand_name,
    COUNT(P.product_id) AS product_count
FROM brands B
JOIN products P ON B.brand_id = P.brand_id
GROUP BY B.brand_name
ORDER BY product_count DESC;


SELECT
	B.brand_name,
    ROUND(AVG(M.discount_rate)) AS avg_discount_rate
FROM brands B
JOIN products P ON B.brand_id = P.brand_id
JOIN product_metrics M ON P.product_id = M.product_id
GROUP BY B.brand_name
ORDER BY avg_discount_rate DESC;


# 파레토 법칙 : 엘리트 20%가 나머지 80%를 이끌어간다는 법칙
# 쇼핑몰에도 대입할 수 있다 모든 상품이 다 미끼가 될 필요는 없다 자주 판매되지 않더라도 마진과 영업이익을 많이 남기는게 있고 많이 판대되더라도 큰 이익은 없는 상품이 있다


SELECT
	B.brand_name,
    ROUND(AVG(M.rating)) AS avg_rating
FROM brands B
JOIN products P ON B.brand_id = P.brand_id
JOIN product_metrics M ON P.product_id = M.product_id
GROUP BY B.brand_name
ORDER BY avg_rating DESC;


SELECT 
	P.product_name,
    COUNT(R.review_id) AS collected_review_count
FROM products P
JOIN product_reviews R ON P.product_id = R.product_id
GROUP BY P.product_id
ORDER BY collected_review_count DESC;


SELECT
	P.product_name,
	R.review_text
FROM product_reviews R
JOIN products P ON R.product_id = P.product_id
WHERE R.review_text LIKE "%기념일%" 
	OR R.review_text LIKE "여행%";




