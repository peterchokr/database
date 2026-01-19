# 부록 2: 정보처리산업기사 시험 준비 (DB 파트)

## 📚 개요

정보처리산업기사 필기시험의 데이터베이스 부분을 완벽하게 준비하기 위한 학습 자료입니다.

---

## 📖 Part 1: 시험 출제 범위

### 시험 구성
- 총 100문제, 100점 만점
- 데이터베이스: 약 15-20문제 출제
- 문제 유형: 객관식 4지선다형

### 주요 출제 영역

```
1. 데이터베이스 개념 (20%)
   - 정의, 특성, 장점
   - DBMS의 역할과 기능
   - 데이터 무결성

2. 데이터모델 (20%)
   - 개념적 데이터모델 (ER)
   - 논리적 데이터모델 (관계형)
   - 물리적 데이터모델

3. 정규화 (20%)
   - 이상 현상
   - 함수 종속성
   - 1NF ~ BCNF

4. SQL (25%)
   - DDL (CREATE, ALTER, DROP)
   - DML (INSERT, UPDATE, DELETE, SELECT)
   - DCL (GRANT, REVOKE)
   - 고급 쿼리 (JOIN, 서브쿼리, 그룹화)

5. 데이터베이스 관리 (15%)
   - 트랜잭션
   - 동시성 제어
   - 복구 및 보안
```

---

## 📖 Part 2: 핵심 개념 정리

### 2.1 데이터베이스 기본 개념

**데이터베이스의 특성**
```
1. 통합성 (Integration): 중복 최소화
2. 공유성 (Sharing): 여러 사용자가 공유
3. 보안성 (Security): 권한 제어
4. 독립성 (Independence): 물리적/논리적 독립
5. 무결성 (Integrity): 데이터 정확성
```

**DBMS의 주요 기능**
```
1. 정의 기능 (DDL): 데이터 구조 정의
2. 조작 기능 (DML): 데이터 삽입, 조회, 수정, 삭제
3. 제어 기능 (DCL): 권한 관리
4. 백업 및 복구
5. 동시성 제어
6. 성능 최적화
```

### 2.2 ER 모델 (개념적 모델)

**기본 요소**
```
엔티티 (Entity)
- 현실 세계의 구분되는 객체
- 예: 학생, 강의, 교수

속성 (Attribute)
- 엔티티의 특성
- 예: 학번, 이름, 학과

관계 (Relationship)
- 엔티티 간의 연관
- 예: "학생은 강의를 수강한다"
```

**카디널리티**
```
1:1 (일대일): 학생 - 학번
1:N (일대다): 교수 - 강의
M:N (다대다): 학생 - 강의 (수강)
```

### 2.3 관계형 데이터모델 (논리적 모델)

**기본 용어**
```
릴레이션 = 테이블
속성 = 열 (Column)
투플 = 행 (Row)
카디널리티 = 행의 개수
차수 = 열의 개수
```

**키의 종류**
```
기본키 (Primary Key)
- 릴레이션을 유일하게 식별
- NOT NULL, UNIQUE
- 예: 학번

후보키 (Candidate Key)
- 기본키가 될 수 있는 속성
- 예: 주민등록번호, 여권번호

외래키 (Foreign Key)
- 다른 릴레이션의 기본키 참조
- 참조 무결성 보장

슈퍼키 (Superkey)
- 튜플을 유일하게 식별하는 속성의 조합
- 예: (학번 + 이름), (학번)
```

### 2.4 정규화 핵심 정리

**이상 현상 (Anomaly)**
```
삽입 이상 (Insertion): 새 데이터 삽입 시 불필요한 데이터도 입력
수정 이상 (Update): 같은 정보를 여러 곳에서 수정해야 함
삭제 이상 (Deletion): 필요한 데이터 삭제 시 원치 않는 정보까지 삭제
```

