# 7장. 집계함수 (Aggregate Functions)

## 📖 수업 개요

이 장에서는 데이터베이스의 여러 행을 하나의 결과값으로 축약하는 집계함수(Aggregate Functions)를 학습합니다.
COUNT, SUM, AVG, MAX, MIN 등 기본 집계함수부터 GROUP BY와 HAVING을 사용한 고급 그룹화 기법까지 다룹니다. 실무에서 판매량, 매출액, 평균 점수 등 다양한 통계정보를 계산하는 데 필수적인 기술입니다.

---

## 📚 Part 1: 이론 학습

### 🌟 이 부분에서 배우는 것

- COUNT 함수의 다양한 사용법
- SUM, AVG, MAX, MIN 함수
- GROUP BY를 사용한 그룹화
- HAVING 절로 그룹 필터링
- NULL 값 처리 방법
- 그룹화 성능 최적화

---

### 7.1 COUNT 함수

**COUNT 함수**는 지정한 열의 행 개수를 반환합니다.

**문법:**

```sql
SELECT COUNT(*) FROM table_name;
SELECT COUNT(column) FROM table_name;
SELECT COUNT(DISTINCT column) FROM table_name;
```

**특징:**

- COUNT(*): 모든 행의 개수 반환 (NULL 포함)
- COUNT(column): 해당 열의 NULL이 아닌 값의 개수
- COUNT(DISTINCT column): 중복을 제거한 서로 다른 값의 개수

**예시:**

```sql
SELECT COUNT(*) FROM employees;              -- 전체 직원 수
SELECT COUNT(manager_id) FROM employees;     -- 상급자가 있는 직원 수
SELECT COUNT(DISTINCT dept_id) FROM employees; -- 부서 수
```

---

### 7.2 SUM 함수

**SUM 함수**는 숫자 열의 합계를 반환합니다.

**문법:**

```sql
SELECT SUM(column) FROM table_name;
```

**특징:**

- 숫자 데이터만 가능
- NULL 값은 자동으로 제외
- 모든 값이 NULL이면 NULL 반환

**예시:**

```sql
SELECT SUM(salary) FROM employees;  -- 전체 급여 합계
SELECT SUM(quantity) FROM orders;   -- 전체 주문 수량 합계
```

---

### 7.3 AVG 함수

**AVG 함수**는 숫자 열의 평균을 반환합니다.

**문법:**

```sql
SELECT AVG(column) FROM table_name;
```

**특징:**

- NULL 값은 자동으로 제외
- 모든 값이 NULL이면 NULL 반환
- 소수점 자리수에 주의

**예시:**

```sql
SELECT AVG(salary) FROM employees;   -- 평균 급여
SELECT ROUND(AVG(score), 2) FROM results; -- 평균 점수 (소수 2자리)
```

---

### 7.4 MAX와 MIN 함수

**MAX 함수**는 최대값, **MIN 함수**는 최소값을 반환합니다.

**문법:**

```sql
SELECT MAX(column) FROM table_name;
SELECT MIN(column) FROM table_name;
```

**특징:**

- 숫자, 문자, 날짜 등 모든 데이터타입에 사용 가능
- NULL 값은 자동으로 제외
- 가장 최근 날짜나 가장 큰 문자값 찾기에 유용

**예시:**

```sql
SELECT MAX(salary) FROM employees;        -- 최고 급여
SELECT MIN(birth_date) FROM employees;    -- 가장 오래된 생년월일
SELECT MAX(order_date) FROM orders;       -- 가장 최근 주문일
```

---

### 7.5 GROUP BY 절

**GROUP BY**는 행들을 그룹으로 나누어 각 그룹에 대해 집계함수를 적용합니다.

**문법:**

```sql
SELECT column, aggregate_function(column)
FROM table_name
GROUP BY column;
```

**예시:**

```sql
SELECT dept_id, AVG(salary)
FROM employees
GROUP BY dept_id;           -- 부서별 평균 급여

SELECT category, COUNT(*) AS count
FROM products
GROUP BY category;          -- 카테고리별 상품 개수
```

---

### 7.6 여러 열로 GROUP BY

여러 열로 그룹화하여 더 세밀한 분석이 가능합니다.

**예시:**

