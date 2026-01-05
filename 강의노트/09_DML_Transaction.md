# 9장: DML(데이터 조작어)과 트랜잭션

---

## 📖 수업 개요

이 장에서는 데이터베이스의 데이터를 조작하는 DML 명령어(INSERT, UPDATE, DELETE)와 데이터 무결성을 보장하는 트랜잭션(Transaction)을 학습합니다. 데이터를 정확하고 안전하게 입력, 수정, 삭제하는 방법과 여러 작업을 하나의 논리적 단위로 처리하여 데이터 일관성을 유지하는 방법을 다룹니다. 실무에서 데이터 무결성 오류를 방지하고 복구할 수 있는 능력을 개발하는 것이 목표입니다.

---

## 📚 Part 1: 이론 학습

### 이 섹션에서 배우는 것

- INSERT 문의 다양한 형태
- UPDATE 문과 조건 처리
- DELETE 문과 데이터 보호
- 트랜잭션의 개념과 ACID 특성
- COMMIT과 ROLLBACK의 역할
- 동시성 제어 및 잠금
- 격리 수준과 트랜잭션 문제

---

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

### JOIN을 사용한 UPDATE

```sql
-- 서울 지역 부서 직원만 급여 인상
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.1
WHERE d.location = 'Seoul';
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

| 특성 | DELETE | TRUNCATE |
|------|--------|----------|
| WHERE 조건 | ✅ 지원 | ❌ 미지원 |
| 롤백 가능 | ✅ 예 (트랜잭션 내) | ❌ 아니오 |
| 속도 | 느림 | 매우 빠름 |
| 사용 시기 | 선택적 삭제 | 모든 행 삭제 |
| 테이블 구조 | 유지 | 유지 |

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

## 9.4 트랜잭션의 개념 (상세 설명)

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

## 9.5 ACID 특성 (상세 설명)

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

**정의:** 트랜잭션 전후로 데이터베이스가 유효한 상태를 유지함

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

#### 제약조건 확인

데이터베이스는 일관성을 위해 모든 제약조건을 확인:

```sql
-- 이 쿼리는 실패함 (일관성 위반)
UPDATE employees SET dept_id = 999 WHERE employee_id = 1;
-- 오류: dept_id 999는 departments 테이블에 없음!
-- (외래키 제약조건 위반)
-- 자동으로 ROLLBACK됨 ❌
```

### 왜 중요한가?

- 부서가 없는데 직원이 그 부서로 배정될 수 없음
- 음수 금액이나 불가능한 값이 저장될 수 없음
- 데이터가 항상 타당한 상태를 유지

---

### I - Isolation (격리성)

**정의:** 동시에 실행되는 여러 트랜잭션이 서로 영향을 주지 않음

#### 문제 상황 (격리성 없이)

```
세션 A (직원 A)                세션 B (직원 B)
─────────────────────────────────────────────
START TRANSACTION;
  SELECT balance;  -- 1,000,000
  balance = balance - 100,000;
                                START TRANSACTION;
                                  SELECT balance;  -- 900,000 (A의 변경사항을 봤다!)
                                  -- 이건 아직 커밋되지 않은 데이터인데?
                                  -- 위험한 상황! 🔴
  UPDATE accounts 
  SET balance = 900000;
  COMMIT;
                                  -- 하지만 B는 이미 900,000을 봤다!
                                  UPDATE accounts 
                                  SET balance = 800000;
                                  COMMIT;

