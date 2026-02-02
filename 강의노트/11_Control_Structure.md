# 11장. 조건문과 반복문

## 📖 수업 개요

이 장에서는 10장에서 소개한 저장프로시저와 함수에서 프로그래밍 로직을 구현하기 위해 일부 사용했던 조건문과 반복문을 전체적으로 학습합니다.   
IF-THEN-ELSE, CASE 문과 같은 조건문, 그리고 WHILE, REPEAT, LOOP 문과 같은 반복문을 사용하여 복잡한 데이터베이스 로직을 구현합니다.   
제어 흐름을 정확하게 이해하고 다양한 비즈니스 요구사항을 데이터베이스 수준에서 처리하는 능력을 개발하는 것이 목표입니다.   

---

## 📚 Part 1: 이론 학습

### 🌟 이 부분에서 배우는 것

- IF-THEN-ELSE 문의 구조와 사용
- CASE 문의 두 가지 형태
- WHILE 반복문
- REPEAT-UNTIL 반복문
- LOOP 반복문
- 중첩된 제어 구조
- 레이블(Label)과 반복문 제어

---

### 11.1 IF-THEN-ELSE 문

**IF-THEN-ELSE**는 조건에 따라 다른 작업을 수행합니다.

**기본 문법:**

```sql
IF condition THEN
  -- 조건이 참일 때 실행
  statement1;
ELSE
  -- 조건이 거짓일 때 실행
  statement2;
END IF;
```

**ELSEIF 사용:**

```sql
IF condition1 THEN
  statement1;
ELSEIF condition2 THEN
  statement2;
ELSEIF condition3 THEN
  statement3;
ELSE
  statement4;
END IF;
```

**예시:**

```sql
CREATE PROCEDURE grade_assignment (IN score INT, OUT grade CHAR)
BEGIN
  IF score >= 90 THEN
    SET grade = 'A';
  ELSEIF score >= 80 THEN
    SET grade = 'B';
  ELSEIF score >= 70 THEN
    SET grade = 'C';
  ELSEIF score >= 60 THEN
    SET grade = 'D';
  ELSE
    SET grade = 'F';
  END IF;
END;
```

---

### 11.2 CASE 문 - 간단한 형태

**CASE 문 (Simple CASE):**

```sql
CASE variable
  WHEN value1 THEN statement1;
  WHEN value2 THEN statement2;
  ...
  ELSE statement_default;
END CASE;
```

**예시:**

```sql
DECLARE month_name VARCHAR(20);
SET month_name = CASE month_num
  WHEN 1 THEN '1월'
  WHEN 2 THEN '2월'
  WHEN 3 THEN '3월'
  ...
  ELSE '알 수 없음'
END;
```

---

### 11.3 CASE 문 - 검색 형태

**Searched CASE:**

```sql
CASE
  WHEN condition1 THEN statement1;
  WHEN condition2 THEN statement2;
  ...
  ELSE statement_default;
END CASE;
```

**예시:**

```sql
DECLARE salary_level VARCHAR(10);
SET salary_level = CASE
  WHEN salary >= 5000000 THEN '상'
  WHEN salary >= 4000000 THEN '중'
  WHEN salary >= 3000000 THEN '하'
  ELSE '저'
END;
```

---

### 11.4 WHILE 반복문

**WHILE** 문은 조건이 참인 동안 반복합니다.

**문법:**

```sql
WHILE condition DO
  -- 반복할 문장들
  statement;
END WHILE;
```

**예시:**

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

**특징:**

- 조건을 먼저 확인하고 반복
- 조건이 거짓이면 반복 실행 안 됨

---

### 11.5 REPEAT-UNTIL 반복문

**REPEAT-UNTIL** 문은 먼저 실행한 후 조건을 확인합니다.

**문법:**

```sql
REPEAT
  -- 반복할 문장들
  statement;
UNTIL condition
END REPEAT;
```

**예시:**

```sql
CREATE PROCEDURE repeat_example (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  REPEAT
    INSERT INTO temp_table VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
  UNTIL i > count
  END REPEAT;
END;
```

