/*
<문자열 함수>
1) LENGTH() : 문자열의 길이를 확인
2) UPPER() : 대문자로 변환
3) LOWER() : 소문자로 변환
4) Callback Function : 함수 안의 함수 (가장 안쪽부터 먼저 실행)
5) CONCAT() : 문자열과 문자열을 합친다
6) SUBSTRING() : 문자열에서 일부만 추출해온다 (어디에서, 몇번째부터, 몇개를)

<날짜/시간 함수>
1) NOW() : 현시점의 날짜와 시간
2) CURDATE() : 현시점의 날짜
3) CURTIME() : 현시점의 시간
4) DATE_ADD(date, INTERVAL unit) : 특정기간 뒤로
- INTERVAL unit : 년, 월, 일, 시간, 분, 초 모두 가능하다
5) DATE_SUB(date, INTERVAL unit) : 특정기간 앞으로
6) EXTRACT(fild FROM source) : 날짜 데이터에서 특정 값만 추출
- ex) 판매가 가장 많이 되었던 날짜, 트래픽이 많았던 시간등을 찾을때 사용
7) YEAR() : 년을 찾아온다
8) MONTH() : 월을 찾아온다
9) DAY() : 일을 찾아온다
10) HOUR() : 시간을 찾아온다
11) MINUTE() : 분을 찾아온다
12) SECOND() : 초를 찾아온다
13) DAYOFWEEK() 한 주에 해당 날이 몇 요일인지 찾는다
- 일요일 = 1, 월요일은=2 ...
14) TIMESTAMPDIFF(unit, start_datetime, end_datetime) : 시작과 끝의 갭 차이
- 년, 월, 일, 시간, 분, 초 모두 가능하다
15) DATE_FORMAT(date, format) : 날짜 또는 시간 데이터를 특정 양식의 문자열로 반환
-%Y : 4자리 연도수 (2026)
-%y : 2자리 연도수 (26)
-%M : 영문 월 이름 표기 (Marth)
-%m : 월을 2자리 수 표기 (01~12)
-%c : 월을 1자리 수 표기 (1~12)
-%D : 일을 2자리 수 + 영문 접미사 표기 (1st, 21st)
-%d : 일을 2자리수 표기 (01~31)
-%H : 시간을 24시간 형식으로 2자리 수 표기 (00~23시)
-%h : 시간을 12시간 형식으로 2자리 수 표기 (01~12시)
-%I : 시간을 12시간 형식으로 1자리 수 표기 (1~12)
-%i : 분을 2자리 수 표기 (00~59)
-%s : 초를 2자리 수 표기 (00~59)

<숫자 함수>
1) ABS(number) : 절대값 반환 함수
2) CEIL(number) : 값을 올린다
3) FLOOR(number) : 값을 내린다
4) ROUND(number, decimals) : 해당 번째까지 값을 올린다
5) SQRT() : 특정 숫자의 제곱근을 반환한다
*/


-- 1) ABS(number) : 절대값 반환 함수
SELECT ABS(-1);


-- 2) CEIL(number) : 값을 올린다
-- 3) FLOOR(number) : 값을 내린다
-- 4) ROUND(number, decimals) : 해당 번째까지 값을 올린다
SELECT 
	amount,
	CEIL(ABS(amount)),
    FLOOR(ABS(amount)),
    ROUND(amount, 1)
FROM payment
LIMIT 10;


-- 5) SQRT() : 특정 숫자의 제곱근을 반환한다
SELECT SQRT(4);


-- payment 테이블에서 결제금액이 5 이하인 모든 결제건에 대해서 해당 결제 금액을 절대값으로 적용하여 출력
-- SELECT
--     ABS(amount) <= 5
-- FROM payment;

SELECT
    ABS(amount)
FROM payment
WHERE amount <= 5;


-- film 테이블에서 영화상영시간(길이)가 120분 이상인 모든 영화에 대해서 영화상영시간의 제곱근을 계산해서 출력해주세요
SELECT *
FROM film;

SELECT
	ROUND(SQRT(length),2)
FROM film
WHERE length >= 120;