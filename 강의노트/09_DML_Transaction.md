# 9장. DML(데이터 조작어)과 트랜잭션

---

## 📖 수업 개요

이 장에서는 데이터베이스의 데이터를 조작하는 DML 명령어(INSERT, UPDATE, DELETE)와 데이터 무결성을 보장하는 트랜잭션(Transaction)을 학습합니다.   
데이터를 정확하고 안전하게 입력, 수정, 삭제하는 방법과 여러 작업을 하나의 논리적 단위로 처리하여 데이터 일관성을 유지하는 방법을 다룹니다. 실무에서 데이터 무결성 오류를 방지하고 복구할 수 있는 능력을 개발하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습




## 9.1 INSERT 문 (데이터 삽입)

**INSERT**는 테이블에 새로운 데이터를 추가합니다.

### 기본 문법

```sql
INSERT INTO 테이블명 (열1, 열2, ...)
VALUES (값1, 값2, ...);
```

### 예시

```sql
-- 새로운 직원 정보를 지정된 열에만 삽입
INSERT INTO employees (name, dept_id, salary)
VALUES ('김철수', 1, 5000000);
```

### 왜 열 이름을 지정해야 할까?

명시적으로 열 이름을 지정하는 것이 좋은 이유:

- **코드가 더 명확함**: 각 값이 어느 열로 가는지 한눈에 알 수 있음
- **테이블 구조 변경에 강함**: 테이블에 새로운 열이 추가되어도 기존 쿼리는 깨지지 않음
- **유지보수가 쉬움**: 누군가 코드를 읽을 때 의도가 명확함
- **기본값(DEFAULT) 활용**: NOT NULL 제약이 있지만 기본값이 있는 열을 건너뛸 수 있음

### ❌ 위험한 방법

```sql
-- 모든 열에 값을 순서대로 입력 (비추천!)
INSERT INTO employees
VALUES (NULL, '이영희', 1, 4000000);  -- 위험함!
```

**왜 위험한가?**

- 테이블 구조가 변경되면 이 쿼리가 깨짐
- 열의 순서를 정확히 알아야 함
- 코드를 읽는 사람이 무엇을 삽입하는지 불명확함

### 대량 INSERT (성능 최적화)

```sql
-- 한 번에 여러 행을 삽입 (개별 INSERT보다 훨씬 빠름!)
INSERT INTO employees (name, dept_id, salary) VALUES
('박민준', 2, 4500000),
('최순신', 2, 3500000),
('황수정', 1, 4100000);
```

**대량 INSERT의 장점:**

- ⚡ 개별 INSERT 문보다 훨씬 빠름
- 🌐 네트워크 트래픽 감소
- 🔒 단일 트랜잭션으로 처리되어 안전함

### 서브쿼리를 이용한 INSERT (데이터 복사)

```sql
-- 한 테이블의 데이터를 다른 테이블로 복사
INSERT INTO employee_backup
SELECT * FROM employees 
WHERE dept_id = 1;
```

**사용 사례:**

- 💾 주요 변경 전 데이터 백업
- 📦 오래된 데이터를 아카이브 테이블로 복사
- 🔄 데이터 마이그레이션
- 🧪 실제 데이터로부터 테스트 데이터 생성

---

## 9.2 UPDATE 문 (데이터 수정)

**UPDATE**는 기존 데이터를 수정합니다.

### 기본 문법

```sql
UPDATE 테이블명
SET 열1 = 값1, 열2 = 값2, ...
WHERE 조건;
```

### ⚠️ 치명적인 경고!

**WHERE 조건을 반드시 포함하세요. 없으면 모든 행이 수정됩니다!**

```sql
-- 🚨 매우 위험! 이것을 절대 하지 마세요!
UPDATE employees SET salary = 5000000;  -- WHERE 없음!
-- 결과: 모든 직원의 급여가 5000000으로 변경됨! 😱

-- ✅ 올바른 방법
UPDATE employees SET salary = 5000000 
WHERE employee_id = 1;  -- 특정 직원만 수정
```