**특징:**

- 최소한 한 번은 실행됨
- WHILE과 반대로 조건 확인

---

### 11.6 LOOP 반복문

**LOOP** 문은 무한 반복하므로 LEAVE 문으로 탈출해야 합니다.

**문법:**

```sql
[label_name:] LOOP
  -- 반복할 문장들
  statement;
  IF condition THEN
    LEAVE label_name;
  END IF;
END LOOP;
```

**예시:**

```sql
CREATE PROCEDURE loop_example (IN max_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  my_loop: LOOP
    INSERT INTO temp_table VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
    IF i > max_count THEN
      LEAVE my_loop;
    END IF;
  END LOOP;
END;
```

---

### 11.7 ITERATE (계속)

**ITERATE** 문은 다음 반복으로 이동합니다.

**예시:**

```sql
DECLARE i INT DEFAULT 0;
WHILE i < 10 DO
  SET i = i + 1;
  IF MOD(i, 2) = 0 THEN
    ITERATE;  -- 짝수일 때 다음 반복으로
  END IF;
  INSERT INTO odd_numbers VALUES (i);
END WHILE;
```

---

### 11.8 LEAVE (탈출)

**LEAVE** 문은 반복을 종료합니다.

**예시:**

```sql
my_loop: LOOP
  -- 반복 문장
  IF condition THEN
    LEAVE my_loop;
  END IF;
END LOOP;
```

---

### 11.9 중첩된 제어 구조

**여러 제어 구조를 결합:**

```sql
CREATE PROCEDURE complex_logic ()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  WHILE i <= 5 DO
    IF i MOD 2 = 0 THEN
      CASE i
        WHEN 2 THEN INSERT INTO results VALUES (2, 'Two');
        WHEN 4 THEN INSERT INTO results VALUES (4, 'Four');
      END CASE;
    ELSE
      INSERT INTO results VALUES (i, 'Odd');
    END IF;
    SET i = i + 1;
  END WHILE;
END;
```

---

## 📚 Part 2: 샘플 데이터

### 필수 테이블 구성

```sql
CREATE DATABASE ch11_control CHARACTER SET utf8mb4;
USE ch11_control;

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

-- temp_table (테스트용)
CREATE TABLE temp_table (
    id INT,
    data VARCHAR(100)
);
```


## 💻 Part 3: 실습 (15개 문제)

### 🌟 이 부분에서 배우는 것

이 섹션에서는 조건문과 반복문을 활용하여 복잡한 데이터베이스 로직을 구현합니다.

