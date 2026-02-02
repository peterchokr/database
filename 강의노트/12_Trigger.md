# 12장. 트리거 (Trigger)

## 📖 수업 개요

이 장에서는 특정 사건이 발생했을 때 자동으로 실행되는 데이터베이스 객체인 **트리거(Trigger)** 를 학습합니다.   
INSERT, UPDATE, DELETE 이전/이후에 자동으로 실행되는 트리거를 사용하여 데이터 무결성을 보장하고, 감사 로그를 자동으로 기록하며, 데이터 일관성을 유지하는 방법을 다룹니다. 트리거의 강력한 기능과 주의사항을 이해하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습

### 🌟 이 부분에서 배우는 것

- 트리거의 개념과 작동 원리
- BEFORE와 AFTER 트리거의 차이
- INSERT, UPDATE, DELETE 트리거의 특징
- NEW와 OLD 참조 방법
- 트리거의 실무 활용 사례
- 트리거의 성능 영향과 주의사항

---

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
- 예: `before_insert_employees`, `after_update_salary`

**시점 (BEFORE/AFTER)**

|       시점       |           실행 시기           | 사용 목적                    |
| :--------------: | :----------------------------: | :--------------------------- |
| **BEFORE** | 데이터 변경**전에** 실행 | 데이터 검증, 값 변환, 거부   |
| **AFTER** | 데이터 변경**후에** 실행 | 로그 기록, 연쇄 작업, 동기화 |

**작업 (INSERT/UPDATE/DELETE)**

- **INSERT**: 새로운 행이 테이블에 추가될 때
- **UPDATE**: 기존 행의 데이터가 수정될 때
- **DELETE**: 행이 테이블에서 삭제될 때

**FOR EACH ROW**

- 변경되는 **각 행마다** 한 번씩 실행됨
- 100개 행을 수정하면 트리거도 100번 실행

#### 📊 트리거 실행 흐름도

```
1️⃣ 사용자가 INSERT/UPDATE/DELETE 명령 실행
   ↓
2️⃣ BEFORE 트리거 실행 (존재하는 경우)
   • 데이터 검증
   • 값 변환/수정
   • 거부 가능 (오류 발생 시)
   ↓
3️⃣ 실제 데이터 변경 작업 수행
   (데이터베이스에 커밋)
   ↓
4️⃣ AFTER 트리거 실행 (존재하는 경우)
   • 로그 기록
   • 다른 테이블 업데이트
   • 연쇄 작업
   ↓
5️⃣ 트리거가 오류 없이 완료되면 모든 변경사항 확정
   (원본 작업 + BEFORE 변경 + AFTER 작업 모두 커밋)
```

---

### 12.3 NEW와 OLD 

#### 🎯 NEW와 OLD의 개념

트리거 내에서는 **NEW**와 **OLD**라는 특수한 변수를 사용하여 변경 전후의 데이터에 접근할 수 있습니다.

#### 📌 각 작업 유형별 사용 가능한 참조

**INSERT 작업**

```sql
NEW.column_name   -- ✓ 사용 가능 (새로 삽입되는 값)
OLD.column_name   -- ✗ 사용 불가 (이전 데이터 없음)
```

**UPDATE 작업**

```sql
NEW.column_name   -- ✓ 사용 가능 (수정 후의 값)
OLD.column_name   -- ✓ 사용 가능 (수정 전의 값)
```

**DELETE 작업**

```sql
NEW.column_name   -- ✗ 사용 불가 (새로운 데이터 없음)
OLD.column_name   -- ✓ 사용 가능 (삭제되는 값)
```

#### 💡 실제 예시로 이해하기

```sql
-- 직원 급여 변경을 추적하는 트리거
CREATE TRIGGER salary_update_log
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  -- OLD.salary: 수정 전 급여 (예: 5,000,000)
  -- NEW.salary: 수정 후 급여 (예: 5,500,000)
  
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (NEW.employee_id, OLD.salary, NEW.salary, NOW());
    -- 결과: (1, 5000000, 5500000, 2024-01-06 15:30:00)
  END IF;
END;
```

**이 트리거의 작동:**

