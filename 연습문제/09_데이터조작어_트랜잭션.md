# Ch9 DML과 트랜잭션 - 연습문제

학생 여러분! 9장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

9장을 마친 후 다음을 이해해야 합니다:

- DML(Data Manipulation Language) 개념
- INSERT, UPDATE, DELETE 명령어
- 트랜잭션(Transaction)의 개념
- COMMIT, ROLLBACK, SAVEPOINT
- 데이터 일관성과 무결성
- 트랜잭션 격리 수준

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** DML의 정의로 옳은 것은?

- ① 데이터베이스 구조를 정의하는 언어 (CREATE, ALTER)
- ② 데이터를 입력, 수정, 삭제하는 언어 (INSERT, UPDATE, DELETE)
- ③ 데이터를 조회하는 언어 (SELECT)
- ④ 사용자 권한을 관리하는 언어

---

**2번** INSERT 문법에서 열을 명시하지 않으면?

- ① 오류 발생
- ② 모든 열의 값을 순서대로 입력해야 함
- ③ NULL이 입력됨
- ④ 선택적으로 입력 가능

---

**3번** UPDATE에서 WHERE 절이 없으면?

- ① 오류 발생
- ② 해당 열의 모든 행이 수정됨
- ③ 아무것도 수정되지 않음
- ④ 마지막 행만 수정됨

---

**4번** 트랜잭션(Transaction)의 기본 특징은?

- ① 데이터베이스 조회만 가능
- ② 여러 SQL을 하나의 작업 단위로 취급
- ③ 항상 성공해야 함
- ④ 되돌릴 수 없음

---

**5번** COMMIT의 역할은?

- ① 작업 취소
- ② 작업 저장 (트랜잭션 종료)
- ③ 특정 지점으로 되돌림
- ④ 트랜잭션 시작

---

## 중급 수준 (3개) - 개념 적용

**6번** INSERT, UPDATE, DELETE 중 올바른 문법은?

```sql
① INSERT INTO employees (name, salary) VALUES ('김철수', 5000000);

② UPDATE employees SET salary = 6000000 WHERE name = '이영희';

③ DELETE FROM employees WHERE employee_id > 10;
```

- ① 올바름
- ② 올바름
- ③ 올바름
- ④ ①②③ 모두 올바름

---

**7번** ROLLBACK이 필요한 상황은?

- ① 모든 변경사항을 저장할 때
- ② 트랜잭션 중 오류 발생 시 모든 변경 취소
- ③ 특정 명령어만 되돌릴 때
- ④ 데이터베이스를 초기화할 때

---

**8번** SAVEPOINT의 용도는?

- ① 트랜잭션 시작 지점 설정
- ② 트랜잭션 중간에 저장 지점 설정하여 필요시 되돌리기
- ③ 데이터베이스 백업 생성
- ④ 여러 사용자 접근 제어

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 상황에서 트랜잭션이 필수인 이유는?

"은행 계좌 송금: A 계좌에서 100만원 출금 → B 계좌에 100만원 입금"

- ① 출금만 성공하고 입금 실패 시 돈 손실 방지
- ② 두 작업이 모두 성공하거나 모두 실패해야 함 (원자성)
- ③ 송금 기록을 저장하기 위해
- ④ ①과 ②

---

**10번** 데이터 일관성을 보장하기 위한 제약조건은?

- ① 트랜잭션만으로 충분
- ② 제약조건(PRIMARY KEY, FOREIGN KEY, CHECK 등)과 트랜잭션 함께 필요
- ③ 제약조건만으로 충분
- ④ 로그 파일 사용

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** INSERT, UPDATE, DELETE 명령어의 차이를 설명하시오.

---

**12번** 트랜잭션의 정의와 필요성을 설명하고, 실무에서 트랜잭션이 필요한 사례를 3가지 이상 제시하시오.

---

**13번** COMMIT과 ROLLBACK의 차이를 설명하고, 각각 사용하는 상황을 예시하시오.

---

## 중급 수준 (1개)

**14번** SAVEPOINT의 개념을 설명하고, 복잡한 트랜잭션에서 SAVEPOINT를 사용하는 방법을 설명하시오.

---

## 고급 수준 (1개)