```sql
-- =====================================================
-- 섹션 1: 조건문 (1-4번)
-- =====================================================

-- 1. 기본 IF-THEN (조건에 따른 처리)
DELIMITER //
CREATE PROCEDURE CheckSalary (IN emp_id INT)
BEGIN
  DECLARE emp_salary DECIMAL;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary >= 5000000 THEN
    SELECT 'High salary' AS status;
  END IF;
END //
DELIMITER ;

CALL CheckSalary(1);

-- 2. IF-ELSEIF-ELSE (3개 이상 분기)
DELIMITER //
CREATE PROCEDURE GradeAssignment (IN score INT)
BEGIN
  IF score >= 90 THEN
    SELECT 'A' AS grade;
  ELSEIF score >= 80 THEN
    SELECT 'B' AS grade;
  ELSEIF score >= 70 THEN
    SELECT 'C' AS grade;
  ELSE
    SELECT 'F' AS grade;
  END IF;
END //
DELIMITER ;

CALL GradeAssignment(85);

-- 3. 간단한 CASE (값에 따른 매핑)
DELIMITER //
CREATE PROCEDURE SimpleCaseExample (IN month_num INT)
BEGIN
  DECLARE month_name VARCHAR(20);
  SET month_name = CASE month_num
    WHEN 1 THEN 'January'
    WHEN 2 THEN 'February'
    WHEN 3 THEN 'March'
    ELSE 'Other'
  END;
  SELECT month_name;
END //
DELIMITER ;

CALL SimpleCaseExample(3);

-- 4. 데이터 검증 (조건에 따른 검증)
DELIMITER //
CREATE PROCEDURE ValidateData (IN emp_id INT, OUT is_valid INT)
BEGIN
  DECLARE emp_salary DECIMAL;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary IS NULL THEN
    SET is_valid = 0;
  ELSEIF emp_salary < 0 THEN
    SET is_valid = 0;
  ELSE
    SET is_valid = 1;
  END IF;
END //
DELIMITER ;

CALL ValidateData(1, @valid);
SELECT @valid;

-- =====================================================
-- 섹션 2: WHILE 반복문 (5-7번)
-- =====================================================

-- 5. WHILE 기본 (데이터 생성)
DELIMITER //
CREATE PROCEDURE WhileLoop (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO temp_table (id, data) VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL WhileLoop(10);

-- 6. WHILE과 조건 (조건부 처리)
DELIMITER //
CREATE PROCEDURE ConditionalWhile (IN max_value INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= max_value DO
    IF i % 2 = 0 THEN
      INSERT INTO temp_table (id, data) VALUES (i, CONCAT('Even: ', i));
    END IF;
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL ConditionalWhile(20);

-- 7. WHILE 누적 계산 (합계 계산)
DELIMITER //
CREATE PROCEDURE SumCalculation (IN max_num INT, OUT total INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE sum INT DEFAULT 0;
  WHILE i <= max_num DO
    SET sum = sum + i;
    SET i = i + 1;
  END WHILE;
  SET total = sum;
END //
DELIMITER ;

CALL SumCalculation(100, @result);
SELECT @result;

-- =====================================================
-- 섹션 3: REPEAT와 LOOP 반복문 (8-10번)
-- =====================================================

-- 8. REPEAT 기본 (최소 1번 실행)
DELIMITER //
CREATE PROCEDURE RepeatLoop (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  REPEAT
    INSERT INTO temp_table (id, data) VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
  UNTIL i > count
  END REPEAT;
END //
DELIMITER ;

CALL RepeatLoop(5);

-- 9. LOOP 기본 (LEAVE로 종료)
DELIMITER //
CREATE PROCEDURE LoopExample (IN max_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  my_loop: LOOP
    INSERT INTO temp_table (id, data) VALUES (i, CONCAT('Iteration ', i));
    SET i = i + 1;
    IF i > max_count THEN
      LEAVE my_loop;
    END IF;
  END LOOP;
END //
DELIMITER ;

CALL LoopExample(10);

-- 10. LOOP와 ITERATE (반복 건너뛰기)
DELIMITER //
CREATE PROCEDURE LoopWithIterate (IN max_val INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  my_loop: LOOP
    SET i = i + 1;
    IF i > max_val THEN
      LEAVE my_loop;
    END IF;
  
    IF i % 2 = 0 THEN
      ITERATE my_loop;
    END IF;
  
    INSERT INTO temp_table (id, data) VALUES (i, CONCAT('Odd: ', i));
  END LOOP;
END //
DELIMITER ;

CALL LoopWithIterate(20);

-- =====================================================
-- 섹션 4: 중첩과 결합 (11-13번)
-- =====================================================

-- 11. 중첩 반복문 (반복문 안의 반복문)
DELIMITER //
CREATE PROCEDURE NestedLoops (IN row_count INT, IN col_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  WHILE i <= row_count DO
    SET j = 1;
    WHILE j <= col_count DO
      INSERT INTO temp_table (id, data) VALUES (i*10 + j, CONCAT('Row ', i, ' Col ', j));
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL NestedLoops(5, 5);

-- 12. IF와 반복문 조합 (조건부 반복 처리)
DELIMITER //
CREATE PROCEDURE IfAndWhile (IN max_num INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= max_num DO
    IF i % 5 = 0 THEN
      INSERT INTO temp_table (id, data) VALUES (i, 'Divisible by 5');
    ELSEIF i % 3 = 0 THEN
      INSERT INTO temp_table (id, data) VALUES (i, 'Divisible by 3');
    ELSE
      INSERT INTO temp_table (id, data) VALUES (i, 'Other');
    END IF;
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL IfAndWhile(30);

-- =====================================================
-- 섹션 5: 실무 응용 (14-15번)
-- =====================================================

-- 13. 조건부 INSERT (조건에 따른 삽입)
DELIMITER //
CREATE PROCEDURE ConditionalInsert (IN emp_salary DECIMAL)
BEGIN
  IF emp_salary > 5000000 THEN
    INSERT INTO temp_table (id, data) VALUES (1, 'Top Earner');
  ELSEIF emp_salary > 4000000 THEN
    INSERT INTO temp_table (id, data) VALUES (2, 'Middle Earner');
  ELSE
    INSERT INTO temp_table (id, data) VALUES (3, 'Entry Level');
  END IF;
END //
DELIMITER ;

CALL ConditionalInsert(4500000);

-- 14. 조건부 UPDATE (조건에 따른 수정)
DELIMITER //
CREATE PROCEDURE ConditionalUpdate (IN emp_id INT, IN new_salary DECIMAL)
BEGIN
  DECLARE old_salary DECIMAL;
  SELECT salary INTO old_salary FROM employees WHERE employee_id = emp_id;
  
  IF new_salary > old_salary * 1.5 THEN
    UPDATE employees SET salary = old_salary * 1.2 WHERE employee_id = emp_id;
  ELSE
    UPDATE employees SET salary = new_salary WHERE employee_id = emp_id;
  END IF;
END //
DELIMITER ;

CALL ConditionalUpdate(1, 6000000);

-- 15. 루프 카운터 (반복 횟수 제한)
DELIMITER //
CREATE PROCEDURE LoopWithCounter (IN limit_count INT)
BEGIN
  DECLARE counter INT DEFAULT 0;
  DECLARE max_iterations INT DEFAULT limit_count;
  
  WHILE counter < max_iterations DO
    INSERT INTO temp_table (id, data) VALUES (counter, CONCAT('Iteration ', counter));
    SET counter = counter + 1;
  END WHILE;
END //
DELIMITER ;

CALL LoopWithCounter(100);
```


