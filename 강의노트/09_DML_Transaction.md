# Chapter 9: DML (Data Manipulation Language)과 트랜잭션

## 📖 수업 개요

이 장에서는 데이터베이스의 데이터를 조작하는 DML 명령어(INSERT, UPDATE, DELETE)와 데이터 무결성을 보장하는 트랜잭션(Transaction)을 학습합니다. 데이터를 정확하고 안전하게 입력, 수정, 삭제하는 방법과 여러 작업을 하나의 논리적 단위로 처리하여 데이터 일관성을 유지하는 방법을 다룹니다. 실무에서 데이터 무결성 오류를 방지하고 복구할 수 있는 능력을 개발하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습

### 🌟 이 부분에서 배우는 것

- INSERT 문의 다양한 형태
- UPDATE 문과 조건 처리
- DELETE 문과 데이터 보호
- 트랜잭션의 개념과 특성 (ACID)
- COMMIT과 ROLLBACK의 역할
- 동시성 제어 및 잠금

---

### 9.1 INSERT 문

**INSERT**는 테이블에 새로운 데이터를 추가합니다.

**기본 문법:**
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

**열 지정 생략:**
```sql
INSERT INTO table_name
VALUES (value1, value2, ...);  -- 모든 열의 값을 순서대로 지정
```

**여러 행 삽입:**
```sql
INSERT INTO table_name (col1, col2)
VALUES (val1, val2), (val3, val4), (val5, val6);
```

**서브쿼리로 삽입:**
```sql
INSERT INTO table_name (col1, col2)
SELECT col1, col2 FROM other_table WHERE condition;
```

**특징:**
- NOT NULL 제약조건을 확인
- 기본값(DEFAULT)을 설정할 수 있음
- AUTO_INCREMENT 열은 자동으로 증가

---

### 9.2 UPDATE 문

**UPDATE**는 기존 데이터를 수정합니다.

**기본 문법:**
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**주의사항:**
- WHERE 조건을 명시하지 않으면 모든 행이 수정됨
- 조건을 항상 먼저 SELECT로 확인하기

**서브쿼리와 함께 사용:**
```sql
UPDATE employees
SET salary = (SELECT AVG(salary) FROM employees)
WHERE dept_id = 1;
```

**JOIN과 함께 사용:**
```sql
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.1
WHERE d.location = '서울';
```

**특징:**
- 여러 열을 동시에 수정 가능
- 연산식 사용 가능 (salary = salary * 1.1)
- 외래키 제약조건을 확인

---

### 9.3 DELETE 문

**DELETE**는 테이블의 데이터를 삭제합니다.

**기본 문법:**
```sql
DELETE FROM table_name
WHERE condition;
```

**주의사항:**
- WHERE 조건이 없으면 모든 행이 삭제됨
- 삭제 전에 조건을 SELECT로 확인하기
- 외래키 제약조건에 의해 삭제가 실패할 수 있음

**JOIN과 함께 사용:**
```sql
DELETE e FROM employees e
WHERE e.dept_id NOT IN (SELECT dept_id FROM departments);
```

**특징:**
- 데이터만 삭제되고 테이블 구조는 유지
- TRUNCATE는 더 빠르지만 되돌릴 수 없음
- 트랜잭션으로 보호 가능

---

### 9.4 트랜잭션의 개념

**트랜잭션**은 하나 이상의 SQL 문을 하나의 논리적 단위로 처리합니다.

**특징:**
- 모두 성공하거나 모두 실패 (All or Nothing)
- 중간 상태의 불안정한 데이터를 방지
- 데이터 일관성 보장

**명시적 트랜잭션:**
```sql
START TRANSACTION;  -- 또는 BEGIN
  INSERT INTO accounts VALUES (1, '김철수', 1000);
  UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;  -- 모두 성공
-- 또는
ROLLBACK;  -- 모두 취소
```

---

### 9.5 ACID 특성

트랜잭션의 특성을 ACID로 정의합니다.

