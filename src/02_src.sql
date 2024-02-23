/* 02장 */

-- <실습> 쇼핑몰 데이터베이스(ShopDB)를 생성하자.

-- </실습> 



-- <실습> 테이블을 생성하자. 

-- </실습> 



-- <실습> 행 데이터를 입력하자. 

-- </실습> 



-- <실습> 데이터를 활용한다는 것은 주로 ‘SELECT’문을 사용한다는 의미이다. 
-- p.64

SELECT * FROM memberTBL;

SELECT memberName, memberAddress FROM memberTBL;

SELECT * FROM memberTBL WHERE memberName = '토마스' ;

CREATE TABLE `my testTBL` (id INT);

DROP TABLE `my TestTBL` ;

-- </실습> 



-- <실습> 인덱스를 간단히 사용해 보자.
-- p.71

CREATE TABLE indexTBL (first_name varchar(14), last_name varchar(16) , hire_date date);
INSERT INTO indexTBL 
	SELECT first_name, last_name, hire_date 
	FROM employees.employees
	LIMIT 500;
SELECT * FROM indexTBL;

-- p. 72 인덱스가 없는 상태에서 쿼리 작동 확인하기

SELECT * FROM indexTBL WHERE first_name = 'Mary';

-- p.72 인덱스 생성후 쿼리 작동 확인하기

CREATE INDEX idx_indexTBL_firstname ON indexTBL(first_name);

SELECT * FROM indexTBL WHERE first_name = 'Mary';

-- </실습> 



-- <실습> 기본적인 뷰의 사용법을 실습하자.
-- p.75 (1)

CREATE VIEW uv_memberTBL 
AS
	SELECT memberName, memberAddress FROM memberTBL ;

-- p.75 (2)

SELECT * FROM uv_memberTBL ;

-- </실습> 



-- <실습> 간단한 스토어드 프로시저를 실습하자.
-- p.76 (1)
SELECT * FROM memberTBL WHERE memberName = '토마스';
SELECT * FROM productTBL WHERE productName = '냉장고';

-- p76 (2)

DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
	SELECT * FROM memberTBL WHERE memberName = '토마스' ;
	SELECT * FROM productTBL WHERE productName = '냉장고' ;
END // 
DELIMITER ;

CALL myProc() ;

-- </실습> 



-- <실습> 가장 일반적으로 사용되는 트리거의 용도를 실습해 보자.
-- p.78

INSERT INTO memberTBL VALUES ('Soccer', '흥민', '서울시 서대문구 북가좌동');

UPDATE memberTBL SET memberAddress = '서울 강남구 역삼동' WHERE memberName = '흥민';

DELETE FROM memberTBL WHERE memberName = '흥민';

-- p.79
-- (1)
CREATE TABLE deletedMemberTBL (  
	memberID char(8) ,
	memberName char(5) ,
	memberAddress  char(20),
	deletedDate date  -- 삭제한 날짜
);

-- (2)
DELIMITER //
CREATE TRIGGER trg_deletedMemberTBL  -- 트리거 이름
	AFTER DELETE -- 삭제 후에 작동하게 지정
	ON memberTBL -- 트리거를 부착할 테이블
	FOR EACH ROW -- 각 행마다 적용시킴
BEGIN 
	-- OLD 테이블의 내용을 백업테이블에 삽입
	INSERT INTO deletedMemberTBL 
		VALUES (OLD.memberID, OLD.memberName, OLD.memberAddress, CURDATE() ); 
END //
DELIMITER ;

-- p.80 (3)
SELECT * FROM memberTBL;

INSERT INTO memberTBL VALUES ('Soccer', '흥민', '서울시 서대문구 북가좌동');

DELETE FROM memberTBL WHERE memberName = '흥민';

SELECT * FROM memberTBL;

SELECT * FROM deletedMemberTBL;

-- </실습> 
