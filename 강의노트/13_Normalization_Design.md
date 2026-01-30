# 13장. 정규화 (Normalization)와 데이터베이스 설계

## 📖 수업 개요

이 장에서는 효율적이고 무결성 있는 데이터베이스 설계의 기초인 정규화(Normalization)를 학습합니다. 정규화는 데이터의 중복을 최소화하고 이상 현상(Anomaly)을 방지하여 데이터의 일관성을 유지하는 과정입니다. 1차 정규형부터 3차 정규형, BCNF까지의 정규화 단계와 ER 다이어그램을 통한 데이터베이스 설계 방법, 그리고 실무에서의 정규화 적용을 다룹니다. 이론적 기초를 바탕으로 실제 데이터베이스를 설계할 수 있는 능력을 개발하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습

### 🌟 이 부분에서 배우는 것

- 정규화의 개념과 목표
- 함수 종속성 (Functional Dependency)
- 1차 정규형 (1NF)
- 2차 정규형 (2NF)
- 3차 정규형 (3NF)
- BCNF (Boyce-Codd Normal Form)
- ER 다이어그램 및 설계 원칙
- 비정규화 (De-normalization) 고려사항

---

### 13.1 정규화 (Normalization)의 개념

**정규화**는 데이터베이스의 이상 현상을 제거하고 데이터 무결성을 보장하기 위해 테이블을 체계적으로 분해하는 과정입니다.

**목표:**

- 데이터 중복 최소화
- 이상 현상 제거 (삽입, 수정, 삭제 이상)
- 데이터 무결성 유지
- 저장 공간 효율성

**이상 현상 (Anomaly):**

1. **삽입 이상 (Insertion Anomaly):**

   - 새로운 데이터 삽입 시 불필요한 정보도 함께 삽입해야 함
2. **수정 이상 (Update Anomaly):**

   - 데이터 수정 시 같은 정보의 여러 행을 수정해야 함
3. **삭제 이상 (Deletion Anomaly):**

   - 필요한 데이터를 삭제할 때 원하지 않는 정보까지 삭제됨

---

### 13.2 함수 종속성 (Functional Dependency)

**함수 종속성**은 속성 간의 종속 관계를 나타냅니다.

**표기:** X → Y (X가 결정되면 Y도 유일하게 결정됨)

**예시:**

- 학번 → 학생명, 학과, 학년
- 사원번호 → 사원명, 부서, 급여

**완전 함수 종속:**

- Y가 X 전체에 종속 (X의 일부에는 종속되지 않음)

**부분 함수 종속:**

- Y가 X의 일부에만 종속 (불바람직)

**이행 함수 종속:**

- X → Y, Y → Z이면 X → Z (이를 제거하는 것이 3NF의 목표)

---

### 13.3 1차 정규형 (1NF)

**1NF의 조건:**

- 모든 속성 값이 원자값(Atomic Value, 더 이상 분해할 수 없는 값)

**잘못된 예시:**

```
| 학번 | 학생명 | 전화번호 (집, 휴대폰) |
|------|--------|----------------------|
| 001  | 김철수 | 02-1234-5678, 010-1111-2222 |
```

**정규형 예시:**

```
| 학번 | 학생명 | 전화번호 | 전화구분 |
|------|--------|---------|---------|
| 001  | 김철수 | 02-1234-5678 | 집    |
| 001  | 김철수 | 010-1111-2222 | 휴대폰 |
```

---

### 13.4 2차 정규형 (2NF)

**2NF의 조건:**

- 1NF를 만족
- 모든 비주요 속성이 기본키 전체에 완전 함수 종속

**복합키 테이블 예시:**

**잘못된 예:**

```
| 학번 | 강의번호 | 강의명 | 학점 | 성적 |
|------|----------|--------|------|------|
| 001  | CS101    | 자료구조 | 3    | A   |
```

문제: 강의명, 학점은 강의번호에만 종속 (학번+강의번호에 완전 종속하지 않음)

**정규형 예:**
수강 테이블:

```
| 학번 | 강의번호 | 성적 |
|------|----------|------|
| 001  | CS101    | A   |
```

강의 테이블:

```
| 강의번호 | 강의명 | 학점 |
|----------|--------|------|
| CS101    | 자료구조 | 3    |
```

---

### 13.5 3차 정규형 (3NF)

**3NF의 조건:**

- 2NF를 만족
- 모든 비주요 속성이 기본키에 이행적으로 함수 종속하지 않음

**잘못된 예:**

```
| 학번 | 학생명 | 학과 | 학과사무실 |
|------|--------|------|-----------|
| 001  | 김철수 | 컴퓨터공학 | 301호   |
```

