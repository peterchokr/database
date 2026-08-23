# Ch3 SELECT 기본 - 연습문제

학생 여러분! 3장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

3장을 마친 후 다음을 이해해야 합니다:

- SELECT 명령어의 기본 구조 이해
- SELECT 실행 순서 (FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT)
- DISTINCT로 중복 제거
- ORDER BY로 정렬
- LIMIT/OFFSET으로 페이지네이션
- 열 별칭의 활용

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** SELECT 실행 순서에서 WHERE 절은 어디에 실행되는가?

- ① FROM 이전
- ② FROM 이후, GROUP BY 이전
- ③ SELECT 이후
- ④ ORDER BY 이후

---

**2번** DISTINCT의 역할은?

- ① 행을 정렬함
- ② 중복된 행을 제거하고 유일한 행만 표시
- ③ 조건에 맞는 행만 선택
- ④ 행의 개수를 세어줌

---

**3번** 다음 SQL에서 열 별칭(alias)의 목적은?

```sql
SELECT student_id AS '학번', student_name AS '학생명'
FROM student;
```

- ① 테이블 이름 변경
- ② 조회 결과의 열 이름을 더 이해하기 쉽게 표시
- ③ 데이터 타입 변경
- ④ WHERE 절의 성능 향상

---

**4번** ORDER BY를 사용할 때 기본 정렬 순서는?

- ① 무작위
- ② 내림차순 (DESC)
- ③ 오름차순 (ASC)
- ④ 입력 순서

---

**5번** LIMIT 10 OFFSET 20의 의미는?

- ① 처음 10개 행 조회
- ② 처음 20개 행 조회
- ③ 21번째부터 30번째까지 10개 행 조회
- ④ 20번째부터 10개씩 무한 조회

---

## 중급 수준 (3개) - 개념 적용

**6번** 다음 쿼리에서 WHERE 절이 GROUP BY 절 이전에 실행되는 이유는?

```sql
SELECT department, COUNT(*)
FROM employee
WHERE salary > 5000000
GROUP BY department;
```

- ① 항상 WHERE가 먼저 실행됨
- ② WHERE로 먼저 필요한 데이터만 필터링 후 GROUP BY 적용 (효율성)
- ③ GROUP BY로 같은 부서끼리 묶은 후 WHERE로 필터링
- ④ 순서는 상관없음

---

**7번** movie 테이블에서 2023년 이후에 개봉한 영화들을 평점 높은 순으로 상위 5개만 조회하려면?

```sql
① SELECT * FROM movie
   WHERE release_year >= 2023
   ORDER BY rating DESC
   LIMIT 5;

② SELECT * FROM movie
   LIMIT 5
   WHERE release_year >= 2023
   ORDER BY rating DESC;

③ SELECT * FROM movie
   ORDER BY rating DESC
   WHERE release_year >= 2023
   LIMIT 5;
```

- ① 올바른 순서 (WHERE → ORDER BY → LIMIT)
- ② 올바른 순서 (LIMIT 위치만 다름)
- ③ 올바른 순서 (WHERE 위치만 다름)
- ④ ①만 올바름

---

**8번** 복수 열로 정렬할 때 ORDER BY category ASC, price DESC의 의미는?

- ① 카테고리와 가격 모두 오름차순
- ② 카테고리는 오름차순, 가격은 내림차순 (같은 카테고리 내 가격으로 정렬)
- ③ 카테고리 우선 정렬, 가격으로는 정렬 안 함
- ④ 가격 우선 정렬, 카테고리는 무시

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 두 쿼리의 실행 결과가 다른 이유는?

```
쿼리 A:
SELECT * FROM movie
WHERE rating >= 8.0
LIMIT 10;

쿼리 B:
SELECT * FROM movie
LIMIT 10
WHERE rating >= 8.0;
```

- ① 두 쿼리 모두 같은 결과
- ② 쿼리 A는 valid, 쿼리 B는 문법 오류 (WHERE는 LIMIT 전에 와야 함)
- ③ 쿼리 B가 더 빠름
- ④ 둘 다 시스템에 따라 다름

---

**10번** 다음 상황에서 가장 효율적인 쿼리는?

"1000개 상품 중 '전자제품' 카테고리에서 가격이 높은 순으로 상위 20개를 조회하되,
페이지당 10개씩 보여주고 현재 3번째 페이지를 조회"

```
① SELECT * FROM product
   WHERE category = '전자제품'
   ORDER BY price DESC
   LIMIT 10 OFFSET 20;

② SELECT * FROM product
   ORDER BY price DESC
   LIMIT 10 OFFSET 20
   WHERE category = '전자제품';

③ SELECT * FROM product
   LIMIT 10 OFFSET 20
   WHERE category = '전자제품';
```

