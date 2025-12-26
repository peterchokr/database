# Ch10 뷰와 저장프로시저 - 연습문제

학생 여러분! 10장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

10장을 마친 후 다음을 이해해야 합니다:
- 뷰(View)의 개념과 생성
- 뷰의 활용과 장단점
- 뷰 수정과 삭제
- 저장프로시저의 개념과 문법
- 저장프로시저의 매개변수 (IN, OUT, INOUT)
- 저장프로시저의 실행과 관리

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** 뷰(View)의 가장 중요한 특징은?
- ① 실제 데이터를 저장함
- ② 가상 테이블로 실제 데이터를 저장하지 않음
- ③ 테이블보다 항상 빠름
- ④ 원본 테이블을 변경함

---

**2번** 뷰를 생성하는 기본 문법은?
- ① CREATE TABLE view_name AS SELECT ...;
- ② CREATE VIEW view_name AS SELECT ...;
- ③ CREATE VIEW view_name FROM SELECT ...;
- ④ MAKE VIEW view_name AS SELECT ...;

---

**3번** 저장프로시저(Stored Procedure)의 정의로 옳은 것은?
- ① 데이터베이스에 저장되는 재사용 가능한 SQL 루틴
- ② 한 번만 실행되는 SQL 문
- ③ 조건문을 포함할 수 없는 쿼리
- ④ 클라이언트 애플리케이션에서만 실행됨

---

**4번** 저장프로시저의 IN 매개변수의 역할은?
- ① 입력값만 받음
- ② 출력값만 반환함
- ③ 입력과 출력 모두 가능
- ④ 매개변수 없이 실행

---

**5번** 저장프로시저를 실행하는 방법은?
- ① SELECT procedure_name;
- ② RUN procedure_name;
- ③ CALL procedure_name(parameters);
- ④ EXECUTE procedure_name;

---

## 중급 수준 (3개) - 개념 적용

**6번** 수정 가능한 뷰(Updatable View)의 조건으로 옳지 않은 것은?

- ① 단일 테이블 기반
- ② GROUP BY 포함 가능
- ③ JOIN 미포함
- ④ DISTINCT 미포함

---

**7번** 저장프로시저의 OUT 매개변수 사용 예는?

```sql
① CREATE PROCEDURE GetCount (IN dept_id INT)
② CREATE PROCEDURE GetCount (OUT count INT)
③ CREATE PROCEDURE GetCount (INOUT salary DECIMAL)
```

- ① 입력 전용
- ② 출력 전용 (이 경우 OUT 사용)
- ③ 입출력 겸용
- ④ ①과 ② 모두 가능

---

**8번** 뷰를 삭제하는 올바른 문법은?

- ① DELETE VIEW view_name;
- ② DROP VIEW view_name;
- ③ REMOVE VIEW view_name;
- ④ DROP TABLE view_name;

---

## 고급 수준 (2개) - 비판적 사고

**9번** 뷰를 사용하는 가장 중요한 이유는?

- ① 항상 성능이 더 좋음
- ② 데이터 보안과 추상화 제공
- ③ 저장 공간 절약
- ④ 모든 연산에서 UPDATE 가능

---

**10번** 저장프로시저와 뷰의 가장 큰 차이는?

- ① 뷰는 조회만, 프로시저는 로직 구현
- ② 프로시저는 조회만, 뷰는 데이터 수정
- ③ 둘 다 같은 기능
- ④ 뷰는 빠르고 프로시저는 느림

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** 뷰(View)의 정의와 뷰가 필요한 이유를 설명하시오.

---

**12번** 뷰의 주요 활용 사례 3가지를 설명하시오.

---

**13번** 저장프로시저의 정의와 매개변수 IN, OUT, INOUT의 차이를 설명하시오.

---

## 중급 수준 (1개)

**14번** 수정 가능한 뷰(Updatable View)의 조건을 설명하고, 수정 불가능한 뷰의 예를 제시하시오.

---

## 고급 수준 (1개)

