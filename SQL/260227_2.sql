CREATE DATABASE IF NOT EXISTS sqlDB;

USE sqlDB;

CREATE TABLE userTBl (
	userId CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(3),
    height SMALLINT,
    mDate DATE,
    INDEX idx_userTbl_name (name),
    INDEX idx_userTbl_addr (addr)
);

-- index : 원하는 값이 어디있는지 말해주는것 / 특정 컬럼의 값을 빠르게 찾아올때 사용 / 마치 자동검색처럼
-- 해당 인덱스가 불필요하면 제거를 해야하는데 그럴때 이름이 필요하다
-- 클러스터형 인덱스, 보조 인덱스가 있다

CREATE TABLE buyTbl (
	num INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    userId CHAR(8) NOT NULL,
    prodName CHAR(4),
    groupName CHAR(4),
    price INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES userTbl(userId)
);

-- FOREIGN KEY 설정해놓지 않아도 서로 다른 테이블간 JOIN가능
-- 단지 KEY로 설정해놓으면 인덱싱, 그룹설정 조건값 키가 될 수있다
-- 만약 양쪽에 외래키가 존재하지 않은 상태에서 두 테이블을 연결하려고 한다면 두 테이블에 동일한 키가 없었음에도 연결가능 그러나 NULL이라고 나온다 연결이 되니까 에러가 아니라고 생각할수도 있음
-- FOREIGN KEY가 있는 상태라면 에러가 나옴
-- 안정적이라는 장점이 있지만 함부로 테이블을 지울수도 생성할수도 없어서 번거롭다는 단점이 있다

SHOW TABLES;

DESC buyTBL;
DESC userTBL;

INSERT INTO userTbl VALUES("HGD", "홍길동", 2000, "서울", "010", "123", 180, "2000-10-1");
INSERT INTO buyTbl VALUES(DEFAULT, "HGD", "조깅화", "신발", 10, 2);

SELECT * FROM userTbl;
SELECT * FROM buyTBL;

DELETE FROM userTbl WHERE userId = "HGD";