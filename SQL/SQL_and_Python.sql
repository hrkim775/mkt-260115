DROP DATABASE ecommerce;
create database ecommerce;
USE ecommerce;
CREATE TABLE IF NOT EXISTS teddyproduct(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(20) NOT NULL,
    PRIMARY KEY(id)
);

SHOW TABLES;
DESC teddyproduct;
SELECT * FROM teddyproduct;