결과: 데이터 불일치! 두 명이 다른 정보로 계산함
```

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

### 왜 중요한가?

- 같은 데이터를 두 명이 다르게 수정하는 문제 방지
- 다른 사람의 미커밋 변경을 볼 수 없음
- 동시에 작업해도 안전함

---

### D - Durability (지속성)

**정의:** COMMIT 후 데이터는 영구적으로 저장되고 손실되지 않음

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

---

## 9.6 COMMIT과 ROLLBACK (상세)

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

## 9.8 격리 수준 (Isolation Level) - 상세 설명

**격리 수준**은 동시에 실행되는 트랜잭션들이 얼마나 서로 영향을 받을지를 결정합니다.

### 동시성 문제의 종류

#### 1. Dirty Read (더티 읽기)

**문제:** 아직 커밋되지 않은 변경사항을 다른 트랜잭션이 읽음

```
세션 A (트랜잭션 1)              세션 B (트랜잭션 2)
─────────────────────────────────────────────────────
START TRANSACTION;
  UPDATE balance = 900;
  (아직 COMMIT 안 함)
                                START TRANSACTION;
                                  SELECT balance;  -- 900 (아직 커밋 안 된 값!)
                                  -- 이것을 Dirty Read라고 함
                                  잔액으로 900을 사용해서 계산함
                                  
  ROLLBACK;  -- 변경을 취소!
  (balance는 다시 1000이 됨)
                                  -- 하지만 B는 이미 900으로 계산해버림!
                                  COMMIT;  -- 틀린 데이터로 커밋됨 ❌
```

#### 2. Non-Repeatable Read (반복 불가능한 읽기)

**문제:** 같은 데이터를 두 번 읽을 때 다른 값이 나옴

```
세션 A                           세션 B
─────────────────────────────────────────────────────
START TRANSACTION;
  SELECT balance;  -- 1000
                                START TRANSACTION;
                                  UPDATE balance = 900;
                                  COMMIT;  -- 커밋됨
  
  SELECT balance;  -- 900 (변경됨!)
  -- 같은 쿼리인데 다른 결과가 나왔다!
  
COMMIT;
```

#### 3. Phantom Read (팬텀 읽기)

**문제:** 새로운 행이 나타나거나 사라짐

```
세션 A                           세션 B
─────────────────────────────────────────────────────
START TRANSACTION;
  SELECT COUNT(*) FROM accounts;  -- 100개
                                START TRANSACTION;
                                  INSERT INTO accounts...;  -- 새 계좌 추가
                                  COMMIT;  -- 커밋됨
  
  SELECT COUNT(*) FROM accounts;  -- 101개!
  -- 팬텀 행이 나타났다!
  
COMMIT;
```

### 4가지 격리 수준

| 수준 | Dirty Read | Non-Repeatable Read | Phantom Read | 성능 |
|------|-----------|-------------------|----------|------|
| **READ UNCOMMITTED** | ✅ 발생 | ✅ 발생 | ✅ 발생 | ⚡⚡⚡ 가장 빠름 |
| **READ COMMITTED** | ❌ 없음 | ✅ 발생 | ✅ 발생 | ⚡⚡ 빠름 |
| **REPEATABLE READ** | ❌ 없음 | ❌ 없음 | ✅ 발생 | ⚡ 느림 |
| **SERIALIZABLE** | ❌ 없음 | ❌ 없음 | ❌ 없음 | 🐌 가장 느림 |

### 각 수준의 특징

#### 1. READ UNCOMMITTED (커밋되지 않은 읽기)

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
```

- ⚠️ 가장 낮은 보호 수준
- ✅ 가장 빠른 성능
- ❌ Dirty Read, Non-repeatable Read, Phantom Read 모두 발생 가능
- 📊 사용: 정확성이 크리티컬하지 않은 통계 조회 등

#### 2. READ COMMITTED (커밋된 데이터만 읽기)

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

- 🛡️ 중간 수준 보호
- ✅ 가장 일반적으로 사용됨 (MySQL 기본값)
- ❌ Dirty Read는 방지하지만 Non-repeatable Read, Phantom Read 발생 가능
- 📊 사용: 대부분의 일반적인 업무

#### 3. REPEATABLE READ (반복 가능한 읽기)

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

- 🛡️🛡️ 높은 수준 보호
- ⚠️ 성능 감소
- ✅ Dirty Read, Non-repeatable Read 방지
- ❌ Phantom Read는 여전히 발생 가능
- 📊 사용: 같은 데이터를 여러 번 읽어야 하는 업무

