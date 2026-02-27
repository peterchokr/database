# 12장. 트리거 (Trigger)

## 📖 수업 개요

이 장에서는 특정 사건이 발생했을 때 자동으로 실행되는 데이터베이스 객체인 **트리거(Trigger)** 를 학습합니다.
INSERT, UPDATE, DELETE 이전/이후에 자동으로 실행되는 트리거를 사용하여 데이터 무결성을 보장하고, 감사 로그를 자동으로 기록하며, 데이터 일관성을 유지하는 방법을 다룹니다. 트리거의 강력한 기능과 주의사항을 이해하는 것이 목표입니다.

---

## 📚 Part 1: 이론

### 12.1 트리거 (Trigger)의 개념

#### 💡 트리거란?

**트리거(Trigger)** 는 특정 테이블의 데이터에 INSERT, UPDATE, DELETE 작업이 발생했을 때 **자동으로 실행되는 저장 프로시저**입니다. 마치 어떤 사건이 발생하면 자동으로 반응하는 "촉발 장치"와 같습니다.

**일상생활의 비유:**

- 비상 경보 시스템: 화재 감지기가 열을 감지하면 자동으로 경보가 울림
- 자동 문: 사람이 다가가면 자동으로 열림
- 데이터베이스 트리거: 데이터가 변경되면 자동으로 특정 작업 실행

#### 🎯 트리거의 특징

**1. 자동 실행**

- 사용자가 명시적으로 호출할 필요가 없음
- INSERT/UPDATE/DELETE가 발생하면 자동으로 작동

**2. 데이터 무결성 보장**

- 잘못된 데이터 입력 방지
- 데이터 규칙 자동 검증
- 일관성 있는 상태 유지

**3. 감시 및 감사 기능**

- 모든 데이터 변경 자동 기록
- 누가 언제 어떤 데이터를 변경했는지 추적 가능
- 보안 감사(Audit) 구현

**4. 복잡한 비즈니스 규칙 자동화**

- 사용자의 실수 가능성 제거
- 비즈니스 규칙을 데이터베이스 수준에서 강제

#### 📋 트리거의 주요 사용 사례

```
✓ 감사 로그(Audit Log) 자동 기록
  → 언제 누가 어떤 데이터를 변경했는지 기록

✓ 데이터 검증 및 제약 조건 강제
  → 급여는 음수가 될 수 없다
  → 가격은 0 이상이어야 한다

✓ 자동 계산 및 업데이트
  → 주문 시 재고 자동 감소
  → 합계 금액 자동 계산

✓ 데이터 동기화
  → 한 테이블의 변경이 다른 테이블에 자동 반영

✓ 관련 테이블 자동 업데이트
  → 직원 삭제 시 관련 급여 기록도 삭제
```

---

## 📚 Part 2: 샘플 데이터 및 테이블 구조

### 🔧 실습을 위한 필수 설정

Part 3의 예제들이 모두 작동하도록 필요한 모든 테이블과 샘플 데이터를 생성합니다.

```sql
-- =====================================================
-- 데이터베이스 생성 및 기본 설정
-- =====================================================
CREATE DATABASE ch12_trigger CHARACTER SET utf8mb4;
USE ch12_trigger;

-- =====================================================
-- 1. employees 테이블 (직원 정보)
-- =====================================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    position VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    emp_level VARCHAR(20),
    job_title VARCHAR(50),
    last_modified TIMESTAMP
);

-- 샘플 데이터
INSERT INTO employees (name, salary, position, department, hire_date, emp_level, job_title)
VALUES 
('김철수', 5000000, '과장', '개발팀', '2020-01-15', 'Level 3', '개발관리자'),
('이영희', 4000000, '대리', '영업팀', '2020-06-20', 'Level 2', '영업직'),
('박민준', 4500000, '대리', '기획팀', '2019-03-10', 'Level 2', '기획자');

-- =====================================================
-- 2. salary_history 테이블 (급여 변경 이력)
-- =====================================================
CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(50),
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_reason VARCHAR(100),
    changed_at TIMESTAMP
);

-- =====================================================
-- 3. salary_change_percent 테이블 (급여 변경 비율)
-- =====================================================
CREATE TABLE salary_change_percent (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    change_percent DECIMAL(5, 2),
    changed_at TIMESTAMP
);

-- =====================================================
-- 4. audit_log 테이블 (감사 로그)
-- =====================================================
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    column_name VARCHAR(50),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    changed_at TIMESTAMP
);

-- =====================================================
-- 5. products 테이블 (상품 정보)
-- =====================================================
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    product_code VARCHAR(50),
    created_at TIMESTAMP
);

-- =====================================================
-- 6. employee_archive 테이블 (퇴직 직원 보관)
-- =====================================================
CREATE TABLE employee_archive (
    archive_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    archived_at TIMESTAMP,
    archived_reason VARCHAR(100)
);

-- =====================================================
-- 7. salary_history_archive 테이블 (급여 이력 보관)
-- =====================================================
CREATE TABLE salary_history_archive (
    archive_history_id INT,
    emp_id INT,
    emp_name VARCHAR(50),
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_reason VARCHAR(100),
    changed_at TIMESTAMP
);


```