**15번** 데이터베이스의 ACID 특성을 설명하고, 각각이 트랜잭션 관리에서 어떤 역할을 하는지 설명하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch9_dml CHARACTER SET utf8mb4;
USE ch9_dml;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    position VARCHAR(20),
    salary INT,
    hire_date DATE
);

-- 초기 데이터 입력
INSERT INTO employees VALUES
(1, '김철수', '과장', 5000000, '2020-01-15'),
(2, '이영희', '대리', 4000000, '2021-03-20'),
(3, '박민준', '사원', 3500000, '2022-06-10');

SELECT * FROM employees;
```

제출: employees 테이블에 초기 데이터가 모두 입력된 스크린샷 1장

---

**17번** 다음을 수행하고 결과를 확인하시오.

```sql
-- 1. INSERT: 새 직원 추가
INSERT INTO employees VALUES
(4, '최순신', '사원', 3200000, '2023-09-01');

SELECT * FROM employees;

-- 2. UPDATE: 급여 인상
UPDATE employees SET salary = 5500000 WHERE name = '김철수';

SELECT * FROM employees WHERE name = '김철수';

-- 3. DELETE: 직원 삭제
DELETE FROM employees WHERE employee_id = 3;

SELECT * FROM employees;
```

제출: 각 단계의 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** 트랜잭션을 사용하여 다음을 수행하시오.

```sql
-- 트랜잭션 시작
START TRANSACTION;

-- 1. 여러 직원 추가
INSERT INTO employees VALUES
(5, '강감찬', '대리', 4300000, '2023-01-15');

INSERT INTO employees VALUES
(6, '이순신', '사원', 3400000, '2023-02-20');

-- 2. 급여 일괄 인상 (5% 증가)
UPDATE employees SET salary = ROUND(salary * 1.05) WHERE position = '사원';

-- 3. 데이터 확인
SELECT * FROM employees;

-- 트랜잭션 커밋
COMMIT;

-- 최종 결과 확인
SELECT * FROM employees;
```

제출: 트랜잭션 실행 결과 스크린샷

---

**19번** ROLLBACK을 사용한 트랜잭션을 수행하시오.

```sql
-- 트랜잭션 1: 정상 커밋
START TRANSACTION;
UPDATE employees SET salary = 6000000 WHERE employee_id = 1;
COMMIT;

-- 트랜잭션 2: 오류로 인한 ROLLBACK
START TRANSACTION;
UPDATE employees SET salary = 7000000 WHERE employee_id = 1;
INSERT INTO employees VALUES (7, '장보고', '과장', 5500000, '2023-03-10');
-- (오류 발생으로 가정) ROLLBACK으로 되돌림
ROLLBACK;

-- 결과 확인: employee_id 1은 6000000, 직원 7은 없음
SELECT * FROM employees;
```

제출: 트랜잭션 ROLLBACK 결과 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복잡한 트랜잭션을 작성하고 실행하시오.

```
요구사항:
1. 조직 개편 트랜잭션
   - 신규 부서 추가
   - 직원 배치 변경
   - 급여 조정
   - 실패 시 전체 취소

2. SAVEPOINT를 사용한 부분 되돌리기
   - 여러 개의 SAVEPOINT 설정
   - 특정 작업만 되돌리기
   - 나머지는 유지

3. 성공/실패 시나리오 테스트
   - 정상 처리: COMMIT
   - 오류 처리: ROLLBACK
   - 부분 처리: SAVEPOINT + ROLLBACK

4. 데이터 무결성 검증
   - 트랜잭션 전후 데이터 일관성 확인
   - 제약조건 위반 시 자동 취소 확인