**A (Atomicity, 원자성):**
- 트랜잭션의 모든 작업이 완전히 수행되거나 완전히 취소됨
- 중간 상태가 없음

**C (Consistency, 일관성):**
- 트랜잭션 전후로 데이터베이스의 무결성이 유지됨
- 모든 제약조건을 만족

**I (Isolation, 고립성):**
- 동시에 실행되는 트랜잭션들이 서로 영향을 주지 않음
- 격리 수준으로 제어

**D (Durability, 지속성):**
- COMMIT된 데이터는 영구적으로 저장됨
- 시스템 장애로부터 보호

---

### 9.6 COMMIT과 ROLLBACK

**COMMIT:**
```sql
COMMIT;  -- 현재 트랜잭션의 모든 변경을 저장
```

**ROLLBACK:**
```sql
ROLLBACK;  -- 현재 트랜잭션의 모든 변경을 취소
ROLLBACK TO SAVEPOINT point_name;  -- 특정 지점까지 롤백
```

**자동 커밋:**
- MySQL은 기본적으로 자동 커밋 모드
- `SET AUTOCOMMIT = 0;`으로 비활성화

---

### 9.7 SAVEPOINT

**SAVEPOINT**는 트랜잭션 내 부분적 롤백을 가능하게 합니다.

**문법:**
```sql
SAVEPOINT point_name;
-- ... 작업 ...
ROLLBACK TO point_name;
```

---

### 9.8 격리 수준 (Isolation Level)

동시성 제어를 위한 4가지 격리 수준:

1. **READ UNCOMMITTED:** 가장 낮은 수준, 위험
2. **READ COMMITTED:** 커밋된 데이터만 읽음
3. **REPEATABLE READ:** MySQL 기본값, 반복 읽기 일관성
4. **SERIALIZABLE:** 가장 높은 수준, 직렬화

**설정:**
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

---

### 9.9 잠금 (Locking)

동시 접근 제어를 위한 잠금:

**행 잠금:**
```sql
SELECT * FROM employees WHERE employee_id = 1 FOR UPDATE;
```

**테이블 잠금:**
```sql
LOCK TABLES employees WRITE;
-- ... 작업 ...
UNLOCK TABLES;
```

---

## 📚 Part 2: 샘플 데이터

### employees 테이블
```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees VALUES
(1, '김철수', 1, 5000000, '2020-01-15'),
(2, '이영희', 1, 4000000, '2020-06-20'),
(3, '박민준', 2, 4500000, '2019-03-10');
```

### accounts 테이블 (거래 예시용)
```sql
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50),
    balance DECIMAL(15, 2)
);

INSERT INTO accounts VALUES
(1001, '김철수', 1000000),
(1002, '이영희', 500000);
```

---

## 💻 Part 3: 실습

### 🌟 이 부분에서 배우는 것

- DML 명령어의 올바른 사용
- 트랜잭션 처리의 중요성
- 데이터 보호 전략
- 오류 처리 및 복구

---

### 9-1. INSERT 기본

새로운 직원 정보를 입력하세요.

```sql
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('황수정', 3, 4100000, CURDATE());
```

---

### 9-2. INSERT 열 생략

모든 열에 값을 순서대로 입력하세요.

```sql
INSERT INTO employees
VALUES (NULL, '금순민', 2, NULL, 4300000, CURDATE());
```

---

### 9-3. INSERT 여러 행

여러 직원 정보를 한 번에 입력하세요.

```sql
INSERT INTO employees (name, dept_id, salary) VALUES
('송준기', 1, 3900000),
('임세준', 2, 4100000),
('박준호', 3, 3700000);
```

---

### 9-4. INSERT 서브쿼리

특정 부서의 평균 급여 이상인 직원들을 아카이브 테이블에 복사하세요.

```sql
INSERT INTO employee_archive
SELECT * FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees WHERE dept_id = 1);
```

---

### 9-5. INSERT DEFAULT

기본값을 이용하여 데이터를 입력하세요.

```sql
INSERT INTO employees (name, dept_id, salary)
VALUES ('이소영', 1, DEFAULT);
```