#### 4. SERIALIZABLE (직렬화)

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

- 🛡️🛡️🛡️ 최고 수준 보호
- 🐌 매우 느린 성능
- ✅ 모든 동시성 문제 방지
- ⚠️ 트랜잭션이 마치 순차적으로 실행되는 것처럼 동작
- 📊 사용: 매우 중요한 금융 거래 등

### 격리 수준 설정

```sql
-- 현재 세션에 대해 설정
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 특정 트랜잭션에만 적용
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
  SELECT * FROM accounts;
COMMIT;

-- 설정 확인
SELECT @@transaction_isolation;
```

---

## 9.9 데드락 (Deadlock) - 상세 설명

**데드락**은 두 개 이상의 트랜잭션이 서로 필요한 리소스를 가지고 있어서 무한 대기 상태가 되는 것입니다.

### 데드락 발생 사례

```
세션 A (트랜잭션 1)              세션 B (트랜잭션 2)
─────────────────────────────────────────────────────
START TRANSACTION;
  SELECT * FROM accounts 
  WHERE id = 1 FOR UPDATE;  -- 계좌 1 잠금 ✅
  
  -- 계좌 2를 업데이트하려고 함
  UPDATE accounts 
  SET balance = balance - 100
  WHERE id = 2;  -- 계좌 2 잠금을 기다리는 중... 🔄
                                START TRANSACTION;
                                  SELECT * FROM accounts 
                                  WHERE id = 2 FOR UPDATE;  -- 계좌 2 잠금 ✅
                                  
                                  -- 계좌 1을 업데이트하려고 함
                                  UPDATE accounts 
                                  SET balance = balance + 100
                                  WHERE id = 1;  -- 계좌 1 잠금을 기다리는 중... 🔄

💥 데드락 발생!
- A는 B가 가진 계좌 2의 잠금을 기다림
- B는 A가 가진 계좌 1의 잠금을 기다림
- 둘 다 영원히 기다릴 수밖에 없음!
```

### MySQL의 데드락 감지

```sql
-- 데드락이 감지되면 MySQL이 자동으로 처리:
-- 1. 한 트랜잭션 선택 (보통 더 적은 행을 변경한 것)
-- 2. 그 트랜잭션 자동 ROLLBACK
-- 3. 오류 1213 반환: "Deadlock found when trying to get lock"
-- 4. 다른 트랜잭션 계속 실행

-- 결과:
-- ❌ 한 트랜잭션: 오류와 함께 실패
-- ✅ 다른 트랜잭션: 정상 계속
```

### 데드락 예방 전략

#### 1. 리소스 순서 일관성 유지

```sql
-- ❌ 나쁜 예
-- 세션 A
UPDATE accounts WHERE id = 1;
UPDATE accounts WHERE id = 2;

-- 세션 B
UPDATE accounts WHERE id = 2;  -- 다른 순서!
UPDATE accounts WHERE id = 1;  -- 데드락 위험!

-- ✅ 좋은 예
-- 모든 세션이 같은 순서로 접근
-- 세션 A
UPDATE accounts WHERE id = 1;
UPDATE accounts WHERE id = 2;

-- 세션 B
UPDATE accounts WHERE id = 1;  -- 같은 순서!
UPDATE accounts WHERE id = 2;
```

#### 2. 트랜잭션을 짧게 유지

```sql
-- ❌ 나쁜 예 (긴 트랜잭션)
START TRANSACTION;
  -- 많은 쿼리 실행
  UPDATE accounts SET...;
  INSERT INTO logs...;
  DELETE FROM old_data...;
  -- 30초 동안 잠금 유지
COMMIT;

-- ✅ 좋은 예 (짧은 트랜잭션)
START TRANSACTION;
  UPDATE accounts SET...;  -- 빠르게 실행
COMMIT;  -- 빨리 잠금 해제
```

