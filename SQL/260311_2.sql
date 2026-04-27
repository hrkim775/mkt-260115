/*
MySQL(DBMS) : 데이터베이스(DB)를 관리하는 시스템 프로그램
- DB > TABLE > DATA
- 관계형 데이터 테이블 : 하나의 DB안에 TABLE간 관계를 맺을 수 있도록 되어있다 (RDBMS)
- SQL : DDL / DML / DCL
- SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY -> 기초문법
- INDEX
- JOIN
- SUB QUERY, 상관서브쿼리
- 숫자형, 문자열, 날짜, 집합 함수, 트랜잭션
- 가상쿼리 (VIEW, WITH)
- CASE WHEN 
*/

/*
TRANSATION => 거래, 중요한 데이터를 다루는 경우 실수로 데이터 삭제나 편집을 했을때 이를 되돌릴 수 있도록 해주는 장치기능
현업에서 아주 자주 쓰진 않지만 알아두면 좋다
*/

USE sakila;
SELECT * FROM customer LIMIT 10;

UPDATE customer SET first_name = "DAVE" 