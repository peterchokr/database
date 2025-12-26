# Chapter 11: 조건문과 반복문

## 📖 수업 개요

이 장에서는 저장프로시저와 함수에서 프로그래밍 로직을 구현하기 위한 조건문과 반복문을 학습합니다. IF-THEN-ELSE, CASE 문과 같은 조건문, 그리고 WHILE, REPEAT, LOOP 문과 같은 반복문을 사용하여 복잡한 데이터베이스 로직을 구현합니다. 제어 흐름을 정확하게 이해하고 다양한 비즈니스 요구사항을 데이터베이스 수준에서 처리하는 능력을 개발하는 것이 목표입니다.

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

### 11.10 커서 (Cursor)

**커서**는 쿼리 결과 행을 하나씩 처리합니다.

**문법:**
```sql
DECLARE cursor_name CURSOR FOR SELECT ... ;
OPEN cursor_name;
FETCH cursor_name INTO variable_list;
CLOSE cursor_name;
```

**예시:**
```sql
CREATE PROCEDURE process_employees ()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_salary DECIMAL(10, 2);
  DECLARE emp_cursor CURSOR FOR SELECT name, salary FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_name, emp_salary;
    IF done THEN
      LEAVE read_loop;
    END IF;
    -- emp_name, emp_salary로 작업
  END LOOP;
  CLOSE emp_cursor;
END;
```

---

## 📚 Part 2: 샘플 데이터

### employees 테이블
```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees VALUES
(1, '김철수', 5000000),
(2, '이영희', 4000000),
(3, '박민준', 4500000);
```

### temp_table (테스트용)
```sql
CREATE TABLE temp_table (
    id INT,
    data VARCHAR(50)
);
```

---

## 💻 Part 3: 실습

### 🌟 이 부분에서 배우는 것

- 다양한 제어 구조의 구현
- 중첩된 조건과 반복
- 커서를 사용한 행 처리
- 제어 흐름 최적화

---

### 11-1. 기본 IF-THEN

조건문을 사용하여 급여에 따라 다른 처리를 하세요.

```sql
CREATE PROCEDURE CheckSalary (IN emp_id INT)
BEGIN
  DECLARE emp_salary DECIMAL;
  SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
  
  IF emp_salary > 5000000 THEN
    SELECT 'High salary' AS status;
  END IF;
END;

CALL CheckSalary(1);
```

---

### 11-2. IF-ELSEIF-ELSE

3개 이상의 분기를 가지는 조건문을 작성하세요.

```sql
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
END;

CALL GradeAssignment(85);
```

---

### 11-3. 중첩된 IF

IF 문 안에 다른 IF 문을 중첩시키세요.

```sql
CREATE PROCEDURE NestedCondition (IN emp_id INT)
BEGIN
  DECLARE emp_salary DECIMAL;
  DECLARE emp_dept INT;
  
  SELECT salary, dept_id INTO emp_salary, emp_dept FROM employees WHERE employee_id = emp_id;
  
  IF emp_dept = 1 THEN
    IF emp_salary > 5000000 THEN
      SELECT 'Senior member' AS status;
    ELSE
      SELECT 'Junior member' AS status;
    END IF;
  END IF;
END;

CALL NestedCondition(1);
```

---

### 11-4. 간단한 CASE

CASE 문의 간단한 형태를 사용하세요.

```sql
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
END;

CALL SimpleCaseExample(3);
```

---

### 11-5. 검색 CASE

Searched CASE 형태를 사용하세요.

```sql
CREATE PROCEDURE SearchedCaseExample (IN salary DECIMAL)
BEGIN
  DECLARE level VARCHAR(20);
  SET level = CASE
    WHEN salary >= 5000000 THEN 'Top'
    WHEN salary >= 4000000 THEN 'Middle'
    WHEN salary >= 3000000 THEN 'Low'
    ELSE 'Entry'
  END;
  SELECT level;
END;

CALL SearchedCaseExample(4500000);
```

---

### 11-6. CASE와 집계함수

CASE를 SELECT 쿼리에서 사용하세요.

```sql
SELECT name, salary,
  CASE
    WHEN salary >= 5000000 THEN 'High'
    WHEN salary >= 4000000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_level
FROM employees;
```