#### 3. 트랜잭션 고립 수준 조정

```sql
-- 필요 이상으로 높은 격리 수준 사용하지 않기
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- READ COMMITTED로 충분한 경우가 많음
```

#### 4. 테이블 잠금 대신 행 잠금 사용

```sql
-- ❌ 나쁜 예 (전체 테이블 잠금)
LOCK TABLES accounts WRITE;
UPDATE accounts SET...;
UNLOCK TABLES;

-- ✅ 좋은 예 (특정 행만 잠금)
START TRANSACTION;
  SELECT * FROM accounts WHERE id = 1 FOR UPDATE;  -- 행 잠금
  UPDATE accounts SET... WHERE id = 1;
COMMIT;
```

---

## 📚 Part 2: 샘플 데이터

### employees 테이블

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    salary DECIMAL(10, 2)
);

INSERT INTO employees VALUES
(1, '김철수', 1, 5000000),
(2, '이영희', 1, 4000000),
(3, '박민준', 2, 4500000),
(4, '최순신', 2, 3500000);
```

### departments 테이블

```sql
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL
);

INSERT INTO departments VALUES
(1, '영업부'),
(2, '기술부');
```

---

## 💻 Part 3: 실습

### 이 섹션에서 배우는 것

- INSERT의 다양한 기법
- 안전한 UPDATE 실습
- 안전한 DELETE 실습
- 트랜잭션 구현
- 오류 처리 및 복구
- 실무 기반 시나리오

```sql
-- =====================================================
-- Part 3: DML과 트랜잭션 실습
-- =====================================================

-- =====================================================
-- 9-1. 기본 INSERT
-- =====================================================
-- 새로운 직원 정보를 지정된 열에만 삽입
-- 열 이름을 명시하는 것이 안전한 이유: 테이블 구조가 변경되어도 영향 없음

INSERT INTO employees (name, dept_id, salary)
VALUES ('황수정', 1, 4100000);

-- =====================================================
-- 9-2. INSERT - 열 이름 지정 (권장)
-- =====================================================
-- 항상 이 방법을 사용하세요!

INSERT INTO employees (name, dept_id, salary)
VALUES ('금선민', 2, 4300000);

-- =====================================================
-- 9-3. 대량 INSERT (효율적)
-- =====================================================
-- 여러 행을 한 번에 삽입하면 개별 INSERT보다 훨씬 빠름!
-- 네트워크 트래픽도 줄어들고, 트랜잭션으로도 처리됨

INSERT INTO employees (name, dept_id, salary) VALUES
('송준기', 1, 3900000),
('임세준', 2, 4100000),
('박준호', 1, 3700000);

-- =====================================================
-- 9-4. 서브쿼리를 이용한 INSERT (데이터 복사)
-- =====================================================
-- 한 테이블의 데이터를 다른 테이블로 복사
-- 용도: 백업, 아카이브, 데이터 마이그레이션

CREATE TABLE IF NOT EXISTS employee_archive AS 
SELECT * FROM employees LIMIT 0;

INSERT INTO employee_archive
SELECT * FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees WHERE dept_id = 1);

-- =====================================================
-- 9-5. INSERT with DEFAULT
-- =====================================================
-- 기본값이 설정된 열은 DEFAULT 키워드 사용 가능

INSERT INTO employees (name, dept_id, salary)
VALUES ('이소영', 1, 4200000);

-- =====================================================
-- 9-6. 기본 UPDATE
-- =====================================================
-- ⚠️ 매우 중요: WHERE 조건을 반드시 포함하세요!
-- WHERE 없으면 모든 행이 수정됨!

UPDATE employees
SET salary = 5200000
WHERE employee_id = 1;

-- =====================================================
-- 9-7. 여러 열을 동시에 UPDATE
-- =====================================================
-- 쉼표로 구분하여 여러 열을 한 번에 수정

UPDATE employees
SET salary = 5500000, dept_id = 2
WHERE employee_id = 2;