### 안전한 UPDATE 절차

```sql
-- 단계 1: 먼저 SELECT로 무엇이 수정될지 확인
SELECT * FROM employees WHERE dept_id = 1;

-- 단계 2: 결과가 맞으면 UPDATE 실행
UPDATE employees 
SET salary = salary * 1.1  -- 10% 인상
WHERE dept_id = 1;

-- 단계 3: 트랜잭션을 사용하면 더 안전함
START TRANSACTION;
UPDATE employees SET salary = salary * 1.1 WHERE dept_id = 1;
COMMIT;  -- 또는 ROLLBACK
```

### 수식을 사용한 UPDATE

```sql
-- 현재 값을 기반으로 계산하여 업데이트
UPDATE employees
SET salary = salary * 1.1  -- 현재 급여의 10% 인상
WHERE dept_id = 1;
```

### 조건부 UPDATE (CASE 사용)

```sql
-- 부서별로 다른 인상률 적용
UPDATE employees
SET salary = CASE
    WHEN dept_id = 1 THEN salary * 1.15  -- 영업부: 15% 인상
    WHEN dept_id = 2 THEN salary * 1.12  -- 기술부: 12% 인상
    WHEN dept_id = 3 THEN salary * 1.10  -- 인사부: 10% 인상
    ELSE salary  -- 다른 부서: 인상 없음
END;
```



---

## 9.3 DELETE 문 (데이터 삭제)

**DELETE**는 테이블의 데이터를 삭제합니다.

### 기본 문법

```sql
DELETE FROM 테이블명
WHERE 조건;
```

### ⚠️ 매우 중요한 경고!

**WHERE 조건이 없으면 모든 행이 영구적으로 삭제됩니다!**

```sql
-- 🚨 극도로 위험! 절대 하지 마세요!
DELETE FROM employees;  -- WHERE 없음!
-- 결과: 모든 직원 데이터가 사라짐! 💥

-- ✅ 올바른 방법
DELETE FROM employees WHERE employee_id = 7;  -- 특정 직원만 삭제
```

### 안전한 DELETE 절차

```sql
-- 단계 1: 삭제될 데이터를 먼저 확인
SELECT * FROM employees WHERE salary < 3500000;

-- 단계 2: 결과가 맞으면 DELETE 실행
DELETE FROM employees WHERE salary < 3500000;

-- 단계 3: 가장 안전한 방법 - 트랜잭션 사용
START TRANSACTION;
DELETE FROM employees WHERE salary < 3500000;
-- 결과 확인 후
COMMIT;  -- 삭제 확정 또는
ROLLBACK;  -- 취소하고 원상복구
```

### DELETE vs TRUNCATE 비교

| 특성        | DELETE              | TRUNCATE     |
| ----------- | ------------------- | ------------ |
| WHERE 조건  | ✅ 지원             | ❌ 미지원    |
| 롤백 가능   | ✅ 예 (트랜잭션 내) | ❌ 아니오    |
| 속도        | 느림                | 매우 빠름    |
| 사용 시기   | 선택적 삭제         | 모든 행 삭제 |
| 테이블 구조 | 유지                | 유지         |

### 외래키 제약조건 주의

```sql
-- 이 DELETE가 실패할 수 있음!
DELETE FROM departments WHERE dept_id = 1;
-- 오류: 직원 테이블이 이 부서를 참조하고 있음!

-- 해결책: 먼저 자식 레코드 삭제
DELETE FROM employees WHERE dept_id = 1;  -- 먼저 직원 삭제
DELETE FROM departments WHERE dept_id = 1;  -- 그 다음 부서 삭제
```

---

## 9.4 트랜잭션의 개념

**트랜잭션**은 여러 SQL 작업을 하나의 논리적 단위로 묶습니다.

### 왜 트랜잭션이 필요한가? (은행 송금 사례)