1. 급여(salary) 칼럼이 업데이트됨
2. OLD.salary = 이전 급여 값
3. NEW.salary = 새로운 급여 값
4. 두 값이 다르면 salary_history 테이블에 기록
5. 변경 이력이 자동으로 저장됨

---

### 12.4 BEFORE 트리거 - 데이터 검증 & 변환

#### 🎯 BEFORE 트리거의 역할

데이터베이스에 **실제로 저장되기 전에** 데이터를 검증하고 필요하면 변환합니다.

#### 📊 BEFORE 트리거의 특징


- 데이터 검증 (유효성 확인)
- NEW 값 수정/변환
- 잘못된 데이터 거부 (SIGNAL 오류 발생)
- 자동 값 설정 (현재 날짜, 기본값 등)


#### 💼 실전 예제 1: 데이터 검증

```sql
-- 급여는 반드시 양수여야 한다는 규칙 강제
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
END;
```

**작동 원리:**

1. 사용자가 INSERT 명령 실행
2. BEFORE 트리거 실행
3. NEW.salary < 0이면 사용자 정의 오류 발생 (데이터 삽입 안 됨)
4. 조건을 만족하면 데이터 삽입

**사용자 관점:**

```sql
INSERT INTO employees VALUES (NULL, '김철수', -100000);
-- ❌ 오류: 급여는 음수일 수 없습니다

INSERT INTO employees VALUES (NULL, '김철수', 5000000);
-- ✅ 성공: 데이터 삽입됨
```

#### 💼 실전 예제 2: 자동 값 설정

```sql
-- 신규 직원 등록 시 자동으로 등록일 설정
CREATE TRIGGER set_hire_date_on_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  -- hire_date가 지정되지 않으면 오늘 날짜 자동 설정
  IF NEW.hire_date IS NULL THEN
    SET NEW.hire_date = CURDATE();
  END IF;
  
  -- 등급이 지정되지 않으면 'Level 1' 자동 설정
  IF NEW.emp_level IS NULL THEN
    SET NEW.emp_level = 'Level 1';
  END IF;
END;
```

**작동 예시:**

```sql
INSERT INTO employees (name, salary) 
VALUES ('이영희', 4000000);

-- 실제로 저장되는 데이터:
-- name: 이영희
-- salary: 4000000
-- hire_date: 2024-01-06 (자동 설정)
-- emp_level: Level 1 (자동 설정)
```

---

### 12.5 AFTER 트리거 - 로그 기록 & 연쇄 작업

#### 🎯 AFTER 트리거의 역할

데이터가 **실제로 저장된 후에** 로그 기록, 이메일 발송, 다른 테이블 업데이트 등의 후속 작업을 수행합니다.

#### 📊 AFTER 트리거의 특징

**✓ 할 수 있는 것:**

- 로그 기록
- 다른 테이블 변경
- 이메일 발송 (일부 DBMS)
- 각종 후속 작업


#### 💼 실전 예제 : 감사 로그 기록

```sql
-- 직원 정보 변경 시 모든 변경사항을 로그 테이블에 기록
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
END;
```

**작동 예시:**

```sql
-- 직원 정보 업데이트
UPDATE employees 
SET name = '이영희',  -- 변경
    salary = 4500000, -- 변경
    department = '개발팀'  -- 변경
WHERE employee_id = 1;

-- 자동으로 audit_log에 3개의 레코드 생성
-- 로그1: employees UPDATE name '김철수' → '이영희'
-- 로그2: employees UPDATE salary 4000000 → 4500000
-- 로그3: employees UPDATE department '인사팀' → '개발팀'
```


---

### 12.6 INSERT 트리거

#### 🎯 INSERT 트리거의 용도

새로운 데이터가 테이블에 추가될 때 실행되는 트리거입니다.

#### 💼 실전 예제: 자동 코드 생성

```sql
-- 상품이 추가될 때 자동으로 상품 코드 생성
CREATE TRIGGER generate_product_code
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  -- 형식: YYYY-MM + 4자리 일련번호
  -- 예: 2024-01-0001, 2024-01-0002
  SET NEW.product_code = CONCAT(
    DATE_FORMAT(NOW(), '%Y-%m'),
    '-',
    LPAD(NEW.product_id, 4, '0')
  );
  
  -- 상품 등록 시간 자동 설정
  SET NEW.created_at = NOW();
END;
```