**함수 종속성 (Functional Dependency)**
```
X → Y: X가 결정되면 Y도 유일하게 결정됨

유형:
- 완전 함수 종속: Y가 X 전체에 종속
- 부분 함수 종속: Y가 X의 일부에만 종속
- 이행 함수 종속: X→Y, Y→Z이면 X→Z
```

**정규형 진행**
```
비정규형 → 1NF → 2NF → 3NF → BCNF

1NF: 모든 속성이 원자값
     ❌ (전화번호: 010-1234, 02-5678)
     ✅ (전화번호1: 010-1234, 전화번호2: 02-5678)

2NF: 1NF + 부분 함수 종속 제거
     ❌ 수강(학번, 강의번호, 강의명, 성적)
        → 강의명은 강의번호에만 종속
     ✅ 수강(학번, 강의번호, 성적)
        강의(강의번호, 강의명)

3NF: 2NF + 이행 함수 종속 제거
     ❌ 학생(학번, 학과, 학과장)
        → 학과장은 학과에 종속
     ✅ 학생(학번, 학과)
        학과(학과, 학과장)

BCNF: 모든 함수 종속에서 좌측이 슈퍼키
```

---

## 📖 Part 3: SQL 핵심 정리

### 3.1 DDL (Data Definition Language)

**CREATE TABLE**
```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT REFERENCES departments(dept_id)
);
```

**주요 제약조건**
```
PRIMARY KEY: 기본키
UNIQUE: 유일값
NOT NULL: 필수값
DEFAULT: 기본값
CHECK: 범위/조건 검증
FOREIGN KEY: 외래키
```

**ALTER TABLE**
```sql
-- 열 추가
ALTER TABLE employees ADD COLUMN hire_date DATE;

-- 열 수정
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2);

-- 열 삭제
ALTER TABLE employees DROP COLUMN hire_date;
```

### 3.2 DML (Data Manipulation Language)

**INSERT**
```sql
INSERT INTO employees VALUES (1, '김철수', 5000000, 1);
INSERT INTO employees (emp_id, name) VALUES (2, '이영희');
```

**UPDATE**
```sql
UPDATE employees SET salary = 5500000 WHERE emp_id = 1;
UPDATE employees SET salary = salary * 1.1;  -- 모두 10% 인상
```

**DELETE**
```sql
DELETE FROM employees WHERE emp_id = 1;
DELETE FROM employees WHERE salary < 3000000;
```

**SELECT**
```sql
-- 기본
SELECT * FROM employees;
SELECT emp_id, name, salary FROM employees;

-- WHERE 절
SELECT * FROM employees WHERE dept_id = 1;
SELECT * FROM employees WHERE salary >= 4000000 AND dept_id = 1;

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC;

-- LIMIT/OFFSET
SELECT * FROM employees LIMIT 10;
SELECT * FROM employees LIMIT 10 OFFSET 5;
```

### 3.3 GROUP BY와 집계함수

**집계함수**
```sql
SELECT COUNT(*) FROM employees;           -- 행 개수
SELECT SUM(salary) FROM employees;        -- 합계
SELECT AVG(salary) FROM employees;        -- 평균
SELECT MAX(salary), MIN(salary) FROM employees;
```

**GROUP BY**
```sql
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;
```

**HAVING (GROUP BY 필터)**
```sql
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 4000000;
```

### 3.4 JOIN

**INNER JOIN**
```sql
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

**LEFT JOIN**
```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

**여러 테이블 JOIN**
```sql
SELECT e.name, d.dept_name, p.project_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN projects p ON e.emp_id = p.emp_id;
```

### 3.5 서브쿼리

**WHERE 절 서브쿼리**
```sql
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Seoul');
```

**FROM 절 서브쿼리**
```sql
SELECT dept_id, avg_salary
FROM (SELECT dept_id, AVG(salary) AS avg_salary FROM employees GROUP BY dept_id)
WHERE avg_salary > 4000000;
```

