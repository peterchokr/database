# 3장: SELECT 기초 및 단일 테이블 조회

---

## 📋 수업 개요

**수업 주제**: SELECT 문을 이용한 기본 데이터 조회

**수업 목표**
- SELECT 문의 기본 구조와 실행 순서 이해
- 열 선택, 별칭, 정렬 등 기본 기능 숙달
- 실무 중심의 데이터 조회 능력 배양

---

## 📚 Part 1: 이론 학습

### 이 부분에서 배우는 것

이 섹션에서는 SQL의 가장 기본이 되는 SELECT 문을 배웁니다.    
SELECT 문의 실행 순서와 각 절의 역할을 이해하고, 열 선택, 중복 제거, 별칭 지정, 정렬, 행 제한 등 다양한 기능을 학습합니다.    
이를 통해 데이터베이스에서 원하는 데이터를 효과적으로 조회하는 능력을 기르게 됩니다.

### 1-1. SELECT 문의 기본 구조

#### **기본 형태**

```sql
SELECT 열이름1, 열이름2, ...
FROM 테이블이름;
```


### 1-2. 열 선택

```
* 사용: 모든 열 조회
SELECT * FROM student;

특정 열만: 필요한 열만 조회
SELECT student_id, name FROM student;

여러 열: 원하는 순서대로 조회
SELECT name, student_id, gpa FROM student;
```

### 1-3. 열 별칭(Column Alias)

```sql
-- AS 사용
SELECT student_id AS 학번, name AS 이름 FROM student;

-- AS 생략
SELECT student_id 학번, name 이름 FROM student;

-- 공백 포함 시 따옴표
SELECT student_id AS '학생 번호' FROM student;
```

### 1-4. DISTINCT (중복 제거)

```sql
-- 학과 정보 중복 제거
SELECT DISTINCT department FROM student;

-- 여러 열 중복 제거
SELECT DISTINCT department, gpa FROM student;
```

### 1-5. LIMIT (행 수 제한)

```sql
-- 상위 5개만 조회
SELECT * FROM student LIMIT 5;

-- 6번째부터 10개 조회
SELECT * FROM student LIMIT 5 OFFSET 5;

-- 페이지네이션: 한 페이지에 10개
-- 1페이지
SELECT * FROM student LIMIT 10;
-- 2페이지
SELECT * FROM student LIMIT 10 OFFSET 10;
```

### 1-6. ORDER BY (정렬)

```sql
-- 오름차순 (ASC)
SELECT * FROM student ORDER BY gpa ASC;

-- 내림차순 (DESC)
SELECT * FROM student ORDER BY gpa DESC;

-- 복수 열 정렬: 학과별 오름차순, 학점 내림차순
SELECT * FROM student 
ORDER BY department ASC, gpa DESC;



## 📚 Part 2: 샘플 데이터 설정

### 이 부분에서 배우는 것

이 섹션에서는 SELECT 실습에 사용할 movie와 product 테이블을 생성합니다.    
다양한 속성을 가진 두 개의 테이블에서 실습함으로써 여러 상황에 대응하는 SELECT 문 활용법을 배웁니다.

```sql
CREATE DATABASE ch3_practice CHARACTER SET utf8mb4;
USE ch3_practice;

-- 영화 테이블
CREATE TABLE movie (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    genre VARCHAR(20),
    release_year INT,
    release_date DATE,
    director VARCHAR(30),
    rating DECIMAL(3, 1),
    runtime INT,
    country VARCHAR(20)
) CHARACTER SET utf8mb4;

INSERT INTO movie VALUES
(1, '쇼핑몰의 왕', '드라마', 2023, '2023-01-15', '김감독', 8.5, 120, '한국'),
(2, '코딩의 예술', '액션', 2023, '2023-02-20', '이감독', 7.8, 135, '한국'),
(3, '데이터 세계', '판타지', 2022, '2022-12-10', '박감독', 8.2, 145, '미국'),
(4, '로맨틱 SQL', '로맨스', 2023, '2023-03-05', '최감독', 7.5, 110, '한국'),
(5, '애니메이션 서버', '애니메이션', 2023, '2023-04-01', '정감독', 8.0, 90, '미국');