**사용 시나리오:**

```sql
INSERT INTO products (product_name, price) 
VALUES ('노트북', 1500000);

-- 자동으로 생성되는 데이터:
-- product_code: 2024-01-0001 (자동)
-- created_at: 2024-01-06 15:30:00 (자동)
```

---

### 12.7 UPDATE 트리거

#### 🎯 UPDATE 트리거의 용도

데이터가 수정될 때 변경 이력을 추적하거나 데이터 검증을 수행합니다.

#### 💼 실전 예제 1: 변경 이력 추적

```sql
-- 급여 변경이 있을 때마다 이력 기록
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
END;
```

#### 💼 실전 예제 2: 수정 전 데이터 검증

```sql
-- 급여 인상이 과도하지 않도록 제한
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
END;
```

---

### 12.8 DELETE 트리거

#### 🎯 DELETE 트리거의 용도

데이터 삭제 시 중요한 데이터를 아카이브하거나 관련 정보를 정리합니다.

#### 💼 실전 예제: 삭제 전 아카이브

```sql
-- 직원 삭제 전 모든 정보를 아카이브 테이블에 저장
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
END;
```

**중요한 이유:**

- 직원 퇴직 시 모든 정보를 영구 보관
- 나중에 업무 관련 분쟁이나 세무 조회 시 필요
- 개인정보보호법 준수

---

### 12.9 트리거 조회 및 삭제

#### 📋 트리거 조회 방법

```sql
-- 현재 데이터베이스의 모든 트리거 조회
SHOW TRIGGERS;

-- 특정 데이터베이스의 트리거 조회
SHOW TRIGGERS FROM database_name;
```

#### 🗑️ 트리거 삭제 방법

```sql
-- 기본 삭제 (오류 발생 가능)
DROP TRIGGER trigger_name;

-- 안전한 삭제 (존재하지 않으면 무시)
DROP TRIGGER IF EXISTS trigger_name;

-- 특정 데이터베이스의 트리거 삭제
DROP TRIGGER database_name.trigger_name;
```

**삭제 시 주의:**

- 트리거를 삭제하면 해당 기능이 자동으로 작동하지 않음
- 삭제 전 다른 곳에서 이 트리거에 의존하는지 확인
- 감사 목적의 트리거는 신중히 다루기

---

### 12.10 트리거의 주의사항

#### ⚠️ 성능 영향

**문제점:**

- 모든 INSERT/UPDATE/DELETE마다 트리거 실행
- 대량 데이터 입력 시 성능 저하
- 여러 트리거가 연쇄되면 더욱 심함

**대처 방법:**

```sql
-- 불필요한 트리거는 비활성화
ALTER TABLE table_name DISABLE TRIGGER trigger_name;

-- 나중에 다시 활성화
ALTER TABLE table_name ENABLE TRIGGER trigger_name;

-- 또는 트리거 임시 삭제 후 재생성
DROP TRIGGER IF EXISTS trigger_name;
CREATE TRIGGER trigger_name ...
```


#### 🐛 디버깅의 어려움

**문제:**

- 트리거는 자동으로 실행되므로 추적이 어려움
- 데이터가 예상과 다르게 변경될 수 있음

**대처 방법:**

```sql
-- 디버깅용 로그 테이블 생성
CREATE TABLE trigger_debug_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  trigger_name VARCHAR(100),
  operation VARCHAR(50),
  old_data TEXT,
  new_data TEXT,
  debug_message TEXT,
  created_at DATETIME
);

-- 트리거에 디버그 로그 추가
CREATE TRIGGER debug_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO trigger_debug_log 
  (trigger_name, operation, new_data, debug_message, created_at)
  VALUES ('debug_trigger', 'INSERT', CONCAT('ID:', NEW.employee_id), 
          '직원 추가됨', NOW());
END;
```

#### 📋 호환성 문제

**주의:**

- 데이터베이스마다 트리거 문법이 다름
- MySQL, PostgreSQL, SQL Server 모두 문법 상이
- 데이터베이스 마이그레이션 시 트리거 재작성 필요

#### 🚫 기타 제약사항

