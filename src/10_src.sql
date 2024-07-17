/* 10장 */

-- p.348
-- 제약조건으로 자동 생성되는 인덱스 확인하기

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
-- (3)
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
-- 클러스터형 인덱스의 정렬 확인하기

-- (1)
CREATE DATABASE IF NOT EXISTS testDB;
USE testDB;
DROP TABLE IF EXISTS userTBL;
CREATE TABLE userTBL 
( userID  char(8) NOT NULL PRIMARY KEY, 
  userName    varchar(10) NOT NULL,
  birthYear   int NOT NULL,
  addr	  char(2) NOT NULL 
 );

-- (2)
INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울');
INSERT INTO userTBL VALUES('KYM', '김용만', 1967, '서울');
INSERT INTO userTBL VALUES('KJD', '김제동', 1974, '경남');
SELECT * FROM userTBL;

-- (3)
ALTER TABLE userTBL DROP PRIMARY KEY ;
ALTER TABLE userTBL 
	ADD CONSTRAINT pk_userName PRIMARY KEY(userName);
SELECT * FROM userTBL;

-- p.355 
-- 인덱스의 내부 작동

-- p.359
-- 클러스터형 인덱스와 보조 인덱스의 구조

-- 클러스터 인덱스

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
-- 보조 인덱스

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