실제 은행 시스템에서 계좌 송금을 생각해봅시다.

#### ❌ 문제 상황 (트랜잭션 없이)

```sql
-- 김철수 계좌에서 100,000원 출금
UPDATE accounts SET balance = balance - 100000 
WHERE account_id = 1001;  
-- ✅ 성공!

-- 여기서 갑자기 시스템이 다운됨! 😱
-- 서버 먹통, 데이터베이스 연결 끊김, 전기 끊김 등...

-- 이영희 계좌에 100,000원 입금 (실행 안 됨)
UPDATE accounts SET balance = balance + 100000 
WHERE account_id = 1002;  
-- ❌ 실행되지 않음
```

**결과가 어떻게 되는가?**

- 🔴 김철수 계좌: 100,000원 차감됨 ✅ (완료됨)
- 🔴 이영희 계좌: 그대로 (입금 안 됨) ❌
- 💥 결과: 100,000원이 사라짐! (매우 큰 문제!)

**은행은 망함** 😞

#### ✅ 해결책 (트랜잭션 사용)

```sql
-- 트랜잭션 시작
START TRANSACTION;

  -- 김철수 계좌에서 출금
  UPDATE accounts SET balance = balance - 100000 
  WHERE account_id = 1001;
  
  -- 이영희 계좌에 입금
  UPDATE accounts SET balance = balance + 100000 
  WHERE account_id = 1002;

-- 둘 다 성공했으면 확정
COMMIT;

-- 또는 문제가 있으면 모두 취소
ROLLBACK;
```

**결과:**

- ✅ 두 업데이트가 모두 성공: COMMIT → 두 변경사항이 모두 저장됨
- ❌ 어느 하나라도 실패: ROLLBACK → 두 변경사항이 모두 취소됨
- 🚫 중간 상태는 절대 발생하지 않음!

**은행이 안전함** 😊

### 트랜잭션의 특징

- **All or Nothing**: 모두 성공하거나 모두 실패함
- **중간 상태 방지**: 불완전한 상태가 절대 저장되지 않음
- **데이터 일관성 보장**: 언제나 데이터는 유효한 상태를 유지
- **안전성**: 문제가 발생하면 이전 상태로 돌려놓을 수 있음

---

## 9.5 ACID 특성

트랜잭션의 안전성을 보장하는 네 가지 핵심 특성입니다.

### A - Atomicity (원자성)

**정의:** "All or Nothing" - 트랜잭션의 모든 작업이 완전히 수행되거나 완전히 취소됨

#### 문제 상황

```sql
START TRANSACTION;
  UPDATE accounts SET balance = balance - 100000 WHERE id = 1001;  -- ✅ 성공
  UPDATE accounts SET balance = balance + 100000 WHERE id = 1002;  -- ❌ 실패!

COMMIT;  -- 첫 번째만 저장되고 두 번째는 안 됨 → 데이터 불일치!
```

#### 해결책

데이터베이스가 자동으로 처리:

- ❌ 어느 하나라도 실패 → ROLLBACK (모두 취소)
- ✅ 모두 성공 → COMMIT (모두 저장)

### 왜 중요한가?

원자성이 없으면:

- 돈이 한 계좌에서는 빠지지만 다른 계좌에 들어오지 않음
- 재고가 1개 감소하지만 판매 기록이 남지 않음
- 혼란스러운 불완전한 데이터 상태 발생

---

### C - Consistency (일관성)

**정의:** 트랜잭션 전후로 데이터베이스가 유효한 상태를 유지함. 쉽게 말해, 데이터베이스의 물리 법칙(규칙)이 트랜잭션 전후로 깨지지 않아야 한다는 뜻

#### 예시

```
은행 규칙: 모든 계좌 잔액의 합 = 은행 준비금
```

