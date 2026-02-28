# Ch12 트리거 - 연습문제

학생 여러분! 12장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

12장을 마친 후 다음을 이해해야 합니다:

- 트리거의 개념과 작동 원리
- BEFORE와 AFTER 트리거의 차이
- INSERT, UPDATE, DELETE 트리거
- NEW와 OLD 참조
- 트리거의 활용 사례 (감사 로그, 데이터 검증)
- 트리거의 생성, 조회, 삭제

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** 트리거(Trigger)의 정의로 옳은 것은?

- ① 수동으로 호출하는 프로시저
- ② 특정 테이블의 DML 작업이 발생할 때 자동으로 실행되는 객체
- ③ 데이터를 조회하는 쿼리
- ④ 테이블을 변경하는 DDL 명령어

---

**2번** BEFORE 트리거의 주요 용도는?

- ① 로그 기록
- ② 데이터 검증 및 자동 변환
- ③ 연쇄 작업 수행
- ④ 데이터 조회

---

**3번** AFTER 트리거의 주요 용도는?

- ① 데이터 검증
- ② 원본 데이터 변경
- ③ 로그 기록 및 연쇄 작업
- ④ 쿼리 최적화

---

**4번** 트리거에서 NEW와 OLD의 의미는?

- ① 오래된 데이터와 새로운 데이터
- ② 트리거 실행 순서
- ③ 테이블의 두 가지 이름
- ④ 데이터베이스의 버전

---

**5번** UPDATE 트리거에서 사용 가능한 것은?

- ① NEW만 사용 가능
- ② OLD만 사용 가능
- ③ NEW와 OLD 모두 사용 가능
- ④ 변수만 사용 가능

---

## 중급 수준 (3개) - 개념 적용

**6번** INSERT 트리거의 NEW 참조:

```sql
CREATE TRIGGER validate_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '음수 불가';
  END IF;
END;
```

이 트리거의 목적은?

- ① 급여가 음수인 직원만 삽입
- ② 음수 급여 데이터 삽입 방지
- ③ 급여 자동 계산
- ④ 모든 데이터 검증

---

**7번** 트리거와 프로시저의 차이는?

- ① 트리거는 자동 실행, 프로시저는 수동 호출
- ② 프로시저는 자동 실행, 트리거는 수동 호출
- ③ 기능이 완전히 같음
- ④ 성능만 다름

---

**8번** 트리거 삭제 명령어는?

- ① DELETE TRIGGER trigger_name;
- ② DROP TRIGGER trigger_name;
- ③ REMOVE TRIGGER trigger_name;
- ④ TRUNCATE TRIGGER trigger_name;

---

## 고급 수준 (2개) - 비판적 사고

**9번** BEFORE INSERT와 AFTER INSERT 트리거의 차이는?

- ① BEFORE는 데이터 검증, AFTER는 로그 기록에 적합
- ② AFTER는 데이터 변경 가능
- ③ BEFORE는 로그 기록 전용
- ④ 차이가 없음

---

**10번** 트리거 사용 시 주의사항은?

- ① 성능 저하 가능성
- ② 디버깅 어려움
- ③ 예기치 않은 연쇄 반응
- ④ ①②③ 모두

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** 트리거의 정의와 자동으로 실행되는 이유를 설명하시오.

---

**12번** BEFORE 트리거와 AFTER 트리거의 차이를 설명하고, 각각의 활용 사례를 제시하시오.

---

**13번** NEW와 OLD 참조의 의미를 설명하고, INSERT, UPDATE, DELETE 트리거에서 각각의 사용 가능 여부를 설명하시오.

---

## 중급 수준 (1개)

**14번** 감사 로그(Audit Log) 트리거의 개념을 설명하고, UPDATE 작업 시 급여 변경을 감시하는 트리거를 설계하시오.

---

## 고급 수준 (1개)