```sql
SELECT dept_id, year, COUNT(*) AS count
FROM employees
GROUP BY dept_id, year;     -- 부서, 연도별 직원 수

SELECT category, color, SUM(quantity) AS total_qty
FROM inventory
GROUP BY category, color;   -- 카테고리, 색상별 재고 수량
```

---

### 7.7 HAVING 절

**HAVING**은 GROUP BY 결과에 조건을 적용하는 WHERE 역할을 합니다.

**문법:**

```sql
SELECT column, aggregate_function(column)
FROM table_name
GROUP BY column
HAVING aggregate_function(column) > value;
```

**예시:**

```sql
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 4000000;  -- 평균 급여가 400만 이상인 부서

SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) >= 5;  -- 상품이 5개 이상인 카테고리
```

---

### 7.8 집계함수와 NULL 처리

NULL 값은 집계함수에서 특별하게 처리됩니다.

**특징:**

- COUNT(*) 제외: NULL 값도 개수에 포함
- COUNT(column): NULL 값 제외
- SUM, AVG, MAX, MIN: 모두 NULL 제외

**NULL 변환:**

```sql
SELECT SUM(commission) FROM employees;      -- NULL은 제외
SELECT SUM(IFNULL(commission, 0)) FROM employees;  -- NULL을 0으로 변환
```

---

### 7.9 WITH ROLLUP

**WITH ROLLUP**은 그룹별 소계와 총계를 함께 표시합니다.

**문법:**

```sql
SELECT column, aggregate_function(column)
FROM table_name
GROUP BY column WITH ROLLUP;
```

**예시:**

```sql
SELECT dept_id, SUM(salary)
FROM employees
GROUP BY dept_id WITH ROLLUP;  -- 부서별, 전체 합계를 표시
```

---

## 📚 Part 2: 샘플 데이터

### sales 테이블

```sql
CREATE DATABASE ch7_aggr CHARACTER SET utf8mb4;
USE ch7_aggr;

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    sale_date DATE,
    employee_id INT
);

INSERT INTO sales VALUES
(1, 1, 10, 50000, '2024-01-15', 1),
(2, 2, 5, 100000, '2024-01-15', 1),
(3, 1, 8, 50000, '2024-01-16', 2),
(4, 3, 3, 200000, '2024-01-16', 2),
(5, 2, 15, 100000, '2024-01-17', 1),
(6, 1, 20, 50000, '2024-01-17', 3),
(7, 4, 2, 500000, '2024-01-18', 3),
(8, 2, 10, 100000, '2024-01-18', 2);
```

### products 테이블

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10, 2),
    stock INT
);

INSERT INTO products VALUES
(1, '노트북 A', '전자제품', 50000, 100),
(2, '마우스 B', '전자제품', 100000, 200),
(3, '모니터 C', '전자제품', 200000, 50),
(4, '키보드 D', '전자제품', 500000, 30);
```

---

## 💻 Part 3: 실습

### 🌟 이 부분에서 배우는 것

- 집계함수의 올바른 사용법
- GROUP BY와 HAVING의 조합
- 실무에서 자주 사용되는 집계 패턴
- NULL 처리 및 성능 최적화

---


```sql
-- =====================================================
-- 7-1~7-10: 기본 집계함수 (COUNT, SUM, AVG, MAX, MIN)
-- =====================================================

-- 1. COUNT 함수 기본 (전체 판매 건수)
SELECT COUNT(*) AS total_sales FROM sales;

-- 2. COUNT와 DISTINCT (판매된 서로 다른 상품 개수)
SELECT COUNT(DISTINCT product_id) AS distinct_products FROM sales;

-- 3. NULL을 포함한 COUNT (NULL 제외한 개수)
SELECT COUNT(product_id) AS non_null_count FROM sales;

-- 4. SUM 함수 (전체 판매량 합계)
SELECT SUM(quantity) AS total_quantity FROM sales;

-- 5. SUM과 조건 (특정 날짜 이후 판매액 합계)
SELECT SUM(quantity * unit_price) AS total_sales_amount 
FROM sales 
WHERE sale_date >= '2024-01-16';

-- 6. AVG 함수 (평균 판매 수량)
SELECT AVG(quantity) AS avg_quantity FROM sales;

-- 7. AVG와 ROUND (평균 판매액, 소수 2자리)
SELECT ROUND(AVG(unit_price), 2) AS avg_price FROM sales;