- ① 올바름 (WHERE로 먼저 필터링 → ORDER BY → LIMIT/OFFSET)
- ② 문법 오류
- ③ 문법 오류
- ④ ②와 ③ 모두 올바름

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** SELECT 명령어의 기본 실행 순서 7단계를 나열하시오.

---

**12번** movie 테이블에서 장르(genre)가 중복되지 않게 모든 장르를 조회하려면 어떤 키워드를 사용해야 하며, 그 이유를 설명하시오.

---

**13번** 다음 결과를 얻기 위한 SELECT 문을 작성하시오.

```
product 테이블에서 전자제품의 가격을 조회
열 이름을 다음과 같이 별칭으로 표시:
- product_name → 상품명
- price → 원가
- price * 1.1 → 10% 인상가
```

---

## 중급 수준 (1개)

**14번** ORDER BY 복수 열 정렬의 중요성을 설명하고, 실무 예시를 제시하시오.

---

## 고급 수준 (1개)

**15번** LIMIT과 OFFSET을 사용한 페이지네이션의 공식을 설명하고, 5개 상품씩 보여주는 페이지 1, 2, 3의 OFFSET 값을 계산하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch3_practice CHARACTER SET utf8mb4;
USE ch3_practice;

CREATE TABLE movie (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    genre VARCHAR(20),
    release_year INT,
    rating DECIMAL(3,1)
);

INSERT INTO movie VALUES
(1, '쇼핑몰의 왕', '드라마', 2023, 8.5),
(2, '코딩의 예술', '액션', 2023, 7.8),
(3, '데이터 세계', '판타지', 2022, 8.2),
(4, '로맨틱 SQL', '로맨스', 2023, 7.5),
(5, '애니메이션 서버', '애니메이션', 2023, 8.0);

SELECT * FROM movie;
```

제출: movie 테이블에 5개 영화 데이터가 모두 입력된 스크린샷 1장

---

**17번** movie 테이블에서 다음을 수행하고 결과를 확인하시오.

```sql
-- 1. 평점 높은 순으로 정렬
SELECT title AS '영화제목', rating AS '평점'
FROM movie
ORDER BY rating DESC;

-- 2. 장르 중복 제거
SELECT DISTINCT genre AS '장르'
FROM movie;

-- 3. 2023년 이후 영화만 조회
SELECT title, release_year
FROM movie
WHERE release_year >= 2023;
```

제출: 3개 쿼리 모두의 결과가 보이는 스크린샷 1장 이상

---

## 중급 수준 (2개)

**18번** product 테이블을 생성하고 다음을 수행하시오.

```sql
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category VARCHAR(20),
    price INT,
    rating DECIMAL(3,2)
);

INSERT INTO product VALUES
(1, '무선 마우스', '전자제품', 45000, 4.50),
(2, '기계식 키보드', '전자제품', 120000, 4.60),
(3, '모니터 암', '전자제품', 65000, 4.30),
(4, '책상 스탠드', '생활용품', 35000, 4.40),
(5, '의자 쿠션', '가구', 28000, 4.20);

-- 1. 전자제품만 조회
SELECT * FROM product
WHERE category = '전자제품';

-- 2. 가격 낮은 순으로 정렬
SELECT product_name, price
FROM product
ORDER BY price ASC;

-- 3. 상위 3개 상품만 조회
SELECT product_name, price
FROM product
LIMIT 3;
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

**19번** movie 테이블에서 다음 분석을 수행하고 결과를 제시하시오.

```
질문:
1. 영화를 평점 높은 순으로 정렬하고 상위 3개만 표시하는 SQL 작성
2. 장르별로 유일한 값만 조회하는 SQL 작성
3. 2023년 이후 영화 중 평점 8.0 이상인 영화만 조회하는 SQL 작성
4. 각 쿼리의 결과를 스크린샷으로 제시

제출: 3개 SQL 코드 + 실행 결과 스크린샷
```

---

## 고급 수준 (1개)

**20번** 10개의 상품이 있는 product 테이블을 설계하고, 상품을 페이지당 3개씩 표시할 때 다음을 수행하시오.