**15번** 트리거를 사용할 때의 장점과 단점을 분석하고, 트리거 대신 애플리케이션 로직으로 구현해야 하는 경우를 설명하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch12_trigger CHARACTER SET utf8mb4;
USE ch12_trigger;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    salary INT,
    hire_date DATE
);

CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary INT,
    new_salary INT,
    change_date DATETIME
);

INSERT INTO employees VALUES
(1, '김철수', 5000000, '2020-01-15'),
(2, '이영희', 4000000, '2020-06-20');

SELECT * FROM employees;
```

제출: employees 테이블에 2명 데이터가 모두 보이는 스크린샷

---

**17번** UPDATE 이전에 급여 변경을 감시하는 AFTER UPDATE 트리거를 생성하고 실행하시오.

```sql
-- 트리거 생성
CREATE TRIGGER log_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (NEW.employee_id, OLD.salary, NEW.salary, NOW());
  END IF;
END;

-- 급여 수정
UPDATE employees SET salary = 5500000 WHERE employee_id = 1;

-- 결과 확인
SELECT * FROM employees WHERE employee_id = 1;
SELECT * FROM salary_history;
```

제출: employees와 salary_history 테이블 결과 스크린샷

---

## 중급 수준 (2개)

**18번** 데이터 검증 BEFORE INSERT 트리거를 생성하고 실행하시오.

```sql
-- 음수 급여 방지 트리거
CREATE TRIGGER validate_salary_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '급여는 음수일 수 없습니다';
  END IF;
  
  -- hire_date 자동 설정
  IF NEW.hire_date IS NULL THEN
    SET NEW.hire_date = CURDATE();
  END IF;
END;

-- 정상 INSERT (hire_date 자동 설정)
INSERT INTO employees (name, salary) VALUES ('박민준', 4500000);

-- 음수 급여 시도 (오류 발생)
-- INSERT INTO employees VALUES (NULL, '정준호', -3000000, '2024-01-01');

-- 결과 확인
SELECT * FROM employees WHERE name = '박민준';
```

제출: INSERT 결과 및 트리거 동작 스크린샷

---

**19번** DELETE 이전에 데이터를 아카이브하는 BEFORE DELETE 트리거를 생성하고 실행하시오.

```sql
-- 아카이브 테이블 생성
CREATE TABLE employee_archive (
    archive_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(30),
    emp_salary INT,
    deleted_date DATETIME
);

-- DELETE 트리거 생성
CREATE TRIGGER archive_employee_delete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_archive (emp_id, emp_name, emp_salary, deleted_date)
  VALUES (OLD.employee_id, OLD.name, OLD.salary, NOW());
END;

-- 직원 삭제
DELETE FROM employees WHERE employee_id = 2;

-- 결과 확인
SELECT * FROM employees;
SELECT * FROM employee_archive;
```

제출: DELETE 후 employees와 employee_archive 결과 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복잡한 트리거를 작성하고 실행하시오.

```
요구사항:
1. 급여 인상 감시 트리거
   - 급여가 20% 이상 인상되면 특별 로그 기록
   - 급여 상한선 제한 (6000000원 초과 불가)

2. 데이터 무결성 트리거
   - 직원 추가 시 기본 hire_date 설정
   - 급여 음수 입력 방지
   - 급여 수정 시 이력 기록

3. 연쇄 트리거
   - 직원 삭제 시 급여 이력도 함께 처리
   - 아카이브 테이블에 기록

4. 트리거 조회 및 검증
   - 생성된 모든 트리거 확인
   - 트리거 동작 검증

제출:
   - 각 트리거의 SQL 코드
   - 각 트리거의 실행 결과 스크린샷
   - 트리거 조회 결과 (SHOW TRIGGERS)
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                           |
| :--: | :--: | :----------------------------- |
| 1번 |  ②  | 트리거는 DML 작업 시 자동 실행 |
| 2번 |  ②  | BEFORE는 검증과 변환           |
| 3번 |  ③  | AFTER는 로그와 연쇄 작업       |
| 4번 |  ①  | NEW와 OLD는 새/구 데이터       |
| 5번 |  ③  | UPDATE에서 NEW와 OLD 모두 가능 |
| 6번 |  ②  | 음수 급여 방지                 |
| 7번 |  ①  | 트리거는 자동, 프로시저는 수동 |
| 8번 |  ②  | DROP TRIGGER로 삭제            |
| 9번 |  ①  | BEFORE는 검증, AFTER는 로그    |
| 10번 |  ④  | ①②③ 모두 주의사항           |