-- 상품 테이블
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(20),
    price INT,
    stock INT,
    upload_date DATE,
    brand VARCHAR(20),
    rating DECIMAL(3, 2)
) CHARACTER SET utf8mb4;

INSERT INTO product VALUES
(1, '무선 마우스', '전자제품', 45000, 150, '2024-01-10', '로지텍', 4.50),
(2, '기계식 키보드', '전자제품', 120000, 80, '2024-01-12', '다이키스', 4.60),
(3, '모니터 암', '전자제품', 65000, 200, '2024-01-08', '엘고', 4.30),
(4, '책상 스탠드', '생활용품', 35000, 300, '2024-01-05', '필립스', 4.40),
(5, '의자 쿠션', '가구', 28000, 250, '2024-01-15', '이케아', 4.20);
```

---

## 💻 Part 3: 실습

### 이 부분에서 배우는 것

이 섹션에서는 배운 SELECT 문의 모든 기능을 실제로 실행하여 데이터를 조회합니다.    
기본적인 SELECT부터 시작하여 별칭 지정, 중복 제거, 정렬, 행 제한 등 다양한 기능을 단계적으로 실습합니다. 각 실습을 통해 SELECT 문을 자유롭게 사용할 수 있게 됩니다.

```sql
-- =====================================================
-- 3-1. SELECT 기초
-- =====================================================
-- 실습 3-1~3-10: 기본 SELECT 문

-- 1. 전체 영화 조회
SELECT * FROM movie;

-- 2. 영화 제목만 조회
SELECT title FROM movie;

-- 3. 영화 제목과 감독 조회
SELECT title, director FROM movie;

-- 4. 모든 상품 조회
SELECT * FROM product;

-- 5. 상품명과 가격만 조회
SELECT product_name, price FROM product;

-- 6. 상품 카테고리 중복 제거
SELECT DISTINCT category FROM product;

-- 7. 영화 장르 중복 제거
SELECT DISTINCT genre FROM movie;

-- 8. 상위 3개 상품 조회
SELECT * FROM product LIMIT 3;

-- 9. 3번째 상품부터 2개 조회
SELECT * FROM product LIMIT 2 OFFSET 2;

-- 10. 영화 제목과 평점 조회
SELECT title, rating FROM movie;

-- =====================================================
-- 3-2. 열 별칭과 정렬
-- =====================================================
-- 실습 3-11~3-20: 별칭 및 정렬

-- 11. 영화 제목을 '영화명'으로, 감독을 '감독명'으로 별칭
SELECT title AS 영화명, director AS 감독명 FROM movie;

-- 12. 상품명을 '상품', 가격을 '판매가'로 별칭
SELECT product_name AS 상품, price AS 판매가 FROM product;

-- 13. 공백을 포함한 별칭
SELECT product_name AS '상품 이름', price AS '판매 가격' FROM product;

-- 14. 가격을 포함한 계산 별칭
SELECT product_name, price, price * 1.1 AS '10% 인상가' FROM product;

-- 15. 영화를 평점 내림차순으로 정렬
SELECT title, rating FROM movie ORDER BY rating DESC;

-- 16. 상품을 가격 오름차순으로 정렬
SELECT product_name, price FROM product ORDER BY price ASC;

-- 17. 상품을 재고 많은 순으로 정렬
SELECT product_name, stock FROM product ORDER BY stock DESC;

-- 18. 영화를 개봉년도 오름차순, 평점 내림차순으로 정렬
SELECT title, release_year, rating FROM movie 
ORDER BY release_year ASC, rating DESC;

-- 19. 상품을 카테고리순, 가격순으로 정렬
SELECT product_name, category, price FROM product 
ORDER BY category ASC, price DESC;

-- 20. 영화 평점 상위 3개만 조회
SELECT title, rating FROM movie 
ORDER BY rating DESC LIMIT 3;

-- =====================================================
-- 3-3. 고급 실습
-- =====================================================
-- 실습 3-21~3-33: 복합 조회

-- 21. 상품명과 '할인가' (20% 할인) 조회
SELECT product_name, price * 0.8 AS 할인가 FROM product;

