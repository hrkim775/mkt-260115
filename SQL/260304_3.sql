-- INDEX = 목차 / 원하는 챕터를 고를 수 있다
-- 인덱스 기능을 테이블 내 특정 컬럼에 적용하면 데이터를 찾아오는게 매우 효과적이다
-- 1만건 이하의 데이터에서는 인덱싱 기능에 큰 차이를 못 느끼지만 그 이상으로 넘어가면 속도면에서 차이를 느낄수있다
-- Clustered Index : 테이블을 생성하는 단계에서부터 인덱스로 시작한 요소
-- Secondary Index : 의도적으로 인덱스값을 생성하는 방법
-- CREATE INDEX [인덱스명] ON users(email);
-- CREATE INDEX idx_email ON users(email);
-- SELECT * FROM users WHERE email = "a@email.com";
-- 인덱스를 설정했다가 필요가 없는 경우에는 제거 해야하기 때문에 인덱스의 이름이 필요하고, 이름은 직관적으로 쓰는 것이 좋다

DROP DATABASE IF EXISTS sqldb;
CREATE DATABASE IF NOT EXISTS sqldb;

USE sqldb;
CREATE TABLE usertable(
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthday INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height INT,
    mDate DATE
);

SHOW TABLES;
DESC usertable;
SHOW INDEX FROM usertable;
-- Non_unique : 0은 중복불가 / 1은 중복가능
-- Seq_in_index : 복합인덱스 설정 시, 인덱스 설정 순서 -> CREATE INDEX (addr, height, mDate) 인덱스의 값은 여러개가 있을 수 있다 : 복합인덱스
-- CREATE INDEX test_idx (user_id, mDate) FROM usertable;
-- (1, 2026-03-01) 
-- (1, 2026-03-02) 
-- (2, 2026-03-04) 
-- (2, 2026-03-05)
-- WHERE user_id = 8 AND mDate = "2026-03-04"
-- 이런 식으로 두 가지의 조건을 모두 일치해야하는 경우엔 복합인덱스를 만들어놓으면 편하다
-- 복합인덱스의 경우 앞쪽부터 시퀀스를 잡는다 
-- Collation : 정렬 : Ascending : 오름 //D
-- Cardinality : 현재 세팅된 인덱스 안에 몇개의 값이 들어와있는가?

CREATE TABLE buytable (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    proName CHAR(4),
    groupName CHAR(4),
    price INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES usertable(userID)
);

SHOW INDEX FROM buytable;

-- 최조에 테이블 생성 후 테이블 수정, 변경, 업데이트 할때 -> ALTER 사용

/*
ALTER TABLE [tablename] ADD COLUMN [추가할 컬럼명][추가할 컬럼 데이터형]
ALTER TABLE [tablename] MODIFY COLUMN [변경할 컬럼명][변경할 컬럼 데이터형]
ALTER TABLE [tablename] CHANGE COLUMN [기존 컬럼명][변경 컬럼명][변경할 컬럼 데이터형]
ALTER TABLE [tablename] ADD CONSTRAINT TESTDate UNIQUE(mDate) : 컬럼의 속성에 중복 값을 받지 않는다 -> 인덱스 처리
ALTER TABLE [tablename] ADD INDEX [인덱스이름](컬럼명)
ALTER TABLE [tablename] DROP INDEX [인덱스이름]
*/

/*
인덱스를 만드는 다섯가지 방법
1) PK
2) FK
3) ALTER UNIQUE()
4) CREATE INDEX
5) ADD INDEX
*/


ALTER TABLE usertable ADD CONSTRAINT TESTDate UNIQUE(mDate);
SHOW INDEX FROM usertable;

CREATE INDEX idx_name ON usertable(name);

ALTER TABLE usertable ADD INDEX idx_addr(addr);

CREATE INDEX idx_group ON buytable(groupName);
SHOW INDEX FROM buytable;

CREATE TABLE usertable(
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL, -- UNIQUE의 속성을 가지고 있어도 인덱스가 된다
    birthday INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height INT,
    mDate DATE,
    -- INDEX idx_usertable_name (name) 
    INDEX idx_usertable_addr (addr)
);

SHOW INDEX FROM usertable;

ALTER TABLE usertable DROP INDEX idx_usertable_addr;