```
요구사항:
1. product 테이블 생성 (10개 상품 데이터)
   - product_id, product_name, category, price, rating

2. 다음 쿼리 작성 및 실행:
   a) 페이지 1 (처음 3개): LIMIT 3
   b) 페이지 2 (4~6번): LIMIT 3 OFFSET 3
   c) 페이지 3 (7~9번): LIMIT 3 OFFSET 6
   d) 페이지 4 (10~12번): LIMIT 3 OFFSET 9

3. 각 페이지의 결과가 정확한지 확인

4. 다음도 함께 수행:
   - 카테고리별로 정렬한 후 각 카테고리의 첫 상품만 조회
   - 가격이 가장 비싼 상품 TOP 5 조회
   - 평점 4.5 이상인 상품을 가격으로 정렬

제출: 
   - CREATE TABLE SQL
   - INSERT SQL (10개 상품)
   - 모든 SELECT 쿼리 코드
   - 각 쿼리의 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                                                                 |
| :--: | :--: | :----------------------------------------------------------------------------------- |
| 1번 |  ②  | SELECT 실행 순서: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT |
| 2번 |  ②  | DISTINCT는 중복된 행을 제거하고 유일한 행만 표시                                     |
| 3번 |  ②  | 열 별칭은 조회 결과의 열 이름을 더 이해하기 쉽게 표시                                |
| 4번 |  ③  | ORDER BY 기본값은 오름차순(ASC)                                                      |
| 5번 |  ③  | LIMIT 10 OFFSET 20은 21~30번째 10개 행 조회 (OFFSET = (페이지-1) * 행수)             |
| 6번 |  ②  | WHERE로 먼저 필터링하면 GROUP BY의 처리량 감소 (효율성)                              |
| 7번 |  ①  | 올바른 순서: WHERE → ORDER BY → LIMIT                                              |
| 8번 |  ②  | ORDER BY category ASC, price DESC는 카테고리 우선 오름, 같은 카테고리 내 가격 내림   |
| 9번 |  ②  | 쿼리 B는 WHERE가 LIMIT 뒤에 있어 문법 오류 (SQL 문법 위반)                           |
| 10번 |  ①  | WHERE로 필터링 → ORDER BY로 정렬 → LIMIT/OFFSET으로 페이징이 올바름                |

---

## 주관식 모범 답안 (5개)

### 11번 SELECT 실행 순서 7단계

**모범 답안**:

```
1. FROM: 조회할 테이블 결정
2. WHERE: 행 필터링 (조건에 맞는 행 선택)
3. GROUP BY: 행을 그룹으로 묶음
4. HAVING: 그룹 필터링 (조건에 맞는 그룹 선택)
5. SELECT: 조회할 열 결정
6. ORDER BY: 결과 정렬
7. LIMIT/OFFSET: 조회 행 수 제한 및 시작 위치 지정
```

---

### 12번 DISTINCT 사용

**모범 답안**:

- **키워드**: DISTINCT
- **SQL**: SELECT DISTINCT genre FROM movie;
- **이유**: genre 열에는 중복된 장르가 있을 수 있으므로 (예: 드라마 2개, 액션 1개), DISTINCT로 유일한 장르만 조회

---

### 13번 SELECT 열 별칭 작성

**모범 답안**:

```sql
SELECT product_name AS '상품명',
       price AS '원가',
       ROUND(price * 1.1) AS '10% 인상가'
FROM product
WHERE category = '전자제품';
```

또는 AS 없이:

```sql
SELECT product_name '상품명',
       price '원가',
       ROUND(price * 1.1) '10% 인상가'
FROM product
WHERE category = '전자제품';
```

---

### 14번 ORDER BY 복수 열 정렬

**모범 답안**:

```
중요성:
- 정렬 순서를 명확히 지정하여 일관된 결과 보장
- 부분 중복 값을 세부적으로 정렬

실무 예시:
1. 부서별 → 급여 높은 순 정렬
   SELECT * FROM employee
   ORDER BY department ASC, salary DESC;
   
2. 판매일 → 판매량 순 정렬
   SELECT * FROM sales
   ORDER BY sale_date ASC, quantity DESC;
   
3. 학과별 → 학년 순 → 성적 높은 순
   SELECT * FROM student
   ORDER BY department ASC, grade ASC, score DESC;
```

---

### 15번 페이지네이션 공식

**모범 답안**:

```
공식: OFFSET = (페이지번호 - 1) × 페이지당행수

5개 상품씩 페이지네이션:

페이지 1:
SELECT * FROM product LIMIT 5 OFFSET 0;
OFFSET = (1 - 1) × 5 = 0 (1~5번 상품)

페이지 2:
SELECT * FROM product LIMIT 5 OFFSET 5;
OFFSET = (2 - 1) × 5 = 5 (6~10번 상품)

