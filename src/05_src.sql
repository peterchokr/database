/* 05장 */
-- p.155

USE employees;

USE mysql;
SELECT * FROM employees;

SELECT * FROM titles ;

SELECT * FROM employees.titles;

SELECT * FROM employees.titles;
SELECT * FROM titles;

SELECT first_name FROM employees;

SELECT first_name, last_name, gender FROM employees;

-- 한줄 주석 연습
-- p.158

SELECT first_name, last_name, gender -- 이름과 성별 열을 가져옴
FROM employees;

/* 블록 주석 연습
SELECT first_name, last_name, gender
FROM employees;
*/

-- <실습> 데이터베이스 이름, 테이블 이름, 필드 이름이 정확히 기억나지 않거나, 또는 각 이름의 철자가 확실하지 않을 때 찾아서 조회하는 방법을 실습하자. 

SHOW DATABASES;

USE employees;

SHOW TABLES;

DESCRIBE employees; -- 또는 DESC employees;

SELECT first_name, gender FROM employees LIMIT 10;

-- </실습> 
-- p.161

SELECT first_name AS 이름 , gender 성별, hire_date '회사 입사일'
FROM employees;



-- <실습> 앞으로 책의 전 과정에서 사용할 [그림 5-12]와 동일한 cookDB 데이터베이스와 테이블을 생성하자. 
-- p.163

DROP DATABASE IF EXISTS cookDB; -- 만약 cookDB가 존재하면 우선 삭제한다.
CREATE DATABASE cookDB;

USE cookDB;
CREATE TABLE userTBL -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  userName    	VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 키
  mDate    	DATE  -- 회원 가입일
);
CREATE TABLE buyTBL -- 회원 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8) NOT NULL, -- 아이디(FK)
   prodName 	CHAR(6) NOT NULL, --  물품명
   groupName 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 단가
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES userTBL(userID)
);

-- p.165
-- (1)

INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 177, '2015-5-5');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남', NULL , NULL      , 173, '2013-3-3');
INSERT INTO userTBL VALUES('NHS', '남희석', 1971, '충남', '016', '66666666', 180, '2017-4-4');
INSERT INTO userTBL VALUES('SDY', '신동엽', 1971, '경기', NULL , NULL      , 176, '2008-10-10');
INSERT INTO userTBL VALUES('LHJ', '이휘재', 1972, '경기', '011', '88888888', 180, '2006-4-4');
INSERT INTO userTBL VALUES('LKK', '이경규', 1960, '경남', '018', '99999999', 170, '2004-12-12');
INSERT INTO userTBL VALUES('PSH', '박수홍', 1970, '서울', '010', '00000000', 183, '2012-5-5');

INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '모니터', '전자', 200,  5);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '청바지', '의류', 50,   3);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '메모리', '전자', 80,  10);
INSERT INTO buyTBL VALUES(NULL, 'KJD', '책'    , '서적', 15,   5);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '청바지', '의류', 50,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'LHJ', '책'    , '서적', 15,   1);
INSERT INTO buyTBL VALUES(NULL, 'PSH', '운동화', NULL   , 30,   2);

-- (2)
SELECT * FROM userTBL;
SELECT * FROM buyTBL;

-- </실습> 

/*
source  C:\SQL\cookDB.sql
exit
*/

-- where 절
-- p.168

USE  cookDB;
SELECT * FROM userTBL;

SELECT * FROM userTBL WHERE userName = '강호동';

-- 조건 연산자와 관계 연산자

SELECT userID, userName FROM userTBL WHERE birthYear >= 1970 AND height >= 182;

SELECT userID, userName FROM userTBL WHERE birthYear >= 1970 OR height >= 182;

-- p.169
-- BETWEEN .. AND, IN(), LIK 연산자

SELECT userName, height FROM userTBL WHERE height >= 180 AND height <= 182;

SELECT userName, height FROM userTBL WHERE height BETWEEN 180 AND 182;

SELECT userName, addr FROM userTBL WHERE addr='경남' OR  addr='충남' OR addr='경북';

SELECT userName, addr FROM userTBL WHERE addr IN ('경남','충남','경북');

SELECT userName, height FROM userTBL WHERE userName LIKE '김%';

SELECT userName, height FROM userTBL WHERE userName LIKE '_경규';

-- p.170
-- 서브쿼리와 ANY, ALL, SOMW 연산자

SELECT userName, height FROM userTBL WHERE height  > 177;

SELECT userName, height FROM userTBL 
   WHERE height > (SELECT height FROM userTBL WHERE userName = '김용만');