---

### 9-6. UPDATE 기본

특정 직원의 급여를 수정하세요.

```sql
UPDATE employees
SET salary = 5200000
WHERE employee_id = 1;
```

---

### 9-7. UPDATE 여러 열

여러 열을 동시에 수정하세요.

```sql
UPDATE employees
SET salary = 5500000, dept_id = 2
WHERE employee_id = 2;
```

---

### 9-8. UPDATE 연산식

모든 직원의 급여를 10% 인상하세요.

```sql
UPDATE employees
SET salary = salary * 1.1;
```

---

### 9-9. UPDATE 조건식

특정 부서의 직원들의 급여를 다르게 인상하세요.

```sql
UPDATE employees
SET salary = CASE 
    WHEN dept_id = 1 THEN salary * 1.15
    WHEN dept_id = 2 THEN salary * 1.12
    ELSE salary * 1.10
END;
```

---

### 9-10. UPDATE 서브쿼리

부서별 평균 급여로 모든 직원의 급여를 조정하세요.

```sql
UPDATE employees
SET salary = (SELECT AVG(salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id)
WHERE (SELECT COUNT(*) FROM employees e3 WHERE e3.dept_id = employees.dept_id) > 0;
```

---

### 9-11. UPDATE JOIN

JOIN을 사용하여 조건부 UPDATE를 수행하세요.

```sql
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.1
WHERE d.location = '서울';
```

---

### 9-12. UPDATE 안전 모드

WHERE 조건을 먼저 SELECT로 확인하고 UPDATE를 수행하세요.

```sql
-- 먼저 확인
SELECT * FROM employees WHERE dept_id = 2;

-- 그 후 UPDATE
UPDATE employees
SET salary = salary * 1.1
WHERE dept_id = 2;
```

---

### 9-13. DELETE 기본

특정 직원을 삭제하세요.

```sql
DELETE FROM employees
WHERE employee_id = 7;
```

---

### 9-14. DELETE 조건

특정 조건의 여러 행을 삭제하세요.

```sql
DELETE FROM employees
WHERE salary < 3500000;
```

---

### 9-15. DELETE JOIN

JOIN 조건으로 DELETE를 수행하세요.

```sql
DELETE e FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = '부산';
```

---

### 9-16. DELETE 서브쿼리

서브쿼리 조건으로 DELETE를 수행하세요.

```sql
DELETE FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = '부산');
```

---

### 9-17. 간단한 트랜잭션

BEGIN-COMMIT으로 기본 트랜잭션을 처리하세요.

```sql
START TRANSACTION;
INSERT INTO employees (name, dept_id, salary) VALUES ('최유정', 1, 4300000);
UPDATE employees SET salary = salary * 1.05 WHERE dept_id = 1;
COMMIT;
```

---

### 9-18. 트랜잭션 롤백

트랜잭션을 시작했다가 롤백하세요.

```sql
START TRANSACTION;
INSERT INTO employees (name, dept_id, salary) VALUES ('이호진', 2, 4400000);
ROLLBACK;
```

---

### 9-19. 송금 거래

