-- p.128 first_name 열을 기준으로 정렬
SELECT * FROM customer ORDER BY first_name;

-- p.129 last_name 열을 기준으로 정렬
SELECT * FROM customer ORDER BY last_name;

-- store_id, first_name 순으로 데이터 정렬
SELECT * FROM customer ORDER BY store_id, first_name;

-- p.130 first_name, store_id 순으로 데이터 정렬
SELECT * FROM customer ORDER BY first_name, store_id;

-- first_name 열을 오름차순으로 정렬
SELECT * FROM customer ORDER BY first_name ASC;

-- p.131 first_name 열을 내림차순으로 정렬
SELECT * FROM customer ORDER BY first_name DESC;

-- ASC와 DESC를 조합하여 데이터 정렬
SELECT * FROM customer ORDER BY store_id DESC, first_name ASC;

-- p.132 LIMIT으로 상위 10개의 데이터 조회
SELECT * FROM customer ORDER BY store_id DESC, first_name ASC LIMIT 10;

-- p.133 LIMIT으로 101번째부터 10개의 데이터 조회
SELECT * FROM customer ORDER BY customer_id ASC LIMIT 100, 10;

-- 데이터 100 개를 건너뛰고 데이터 10개 조회
SELECT * FROM customer ORDER BY customer_id ASC LIMIT 10 OFFSET 100;