### ✅ 데이터베이스 생성 확인

다음 명령으로 모든 테이블이 정상 생성되었는지 확인하세요:

```sql
-- 모든 테이블 목록 확인
SHOW TABLES;

-- employees 테이블 데이터 확인
SELECT * FROM employees;
```

---

## 📚 Part 3:  학습 및 실습

### 12.2 트리거 생성 문법

#### 📝 기본 문법

```sql
CREATE TRIGGER trigger_name
BEFORE/AFTER INSERT/UPDATE/DELETE ON table_name
FOR EACH ROW
BEGIN
  -- 트리거 본문
  trigger_statements;
END;
```

#### 🔑 각 부분의 의미

**트리거 이름 (trigger_name)**

- 트리거를 구분하는 고유 이름
- 관례: `{시점}_{작업}_{테이블명}` 형식

**시점 (BEFORE/AFTER)**

- **BEFORE**: 데이터 변경 전에 실행 (검증, 값 변환, 거부)
- **AFTER**: 데이터 변경 후에 실행 (로그 기록, 연쇄 작업)

---

### 12.3 NEW와 OLD

#### 🎯 NEW와 OLD의 개념

트리거 내에서는 **NEW**와 **OLD**라는 특수한 변수를 사용하여 변경 전후의 데이터에 접근할 수 있습니다.

#### 📌 각 작업 유형별 사용 가능한 참조

| 작업   | NEW 사용 | OLD 사용 |
| ------ | -------- | -------- |
| INSERT | ✓ 가능  | ✗ 불가  |
| UPDATE | ✓ 가능  | ✓ 가능  |
| DELETE | ✗ 불가  | ✓ 가능  |

#### 💡 실제 예시

```sql
-- 직원 급여 변경을 추적하는 트리거
DELIMITER //
CREATE TRIGGER salary_update_log
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  -- OLD.salary: 수정 전 급여
  -- NEW.salary: 수정 후 급여
  
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history 
    (emp_id, emp_name, old_salary, new_salary, change_reason, changed_at)
    VALUES (NEW.employee_id, NEW.name, OLD.salary, NEW.salary, '정기 인상', NOW());
  END IF;
END //
DELIMITER ;

-- 테스트: 급여 변경
UPDATE employees SET salary = 5500000 WHERE employee_id = 1;

-- 결과 확인
SELECT * FROM salary_history;
```

---

### 12.4 BEFORE 트리거 - 데이터 검증 & 변환

#### 🎯 BEFORE 트리거의 역할

데이터베이스에 **실제로 저장되기 전에** 데이터를 검증하고 필요하면 변환합니다.

#### 💼 실전 예제 1: 데이터 검증

```sql
-- 급여는 반드시 양수여야 한다는 규칙 강제
DELIMITER //
CREATE TRIGGER validate_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  -- 음수 급여 검증
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '급여는 음수일 수 없습니다. 양수를 입력하세요.';
  END IF;
  
  -- 급여 상한 검증 (CEO가 아닌 경우)
  IF NEW.salary > 100000000 AND NEW.position != 'CEO' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '1억원 이상의 급여는 CEO만 가능합니다.';
  END IF;
END //
DELIMITER ;

-- 테스트 1: 음수 급여 입력 (실패해야 함)
INSERT INTO employees (name, salary, position, department) 
VALUES ('테스트', -100000, '대리', '개발팀');
-- ❌ 오류: 급여는 음수일 수 없습니다

-- 테스트 2: 정상 급여 입력 (성공)
INSERT INTO employees (name, salary, position, department) 
VALUES ('이순신', 5000000, '대리', '개발팀');
-- ✅ 성공
```

#### 💼 실전 예제 2: 자동 값 설정