---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: IF-THEN-ELSE와 CASE 문의 특징을 상세히 설명하고, 각각이 적합한 상황을 논의하세요. 복잡한 조건을 처리할 때 가독성 면에서 어느 것이 나은지 분석하세요.

**2번 과제**: WHILE, REPEAT, LOOP 세 가지 반복문의 차이점을 상세히 설명하세요. 각각의 사용 시기와 장단점을 비교하고, 어떤 상황에서 어느 것을 선택할지 제시하세요.

**3번 과제**: ITERATE와 LEAVE 문의 역할을 상세히 설명하세요. 반복문의 제어 흐름을 정확하게 조정할 때 이들 문장이 어떻게 사용되는지 서술하세요.

**4번 과제**: 제어 구조를 중첩시킬 때의 고려사항을 상세히 논의하세요. 복잡한 중첩 구조를 어떻게 가독성 있게 작성할 수 있는지 제안하세요. 조건문과 반복문을 결합한 실무 사례를 제시하세요.

**5번 과제**: 비즈니스 로직에서 제어 구조의 실무 활용을 상세히 설명하세요. 다양한 시나리오에서 적절한 제어 구조를 선택하는 방법과 성능 영향을 논의하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 다양한 조건문을 작성하세요: IF-THEN-ELSE, 여러 ELSEIF, CASE 문.

**2번 과제**: 세 가지 반복문(WHILE, REPEAT, LOOP)을 모두 사용하는 프로시저를 작성하세요.

**3번 과제**: ITERATE와 LEAVE를 사용한 반복문 제어 프로시저를 작성하세요.

**4번 과제**: 조건문과 반복문을 결합한 프로시저를 작성하고, 중첩된 반복문 예제를 포함하세요.

**5번 과제**: Part 3의 실습 11-1부터 11-15까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 비즈니스 시나리오 기반 제어 구조를 만들어 그 목적과 활용 방법을 설명하세요.

제출 형식: SQL 파일 (Ch11_Control_Structure_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
