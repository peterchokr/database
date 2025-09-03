-- p.250 COUNT 함수로 데이터 개수 집계
SELECT COUNT(*) FROM customer;

-- COUNT 함수와 GROUP BY 문 조합
SELECT store_id, COUNT(*) AS cnt FROM customer GROUP BY store_id;

-- p.251 COUNT 함수와 GROUP BY 문 조합: 열 2개 활용
SELECT store_id, active, COUNT(*) AS cnt FROM customer GROUP BY store_id, active;

-- NULL을 제외한 집계 확인
SELECT COUNT(*) AS all_cnt, COUNT(address2) AS ex_null FROM address;

-- COUNT 함수와 DISTINCT 문 조합
SELECT COUNT(*), COUNT(store_id), COUNT(DISTINCT store_id) FROM customer;

-- p.252 SUM 함수로 amount 열의 데이터 합산
SELECT SUM(amount) FROM payment;

-- SUM 함수와 GROUP BY 문 조합
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id;

-- p.253 암시적 형 변환으로 오버플로 없이 합산 결과를 반환
CREATE TABLE doit_overflow (
col_1 int,
col_2 int,
col_3 int
);

INSERT INTO doit_overflow VALUES (1000000000,1000000000, 1000000000);
INSERT INTO doit_overflow VALUES (1000000000,1000000000, 1000000000);
INSERT INTO doit_overflow VALUES (1000000000,1000000000, 1000000000);

SELECT SUM(col_1) FROM doit_overflow;

-- p.254 AVG 함수로 amount 열의 데이터 평균 계산
SELECT AVG(amount) FROM payment;

-- AVG 함수와 GROUP BY 문 조합
SELECT customer_id, AVG(amount) FROM payment GROUP BY customer_id;

-- p.255 MIN과 MAX 함수로 amount 열의 최솟값과 최댓값 조회
SELECT MIN(amount), MAX(amount) FROM payment;

-- MIN과 MAX 함수 그리고 GROUP BY 문 조합
SELECT customer_id, MIN(amount), MAX(amount) FROM payment GROUP BY customer_id;

-- p.256 ROLLUP 함수로 부분합 계산
SELECT 
	customer_id, staff_id, SUM(amount)
FROM payment
GROUP BY customer_id, staff_id WITH ROLLUP;

-- p.257 STDDEV와 STDDEV_SAMP 함수로 표준편차 계산
SELECT STDDEV(amount), STDDEV_SAMP(amount) FROM payment;