---

### 11-7. CASE의 중첩

CASE 문을 중첩시키세요.

```sql
SELECT name,
  CASE
    WHEN dept_id = 1 THEN
      CASE WHEN salary > 5000000 THEN 'Senior' ELSE 'Junior' END
    WHEN dept_id = 2 THEN
      CASE WHEN salary > 4500000 THEN 'Senior' ELSE 'Junior' END
    ELSE 'Other'
  END AS position
FROM employees;
```

---

### 11-8. WHILE 기본

WHILE 반복문으로 데이터를 생성하세요.

```sql
CREATE PROCEDURE WhileLoop (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO numbers (value) VALUES (i);
    SET i = i + 1;
  END WHILE;
END;

CALL WhileLoop(10);
```

---

### 11-9. WHILE과 조건

WHILE 루프에 조건을 추가하세요.

```sql
CREATE PROCEDURE ConditionalWhile (IN max_value INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= max_value DO
    IF i % 2 = 0 THEN
      INSERT INTO even_numbers VALUES (i);
    END IF;
    SET i = i + 1;
  END WHILE;
END;

CALL ConditionalWhile(20);
```

---

### 11-10. WHILE 누적 계산

WHILE로 누적 합계를 계산하세요.

```sql
CREATE PROCEDURE SumCalculation (IN max_num INT, OUT total INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE sum INT DEFAULT 0;
  WHILE i <= max_num DO
    SET sum = sum + i;
    SET i = i + 1;
  END WHILE;
  SET total = sum;
END;

CALL SumCalculation(100, @result);
SELECT @result;
```

---

### 11-11. REPEAT 기본

REPEAT-UNTIL 반복문을 사용하세요.

```sql
CREATE PROCEDURE RepeatLoop (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  REPEAT
    INSERT INTO data_table VALUES (i, CONCAT('Data', i));
    SET i = i + 1;
  UNTIL i > count
  END REPEAT;
END;

CALL RepeatLoop(5);
```

---

### 11-12. REPEAT와 조건

REPEAT에 복잡한 종료 조건을 추가하세요.

```sql
CREATE PROCEDURE RepeatWithCondition (IN max_val INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  REPEAT
    IF i % 3 = 0 THEN
      INSERT INTO multiples_of_three VALUES (i);
    END IF;
    SET i = i + 1;
  UNTIL i > max_val
  END REPEAT;
END;

CALL RepeatWithCondition(30);
```

---

### 11-13. LOOP 기본

LOOP 반복문을 LEAVE와 함께 사용하세요.

```sql
CREATE PROCEDURE LoopExample (IN max_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  my_loop: LOOP
    INSERT INTO loop_data VALUES (i);
    SET i = i + 1;
    IF i > max_count THEN
      LEAVE my_loop;
    END IF;
  END LOOP;
END;

CALL LoopExample(10);
```

---

### 11-14. LOOP와 ITERATE

LOOP에서 ITERATE로 특정 반복을 건너뛰세요.

```sql
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
    
    INSERT INTO odd_numbers VALUES (i);
  END LOOP;
END;

CALL LoopWithIterate(20);
```

---

### 11-15. ITERATE 조건

특정 조건에서 ITERATE를 사용하세요.

```sql
CREATE PROCEDURE ConditionalIterate (IN limit_val INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  process_loop: LOOP
    SET i = i + 1;
    IF i > limit_val THEN
      LEAVE process_loop;
    END IF;
    
    IF i < 5 THEN
      ITERATE process_loop;
    END IF;
    
    INSERT INTO processed_values VALUES (i);
  END LOOP;
END;

CALL ConditionalIterate(15);
```

---

### 11-16. 중첩 반복문

반복문 안에 또 다른 반복문을 중첩시키세요.

```sql
CREATE PROCEDURE NestedLoops (IN row_count INT, IN col_count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  WHILE i <= row_count DO
    SET j = 1;
    WHILE j <= col_count DO
      INSERT INTO matrix VALUES (i, j, i * j);
      SET j = j + 1;
    END WHILE;
    SET i = i + 1;
  END WHILE;
END;

CALL NestedLoops(5, 5);
```