**SELECT 절 서브쿼리**
```sql
SELECT name, salary, 
       (SELECT COUNT(*) FROM employees) AS total_emp
FROM employees;
```

### 3.6 DCL (Data Control Language)

**GRANT (권한 부여)**
```sql
GRANT SELECT ON employees TO user1;
GRANT INSERT, UPDATE, DELETE ON employees TO user2;
GRANT ALL PRIVILEGES ON company TO admin;
```

**REVOKE (권한 회수)**
```sql
REVOKE SELECT ON employees FROM user1;
```

---

## 📖 Part 4: 트랜잭션과 동시성 제어

### 4.1 트랜잭션 성질 (ACID)

```
Atomicity (원자성)
- 모두 성공 또는 모두 실패
- 부분 성공 불가능

Consistency (일관성)
- 트랜잭션 전후 데이터 정합성 유지

Isolation (고립성)
- 동시 실행 트랜잭션 간 간섭 없음

Durability (지속성)
- 커밋된 데이터는 영구 보존
```

### 4.2 트랜잭션 제어

```sql
BEGIN TRANSACTION;  -- 트랜잭션 시작

UPDATE accounts SET balance = balance - 100000 WHERE acc_id = 1;
UPDATE accounts SET balance = balance + 100000 WHERE acc_id = 2;

COMMIT;     -- 변경사항 저장
-- ROLLBACK;  -- 변경사항 취소
```

### 4.3 동시성 제어

**잠금 (Lock)**
```
공유 잠금 (S-Lock): 읽기 전용
배타 잠금 (X-Lock): 읽기/쓰기 가능
```

**트랜잭션 격리 수준**
```
1. Dirty Read: 커밋되지 않은 데이터 읽음 (위험)
2. Non-repeatable Read: 같은 데이터를 여러 번 읽으면 다름
3. Phantom Read: 새로운 행이 나타남
4. Serializable: 완전 격리 (성능 저하)
```

---

## 📖 Part 5: 자주 출제되는 문제 유형

### 5.1 ER 다이어그램 해석

```
문제: 다음 ER 다이어그램에서 카디널리티가 M:N인 관계는?
답: 학생-강의 관계
   → 한 학생은 여러 강의를 수강하고,
   → 한 강의는 여러 학생을 수강
   → 수강 테이블(Junction Table)로 구현
```

### 5.2 정규화 문제

```
문제: 다음 테이블이 어느 정규형인가?
학생(학번, 이름, 학과, 학과위치)
- 학과위치는 학과에만 종속 (이행 함수 종속)
답: 2NF
해결: 학생(학번, 이름, 학과)
     학과(학과, 학과위치)로 분리하면 3NF
```

### 5.3 SQL 쿼리 해석

```
문제: SELECT dept_id, MAX(salary)
      FROM employees
      GROUP BY dept_id
      HAVING COUNT(*) >= 3;
      
의미: 3명 이상의 직원이 있는 부서의 최고 급여
```

### 5.4 트랜잭션 문제

```
문제: A계좌에서 B계좌로 10만원 이체 중
     이체 직후 시스템 중단 발생
결과: ACID 특성에 의해 자동 ROLLBACK
     원자성(Atomicity)이 보장됨
```

---

## 📝 Part 6: 시험 대비 문제

### 객관식 20문제

**1번** 다음 중 데이터베이스의 특성이 아닌 것은?
① 통합성 ② 공유성 ③ 보안성 ④ 강제성

**답: ④** (보안성, 통합성, 공유성, 무결성이 특성)

---

**2번** ER 다이어그램에서 엔티티 간 관계로 옳지 않은 것은?
① 1:1 ② 1:N ③ M:N ④ N:N

**답: ④** (카디널리티는 1:1, 1:N, M:N만 가능)

---

**3번** 함수 종속성 X→Y에서 X를 무엇이라고 하는가?
① 결정자(Determinant) ② 종속자 ③ 함수 ④ 관계자