```sql
-- 신규 직원 등록 시 자동으로 등록일 설정
DELIMITER //
CREATE TRIGGER set_hire_date_on_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  -- hire_date가 지정되지 않으면 오늘 날짜 자동 설정
  IF NEW.hire_date IS NULL THEN
    SET NEW.hire_date = (CURDATE());
  END IF;
  
  -- 등급이 지정되지 않으면 'Level 1' 자동 설정
  IF NEW.emp_level IS NULL THEN
    SET NEW.emp_level = 'Level 1';
  END IF;
END //
DELIMITER ;

-- 테스트: hire_date와 emp_level을 지정하지 않고 삽입
INSERT INTO employees (name, salary, position, department) 
VALUES ('강감찬', 4000000, '사원', '마케팅팀');

-- 결과 확인
SELECT name, hire_date, emp_level FROM employees WHERE name = '강감찬';
-- hire_date: 현재 날짜 (자동 설정)
-- emp_level: Level 1 (자동 설정)
```

---

### 12.5 AFTER 트리거 - 로그 기록 & 연쇄 작업

#### 🎯 AFTER 트리거의 역할

데이터가 **실제로 저장된 후에** 로그 기록, 이메일 발송, 다른 테이블 업데이트 등의 후속 작업을 수행합니다.

#### 💼 실전 예제: 감사 로그 기록

```sql
-- 직원 정보 변경 시 모든 변경사항을 로그 테이블에 기록
DELIMITER //
CREATE TRIGGER audit_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  -- 변경된 항목마다 별도의 로그 생성
  IF NEW.name != OLD.name THEN
    INSERT INTO audit_log (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'name', OLD.name, NEW.name, NOW());
  END IF;
  
  IF NEW.salary != OLD.salary THEN
    INSERT INTO audit_log (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'salary', OLD.salary, NEW.salary, NOW());
  END IF;
  
  IF NEW.department != OLD.department THEN
    INSERT INTO audit_log (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'department', OLD.department, NEW.department, NOW());
  END IF;
END //
DELIMITER ;

-- 테스트: 직원 정보 업데이트
UPDATE employees 
SET name = '김철수김',
    salary = 5500000,
    department = '기획팀'
WHERE employee_id = 1;

-- 결과 확인
SELECT * FROM audit_log;
-- 3개의 로그 레코드가 자동으로 생성됨
```

---

### 12.6 INSERT 트리거

#### 🎯 INSERT 트리거의 용도

새로운 데이터가 테이블에 추가될 때 실행되는 트리거입니다.

#### 💼 실전 예제: 자동 코드 생성

```sql
-- 상품이 추가될 때 자동으로 상품 코드 생성
DELIMITER //
CREATE TRIGGER generate_product_code
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  -- 형식: YYYY-MM + 4자리 일련번호
  SET NEW.product_code = CONCAT(
    DATE_FORMAT(NOW(), '%Y-%m'),
    '-',
    LPAD(NEW.product_id, 4, '0')
  );
  
  -- 상품 등록 시간 자동 설정
  SET NEW.created_at = NOW();
END //
DELIMITER ;

-- 테스트: 상품 추가
INSERT INTO products (product_name, price) 
VALUES ('노트북', 1500000);

-- 결과 확인
SELECT * FROM products;
-- product_code: 2024-01-0001 (자동 생성)
-- created_at: 현재 시간 (자동 설정)
```

---

### 12.7 UPDATE 트리거

#### 🎯 UPDATE 트리거의 용도

데이터가 수정될 때 변경 이력을 추적하거나 데이터 검증을 수행합니다.

#### 💼 실전 예제 1: 변경 이력 추적

```sql
-- 급여 변경이 있을 때마다 이력 기록
DELIMITER //
CREATE TRIGGER track_salary_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  -- 급여가 실제로 변경된 경우만 기록
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history 
    (emp_id, emp_name, old_salary, new_salary, change_reason, changed_at)
    VALUES (
      NEW.employee_id,
      NEW.name,
      OLD.salary,
      NEW.salary,
      '정기 인상',
      NOW()
    );
  
    -- 급여 변경 비율 계산
    INSERT INTO salary_change_percent
    (emp_id, change_percent, changed_at)
    VALUES (
      NEW.employee_id,
      ROUND((NEW.salary - OLD.salary) / OLD.salary * 100, 2),
      NOW()
    );
  END IF;
END //
DELIMITER ;

-- 테스트: 급여 업데이트
UPDATE employees SET salary = 5500000 WHERE employee_id = 2;

-- 결과 확인
SELECT * FROM salary_history;
SELECT * FROM salary_change_percent;
```

#### 💼 실전 예제 2: 수정 전 데이터 검증

