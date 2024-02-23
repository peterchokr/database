/* 09장 */

-- <실습> SQL을 이용해서 테이블을 생성하자.
-- p.295

USE mysql;
DROP DATABASE IF EXISTS ShopDB;
DROP DATABASE IF EXISTS ModelDB;
DROP DATABASE IF EXISTS cookDB;
DROP DATABASE IF EXISTS movieDB;

CREATE DATABASE tableDB;

-- p.296

-- (1)
USE tableDB;
DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL -- 회원 테이블
( userID  CHAR(8), -- 사용자 아이디
  userName    VARCHAR(10), -- 이름
  birthYear   INT,  -- 출생년도
  addr	  CHAR(2), -- 지역(경기,서울,경남 등으로 글자만 입력)
  mobile1	CHAR(3), -- 휴대폰의국번(011, 016, 017, 018, 019, 010 등)
  mobile2   CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈 제외)
  height    SMALLINT,  -- 키
  mDate    DATE  -- 회원 가입일
) ;
CREATE TABLE buyTBL -- 구매 테이블
(  num INT, -- 순번(PK)
   userID  CHAR(8),-- 아이디(FK)
   prodName CHAR(6), -- 물품명
   groupName CHAR(4) , -- 분류
   price     INT , -- 단가
   amount    SMALLINT -- 수량
) ;

-- (2)
USE tableDB;
DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL , 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr	  CHAR(2) NOT NULL,
  mobile1	CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height    SMALLINT NULL, 
  mDate    DATE NULL 
);
CREATE TABLE buyTBL 
(  num INT NOT NULL , 
   userID  CHAR(8) NOT NULL ,
   prodName CHAR(6) NOT NULL,
   groupName CHAR(4) NULL , 
   price     INT  NOT NULL,
   amount    SMALLINT  NOT NULL 
);

-- p.298

DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr	  CHAR(2) NOT NULL,
  mobile1	CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height    SMALLINT NULL, 
  mDate    DATE NULL 
);
CREATE TABLE buyTBL 
(  num INT NOT NULL PRIMARY KEY, 
   userID  CHAR(8) NOT NULL ,
   prodName CHAR(6) NOT NULL,
   groupName CHAR(4) NULL , 
   price     INT  NOT NULL,
   amount    SMALLINT  NOT NULL 
);

-- p.299
-- (1)
DROP TABLE IF EXISTS buyTBL;
CREATE TABLE buyTBL 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   userID  CHAR(8) NOT NULL ,
   prodName CHAR(6) NOT NULL,
   groupName CHAR(4) NULL , 
   price     INT  NOT NULL,
   amount    SMALLINT  NOT NULL 
);

-- (2)
DROP TABLE IF EXISTS buyTBL;
CREATE TABLE buyTBL 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 	
   prodName CHAR(6) NOT NULL,
   groupName CHAR(4) NULL , 
   price     INT  NOT NULL,
   amount    SMALLINT  NOT NULL 
  , FOREIGN KEY(userID) REFERENCES userTBL(userID)
);

-- (3)
INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');

INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);

-- p.300

INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울', '010', '44444444', 177, '2015-5-5');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남', NULL , NULL      , 173, '2013-3-3');
INSERT INTO userTBL VALUES('NHS', '남희석', 1971, '충남', '016', '66666666', 180, '2017-4-4');
INSERT INTO userTBL VALUES('SDY', '신동엽', 1971, '경기', NULL , NULL      , 176, '2008-10-10');
INSERT INTO userTBL VALUES('LHJ', '이휘재', 1972, '경기', '011', '88888888', 180, '2006-4-4');
INSERT INTO userTBL VALUES('LKK', '이경규', 1960, '경남', '018', '99999999', 170, '2004-12-12');
INSERT INTO userTBL VALUES('PSH', '박수홍', 1970, '서울', '010', '00000000', 183, '2012-5-5');

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