```sql
START TRANSACTION;
  UPDATE accounts SET balance = balance - 100000 WHERE id = 1001;  -- -100,000
  UPDATE accounts SET balance = balance + 100000 WHERE id = 1002;  -- +100,000
COMMIT;

-- 결과: 총 잔액은 변하지 않음! ✅ 일관성 유지됨
```



### 왜 중요한가?

- 부서가 없는데 직원이 그 부서로 배정될 수 없음
- 음수 금액이나 불가능한 값이 저장될 수 없음
- 데이터가 항상 타당한 상태를 유지

---

### I - Isolation (격리성)

**정의:** 동시에 여러 트랜잭션이 수행될 때, 각 트랜잭션이 서로 방해하지 못하도록 격리하는 성질


### 왜 중요한가?

만약 고립성이 보장되지 않는다면 다음과 같은 사고가 발생할 수 있다.

- 이중 출금: 잔액이 10만원인데 동시에 두 곳에서 10만원씩 출금되어 잔액이 마이너스가 되는 상황.   
- 데이터 증발: 두 명이 동시에 게시글 수정 버튼을 눌렀을 때, 나중에 저장한 사람의 내용만 남고 앞사람의 작업은 사라지는 상황.


#### 해결책 (격리성으로 보호)

```
세션 A                          세션 B
─────────────────────────────────────────────
START TRANSACTION;
  SELECT balance;  -- 1,000,000 (잠금 시작)
  [A의 트랜잭션 동안 이 행을 다른 세션이 볼 수 없음]
                                START TRANSACTION;
                                  SELECT balance;  -- 대기 중... 🔄
                                  -- A의 트랜잭션이 끝날 때까지 기다림
  UPDATE accounts 
  SET balance = 900,000;
  COMMIT;  -- 잠금 해제
                                  -- 이제 비로소 데이터를 읽을 수 있음
                                  SELECT balance;  -- 900,000
                                  UPDATE accounts 
                                  SET balance = 800,000;
                                  COMMIT;

결과: 안전함! ✅
```

---

### D - Durability (지속성)

**정의:** 성공적으로 완료(Commit)된 트랜잭션의 결과는 시스템에 오류가 발생하더라도 영구적으로 보존되어야 한다는 성질

#### 예시

```sql
START TRANSACTION;
  INSERT INTO employees VALUES (10, 'New Employee', 1, 3500000);
COMMIT;  -- 데이터가 이제 영구적으로 저장됨 ✅

-- 이 순간:
-- - 서버가 재부팅됨
-- - 정전이 발생함
-- - 디스크가 깨짐
-- → 데이터는 여전히 안전함!
```

### 저장 보장 방식

```
메모리 (휘발성)
    ↓
    ↓ COMMIT 시
    ↓
디스크 (비휘발성) ← 영구 저장됨!
```

### 왜 중요한가?

- COMMIT한 데이터는 절대 손실되지 않음
- 시스템 장애로부터 보호됨
- 업무 연속성 보장
  
  쉽게 말해, 은행에서 송금을 완료했는데 갑자기 은행 서버의 전원이 꺼지더라도, 다시 켰을 때 내 돈이 사라지지 않고 제대로 송금된 상태로 남아있어야 한다는 뜻
---

## 9.6 COMMIT과 ROLLBACK

### COMMIT

**역할:** 트랜잭션의 모든 변경사항을 영구적으로 저장

```sql
START TRANSACTION;
  UPDATE employees SET salary = 5000000 WHERE employee_id = 1;
  -- 이 시점에서는 나 자신의 세션에서만 변경사항을 볼 수 있음
  
COMMIT;  -- 이제 모든 사람이 변경사항을 볼 수 있음
```

### ROLLBACK

**역할:** 트랜잭션의 모든 변경사항을 취소하고 이전 상태로 복원

```sql
START TRANSACTION;
  INSERT INTO employees VALUES (10, 'New Employee', 1, 3500000);
  -- 새 직원이 추가됨 (임시)
  
  -- 문제 발견! 잘못된 정보다!
  
ROLLBACK;  -- 삽입이 취소됨, 직원이 생성되지 않음
```