---

## 주관식 모범 답안 (5개)

### 11번 트리거의 정의와 자동 실행

**모범 답안**:

```
정의:
- 특정 테이블의 DML(INSERT, UPDATE, DELETE) 작업이 
  발생했을 때 자동으로 실행되는 저장 프로시저

자동 실행 이유:
- 트리거는 데이터베이스 객체로 저장됨
- DML 작업 시 DBMS가 자동으로 검사
- 명시적 호출 없이 실행
- 비즈니스 규칙을 자동으로 강제

장점:
- 일관된 데이터 무결성
- 코드 중복 제거
- 감사 기능 자동화
```

---

### 12번 BEFORE와 AFTER 트리거

**모범 답안**:

```
BEFORE 트리거:
- 시점: DML 작업 이전
- NEW와 OLD: NEW 참조 가능 (INSERT: NEW만, UPDATE: 둘 다)
- 목적: 데이터 검증, 자동 변환
- 거부 가능: SIGNAL로 작업 거부 가능

예:
CREATE TRIGGER validate_email
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  IF NEW.email NOT LIKE '%@%' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '유효한 이메일 필요';
  END IF;
END;

AFTER 트리거:
- 시점: DML 작업 이후
- NEW와 OLD: 모두 참조 가능 (읽기만 가능)
- 목적: 로그 기록, 연쇄 작업, 통지
- 거부 불가: 이미 작업 완료

예:
CREATE TRIGGER log_user_changes
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
  IF NEW.status != OLD.status THEN
    INSERT INTO audit_log VALUES (...);
  END IF;
END;

활용 사례:
BEFORE: 입력값 검증, 기본값 설정, 값 변환
AFTER: 감사 로그, 통계 업데이트, 다른 테이블 자동 갱신
```

---

### 13번 NEW와 OLD 참조

**모범 답안**:

```
NEW:
- 의미: 새로 삽입되거나 수정될 값
- INSERT 트리거: NEW 사용 가능 (새 데이터)
- UPDATE 트리거: NEW 사용 가능 (수정 후 값)
- DELETE 트리거: NEW 사용 불가

OLD:
- 의미: 수정되기 전이나 삭제될 값
- INSERT 트리거: OLD 사용 불가
- UPDATE 트리거: OLD 사용 가능 (수정 전 값)
- DELETE 트리거: OLD 사용 가능 (삭제된 값)

사용 가능 여부:
             | NEW | OLD |
INSERT 전    |  ○ |  ✗ |
UPDATE 전후  |  ○ |  ○ |
DELETE 전    |  ✗ |  ○ |

예시:
-- UPDATE에서 변경 감지
IF NEW.salary != OLD.salary THEN
  -- 급여 변경 기록
END IF;

-- DELETE에서 삭제 기록
INSERT INTO archive SELECT OLD.*;
```

---

### 14번 감사 로그 트리거

**모범 답안**:

```
개념:
- 모든 데이터 변경사항을 기록하는 트리거
- 언제, 누가, 무엇을 변경했는지 추적
- 데이터베이스 보안 및 감시 기능

설계 (급여 변경 감시):

CREATE TABLE salary_audit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  old_salary INT,
  new_salary INT,
  change_date DATETIME,
  change_percent DECIMAL(5,2)
);

CREATE TRIGGER track_salary_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_audit VALUES (
      NULL,
      NEW.employee_id,
      OLD.salary,
      NEW.salary,
      NOW(),
      ROUND((NEW.salary - OLD.salary) / OLD.salary * 100, 2)
    );
  END IF;
END;

활용:
UPDATE employees SET salary = 5500000 WHERE employee_id = 1;

결과 확인:
SELECT * FROM salary_audit;
-- 변경 내역, 변경 시간, 인상률 모두 기록됨
```