-- 22. 영화 정보를 평점 내림차순으로 정렬하여 모두 조회
SELECT * FROM movie ORDER BY rating DESC;

-- 23. 상품 중복 카테고리 제거하여 모든 카테고리 조회
SELECT DISTINCT category FROM product;

-- 24. 전체 상품 중 상위 5개만 조회
SELECT * FROM product LIMIT 5;

-- 25. 영화 제목과 평점을 평점 높은 순으로 조회
SELECT title AS 영화제목, rating AS 평점 
FROM movie ORDER BY rating DESC;

-- 26. 상품 중 3번째부터 5개 조회
SELECT product_name, price FROM product LIMIT 5 OFFSET 2;

-- 27. 영화의 제목, 감독, 개봉년도 조회 (연도순 정렬)
SELECT title, director, release_year 
FROM movie ORDER BY release_year;

-- 28. 상품을 재고 많은 순으로, 같으면 가격 비싼 순으로 정렬
SELECT product_name, stock, price 
FROM product ORDER BY stock DESC, price DESC;

-- 29. 영화 제목과 평점, 감독을 평점순으로 조회
SELECT title, rating, director FROM movie ORDER BY rating DESC;

-- 30. 상품명과 가격, 카테고리를 카테고리순으로 조회
SELECT product_name, price, category FROM product ORDER BY category;

-- 31. 2023년 개봉 영화만 조회 (제목, 감독만)
SELECT title, director FROM movie WHERE release_year = 2023;

-- 32. 가격이 50000원 이상인 상품만 조회
SELECT * FROM product WHERE price >= 50000;

-- 33. 평점이 높은 순으로 상위 5개 영화 조회
SELECT title, rating FROM movie ORDER BY rating DESC LIMIT 5;
```

---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: SELECT 문의 실행 순서와 각 단계에서의 처리 과정을 상세히 설명하세요. 구체적인 SQL 예시를 들어 FROM 절에서 데이터를 가져오는 과정부터 ORDER BY로 정렬되는 전체 과정을 서술하세요.

**2번 과제**: DISTINCT 키워드의 역할과 사용 방법을 설명하고, 실무에서 중복된 값을 제거해야 하는 상황을 구체적으로 예시하여 설명하세요.

**3번 과제**: ORDER BY 절을 사용하여 복수의 열로 정렬할 때 우선순위가 어떻게 결정되는지 설명하고, ASC와 DESC의 개념을 명확히 구분하여 서술하세요.

**4번 과제**: LIMIT과 OFFSET 키워드를 사용하여 페이지네이션을 구현하는 방식을 설명하고, 한 페이지에 10개씩 3페이지를 조회하는 예시를 제시하세요.

**5번 과제**: 열 별칭의 개념과 사용 목적을 설명하고, 실무에서 가독성 좋은 별칭을 작성하기 위한 원칙과 주의사항을 제시하세요.

제출 형식: Word 또는 PDF 문서 (1-2페이지)

---

### 실습 과제

**1번 과제**: movie 테이블에서 모든 영화의 제목, 감독, 평점을 조회하되, 평점이 높은 순서대로 정렬하여 결과를 제시하세요.

**2번 과제**: product 테이블에서 상품명, 가격, 그리고 10% 인상가를 별칭으로 표시하여 조회하세요. 결과는 원래 가격의 오름차순으로 정렬되어야 하며, 상위 5개만 조회하세요.

**3번 과제**: movie 테이블에서 영화 장르의 모든 종류를 중복 없이 조회하세요. DISTINCT 키워드를 사용하여 서로 다른 장르가 몇 개인지 확인하고, 각 장르가 무엇인지 제시하세요.

**4번 과제**: product 테이블에서 전자제품 카테고리의 상품명, 가격, 평점을 조회하되, 평점이 높은 순서대로 정렬하세요. WHERE 절을 사용하여 전자제품만 필터링하고, ORDER BY로 정렬하는 과정을 SQL 문으로 작성하세요.

**5번 과제**: Part 3의 실습 3-1부터 3-33까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 창의적인 쿼리를 작성하여 그 결과도 함께 제시하세요.

제출 형식: SQL 파일 (Ch3_SELECT_Practice_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