송금자와 수취인의 잔액을 한 트랜잭션으로 처리하세요.

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 100000 WHERE account_id = 1001;
UPDATE accounts SET balance = balance + 100000 WHERE account_id = 1002;
COMMIT;
```

---

### 9-20. 트랜잭션 오류 처리

트랜잭션 중 오류 발생 시 롤백하세요.

```sql
START TRANSACTION;
INSERT INTO employees (name, dept_id, salary) VALUES ('박준', 5, 4200000);
-- 오류 발생 (dept_id 5는 존재하지 않음)
ROLLBACK;
```

---

### 9-21. SAVEPOINT

SAVEPOINT를 사용하여 부분 롤백을 수행하세요.

```sql
START TRANSACTION;
INSERT INTO employees (name, dept_id, salary) VALUES ('김나현', 1, 4100000);
SAVEPOINT sp1;
INSERT INTO employees (name, dept_id, salary) VALUES ('이수호', 2, 4300000);
ROLLBACK TO sp1;
COMMIT;
```

---

### 9-22. 복합 거래

여러 거래를 하나의 트랜잭션으로 처리하세요.

```sql
START TRANSACTION;
INSERT INTO orders (customer_id, order_date) VALUES (1, CURDATE());
INSERT INTO order_details (order_id, product_id, quantity) VALUES (1, 1, 5);
UPDATE products SET stock = stock - 5 WHERE product_id = 1;
COMMIT;
```

---

### 9-23. 자동 커밋 제어

자동 커밋을 비활성화한 후 명시적으로 커밋하세요.

```sql
SET AUTOCOMMIT = 0;
UPDATE employees SET salary = 5000000 WHERE employee_id = 1;
COMMIT;
SET AUTOCOMMIT = 1;
```

---

### 9-24. 트랜잭션 격리 수준

격리 수준을 설정하고 테스트하세요.

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM employees WHERE dept_id = 1;
COMMIT;
```

---

### 9-25. 데이터 검증

INSERT 전에 데이터를 검증하세요.

```sql
SELECT IF((SELECT COUNT(*) FROM employees WHERE name = '김철수') = 0, 
          'OK to insert', 'Already exists');
```

---

### 9-26. 중복 체크

중복된 데이터가 없는지 확인한 후 INSERT하세요.

```sql
INSERT INTO employees (name, dept_id, salary)
SELECT '새직원', 1, 4100000
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE name = '새직원');
```

---

### 9-27. 외래키 제약

외래키 제약조건으로 인한 INSERT 실패 처리하세요.

```sql
-- 실패: 부서 ID 99가 존재하지 않음
INSERT INTO employees (name, dept_id, salary) VALUES ('테스트', 99, 4000000);
```

---

### 9-28. 외래키 제약 UPDATE

외래키 제약조건으로 인한 UPDATE 실패 처리하세요.

```sql
-- 실패: 부서 ID 99가 존재하지 않음
UPDATE employees SET dept_id = 99 WHERE employee_id = 1;
```

---

### 9-29. 외래키 제약 DELETE

외래키 제약조건으로 인한 DELETE 실패 처리하세요.

```sql
-- 실패: 자식 테이블에 참조가 있음
DELETE FROM departments WHERE dept_id = 1;
```

---

### 9-30. 데이터 마이그레이션

대량의 데이터를 안전하게 마이그레이션하세요.

```sql
START TRANSACTION;
INSERT INTO new_employees SELECT * FROM employees WHERE created_date < '2024-01-01';
DELETE FROM employees WHERE created_date < '2024-01-01';
COMMIT;
```

---

### 9-31. 원본 데이터 백업

변경 전에 원본 데이터를 백업하세요.

```sql
INSERT INTO employees_backup SELECT * FROM employees;
UPDATE employees SET salary = salary * 1.1;
```

---

### 9-32. 동시성 문제 시뮬레이션

두 개의 세션에서 동시에 같은 데이터를 수정하세요 (별도 연결 필요).

```sql
-- 세션 1
START TRANSACTION;
UPDATE employees SET salary = 5000000 WHERE employee_id = 1;

-- 세션 2에서 같은 행 수정 시도
```

---

### 9-33. 행 잠금

SELECT FOR UPDATE로 행을 잠그세요.

```sql
START TRANSACTION;
SELECT * FROM employees WHERE employee_id = 1 FOR UPDATE;
-- 다른 세션에서 수정 불가
COMMIT;
```

---

### 9-34. 테이블 잠금

LOCK TABLES로 테이블을 잠그세요.

```sql
LOCK TABLES employees WRITE;
INSERT INTO employees VALUES (...);
UNLOCK TABLES;
```

---

### 9-35. TRUNCATE vs DELETE

TRUNCATE와 DELETE의 차이를 비교하세요.

```sql
-- DELETE (되돌릴 수 있음)
DELETE FROM employees WHERE dept_id = 4;

-- TRUNCATE (되돌릴 수 없음)
TRUNCATE TABLE employees;
```