```
❌ BEFORE INSERT 트리거에서 OLD 값 사용 불가
   (INSERT는 이전 값이 없음)

❌ AFTER DELETE 트리거에서 NEW 값 사용 불가
   (DELETE는 새로운 값이 없음)

❌ 트리거 내에서 COMMIT/ROLLBACK 사용 불가
   (자동으로 상위 트랜잭션에 포함됨)

```

---

## 📚 Part 2: 샘플 데이터 및 테이블 구조

### 필수 테이블 구성

```sql
CREATE DATABASE ch12_trigger CHARACTER SET utf8mb4;
USE ch12_trigger;

-- employees 테이블
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    department VARCHAR(50),
    position VARCHAR(50),
    hire_date DATE,
    last_modified TIMESTAMP
);

INSERT INTO employees VALUES
(1, '김철수', 5000000, '개발팀', '개발자', '2020-01-15', NOW()),
(2, '이영희', 4000000, '영업팀', '영업사원', '2020-06-20', NOW()),
(3, '박민준', 4500000, '기획팀', '기획자', '2019-03-10', NOW());

-- audit_log 테이블 (감사 로그)
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    column_name VARCHAR(50),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    changed_at TIMESTAMP
);

-- salary_history 테이블 (급여 이력)
CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(50),
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_reason VARCHAR(100),
    changed_at TIMESTAMP
);

-- employee_archive 테이블 (직원 아카이브)
CREATE TABLE employee_archive (
    archive_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department VARCHAR(50),
    hire_date DATE,
    archived_at TIMESTAMP,
    archived_reason VARCHAR(100)
);
```


---

## 💻 Part 3: 실습 (9개 문제)

### 이 부분에서 배우는 것

이 섹션에서는 다양한 형태의 트리거를 작성하고 실행하여 데이터 무결성 보장, 감사 기능, 자동 로깅 등을 구현합니다.

```sql
-- =====================================================
-- 섹션 1: INSERT 트리거 (1-3번)
-- =====================================================

-- 1. 기본 INSERT 트리거 (감사 로그 기록)
CREATE TRIGGER log_new_employee
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log 
  (table_name, operation, column_name, new_value, changed_at)
  VALUES ('employees', 'INSERT', 'employee_id', 
          CONCAT('ID:', NEW.employee_id, ' Name:', NEW.name), 
          NOW());
END;

-- 2. INSERT BEFORE 트리거 (데이터 검증)
CREATE TRIGGER validate_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: 급여는 음수가 될 수 없습니다.';
  END IF;
  
  IF NEW.department IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: 부서 정보는 필수입니다.';
  END IF;
  
  IF NEW.hire_date IS NULL THEN
    SET NEW.hire_date = CURDATE();
  END IF;
END;

-- 3. INSERT AFTER 트리거 (상세 감사 로그)
CREATE TRIGGER audit_new_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log 
  (table_name, operation, column_name, old_value, new_value, changed_at)
  VALUES 
  ('employees', 'INSERT', 'name', NULL, NEW.name, NOW()),
  ('employees', 'INSERT', 'salary', NULL, NEW.salary, NOW()),
  ('employees', 'INSERT', 'department', NULL, NEW.department, NOW()),
  ('employees', 'INSERT', 'position', NULL, NEW.position, NOW());
END;

-- =====================================================
-- 섹션 2: UPDATE 트리거 (4-6번)
-- =====================================================

-- 4. UPDATE AFTER 트리거 (변경 이력 추적)
CREATE TRIGGER track_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
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
  END IF;
END;

-- 5. UPDATE BEFORE 트리거 (수정 전 검증)
CREATE TRIGGER validate_salary_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  DECLARE raise_percentage DECIMAL(5, 2);
  
  SET raise_percentage = ROUND(
    (NEW.salary - OLD.salary) / OLD.salary * 100, 2
  );
  
  IF raise_percentage > 50 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: 급여는 한 번에 50% 이상 인상할 수 없습니다.';
  END IF;
  
  IF NEW.salary < OLD.salary AND NEW.position = OLD.position THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: 같은 직급에서는 급여를 감소시킬 수 없습니다.';
  END IF;
  
  SET NEW.last_modified = NOW();
END;

-- 6. UPDATE AFTER 트리거 (다중 정보 변경 기록)
CREATE TRIGGER log_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.name != OLD.name THEN
    INSERT INTO audit_log 
    (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'name', OLD.name, NEW.name, NOW());
  END IF;
  
  IF NEW.salary != OLD.salary THEN
    INSERT INTO audit_log 
    (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'salary', OLD.salary, NEW.salary, NOW());
  END IF;
  
  IF NEW.department != OLD.department THEN
    INSERT INTO audit_log 
    (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'department', OLD.department, NEW.department, NOW());
  END IF;
  
  IF NEW.position != OLD.position THEN
    INSERT INTO audit_log 
    (table_name, operation, column_name, old_value, new_value, changed_at)
    VALUES ('employees', 'UPDATE', 'position', OLD.position, NEW.position, NOW());
  END IF;
END;

-- =====================================================
-- 섹션 3: DELETE 트리거 및 관리 (7-9번)
-- =====================================================

-- 7. DELETE BEFORE 트리거 (아카이브 및 감사)
CREATE TRIGGER archive_deleted_employee
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_archive 
  (emp_id, emp_name, salary, department, hire_date, archived_at, archived_reason)
  VALUES (
    OLD.employee_id,
    OLD.name,
    OLD.salary,
    OLD.department,
    OLD.hire_date,
    NOW(),
    '퇴직'
  );
  
  INSERT INTO audit_log 
  (table_name, operation, column_name, old_value, changed_at)
  VALUES ('employees', 'DELETE', 'employee_id', 
          CONCAT('ID:', OLD.employee_id, ' Name:', OLD.name), 
          NOW());
END;

-- 8. 트리거 조회 (생성된 트리거 확인)
SELECT TRIGGER_NAME, EVENT_MANIPULATION, TRIGGER_TIME, 
       ACTION_STATEMENT
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = DATABASE();

-- 9. 트리거 삭제 및 재생성
DROP TRIGGER IF EXISTS track_salary_update;

CREATE TRIGGER track_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history 
    (emp_id, emp_name, old_salary, new_salary, change_reason, changed_at)
    VALUES (NEW.employee_id, NEW.name, OLD.salary, NEW.salary, '정기 인상', NOW());
  END IF;
END;
```