-- 8. MAX 함수 (가장 높은 단가)
SELECT MAX(unit_price) AS max_price FROM sales;

-- 9. MIN 함수 (가장 낮은 단가)
SELECT MIN(unit_price) AS min_price FROM sales;

-- 10. MAX와 MIN의 조합 (단가 범위)
SELECT MAX(unit_price) - MIN(unit_price) AS price_range FROM sales;

-- =====================================================
-- 7-11~7-20: GROUP BY와 HAVING
-- =====================================================

-- 11. GROUP BY 기본 (상품별 판매 수량)
SELECT product_id, SUM(quantity) AS total_qty
FROM sales
GROUP BY product_id;

-- 12. GROUP BY와 COUNT (상품별 판매 건수)
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id;

-- 13. GROUP BY와 SUM (상품별 총 판매액)
SELECT product_id, SUM(quantity * unit_price) AS total_sales
FROM sales
GROUP BY product_id;

-- 14. GROUP BY와 AVG (상품별 평균 판매액)
SELECT product_id, AVG(unit_price) AS avg_price
FROM sales
GROUP BY product_id;

-- 15. 여러 열로 GROUP BY (직원별, 날짜별 판매액)
SELECT employee_id, DATE(sale_date) AS sale_date, SUM(quantity * unit_price) AS daily_sales
FROM sales
GROUP BY employee_id, DATE(sale_date);

-- 16. GROUP BY와 ORDER BY (상품별 판매량 내림차순)
SELECT product_id, SUM(quantity) AS total_qty
FROM sales
GROUP BY product_id
ORDER BY total_qty DESC;

-- 17. HAVING으로 그룹 필터링 (판매 건수 3건 이상인 상품)
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id
HAVING COUNT(*) >= 3;

-- 18. HAVING과 조건 (판매액 합계 500000 이상인 상품)
SELECT product_id, SUM(quantity * unit_price) AS total_sales
FROM sales
GROUP BY product_id
HAVING SUM(quantity * unit_price) >= 500000;

-- 19. WHERE와 HAVING 조합 (특정 기간 + 판매액 조건)
SELECT product_id, SUM(quantity * unit_price) AS total_sales
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY product_id
HAVING SUM(quantity * unit_price) >= 600000;

-- 20. GROUP BY 후 LIMIT (판매액 상위 3개 상품)
SELECT product_id, SUM(quantity * unit_price) AS total_sales
FROM sales
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 3;

-- =====================================================
-- 7-21~7-32: 복합 집계 및 고급 기능
-- =====================================================

-- 21. 카테고리별 통계 (상품 개수, 평균 가격, 최대 가격)
SELECT category, COUNT(*) AS product_count, 
       AVG(price) AS avg_price, MAX(price) AS max_price
FROM products
GROUP BY category;

-- 22. 직원별 판매 실적 (총 판매액, 건수, 평균)
SELECT employee_id, 
       SUM(quantity * unit_price) AS total_sales,
       COUNT(*) AS sales_count,
       AVG(quantity * unit_price) AS avg_sales
FROM sales
GROUP BY employee_id;

-- 23. 날짜별 집계 (판매액, 건수, 평균 단가)
SELECT DATE(sale_date) AS sale_date,
       SUM(quantity * unit_price) AS daily_sales,
       COUNT(*) AS transaction_count,
       AVG(unit_price) AS avg_unit_price
FROM sales
GROUP BY DATE(sale_date);

-- 24. 복합 집계 (카테고리, 상품별 판매량, 판매액, 평균 가격)
SELECT p.category, p.product_id, p.product_name,
       SUM(s.quantity) AS total_qty,
       SUM(s.quantity * s.unit_price) AS total_sales,
       AVG(s.unit_price) AS avg_unit_price
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category, p.product_id, p.product_name;

-- 25. NULL 처리 (NULL을 0으로 처리한 합계)
SELECT SUM(IFNULL(stock, 0)) AS total_stock FROM products;

-- 26. CASE와 집계함수 조합 (판매액 범주별 개수)
SELECT CASE 
           WHEN quantity * unit_price >= 500000 THEN '대'
           WHEN quantity * unit_price >= 300000 THEN '중'
           ELSE '소'
       END AS sales_category,
       COUNT(*) AS count
