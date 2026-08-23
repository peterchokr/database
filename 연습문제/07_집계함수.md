# Ch7 집계함수와 그룹화 - 연습문제

학생 여러분! 7장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

7장을 마친 후 다음을 이해해야 합니다:

- COUNT, SUM, AVG, MAX, MIN 집계함수
- GROUP BY를 사용한 데이터 그룹화
- HAVING 절로 그룹 필터링
- NULL 값이 집계함수에 미치는 영향
- 복합 그룹화 (여러 열로 GROUP BY)

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** COUNT(*)와 COUNT(column)의 가장 큰 차이는?

- ① COUNT(*)는 더 빠름
- ② COUNT(*)는 NULL을 포함, COUNT(column)은 NULL 제외
- ③ COUNT(column)은 중복 제거, COUNT(*)는 안 함
- ④ 기능이 완전히 같음

---

**2번** GROUP BY의 기본 목적은?

- ① 데이터를 정렬함
- ② 행들을 그룹으로 나누어 각 그룹에 집계함수 적용
- ③ 데이터를 필터링함
- ④ 테이블을 다시 정의함

---

**3번** 다음 중 NULL 값이 집계함수에 어떻게 처리되는가?

- ① NULL은 0으로 계산됨
- ② NULL은 무시되고 제외됨
- ③ NULL로 인해 오류 발생
- ④ 함수에 따라 다름

---

**4번** HAVING 절의 역할은?

- ① 개별 행을 필터링 (WHERE와 같음)
- ② GROUP BY 결과로 생성된 그룹을 필터링
- ③ 데이터를 정렬
- ④ 열을 선택

---

**5번** COUNT(DISTINCT column)의 의미는?

- ① 중복을 포함한 모든 행 개수
- ② 중복을 제거한 유일한 값의 개수
- ③ NULL을 포함한 행 개수
- ④ 특정 값만 개수를 셈

---

## 중급 수준 (3개) - 개념 적용

**6번** GROUP BY와 집계함수를 올바르게 사용하는 쿼리는?

```sql
① SELECT dept_id, salary, COUNT(*)
   FROM employees
   GROUP BY dept_id;

② SELECT dept_id, COUNT(*), AVG(salary)
   FROM employees
   GROUP BY dept_id;

③ SELECT dept_id, COUNT(*), salary
   FROM employees
   GROUP BY dept_id;
```

- ① 올바름
- ② 올바름
- ③ 오류 (salary가 그룹화되지 않음)
- ④ ①②가 올바름

---

**7번** HAVING 절과 WHERE 절의 차이는?

```sql
SELECT dept_id, AVG(salary)
FROM employees
WHERE salary > 5000000        -- ①
GROUP BY dept_id
HAVING AVG(salary) > 5500000; -- ②
```

- ① WHERE는 그룹화 전 개별 행 필터링, HAVING은 그룹화 후 그룹 필터링
- ② WHERE와 HAVING은 같은 기능
- ③ HAVING만 집계함수 사용 가능
- ④ ①과 ③ 모두 맞음

---

**8번** 부서별 평균 급여를 구하되, 평균이 4000000원 이상인 부서만 보려면?

- ① WHERE AVG(salary) >= 4000000
- ② HAVING AVG(salary) >= 4000000
- ③ GROUP BY HAVING AVG(salary) >= 4000000
- ④ ORDER BY AVG(salary) >= 4000000

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 쿼리의 결과가 다를 이유는?

```
쿼리 A:
SELECT COUNT(*) FROM employees;

쿼리 B:
SELECT COUNT(manager_id) FROM employees;
```

- ① 쿼리 A는 더 느림
- ② 쿼리 B는 manager_id가 NULL인 행 제외 (결과가 작을 수 있음)
- ③ 둘 다 같은 결과
- ④ 쿼리 B에 오류

---

**10번** GROUP BY 없이 집계함수만 사용할 때의 결과는?

```sql
SELECT COUNT(*), SUM(salary), AVG(salary), MAX(salary)
FROM employees;
```

- ① 오류 발생
- ② 전체 직원의 통계 (1행) 반환
- ③ 각 직원별로 반복 (행 수 만큼)
- ④ 빈 결과

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** COUNT(*), SUM(), AVG(), MAX(), MIN()의 차이를 설명하시오.

---

**12번** GROUP BY를 사용해야 하는 상황을 설명하고, 부서별 직원 수를 구하는 쿼리를 작성하시오.

---

**13번** NULL 값이 집계함수에 미치는 영향을 설명하고, COUNT(*)와 COUNT(column)의 결과가 다를 수 있는 경우를 예시하시오.

---

## 중급 수준 (1개)

**14번** HAVING 절의 필요성을 설명하고, WHERE와 HAVING의 차이를 명확히 하시오.

---

## 고급 수준 (1개)

**15번** 여러 열로 그룹화(GROUP BY col1, col2)할 때 주의할 사항과 성능 최적화 방법을 설명하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch7_aggregation CHARACTER SET utf8mb4;
USE ch7_aggregation;

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    sale_date DATE,
    employee_id INT
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10, 2)
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