---

### 9-36. 대량 INSERT

많은 수의 행을 효율적으로 삽입하세요.

```sql
INSERT INTO employees (name, dept_id, salary) VALUES
('직원1', 1, 4000000),
('직원2', 1, 4100000),
('직원3', 2, 4200000),
...
('직원100', 3, 4300000);
```

---

### 9-37. 배치 UPDATE

배치로 여러 행을 UPDATE하세요.

```sql
UPDATE employees
SET salary = CASE 
    WHEN employee_id IN (1, 2, 3) THEN salary * 1.1
    WHEN employee_id IN (4, 5, 6) THEN salary * 1.05
    ELSE salary
END;
```

---

### 9-38. INSERT IGNORE

중복 키 오류를 무시하고 INSERT하세요.

```sql
INSERT IGNORE INTO employees (name, dept_id, salary)
VALUES ('김철수', 1, 5000000);
```

---

### 9-39. INSERT ON DUPLICATE KEY UPDATE

중복 시 UPDATE하는 조건부 INSERT를 수행하세요.

```sql
INSERT INTO employees (employee_id, name, salary)
VALUES (1, '김철수', 5500000)
ON DUPLICATE KEY UPDATE salary = VALUES(salary);
```

---

### 9-40. 트랜잭션 로그 확인

트랜잭션 처리 과정을 로그로 추적하세요.

```sql
-- 트랜잭션 로그 활성화
SET SESSION binlog_format = 'ROW';
START TRANSACTION;
UPDATE employees SET salary = 5000000 WHERE employee_id = 1;
COMMIT;
```

---
## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: INSERT, UPDATE, DELETE 문의 기본 문법과 특징을 설명하세요. 각 명령어가 필요한 상황과 주의사항을 서술하세요.

**2번 과제**: 트랜잭션의 개념과 ACID 특성을 상세히 설명하세요. 각 특성이 데이터 무결성을 어떻게 보장하는지 논의하세요.

**3번 과제**: COMMIT과 ROLLBACK의 역할을 설명하세요. SAVEPOINT를 사용한 부분 롤백의 개념과 활용 사례를 제시하세요.

**4번 과제**: 격리 수준의 4가지 종류를 설명하고, 각각의 장단점을 분석하세요. 실무에서 선택 기준을 제시하세요.

**5번 과제**: 동시성 제어 메커니즘(잠금, 격리 수준)을 설명하세요. 동시성 문제(더티 리드, 팬텀 리드 등)와 해결 방법을 서술하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 다양한 INSERT 방법을 사용하세요:
- 기본 INSERT로 단일 행 삽입
- 여러 행을 한 번에 삽입
- 서브쿼리를 사용한 조건부 삽입
- INSERT ON DUPLICATE KEY UPDATE 활용

**2번 과제**: UPDATE 작업을 안전하게 수행하세요:
- WHERE 조건을 먼저 SELECT로 확인
- 연산식을 사용한 UPDATE
- JOIN을 사용한 조건부 UPDATE
- 서브쿼리를 사용한 UPDATE

**3번 과제**: DELETE를 신중하게 처리하세요:
- 삭제 전 조건 확인
- 삭제할 데이터를 백업 테이블에 복사
- JOIN을 사용한 조건부 DELETE
- TRUNCATE와 DELETE의 성능 비교

**4번 과제**: 트랜잭션을 구현하세요:
- 기본 트랜잭션으로 일련의 작업 처리
- SAVEPOINT를 사용한 부분 롤백
- 오류 발생 시 자동 롤백
- 동시성 제어를 포함한 트랜잭션

**5번 과제**: Part 3의 실습 9-1부터 9-40까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 실무 시나리오(사원 채용, 급여 인상, 퇴직처리 등)를 트랜잭션으로 구현하여 그 결과를 제시하고, 각 시나리오에서 왜 트랜잭션이 필요한지 설명하세요.

제출 형식: SQL 파일 (Ch9_DML_Transaction_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