문제: 학과사무실은 학과에 종속 (이행적 함수 종속)

**정규형 예:**
학생 테이블:

```
| 학번 | 학생명 | 학과 |
|------|--------|------|
| 001  | 김철수 | 컴퓨터공학 |
```

학과 테이블:

```
| 학과 | 학과사무실 |
|------|-----------|
| 컴퓨터공학 | 301호 |
```

---

### 13.6 BCNF (Boyce-Codd Normal Form)

**BCNF의 조건:**

- 모든 함수 종속 X → Y에서 X가 슈퍼키(Superkey)

**3NF와 BCNF의 차이:**

- 3NF: 비주요 속성만 기본키에 종속
- BCNF: 모든 속성이 슈퍼키에만 종속

**BCNF 위반 예시:**

```
| 교사 | 과목 | 시간 |
|------|------|------|
| 김교수 | 자료구조 | 월,수,금 |
```

문제: 과목 → 교사는 아니지만, 과목 → 시간에서 과목은 슈퍼키가 아님

---

### 13.7 ER 다이어그램 (Entity-Relationship Diagram)

**ER 다이어그램**은 데이터베이스 설계의 시각적 표현입니다.

**기본 요소:**

- **엔티티 (Entity):** 정보를 저장할 대상 (예: 학생, 강의)
- **속성 (Attribute):** 엔티티의 특성 (예: 학번, 학생명)
- **관계 (Relationship):** 엔티티 간의 연관 관계

**카디널리티 (Cardinality):**

- 1:1 (일대일): 한 명의 학생은 하나의 학번
- 1:N (일대다): 한 명의 교수는 여러 강의
- M:N (다대다): 학생은 여러 강의, 강의는 여러 학생

---

### 13.8 데이터베이스 설계 프로세스

**1단계: 요구사항 분석**

- 데이터 수집 및 분석
- 비즈니스 규칙 파악

**2단계: 개념적 설계**

- ER 다이어그램 작성
- 엔티티와 관계 정의

**3단계: 논리적 설계**

- 정규화 적용
- 스키마 정의

**4단계: 물리적 설계**

- 저장소 구조 결정
- 인덱스 설계

**5단계: 구현 및 검증**

- DDL로 테이블 생성
- 데이터 무결성 검증

---

### 13.9 외래키와 관계

**외래키 (Foreign Key):**

- 다른 테이블의 기본키를 참조
- 관계 무결성 보장
- ON DELETE, ON UPDATE 옵션으로 연쇄 작업 제어

**예시:**

```sql
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

---

### 13.10 비정규화 (De-normalization)

**비정규화**는 성능을 위해 의도적으로 정규화를 역행합니다.

**상황:**

- 복잡한 JOIN으로 인한 성능 저하
- 읽기 성능 최적화가 필요할 때
- 조회가 매우 빈번할 때

**예시:**
학생 테이블에 학과명을 직접 저장 (원래는 학과명은 학과 테이블에만)

**주의사항:**

- 데이터 일관성 문제 발생 가능
- 수정 시 여러 행을 업데이트해야 함

---

## 📚 Part 2: 샘플 데이터

### 온라인 쇼핑몰 데이터베이스

**Customers 테이블:**

```sql
CREATE DATABASE ch13_normal CHARACTER SET utf8mb4;
USE ch13_normal ;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(50),
    city VARCHAR(30)
);
```

**Products 테이블:**

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category_id INT,
    price DECIMAL(10, 2)
);
```

**Categories 테이블:**

```sql
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(30)
);
```

**Orders 테이블:**

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

**OrderDetails 테이블:**

```sql
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## 💻 Part 3: 실습

### 🌟 이 부분에서 배우는 것

- 정규화 단계의 실제 적용
- 이상 현상의 식별과 해결
- ER 다이어그램 작성
- 데이터베이스 설계 실습

---

### 13-1. 1NF 식별

비정규형 데이터를 1NF로 변환하세요.

**문제 테이블:**

```sql
-- 잘못된 형태 (전화번호가 원자값이 아님)
students (학번, 이름, 전화번호)
001, 김철수, 02-123-4567, 010-1111-2222
```

**해결 (1NF):**

```sql
CREATE TABLE students (
    student_id VARCHAR(5),
    name VARCHAR(50)
);

CREATE TABLE phone_numbers (
    student_id VARCHAR(5),
    phone_number VARCHAR(20)
);
```

---

### 13-2. 2NF 변환

1NF 데이터를 2NF로 변환하세요.

**문제 (부분 함수 종속):**

```sql
-- 수강 (학번, 강의번호, 강의명, 학점)
-- 강의명과 학점은 강의번호에만 종속
```

**해결:**

```sql
CREATE TABLE enrollment (
    student_id VARCHAR(5),
    course_id VARCHAR(5),
    grade CHAR(1)
);

