/* 04장 */

-- p.124 쿼리 창 활용하기 

USE employees;
SELECT * FROM employees;

use shopDB;
select * from membertbl;

USE ShopDB;
CREATE TABLE test (id INT);

USE ShopDB;
CREATE TABLE test (id INT);
INSERT INTO test VALUES(1);

USE employees;
SELECT * FROM employees;

-- p.134
-- MySQL 사용자 생성하고 권한 부여하기 

-- p.139 
-- (1)
CREATE DATABASE sampleDB;
DROP DATABASE sampleDB;

-- (2)
USE ShopDB;
SELECT * FROM membertbl;

-- (3)
DELETE FROM membertbl;

-- p.140

-- (1)
USE ShopDB;
SELECT * FROM memberTBL;
DELETE FROM memberTBL WHERE memberID = 'Gorden';

-- (2)
DROP TABLE memberTBL;

-- (3)
USE employees;
SELECT * FROM employees;

-- p.142
-- 쇼핑몰 데이터베이스 백업 후 복원하기ALTER

-- p.143
USE ShopDB;
SELECT * FROM productTBL;

-- p.145
DELETE FROM productTBL;

SELECT * FROM productTBL;

USE sys; -- 일단 다른 DB를 선택함

-- p.146
USE ShopDB;
SELECT * FROM productTBL;

