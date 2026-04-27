/*
[오늘의 미션] 3/4
오늘 학습한 MySQL > bestproducts DB 를 활용해서 다음 문제를 해결하세요.

카테고리별(메인 + 서브카테고리) 할인률 상위 20% (할인을 많이한 기준) 상품만 추출해서 출력해주세요.
*/

USE bestproducts;

SELECT * FROM items;
SELECT * FROM ranking;



-- 1) 카테고리별(메인 + 서브카테고리) 할인률 상위 20% (할인을 많이한 기준) 상품만 추출해서 출력해주세요.
SELECT 
    title,
    main_category,
    sub_category,
	MAX(discount_percent) max_dis_percent
FROM ranking R
JOIN items I ON R.item_code = I.item_code
GROUP BY main_category, sub_category, title
HAVING max_dis_percent >= 20
ORDER BY max_dis_percent DESC;

-- 지금은 단순히 discount_percent가 20 이상인 것만 가져오는 것
-- 상위 20%는 어떻게 표현?
-- 정렬을 그룹별로 할수는 없을까?


/*
1) 메인과 서브카테고리가 모두 같은 상품들은 각각 개별적인 할인율을 가지고 있다
2) 위 조건에 충족되는 상품들이 총 몇개인가? -> 20%에 해당되는 갯수가 얼마인지 계산
3) 위에서 계산된 갯수 만큼만 높은 할인율을 기준으로 조회, 출력되도록 하면 된다
*/

USE bestproducts;

SELECT * FROM items LIMIT 10;
SELECT * FROM ranking LIMIT 10;



-- 1)
SELECT 
    main_category,
    sub_category,
	COUNT(*)
FROM ranking
GROUP BY main_category, sub_category;



-- 2)
SELECT 
    r.main_category,
    r.sub_category,
	r.item_ranking,
    i.item_code,
    i.title,
    i.discount_percent
FROM ranking r
JOIN items i ON r.item_code = i.item_code;



-- 3)
SELECT 
	a.main_category,
	a.sub_category,
	a.item_ranking,
	a.item_code,
	a.title,
	a.discount_percent
FROM (
	SELECT 
		r.main_category,
		r.sub_category,
		r.item_ranking,
		i.item_code,
		i.title,
		i.discount_percent
	FROM ranking r
	JOIN items i ON r.item_code = i.item_code
) a; -- 서브쿼리에도 이름을 붙일  수 있다



-- 4) 20%를 구하는 구문
SELECT 
	r.main_category, 
    r.sub_category,
    COUNT(*) * 0.2 -- 전체 갯수를 알아야 20%를 구할 수 있다
FROM ranking r
GROUP BY r.main_category, r.sub_category;



-- 5)
SELECT 
	r.main_category, 
    r.sub_category,
    CEIL(COUNT(*) * 0.2) top_k-- 값을 올림한다
FROM ranking r
GROUP BY r.main_category, r.sub_category;



-- 6)
SELECT 
	a.main_category,
	a.sub_category,
	a.item_ranking,
	a.item_code,
	a.title,
	a.discount_percent,
    top_k
FROM (
	SELECT 
		r.main_category,
		r.sub_category,
		r.item_ranking,
		i.item_code,
		i.title,
		i.discount_percent
	FROM ranking r
	JOIN items i ON r.item_code = i.item_code
) a
JOIN (
	SELECT 
	r.main_category, 
    r.sub_category,
    CEIL(COUNT(*) * 0.2) top_k
FROM ranking r
GROUP BY r.main_category, r.sub_category
) c 
ON a.main_category = c.main_category
AND a.sub_category = c.sub_category;




-- 7)
SELECT 
	a.main_category,
	a.sub_category,
	a.item_ranking,
	a.item_code,
	a.title,
	a.discount_percent
FROM (
	SELECT 
		r.main_category,
		r.sub_category,
		r.item_ranking,
		i.item_code,
		i.title,
		i.discount_percent
	FROM ranking r
	JOIN items i ON r.item_code = i.item_code
) a
JOIN (
	SELECT 
	r.main_category, 
    r.sub_category,
    CEIL(COUNT(*) * 0.2) top_k
FROM ranking r
GROUP BY r.main_category, r.sub_category
) c 
ON a.main_category = c.main_category
AND a.sub_category = c.sub_category
LEFT JOIN (
	SELECT
		r.main_category,
        r.sub_category,
        r.item_ranking,
        i.item_code,
		i.discount_percent
    FROM ranking r
    JOIN items i ON r.item_code = i.item_code
) b
ON a.main_category = b.main_category
AND a.sub_category = b.sub_category
AND (
	b.discount_percent > a.discount_percent
    OR (b.discount_percent = a.discount_percent
		AND b.item_ranking < a.item_ranking)
)
GROUP BY a.main_category, a.sub_category, a.item_ranking, a.item_code, a.title, a.discount_percent, c.top_k
HAVING COUNT(b.item_code) < c.top_k
ORDER BY a.main_category, a.sub_category, a.discount_percent DESC;