CREATE TABLE courses (
    course_id VARCHAR(5),
    course_name VARCHAR(50),
    credits INT
);
```

---

### 13-3. 3NF 변환

2NF 데이터를 3NF로 변환하세요.

**문제 (이행 함수 종속):**

```sql
-- 학생 (학번, 이름, 학과, 학과장)
-- 학과장은 학과에 종속
```

**해결:**

```sql
CREATE TABLE students (
    student_id VARCHAR(5),
    name VARCHAR(50),
    major_id INT
);

CREATE TABLE majors (
    major_id INT,
    major_name VARCHAR(50),
    chairman VARCHAR(50)
);
```

---

### 13-4. BCNF 확인

데이터가 BCNF를 만족하는지 확인하세요.

```sql
-- 교수 (교수id, 과목, 시간)
-- 문제: 과목 -> 교수는 아니지만, 과목 -> 시간

-- BCNF 형태로 변환:
CREATE TABLE professor_assignment (
    professor_id INT,
    course_id INT,
    PRIMARY KEY (professor_id, course_id)
);

CREATE TABLE course_schedule (
    course_id INT,
    time_slot VARCHAR(20),
    PRIMARY KEY (course_id, time_slot)
);
```

---

### 13-5. 함수 종속성 식별

테이블에서 함수 종속성을 찾아내세요.

```sql
-- 직원 테이블의 함수 종속성:
-- 직원ID -> 이름, 부서, 직급
-- 부서 -> 부서명, 위치
-- 직급 -> 급여범위

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    job_id INT
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE jobs (
    job_id INT PRIMARY KEY,
    job_title VARCHAR(50),
    min_salary DECIMAL(10, 2),
    max_salary DECIMAL(10, 2)
);
```

---

### 13-6. 부분 함수 종속 제거

부분 함수 종속을 제거하여 2NF로 변환하세요.

**문제:**

```sql
-- 수강 (학번, 강의번호, 강의명, 점수)
-- 강의명은 강의번호에만 종속 (부분 함수 종속)
```

**해결:**

```sql
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade DECIMAL(3, 2),
    PRIMARY KEY (student_id, course_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);
```

---

### 13-7. 이행 함수 종속 제거

이행 함수 종속을 제거하여 3NF로 변환하세요.

**문제:**

```sql
-- 학생 (학번, 이름, 학과, 학과장)
-- 학번 -> 학과, 학과 -> 학과장 (이행 함수 종속)
```

**해결:**

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE majors (
    major_id INT PRIMARY KEY,
    major_name VARCHAR(50),
    chairman_id INT,
    FOREIGN KEY (chairman_id) REFERENCES professors(professor_id)
);
```

---

### 13-8. 복합키 테이블 설계

복합키를 가지는 정규화된 테이블을 설계하세요.

```sql
CREATE TABLE course_enrollment (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

---

### 13-9. 외래키 관계 설정

테이블 간 외래키 관계를 정의하세요.

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

### 13-10. 참조 무결성 유지

외래키 제약조건이 참조 무결성을 보장하는지 확인하세요.

```sql
-- 올바른 INSERT
INSERT INTO orders VALUES (1, 1, '2024-01-15');

-- 오류: customer_id 99가 존재하지 않음
INSERT INTO orders VALUES (2, 99, '2024-01-16'); -- 실패

-- 참조 무결성 확인
SELECT * FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```

---

### 13-11. 다대다 관계 처리

M:N 관계를 정규화하여 처리하세요.

**문제:**

```sql
-- 학생이 여러 과목을 수강하고, 과목마다 여러 학생이 수강
```

**해결:**

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

---

### 13-12. ER 다이어그램 해석

주어진 ER 다이어그램으로부터 테이블 구조를 도출하세요.

```
[Customer] 1:N [Order]
[Order] 1:N [OrderItem]
[Product] 1:N [OrderItem]
```

**DDL:**

```sql
CREATE TABLE customers (...);
CREATE TABLE orders (customer_id INT REFERENCES customers);
CREATE TABLE products (...);
CREATE TABLE order_items (order_id INT REFERENCES orders, product_id INT REFERENCES products);
```

---

### 13-13. ER 다이어그램 작성

온라인 쇼핑몰의 ER 다이어그램 및 테이블 구조를 설계하세요.

```
엔티티: Customer, Product, Category, Order, OrderItem, Inventory
관계: Customer 1:N Order
      Product N:1 Category
      Product 1:N Inventory
      Order 1:N OrderItem
      Product 1:N OrderItem