**답: ①** (X가 Y를 결정하므로 X는 결정자)

---

**4번** 다음 중 부분 함수 종속을 제거하는 정규화 단계는?
① 1NF → 2NF ② 2NF → 3NF ③ 3NF → BCNF ④ 데이터 무결성

**답: ①** (2NF의 정의가 부분 함수 종속 제거)

---

**5번** 다음 릴레이션에서 기본키가 될 수 있는 것은?
학생(학번, 주민등록번호, 이름, 학과)
① 학번, 주민등록번호 ② 이름 ③ 학과 ④ 학번, 이름

**답: ①** (학번과 주민등록번호는 후보키 중 하나를 기본키로 선택)

---

**6번** SELECT name, COUNT(*) FROM employees GROUP BY name
이 쿼리의 결과는?
① 각 직원의 이름과 개수 ② 직원 총 수 ③ 같은 이름의 직원 수 ④ 모든 직원 나열

**답: ③** (같은 이름을 가진 직원들이 몇 명인지 표시)

---

**7번** HAVING 절의 역할은?
① 행 필터링 ② 그룹 필터링 ③ 열 선택 ④ 정렬

**답: ②** (WHERE는 행, HAVING은 GROUP BY 결과 필터링)

---

**8번** 외래키의 주요 기능은?
① 유일성 보장 ② 참조 무결성 보장 ③ NOT NULL 강제 ④ 자동 증가

**답: ②** (외래키는 다른 테이블의 기본키를 참조하여 무결성 보장)

---

**9번** 트랜잭션의 원자성(Atomicity)이란?
① 모두 성공하거나 모두 실패
② 데이터 정합성 유지
③ 동시 실행 격리
④ 영구 보존

**답: ①** (모두 실행되거나 모두 취소되는 특성)

---

**10번** 서브쿼리가 여러 행을 반환할 때 사용하는 연산자는?
① = ② > ③ IN ④ EXISTS

**답: ③** (IN은 목록의 값과 비교, EXISTS도 가능)

---

**11번** 정규화의 목표가 아닌 것은?
① 이상 현상 제거 ② 중복 최소화 ③ 성능 최대화 ④ 무결성 보장

**답: ③** (정규화는 성능 저하 가능, 필요시 비정규화)

---

**12번** LEFT JOIN과 INNER JOIN의 차이는?
① LEFT는 모든 행, INNER는 일치하는 행만
② 속도 차이
③ 사용 범위 차이
④ 다른 문법

**답: ①** (LEFT JOIN은 좌측 모든 행 포함, INNER는 일치만)

---

**13번** CREATE TABLE 문에서 PRIMARY KEY 제약조건의 특성은?
① NULL 허용 ② 중복 허용 ③ NULL, 중복 모두 불허 ④ 선택적

**답: ③** (PRIMARY KEY는 NOT NULL + UNIQUE)

---

**14번** 다음 쿼리의 결과 개수는?
SELECT * FROM employees WHERE salary > 4000000
① 1개 ② 여러 개 ③ 지정 불가 ④ 항상 NULL

**답: ③** (데이터에 따라 결과 개수가 달라짐)

---

**15번** 동시성 제어에서 보안 잠금(X-Lock)의 특징은?
① 읽기만 가능 ② 읽기/쓰기 가능 ③ 공유 가능 ④ 자동 해제

**답: ②** (배타 잠금은 읽기/쓰기 모두 가능, 다른 트랜잭션 대기)

---

**16번** 데이터 무결성의 종류 중 참조 무결성은?
① 도메인 무결성 ② 외래키 제약 ③ 기본키 고유성 ④ NOT NULL

**답: ②** (외래키로 참조 무결성 보장)

---

**17번** COMMIT 명령어의 역할은?
① 변경사항 저장 ② 변경사항 취소 ③ 트랜잭션 시작 ④ 데이터 검증

