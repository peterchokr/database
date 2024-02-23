/* 10장 */

-- <실습> 제약조건으로 자동 생성되는 인덱스 확인하기
-- p.345

-- (1)
USE cookDB;
CREATE TABLE  TBL1
	(	a INT PRIMARY KEY,
		b INT,
		c INT
	);

SHOW INDEX FROM TBL1;

-- (2)
CREATE TABLE  TBL2
	(	a INT PRIMARY KEY,
		b INT UNIQUE,
		c INT UNIQUE,
		d INT
	);
SHOW INDEX FROM TBL2;

-- p.350

CREATE TABLE  TBL3
	(	a INT UNIQUE,
		b INT UNIQUE,
		c INT UNIQUE,
		d INT
	);
SHOW INDEX FROM TBL3;

-- p.351

-- (1)
CREATE TABLE  TBL4
	(	a INT UNIQUE NOT NULL,
		b INT UNIQUE ,
		c INT UNIQUE,
		d INT
	);
SHOW INDEX FROM TBL4;

-- (2)
CREATE TABLE  TBL5
	(	a INT UNIQUE NOT NULL,
		b INT UNIQUE ,
		c INT UNIQUE,
		d INT PRIMARY KEY
	);
SHOW INDEX FROM TBL5;

-- p.352

CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID  char(8) NOT NULL PRIMARY KEY, 
  userName    varchar(10) NOT NULL,
  birthYear   int NOT NULL,
  addr	  char(2) NOT NULL 
 );

INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울');
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남');
SELECT * FROM userTBL;

ALTER TABLE userTBL DROP PRIMARY KEY ;
ALTER TABLE userTBL 
	ADD CONSTRAINT pk_userName PRIMARY KEY(userName);
SELECT * FROM userTBL;

-- p.359

CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS clusterTBL;
CREATE TABLE clusterTBL
( userID  char(8) ,
  userName    varchar(10) 
);
INSERT INTO clusterTBL VALUES('YJS', '유재석');
INSERT INTO clusterTBL VALUES('KHD', '강호동');
INSERT INTO clusterTBL VALUES('KKJ', '김국진');
INSERT INTO clusterTBL VALUES('KYM', '김용만');
INSERT INTO clusterTBL VALUES('KJD', '김제동');
INSERT INTO clusterTBL VALUES('NHS', '남희석');
INSERT INTO clusterTBL VALUES('SDY', '신동엽');
INSERT INTO clusterTBL VALUES('LHJ', '이휘재');
INSERT INTO clusterTBL VALUES('LKK', '이경규');
INSERT INTO clusterTBL VALUES('PSH', '박수홍');

SELECT * FROM clusterTBL;

-- p.360

ALTER TABLE clusterTBL
	ADD CONSTRAINT PK_clusterTBL_userID
		PRIMARY KEY (userID);

SELECT * FROM clusterTBL;

-- p.362

CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS secondaryTBL;
CREATE TABLE secondaryTBL
( userID  char(8),
  userName    varchar(10)
);
INSERT INTO secondaryTBL VALUES('YJS', '유재석');
INSERT INTO secondaryTBL VALUES('KHD', '강호동');
INSERT INTO secondaryTBL VALUES('KKJ', '김국진');
INSERT INTO secondaryTBL VALUES('KYM', '김용만');
INSERT INTO secondaryTBL VALUES('KJD', '김제동');
INSERT INTO secondaryTBL VALUES('NHS', '남희석');
INSERT INTO secondaryTBL VALUES('SDY', '신동엽');
INSERT INTO secondaryTBL VALUES('LHJ', '이휘재');
INSERT INTO secondaryTBL VALUES('LKK', '이경규');
INSERT INTO secondaryTBL VALUES('PSH', '박수홍');

ALTER TABLE secondaryTBL
	ADD CONSTRAINT UK_secondaryTBL_userID
		UNIQUE (userID);

SELECT * FROM secondaryTBL;

-- p.364
INSERT INTO clusterTBL VALUES('KKK', '크크크');
INSERT INTO clusterTBL VALUES('MMM', '마마무');

-- p.365
INSERT INTO secondaryTBL VALUES('KKK', '크크크');
INSERT INTO secondaryTBL VALUES('MMM', '마마무');

-- 인덱스 생성하고 활용하기

-- p.369

USE cookDB;
SELECT * FROM userTBL;

SHOW INDEX FROM userTBL;

-- p.370
CREATE INDEX idx_userTBL_addr 
   ON userTBL (addr);

SHOW INDEX FROM userTBL;

--
CREATE UNIQUE INDEX idx_userTBL_birtyYear
	ON userTBL (birthYear);

--
CREATE UNIQUE INDEX idx_userTBL_userName
	ON userTBL (userName);

SHOW INDEX FROM userTBL;

-- p.371
INSERT INTO userTBL VALUES('GHD', '강호동', 1988, '미국', NULL  , NULL  , 172, NULL);

--
CREATE INDEX idx_userTBL_userName_birthYear
	ON userTBL (userName,birthYear);
DROP INDEX idx_userTBL_userName ON userTBL;

SHOW INDEX FROM userTBL ;

--
SELECT * FROM userTBL WHERE userName = '신동엽' and birthYear = '1971';

--
SELECT * FROM userTBL WHERE userName = '신동엽';

-- p.372
CREATE INDEX idx_userTBL_mobile1
	ON userTBL (mobile1);

SELECT * FROM userTBL WHERE mobile1 = '011';

--
SHOW INDEX FROM userTBL ;

--
DROP INDEX idx_userTBL_addr ON userTBL;
DROP INDEX idx_userTBL_userName_birthYear ON userTBL;
DROP INDEX idx_userTBL_mobile1 ON userTBL;

SHOW INDEX FROM userTBL ;

-- p.373
ALTER TABLE userTBL DROP INDEX idx_userTBL_addr;
ALTER TABLE userTBL DROP INDEX idx_userTBL_userName_birthYear;
ALTER TABLE userTBL DROP INDEX idx_userTBL_mobile1;

--
ALTER TABLE userTBL DROP PRIMARY KEY;

SHOW INDEX FROM userTBL ;

--
SELECT table_userName, constraint_userName
    FROM information_schema.referential_constraints
    WHERE constraint_schema = 'cookDB';
ALTER TABLE buyTbl DROP FOREIGN KEY 제약조건이름;

-- p.374

SELECT userName, birthYear, addr FROM userTBL WHERE userID = 'KHD';

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

CREATE TABLE userTBL 
( userID  CHAR(8) NULL UNIQUE , 
  userName    VARCHAR(10) NOT NULL, 
  birthYear   INT NOT NULL,  
  addr	  CHAR(2) NOT NULL,
  mobile1	CHAR(3) NULL, 
  mobile2   CHAR(8) NULL, 
  height    SMALLINT NULL, 
  mDate    DATE NULL 
);
