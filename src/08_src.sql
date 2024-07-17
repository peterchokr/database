/* 08장 */
-- p.257

-- 내부 조인
SELECT <열 목록> 
   FROM <첫 번째 테이블> 
   INNER JOIN <두 번째 테이블> 
      ON <조인될 조건> 
[WHERE 검색조건];


-- 258
-- (1)
USE cookDB;
SELECT * 
   FROM buyTBL
     INNER JOIN userTBL
        ON buyTBL.userID = userTBL.userID
   WHERE buyTBL.userID = 'KYM';

-- (2)
USE cookDB;
SELECT * 
   FROM buyTBL
     INNER JOIN userTBL
        ON buyTBL.userID = userTBL.userID
   -- WHERE buyTBL.userID = 'KYM'; 을 생략하면
   
-- p.259
-- (3) 필요한 열만 추출하는 

SELECT userID, userName, prodName, addr, CONCAT(mobile1, mobile2) AS '연락처'
   FROM buyTBL
     INNER JOIN userTBL
        ON buyTBL.userID = userTBL.userID ;

SELECT buyTBL.userID, userName, prodName, addr, CONCAT(mobile1, mobile2) AS '연락처'
   FROM buyTBL
     INNER JOIN userTBL
        ON buyTBL.userID = userTBL.userID;
        
-- p.260
-- 코드를 명확히 하기 위해 SELECT 다음의 열 이름도 모두 '테이블이름.열이름' 형식으로.
SELECT buyTBL.userID, userTBL.userName, buyTBL.prodName, userTBL.addr, CONCAT(userTBL.mobile1, userTBL.mobile2) AS '연락처'
   FROM buyTBL 
     INNER JOIN userTBL 
        ON buyTBL.userID = userTBL.userID ;

-- 간단해 보이도록 각 테이블에 별칭을 부여        
SELECT B.userID, U.userName, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
   FROM buyTBL B
     INNER JOIN userTBL U
        ON B.userID = U.userID ;
        
-- p.262
-- 한번이라도 구매한 기록이 있는 우수 회원에게 감사의 안내문을 발송하려 할 때.

SELECT DISTINCT U.userID, U.userName,  U.addr
   FROM userTBL U
     INNER JOIN buyTBL B
        ON U.userID = B.userID 
   ORDER BY U.userID ;

SELECT U.userID, U.userName,  U.addr
   FROM userTBL U
   WHERE EXISTS (
      SELECT * 
      FROM buyTBL B
      WHERE U.userID = B.userID );

-- p.263
-- 세 테이블의 내부 조인

-- 264
-- (1)
USE cookDB;
CREATE TABLE stdTBL 
( stdName    VARCHAR(10) NOT NULL PRIMARY KEY,
  addr	  CHAR(4) NOT NULL
);
CREATE TABLE clubTBL 
( clubName    VARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo    CHAR(4) NOT NULL
);
CREATE TABLE stdclubTBL
(  num int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
   stdName    VARCHAR(10) NOT NULL,
   clubName    VARCHAR(10) NOT NULL,
FOREIGN KEY(stdName) REFERENCES stdTBL(stdName),
FOREIGN KEY(clubName) REFERENCES clubTBL(clubName)
);
INSERT INTO stdTBL VALUES ('강호동','경북'), ('김제동','경남'), ('김용만','서울'), ('이휘재','경기'),('박수홍','서울');
INSERT INTO clubTBL VALUES ('수영','101호'), ('바둑','102호'), ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubTBL VALUES (NULL, '강호동','바둑'), (NULL,'강호동','축구'), (NULL,'김용만','축구'), (NULL,'이휘재','축구'), (NULL,'이휘재','봉사'), (NULL,'박수홍','봉사');

-- (2)
-- 학생을 기준으로 이름, 지역, 가입한 동아리, 동아리방을 출력

SELECT S.stdName, S.addr, C.clubName, C.roomNo
   FROM stdTBL S 
      INNER JOIN stdclubTBL SC
           ON S.stdName = SC.stdName
      INNER JOIN clubTBL C
		   ON SC.clubName = C.clubName 
   ORDER BY S.stdName;


-- (3)
-- 동아리를 기준으로 가입한 학생의 목록을 출력

SELECT C.clubName, C.roomNo, S.stdName, S.addr
   FROM  stdTBL S
      INNER JOIN stdclubTBL SC
           ON SC.stdName = S.stdName
      INNER JOIN clubTBL C
	       ON SC.clubName = C.clubName
    ORDER BY C.clubName;

-- p.266 
-- 외부 조인 -> 스터디 & 과제

-- p.270
-- 상호 조인

-- (1)
USE cookDB;
SELECT * 
   FROM buyTBL 
     CROSS JOIN userTBL ;

-- (2)
USE employees;
SELECT  COUNT(*) AS '데이터개수'
   FROM employees 
     CROSS JOIN titles;

-- 자체 조인
-- <실습> 하나의 테이블에서 SELF JOIN을 활용해 보자.
-- p.272