페이지 3:
SELECT * FROM product LIMIT 5 OFFSET 10;
OFFSET = (3 - 1) × 5 = 10 (11~15번 상품)
```

---

## 실습형 모범 답안 (5개)

### 16번 movie 테이블 생성 및 데이터 입력

**완료 기준**:
✅ ch3_practice 데이터베이스 생성
✅ movie 테이블 생성 (5개 열)
✅ 5개 영화 데이터 입력
✅ SELECT * FROM movie 실행

**스크린샷 포함 내용**:

- 5개 영화 데이터가 모두 표시됨

**예상 결과**:

```
movie_id | title              | genre       | release_year | rating
1        | 쇼핑몰의 왕        | 드라마      | 2023         | 8.5
2        | 코딩의 예술        | 액션        | 2023         | 7.8
3        | 데이터 세계        | 판타지      | 2022         | 8.2
4        | 로맨틱 SQL         | 로맨스      | 2023         | 7.5
5        | 애니메이션 서버    | 애니메이션  | 2023         | 8.0
```

---

### 17번 movie 테이블 다양한 SELECT 조회

**완료 기준**:
✅ 평점 높은 순 정렬: 쇼핑몰의 왕(8.5) → 데이터 세계(8.2) → ... 순서 확인
✅ DISTINCT genre: 드라마, 액션, 판타지, 로맨스, 애니메이션 (5개 유일)
✅ 2023년 이후: 쇼핑몰의 왕, 코딩의 예술, 로맨틱 SQL, 애니메이션 서버 (4개)

**스크린샷 포함 내용**:

- 3개 쿼리 결과 모두 정확하게 표시

---

### 18번 product 테이블 다양한 조건 조회

**완료 기준**:
✅ 전자제품 카테고리 조회: 무선 마우스, 기계식 키보드, 모니터 암 3개
✅ 가격 낮은 순 정렬: 의자 쿠션(28000) → 책상 스탠드(35000) → ...
✅ 상위 3개: 처음 3개 행만 표시

**예상 결과 1 (전자제품)**:

```
product_id | product_name    | category  | price  | rating
1          | 무선 마우스     | 전자제품  | 45000  | 4.50
2          | 기계식 키보드   | 전자제품  | 120000 | 4.60
3          | 모니터 암       | 전자제품  | 65000  | 4.30
```

**예상 결과 2 (가격 낮은 순)**:

```
product_name    | price
의자 쿠션       | 28000
책상 스탠드     | 35000
무선 마우스     | 45000
```

**예상 결과 3 (상위 3개)**:

```
product_id | product_name    | category  | price  | rating
1          | 무선 마우스     | 전자제품  | 45000  | 4.50
2          | 기계식 키보드   | 전자제품  | 120000 | 4.60
3          | 모니터 암       | 전자제품  | 65000  | 4.30
```

---

### 19번 movie 테이블 복합 조건 조회

**모범 답안**:

```sql
-- 1. 평점 높은 순 상위 3개
SELECT title, rating
FROM movie
ORDER BY rating DESC
LIMIT 3;

결과:
title              | rating
쇼핑몰의 왕        | 8.5
데이터 세계        | 8.2
애니메이션 서버    | 8.0

-- 2. 장르 중복 제거
SELECT DISTINCT genre
FROM movie;

결과:
genre
드라마
액션
판타지
로맨스
애니메이션

-- 3. 2023년 이후 AND 평점 8.0 이상
SELECT title, release_year, rating
FROM movie
WHERE release_year >= 2023 AND rating >= 8.0;

결과:
title              | release_year | rating
쇼핑몰의 왕        | 2023         | 8.5
애니메이션 서버    | 2023         | 8.0
```

---

### 20번 페이지네이션 및 복합 조회

**모범 답안**:

```sql
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category VARCHAR(20),
    price INT,
    rating DECIMAL(3,2)
);

INSERT INTO product VALUES
(1, '무선 마우스', '전자제품', 45000, 4.50),
(2, '기계식 키보드', '전자제품', 120000, 4.60),
(3, '모니터 암', '전자제품', 65000, 4.30),
(4, '책상 스탠드', '생활용품', 35000, 4.40),
(5, '의자 쿠션', '가구', 28000, 4.20),
(6, '무선 스피커', '전자제품', 89000, 4.55),
(7, '테이블 램프', '생활용품', 42000, 4.35),
(8, '책상', '가구', 250000, 4.70),
(9, '모니터', '전자제품', 350000, 4.80),
(10, 'USB 허브', '전자제품', 32000, 4.25);

-- 페이지 1 (1~3번 상품)
SELECT * FROM product LIMIT 3 OFFSET 0;

-- 페이지 2 (4~6번 상품)
SELECT * FROM product LIMIT 3 OFFSET 3;

-- 페이지 3 (7~9번 상품)
SELECT * FROM product LIMIT 3 OFFSET 6;

-- 페이지 4 (10~12번 상품)
SELECT * FROM product LIMIT 3 OFFSET 9;

-- 카테고리별 정렬 후 각 카테고리 첫 상품
SELECT product_name, category, price
FROM product
WHERE product_id IN (
    SELECT MIN(product_id) FROM product GROUP BY category
)
ORDER BY category;

-- 가격 TOP 5
SELECT product_name, price
FROM product
ORDER BY price DESC
LIMIT 5;

-- 평점 4.5 이상을 가격으로 정렬
SELECT product_name, price, rating
FROM product
WHERE rating >= 4.5
ORDER BY price DESC;
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