### 실제 사용 사례

```sql
-- 케이스 1: 성공적인 트랜잭션
START TRANSACTION;
  UPDATE employees SET salary = 5500000 WHERE employee_id = 1;
  UPDATE employees SET dept_id = 2 WHERE employee_id = 1;
COMMIT;  -- 두 변경사항이 모두 저장됨 ✅

-- 케이스 2: 오류가 발생한 트랜잭션
START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('New Employee', 99, 3500000);
  -- 오류! dept_id 99는 존재하지 않음
  
  -- 다른 방법으로 시도
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('New Employee', 1, 3500000);
  -- 이번엔 성공!
  
COMMIT;  -- 두 번째 삽입만 저장됨
```

---

## 9.7 SAVEPOINT (부분 롤백)

**용도:** 트랜잭션 내에서 특정 지점까지만 롤백할 수 있음

### 문제 상황 (SAVEPOINT 없이)

```sql
START TRANSACTION;
  INSERT INTO employees VALUES (10, 'Employee1', 1, 3000000);  -- ✅ 성공
  INSERT INTO employees VALUES (11, 'Employee2', 1, 3500000);  -- ✅ 성공
  INSERT INTO employees VALUES (12, 'Employee3', 99, 3700000); -- ❌ 오류!

ROLLBACK;  -- 모두 취소됨 (처음 두 개도!)
-- 하지만 처음 두 개는 지키고 싶었는데...
```

### 해결책 (SAVEPOINT 사용)

```sql
START TRANSACTION;
  INSERT INTO employees VALUES (10, 'Employee1', 1, 3000000);  -- ✅ 성공
  INSERT INTO employees VALUES (11, 'Employee2', 1, 3500000);  -- ✅ 성공
  
  SAVEPOINT sp1;  -- 이 지점을 표시해둠
  
  INSERT INTO employees VALUES (12, 'Employee3', 99, 3700000); -- ❌ 오류!
  
  -- sp1까지만 롤백 (처음 두 개는 유지)
  ROLLBACK TO sp1;
  
  -- 이제 올바른 데이터로 다시 시도
  INSERT INTO employees VALUES (12, 'Employee3', 1, 3700000);  -- ✅ 성공!
  
COMMIT;  -- 세 명 모두 삽입됨! ✅
```

### 여러 SAVEPOINT 사용

```sql
START TRANSACTION;
  DELETE FROM logs WHERE created_date < '2024-01-01';  -- 로그 삭제
  SAVEPOINT sp1;
  
  UPDATE employees SET salary = salary * 1.1;  -- 급여 인상
  SAVEPOINT sp2;
  
  DELETE FROM old_data WHERE archived = true;  -- 오래된 데이터 삭제
  -- 이 작업에서 문제 발생!
  
  -- sp2로 롤백: 급여 인상은 유지, 데이터 삭제는 취소
  ROLLBACK TO sp2;
  
COMMIT;  -- 로그 삭제와 급여 인상만 저장됨
```

---

## 📚 Part 2: 샘플 데이터

### 필수 테이블 구성

```sql
CREATE DATABASE ch9_dml CHARACTER SET utf8mb4;
USE ch9_dml;

-- employees 테이블
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2)
);

INSERT INTO employees VALUES
(1, '김철수', 1, 5000000),
(2, '이영희', 1, 4000000),
(3, '박민준', 2, 4500000),
(4, '최순신', 2, 3500000),
(5, '강감찬', 3, 4200000);

-- accounts 테이블 (트랜잭션 예시용)
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    account_name VARCHAR(50),
    balance DECIMAL(10, 2)
);
```

---


## 💻 Part 3: 실습 (20개 문제)

### 이 부분에서 배우는 것

이 섹션에서는 INSERT, UPDATE, DELETE를 안전하게 사용하고, 트랜잭션을 통해 데이터 무결성을 보장하는 다양한 기법을 실습합니다.

