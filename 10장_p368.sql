-- p.368
-- <실습> 인덱스 생성하고 활용하기

-- cookDB.sql 파일 실행한다.

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
