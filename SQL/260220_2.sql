-- 테이블 생성

/*
1. 테이블 생성 시, 2가지 방법
> CREATE TABLE tablename ()
> CREATE TABLE IF NOT EXISTS tablename ()
> 테이블 생성 시, () 안에 입력될 요소들이 바로 스키마 (약속된 타입 정의)
> 약속된 타입 정의 = 몇개의 컬럼을 만들지, 각 컬럼 내부에 입력 될 값들이 어떤 타입으로 채워지게 할 것인가를 사전에 약속, 정의

2. 테이블 삭제 시, 2가지 방법
> DROP TABLE tablename;
> DROP TABLE IF EXISTS tablename;


UNSIGNDE 양의 정수 값만 사용한다
NOT NULL 결측치 값을 허용하지 않겠다
AUTO_INCREMENT 컬럼 안에 값이 추가된다면 자동으로 컬럼이 생성된다
*/

CREATE TABLE IF NOT EXISTS digitalclass (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50), 
    PRIMARY KEY(id)
);

DESC digitalclass;

DROP TABLE IF EXISTS digitalclass;

CREATE TABLE IF NOT EXISTS mktclass (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50) NOT NULL,
    modelnumber VARCHAR(15) NOT NULL,
    series VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);

DESC mktclass;

SELECT * FROM mktclass;