---

### 11-17. IF와 반복문 조합

IF와 WHILE을 함께 사용하세요.

```sql
CREATE PROCEDURE IfAndWhile (IN max_num INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= max_num DO
    IF i % 5 = 0 THEN
      INSERT INTO divisible_by_five VALUES (i);
    ELSEIF i % 3 = 0 THEN
      INSERT INTO divisible_by_three VALUES (i);
    ELSE
      INSERT INTO others VALUES (i);
    END IF;
    SET i = i + 1;
  END WHILE;
END;

CALL IfAndWhile(30);
```

---

### 11-18. CASE와 반복문 조합

CASE와 반복문을 함께 사용하세요.

```sql
CREATE PROCEDURE CaseAndLoop (IN count INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= count DO
    INSERT INTO categorized_data VALUES (i,
      CASE
        WHEN i <= 10 THEN 'Low'
        WHEN i <= 20 THEN 'Medium'
        ELSE 'High'
      END
    );
    SET i = i + 1;
  END WHILE;
END;

CALL CaseAndLoop(30);
```

---

### 11-19. 커서 기본

커서를 사용하여 각 행을 처리하세요.

```sql
CREATE PROCEDURE ProcessEmployees ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_cursor CURSOR FOR SELECT name FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_name;
    IF done THEN LEAVE read_loop; END IF;
    INSERT INTO processed_employees VALUES (emp_name, NOW());
  END LOOP;
  CLOSE emp_cursor;
END;

CALL ProcessEmployees();
```

---

### 11-20. 커서와 변수

커서에서 가져온 값을 변수에 저장하세요.

```sql
CREATE PROCEDURE CursorWithVariables ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_id INT;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_salary DECIMAL;
  DECLARE emp_cursor CURSOR FOR SELECT employee_id, name, salary FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_id, emp_name, emp_salary;
    IF done THEN LEAVE read_loop; END IF;
    UPDATE employee_summary SET total_salary = emp_salary WHERE id = emp_id;
  END LOOP;
  CLOSE emp_cursor;
END;

CALL CursorWithVariables();
```

---

### 11-21. 커서와 INSERT

커서를 사용하여 데이터를 변환하고 삽입하세요.

```sql
CREATE PROCEDURE CursorInsert ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_salary DECIMAL;
  DECLARE emp_cursor CURSOR FOR SELECT name, salary FROM employees WHERE salary > 4000000;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_name, emp_salary;
    IF done THEN LEAVE read_loop; END IF;
    INSERT INTO high_earners VALUES (emp_name, emp_salary);
  END LOOP;
  CLOSE emp_cursor;
END;

CALL CursorInsert();
```

---

### 11-22. 커서와 UPDATE

커서를 사용하여 데이터를 수정하세요.

```sql
CREATE PROCEDURE CursorUpdate ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_id INT;
  DECLARE emp_cursor CURSOR FOR SELECT employee_id FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_id;
    IF done THEN LEAVE read_loop; END IF;
    UPDATE employees SET salary = salary * 1.05 WHERE employee_id = emp_id;
  END LOOP;
  CLOSE emp_cursor;
END;

CALL CursorUpdate();
```

---

### 11-23. 커서와 조건

커서 결과에 조건을 적용하세요.

```sql
CREATE PROCEDURE CursorWithCondition ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_id INT;
  DECLARE emp_salary DECIMAL;
  DECLARE emp_cursor CURSOR FOR SELECT employee_id, salary FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_id, emp_salary;
    IF done THEN LEAVE read_loop; END IF;
    
    IF emp_salary > 5000000 THEN
      INSERT INTO bonus_eligible VALUES (emp_id, emp_salary * 0.1);
    END IF;
  END LOOP;
  CLOSE emp_cursor;
END;

CALL CursorWithCondition();
```

---

### 11-24. 중복 커서

여러 커서를 동시에 사용하세요.

