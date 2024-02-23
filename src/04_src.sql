/* 04장 */

-- <실습> 내비게이터의 [Administration] 탭을 이용해서 MySQL을 관리해 보자  

-- </실습> 



-- <실습> 쿼리 창을 활용하는 방법을 연습하자. 

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

-- </실습> 



-- <실습> MySQL의 사용자 및 역할/권한을 관리하자. 

-- p.139 (1)
CREATE DATABASE sampleDB;
DROP DATABASE sampleDB;

-- p.139 (2)
USE ShopDB;
SELECT * FROM membertbl;

DELETE FROM membertbl;

-- p.140
USE ShopDB;
SELECT * FROM memberTBL;
DELETE FROM memberTBL WHERE memberID = 'Gorden';

DROP TABLE memberTBL;

USE employees;
SELECT * FROM employees;

-- </실습> 



-- <실습> 간단한 백업과 복원을 실습하자.
-- p.143

USE ShopDB;
SELECT * FROM productTBL;

DELETE FROM productTBL;

SELECT * FROM productTBL;

USE sys; -- 일단 다른 DB를 선택함

USE ShopDB;
SELECT * FROM productTBL;

-- </실습> 