FROM sales
GROUP BY sales_category;

-- 27. 부분합 (WITH ROLLUP - 카테고리별 소계)
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
WITH ROLLUP;

-- 28. 계층적 집계 (WITH ROLLUP - 직원별, 날짜별)
SELECT employee_id, DATE(sale_date) AS sale_date,
       SUM(quantity * unit_price) AS total_sales
FROM sales
GROUP BY employee_id, DATE(sale_date)
WITH ROLLUP;

-- 29. 변화치 비교 (날짜별 판매액과 전일값)
SELECT DATE(sale_date) AS sale_date, 
       SUM(quantity * unit_price) AS daily_sales,
       LAG(SUM(quantity * unit_price)) OVER (ORDER BY DATE(sale_date)) AS prev_day_sales
FROM sales
GROUP BY DATE(sale_date);

-- 30. 순위 매기기 (판매액 높은 순서대로 순위)
SELECT product_id, SUM(quantity * unit_price) AS total_sales,
       ROW_NUMBER() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS ranking 
FROM sales
GROUP BY product_id;

-- 31. 기간별 비교 (특정 기간의 판매액 비교)
SELECT 
    CASE WHEN sale_date < '2024-01-16' THEN '기간1' ELSE '기간2' END AS period,
    SUM(quantity * unit_price) AS period_sales,
    COUNT(*) AS transaction_count
FROM sales
GROUP BY period;

-- 32. 그룹 내 랭킹 (각 상품 내에서 판매 순위)
SELECT product_id, sale_date, quantity * unit_price AS sales_amount,
       ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY quantity * unit_price DESC) AS product_rank
FROM sales;
```

---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: COUNT, SUM, AVG, MAX, MIN 함수의 특징을 각각 설명하고, NULL 값이 포함되었을 때의 동작 방식을 비교 분석하세요. 실무에서 각 함수가 필요한 상황을 사례와 함께 제시하세요.

**2번 과제**: GROUP BY와 WHERE, HAVING의 차이점을 설명하세요. WHERE와 HAVING을 함께 사용할 때의 실행 순서와 각각의 역할을 명확히 서술하세요.

**3번 과제**: 여러 열로 GROUP BY할 때의 주의사항을 설명하세요. SELECT 절에 그룹화되지 않은 열이 포함될 경우의 문제점과 해결 방법을 논의하세요.

**4번 과제**: 집계함수가 포함된 쿼리의 성능 최적화 방법을 제시하세요. 인덱스 활용, 집계 시점 조절, 부분 집계 등의 기법을 설명하세요.

**5번 과제**: WITH ROLLUP, 윈도우 함수, 서브쿼리를 사용한 고급 집계 기법을 설명하세요. 각 기법의 장단점을 비교하고 활용 사례를 제시하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 판매 데이터에서 다음의 집계 쿼리를 작성하세요:

- 전체 판매 건수, 판매액 합계, 평균 판매액
- 상품별 판매 건수, 판매액 합계, 평균 판매액
- 직원별 판매 실적 (판매액, 건수, 평균)
- 판매액이 높은 순서대로 상위 5개 상품

**2번 과제**: GROUP BY와 HAVING을 사용하여 다음을 조회하세요:

- 판매 건수가 3건 이상인 상품
- 판매액 합계가 500000 이상인 직원
- 평균 판매액이 전체 평균보다 높은 상품

**3번 과제**: NULL 처리, CASE 문, 형식 변환을 포함한 복합 집계를 수행하세요:

- commission 포함 직원별 총 보상액 계산
- 판매액을 범주(대/중/소)로 분류하여 범주별 통계
- 분기별 판매 성과 분석

**4번 과제**: WITH ROLLUP을 사용하여 계층적 집계를 수행하세요:

- 카테고리별, 상품별 판매액 소계 및 전체 합계
- 지역별, 지점별 판매 실적 계층적 표시
- 연도별, 월별 누적 판매액

**5번 과제**: Part 3의 실습 7-1부터 7-32까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 창의적인 집계 쿼리를 작성하여 그 결과를 제시하고, 각 쿼리가 어떤 비즈니스 의사결정에 도움이 될 수 있는지 설명하세요.

제출 형식: SQL 파일 (Ch7_Aggregate_Functions_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