```

---

### 13-14. 삽입 이상 식별

정규화되지 않은 테이블의 삽입 이상을 식별하세요.

**문제:**

```sql
-- 학생 (학번, 이름, 학과, 학과장, 학과위치)
-- 새로운 학과 정보만 추가하려면 학번을 입력해야 함 (삽입 이상)
```

---

### 13-15. 삽입 이상 해결

정규화를 통해 삽입 이상을 제거하세요.

**해결:**

```sql
CREATE TABLE students (학번, 이름, 학과ID);
CREATE TABLE majors (학과ID, 학과장, 위치);
-- 이제 학과 정보만 독립적으로 추가 가능
```

---

### 13-16. 수정 이상 식별

수정 이상의 사례를 찾으세요.

**문제:**

```sql
-- 과목 (학번, 강의번호, 강의명, 강사, 학점)
-- 강의명을 변경하려면 모든 수강 학생 행을 수정해야 함 (수정 이상)
```

---

### 13-17. 수정 이상 해결

정규화로 수정 이상을 제거하세요.

```sql
CREATE TABLE courses (강의번호, 강의명, 강사, 학점);
CREATE TABLE enrollments (학번, 강의번호);
-- 이제 강의명 변경 시 courses 테이블만 수정
```

---

### 13-18. 삭제 이상 식별

삭제 이상의 사례를 찾으세요.

**문제:**

```sql
-- 직원 (직원ID, 이름, 부서, 부서장)
-- 마지막 직원을 삭제하면 부서 정보도 사라짐 (삭제 이상)
```

---

### 13-19. 삭제 이상 해결

정규화로 삭제 이상을 제거하세요.

```sql
CREATE TABLE employees (emp_id, name, dept_id);
CREATE TABLE departments (dept_id, dept_name, manager_id);
-- 이제 부서 정보는 별도로 유지 가능
```

---

### 13-20. 성능 vs 정규화

정규화된 스키마와 비정규화된 스키마의 성능을 분석하세요.

**정규화 (쓰기 빠름, 읽기 느림):**

```sql
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
```

**비정규화 (쓰기 느림, 읽기 빠름):**

```sql
SELECT name, dept_name FROM employees;
-- dept_name이 employees에 중복 저장
```

---

### 13-21. 의도적 비정규화

성능을 위해 의도적으로 비정규화하세요.

```sql
-- 읽기가 매우 빈번한 경우
ALTER TABLE orders
ADD COLUMN customer_name VARCHAR(50);