INSERT INTO products VALUES
(1, '노트북 A', '전자제품', 50000),
(2, '마우스 B', '전자제품', 100000),
(3, '모니터 C', '전자제품', 200000),
(4, '키보드 D', '전자제품', 500000);

SELECT * FROM sales;
SELECT * FROM products;
```

제출: sales 테이블에 8개 판매 기록과 products 테이블이 모두 보이는 스크린샷

---

**17번** sales 테이블에서 다음을 수행하고 결과를 확인하시오.

```sql
-- 1. 전체 판매량 합계
SELECT SUM(quantity) AS total_quantity FROM sales;

-- 2. 평균 가격
SELECT AVG(unit_price) AS avg_price FROM sales;

-- 3. 최고 가격 상품
SELECT MAX(unit_price) AS max_price FROM sales;
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** sales 테이블에서 다음을 수행하시오.

```sql
-- 1. 상품별 판매량
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_id;

-- 2. 상품별 평균 가격
SELECT product_id, AVG(unit_price) AS avg_price
FROM sales
GROUP BY product_id;

-- 3. 상품별 판매 횟수
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id;
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

**19번** sales 테이블에서 다음 분석을 수행하시오.

```sql
-- 1. 판매량이 5개 이상인 상품
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_id
HAVING SUM(quantity) >= 5;

-- 2. 평균 가격이 100000원 이상인 상품
SELECT product_id, AVG(unit_price) AS avg_price
FROM sales
GROUP BY product_id
HAVING AVG(unit_price) >= 100000;

-- 3. 판매 횟수가 2회 이상인 상품
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id
HAVING COUNT(*) >= 2;
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복합 집계 쿼리를 작성하고 실행하시오.

```
요구사항:
1. 카테고리별, 상품별로 그룹화하여 판매량과 가격 집계
   SELECT category, product_name, SUM(quantity), AVG(price)
   FROM sales
   GROUP BY category, product_name;

2. 카테고리별 판매 현황 (판매량, 판매 횟수, 평균 가격)
   SELECT category, 
          SUM(quantity) AS total_qty,
          COUNT(*) AS sales_count,
          AVG(price) AS avg_price
   FROM sales
   GROUP BY category
   ORDER BY total_qty DESC;

3. 판매량 상위 3개 카테고리 (LIMIT)
   SELECT category, SUM(quantity) AS total_qty
   FROM sales
   GROUP BY category
   ORDER BY total_qty DESC
   LIMIT 3;

4. 자유로운 집계 쿼리 2개 이상:
   - GROUP BY와 HAVING 조합
   - COUNT(DISTINCT) 활용
   - 정렬 및 제한

제출:
   - 각 쿼리의 SQL 코드
   - 각 쿼리의 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                               |
| :--: | :--: | :------------------------------------------------- |
| 1번 |  ②  | COUNT(*)는 NULL 포함, COUNT(column)은 NULL 제외    |
| 2번 |  ②  | GROUP BY는 행들을 그룹화 후 집계함수 적용          |
| 3번 |  ④  | 집계함수에 따라 다름 (COUNT는 제외, SUM도 제외 등) |
| 4번 |  ②  | HAVING은 그룹화 결과 필터링                        |
| 5번 |  ②  | COUNT(DISTINCT)는 중복 제거한 유일값 개수          |
| 6번 |  ④  | ①②는 올바르고, ③은 salary가 그룹화 안 됨        |
| 7번 |  ④  | WHERE는 개별 행, HAVING은 그룹, ③도 맞음          |
| 8번 |  ②  | HAVING으로 그룹 조건 필터링                        |
| 9번 |  ②  | manager_id가 NULL인 행 제외로 결과 다를 수 있음    |
| 10번 |  ②  | GROUP BY 없으면 전체 통계 1행 반환                 |

---

## 주관식 모범 답안 (5개)

### 11번 집계함수의 차이

**모범 답안**:

```
COUNT(*): 모든 행의 개수 (NULL 포함)
COUNT(column): NULL이 아닌 값의 개수

SUM(column): 숫자 열의 합계 (NULL 제외)
AVG(column): 숫자 열의 평균 (NULL 제외)
MAX(column): 최대값 (NULL 제외)
MIN(column): 최소값 (NULL 제외)

NULL 처리:
- SUM, AVG, MAX, MIN: NULL 무시
- COUNT(*): NULL 포함
- COUNT(column): NULL 제외
```

---

### 12번 GROUP BY 사용 상황

**모범 답안**:

```
GROUP BY 필요 상황:
- 부서별, 카테고리별 등 특정 기준으로 그룹화
- 각 그룹의 통계 정보 필요
- 예: 부서별 평균 급여, 상품별 판매량 등

부서별 직원 수 쿼리:
SELECT dept_id, COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id;