```sql
CREATE PROCEDURE MultipleCursors ()
BEGIN
  DECLARE done1 INT DEFAULT 0;
  DECLARE done2 INT DEFAULT 0;
  DECLARE dept_id INT;
  DECLARE emp_name VARCHAR(50);
  DECLARE dept_cursor CURSOR FOR SELECT dept_id FROM departments;
  DECLARE emp_cursor CURSOR FOR SELECT name FROM employees WHERE dept_id = dept_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;
  
  OPEN dept_cursor;
  dept_loop: LOOP
    FETCH dept_cursor INTO dept_id;
    IF done1 THEN LEAVE dept_loop; END IF;
    -- 부서별 직원 처리
  END LOOP;
  CLOSE dept_cursor;
END;

CALL MultipleCursors();
```

---

### 11-25. 커서 에러 처리

커서 사용 중 오류를 처리하세요.

```sql
CREATE PROCEDURE CursorErrorHandling ()
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
  SELECT 'Error occurred while processing cursor' AS error_message;
  
  DECLARE done INT DEFAULT 0;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_cursor CURSOR FOR SELECT name FROM employees;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  read_loop: LOOP
    FETCH emp_cursor INTO emp_name;
    IF done THEN LEAVE read_loop; END IF;
    INSERT INTO cursor_results VALUES (emp_name);
  END LOOP;
  CLOSE emp_cursor;
END;

CALL CursorErrorHandling();
```

---

### 11-26. 계산 로직

IF와 반복문을 사용하여 복잡한 계산을 수행하세요.

```sql
CREATE PROCEDURE ComplexCalculation (IN input_val INT, OUT result INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE total INT DEFAULT 0;
  
  WHILE i <= input_val DO
    IF i % 2 = 0 THEN
      SET total = total + i;
    ELSE
      SET total = total - i;
    END IF;
    SET i = i + 1;
  END WHILE;
  
  SET result = total;
END;

CALL ComplexCalculation(20, @calc_result);
SELECT @calc_result;
```

---

### 11-27. 데이터 검증

조건문으로 데이터를 검증하세요.

```sql
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
END;

CALL ValidateData(1, @valid);
SELECT @valid;
```

---

### 11-28. 조건부 INSERT

조건에 따라 다른 데이터를 삽입하세요.

```sql
CREATE PROCEDURE ConditionalInsert (IN emp_salary DECIMAL)
BEGIN
  IF emp_salary > 5000000 THEN
    INSERT INTO top_earners VALUES (emp_salary);
  ELSEIF emp_salary > 4000000 THEN
    INSERT INTO middle_earners VALUES (emp_salary);
  ELSE
    INSERT INTO entry_level VALUES (emp_salary);
  END IF;
END;

CALL ConditionalInsert(4500000);
```

---

### 11-29. 조건부 UPDATE

조건에 따라 다르게 수정하세요.

```sql
CREATE PROCEDURE ConditionalUpdate (IN emp_id INT, IN new_salary DECIMAL)
BEGIN
  DECLARE old_salary DECIMAL;
  SELECT salary INTO old_salary FROM employees WHERE employee_id = emp_id;
  
  IF new_salary > old_salary * 1.5 THEN
    UPDATE employees SET salary = old_salary * 1.2 WHERE employee_id = emp_id;
  ELSE
    UPDATE employees SET salary = new_salary WHERE employee_id = emp_id;
  END IF;
END;

CALL ConditionalUpdate(1, 6000000);
```

---

### 11-30. 루프 카운터

반복 횟수를 세고 제한하세요.

```sql
CREATE PROCEDURE LoopWithCounter (IN limit_count INT)
BEGIN
  DECLARE counter INT DEFAULT 0;
  DECLARE max_iterations INT DEFAULT limit_count;
  
  WHILE counter < max_iterations DO
    INSERT INTO loop_iterations VALUES (counter);
    SET counter = counter + 1;
  END WHILE;
END;

CALL LoopWithCounter(100);
```

---

### 11-31. 동적 쿼리

조건에 따라 다른 쿼리를 실행하세요.

```sql
CREATE PROCEDURE DynamicQuery (IN query_type VARCHAR(20), IN dept_id INT)
BEGIN
  IF query_type = 'salary' THEN
    SELECT AVG(salary) FROM employees WHERE dept_id = dept_id;
  ELSEIF query_type = 'count' THEN
    SELECT COUNT(*) FROM employees WHERE dept_id = dept_id;
  ELSE
    SELECT * FROM employees WHERE dept_id = dept_id;
  END IF;
END;

CALL DynamicQuery('salary', 1);
```

