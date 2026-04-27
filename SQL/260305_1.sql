/*
<문자열 함수>
1) LENGTH() : 문자열의 길이를 확인
2) UPPER() : 대문자로 변환
3) LOWER() : 소문자로 변환
4) Callback Function : 함수 안의 함수 (가장 안쪽부터 먼저 실행)
5) CONCAT() : 문자열과 문자열을 합친다
6) SUBSTRING() : 문자열에서 일부만 추출해온다 (어디에서, 몇번째부터, 몇개를)
*/


USE sakila;
SHOW TABLES;

SELECT * FROM film LIMIT 10;


-- 1) LENGTH() : 문자열의 길이를 확인
SELECT 
	title, 
    LENGTH(title) title_length
FROM film  
LIMIT 10;


-- 2) UPPER() : 대문자로 변환
SELECT 
	title, 
    UPPER(title) uppercased_title
FROM film  
LIMIT 10;


-- 3) LOWER() : 소문자로 변환
SELECT 
	title, 
    LOWER(title) lowercased_title
FROM film  
LIMIT 10;



-- 4) Callback Function : 함수 안의 함수 (가장 안쪽부터 먼저 실행)
SELECT 
	title, 
    LENGTH(UPPER(LOWER(title))) lowercased_title
FROM film  
LIMIT 10;



-- 5) CONCAT() : 문자열과 문자열을 합친다
SELECT 
	first_name, last_name, 
    CONCAT(first_name, " ", last_name) full_name
FROM actor 
LIMIT 10;



-- 6) SUBSTRING() : 문자열에서 일부만 추출해온다 (어디에서, 몇번째부터, 몇개를)
SELECT 
	description,
    SUBSTRING(description, 3, 10) short_description
FROM film
LIMIT 10;


-- film테이블에서 영화 제목의 길이가 15자인 영화들을 찾아주세요
SELECT 
	title
FROM film
WHERE LENGTH(title) = 15;


-- actor 테이블에서 first_name이 소문자로 john인 배우들의 전체이름을 변환해서 출력
SELECT * FROM actor;

SELECT 
    UPPER(CONCAT(first_name, " ", last_name)) full_name
FROM actor
WHERE LOWER(first_name) = "john";

SELECT * FROM actor;


-- film 테이블에서 description 컬럼 안에 텍스트가 3번째 문자열부터 이후 6글자가 action인 영화제목을 찾아서 출력
SELECT * FROM film;

SELECT 
	title
FROM film
WHERE SUBSTRING(description, 3, 6) = "action";