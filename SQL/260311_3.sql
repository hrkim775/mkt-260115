/*
VIEW 가상 쿼리문 : 가상의 테이블을 만들어서 쿼리문을 작성한 것

VIEW를 쓰는 이유
1) 복잡한 쿼리문을 간소화 시킬 수 있다 
- SQL 쿼리문을 쓰다보면 복잡해질때가 있다(서브쿼리 안에 또 서브쿼리 또 서브...이렇게 됨) 그럴때 가상의 테이블로 가상쿼리를 하나 만들어놓고 사용한다 -> 가독성이 좋아진다
- 미리 가상 테이블을 만들어 놓고 필요에 따라 불러올 수 있다
2) 데이터 보안
- 원본 데이터를 가지고 있는 데이블에서 중요하고 민감한 데이터를 필터링해서 임시 테이블을 만들 수 있다 (회사의 개인정보 같은 것)
*/

-- CREATE VIEW <가상 테이블 이름> AS 쿼리문

CREATE VIEW actorinfo AS
SELECT first_name, last_name 
FROM actor 
WHERE actor_id < 100;

SELECT * FROM actorinfo; -- 가상 테이블이기 때문에 네비게이터 목록에는 보이지 않는다

SHOW TABLES;
-- 이걸로만 확인할 수 있기 때문에 만들었던 가상테이블 만들었던 것을 잊을수도 있다
-- 여러명이 작업할 때도 혼란스러울수 있다 이게 주의해야할 점!


-- 에러를 만들지않고 기존에 있던 가상 테이블에 데이터를 덮어씌울수 있다 (덮어쓰면 안되는게 있을수있으니 사용할땐 주의!)
CREATE OR REPLACE VIEW actorinfo AS
SELECT first_name, last_name 
FROM actor 
WHERE actor_id < 100;


-- 제거방법
DROP VIEW actorinfo;


-- VIEW를 통해서 가상 테이블을 생성한다는 것은 어딘가엔 원본 테이블이 존재한다는건데 이 것은 어떤 상관관계를 가지고 있을까?
-- 원본의 값이 바뀌면 반드시 가상 테이블의 값도 바뀐다
-- 가상 테이블이 바뀌면 원본 테이블의 값도 바뀐다
-- 같은 주소값을 받아오기 때문에 둘 중 어느 것의 값이 바뀌어도 반영된다
CREATE OR REPLACE VIEW myview AS
SELECT * FROM customer
WHERE customer_id = 1;

SELECT * FROM myview;
SELECT * FROM customer LIMIT 1;

UPDATE customer SET first_name = "DAVE"
WHERE customer_id = 1;


UPDATE myview SET first_name = "MARY"
WHERE customer_id = 1;


-- 가상 테이블의 이름을 바꾸는 방법
RENAME TABLE myview TO myviewrename;

SHOW TABLES;




/*
actorinfo라는 가상 테이블을 생성. actor 테이블에서 first_name, last_name 컬럼을 모두 포함 limit 50
*/

CREATE OR REPLACE VIEW actorinfo AS
SELECT  first_name, last_name
FROM actor LIMIT 50;

SHOW TABLES;
SELECT * FROM actorinfo;


/*
FILM테이블에서 렌탈 비용이 2달러보다 높은 영화에 대한 VIEW테이블 생성
테이블의 이름은 expensivefilms, title, rental_rate 컬럼을 포함시켜주세요
*/

SELECT title, rental_rate FROM film;

CREATE OR REPLACE VIEW expensivefilms AS
SELECT title, rental_rate
FROM film WHERE rental_rate > 2.00;

SELECT * FROM expensivefilms;



DROP VIEW expensivefilms;
DROP VIEW actorinfo;
DROP VIEW myviewrename;
