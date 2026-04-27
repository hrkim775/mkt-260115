-- 

USE sakila;

SHOW TABLES;

DESC country;

-- 국가 정보
SELECT *
FROM country
LIMIT 5;

-- 영화 정보
SELECT * FROM film LIMIT 10;

-- 집계 함수 = 수치형 데이터 (숫자 형태의 데이터를 분류 하거나 집계 할때 사용 -> COUNT())
-- 데이터를 확인할 때 몇개인지 확인먼저 하고 LIMIT를 거는 것도 방법이다
SELECT COUNT(*) FROM film;

-- DISTINCT : 중복값을 제거 // GROUP BY랑 다르다
SELECT DISTINCT rating FROM film;

SELECT DISTINCT release_year FROM film;

SELECT COUNT(*) FROM rental;

SELECT * FROM rental LIMIT 10;

-- 어떤 데이터를 수집하고 생성하던지 고유의 식별값이 필요하다 ->ID가 가장 보편적이다
-- id가 있으면 검색하기도 편하고(인덱싱) 해당 값을 삭제 | 업데이트를 할 때도 좋다

SELECT * FROM inventory LIMIT 10;

-- 조건절 // 파이썬에서는 if // SQL에서는 WHERE
SELECT * FROM rental 
	WHERE inventory_id = 367;
    
SELECT * FROM customer LIMIT 10;
SELECT COUNT(*) FROM customer;


-- 데이터 분류 : 수치형 / 범주형
-- 수치형 데이터 : 집계함수
-- 집계함수 : COUNT(), SUM(), AVG(), MAX(), MIN()
-- 범주형 데이터 : DISTINCT

SELECT * FROM customer LIMIT 10;
SELECT COUNT(*) FROM customer;
SELECT MIN(customer_id) FROM customer;
SELECT MAX(customer_id) FROM customer;
SELECT AVG(customer_id) FROM customer;
SELECT SUM(customer_id) FROM customer;

SELECT * FROM payment LIMIT 10;

-- 아래 칼럼 내 정보값을 보면서 구두로 설명 -> 데이터를 읽어내려감 -> 데이터 리터러시 능력
-- 다양한 데이터들을 보고 이 데이터들이 무엇을 이야기 하고 있는지를 알아야한다 이 수치들을 보고 어떤 문제가 있고 해결책은 무엇인지 제안하는 능력 키우기

SELECT 
	SUM(amount), AVG(amount), 
    MAX(amount), MIN(amount)
FROM payment;
-- AVG(amount) : 객단가 : 상품의 가격을 책정할 때 참고

SELECT * FROM rental 
WHERE inventory_id = 367
AND staff_id = 1;

-- 그룹핑 =>특정 조건에 따라서 부류를 나눠야하는 상황
-- GROUP BY

-- 이 순서 외워 // SF 다음것들은 상황에 따라 생략이 가능하지만 순서는 절대 지켜야한다
-- SELECT 컬럼
-- FROM 테이블명
-- WHERE 조건
-- GROUP BY 컬럼
-- ORDER BY 컬럼 (오름차순/내림차순)
-- LIMIT 출력할 갯수 (기본적으로 위에서부터)


-- GROUP BY와 DISTINCT의 차이점 
SELECT rating, COUNT(*) FROM film
GROUP BY rating;
-- 중복해서 노출된 데이터들을 공통된 패턴에 따라 하나의 그룹(폴더)에 담아놓은 상태

SELECT DISTINCT rating FROM film;
-- 중복된 값이라고 판단되는 요소들을 한 번씩만 출력 (나머지는 제거)

SELECT
	rating, COUNT(*)
FROM film
WHERE rating = "PG" OR rating = "G"
GROUP BY rating;

SELECT title, rating FROM film
WHERE rating = "G" OR rating = "PG"
ORDER BY rating DESC;

SELECT title, rating FROM film
WHERE rating = "G" OR rating = "PG"
GROUP BY rating
ORDER BY rating DESC;
-- GROUP BY는 제약이 많다
-- GROUP BY를 통해서 특정 컬럼을 그룹화했다면, 해당 컬럼 외 값을 추력하고자 할 때, 그 요소 역시 집계함수로 설정해줘야한다
-- 만약 출력하고자 하는 값들에 집계함수를 사용하지 않을 경우, 굳이 그룹화가 불필요함


SELECT title FROM film
WHERE 
	(rating = "G" OR rating = "PG") AND 
    (release_year = 2006 or release_year = 2007);
    
    
-- film 테이블에서 각 등급별 그룹화 후 해당 등급별 영화 갯수 출력 + 평균 렌탈비용
-- 필름 테이블을 확인하고
-- 등급을 확인한 후 그룹핑을 한다
-- COUNT() 함수를 사용해서 갯수를 출력한다
-- AVG() 함수를 사용해서 평균 렌탈 비용을 출력한다

SELECT 
	rating, COUNT(*), AVG(rental_rate)
FROM film
GROUP BY rating;

SELECT * FROM film LIMIT 10;

-- 정렬 (내림: DESC | 오름: ASC)
-- 기본적으로 오름차순이릭 때문에 써줄 필요가 없음
SELECT
	rating, COUNT(*) AS total_films, 
    AVG(rental_rate) AS avg_rental_rate
FROM film
GROUP BY rating
ORDER BY AVG(rental_rate) DESC;


SELECT
	rating, COUNT(*) AS total_films, 
    AVG(rental_rate) AS avg_rental_rate
FROM film
WHERE release_year = 2006 OR release_year = 2007
GROUP BY rating
ORDER BY avg_rental_rate DESC;

-- SQL이 코드를 읽는 순서
-- FROM 어디서 가져와요?
-- WHERE 조건이 있어요?
-- GROUP BY 그룹이 있어요?
-- HAVING 그룹에 조건이 있어요?
-- SELECT 확인했으니 가져올게요
-- ORDER BY 

-- SELECT 안에 AS가 있으면 읽어올 수 없다
-- HAVING | ORDER BY에 있는 AS만 읽어올 수 있다


-- 각 등급별 영화의 상영시간이 130분 이상인 영화의 갯수와 해당 영화의 등급을 출력
SELECT 
	rating, 
    COUNT(*) film_count
FROM film
WHERE length >= 130
GROUP BY rating
ORDER BY film_count DESC;
-- AS 는 생략이 가능하기 때문에 잘 봐야한다