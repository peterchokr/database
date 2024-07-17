/* 02장 */

-- p.52 쇼핑몰 데이터베이스(ShopDB)를 생성하기

-- p.57 테이블 생성하기

-- p.61 행 데이터 입력하기 

-- p.63 SQL 문 작성하기

SELECT * FROM memberTBL;

SELECT memberName, memberAddress FROM memberTBL;

SELECT * FROM memberTBL WHERE memberName = '토마스' ;

CREATE TABLE `my testTBL` (id INT);

DROP TABLE `my TestTBL` ;

-- p.69
-- 데이버베이스 개체 활용

-- p.70 
-- 인덱스 사용하기 

-- p.71
-- (1) 현재의 데이터베이스를 shopDB 로 변경

-- (2) 적정량의 데이터가 있는 테이블 생성하기

CREATE TABLE indexTBL (first_name varchar(14), last_name varchar(16) , hire_date date);
INSERT INTO indexTBL 
	SELECT first_name, last_name, hire_date 
	FROM employees.employees
	LIMIT 500;
SELECT * FROM indexTBL;

-- (3) 인덱스가 없는 상태에서 쿼리 작동 확인하기
SELECT * FROM indexTBL WHERE first_name = 'Mary';

-- p.72
-- (4) 인덱스 생성후 쿼리 작동 확인하기

CREATE INDEX idx_indexTBL_firstname ON indexTBL(first_name);

SELECT * FROM indexTBL WHERE first_name = 'Mary';

-- p.74 
-- 기본적인 뷰 사용법 알아보기

-- (1) 현재의 데이터베이스를 shopDB 로 변경

-- p.75
-- (2) 뷰 생성하기
CREATE VIEW uv_memberTBL 
AS
	SELECT memberName, memberAddress FROM memberTBL ;

-- (3) 뷰 조회하기
SELECT * FROM uv_memberTBL ;

-- p.76 
-- 간단한 스토어드 프로시저 만들기

-- (1) 2개의 쿼리를 각각 실행하기
SELECT * FROM memberTBL WHERE memberName = '토마스';
SELECT * FROM productTBL WHERE productName = '냉장고';

-- (2) 2개의 쿼리를 하나의 스토어드 프로시저로 만들기
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
	SELECT * FROM memberTBL WHERE memberName = '토마스' ;
	SELECT * FROM productTBL WHERE productName = '냉장고' ;
END // 
DELIMITER ;

-- (3) 생성한 스토어드 프로시저를 실행
CALL myProc() ;

-- p.78
-- 가장 일반적으로 사용되는 트리거의 용도 알아보기

-- (1) 데이터를 삽입, 수정, 삭제하는 SQL 문 작성하기
INSERT INTO memberTBL VALUES ('Soccer', '흥민', '서울시 서대문구 북가좌동');

UPDATE memberTBL SET memberAddress = '서울 강남구 역삼동' WHERE memberName = '흥민';

DELETE FROM memberTBL WHERE memberName = '흥민';

-- p.79
-- (2) 다른 테이블에 삭제된 데이터와 삭제된 날짜 기록하도록 테이블 생성
CREATE TABLE deletedMemberTBL (  
	memberID char(8) ,
	memberName char(5) ,
	memberAddress  char(20),
	deletedDate date  -- 삭제한 날짜
);

-- (3) 삭제 작업이 일어나면 백업 테이블에 삭제된 데이터가 기록되는 트리거를 생성
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

-- p.80 
-- (4) 데이터 삭제 후 삭제된 데이터가 백업 테이블에 들어가는지 확인
SELECT * FROM memberTBL;

INSERT INTO memberTBL VALUES ('Soccer', '흥민', '서울시 서대문구 북가좌동');

DELETE FROM memberTBL WHERE memberName = '흥민';

SELECT * FROM memberTBL;

SELECT * FROM deletedMemberTBL;