**15번** 뷰와 저장프로시저의 차이와 각각의 장단점을 비교 분석하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch10_view_procedure CHARACTER SET utf8mb4;
USE ch10_view_procedure;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    dept_id INT,
    salary INT,
    hire_date DATE
);

INSERT INTO employees VALUES
(1, '김철수', 1, 5000000, '2020-01-15'),
(2, '이영희', 1, 4000000, '2020-06-20'),
(3, '박민준', 2, 4500000, '2019-03-10');

SELECT * FROM employees;
```

제출: employees 테이블에 3명 데이터가 모두 보이는 스크린샷

---

**17번** employees 테이블을 기반으로 뷰를 생성하고 조회하시오.

```sql
-- 1. 단순 뷰 생성: 직원의 이름과 급여만 조회
CREATE VIEW employee_salary_view AS
SELECT name, salary FROM employees;

SELECT * FROM employee_salary_view;

-- 2. 조건부 뷰: 급여 4000000 이상인 직원만
CREATE VIEW high_salary_view AS
SELECT name, salary FROM employees WHERE salary >= 4000000;

SELECT * FROM high_salary_view;
```

제출: 2개 뷰의 조회 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** 뷰를 이용한 집계와 수정을 수행하시오.

```sql
-- 1. 집계 뷰: 부서별 직원 수와 평균 급여
CREATE VIEW dept_summary_view AS
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;

SELECT * FROM dept_summary_view;

-- 2. 뷰를 통한 UPDATE (수정 가능한 뷰)
CREATE VIEW emp_update_view AS
SELECT employee_id, name, salary FROM employees;

UPDATE emp_update_view SET salary = 5500000 WHERE employee_id = 1;
SELECT * FROM emp_update_view;
```

제출: 집계 뷰와 UPDATE 후 결과 스크린샷

---

**19번** 저장프로시저를 생성하고 실행하시오.

```sql
-- 1. 입력 매개변수 (IN) 프로시저
CREATE PROCEDURE GetEmployeeInfo (IN emp_id INT)
BEGIN
  SELECT name, salary FROM employees WHERE employee_id = emp_id;
END;

CALL GetEmployeeInfo(1);

-- 2. 출력 매개변수 (OUT) 프로시저
CREATE PROCEDURE GetEmployeeCount (OUT count INT)
BEGIN
  SELECT COUNT(*) INTO count FROM employees;
END;

CALL GetEmployeeCount(@emp_count);
SELECT @emp_count AS employee_count;

-- 3. 조건문이 포함된 프로시저
CREATE PROCEDURE CheckSalary (IN emp_id INT)
BEGIN
  DECLARE emp_salary INT;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary > 4500000 THEN
    SELECT CONCAT('High salary: ', emp_salary);
  ELSE
    SELECT CONCAT('Regular salary: ', emp_salary);
  END IF;
END;

CALL CheckSalary(1);
```

제출: 3개 프로시저의 실행 결과 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복잡한 저장프로시저를 작성하고 실행하시오.

```
요구사항:
1. 급여 인상 프로시저
   - 부서별로 급여를 일정 비율 인상
   - 상한선 초과 시 상한선으로 설정
   - 결과 반환 (입력/출력 매개변수 활용)

2. 복합 로직 프로시저
   - IF-ELSEIF-ELSE 구문으로 급여 등급 판정
   - 등급별 처리 (A: 보너스 계산, B: 일반, C: 승진 대기 등)

3. 데이터 검증 프로시저
   - 입력된 직원 ID 존재 여부 확인
   - 존재하면 정보 반환, 미존재하면 오류 메시지

4. WHILE 반복을 사용한 프로시저
   - 여러 직원의 급여를 일괄 계산/업데이트
   - 반복문으로 각 직원 처리

