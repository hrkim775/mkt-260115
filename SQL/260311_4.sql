/*
1) 가상 테이블 생성 방법 : VIEW
2) 가상 테이블 생성 방법 : WITH
- VIEW를 써야하는 이유 : 임시적으로 가상 테이블 생성. 임시적이긴 하지만 삭제할때까지 해당 데이터는 로컬 컴퓨터 메모리에 기록된다(데이터 로딩에 무리를 준다) 안정적이다 반복적으로 사용할수있다
- WITH : 메모리 공간에 저장되는 것이 아니라 먼저 쿼리구문을 실행하고 가져오는 형식이다 그래서 쿼리구문이 종료되면 WITH도 종료되다(컴퓨터는 이게 존재했는지도 알수없다) 반복적으로 사용할수는 없지만 메모리의 부담감은 줄여준다
WITH절 => CTE구문 (Commom Table Expression)이라고도 부른다 
*/

SELECT * FROM film LIMIT 10;
SELECT * FROM inventory LIMIT 10;


SELECT F.film_id, F.title
FROM film F
JOIN (SELECT DISTINCT I.film_id FROM inventory I) IV 
ON F.film_id = IV.film_id;

SELECT F.film_id, F.title
FROM film F
JOIN (SELECT DISTINCT I.film_id FROM inventory I) IV 
USING(film_id);



WITH filminvent AS (
	SELECT DISTINCT film_id FROM inventory I
)

SELECT F.film_id, F.title
FROM film F
JOIN filminvent FI
USING(film_id);