-- =====================================================
-- 9-8. 수식을 사용한 UPDATE
-- =====================================================
-- 현재 값을 기반으로 계산하여 수정
-- 예: 급여의 10% 인상

UPDATE employees
SET salary = salary * 1.1;

-- =====================================================
-- 9-9. CASE를 사용한 조건부 UPDATE
-- =====================================================
-- 부서별로 다른 인상률 적용
-- 복잡한 비즈니스 로직을 한 쿼리로 처리

UPDATE employees
SET salary = CASE 
    WHEN dept_id = 1 THEN salary * 1.15  -- 영업부: 15% 인상
    WHEN dept_id = 2 THEN salary * 1.12  -- 기술부: 12% 인상
    ELSE salary * 1.10  -- 다른 부서: 10% 인상
END;

-- =====================================================
-- 9-10. 안전한 UPDATE 절차
-- =====================================================
-- 최고의 실습: 먼저 SELECT로 확인 후 UPDATE 실행

-- 단계 1: 먼저 무엇이 수정될지 확인
SELECT * FROM employees WHERE dept_id = 2;

-- 단계 2: 결과가 맞으면 UPDATE 실행
UPDATE employees
SET salary = salary * 1.05
WHERE dept_id = 2;

-- =====================================================
-- 9-11. 기본 DELETE
-- =====================================================
-- ⚠️ 치명적 경고: WHERE 조건을 반드시 포함하세요!
-- WHERE 없으면 모든 행이 영구 삭제됨!

DELETE FROM employees
WHERE employee_id = 7;

-- =====================================================
-- 9-12. 조건을 포함한 DELETE
-- =====================================================
-- 특정 조건에 맞는 여러 행을 한 번에 삭제

DELETE FROM employees
WHERE salary < 3500000;

-- =====================================================
-- 9-13. 안전한 DELETE 절차
-- =====================================================
-- 최고의 실습: 먼저 SELECT로 확인 후 DELETE 실행

-- 단계 1: 삭제될 데이터를 먼저 확인
SELECT * FROM employees WHERE salary < 3600000;

-- 단계 2: 결과가 맞으면 DELETE 실행
DELETE FROM employees WHERE salary < 3600000;

-- =====================================================
-- 9-14. 간단한 트랜잭션 - COMMIT
-- =====================================================
-- 트랜잭션: 여러 작업을 하나의 논리적 단위로 처리
-- COMMIT: 모든 변경을 저장

START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('최유정', 1, 4300000);
  UPDATE employees 
  SET salary = salary * 1.05 
  WHERE dept_id = 1;
COMMIT;  -- 두 작업 모두 저장됨

-- =====================================================
-- 9-15. 트랜잭션 - ROLLBACK
-- =====================================================
-- ROLLBACK: 트랜잭션 내의 모든 작업 취소
-- 문제가 발생했을 때 이전 상태로 복구

START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이호진', 2, 4400000);
ROLLBACK;  -- 삽입 취소, 직원이 생성되지 않음

-- =====================================================
-- 9-16. 은행 송금 시뮬레이션
-- =====================================================
-- 실제 은행 업무처럼: 한 계좌에서 출금하고 다른 계좌에 입금
-- All or Nothing 보장!

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    account_name VARCHAR(50),
    balance DECIMAL(10, 2)
);

INSERT INTO accounts VALUES
(1001, '김철수 계좌', 1000000),
(1002, '이영희 계좌', 500000);

START TRANSACTION;
  -- 김철수 계좌에서 100,000 출금
  UPDATE accounts 
  SET balance = balance - 100000 
  WHERE account_id = 1001;
  
  -- 이영희 계좌에 100,000 입금
  UPDATE accounts 
  SET balance = balance + 100000 
  WHERE account_id = 1002;
  
COMMIT;  -- 둘 다 성공하면 저장
-- 또는 문제가 있으면
-- ROLLBACK;  -- 둘 다 취소