```sql
-- =====================================================
-- 섹션 1: INSERT (1-3번)
-- =====================================================

-- 1. 기본 INSERT (안전한 방법 - 열 이름 명시)
INSERT INTO employees (name, dept_id, salary)
VALUES ('황수정', 1, 4100000);

-- 2. 대량 INSERT (효율적 - 개별보다 빠름)
INSERT INTO employees (name, dept_id, salary) VALUES
('송준기', 1, 3900000),
('임세준', 2, 4100000),
('박준호', 1, 3700000);

-- 3. 서브쿼리를 이용한 INSERT (데이터 복사)
CREATE TABLE IF NOT EXISTS employee_archive AS 
SELECT * FROM employees LIMIT 0;

INSERT INTO employee_archive
SELECT * FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees WHERE dept_id = 1);

-- =====================================================
-- 섹션 2: UPDATE (4-8번)
-- =====================================================

-- 4. 기본 UPDATE (WHERE 조건 필수!)
UPDATE employees
SET salary = 5200000
WHERE employee_id = 1;

-- 5. 여러 열을 동시에 UPDATE
UPDATE employees
SET salary = 5500000, dept_id = 2
WHERE employee_id = 2;

-- 6. 수식을 사용한 UPDATE (현재값 기반 계산)
UPDATE employees
SET salary = salary * 1.1
WHERE dept_id = 1;

-- 7. CASE를 사용한 조건부 UPDATE (부서별 다른 인상률)
UPDATE employees
SET salary = CASE 
    WHEN dept_id = 1 THEN salary * 1.15
    WHEN dept_id = 2 THEN salary * 1.12
    ELSE salary * 1.10
END;

-- 8. 안전한 UPDATE 절차 (먼저 SELECT로 확인)
-- 단계 1: 확인
SELECT * FROM employees WHERE dept_id = 2;
-- 단계 2: UPDATE 실행
UPDATE employees
SET salary = salary * 1.05
WHERE dept_id = 2;

-- =====================================================
-- 섹션 3: DELETE (9-10번)
-- =====================================================

-- 9. 기본 DELETE (WHERE 조건 필수!)
DELETE FROM employees
WHERE employee_id = 7;

-- 10. 안전한 DELETE 절차 (먼저 SELECT로 확인)
-- 단계 1: 삭제될 데이터 확인
SELECT * FROM employees WHERE salary < 3600000;
-- 단계 2: DELETE 실행
DELETE FROM employees WHERE salary < 3600000;

-- =====================================================
-- 섹션 4: 트랜잭션 기본 (11-13번)
-- =====================================================

-- 11. 간단한 트랜잭션 - COMMIT (모두 저장)
START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('최유정', 1, 4300000);
  UPDATE employees 
  SET salary = salary * 1.05 
  WHERE dept_id = 1;
COMMIT;

-- 12. 트랜잭션 - ROLLBACK (모두 취소)
START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이호진', 2, 4400000);
ROLLBACK;

-- 13. 은행 송금 시뮬레이션 (트랜잭션의 중요성)
INSERT INTO accounts VALUES
(1001, '김철수 계좌', 1000000),
(1002, '이영희 계좌', 500000);

START TRANSACTION;
  UPDATE accounts SET balance = balance - 100000 WHERE account_id = 1001;
  UPDATE accounts SET balance = balance + 100000 WHERE account_id = 1002;
COMMIT;

-- =====================================================
-- 섹션 5: 고급 트랜잭션 및 SAVEPOINT (14-16번)
-- =====================================================

-- 14. SAVEPOINT - 부분 롤백
START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('김나현', 1, 4100000);
  
  SAVEPOINT sp1;
  
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이수호', 2, 4300000);
  
  ROLLBACK TO sp1;
  
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이수호', 1, 4300000);
  
COMMIT;

-- 15. 데이터 검증 후 INSERT
INSERT INTO employees (name, dept_id, salary)
SELECT '신입직원', 1, 4100000
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE name = '신입직원');

-- 16. INSERT IGNORE (중복 무시)
INSERT IGNORE INTO employees (employee_id, name, dept_id, salary)
VALUES (1, '김철수', 1, 5000000);

-- =====================================================
-- 섹션 6: 실무 활용 (17-20번)
-- =====================================================

-- 17. 데이터 마이그레이션 (트랜잭션으로 보호)
START TRANSACTION;
  INSERT INTO employee_archive 
  SELECT * FROM employees WHERE employee_id >= 10;
  
  DELETE FROM employees WHERE employee_id >= 10;
  
COMMIT;

-- 18. 행 잠금 (SELECT FOR UPDATE - 동시성 제어)
START TRANSACTION;
  SELECT * FROM employees WHERE employee_id = 1 FOR UPDATE;
  UPDATE employees SET salary = 5500000 WHERE employee_id = 1;
COMMIT;

-- 19. 변경 전 검증 (베스트 프랙티스)
SELECT * FROM employees WHERE dept_id = 1 AND salary < 4000000;

START TRANSACTION;
  UPDATE employees 
  SET salary = salary * 1.15
  WHERE dept_id = 1 AND salary < 4000000;
COMMIT;

-- 20. TRUNCATE vs DELETE 비교 (DELETE는 트랜잭션 보호 가능)
START TRANSACTION;
  DELETE FROM employees WHERE dept_id = 4;
COMMIT;
-- TRUNCATE TABLE employees;  -- 모든 행 삭제 (롤백 불가!)
```