-- INSERT/UPDATE 시 customer_name도 함께 수정해야 함
```

---

### 13-22. 온라인 쇼핑몰 설계

상품, 고객, 주문 정보를 정규화하여 설계하세요.

```sql
CREATE TABLE categories (category_id INT, category_name VARCHAR(50));
CREATE TABLE products (product_id INT, name VARCHAR(50), category_id INT, price DECIMAL);
CREATE TABLE customers (customer_id INT, name VARCHAR(50), email VARCHAR(50), city VARCHAR(50));
CREATE TABLE orders (order_id INT, customer_id INT, order_date DATE);
CREATE TABLE order_items (order_item_id INT, order_id INT, product_id INT, quantity INT, unit_price DECIMAL);
```

---

### 13-23. 대학 정보 시스템 설계

학생, 강의, 수강 정보를 정규화하여 설계하세요.

```sql
CREATE TABLE departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50));
CREATE TABLE students (student_id INT PRIMARY KEY, name VARCHAR(50), dept_id INT);
CREATE TABLE courses (course_id INT PRIMARY KEY, course_name VARCHAR(50), credits INT);
CREATE TABLE enrollments (student_id INT, course_id INT, grade CHAR(1));
CREATE TABLE professors (prof_id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE course_instructors (course_id INT, prof_id INT);
```

---

### 13-24. 병원 관리 시스템 설계

환자, 의료진, 진료 정보를 정규화하세요.

```sql
CREATE TABLE patients (patient_id INT, name VARCHAR(50), medical_record_number VARCHAR(20));
CREATE TABLE doctors (doctor_id INT, name VARCHAR(50), specialty VARCHAR(50));
CREATE TABLE visits (visit_id INT, patient_id INT, doctor_id INT, visit_date DATE);
CREATE TABLE diagnoses (diagnosis_id INT, visit_id INT, diagnosis_description VARCHAR(255));
CREATE TABLE prescriptions (prescription_id INT, visit_id INT, medication VARCHAR(50), dosage VARCHAR(50));
```

---

### 13-25. 도서관 관리 시스템 설계

도서, 회원, 대출 정보를 정규화하세요.

```sql
CREATE TABLE members (member_id INT, name VARCHAR(50), join_date DATE);
CREATE TABLE categories (category_id INT, category_name VARCHAR(50));
CREATE TABLE books (book_id INT, title VARCHAR(100), author VARCHAR(50), category_id INT);
CREATE TABLE loans (loan_id INT, member_id INT, book_id INT, loan_date DATE, return_date DATE);
```

---

### 13-26-40. 종합 설계 시나리오

소셜 네트워크, 이메일 시스템, 블로그 플랫폼 등의 정규화된 데이터베이스 설계:

**소셜 네트워크:**

```sql
CREATE TABLE users (user_id INT, username VARCHAR(50), email VARCHAR(50));
CREATE TABLE user_profiles (user_id INT, bio TEXT, profile_pic VARCHAR(255));
CREATE TABLE follows (follower_id INT, following_id INT);
CREATE TABLE posts (post_id INT, user_id INT, content TEXT, post_date DATETIME);
CREATE TABLE comments (comment_id INT, post_id INT, user_id INT, content TEXT);
CREATE TABLE likes (like_id INT, post_id INT, user_id INT);
```

**블로그 플랫폼:**

```sql
CREATE TABLE authors (author_id INT, name VARCHAR(50), email VARCHAR(50));
CREATE TABLE categories (category_id INT, category_name VARCHAR(50));
CREATE TABLE blog_posts (post_id INT, author_id INT, category_id INT, title VARCHAR(255), content LONGTEXT, published_date DATE);
CREATE TABLE comments (comment_id INT, post_id INT, author_id INT, content TEXT, comment_date DATETIME);
CREATE TABLE tags (tag_id INT, tag_name VARCHAR(50));
CREATE TABLE post_tags (post_id INT, tag_id INT);
```

---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: 정규화의 목표와 각 단계(1NF, 2NF, 3NF, BCNF)의 조건을 상세히 설명하세요. 각 정규형에서 제거되는 문제점을 구체적인 예시와 함께 서술하세요.

**2번 과제**: 삽입 이상, 수정 이상, 삭제 이상의 개념을 설명하고, 각각이 정규화로 어떻게 해결되는지 논의하세요. 실제 비즈니스에서 발생할 수 있는 사례를 제시하세요.

**3번 과제**: 함수 종속성의 개념과 부분 함수 종속, 이행 함수 종속의 차이점을 설명하세요. 정규화 과정에서 이들이 어떻게 제거되는지 명확히 서술하세요.

**4번 과제**: ER 다이어그램의 개념과 구성 요소를 설명하세요. 데이터베이스 설계 프로세스에서 ER 다이어그램의 역할과 중요성을 논의하세요.

**5번 과제**: 정규화와 비정규화의 트레이드오프를 분석하세요. 실무에서 정규화와 성능 사이의 균형을 어떻게 맞춰야 하는지 제시하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 정규화 실습을 수행하세요:

- 비정규형 테이블을 1NF로 변환
- 1NF 테이블을 2NF로 변환
- 2NF 테이블을 3NF로 변환
  각 단계에서 이상 현상이 어떻게 제거되는지 설명

**2번 과제**: 함수 종속성을 분석하세요:

- 테이블의 모든 함수 종속성 식별
- 부분 함수 종속과 이행 함수 종속 찾기
- 각각을 제거하기 위한 정규화 계획

**3번 과제**: 복잡한 데이터베이스를 설계하세요:

- ER 다이어그램 작성
- 엔티티와 관계 정의
- 정규화된 스키마로 변환
- SQL로 구현

**4번 과제**: 실제 비즈니스 시스템을 설계하세요:

- 온라인 쇼핑몰, 대학 정보 시스템, 병원 관리 시스템 중 선택
- 요구사항 분석 및 ER 다이어그램 작성
- 정규화 적용
- 완전한 DDL 작성

**5번 과제**: Part 3의 실습 13-1부터 13-40까지 제공된 모든 쿼리를 직접 실행하고, 각 결과를 스크린샷으로 첨부하세요. 추가로 종합적인 정보 시스템(선택 사항)의 데이터베이스를 완전히 설계하여, 설계 과정, 최종 ER 다이어그램, 정규화 분석, 완성된 DDL을 포함한 상세한 설계 문서를 제출하세요. 설계 결과물이 각 정규형 조건을 만족하는지 검증하세요.

제출 형식: SQL 파일 (Ch13_Normalization_Design_[학번].sql), 설계 문서, 및 ER 다이어그램

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