-- =====================================================
-- 9-17. SAVEPOINT - 부분 롤백
-- =====================================================
-- SAVEPOINT: 트랜잭션 내의 특정 지점을 표시
-- ROLLBACK TO: 그 지점까지만 되돌림

START TRANSACTION;
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('김나현', 1, 4100000);
  
  SAVEPOINT sp1;  -- 이 지점 표시
  
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이수호', 2, 4300000);
  -- 이 작업이 문제가 있다고 가정
  
  ROLLBACK TO sp1;  -- sp1까지만 롤백 (첫 번째 삽입은 유지)
  
  -- 올바른 데이터로 다시 삽입
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('이수호', 1, 4300000);
  
COMMIT;  -- 올바른 두 명의 직원이 삽입됨

-- =====================================================
-- 9-18. 여러 SAVEPOINT 사용
-- =====================================================
-- 복잡한 트랜잭션에서 여러 체크포인트 생성

START TRANSACTION;
  DELETE FROM employees WHERE salary < 3000000;
  SAVEPOINT sp1;
  
  UPDATE employees SET salary = salary * 1.1;
  SAVEPOINT sp2;
  
  DELETE FROM employees WHERE dept_id = 3;
  -- 이 작업에서 오류 발생 시
  
  -- sp2로 롤백: 급여 인상은 유지, 부서3 삭제는 취소
  ROLLBACK TO sp2;
  
COMMIT;

-- =====================================================
-- 9-19. 복잡한 트랜잭션
-- =====================================================
-- INSERT, UPDATE, DELETE를 모두 포함한 트랜잭션
-- 이들이 모두 성공하거나 모두 실패함

START TRANSACTION;
  -- 새 직원 추가
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('신입직원', 1, 3500000);
  
  -- 부서 변경
  UPDATE employees 
  SET dept_id = 2 
  WHERE employee_id IN (2, 3);
  
  -- 연봉 낮은 직원 제거
  DELETE FROM employees WHERE salary < 3000000;
  
COMMIT;  -- 모두 함께 저장

-- =====================================================
-- 9-20. 자동 커밋(AUTOCOMMIT) 제어
-- =====================================================
-- 기본적으로 각 쿼리는 자동 커밋됨
-- 여러 쿼리를 함께 처리하려면 자동 커밋 비활성화

SET AUTOCOMMIT = 0;  -- 자동 커밋 비활성화
UPDATE employees SET salary = 5000000 WHERE employee_id = 1;
UPDATE employees SET salary = 4500000 WHERE employee_id = 2;
COMMIT;  -- 이제 명시적으로 커밋해야 함
SET AUTOCOMMIT = 1;  -- 자동 커밋 다시 활성화

-- =====================================================
-- 9-21. 격리 수준 설정
-- =====================================================
-- 격리 수준: 트랜잭션 간 영향 정도 결정

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
  SELECT * FROM employees WHERE dept_id = 1;
  -- 다른 트랜잭션의 커밋된 변경만 볼 수 있음
COMMIT;

-- =====================================================
-- 9-22. 데이터 검증 후 INSERT
-- =====================================================
-- INSERT 전에 데이터 무결성 확인

INSERT INTO employees (name, dept_id, salary)
SELECT '신입직원', 1, 4100000
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE name = '신입직원');
-- 이미 존재하면 삽입하지 않음

-- =====================================================
-- 9-23. INSERT IGNORE (중복 무시)
-- =====================================================
-- 중복 키 오류 무시하고 계속 진행

INSERT IGNORE INTO employees (employee_id, name, dept_id, salary)
VALUES (1, '김철수', 1, 5000000);  -- 이미 있으므로 무시됨

-- =====================================================
-- 9-24. 데이터 마이그레이션
-- =====================================================
-- 데이터를 한 테이블에서 다른 테이블로 이전 (트랜잭션으로 보호)

START TRANSACTION;
  -- 아카이브 테이블로 복사
  INSERT INTO employee_archive 
  SELECT * FROM employees WHERE employee_id >= 10;
  
  -- 원본에서 삭제
  DELETE FROM employees WHERE employee_id >= 10;
  