---

### 15번 트리거의 장단점

**모범 답안**:

```
장점:
1. 데이터 무결성 자동화
   - 비즈니스 규칙 자동 강제
   - 모든 경로의 데이터 수정에 적용

2. 감사 및 보안
   - 모든 변경 기록
   - 권한 제어 가능

3. 복잡한 로직 자동화
   - 복잡한 계산 자동 수행
   - 데이터 동기화

단점:
1. 성능 저하
   - 모든 DML에 오버헤드
   - 여러 트리거 연쇄 시 심각

2. 디버깅 어려움
   - 숨겨진 로직
   - 예기치 않은 연쇄 반응
   - 성능 문제 원인 파악 어려움

3. 유지보수 복잡성
   - 트리거 간 의존성
   - 마이그레이션 어려움

4. 재사용성 낮음
   - 트리거는 특정 DB에만 적용
   - 다른 시스템 연동 어려움

트리거 vs 애플리케이션 로직:

트리거 사용:
✅ 모든 경로(직접 SQL, 애플리케이션)에 적용 필요
✅ 데이터베이스 자체 보호 필요
✅ 간단한 검증

애플리케이션 로직:
✅ 복잡한 비즈니스 로직
✅ 외부 시스템 연동 필요
✅ 디버깅 및 테스트 용이
✅ 성능 최적화 필요
```

---

## 실습형 모범 답안 (5개)

### 16번 employees 생성

**완료 기준**:
✅ ch12_trigger 데이터베이스 생성
✅ employees, salary_history 테이블 생성
✅ 2명 데이터 입력

---

### 17번 UPDATE 트리거

**완료 기준**:
✅ log_salary_update 트리거 생성
✅ UPDATE 실행 (급여 5000000 → 5500000)
✅ salary_history에 이력 기록 확인

---

### 18번 BEFORE INSERT 트리거

**완료 기준**:
✅ validate_salary_insert 트리거 생성
✅ 자동 hire_date 설정 확인
✅ 음수 급여 방지 확인

---

### 19번 BEFORE DELETE 트리거

**완료 기준**:
✅ archive_employee_delete 트리거 생성
✅ DELETE 실행
✅ employee_archive에 백업 확인

---

### 20번 복합 트리거

**모범 답안**:

```sql
-- 1. 급여 인상 감시 + 상한선
CREATE TRIGGER salary_raise_check
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  DECLARE raise_pct INT;
  
  -- 인상율 계산
  SET raise_pct = ROUND((NEW.salary - OLD.salary) / OLD.salary * 100);
  
  -- 상한선 제한
  IF NEW.salary > 6000000 THEN
    SET NEW.salary = 6000000;
  END IF;
  
  -- 큰 인상 기록
  IF raise_pct > 20 THEN
    INSERT INTO salary_audit (note) VALUES (CONCAT('High raise:', raise_pct, '%'));
  END IF;
END;

-- 2. 데이터 무결성
CREATE TRIGGER employee_insert_validation
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '급여 음수 불가';
  END IF;
  
  IF NEW.hire_date IS NULL THEN
    SET NEW.hire_date = CURDATE();
  END IF;
END;

-- 3. UPDATE 이력
CREATE TRIGGER salary_history_log
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF NEW.salary != OLD.salary THEN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (NEW.employee_id, OLD.salary, NEW.salary, NOW());
  END IF;
END;

-- 4. DELETE 처리
CREATE TRIGGER delete_employee_cascade
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  -- 아카이브
  INSERT INTO employee_archive SELECT NULL, OLD.*;
  
  -- 급여 이력도 기록
  INSERT INTO salary_history VALUES (NULL, OLD.employee_id, OLD.salary, 0, NOW());
END;

-- 검증
SHOW TRIGGERS;
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
