# 10장. 뷰(View)와 저장프로시저(Stored Procedure)

## 📖 수업 개요

이 장에서는 데이터베이스의 논리적 추상화를 제공하는 뷰(View)와 재사용 가능한 SQL 루틴인 저장프로시저(Stored Procedure)를 학습합니다.   
뷰를 사용하여 복잡한 쿼리를 단순화하고 데이터 접근을 제어하며, 저장프로시저로 반복적인 작업을 자동화하고 애플리케이션 로직을 데이터베이스에 구현하는 방법을 다룹니다. 데이터베이스의 유지보수성과 보안을 강화하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습



---

### 10.1 뷰(View)의 개념

**뷰**는 하나 이상의 테이블을 기반으로 하는 가상 테이블입니다.

**특징:**

- 실제 데이터를 저장하지 않음 (논리적 추상화)
- SELECT 쿼리로 정의됨
- 테이블처럼 SELECT로 조회 가능
- 복잡한 조인이나 집계를 단순화

**뷰가 필요한 이유:**

1. **복잡한 쿼리 단순화** - 여러 테이블의 JOIN과 집계를 한 번 정의하면, 이후 계속 테이블처럼 사용 가능
2. **보안** - 민감한 열(예: 급여)은 숨기고 필요한 정보만 노출
3. **유지보수 용이** - 쿼리 정의를 한 곳에서 관리하면 수정이 간단
4. **일관성** - 모든 사용자가 동일한 정의를 사용하므로 데이터 해석이 일관됨

**뷰 생성:**

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

**뷰 조회:**

```sql
SELECT * FROM view_name;
```

---

### 10.2 뷰의 활용 사례

**1. 복잡한 쿼리 단순화:**

```sql
CREATE VIEW sales_summary AS
SELECT p.product_name, COUNT(*) AS sales_count, SUM(s.quantity) AS total_qty
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name;

-- 사용
SELECT * FROM sales_summary WHERE total_qty > 100;
```

**2. 데이터 보안:**

```sql
CREATE VIEW employee_public AS
SELECT employee_id, name, hire_date
FROM employees;  -- 급여 정보 제외
```

**3. 데이터 추상화:**

```sql
CREATE VIEW current_employees AS
SELECT * FROM employees
WHERE termination_date IS NULL;
```

---

### 10.3 뷰 수정과 삭제

**뷰 수정:**

```sql
ALTER VIEW view_name AS
SELECT column1, column2, ...
FROM table_name;
```

**뷰 삭제:**

```sql
DROP VIEW view_name;
DROP VIEW IF EXISTS view_name;  -- 존재하지 않으면 오류 무시
```

**여러 뷰 삭제:**

```sql
DROP VIEW view1, view2, view3;
```

---

### 10.4 수정 가능한 뷰(Updatable View)

특정 조건을 만족하면 뷰에 INSERT, UPDATE, DELETE가 가능합니다.

**조건:**

- 단일 테이블을 기반으로 함
- GROUP BY, DISTINCT, JOIN을 포함하지 않음
- 서브쿼리, UNION을 포함하지 않음
- HAVING, LIMIT을 포함하지 않음

**예시:**

```sql
CREATE VIEW employee_view AS
SELECT employee_id, name, salary FROM employees;

-- 뷰를 통한 수정 가능
UPDATE employee_view SET salary = 5000000 WHERE employee_id = 1;
```

---

### 10.5 저장프로시저(Stored Procedure)

**저장프로시저**는 데이터베이스에 저장되는 재사용 가능한 SQL 루틴입니다.

**특징:**

- 조건문, 반복문 포함 가능
- 매개변수 사용 가능 (IN, OUT, INOUT)
- 트랜잭션 제어 가능
- 성능 향상 (미리 컴파일됨)

**저장프로시저가 필요한 이유:**

1. **코드 재사용** - 같은 로직을 여러 애플리케이션에서 사용
2. **보안** - 데이터베이스 수준에서 로직을 제어
3. **성능** - 프로시저는 미리 컴파일되어 매번 파싱할 필요 없음
4. **복잡한 비즈니스 로직** - 조건문, 반복문으로 복잡한 작업 수행

**생성:**