제출:
   - 각 트랜잭션의 SQL 코드
   - 각 단계의 실행 결과 스크린샷
   - 트랜잭션 전후 데이터 비교
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                              |
| :--: | :--: | :------------------------------------------------ |
| 1번 |  ②  | DML은 INSERT, UPDATE, DELETE (데이터 변조)        |
| 2번 |  ②  | 열을 명시하지 않으면 모든 열의 값을 순서대로 입력 |
| 3번 |  ②  | WHERE 없으면 모든 행 수정 (주의 필요!)            |
| 4번 |  ②  | 트랜잭션은 여러 SQL을 하나의 작업 단위로          |
| 5번 |  ②  | COMMIT은 작업 저장 (트랜잭션 종료)                |
| 6번 |  ④  | ①②③ 모두 올바른 문법                           |
| 7번 |  ②  | ROLLBACK은 오류 시 모든 변경 취소                 |
| 8번 |  ②  | SAVEPOINT로 중간 저장점 설정하여 부분 되돌리기    |
| 9번 |  ④  | ①②가 모두 맞음 (트랜잭션 필요성)                |
| 10번 |  ②  | 제약조건과 트랜잭션 함께 필요                     |

---

## 주관식 모범 답안 (5개)

### 11번 INSERT, UPDATE, DELETE의 차이

**모범 답안**:

```
INSERT (삽입):
- 새로운 행 추가
- 문법: INSERT INTO table (cols) VALUES (vals);
- 예: 신입 직원 추가

UPDATE (수정):
- 기존 행의 데이터 변경
- 문법: UPDATE table SET col = val WHERE condition;
- 예: 직원 급여 인상

DELETE (삭제):
- 행 삭제
- 문법: DELETE FROM table WHERE condition;
- 예: 퇴직 직원 삭제

주의:
- UPDATE, DELETE는 WHERE 필수 (전체 영향 방지)
- 백업 후 실행 권장
```

---

### 12번 트랜잭션의 정의와 필요성

**모범 답안**:

```
정의:
- 논리적인 작업 단위
- 여러 SQL을 하나로 취급
- 모두 성공하거나 모두 실패 (원자성)

필요성:
- 데이터 일관성 보장
- 부분 성공으로 인한 데이터 무결성 깨짐 방지

실무 사례:

1. 은행 송금
   출금(A) → 입금(B)
   둘 다 성공하거나 모두 취소

2. 주문 처리
   상품 수량 감소 → 주문 생성
   양쪽 모두 적용되거나 모두 취소

3. 인사 기록
   퇴직 처리 → 급여 삭제
   함께 처리되어야 함

4. 재고 관리
   판매 → 재고 감소 → 매출 기록
   3가지 모두 성공해야 의미 있음

5. 계좌 이체
   A 계좌 감액 → B 계좌 증액
   중간 실패 시 원상 복구
```

---

### 13번 COMMIT vs ROLLBACK

**모범 답안**:

```
COMMIT:
- 역할: 트랜잭션 변경사항 저장
- 시점: 작업 완료 후
- 효과: 변경사항 데이터베이스 반영

ROLLBACK:
- 역할: 트랜잭션 변경사항 취소
- 시점: 오류 발생 또는 의도적 취소 시
- 효과: 트랜잭션 시작 전 상태로 복구

사용 상황:

COMMIT 사용:
START TRANSACTION;
INSERT INTO employees ...;
UPDATE employees ...;
-- 모든 작업 성공 확인
COMMIT;

ROLLBACK 사용:
START TRANSACTION;
DELETE FROM employees WHERE ...;
-- 실수로 삭제함을 발견
ROLLBACK;  -- 삭제 취소

데이터 입장:
COMMIT 전: 다른 사용자가 변경 미보임
COMMIT 후: 모든 사용자가 변경 확인
ROLLBACK 후: 변경 없었던 것처럼
```

---

### 14번 SAVEPOINT 사용법

**모범 답안**:

```
개념:
- 트랜잭션 중간에 저장점 설정
- 전체 ROLLBACK 대신 특정 지점으로 되돌리기

문법:
SAVEPOINT savepoint_name;
ROLLBACK TO savepoint_name;

사용 예:
START TRANSACTION;
  INSERT INTO employees VALUES (...);
  SAVEPOINT sp1;  -- 저장점 1
  
  UPDATE employees SET ...;
  SAVEPOINT sp2;  -- 저장점 2
  
  DELETE FROM employees WHERE ...;
  -- DELETE 오류 발생
  ROLLBACK TO sp2;  -- sp2로 되돌림 (UPDATE는 유지)
  
COMMIT;

결과:
- INSERT 유지
- UPDATE 유지
- DELETE 취소

실무 활용:
복잡한 작업을 여러 단계로 나누어
각 단계마다 SAVEPOINT 설정
오류 발생 시 해당 단계만 되돌림
```