SELECT * FROM userTBL;
SELECT * FROM buyTBL;

-- 기본키 제약 조건
-- p.302

-- (1)
USE tableDB;
DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL
);

-- (2)
DESCRIBE userTBL;

-- (3)
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL, 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  CONSTRAINT PRIMARY KEY PK_userTBL_userID (userID)
);

-- (4) p.303
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
(   userID  CHAR(8) NOT NULL, 
    userName    VARCHAR(10) NOT NULL, 
    birthYear   INT NOT NULL
);
ALTER TABLE userTBL
	ADD CONSTRAINT PK_userTBL_userID 
        PRIMARY KEY (userID);

-- p.304

-- (1)
DROP TABLE IF EXISTS prodTbl;
CREATE TABLE prodTbl
( prodCode CHAR(3) NOT NULL,
  prodID   CHAR(4)  NOT NULL,
  prodDate  DATETIME  NOT NULL,
  prodState  CHAR(10) NULL
);
ALTER TABLE prodTbl
	ADD CONSTRAINT PK_prodTbl_proCode_prodID 
	PRIMARY KEY (prodCode, prodID) ;

-- (2)
DROP TABLE IF EXISTS prodTbl;
CREATE TABLE prodTbl
( prodCode CHAR(3) NOT NULL,
  prodID   CHAR(4)  NOT NULL,
  prodDate DATETIME  NOT NULL,
  prodState  CHAR(10) NULL,
  CONSTRAINT PK_prodTbl_proCode_prodID 
	PRIMARY KEY (prodCode, prodID) 
);

-- (3)
SHOW INDEX FROM prodtbl;

-- p.305

DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL 
);
CREATE TABLE buyTBL 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   FOREIGN KEY(userID) REFERENCES userTBL(userID)
);

-- p.306

-- (1)
DROP TABLE IF EXISTS buyTBL;
CREATE TABLE buyTBL 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL,
   CONSTRAINT FK_userTBL_buyTBL FOREIGN KEY(userID) REFERENCES userTBL(userID)
);

-- (2)
DROP TABLE IF EXISTS buyTBL;
CREATE TABLE buyTBL 
(  num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
   userID  CHAR(8) NOT NULL, 
   prodName CHAR(6) NOT NULL 
);
ALTER TABLE buyTBL
    ADD CONSTRAINT FK_userTBL_buyTBL 
    FOREIGN KEY (userID) 
    REFERENCES userTBL(userID);

SHOW INDEX FROM prodtbl;

-- p.307

ALTER TABLE buyTBL
	DROP FOREIGN KEY FK_userTBL_buyTBL; -- 외래 키 제거
ALTER TABLE buyTBL
	ADD CONSTRAINT FK_userTBL_buyTBL
	FOREIGN KEY (userID)
	REFERENCES userTBL (userID)
	ON UPDATE CASCADE;

-- UNIQUE 제약 조건

-- p.307
USE tableDB;
DROP TABLE IF EXISTS buyTBL, userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL PRIMARY KEY, 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL  UNIQUE
);

-- p.308
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID  CHAR(8) NOT NULL PRIMARY KEY,
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  email   CHAR(30) NULL ,  
  CONSTRAINT AK_email  UNIQUE (email)
);

-- DEFAULT 제약 조건

-- p.308

DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID  	CHAR(8) NOT NULL PRIMARY KEY,  
  userName    	VARCHAR(10) NOT NULL, 
  birthYear	int NOT NULL DEFAULT -1,
  addr	  	CHAR(2) NOT NULL DEFAULT '서울',
  mobile1	CHAR(3) NULL, 
  mobile2	CHAR(8) NULL, 
  height	smallint NULL DEFAULT 170, 
  mDate    	date NULL
);

-- p.309