```sql
-- 급여 인상이 과도하지 않도록 제한
DELIMITER //
CREATE TRIGGER validate_salary_increase
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  DECLARE raise_percent DECIMAL(5, 2);
  
  -- 급여 인상 비율 계산
  SET raise_percent = ROUND((NEW.salary - OLD.salary) / OLD.salary * 100, 2);
  
  -- 한 번에 50% 이상 인상 불가
  IF raise_percent > 50 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '급여는 한 번에 50% 이상 인상할 수 없습니다.';
  END IF;
  
  -- 기본적으로 급여는 감소할 수 없음 (강등 제외)
  IF NEW.salary < OLD.salary AND NEW.position = OLD.position THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '같은 직급에서는 급여를 감소시킬 수 없습니다.';
  END IF;
  
  -- 수정 시간 자동 업데이트
  SET NEW.last_modified = NOW();
END //
DELIMITER ;

-- 테스트 1: 50% 이상 인상 시도 (실패)
UPDATE employees SET salary = 8000000 WHERE employee_id = 3;
-- ❌ 오류

-- 테스트 2: 정상 인상 (성공)
UPDATE employees SET salary = 5100000 WHERE employee_id = 3;
-- ✅ 성공, last_modified 자동 업데이트
```

---

### 12.8 DELETE 트리거

#### 🎯 DELETE 트리거의 용도

데이터 삭제 시 중요한 데이터를 아카이브하거나 관련 정보를 정리합니다.

#### 💼 실전 예제: 삭제 전 아카이브

```sql
-- 직원 삭제 전 모든 정보를 아카이브 테이블에 저장
DELIMITER //
CREATE TRIGGER archive_employee_before_delete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  -- 삭제되는 직원 정보 보관
  INSERT INTO employee_archive (
    emp_id, emp_name, salary, department, hire_date, 
    job_title, archived_at, archived_reason
  )
  VALUES (
    OLD.employee_id,
    OLD.name,
    OLD.salary,
    OLD.department,
    OLD.hire_date,
    OLD.job_title,
    NOW(),
    '퇴직'
  );
  
  -- 삭제되는 직원과 관련된 급여 기록도 아카이브
  INSERT INTO salary_history_archive
  SELECT * FROM salary_history 
  WHERE emp_id = OLD.employee_id;
END //
DELIMITER ;

-- 테스트: 직원 삭제
DELETE FROM employees WHERE employee_id = 1;

-- 결과 확인
SELECT * FROM employee_archive;
SELECT * FROM salary_history_archive;
```

---

### 12.9 트리거 조회 및 삭제

#### 📋 트리거 조회 방법

```sql
-- 현재 데이터베이스의 모든 트리거 조회
SHOW TRIGGERS;

-- 특정 데이터베이스의 트리거 조회
SHOW TRIGGERS FROM ch12_trigger;
```

#### 🗑️ 트리거 삭제 방법

```sql
-- 안전한 삭제 (존재하지 않으면 무시)
DROP TRIGGER IF EXISTS salary_update_log;

```

---

### 12.10 트리거의 주의사항

#### ⚠️ 성능 영향

**문제점:**

- 모든 INSERT/UPDATE/DELETE마다 트리거 실행
- 대량 데이터 입력 시 성능 저하

**대처 방법:**

```sql
-- 트리거 임시 삭제 후 재생성
DROP TRIGGER IF EXISTS trigger_name;
CREATE TRIGGER trigger_name ...
```

#### 📋 호환성 문제

**주의:**

- 데이터베이스마다 트리거 문법이 다름
- MySQL, PostgreSQL, SQL Server 모두 문법 상이

#### 🚫 기타 제약사항

```
❌ BEFORE INSERT 트리거에서 OLD 값 사용 불가
❌ AFTER DELETE 트리거에서 NEW 값 사용 불가
❌ 트리거 내에서 COMMIT/ROLLBACK 사용 불가
```

---

## 📝 Part 4: 과제 안내

### 이론 과제

1. 트리거의 개념을 설명하고, 사용해야 하는 상황 5가지 제시
2. BEFORE와 AFTER 트리거의 차이 설명
3. NEW와 OLD 참조의 개념 및 사용 가능성 표로 정리
4. 트리거의 성능 영향 및 최적화 방안
5. 트리거 사용 시 주의사항 및 연쇄 반응 문제

### 실습 과제

1. Part 1의 12.3 ~ 12.8 모든 예제 실행
2. 각 트리거의 작동 테스트
3. 추가 트리거 2개 이상 작성

---

수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 수업자료는 Claude와 Gemini를 이용하여 제작되었습니다.
