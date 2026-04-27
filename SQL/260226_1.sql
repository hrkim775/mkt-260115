CREATE DATABASE IF NOT EXISTS school;

USE school;

CREATE TABLE students (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT UNSIGNED,
    grade VARCHAR(10)
); 

DESC students;

INSERT INTO students VALUES(1, "홍길동", 15, "9학년");
INSERT INTO students VALUES(default, "고길동", 16, "10학년");
INSERT INTO students (name, age, grade) VALUES("신길동", 17, "11학년"); -- 가장 좋은 방법

SELECT * FROM students;

TRUNCATE TABLE students; -- 테이블은 유지한채로 안에 데이터를 리셋하는 방법

INSERT INTO students (grade, name, age)
VALUES 
	("9학년", "홍길동", 15),
	("10학년", "고길동", 16),
	("11학년", "신길동", 17);
    
DESC students;


-- ALTER : 속성을 변경
ALTER TABLE students
	MODIFY age INT UNSIGNED NOT NULL,
    MODIFY grade VARCHAR(10) NOT NULL;
    
ALTER TABLE students
	MODIFY age INT UNSIGNED;
    
-- UPDATE : 값을 변경
-- 초심자들의 가장 큰 실수 // 조건을 걸어줘야 전체 데이터가 바뀌지 않는다
UPDATE students
SET grade = "12학년", age = 18
WHERE id = 3;
-- WHERE grade = "11학년" AND age = 17;
-- 데이터를 수정하려고 할땐 안전모드가 있다 반드시 키의 속성을 가지고 있는 값을 가지고 와야한다

SET SQL_SAFE_UPDATES = 0; -- 세이프모드를 비활성화 // 비추천

UPDATE students
SET grade = "11학년", age = 17
WHERE grade = "12학년" AND age = 18;

SET SQL_SAFE_UPDATES = 1; -- 세이프모드를 활성화

INSERT INTO students (name, age, grade) VALUES("이길동", 14, "8학년");

SELECT * FROM students;

SELECT 
	name, age 
FROM students;

-- 조건은 WHERE
SELECT *
FROM students
WHERE age = 16; -- 값이 같은 것을 찾아와라

-- 프로그래밍 언어 : ~과 ~이 같다 : == | ===

SELECT *
FROM students
WHERE age <> 16; -- 값이 같지 않은 것을 찾아와라alter

SELECT *
FROM students
WHERE age > 16; -- 초과되는 값을 찾아와라

SELECT *
FROM students
WHERE age = 16; -- 미만의 값을 찾아와라

SELECT *
FROM students
WHERE age >= 16; -- 크거나 같은 값을 찾아와라

SELECT *
FROM students
WHERE age <= 16; -- 작거나 같은 값을 찾아와라alter

SELECT *
FROM students
WHERE age != 16; -- 

INSERT INTO students (name, age, grade) VALUES("길동", NULL, "9학년");

SELECT * FROM students;

SELECT * FROM students WHERE age <> 16;
SELECT * FROM students WHERE age != 16;
SELECT * FROM students WHERE NOT age = 16;
-- 부정연산자 중에서 <>와 !=, NOT은 NULL 값을 배제한다

SELECT * FROM students WHERE age NOT IN (16, 17, NULL);
-- UNKNOWN => 조회불가능 상태

-- SELECT * FROM students WHERE age NOT IN (SELECT age FROM students WHERE age IS NOT NULL); 

SELECT * 
FROM students 
WHERE age <> 16 OR age IS NULL;
SELECT * FROM students WHERE age IS NOT NULL;
-- NULL 값을 온전하게 판단 

SELECT *
FROM students
WHERE 
	age >= 15 AND grade = "10학년";
    
SELECT *
FROM students
WHERE 
	age >= 15 OR grade = "10학년";
    
SELECT *
FROM students
WHERE 
	(age >= 15) OR (grade = "10학년");
    
SELECT *
FROM students
WHERE name like "고%";
-- %는 갯수와 무관하게 어떤 값을 받는다

SELECT *
FROM students
WHERE name like "고__";
-- _는 갯수만큼만 값을 받는다

SELECT *
FROM students
WHERE name like "%길%";
-- %는 값이 있을수도 없을수도 있다

SELECT *
FROM students
WHERE name like "___";

SET SQL_SAFE_UPDATES = 0;
DELETE FROM students WHERE name = "길동";
SET SQL_SAFE_UPDATES = 1;
DELETE FROM students WHERE id = 4;

SELECT * FROM students;

SHOW DATABASES;

USE mysql;

SELECT Host, User FROM user;

-- User : 아이디
-- Host : 접근 가능한 ip 범위 : 127.0.0.1 = 로컬 컴퓨터

CREATE USER "jklee"@"localhost"
IDENTIFIED BY "1234567a";

CREATE USER "jkleeall"@"%"
IDENTIFIED BY "1234567a";

SET PASSWORD FOR "jkleeall"@"%" = "1234a";

DROP USER "jklee"@"localhost";

DROP USER "jkleeall"@"%";

SHOW GRANTS FOR "root"@"localhost";

SHOW GRANTS FOR "jkleeall"@"%";

GRANT SELECT ON school.students TO "jkleeall"@"%";

GRANT UPDATE ON school.students TO "jklee"@"localhost";

SHOW GRANTS FOR "jklee"@"localhost";

FLUSH PRIVILEGES; -- 사라질 예정

REVOKE UPDATE ON school.students FROM "jklee"@"localhost";
REVOKE ALL PRIVILEGES, GRANT option from "jklee"@"localhost";