```sql
CREATE PROCEDURE procedure_name (
  IN parameter1 INT,
  OUT parameter2 VARCHAR(50)
)
BEGIN
  -- 프로시저 본문
  SELECT column INTO parameter2 FROM table WHERE id = parameter1;
END;
```

---

### 10.6 저장프로시저 매개변수

**IN (입력 매개변수):**

프로시저로 데이터를 전달합니다.

```sql
CREATE PROCEDURE get_employee (IN emp_id INT)
BEGIN
  SELECT * FROM employees WHERE employee_id = emp_id;
END;
```

**OUT (출력 매개변수):**

프로시저에서 계산한 결과를 반환합니다.

```sql
CREATE PROCEDURE get_employee_count (OUT count INT)
BEGIN
  SELECT COUNT(*) INTO count FROM employees;
END;
```

**INOUT (입출력 매개변수):**

데이터를 받아서 처리한 후 결과를 반환합니다.

```sql
CREATE PROCEDURE process_salary (INOUT salary DECIMAL)
BEGIN
  SET salary = salary * 1.1;
END;
```

---

### 10.7 저장프로시저의 제어 구조

**IF-THEN-ELSE:**

조건에 따라 다른 작업을 수행합니다.

```sql
CREATE PROCEDURE check_salary (IN emp_id INT)
BEGIN
  DECLARE salary DECIMAL;
  SELECT salary_amount INTO salary FROM employees WHERE employee_id = emp_id;
  
  IF salary > 5000000 THEN
    SELECT '높음' AS salary_level;
  ELSEIF salary > 4000000 THEN
    SELECT '중간' AS salary_level;
  ELSE
    SELECT '낮음' AS salary_level;
  END IF;
END;
```

**WHILE 루프:**

반복적인 작업을 수행합니다.

```sql
CREATE PROCEDURE insert_sample_data (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO temp_table VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
  END WHILE;
END;
```

**CASE 문:**

여러 조건을 깔끔하게 처리합니다.

```sql
CREATE PROCEDURE get_grade (IN score INT, OUT grade CHAR)
BEGIN
  CASE
    WHEN score >= 90 THEN SET grade = 'A';
    WHEN score >= 80 THEN SET grade = 'B';
    WHEN score >= 70 THEN SET grade = 'C';
    ELSE SET grade = 'F';
  END CASE;
END;
```

---

### 10.8 저장프로시저 실행

**CALL 문으로 실행:**

```sql
CALL procedure_name(parameter_list);
```

**예시:**

```sql
CALL get_employee(1);

-- OUT 매개변수로 결과 받기
CALL get_employee_count(@count);
SELECT @count;
```

---

### 10.9 저장프로시저 삭제

**프로시저 삭제:**

```sql
DROP PROCEDURE procedure_name;
DROP PROCEDURE IF EXISTS procedure_name;
```

---

### 10.10 뷰 vs 테이블

| 특성   | 뷰                 | 테이블           |
| ------ | ------------------ | ---------------- |
| 저장소 | 가상 (정의만 저장) | 실제 데이터 저장 |
| 성능   | 매번 계산          | 사전 저장        |
| 수정   | 제한적             | 자유로움         |
| 용도   | 추상화, 보안       | 데이터 저장      |

---

## 📚 Part 2: 샘플 데이터

### 필수 테이블 구성

```sql
CREATE DATABASE ch10_view CHARACTER SET utf8mb4;
USE ch10_view;

-- employees 테이블
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees VALUES
(1, '김철수', 1, 5000000, '2020-01-15'),
(2, '이영희', 1, 4000000, '2020-06-20'),
(3, '박민준', 2, 4500000, '2019-03-10'),
(4, '최순신', 2, 3500000, '2021-07-15'),
(5, '강감찬', 3, 4200000, '2020-09-05');

-- departments 테이블
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments VALUES
(1, '영업부', '서울'),
(2, '기술부', '대전'),
(3, '인사부', '서울'),
(4, '재무부', '부산');

-- 아카이브 테이블
CREATE TABLE employees_archive (
    employee_id INT,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE
);
```


---

## 💻 Part 3: 실습

### 🌟 이 부분에서 배우는 것

이 섹션에서는 뷰를 통한 데이터 추상화와 저장프로시저를 통한 비즈니스 로직 구현을 실습합니다.