---

## 📝 Part 4: 과제 안내

### 이론 과제

**과제 1:** INSERT, UPDATE, DELETE 문을 상세히 설명하세요. 각각이 언제 사용되어야 하는지 설명하고, 실제 사례를 들어주세요.

**과제 2:** 트랜잭션의 개념과 ACID 특성을 상세히 설명하세요. 데이터베이스에서 트랜잭션이 중요한 이유를 은행 송금 예시로 설명하세요.

**과제 3:** COMMIT, ROLLBACK, SAVEPOINT를 상세히 설명하세요. 각각이 언제 사용되며, 어떻게 동작하는지 예시와 함께 설명하세요.

**과제 4:** 트랜잭션 없이 발생할 수 있는 데이터 일관성 문제를 논의하세요. 실제 발생 가능한 상황을 들어 설명하고, 어떻게 해결할 수 있는지 제시하세요.

**과제 5:** 안전한 DML 실습과 위험한 DML 실습을 비교하세요. 데이터 무결성을 보호하기 위한 베스트 프랙티스를 설명하세요.

제출 형식: Word 또는 PDF 문서 (2-3 페이지)

---

### 실무 과제

**과제 1:** INSERT 문의 여러 형태를 실습하세요: 기본 INSERT, 대량 INSERT, 서브쿼리를 이용한 INSERT.

**과제 2:** UPDATE 문의 안전한 사용법을 실습하세요: WHERE 조건 확인, 조건부 UPDATE, CASE를 사용한 UPDATE.

**과제 3:** DELETE 문의 안전한 사용법을 실습하세요: SELECT로 먼저 확인, WHERE 조건 포함, 트랜잭션 사용.

**과제 4:** 트랜잭션 예시를 작성하세요: 성공하는 COMMIT, 실패하는 ROLLBACK, SAVEPOINT를 사용한 부분 롤백.

**과제 5:** Part 3의 모든 실습(9-1 ~ 9-20)을 직접 실행하고 결과 스크린샷을 첨부하세요. 추가로 5개 이상의 비즈니스 시나리오를 만들어 트랜잭션으로 구현하고, 각 시나리오의 목적과 실무 활용 방법을 설명하세요.

제출 형식: SQL 파일(Ch9_DML_Transaction_한글_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
