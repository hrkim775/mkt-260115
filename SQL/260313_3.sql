/*[오늘의 미션] 3/13

wconcept > SQL 활용 다음과 같은 값을 조회.출력
카테고리별(의류, 가방, 신발, 액세서리) 평균 판매가, 평균 할인율
*/

CREATE DATABASE IF NOT EXISTS wconsept_db2
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE wconsept_db2;

CREATE TABLE IF NOT EXISTS brands(
	brand_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS categorys(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    category_name VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    rank_no INT,
    product_name VARCHAR(255) NOT NULL,
    original_price INT,
    sale_price INT,
    discount_rate INT,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);