```sql
-- =====================================================
-- 섹션 1: 뷰의 기본 (1-5번)
-- =====================================================

-- 1. 단순 뷰 생성 (특정 열만 노출)
CREATE VIEW employee_names AS
SELECT employee_id, name, hire_date
FROM employees;

SELECT * FROM employee_names;

-- 2. JOIN 뷰 (여러 테이블 통합)
CREATE VIEW employee_department_view AS
SELECT e.employee_id, e.name, d.department_name, d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM employee_department_view;

-- 3. 집계 뷰 (GROUP BY 사용)
CREATE VIEW dept_salary_summary AS
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;

SELECT * FROM dept_salary_summary;

-- 4. 조건부 뷰 (WHERE로 자동 필터링)
CREATE VIEW high_salary_employees AS
SELECT employee_id, name, salary
FROM employees
WHERE salary > 4500000;

SELECT * FROM high_salary_employees;

-- 5. 뷰 삭제
DROP VIEW IF EXISTS high_salary_employees;

-- =====================================================
-- 섹션 2: 수정 가능한 뷰 (6-8번)
-- =====================================================

-- 6. 수정 가능한 뷰 (단일 테이블, 단순 조건)
CREATE VIEW employee_view AS
SELECT employee_id, name, salary FROM employees;

-- 7. 뷰를 통한 INSERT
INSERT INTO employee_view (name, salary)
VALUES ('박수정', 4200000);

-- 8. 뷰를 통한 UPDATE
UPDATE employee_view SET salary = 4800000 WHERE employee_id = 2;

-- =====================================================
-- 섹션 3: 저장프로시저 기본 (9-13번)
-- =====================================================

-- 9. 기본 저장프로시저 (입력 매개변수)
CREATE PROCEDURE GetEmployeeInfo (IN emp_id INT)
BEGIN
  SELECT employee_id, name, salary, dept_id
  FROM employees
  WHERE employee_id = emp_id;
END;

CALL GetEmployeeInfo(1);

-- 10. 출력 매개변수 (결과 반환)
CREATE PROCEDURE GetEmployeeCount (OUT emp_count INT)
BEGIN
  SELECT COUNT(*) INTO emp_count FROM employees;
END;

CALL GetEmployeeCount(@count);
SELECT @count;

-- 11. 입출력 매개변수 (급여 인상)
CREATE PROCEDURE IncreaseSalary (INOUT salary DECIMAL)
BEGIN
  SET salary = salary * 1.1;
END;

SET @my_salary = 5000000;
CALL IncreaseSalary(@my_salary);
SELECT @my_salary;

-- 12. IF-ELSE 조건문 (급여 수준 분류)
CREATE PROCEDURE CheckSalaryLevel (IN emp_id INT)
BEGIN
  DECLARE emp_salary DECIMAL;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary > 5000000 THEN
    SELECT '상위' AS salary_level;
  ELSEIF emp_salary > 4000000 THEN
    SELECT '중위' AS salary_level;
  ELSE
    SELECT '하위' AS salary_level;
  END IF;
END;

CALL CheckSalaryLevel(1);

-- 13. CASE 문 (학점 할당)
CREATE PROCEDURE GetGrade (IN score INT, OUT grade CHAR(1))
BEGIN
  SET grade = CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 80 THEN 'B'
    WHEN score >= 70 THEN 'C'
    ELSE 'F'
  END;
END;

CALL GetGrade(85, @result);
SELECT @result;

-- =====================================================
-- 섹션 4: 고급 프로시저 (14-16번)
-- =====================================================

-- 14. WHILE 루프 (반복 처리)
CREATE PROCEDURE InsertSampleData (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO employees (name, dept_id, salary)
    VALUES (CONCAT('직원', i), 1, 3000000 + (i * 100000));
    SET i = i + 1;
  END WHILE;
END;

-- CALL InsertSampleData(5);

-- 15. 변수 선언과 할당 (급여 통계)
CREATE PROCEDURE CalculateSalaryInfo ()
BEGIN
  DECLARE total_salary DECIMAL;
  DECLARE avg_salary DECIMAL;
  DECLARE emp_count INT;
  
  SELECT SUM(salary) INTO total_salary FROM employees;
  SELECT AVG(salary) INTO avg_salary FROM employees;
  SELECT COUNT(*) INTO emp_count FROM employees;
  
  SELECT total_salary, avg_salary, emp_count;
END;

CALL CalculateSalaryInfo();

-- 16. 트랜잭션 포함 프로시저 (부서 이동)
CREATE PROCEDURE TransferEmployee (IN emp_id INT, IN new_dept INT)
BEGIN
  START TRANSACTION;
  
  UPDATE employees SET dept_id = new_dept WHERE employee_id = emp_id;
  
  COMMIT;
END;

-- CALL TransferEmployee(1, 2);

-- =====================================================
-- 섹션 5: 실무 응용 (17-20번)
-- =====================================================

-- 17. 데이터 검증 프로시저 (존재 여부 확인)
CREATE PROCEDURE ValidateEmployee (IN emp_id INT, OUT is_valid INT)
BEGIN
  IF EXISTS(SELECT 1 FROM employees WHERE employee_id = emp_id) THEN
    SET is_valid = 1;
  ELSE
    SET is_valid = 0;
  END IF;
END;

CALL ValidateEmployee(1, @valid);
SELECT @valid;

-- 18. 통계 계산 프로시저 (총합, 평균, 최고값)
CREATE PROCEDURE GetSalaryStatistics (OUT total DECIMAL, OUT average DECIMAL, OUT max DECIMAL)
BEGIN
  SELECT SUM(salary), AVG(salary), MAX(salary)
  INTO total, average, max FROM employees;
END;

CALL GetSalaryStatistics(@t, @a, @m);
SELECT @t AS total, @a AS average, @m AS max;

-- 19. 마이그레이션 프로시저 (데이터 이전)
CREATE PROCEDURE MigrateOldEmployees ()
BEGIN
  START TRANSACTION;
  
  INSERT INTO employees_archive
  SELECT * FROM employees WHERE hire_date < '2020-01-01';
  
  DELETE FROM employees WHERE hire_date < '2020-01-01';
  
  COMMIT;
END;

-- CALL MigrateOldEmployees();

-- 20. 백업 프로시저 (데이터 복사)
CREATE PROCEDURE BackupData ()
BEGIN
  DELETE FROM employees_archive;
  INSERT INTO employees_archive
  SELECT * FROM employees;
END;

CALL BackupData();
```