---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: 트리거의 개념을 설명하고, 트리거를 사용해야 하는 상황 5가지를 구체적으로 제시하세요.

**2번 과제**: BEFORE 트리거와 AFTER 트리거의 차이를 설명하고, 각각의 사용 목적과 사용 시기를 비교하세요.

**3번 과제**: NEW와 OLD 참조의 개념을 설명하고, INSERT/UPDATE/DELETE 작업 각각에서 어떤 참조가 사용 가능한지 표로 정리하세요.

**4번 과제**: 트리거의 성능 영향 문제를 설명하고, 성능 최적화 방안을 제시하세요.

**5번 과제**: 트리거 사용 시 주의사항을 설명하고, 연쇄 반응 문제와 해결 방법을 사례와 함께 제시하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 다양한 INSERT 트리거를 작성하세요:

- BEFORE INSERT로 데이터 검증
- AFTER INSERT로 감사 로그 기록
- 자동 값 설정 (등록일, 기본값 등)

**2번 과제**: UPDATE 트리거를 작성하세요:

- BEFORE UPDATE로 수정 조건 검증
- AFTER UPDATE로 변경 이력 기록
- 여러 칼럼의 변경을 각각 추적

**3번 과제**: DELETE 트리거를 작성하세요:

- BEFORE DELETE로 아카이브 처리
- 삭제 이력 기록

**4번 과제**: 중복 검증 트리거를 작성하세요:

- 동일한 이메일로 중복 가입 방지
- 핸드폰 번호 중복 검사
- 사용자 정의 검증 규칙

**5번 과제**: Part 3의 실습 12-1부터 12-9까지 제공된 모든 트리거를 직접 생성하고, 각 트리거가 정상 작동하는지 데이터 삽입/수정/삭제 작업을 통해 검증하여 결과 스크린샷을 첨부하세요. 추가로 3개 이상의 실무 시나리오(상품 관리, 재고 추적, 주문 처리 등)에 대한 종합적인 트리거 시스템을 설계하고 구현하여 그 결과를 제시하고, 각 트리거의 역할과 필요성을 설명하세요.

제출 형식: SQL 파일 (Ch12_Trigger_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