USE cookDB;
CREATE TABLE empTBL (emp CHAR(3), manager CHAR(3), empTel VARCHAR(8));

INSERT INTO empTBL VALUES('나사장',NULL,'0000');
INSERT INTO empTBL VALUES('김재무','나사장','2222');
INSERT INTO empTBL VALUES('김부장','김재무','2222-1');
INSERT INTO empTBL VALUES('이부장','김재무','2222-2');
INSERT INTO empTBL VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTBL VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTBL VALUES('이영업','나사장','1111');
INSERT INTO empTBL VALUES('한과장','이영업','1111-1');
INSERT INTO empTBL VALUES('최정보','나사장','3333');
INSERT INTO empTBL VALUES('윤차장','최정보','3333-1');
INSERT INTO empTBL VALUES('이주임','윤차장','3333-1-1');

-- 우대리 상관의 구내번호를 알고 싶다면

SELECT A.emp AS '부하직원' , B.emp AS '직속상관', B.empTel AS '직속상관연락처'
   FROM empTBL A
      INNER JOIN empTBL B
         ON A.manager = B.emp
   WHERE A.emp = '우대리';

-- p.273
-- UNION

USE cookDB;
SELECT stdName, addr FROM stdTBL
   UNION ALL
SELECT clubName, roomNo FROM clubTBL;

-- NOT IN/IN
-- p.274

SELECT userName, CONCAT(mobile1, '-', mobile2) AS '전화번호' FROM userTBL
   WHERE userName NOT IN ( SELECT userName FROM userTBL WHERE mobile1 IS NULL) ;

SELECT userName, CONCAT(mobile1, mobile2) AS '전화번호' FROM userTBL
   WHERE userName IN ( SELECT userName FROM userTBL WHERE mobile1 IS NULL) ;

-- p.276
-- SQL 프로그래밍ALTER

-- 스토어드 프로시저 형식
DELIMITER $$ 
CREATE PROCEDURE 스토어드프로시저이름() 
BEGIN

이곳에 SQL 프로그래밍 코딩

END $$ 
DELIMITER ;
CALL 스토어드프로시저이름();

-- p.277
-- IF … ELSE … END IF 문

DROP PROCEDURE IF EXISTS ifProc; -- 기존에 만든적이 있다면 삭제
DELIMITER $$
CREATE PROCEDURE ifProc()
BEGIN
  DECLARE var1 INT;  -- var1 변수선언
  SET var1 = 100;  -- 변수에 값 대입

  IF var1 = 100 THEN  -- 만약 @var1이 100이라면,
	SELECT '100입니다.';
  ELSE
    SELECT '100이 아닙니다.';
  END IF;
END $$
DELIMITER ;
CALL ifProc();

-- p.278

DROP PROCEDURE IF EXISTS ifProc2; 
USE employees;

DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE hireDATE DATE; -- 입사일
	DECLARE curDATE DATE; -- 오늘
	DECLARE days INT; -- 근무한 일수

	SELECT hire_date INTO hireDate -- hire_date 열의 결과를 hireDATE에 대입
	   FROM employees.employees
	   WHERE emp_no = 10001;

	SET curDATE = CURRENT_DATE(); -- 현재 날짜
	SET days =  DATEDIFF(curDATE, hireDATE); -- 날짜의 차이, 일 단위

	IF (days/365) >= 5 THEN -- 5년이 지났다면
		  SELECT CONCAT('입사한지 ', days, '일이나 지났습니다. 축하합니다!') AS '메시지';
	ELSE
		  SELECT '입사한지 ' + days + '일밖에 안되었네요. 열심히 일하세요.' AS '메시지';
	END IF;
END $$
DELIMITER ;
CALL ifProc2();

-- CASE 문
-- p.279

-- (1)
DROP PROCEDURE IF EXISTS ifProc3; 
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
    DECLARE point INT ;
    DECLARE credit CHAR(1);
    SET point = 77 ;
    
    IF point >= 90 THEN
		SET credit = 'A';
    ELSEIF point >= 80 THEN
		SET credit = 'B';
    ELSEIF point >= 70 THEN
		SET credit = 'C';
    ELSEIF point >= 60 THEN
		SET credit = 'D';
    ELSE
		SET credit = 'F';
    END IF;
    SELECT CONCAT('취득점수==>', point), CONCAT('학점==>', credit);
END $$
DELIMITER ;
CALL ifProc3();

-- (2)
DROP PROCEDURE IF EXISTS caseProc; 
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
    DECLARE point INT ;
    DECLARE credit CHAR(1);
    SET point = 77 ;
    
    CASE 
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		ELSE
			SET credit = 'F';
    END CASE;
    SELECT CONCAT('취득점수==>', point), CONCAT('학점==>', credit);
END $$
DELIMITER ;
CALL caseProc();

-- <실습> CASE 문을 활용하여 SQL 프로그래밍하기 
-- p.283

USE cookDB;