제출:
   - 각 프로시저의 SQL 코드
   - 각 프로시저의 실행 결과 스크린샷
   - 실행 전후 데이터 비교
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설 |
|:---:|:---:|:---|
| 1번 | ② | 뷰는 가상 테이블로 실제 데이터 저장 안 함 |
| 2번 | ② | CREATE VIEW로 뷰 생성 |
| 3번 | ① | 저장프로시저는 DB에 저장되는 SQL 루틴 |
| 4번 | ① | IN은 입력 매개변수만 |
| 5번 | ③ | CALL로 프로시저 실행 |
| 6번 | ② | GROUP BY 포함 시 수정 불가 |
| 7번 | ② | OUT은 출력 전용 매개변수 |
| 8번 | ② | DROP VIEW로 뷰 삭제 |
| 9번 | ② | 뷰의 주요 목적은 보안과 추상화 |
| 10번 | ① | 뷰는 조회, 프로시저는 로직 구현 |

---

## 주관식 모범 답안 (5개)

### 11번 뷰의 정의와 필요성

**모범 답안**:
```
정의:
- 하나 이상의 테이블을 기반으로 하는 가상 테이블
- 실제 데이터를 저장하지 않음 (논리적 추상화)
- SELECT 쿼리로 정의됨

필요성:
1. 복잡한 쿼리 단순화
   - 복잡한 JOIN과 GROUP BY를 뷰로 캡슐화
   - 사용자는 단순한 SELECT로 조회

2. 데이터 보안
   - 특정 열만 노출 (급여 정보 제외 등)
   - 민감한 데이터 접근 제어

3. 데이터 추상화
   - 원본 테이블 구조 변경 시 뷰로 호환성 유지
   - 사용자 쿼리 수정 최소화
```

---

### 12번 뷰의 활용 사례

**모범 답안**:
```
1. 복잡한 쿼리 단순화
   CREATE VIEW sales_summary AS
   SELECT p.name, COUNT(*) AS cnt, SUM(s.qty) AS total
   FROM products p
   JOIN sales s ON p.id = s.prod_id
   GROUP BY p.id;
   
   사용자는 SELECT * FROM sales_summary;

2. 데이터 보안
   CREATE VIEW emp_public AS
   SELECT emp_id, name, dept_id FROM employees;
   -- 급여, 주민등록번호 등 제외

3. 데이터 추상화
   CREATE VIEW active_employees AS
   SELECT * FROM employees WHERE termination_date IS NULL;
   -- 퇴직자 자동 제외
```

---

### 13번 저장프로시저와 매개변수

**모범 답안**:
```
정의:
- DB에 저장되는 재사용 가능한 SQL 루틴
- 조건문, 반복문 등 프로그래밍 로직 포함
- CALL로 실행

매개변수:

1. IN (입력 매개변수)
   - 프로시저에 값 전달
   - 읽기만 가능
   CREATE PROCEDURE get_emp (IN emp_id INT)

2. OUT (출력 매개변수)
   - 프로시저에서 결과 반환
   - 쓰기만 가능
   CREATE PROCEDURE count_emp (OUT cnt INT)
   SELECT COUNT(*) INTO cnt FROM employees;
   
   호출: CALL count_emp(@c); SELECT @c;

3. INOUT (입출력 매개변수)
   - 입력받아서 처리 후 반환
   - 읽고 쓰기 가능
   CREATE PROCEDURE adjust_salary (INOUT sal DECIMAL)
   SET sal = sal * 1.1;
```

---

### 14번 수정 가능한 뷰

**모범 답안**:
```
수정 가능한 뷰 조건:
1. 단일 테이블 기반
2. GROUP BY 미포함
3. DISTINCT 미포함
4. JOIN 미포함
5. HAVING 미포함
6. LIMIT 미포함
7. 서브쿼리 미포함

수정 가능한 뷰:
CREATE VIEW emp_update AS
SELECT emp_id, name, salary FROM employees;

UPDATE emp_update SET salary = 5000000 WHERE emp_id = 1;

수정 불가능한 뷰:
CREATE VIEW dept_summary AS
SELECT dept_id, COUNT(*) AS cnt, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id;
-- GROUP BY, AVG 때문에 수정 불가

CREATE VIEW high_salary AS
SELECT DISTINCT name FROM employees WHERE salary > 4000000;
-- DISTINCT 때문에 수정 불가
```

