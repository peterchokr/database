# Ch11 조건문과 반복문 - 연습문제

학생 여러분! 11장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

11장을 마친 후 다음을 이해해야 합니다:

- IF-THEN-ELSE 문의 구조
- CASE 문 (간단한 형태와 검색 형태)
- WHILE, REPEAT, LOOP 반복문
- 중첩된 제어 구조
- 레이블(Label)과 반복문 제어 (LEAVE, ITERATE)
- 제어 구조의 실무 활용 및 성능 최적화

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** IF-THEN-ELSE 문의 기본 구조로 옳은 것은?

- ① IF condition THEN statement; END;
- ② IF condition THEN statement; ELSE statement; END IF;
- ③ IF (condition) { statement; }
- ④ IF condition BEGIN statement; END;

---

**2번** CASE 문의 간단한 형태(Simple CASE)는?

- ① CASE WHEN condition THEN statement;
- ② CASE variable WHEN value THEN statement;
- ③ CASE condition WHEN value THEN statement;
- ④ CASE THEN statement;

---

**3번** WHILE 반복문의 특징은?

- ① 무조건 최소 1번 실행
- ② 조건을 먼저 확인하고 반복
- ③ 조건을 확인하지 않고 반복
- ④ BREAK로 탈출

---

**4번** REPEAT-UNTIL 반복문과 WHILE의 차이는?

- ① REPEAT는 조건을 먼저 확인
- ② WHILE은 무조건 1번 실행
- ③ REPEAT는 무조건 1번 실행 (조건 확인 후)
- ④ 차이가 없음

---

**5번** LOOP 반복문에서 탈출하는 방법은?

- ① BREAK;
- ② EXIT;
- ③ LEAVE label_name;
- ④ STOP;

---

## 중급 수준 (3개) - 개념 적용

**6번** 다음 중 ELSEIF를 올바르게 사용한 것은?

```sql
① IF score >= 90 THEN SET grade = 'A';
   ELSEIF score >= 80 THEN SET grade = 'B';
   ELSE SET grade = 'C';
   END IF;

② IF score >= 90 THEN SET grade = 'A';
   ELSE IF score >= 80 THEN SET grade = 'B';
   END IF;
   END IF;
```

- ① 올바름
- ② 올바름
- ③ ①만 올바름
- ④ ②만 올바름

---

**7번** 검색 형태의 CASE 문은?

```sql
① CASE month_num WHEN 1 THEN '1월'

② CASE
   WHEN salary >= 5000000 THEN '상'
   WHEN salary >= 4000000 THEN '중'
   END CASE;
```

- ① 간단한 형태
- ② 검색 형태
- ③ 둘 다 같은 형태
- ④ 둘 다 검색 형태

---

**8번** 중첩된 제어 구조의 사용 예는?

- ① WHILE IF CASE를 함께 사용
- ② IF 내에서 CASE, CASE 내에서 IF
- ③ IF와 CASE를 연속으로 사용
- ④ ①과 ②

---

## 고급 수준 (2개) - 비판적 사고

**9번** ITERATE 문의 역할은?

- ① 반복문을 완전히 종료
- ② 현재 반복 주기를 건너뛰고 다음 반복으로 이동
- ③ 반복 횟수를 증가
- ④ 조건을 다시 평가

---

**10번** 라벨(Label)과 LEAVE의 관계는?

```sql
my_loop: LOOP
  IF condition THEN
    LEAVE my_loop;
  END IF;
END LOOP;
```

- ① 라벨로 LOOP를 식별하고 LEAVE로 탈출
- ② LEAVE만으로 탈출 가능
- ③ 라벨은 선택사항
- ④ LOOP 탈출에는 필수 아님

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** IF-THEN-ELSE 문의 구조를 설명하고, ELSEIF를 사용하는 방법을 설명하시오.

---

**12번** CASE 문의 두 가지 형태(간단한 형태와 검색 형태)를 설명하고 각각의 사용 상황을 예시하시오.

---

**13번** WHILE, REPEAT, LOOP 반복문의 차이를 설명하고, 각각의 특징을 비교하시오.

---

## 중급 수준 (1개)

**14번** 중첩된 제어 구조의 개념을 설명하고, IF-THEN-CASE-WHILE을 모두 포함하는 예제를 작성하시오.

---

## 고급 수준 (1개)

**15번** ITERATE와 LEAVE 문의 역할과 사용 방법을 설명하시오. 각각이 어떤 상황에서 필요한지 구체적인 예시와 함께 설명하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch11_control_structure CHARACTER SET utf8mb4;
USE ch11_control_structure;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    salary INT
);

INSERT INTO employees VALUES
(1, '김철수', 5000000),
(2, '이영희', 4000000),
(3, '박민준', 4500000);