---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: 뷰의 개념, 특징, 활용 사례를 설명하세요. 뷰를 사용하는 장점과 단점을 분석하고, 어떤 상황에서 뷰를 사용해야 하는지 논의하세요.

**2번 과제**: 저장프로시저의 개념과 특징을 설명하세요. 저장프로시저가 필요한 상황과 애플리케이션 로직을 데이터베이스에서 처리할 때의 고려사항을 서술하세요.

**3번 과제**: 저장프로시저의 매개변수(IN, OUT, INOUT)의 차이점을 설명하고, 각각의 활용 사례를 제시하세요.

**4번 과제**: 저장프로시저의 제어 구조(IF-THEN-ELSE, WHILE, CASE)와 에러 처리 방법을 설명하세요. 복잡한 비즈니스 로직을 구현하는 방법을 논의하세요.

**5번 과제**: 뷰와 저장프로시저의 성능 특성을 비교하세요. 어떤 경우에 뷰를 사용할지, 저장프로시저를 사용할지 선택 기준을 제시하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제


**1번 과제**: 다양한 유형의 뷰를 생성하세요: 단순 뷰, JOIN 뷰, 집계 뷰, 조건부 뷰.

**2번 과제**: 수정 가능한 뷰를 생성하고, 뷰를 통한 INSERT, UPDATE를 실습하세요.

**3번 과제**: 다양한 매개변수를 가진 저장프로시저를 작성하세요: IN, OUT, INOUT.

**4번 과제**: 제어문(IF-ELSE, CASE, WHILE)을 사용한 저장프로시저를 작성하세요.

**5번 과제**: Part 3의 실습 10-1부터 10-20까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 실무 시나리오 기반 뷰와 프로시저를 만들어 그 목적과 활용 방법을 설명하세요.

제출 형식: SQL 파일 (Ch10_View_Procedure_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