---

### 11-32. 게이트키퍼 패턴

조건을 만족하지 않으면 조기 종료하세요.

```sql
CREATE PROCEDURE GateKeeperPattern (IN emp_id INT, OUT result VARCHAR(50))
BEGIN
  IF NOT EXISTS(SELECT 1 FROM employees WHERE employee_id = emp_id) THEN
    SET result = 'Employee not found';
    LEAVE;
  END IF;
  
  SET result = 'Processing employee';
END;

CALL GateKeeperPattern(1, @result);
SELECT @result;
```

---

### 11-33. 상태 기계

여러 상태를 전환하는 로직을 구현하세요.

```sql
CREATE PROCEDURE StateMachine (IN emp_id INT)
BEGIN
  DECLARE current_state VARCHAR(20) DEFAULT 'start';
  DECLARE loop_count INT DEFAULT 0;
  
  WHILE loop_count < 10 DO
    SET current_state = CASE current_state
      WHEN 'start' THEN 'processing'
      WHEN 'processing' THEN 'completed'
      ELSE 'end'
    END;
    
    SET loop_count = loop_count + 1;
    
    IF current_state = 'end' THEN
      LEAVE;
    END IF;
  END WHILE;
END;

CALL StateMachine(1);
```

---

### 11-34. 배치 처리

반복문으로 대량 데이터를 처리하세요.

```sql
CREATE PROCEDURE BatchProcessing (IN batch_size INT)
BEGIN
  DECLARE processed INT DEFAULT 0;
  
  WHILE processed < 1000 DO
    INSERT INTO processed_batch
    SELECT * FROM unprocessed_data LIMIT batch_size;
    
    DELETE FROM unprocessed_data LIMIT batch_size;
    
    SET processed = processed + batch_size;
  END WHILE;
END;

CALL BatchProcessing(100);
```

---

### 11-35. 진행 추적

반복 진행 상황을 추적하세요.

```sql
CREATE PROCEDURE ProgressTracking (IN total_items INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE progress INT DEFAULT 0;
  
  WHILE i <= total_items DO
    INSERT INTO items VALUES (i);
    SET i = i + 1;
    SET progress = ROUND((i / total_items) * 100);
    UPDATE progress_log SET percent = progress WHERE task_id = 1;
  END WHILE;
END;

CALL ProgressTracking(1000);
```

---

### 11-36. 조건부 반복

조건에 따라 반복 횟수를 조절하세요.

```sql
CREATE PROCEDURE ConditionalLoop (IN repeat_count INT, IN skip_even INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  
  WHILE i <= repeat_count DO
    IF skip_even = 1 AND i % 2 = 0 THEN
      SET i = i + 1;
      ITERATE;
    END IF;
    
    INSERT INTO conditional_data VALUES (i);
    SET i = i + 1;
  END WHILE;
END;

CALL ConditionalLoop(20, 1);
```

---

### 11-37. 범위 처리

범위 내에서만 반복하세요.

```sql
CREATE PROCEDURE RangeProcessing (IN start_val INT, IN end_val INT)
BEGIN
  DECLARE i INT DEFAULT start_val;
  
  WHILE i <= end_val DO
    IF i >= start_val AND i <= end_val THEN
      INSERT INTO range_data VALUES (i);
    END IF;
    SET i = i + 1;
  END WHILE;
END;

CALL RangeProcessing(10, 20);
```

---

### 11-38. 리스트 처리

리스트의 각 항목을 처리하세요.

```sql
CREATE PROCEDURE ListProcessing ()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE item_id INT;
  DECLARE item_cursor CURSOR FOR SELECT id FROM items;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN item_cursor;
  process_loop: LOOP
    FETCH item_cursor INTO item_id;
    IF done THEN LEAVE process_loop; END IF;
    UPDATE items SET processed = 1 WHERE id = item_id;
  END LOOP;
  CLOSE item_cursor;
END;

CALL ListProcessing();
```

---

### 11-39. 계층 처리

계층 구조를 처리하세요.