---

### 15번 뷰와 저장프로시저 비교

**모범 답안**:
```
차이점:

뷰 (View):
- SELECT 기반의 가상 테이블
- 데이터 조회만 가능 (대부분)
- 논리적 추상화 목적
- 매개변수 없음
- 복잡한 쿼리 단순화

저장프로시저:
- SQL 루틴으로 로직 구현
- 조회, 수정, 삭제, 제어 모두 가능
- 비즈니스 로직 자동화 목적
- 매개변수 지원 (IN, OUT, INOUT)
- 반복문, 조건문 사용

장점:

뷰:
✅ 쿼리 간단화
✅ 보안 제공
✅ 유지보수 용이
❌ 성능: 매번 계산

프로시저:
✅ 복잡한 로직 구현
✅ 성능: 미리 컴파일
✅ 재사용성
❌ 관리 복잡
```

---

## 실습형 모범 답안 (5개)

### 16번 employees 생성

**완료 기준**:
✅ ch10_view_procedure 데이터베이스 생성
✅ employees 테이블 생성
✅ 3명 데이터 입력

---

### 17번 기본 뷰

**완료 기준**:
✅ employee_salary_view: 이름과 급여만 조회
✅ high_salary_view: 급여 4000000 이상

**예상 결과**:
```
employee_salary_view:
이영희, 4000000
김철수, 5000000
박민준, 4500000

high_salary_view:
김철수, 5000000
이영희, 4000000
박민준, 4500000
```

---

### 18번 집계 뷰와 수정

**완료 기준**:
✅ dept_summary_view: 부서별 통계
✅ UPDATE를 통한 뷰 수정
✅ 수정 후 데이터 확인

---

### 19번 저장프로시저

**완료 기준**:
✅ IN 프로시저: 특정 직원 정보 조회
✅ OUT 프로시저: 직원 수 반환
✅ 조건문 프로시저: 급여 등급 판정

---

### 20번 복잡한 프로시저

**모범 답안**:

```sql
-- 1. 급여 인상 프로시저
CREATE PROCEDURE RaiseSalary (IN emp_id INT, IN raise_rate DECIMAL, OUT new_salary INT)
BEGIN
  DECLARE max_salary INT DEFAULT 6000000;
  DECLARE current_sal INT;
  
  SELECT salary INTO current_sal FROM employees WHERE employee_id = emp_id;
  SET new_salary = ROUND(current_sal * (1 + raise_rate/100));
  
  IF new_salary > max_salary THEN
    SET new_salary = max_salary;
  END IF;
  
  UPDATE employees SET salary = new_salary WHERE employee_id = emp_id;
END;

CALL RaiseSalary(1, 10, @new_sal);
SELECT @new_sal;

-- 2. 급여 등급 프로시저
CREATE PROCEDURE AssignSalaryGrade (IN emp_id INT, OUT grade CHAR)
BEGIN
  DECLARE emp_salary INT;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary >= 5000000 THEN
    SET grade = 'A';
  ELSEIF emp_salary >= 4500000 THEN
    SET grade = 'B';
  ELSEIF emp_salary >= 4000000 THEN
    SET grade = 'C';
  ELSE
    SET grade = 'D';
  END IF;
END;

CALL AssignSalaryGrade(1, @g);
SELECT @g;

-- 3. 데이터 검증 프로시저
CREATE PROCEDURE ValidateEmployee (IN emp_id INT, OUT result VARCHAR(100))
BEGIN
  DECLARE emp_exists INT;
  SELECT COUNT(*) INTO emp_exists FROM employees WHERE employee_id = emp_id;
  
  IF emp_exists > 0 THEN
    SELECT CONCAT('직원 존재: ', name) INTO result FROM employees WHERE employee_id = emp_id;
  ELSE
    SET result = '직원 미존재';
  END IF;
END;

CALL ValidateEmployee(1, @result);
SELECT @result;
```

---

조정현 교수 (peterchokr@gmail.com)