--
SELECT userName, height FROM userTBL 
   WHERE height >= (SELECT height FROM userTBL WHERE addr = '경기');  -- 오류 발생

--
SELECT userName, height FROM userTBL 
   WHERE height >= ANY (SELECT height FROM userTBL WHERE addr = '경기');

SELECT userName, height FROM userTBL 
   WHERE height >= ALL (SELECT height FROM userTBL WHERE addr = '경기');

--
SELECT userName, height FROM userTBL 
   WHERE height = ANY (SELECT height FROM userTBL WHERE addr = '경기');

SELECT userName, height FROM userTBL 
  WHERE height IN (SELECT height FROM userTBL WHERE addr = '경기');

-- p.172
-- ORDER BY 절

SELECT userName, mDate FROM userTBL ORDER BY mDate;

SELECT userName, mDate FROM userTBL ORDER BY mDate DESC;

SELECT userName, height FROM userTBL ORDER BY height DESC, userName ASC;

-- p.173
-- DISTINCT 키워드

SELECT addr FROM userTBL;

SELECT addr FROM userTBL ORDER BY addr;

SELECT DISTINCT addr FROM userTBL;

-- p.174
-- LIMIT 절

USE employees;
SELECT emp_no, hire_date FROM employees 
   ORDER BY hire_date ASC;

SELECT emp_no, hire_date FROM employees 
   ORDER BY hire_date ASC
   LIMIT 5;

SELECT emp_no, hire_date FROM employees 
   ORDER BY hire_date ASC
   LIMIT 0, 5;  -- LIMIT 5 OFFSET 0 과 동일

-- p.175
-- CREATE TABLE .. SELECT 절

USE cookDB;
CREATE TABLE buyTBL2 (SELECT * FROM buyTBL);
SELECT * FROM buyTBL2;

CREATE TABLE buyTBL3 (SELECT userID, prodName FROM buyTBL);
SELECT * FROM buyTBL3;

-- p.177
-- GROUP BY 절

USE cookDB;
SELECT userID, amount FROM buyTBL ORDER BY userID;

SELECT userID, SUM(amount) FROM buyTBL GROUP BY userID;

--
SELECT userID AS '사용자 아이디', SUM(amount) AS '총 구매 개수'  
   FROM buyTBL GROUP BY userID;

SELECT userID AS '사용자 아이디', SUM(price*amount) AS '총 구매액'  
   FROM buyTBL GROUP BY userID;

-- p.179
-- 집계함수

USE cookDB;
SELECT AVG(amount) AS '평균 구매 개수' FROM buyTBL ;

SELECT userID, AVG(amount) AS '평균 구매 개수' 
   FROM buyTBL  GROUP BY userID;

--
SELECT userName, MAX(height), MIN(height) FROM userTBL;

SELECT userName, MAX(height), MIN(height) 
   FROM userTBL GROUP BY userName;

SELECT userName, height
   FROM userTBL 
   WHERE height = (SELECT MAX(height)FROM userTBL) 
       OR height = (SELECT MIN(height)FROM userTBL) ;

--
SELECT COUNT(*) FROM userTBL;

SELECT COUNT(mobile1) AS '휴대폰이 있는 사용자' FROM userTBL;

-- p.181
-- HAVING 절

USE cookDB;
SELECT userID AS '사용자', SUM(price*amount) AS '총구매액'  
   FROM buyTBL 
   GROUP BY userID ;

--
SELECT userID AS '사용자', SUM(price*amount) AS '총구매액'  
   FROM buyTBL 
   WHERE SUM(price*amount) > 1000   -- 집계함수는 WHERE 절에 사용할 수 없다.
   GROUP BY userID ;

SELECT userID AS '사용자', SUM(price*amount) AS '총구매액'  
   FROM buyTBL 
   GROUP BY userID
   HAVING SUM(price*amount) > 1000 ;

SELECT userID AS '사용자', SUM(price*amount) AS '총구매액'  
   FROM buyTBL 
   GROUP BY userID
   HAVING SUM(price*amount) > 1000 
   ORDER BY SUM(price*amount) ;

-- p.182
-- WITH ROLLUP 절

SELECT num, groupName, SUM(price * amount) AS '비용' 
   FROM buyTBL
   GROUP BY  groupName, num
   WITH ROLLUP;

SELECT groupName, SUM(price * amount) AS '비용' 
   FROM buyTBL
   GROUP BY  groupName
   WITH ROLLUP;