```sql
CREATE PROCEDURE HierarchyProcessing (IN parent_id INT)
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE child_id INT;
  DECLARE children_cursor CURSOR FOR SELECT id FROM hierarchy WHERE parent_id = parent_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN children_cursor;
  child_loop: LOOP
    FETCH children_cursor INTO child_id;
    IF done THEN LEAVE child_loop; END IF;
    CALL HierarchyProcessing(child_id);
  END LOOP;
  CLOSE children_cursor;
END;

CALL HierarchyProcessing(1);
```

---

### 11-40. 실무 시나리오

급여 인상, 성과급 계산 등 실무 로직을 구현하세요.

```sql
CREATE PROCEDURE AnnualSalaryReview (IN dept_id INT, IN increase_percent DECIMAL)
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE emp_id INT;
  DECLARE emp_salary DECIMAL;
  DECLARE emp_cursor CURSOR FOR SELECT employee_id, salary FROM employees WHERE dept_id = dept_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  OPEN emp_cursor;
  review_loop: LOOP
    FETCH emp_cursor INTO emp_id, emp_salary;
    IF done THEN LEAVE review_loop; END IF;
    
    UPDATE employees SET salary = emp_salary * (1 + increase_percent / 100)
    WHERE employee_id = emp_id;
    
    INSERT INTO salary_review_history VALUES (emp_id, emp_salary, increase_percent, NOW());
  END LOOP;
  CLOSE emp_cursor;
END;

CALL AnnualSalaryReview(1, 5);
```

---
## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: IF-THEN-ELSE와 CASE 문의 특징을 설명하고, 각각이 적합한 상황을 논의하세요. 복잡한 조건을 처리할 때 가독성 면에서 어느 것이 나은지 분석하세요.

**2번 과제**: WHILE, REPEAT, LOOP 세 가지 반복문의 차이점을 설명하세요. 각각의 사용 시기와 장단점을 비교하고, 어떤 상황에서 어느 것을 선택할지 제시하세요.

**3번 과제**: ITERATE와 LEAVE 문의 역할을 설명하세요. 반복문의 제어 흐름을 정확하게 조정할 때 이들 문장이 어떻게 사용되는지 서술하세요.

**4번 과제**: 커서의 개념과 사용 방법을 설명하세요. 커서가 필요한 상황과 커서를 사용하지 않고 같은 작업을 수행하는 방법이 있는지 비교하세요.

**5번 과제**: 제어 구조를 중첩시킬 때의 고려사항을 논의하세요. 복잡한 중첩 구조를 어떻게 가독성 있게 작성할 수 있는지 제안하세요.

제출 형식: Word 또는 PDF 문서 (2-3페이지)

---

### 실습 과제

**1번 과제**: 다양한 조건문을 작성하세요:
- IF-THEN-ELSE로 급여에 따른 세금 계산
- CASE 문으로 점수에 따른 학점 부여
- 중첩 조건으로 복합 로직 구현

**2번 과제**: 반복문 프로시저를 작성하세요:
- WHILE로 1부터 N까지 합계 계산
- REPEAT로 조건에 따른 데이터 생성
- LOOP로 조건부 행 처리

**3번 과제**: ITERATE와 LEAVE를 사용하세요:
- 특정 조건에서 반복을 건너뛰기
- 특정 조건에서 반복 조기 종료
- 여러 개의 탈출 조건 처리

**4번 과제**: 커서를 사용한 행 처리를 구현하세요:
- 커서로 각 행을 읽고 처리
- 커서로 데이터를 변환하여 새로운 테이블에 삽입
- 커서로 데이터를 검증하고 수정

**5번 과제**: Part 3의 실습 11-1부터 11-40까지 제공된 모든 쿼리를 직접 실행하고, 각 결과를 스크린샷으로 첨부하세요. 추가로 5개 이상의 실무 시나리오(급여 계산, 성과급 지급, 직원 분류 등)의 복잡한 비즈니스 로직을 프로시저로 구현하여 그 결과를 제시하고, 제어 구조를 선택한 이유를 설명하세요.

제출 형식: SQL 파일 (Ch11_Control_Structure_[학번].sql) 및 결과 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
