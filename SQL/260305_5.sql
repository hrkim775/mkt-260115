/*
[오늘의 미션] 3/5
MySQL > bestproducts DB 를 활용해서 다음 1개 문제를 해결하세요.

판매자별 판매중인 상품 가운데, 가장 랭킹 (숫자가 낮은게 높은것)이 높은 상품을 찾아서 출력해주세요.
*/

-- 1) 해당 데이터베이스를 선택한다
-- 2) 데이터 베이스 안에 테이블의 값을 조회해 각 컬럼을 확인한다
-- 3) 컬럼을 확인했다면, 판매자별로 그룹을 짓는다 GROUP BY
-- 4) 두 개의 테이블을 INNER JOIN으로 묶는다 (item_code) . 말고 서브쿼리 사용하기
-- 5) 묶었다면, item_ranking의 값을 확인한다
-- 6) item_ranking의 값 중에 가장 높은 상품의 title명을 출력한다

-- 1) 판매자별로 판매중인 상품을 확인한다 

USE bestproducts;

SELECT * FROM items;
SELECT * FROM ranking;

-- SELECT 
-- 	i.provider,
--     i.title,
--     r.item_ranking
-- FROM items i
-- JOIN ranking r ON r.item_code = i.item_code
-- GROUP BY i.provider, i.title, r.item_ranking 
-- ORDER BY item_ranking LIMIT 1;


SELECT 
	i.provider,
    i.title,
    r.item_ranking, COUNT(*) ranking_count
FROM items i
JOIN ranking r ON r.item_code = i.item_code
GROUP BY provider;



-- 문제풀이
USE bestproducts;

SELECT * FROM items; # 판매자
SELECT * FROM ranking; # 아이템랭킹



/*
1) 판매자별 가장 높은 랭킹 순위 찾기 (MIN, JOIN, 서브쿼리)
2) 판매자별 가장  작은 아이템 코드 찾기 (MIN, JOIN, 서브쿼리)
3) 판매자별 가장  높은 랭킹이면서 동시에 가장 작은 아이템 코드를 가진 상품 찾기 (JOIN, 서브쿼리)
4) 해당 상품들을 찾아서 랭킹별로 내림차순하기 (GROUP BY)
*/


-- 1) 판매자별로 묶기
SELECT provider
FROM items
WHERE provider <> "" # 빈 문자열 삭제
GROUP BY provider; # 중복값제거


-- 2) 두 개의 테이블 연결시키기 // 그룹화가 된 상태라도 집계함수를 쓰는건 무방하다 -> 집계함수 안 쓰면 오류남
SELECT 
	i.provider, 
    MIN(r.item_ranking) best_ranking
FROM items i
JOIN ranking r ON r.item_code = i.item_code
WHERE i.provider <> "" 
GROUP BY i.provider; 


-- 3) 판매자별로 랭킹 값이 가장 작은 것을 구했다면, 그 값의 기준을 만든다 (?)
SELECT
	i.provider,
    r.item_ranking,
    MIN(i.item_code) min_item_code # 판매자별로 한개만 가져오고 싶은데 랭킹에 중복값이 있을까봐 기준을 세우는 것 -> 아이템 코드가 가장 낮은 제품을 골라오겠다
FROM ranking r
JOIN items i ON r.item_code = i.item_code
WHERE i.provider <> "" 
GROUP BY i.provider, r.item_ranking; 



-- 4) 두 구문을 합친다
SELECT
	i.provider,
    r.item_ranking,
    MIN(i.item_code) min_item_code # 판매자별로 한개만 가져오고 싶은데 랭킹에 중복값이 있을까봐 기준을 세우는 것 -> 아이템 코드가 가장 낮은 제품을 골라오겠다
FROM ranking r
JOIN items i ON r.item_code = i.item_code
JOIN(
	SELECT 
		i.provider, 
		MIN(r.item_ranking) best_ranking
	FROM items i
	JOIN ranking r ON r.item_code = i.item_code
	WHERE i.provider <> "" 
	GROUP BY i.provider
) x 
	ON x.provider = x.provider 
    AND x.best_ranking = r.item_ranking
WHERE i.provider <> "" 
GROUP BY i.provider, r.item_ranking; 



-- 5) 아이템 이름이 없어서 한번 더 서브쿼리를 만들어준다
SELECT
	y.provider,
    y.item_ranking,
    t.title
FROM (
	SELECT
		i.provider,
		r.item_ranking,
		MIN(i.item_code) min_item_code 
	FROM ranking r
	JOIN items i ON r.item_code = i.item_code
	JOIN(
		SELECT 
			i.provider, 
			MIN(r.item_ranking) best_ranking
		FROM items i
		JOIN ranking r ON r.item_code = i.item_code
		WHERE i.provider <> "" 
		GROUP BY i.provider
	) x 
		ON x.provider = x.provider 
        AND x.best_ranking = r.item_ranking
	WHERE i.provider <> "" 
	GROUP BY i.provider, r.item_ranking
) y
JOIN items t ON y.min_item_code = t.item_code
ORDER BY y.item_ranking ASC;