-- (1)
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID	CHAR(8) NOT NULL PRIMARY KEY,  
  userName	VARCHAR(10) NOT NULL, 
  birthYear	int NOT NULL ,
  addr		CHAR(2) NOT NULL,
  mobile1	CHAR(3) NULL, 
  mobile2	CHAR(8) NULL, 
  height	smallint NULL, 
  mDate	date NULL 
);
ALTER TABLE userTBL
	ALTER COLUMN birthYear SET DEFAULT -1;
ALTER TABLE userTBL
	ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE userTBL
	ALTER COLUMN height SET DEFAULT 170;

-- (2)
-- 입력 데이터가 default 이면 DEFAULT로 설정된 값을 자동 입력한다.
INSERT INTO userTBL VALUES ('YBJ', '유병재', default, default, '010', '12345678', default, '2019.12.12');
-- 열이름이 명시되지 않으면 DEFAULT로 설정된 값을 자동 입력한다
INSERT INTO userTBL(userID, userName) VALUES('PNR', '박나래');
-- 값이 직접 명기되면 DEFAULT로 설정된 값은 무시된다.
INSERT INTO userTBL VALUES ('WB', '원빈', 1982, '대전', '010', '98765432', 176, '2020.5.5');

SELECT * FROM userTBL;

-- 테이블 압축
-- p.311

-- (1)
CREATE DATABASE IF NOT EXISTS compressDB;
USE compressDB;
CREATE TABLE normalTBL( emp_no INT , first_name VARCHAR(14));
CREATE TABLE compressTBL( emp_no INT , first_name VARCHAR(14))
	ROW_FORMAT=COMPRESSED ;

INSERT INTO normalTbl 
     SELECT emp_no, first_name FROM employees.employees;   
INSERT INTO compressTBL 
     SELECT emp_no, first_name FROM employees.employees;

SHOW TABLE STATUS FROM compressDB;

-- (2)
DROP DATABASE IF EXISTS compressDB;

-- 임시 테이블
-- p.314 

-- (1)
USE employees;
CREATE TEMPORARY TABLE  IF NOT EXISTS  tempTBL (id INT, userName CHAR(5));
CREATE TEMPORARY TABLE  IF NOT EXISTS employees (id INT, userName CHAR(5));
DESCRIBE tempTBL;
DESCRIBE employees;

-- (2)
INSERT INTO tempTBL VALUES (1, 'Cook');
INSERT INTO employees VALUES (2, 'MySQL');
SELECT * FROM tempTBL;
SELECT * FROM employees;

-- (3)
USE employees;
SELECT * FROM tempTBL;
SELECT * FROM employees;

-- (4)
USE employees;
SELECT * FROM employees;

-- 열 추가
-- p.317
USE tableDB;
ALTER TABLE userTBL
	ADD homepage VARCHAR(30)  -- 열추가
		DEFAULT 'http://www.hanbit.co.kr' -- 디폴트값
		NULL; -- Null 허용함

-- 열 삭제
-- p.318
ALTER TABLE userTBL
	DROP COLUMN mobile1;

-- 열 이름 및 데이터 형식 변경
ALTER TABLE userTBL
	CHANGE COLUMN userName uName VARCHAR(20) NULL ;

-- 열의 제약 조건 추가 및 삭제
ALTER TABLE userTBL
	DROP PRIMARY KEY; 

-- 뷰

-- p.328

USE tableDB;
CREATE VIEW v_userTBL
AS
	SELECT userID, userName, addr FROM userTBL;

SELECT * FROM v_userTBL;  -- 뷰를 테이블이라고 생각해도 무방

-- p.329

-- (1)
SELECT U.userID, U.userName, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
FROM userTBL U
  INNER JOIN buyTBL B
     ON U.userID = B.userID ;

-- (2)
CREATE VIEW v_userbuyTBL
AS
SELECT U.userID, U.userName, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
FROM userTBL U
	INNER JOIN buyTBL B
	 ON U.userID = B.userID ;

SELECT * FROM v_userbuyTBL WHERE userName = '강호동';


