-- 매개변수 전달 사원번호는 3으로 지정해서 출력
-- 1. 외부로 부터 사원번호(employee_id)를 매개변수로 입력받아 사원의 부서번호(dept_id)를 돌려주는 프로시저

DROP PROCEDURE getDeptId;
DELIMITER //
CREATE PROCEDURE getDeptID(IN iemployee_id INT, OUT result INT, OUT sawon_myung VARCHAR(20))
BEGIN
	SELECT dept_id, name INTO result, sawon_myung FROM employees WHERE employee_id = iemployee_id;
END//
DELIMITER ;

-- 2. 외부로 부터 부서번호(dept_id)를 매개변수로 입력받아 부서명(department_name)을 돌려주는 프로시저
DROP PROCEDURE getDepartmentName;
DELIMITER //
CREATE PROCEDURE getDepartmentName(IN idept_id INT, OUT result VARCHAR(20))
BEGIN
	SELECT department_name INTO result FROM departments WHERE dept_id = idept_id;
END//
DELIMITER ;

-- 3. 최종 화면출력으로는 결과를 확인하도록 사원번호, 사원명, 부서코드, 부서명을 출력
SET @id = 3;
CALL getDeptID(@id, @buseo_code, @sawon_myung);
CALL getDepartmentName(@buseo_code, @buseo_myung);

SELECT @id, @sawon_myung, @buseo_code, @buseo_myung;