**답: ①** (COMMIT으로 변경사항 영구 저장)

---

**18번** 다음 중 데이터 중복이 없으면서 성능이 좋은 상태는?
① 비정규형 ② 1NF ③ 3NF ④ 필요시 비정규화

**답: ④** (정규화로 무결성, 필요시 비정규화로 성능)

---

**19번** 뷰(View)의 주요 목적은?
① 저장 공간 절약 ② 논리적 추상화 ③ 성능 향상 ④ 자동 계산

**답: ②** (뷰는 데이터 보안과 추상화)

---

**20번** 트리거의 실행 시점으로 옳은 것은?
① BEFORE INSERT (작업 전) ② AFTER INSERT (작업 후) ③ ①, ② 모두 ④ 사용자 선택

**답: ③** (BEFORE와 AFTER 모두 가능)

---

## 📚 Part 7: 시험 팁

### 시험 전 체크리스트

```
□ ER 다이어그램 해석 (카디널리티, 엔티티, 관계)
□ 정규화 과정 (1NF ~ BCNF)
□ SQL 문법 (DDL, DML, DCL)
□ JOIN 종류 (INNER, LEFT, RIGHT, FULL)
□ 트랜잭션과 ACID
□ 동시성 제어와 잠금
□ 데이터 무결성 (기본, 참조, 도메인)
□ 함수 종속성 (완전, 부분, 이행)
□ 복습 문제 풀기 (최소 3회)
```

### 자주 틀리는 부분

```
❌ 정규화와 성능 혼동
   → 정규화 = 무결성, 성능 저하 가능
   → 필요시 비정규화로 성능 개선

❌ LEFT JOIN과 INNER JOIN 구분 안 됨
   → LEFT: 좌측 모든 행 포함
   → INNER: 일치하는 행만

❌ 카디널리티 1:1과 1:N 혼동
   → 1:1 = 일대일 (학생-학번)
   → 1:N = 일대다 (교수-강의)

❌ GROUP BY와 집계함수 사용 오류
   → SELECT에 집계함수 아닌 열이 있으면
   → 반드시 GROUP BY에 포함해야 함
```

---

## 📚 Part 8: 실전 모의고사

### 시나리오 기반 문제

**[상황]**
회사 데이터베이스 설계

employees (직원)
├── emp_id (기본키)
├── name
├── salary
└── dept_id (외래키)

departments (부서)
├── dept_id (기본키)
├── dept_name
└── location

projects (프로젝트)
├── proj_id (기본키)
├── proj_name
└── dept_id (외래키)

**Q1.** 부서별 직원 수와 평균 급여를 구하되, 직원 수가 3명 이상인 부서만 표시하는 쿼리는?

```sql
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING COUNT(*) >= 3
ORDER BY emp_count DESC;
```

**Q2.** 특정 부서의 모든 직원과 그들이 담당하는 프로젝트를 함께 표시하되, 프로젝트가 없는 직원도 표시하는 쿼리는?

```sql
SELECT e.name, p.proj_name
FROM employees e
LEFT JOIN projects p ON e.dept_id = p.dept_id
WHERE e.dept_id = 1
ORDER BY e.name;
```

**Q3.** 회사 평균 급여보다 높은 급여를 받는 직원을 부서명과 함께 표시하는 쿼리는?

```sql
SELECT e.name, e.salary, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > (SELECT AVG(salary) FROM employees)
ORDER BY e.salary DESC;
```

---

## 최종 학습 권장 순서

```
1주차: 데이터베이스 개념 + ER 모델 + 정규화
2주차: SQL 기본 (DDL, DML) + 연습
3주차: SQL 고급 (JOIN, 서브쿼리) + 연습
4주차: 트랜잭션, 동시성 제어 + 종합 문제
5주차: 기출 문제 풀이 + 오답 정리
```

---

조정현 교수 (peterchokr@gmail.com)