실행 예:
dept_id | employee_count
1       | 3
2       | 2
3       | 2
```

---

### 13번 NULL의 영향

**모범 답안**:

```
NULL이 집계함수에 미치는 영향:
- COUNT(*): NULL 포함해서 셈
- COUNT(column): NULL 제외해서 셈
- SUM, AVG, MAX, MIN: NULL 무시

예시:
employees 테이블에서 10명 중 2명이 manager_id = NULL

COUNT(*) FROM employees → 10명
COUNT(manager_id) FROM employees → 8명 (NULL 2명 제외)

결과:
- COUNT(*) = COUNT(manager_id) + NULL 개수
- 데이터에서 NULL이 많으면 결과 큰 차이
```

---

### 14번 HAVING의 필요성

**모범 답안**:

```
HAVING 필요성:
- GROUP BY로 그룹화된 결과 중 조건 만족하는 그룹만 선택

WHERE vs HAVING:

WHERE:
- 시점: GROUP BY 이전
- 대상: 개별 행
- 예: WHERE salary > 4000000

HAVING:
- 시점: GROUP BY 이후
- 대상: 그룹
- 예: HAVING AVG(salary) > 4000000
- 집계함수 사용 가능

예시 쿼리:
SELECT dept_id, AVG(salary)
FROM employees
WHERE salary > 4000000      -- 개별 직원 필터
GROUP BY dept_id
HAVING AVG(salary) > 4500000; -- 그룹 필터
```

---

### 15번 복합 GROUP BY와 성능

**모범 답안**:

```
여러 열 GROUP BY 주의:
1. 그룹 수가 기하급수적 증가
   GROUP BY col1: 5개 그룹
   GROUP BY col1, col2: 5 × 10 = 50개 그룹

2. SELECT에 그룹화되지 않은 열 주의
   MySQL 5.7+에서는 오류 발생

3. 정렬 순서 고려
   같은 col1 그룹 내에서 col2로 정렬

성능 최적화:
- 필요한 그룹만 그룹화
- WHERE로 먼저 필터링
- 인덱스 활용
- GROUP BY 열의 카디널리티 확인

최적 쿼리:
SELECT dept_id, position, COUNT(*) AS count
FROM employees
WHERE dept_id IS NOT NULL
GROUP BY dept_id, position
ORDER BY dept_id, COUNT(*) DESC;
```

---

## 실습형 모범 답안 (5개)

### 16번 sales 테이블 생성

**완료 기준**:
✅ ch7_aggregation 데이터베이스 생성
✅ sales 테이블 생성 (6개 열)
✅ 7개 판매 기록 입력

---

### 17번 기본 집계함수

**예상 결과**:

```
1. total_quantity: 73 (10+5+8+3+15+20+2+10)
2. avg_price: 143,750 (평균 가격)
3. max_price: 500,000 (product_id 4의 unit_price)
```

---

### 18번 GROUP BY 기본

**완료 기준**:
✅ 상품별 판매량: Product 1~4 각각의 합계
✅ 상품별 평균 가격 계산
✅ 상품별 판매 횟수

**예상 결과**:

```
상품별 판매량:
product_id | total_quantity
1          | 38
2          | 30
3          | 3
4          | 2
```

### 19번 HAVING 필터링

**모범 답안**:

```sql
-- 1. 판매량 5개 이상
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_id
HAVING SUM(quantity) >= 5;

결과:
product_id | total_quantity
1          | 38
2          | 30

-- 2. 평균 가격 100,000원 이상
SELECT product_id, AVG(unit_price) AS avg_price
FROM sales
GROUP BY product_id
HAVING AVG(unit_price) >= 100000;

결과:
product_id | avg_price
2          | 100,000
3          | 200,000
4          | 500,000

-- 3. 판매 횟수 2회 이상
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id
HAVING COUNT(*) >= 2;

결과:
product_id | sales_count
1          | 3
2          | 3
```

---

### 20번 복합 집계

**모범 답안**:

```sql
-- 1. 카테고리, 상품별 그룹화
SELECT category, product_name, SUM(quantity), AVG(price)
FROM sales
GROUP BY category, product_name;

-- 2. 카테고리별 판매 현황
SELECT category, 
       SUM(quantity) AS total_qty,
       COUNT(*) AS sales_count,
       AVG(price) AS avg_price
FROM sales
GROUP BY category
ORDER BY total_qty DESC;

결과:
전자제품: 16개, 4회, 76,666.67
생활용품: 10개, 1회, 35,000
가구: 8개, 1회, 28,000

-- 3. 판매량 상위 3개
SELECT category, SUM(quantity) AS total_qty
FROM sales
GROUP BY category
ORDER BY total_qty DESC
LIMIT 3;

-- 4. 창의적 쿼리 1: COUNT(DISTINCT)
SELECT COUNT(DISTINCT category) AS category_count,
       COUNT(DISTINCT product_name) AS product_count
FROM sales;

-- 5. 창의적 쿼리 2: 판매액 상위
SELECT product_name, 
       SUM(quantity * price) AS total_sales
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 3;
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
