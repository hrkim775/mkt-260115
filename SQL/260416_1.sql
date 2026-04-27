USE crawler_lab_v1;

CREATE TABLE IF NOT EXISTS produsts (
	id INT AUTO_INCREMENT PRIMARY KEY,
    product_url VARCHAR(500) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_name VARCHAR(255),
    price DECIMAL(10, 2),
    rating DECIMAL(3, 2),
    review_count INT,
    crawler_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_product_url (product_url)
);

CREATE TABLE IF NOT EXISTS reviews (
	id INT AUTO_INCREMENT PRIMARY KEY,
    product_url VARCHAR(500) NOT NULL,
    review_text TEXT NOT NULL,
    review_score DECIMAL(3, 2),
    crawler_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM produsts;
SELECT * FROM reviews;

