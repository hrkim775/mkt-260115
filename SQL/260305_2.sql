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
*/


-- 1) NOW() : 현시점의 날짜와 시간
SELECT NOW();


-- 2) CURDATE() : 현시점의 날짜
SELECT 
	NOW() current_date_time,
    CURTIME() date_time;
    
    
-- 3) CURDATE() : 현시점의 시간
SELECT 
	NOW() current_date_time,
    CURDATE() date_time,
    CURTIME() cur_time;
    
    
-- 4) DATE_ADD(date, INTERVAL unit) : 특정기간
SELECT 
	rental_date,
    DATE_ADD(rental_date, INTERVAL 3 MONTH) dead_line,
    return_date
FROM rental
LIMIT 10;



-- 5) DATE_SUB(date, INTERVAL unit) : 특정기간 앞으로
SELECT 
	rental_date,
    DATE_SUB(rental_date, INTERVAL 8 SECOND) dead_line,
    return_date
FROM rental
LIMIT 10;



-- 6) EXTRACT(fild FROM source) : 날짜 데이터에서 특정 값만 추출 
SELECT 
	payment_date,
    EXTRACT(HOUR FROM payment_date)
FROM payment
LIMIT 10;


SELECT 
	COUNT(*)
FROM payment
WHERE EXTRACT(HOUR FROM payment_date) = 22;


SELECT 
	EXTRACT(MONTH FROM payment_date) payment_month,
	COUNT(*) payment_count
FROM payment
GROUP BY payment_month
ORDER BY payment_count DESC;



-- 7) YEAR() : 년을 찾아온다
-- 8) MONTH() : 월을 찾아온다
-- 9) DAY() : 일을 찾아온다
-- 10) HOUR() : 시간을 찾아온다
-- 11) MINUTE() : 분을 찾아온다
-- 12) SECOND() : 초를 찾아온다
SELECT 
	YEAR(payment_date) payment_year,
    MONTH(payment_date) payment_month,
    DAY(payment_date) payment_day,
    HOUR(payment_date) payment_hour,
    MINUTE(payment_date) payment_minute,
    SECOND(payment_date) payment_second
FROM payment;



-- 13) DAYOFWEEK() 한 주에 해당 날이 몇 요일인지 찾는다
SELECT 
	DAYOFWEEK(payment_date) payment_week,
    COUNT(*) week
FROM payment
GROUP BY payment_week
ORDER BY week DESC;


SELECT 
	CASE DAYOFWEEK(payment_date)
		WHEN 1 THEN "일요일" -- 여기서는 , 안쓴다 
        WHEN 2 THEN "월요일"
        WHEN 3 THEN "화요일" 
        WHEN 4 THEN "수요일"
        WHEN 5 THEN "목요일"
        WHEN 6 THEN "금요일"
        WHEN 7 THEN "토요일"
	END payment_dayname,
    COUNT(*) total_count
FROM payment
GROUP BY payment_dayname
ORDER BY total_count DESC;



-- 14) TIMESTAMPDIFF(unit, start_datetime, end_datetime) : 시작과 끝의 갭 차이
SELECT 
	rental_date,
    return_date,
	TIMESTAMPDIFF(DAY, rental_date, return_date) rental_days
FROM rental
LIMIT 10;



-- 15) DATE_FORMAT(date, format) : 날짜 또는 시간 데이터를 특정 양식의 문자열로 반환
SELECT 
	rental_id,
    rental_date,
	DATE_FORMAT(rental_date, "%y-%m-%d")
FROM rental
LIMIT 10;

SELECT 
	rental_id,
    rental_date,
	DATE_FORMAT(rental_date, "%y~%c~%d")
FROM rental
LIMIT 10;

SELECT 
	rental_id,
    rental_date,
	DATE_FORMAT(rental_date, "%y.%M.%d")
FROM rental
LIMIT 10;



-- rental 테이블에서 대여 시작 날짜가 2006년 1월 1일 이후인 모든 대여에 대해서 예상 반납 날짜를 대여 날짜로부터 5일 뒤로 설정한 후 해당 테이블 값을 출력
SELECT * FROM rental;

SELECT 
	rental_date,
	DATE_ADD(rental_date, INTERVAL 5 DAY) dead_line
FROM rental
WHERE rental_date >= "2006-01-01";