/*
중급 문법 마지막
CONCAT() : 컬럼간 문자열을 하나로 합쳐서 새로운 컬럼으로 출력하고자 할때 사용
GROUP_CONCAT() : 1개의 컬럼에 여러개의 행이 존재하는 경우, 그 각각의 행에 존재하는 문자열을 하나의 셀 안으로 결합하고자 할때 사용한다
*/

SELECT 
	c.customer_id,
    CONCAT(c.first_name, " ", c.last_name) customer_name,
    GROUP_CONCAT(f.title ORDER BY f.title ASC SEPARATOR " / ") rented_movies -- GROUP_CONCAT 정렬을 따로 할수있다 / SEPARATOR를 넣어야한다
FROM customer c
JOIN rental r USING (customer_id)
JOIN inventory i USING (inventory_id)
JOIN film f USING (film_id)
GROUP BY c.customer_id;



-- 각 배우들이 출연한 영화 제목은 세미콜론을 구분자로 구분하여 하나의 셀에 출력해주세요 최소 출력 되여야하는 값들은 영화배우, 아이디, 영화배우이름(풀네임), 출연했던 영화제목리스트가 나와야합니다

SELECT * FROM actor LIMIT 10; -- actor_id, 이름
SELECT * FROM film LIMIT 10; -- film_id, 영화제목
SELECT * FROM film_category LIMIT 10; -- film_id, category_id
SELECT * FROM film_actor LIMIT 10; -- actor_id, film_id


SELECT 
	CONCAT(a.first_name, " ", a.last_name) full_name,
    GROUP_CONCAT(f.title ORDER BY f.title ASC SEPARATOR " ; ") movies_list
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
GROUP BY full_name;


SELECT 
	a.actor_id,
	CONCAT(a.first_name, " ", a.last_name) full_name,
    GROUP_CONCAT(f.title ORDER BY f.title ASC SEPARATOR " ; ") movies_list
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
GROUP BY a.actor_id;