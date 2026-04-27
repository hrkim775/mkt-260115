-- 주석1 : 단문주석 -> SQL 표준주석
# 주석2 : 단문주석 -> MySQL 전용주석
/* 주석3 : 복문주석 */
-- 반드시 SQL 문법을 사용할 때에는 종료구문에 세미콜론(;)가 들어가야한다

-- 쿼리문을 작성해서 데이터베이스와 테이블을 생성, 편집, 삭제

/*
MySQL 접속 시, 이것부터 시작해라!

1. 데이터베이스 생성
> CREATE DATABASE dbname;
> 데이터베이스의 이름은 직관적이고 명시적이게 써야한다 -> 누가봐도 한 눈에 알아볼 수 있도록

> CMD에서 MySQL 접속 -> mysql -u root -p
> 종료 -> exit

> CREATE DATABASE IF NOT EXISIS dbname;
> 혹시라도 데이터베이스가 덮어쓰기 되는 것을 방지하기 위해 실무에서는 이 구문을 많이 쓴다
> 이모지, 특수문자가 다 깨진다는 단점이 있다

> CREATE DATABASE IF NOT EXISTS dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
>이모지, 특수문자까지 모두 받을 수 있는 구문

UTF : Unicode Transformation Format
각 나라의 언어는 국제적으로 약속된 코드형식으로 이루어져있다
예) 가 = U+AC00 : 3byte / A = U+0041 : 1byte
스크래피, 셀리니움, 파이썬 -> utf8 -> 3byte
이모지🙂 = 4byte 그래서 인식 불가

COLLATE -> collation

general_ci : case insensitive
general_cs : case seneitive

> CREATE SCHEMA dbname;
> 잘 사용하진 않는다

2. 현재 MySQL 안에 생성된 데이터베이스를 조회
> SHOW DATABASES;

3. 해당 데이터베이스를 선택
> USE dbname;

4. 선택된 데이터베이스 안에 테이블 생성
> CREATE TABLE tablename (컬럼명 타입);
> CREATE TABLE IF NOT EXISTS tablename (컬럼명 타입);

5. 데이터베이스 안에 생성된 테이블 속성 조회
> DESC tablename;

6. 테이블 내부 값을 조회
> SELECT * FROM tablename;

7. 생성된 테이블 안에 데이터 저장, 삽입

8. 데이터베이스 삭제
> DROP DATABASE dbname;
> DROP DATABASE IF EXISTS dbname;

ctrl + enter : 단문실행
ctrl + shift + enter : 복문실행
*/

CREATE DATABASE digitalmkt;
CREATE DATABASE IF NOT EXISTS digitalmkt; 
CREATE SCHEMA digitalmkt;
CREATE DATABASE IF NOT EXISTS digitalmkt CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

SHOW DATABASES;
USE digitalmkt;

DROP DATABASE digitalmkt;
DROP DATABASE IF EXISTS digitalmkt; 

