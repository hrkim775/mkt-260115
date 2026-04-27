CREATE DATABASE yeogi_db 
	DEFAULT CHARACTER SET utf8mb4
	DEFAULT COLLATE utf8mb4_0900_ai_ci;
    

CREATE TABLE IF NOT EXISTS yeogi_product_top4 (
	category VARCHAR(20) NOT NULL, 
    title VARCHAR(30) NOT NULL,
    location VARCHAR(20) NOT NULL,
    rating INT NULL,
    people VARCHAR(20) NOT NULL,
    price VARCHAR(20) NOT NULL,
    dis_price VARCHAR(20) NOT NULL,
    PRIMARY KEY(title)
);


SELECT * FROM yeogi_product_top4;

USE yeogi_db;

ALTER TABLE yeogi_product_top4
MODIFY rating FLOAT;