SELECT U.userID, U.userName, SUM(price*amount) AS '총구매액',
      CASE  
         WHEN (SUM(price*amount)  >= 1500) THEN '최우수고객'
         WHEN (SUM(price*amount)  >= 1000) THEN '우수고객'
         WHEN (SUM(price*amount) >= 1 ) THEN '일반고객'
         ELSE '유령고객'
      END AS '고객등급'
   FROM buyTBL B
      RIGHT OUTER JOIN userTBL U
         ON B.userID = U.userID
   GROUP BY U.userID, U.userName 
   ORDER BY sum(price*amount) DESC ;


-- WHILE 문, ITERATE/LEAVE 문

WHILE <불식> DO 
       SQL 명령문들 … 
END WHILE;

-- p.284

-- (1)
DROP PROCEDURE IF EXISTS whileProc; 
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT; -- 1에서 100까지 증가할 변수
	DECLARE hap INT; -- 더한 값을 누적할 변수
   SET i = 1;
   SET hap = 0;

	WHILE (i <= 100) DO
		SET hap = hap + i;  -- hap의 원래의 값에 i를 더해서 다시 hap에 넣으라는 의미
		SET i = i + 1;      -- i의 원래의 값에 1을 더해서 다시 i에 넣으라는 의미
	END WHILE;

	SELECT hap;   
END $$
DELIMITER ;
CALL whileProc();

-- (2)
DROP PROCEDURE IF EXISTS whileProc2; 
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
   DECLARE i INT; -- 1에서 100까지 증가할 변수
   DECLARE hap INT; -- 더한 값을 누적할 변수
   SET i = 1;
   SET hap = 0;

   myWhile: WHILE (i <= 100) DO  -- While문에 label을 지정
	  IF (i%7 = 0) THEN
	   	SET i = i + 1;     
		   ITERATE myWhile; -- 지정한 label문으로 가서 계속 진행
	  END IF;
        
      SET hap = hap + i; 
      IF (hap > 1000) THEN 
		   LEAVE myWhile; -- 지정한 label문을 떠남. 즉, While 종료.
	   END IF;
      SET i = i + 1;
   END WHILE;

   SELECT hap;   
END $$
DELIMITER ;
CALL whileProc2();

-- p.285
-- 오류처리

-- (1)
DROP PROCEDURE IF EXISTS errorProc; 
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
   DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없어요ㅠㅠ' AS '메시지';
   -- DECLARE CONTINUE HANDLER FOR SQLSTATE'42S02' SELECT '테이블이 없어요ㅠㅠ' AS '메시지';    
   SELECT * FROM noTable;  -- noTable은 없음.  
END $$
DELIMITER ;
CALL errorProc();

-- (2)
DROP PROCEDURE IF EXISTS errorProc2; 
DELIMITER $$
CREATE PROCEDURE errorProc2()
BEGIN
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
   BEGIN
	   SHOW ERRORS; -- 오류 메시지를 보여 준다.
	   SELECT '오류가 발생했네요. 작업은 취소시켰습니다.' AS '메시지'; 
	   ROLLBACK; -- 오류 발생시 작업을 롤백시킨다.
   END;
   INSERT INTO userTBL VALUES('YJS', '윤정수', 1988, '서울', NULL, 
		NULL, 170, CURRENT_DATE()); -- 중복되는 아이디이므로 오류 발생
END $$
DELIMITER ;
CALL errorProc2();

-- p.287
-- 동적 SQL

-- (1)
use cookDB;
PREPARE myQuery FROM 'SELECT * FROM userTBL WHERE userID = "NHS"';
EXECUTE myQuery;
DEALLOCATE PREPARE myQuery;

-- (2)
USE cookDB;
DROP TABLE IF EXISTS myTable;
CREATE TABLE myTable (id INT AUTO_INCREMENT PRIMARY KEY, mDate DATETIME);

SET @curDATE = CURRENT_TIMESTAMP(); -- 현재 날짜와 시간

PREPARE myQuery FROM 'INSERT INTO myTable VALUES(NULL, ?)';
EXECUTE myQuery USING @curDATE;
DEALLOCATE PREPARE myQuery;

SELECT * FROM myTable;

-- 연습문제
-- p.292

-- (9)
DROP PROCEDURE IF EXISTS caseProc; 
DELIMITER $$
CREATE PROCEDURE caseProc( )
BEGIN
	DECLARE myData SMALLINT; 
	SET myData = -1000;  
    
    CASE 
	WHEN myData > 0 THEN
		SELECT '양수입니다.';
	WHEN myData < 0 THEN
		SELECT '음수입니다.';
	ELSE
		SELECT '0입니다.';
    END CASE;
END $$
DELIMITER ;
CALL caseProc( );

-- (10)
DROP PROCEDURE IF EXISTS whileProc; 
DELIMITER $$
CREATE PROCEDURE whileProc( )
BEGIN
	DECLARE i INT; 
	DECLARE hap INT; 
    SET i = 12345;
    SET hap = 0;

	WHILE (i <= 67890) DO
		IF i%1234 = 0 THEN
			SET hap = hap + i;  
		END IF;
		SET i = i + 1;      
	END WHILE;

	SELECT hap;   
END $$
DELIMITER ;
CALL whileProc( );