SELECT * FROM employees;
```

제출: employees 테이블에 3명 데이터가 모두 보이는 스크린샷

---

**17번** IF-THEN-ELSE와 CASE 문을 사용한 프로시저를 작성하고 실행하시오.

```sql
-- 1. IF-THEN-ELSE로 급여 등급 판정
CREATE PROCEDURE CheckSalaryLevel (IN emp_id INT)
BEGIN
  DECLARE emp_salary INT;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary > 4500000 THEN
    SELECT CONCAT(emp_salary, ' - High Salary');
  ELSEIF emp_salary > 4000000 THEN
    SELECT CONCAT(emp_salary, ' - Medium Salary');
  ELSE
    SELECT CONCAT(emp_salary, ' - Low Salary');
  END IF;
END;

CALL CheckSalaryLevel(1);
CALL CheckSalaryLevel(2);

-- 2. CASE 문으로 등급 할당
CREATE PROCEDURE AssignGrade (IN emp_id INT, OUT grade CHAR)
BEGIN
  DECLARE emp_salary INT;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  SET grade = CASE
    WHEN emp_salary >= 5000000 THEN 'A'
    WHEN emp_salary >= 4500000 THEN 'B'
    WHEN emp_salary >= 4000000 THEN 'C'
    ELSE 'D'
  END;
END;

CALL AssignGrade(1, @grade1);
SELECT @grade1;
```

제출: 프로시저 실행 결과 스크린샷

---

## 중급 수준 (2개)

**18번** WHILE 반복문을 사용하여 데이터를 처리하시오.

```sql
-- 임시 테이블 생성
CREATE TABLE temp_results (
    id INT,
    data VARCHAR(50)
);