COMMIT;  -- 둘 다 성공하거나 둘 다 실패

-- =====================================================
-- 9-25. 배치 UPDATE (대량 수정)
-- =====================================================
-- 여러 행을 다른 조건으로 한 번에 수정

START TRANSACTION;
  UPDATE employees
  SET salary = CASE 
      WHEN employee_id IN (1, 2, 3) THEN salary * 1.1
      WHEN employee_id IN (4, 5, 6) THEN salary * 1.05
      ELSE salary
  END;
COMMIT;

-- =====================================================
-- 9-26. 행 잠금 (Row Locking)
-- =====================================================
-- SELECT FOR UPDATE: 특정 행을 잠금
-- 다른 세션이 이 행을 수정할 수 없음

START TRANSACTION;
  -- 이 행을 잠금
  SELECT * FROM employees WHERE employee_id = 1 FOR UPDATE;
  
  -- 다른 세션은 이 행의 수정을 기다려야 함
  UPDATE employees SET salary = 5500000 WHERE employee_id = 1;
  
COMMIT;  -- 잠금 해제

-- =====================================================
-- 9-27. 변경 전 검증
-- =====================================================
-- 최고의 실습: 변경 전에 항상 SELECT로 확인

-- 단계 1: 영업부 직원 확인
SELECT * FROM employees WHERE dept_id = 1 AND salary < 4000000;

-- 단계 2: 결과가 맞으면 UPDATE
START TRANSACTION;
  UPDATE employees 
  SET salary = salary * 1.15
  WHERE dept_id = 1 AND salary < 4000000;
COMMIT;

-- =====================================================
-- 9-28. 감사 추적 (Audit Trail)
-- =====================================================
-- 변경 사항을 기록하여 나중에 추적 가능하게 함

CREATE TABLE IF NOT EXISTS employee_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(10),
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP
);

START TRANSACTION;
  -- 급여 변경
  UPDATE employees SET salary = 5200000 WHERE employee_id = 1;
  
  -- 변경 기록
  INSERT INTO employee_audit 
  VALUES (NULL, 'UPDATE', 1, 5000000, 5200000, NOW());
  
COMMIT;

-- =====================================================
-- 9-29. 트랜잭션 오류 처리
-- =====================================================
-- 외래키 제약조건 위반을 처리하는 방법

START TRANSACTION;
  -- 이 쿼리는 실패함 (dept_id 99는 없음)
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('테스트', 99, 4000000);
  -- 외래키 제약 위반!
  
  -- 올바른 부서로 다시 시도
  INSERT INTO employees (name, dept_id, salary) 
  VALUES ('테스트', 1, 4000000);
  -- 이번엔 성공!
  
COMMIT;

-- =====================================================
-- 9-30. TRUNCATE vs DELETE 비교
-- =====================================================
-- TRUNCATE: 모든 행을 매우 빠르게 삭제 (롤백 불가)
-- DELETE: 조건에 맞는 행 삭제 (롤백 가능)

-- DELETE (트랜잭션으로 보호 가능)
START TRANSACTION;
DELETE FROM employees WHERE dept_id = 4;
COMMIT;  -- 또는 ROLLBACK

-- TRUNCATE (매우 빠르지만 롤백 불가)
-- TRUNCATE TABLE employees;  -- 모든 행 삭제 (되돌릴 수 없음!)
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

**과제 5:** Part 3의 모든 실습(9-1 ~ 9-30)을 직접 실행하고 결과 스크린샷을 첨부하세요. 추가로 5개 이상의 비즈니스 시나리오를 만들어 트랜잭션으로 구현하고, 각 시나리오의 목적과 실무 활용 방법을 설명하세요.

제출 형식: SQL 파일(Ch9_DML_Transaction_한글_[학번].sql) 및 결과 스크린샷

---

감사합니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