---

### 15번 ACID 특성

**모범 답안**:

```
ACID 특성:

1. Atomicity (원자성)
   - 트랜잭션은 전부 성공하거나 전부 실패
   - 부분 성공 없음
   - 역할: 데이터 일관성 보장

2. Consistency (일관성)
   - 트랜잭션 전후로 DB는 일관된 상태 유지
   - 제약조건, 규칙 준수
   - 예: 외래키 무결성 유지

3. Isolation (격리성)
   - 동시에 실행되는 트랜잭션은 영향 없음
   - 각 트랜잭션 독립 실행
   - 격리 수준: READ UNCOMMITTED, READ COMMITTED 등

4. Durability (지속성)
   - COMMIT 후 데이터는 영구 저장
   - 시스템 장애해도 복구 가능
   - 로그 파일로 보장

트랜잭션 관리에서의 역할:

출금 예:
A. 원자성: 출금 전체 또는 없음 (부분 출금 X)
C. 일관성: 잔액이 음수 안 됨
I. 격리성: 다른 출금과 동시 실행해도 무관
D. 지속성: 출금 확정 후 전원 나가도 기록 유지
```

---

## 실습형 모범 답안 (5개)

### 16번 테이블 생성 및 초기 데이터

**완료 기준**:
✅ ch9_dml 데이터베이스 생성
✅ employees 테이블 생성
✅ 3개 직원 초기 데이터 입력

---

### 17번 INSERT, UPDATE, DELETE 실행

**예상 결과**:

```
INSERT 후: 4명 (직원 4 추가)
UPDATE 후: 김철수 급여 5500000
DELETE 후: 3명 (박민준 삭제됨)
```

---

### 18번 COMMIT이 포함된 트랜잭션

**완료 기준**:
✅ 신규 직원 2명 추가
✅ 사원 급여 5% 인상
✅ COMMIT으로 저장
✅ 최종 확인

---

### 19번 ROLLBACK 트랜잭션

**모범 답안**:

```sql
-- 트랜잭션 1: COMMIT
START TRANSACTION;
UPDATE employees SET salary = 6000000 WHERE employee_id = 1;
COMMIT;

-- 트랜잭션 2: ROLLBACK
START TRANSACTION;
UPDATE employees SET salary = 7000000 WHERE employee_id = 1;
INSERT INTO employees VALUES (7, '장보고', '과장', 5500000, '2023-03-10');
-- ROLLBACK으로 되돌림
ROLLBACK;

결과:
- 직원 1: 6000000 (트랜잭션 2의 UPDATE 취소)
- 직원 7: 없음 (INSERT 취소)
```

---

### 20번 복잡한 트랜잭션

**모범 답안**:

```sql
-- 1. 조직 개편 트랜잭션
START TRANSACTION;
  -- 신규 부서 생성 (departments 테이블 예상)
  -- INSERT INTO departments ...;
  
  -- 직원 배치 변경
  UPDATE employees SET position = '대리' WHERE employee_id = 2;
  SAVEPOINT sp1;
  
  -- 급여 조정 (과장급 10% 인상)
  UPDATE employees SET salary = ROUND(salary * 1.1) WHERE position = '과장';
  SAVEPOINT sp2;
  
  -- 신규 직원 추가
  INSERT INTO employees VALUES (8, '이순신', '대리', 4500000, '2023-04-15');
  
COMMIT;

-- 2. SAVEPOINT 사용 예
START TRANSACTION;
  DELETE FROM employees WHERE employee_id = 1;
  SAVEPOINT sp1;
  
  DELETE FROM employees WHERE employee_id = 2;
  -- 여기서 오류 발생 (무결성 위반)
  ROLLBACK TO sp1;  -- sp1로 되돌림
  
  -- 직원 1은 삭제됨, 직원 2는 유지
  
COMMIT;

-- 3. 데이터 무결성 검증
SELECT COUNT(*) FROM employees;  -- 트랜잭션 전후 행 수 비교
SELECT * FROM employees WHERE employee_id = 1;  -- 특정 데이터 확인
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