-- WHILE 반복문으로 데이터 삽입
CREATE PROCEDURE InsertTestData (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO temp_results VALUES (i, CONCAT('Data_', i));
    SET i = i + 1;
  END WHILE;
END;

CALL InsertTestData(5);
SELECT * FROM temp_results;

-- REPEAT 반복문 (WHILE 대체)
CREATE PROCEDURE InsertTestDataRepeat (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  REPEAT
    INSERT INTO temp_results VALUES (i + 5, CONCAT('DataR_', i));
    SET i = i + 1;
  UNTIL i > 5
  END REPEAT;
END;

CALL InsertTestDataRepeat(5);
SELECT * FROM temp_results;
```

제출: temp_results 테이블의 최종 결과 스크린샷

---

**19번** 중첩된 제어 구조를 사용한 프로시저를 작성하고 실행하시오.

```sql
CREATE TABLE salary_analysis (
    emp_id INT,
    emp_name VARCHAR(30),
    salary INT,
    grade CHAR,
    status VARCHAR(30)
);

-- 중첩된 IF-CASE를 사용한 복합 프로시저
CREATE PROCEDURE AnalyzeSalary (IN emp_id INT)
BEGIN
  DECLARE emp_name VARCHAR(30);
  DECLARE emp_salary INT;
  DECLARE grade CHAR;
  DECLARE status VARCHAR(30);
  
  SELECT name, salary INTO emp_name, emp_salary FROM employees WHERE employee_id = emp_id;
  
  -- IF 문으로 조건 확인
  IF emp_salary >= 4000000 THEN
    -- 급여가 충분한 경우 CASE로 등급 할당
    SET grade = CASE
      WHEN emp_salary >= 5000000 THEN 'A'
      WHEN emp_salary >= 4500000 THEN 'B'
      ELSE 'C'
    END;
    SET status = 'Normal';
  ELSE
    SET grade = 'D';
    SET status = 'Needs Raise';
  END IF;
  
  INSERT INTO salary_analysis VALUES (emp_id, emp_name, emp_salary, grade, status);
END;

CALL AnalyzeSalary(1);
CALL AnalyzeSalary(2);
CALL AnalyzeSalary(3);

SELECT * FROM salary_analysis;
```

제출: salary_analysis 테이블의 분석 결과 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복잡한 제어 구조 프로시저를 작성하고 실행하시오.

```
요구사항:
1. LOOP와 LEAVE를 사용한 프로시저
   - 라벨을 붙인 LOOP 생성
   - 특정 조건에서 LEAVE로 탈출
   - 반복 횟수 제한

2. ITERATE를 활용한 프로시저
   - 특정 조건에서 반복 건너뛰기
   - 조건 필터링
   - 선택적 데이터 처리

3. 중첩된 반복문
   - WHILE 내에 IF-CASE 포함
   - 부서별/급여 범위별 데이터 분류
   - 여러 조건에 따른 처리

4. 프로시저 실행 및 결과 검증
   - 각 프로시저의 실행
   - 결과 데이터 확인
   - 조건 검증

제출:
   - 각 프로시저의 SQL 코드
   - 각 프로시저의 실행 결과 스크린샷
   - 실행 후 생성된 테이블 데이터
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                         |
| :--: | :--: | :------------------------------------------- |
| 1번 |  ②  | IF-THEN-ELSE의 올바른 문법                   |
| 2번 |  ②  | 간단한 CASE: CASE variable WHEN              |
| 3번 |  ②  | WHILE은 조건을 먼저 확인                     |
| 4번 |  ③  | REPEAT는 무조건 1번 실행 후 조건 확인        |
| 5번 |  ③  | LEAVE로 라벨 지정 LOOP 탈출                  |
| 6번 |  ③  | ①만 올바른 ELSEIF 문법                      |
| 7번 |  ②  | 검색형 CASE: CASE WHEN condition             |
| 8번 |  ④  | 둘 다 가능한 중첩 구조                       |
| 9번 |  ②  | ITERATE는 현재 반복을 건너뛰고 다음으로 이동 |
| 10번 |  ①  | 라벨로 식별, LEAVE로 탈출                    |

---

## 주관식 모범 답안 (5개)

### 11번 IF-THEN-ELSE와 ELSEIF

**모범 답안**:

```
IF-THEN-ELSE 구조:

IF condition THEN
  -- 조건이 참
  statement1;
ELSEIF condition2 THEN
  -- 조건2가 참
  statement2;
ELSE
  -- 모든 조건이 거짓
  statement3;
END IF;

ELSEIF 사용:
- 3개 이상의 분기 필요시
- 각 조건 순서대로 확인
- 첫 번째 참인 분기 실행
- 나머지 조건 확인 안 함

예제:
IF score >= 90 THEN SET grade = 'A';
ELSEIF score >= 80 THEN SET grade = 'B';
ELSEIF score >= 70 THEN SET grade = 'C';
ELSE SET grade = 'D';
END IF;
```

---

### 12번 CASE 문의 두 형태

**모범 답안**:

```
1. 간단한 형태 (Simple CASE)
CASE variable
  WHEN value1 THEN statement1;
  WHEN value2 THEN statement2;
  ELSE statement_default;
END CASE;

특징:
- 하나의 변수와 여러 값 비교
- = 비교만 가능
- 값 목록이 명확할 때

사용 상황:
- 월 번호 → 월 이름
- 코드 → 설명
- 고정된 값의 매핑

예:
SET month_name = CASE month
  WHEN 1 THEN '1월'
  WHEN 2 THEN '2월'
  ELSE '알 수 없음'
END;

2. 검색 형태 (Searched CASE)
CASE
  WHEN condition1 THEN statement1;
  WHEN condition2 THEN statement2;
  ELSE statement_default;
END CASE;

특징:
- 복잡한 조건 가능
- >, <, AND, OR 등 사용
- 범위 검사 가능

사용 상황:
- 범위에 따른 등급
- 여러 조건의 조합
- 복잡한 비즈니스 로직

예:
SET grade = CASE
  WHEN salary >= 5000000 THEN 'A'
  WHEN salary >= 4000000 AND dept = 1 THEN 'B'
  WHEN salary < 3000000 OR dept = 3 THEN 'D'
  ELSE 'C'
END;
```

---

### 13번 반복문 비교

**모범 답안**:

```
1. WHILE (조건 먼저 확인)
WHILE condition DO
  statement;
END WHILE;

특징:
- 조건 확인 → 실행
- 조건 거짓이면 미실행 (0회 가능)
- 일반적 반복문

2. REPEAT-UNTIL (실행 후 조건 확인)
REPEAT
  statement;
UNTIL condition
END REPEAT;

특징:
- 무조건 최소 1회 실행
- 조건 확인이 후행
- do-while 같음

3. LOOP (무한 반복, LEAVE로 탈출)
[label:] LOOP
  statement;
  IF condition THEN
    LEAVE label;
  END IF;
END LOOP;

특징:
- 무조건 반복
- LEAVE로 명시적 탈출
- 라벨 필수

비교:
WHILE: 조건 전 확인, 0회 가능
REPEAT: 최소 1회 실행
LOOP: 무한 반복, 명시적 탈출
```

---

### 14번 중첩된 제어 구조

**모범 답안**:

```
개념:
- 제어 구조 안에 다른 제어 구조 포함
- IF 내 CASE, CASE 내 IF 등
- 복잡한 로직 구현 가능

예제:
CREATE PROCEDURE complex_logic ()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  -- WHILE 반복문
  WHILE i <= 5 DO
    -- IF 조건문
    IF i MOD 2 = 0 THEN
      -- CASE 문
      SET grade = CASE i
        WHEN 2 THEN '2: Even'
        WHEN 4 THEN '4: Even'
        ELSE 'Other'
      END;
    ELSE
      SET grade = CONCAT(i, ': Odd');
    END IF;
  
    INSERT INTO results VALUES (i, grade);
    SET i = i + 1;
  END WHILE;
END;
```

---

### 15번 ITERATE와 LEAVE 문

**모범 답안**:

```
1. ITERATE 문
역할:
- 현재 반복 주기를 건너뜀
- 루프 카운터는 증가되지만 그 반복의 나머지 코드 실행 안 함
- 다음 반복 조건 확인으로 이동

사용 상황:
- 특정 조건의 데이터 필터링
- 특정 값 제외하고 처리
- 짝수/홀수 구분

예제:
DECLARE i INT DEFAULT 0;
WHILE i < 10 DO
  SET i = i + 1;
  IF MOD(i, 2) = 0 THEN
    ITERATE;  -- 짝수 건너뛰기
  END IF;
  INSERT INTO odd_numbers VALUES (i);
END WHILE;

2. LEAVE 문
역할:
- 반복문 완전 종료
- 라벨로 지정된 특정 반복문 탈출
- 남은 반복 실행 안 함

사용 상황:
- 특정 조건 만족 시 반복 중단
- 최대 반복 횟수 제한
- 에러 발생 시 빠져나오기

예제:
my_loop: LOOP
  SET i = i + 1;
  IF i > 10 THEN
    LEAVE my_loop;  -- 루프 완전 종료
  END IF;
  INSERT INTO data VALUES (i);
END LOOP;

3. ITERATE vs LEAVE
ITERATE: 현재 반복만 건너뜀, 루프는 계속
LEAVE: 루프 완전 탈출
```

---

## 실습형 모범 답안 (5개)

### 16번 employees 생성

**완료 기준**:
✅ ch11_control_structure 데이터베이스 생성
✅ employees 테이블 생성
✅ 3명 데이터 입력

---

### 17번 조건문 프로시저

**완료 기준**:
✅ IF-THEN-ELSE 프로시저 실행
✅ CASE 문 프로시저 실행
✅ 각 직원별 결과 확인

---

### 18번 반복문 프로시저

**완료 기준**:
✅ WHILE로 5개 행 삽입
✅ REPEAT로 추가 5개 행 삽입
✅ temp_results 최종 10개 행 확인

---

### 19번 중첩 제어 구조

**완료 기준**:
✅ salary_analysis 테이블 생성
✅ IF-CASE 중첩 프로시저 실행
✅ 3명 직원 분석 결과 저장

---

### 20번 복잡한 제어 구조

**모범 답안**:

```sql
-- 1. LOOP와 LEAVE를 사용한 프로시저
CREATE TABLE loop_test (
  iteration INT,
  value VARCHAR(50)
);

CREATE PROCEDURE TestLoopLeave ()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  loop_label: LOOP
    IF i > 10 THEN
      LEAVE loop_label;
    END IF;
  
    INSERT INTO loop_test VALUES (i, CONCAT('Iteration_', i));
    SET i = i + 1;
  END LOOP;
END;

CALL TestLoopLeave();
SELECT * FROM loop_test;

-- 2. ITERATE를 활용한 프로시저
CREATE TABLE filtered_data (
  num INT,
  category VARCHAR(30)
);

CREATE PROCEDURE TestIterateLoop (IN max_val INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  
  filter_loop: LOOP
    SET i = i + 1;
    IF i > max_val THEN
      LEAVE filter_loop;
    END IF;
  
    -- 5의 배수 건너뛰기
    IF i % 5 = 0 THEN
      ITERATE filter_loop;
    END IF;
  
    INSERT INTO filtered_data VALUES (i, 
      CASE 
        WHEN i % 2 = 0 THEN 'Even'
        ELSE 'Odd'
      END
    );
  END LOOP;
END;

CALL TestIterateLoop(20);
SELECT * FROM filtered_data;

-- 3. 중첩된 반복문
CREATE TABLE nested_results (
  row_num INT,
  col_num INT,
  value VARCHAR(50)
);

CREATE PROCEDURE NestedControlStructure (IN row_count INT, IN col_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  DECLARE category VARCHAR(50);
  
  WHILE i <= row_count DO
    SET j = 1;
    WHILE j <= col_count DO
      SET category = CASE
        WHEN (i * j) % 2 = 0 THEN 'Even'
        ELSE 'Odd'
      END;
    
      INSERT INTO nested_results VALUES (i, j, CONCAT('(', i, ',', j, ')=', category));
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;
END;

CALL NestedControlStructure(3, 4);
SELECT * FROM nested_results;
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
