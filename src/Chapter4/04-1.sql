-- p.110 first_name 열을 조회
SELECT first_name FROM customer;

-- p.111 2개의 열을 조회
SELECT first_name, last_name FROM customer;

-- 모든 열을 조회
SELECT * FROM customer;

-- p.113 customer 테이블의 열 정보를 조회
SHOW COLUMNS FROM sakila.customer;
desc sakila.customer;

