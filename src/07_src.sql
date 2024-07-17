/* 07장 */
-- p.220
-- 숫자 데이터 형식
-- 문자 데이터 형식
-- 날짜와 시간 데이터 형식

-- p.223 (1)
-- 시스템에 설정된 문자세트 확인

SHOW VARIABLES LIKE 'character_set_system';

-- p.223 (2)
SELECT CAST('2020-10-19 12:35:29.123' AS DATE) AS 'DATE' ;
SELECT CAST('2020-10-19 12:35:29.123' AS TIME) AS 'TIME' ;
SELECT CAST('2020-10-19 12:35:29.123' AS DATETIME) AS 'DATETIME' ; 

-- p.225 
-- 변수와 형 변환

SET @변수이름 = 변수값; -- 변수 선언 및 값 대입 
SELECT @변수이름; -- 변수 값 출력

-- <실습> 변수 사용하기 

-- cookDB.sql 파일을 실행하여 초기화
-- p.226

-- (1)
USE cookDB;
SET @myVar1 = 5 ;
SET @myVar2 = 3 ;
SET @myVar3 = 4.25 ;
SET @myVar4 = 'MC 이름==> ' ;
SELECT @myVar1 ;
SELECT @myVar2 + @myVar3 ;
SELECT @myVar4 , userName FROM userTBL WHERE height > 180 ;

-- (2)

SET @myVar1 = 3 ;
PREPARE myQuery 
    FROM 'SELECT userName, height FROM userTBL ORDER BY height LIMIT ?';
EXECUTE myQuery USING @myVar1 ;

-- p.227
-- 데이터 형식과 형 변환
CAST(expression AS 데이터형식 [(길이)]) 
CONVERT(expression, 데이터형식 [(길이)])

-- (1)
USE cookDB ;
SELECT AVG(amount) AS '평균 구매 개수' FROM buyTBL ;

SELECT CAST(AVG(amount) AS SIGNED INTEGER) AS '평균 구매 개수'  FROM buyTBL ;
SELECT CONVERT(AVG(amount) , SIGNED INTEGER) AS '평균 구매 개수'  FROM buyTBL ;

-- (2)
SELECT CAST('2020$12$12' AS DATE);
SELECT CAST('2020/12/12' AS DATE);
SELECT CAST('2020%12%12' AS DATE);
SELECT CAST('2020@12@12' AS DATE);

-- p.228
SELECT num, CONCAT(CAST(price AS CHAR(10)), 'X', CAST(amount AS CHAR(4)) ,'=' )  AS '단가X수량',
	price*amount AS '구매액' 
  FROM buyTBL ;

-- 암시적 형 변환

SELECT '100' + '200' ; -- 문자와 문자를 더함 (정수로 변환되서 연산됨)
SELECT CONCAT('100', '200'); -- 문자와 문자를 연결 (문자로 처리)
SELECT CONCAT(100, '200'); -- 정수와 문자를 연결 (정수가 문자로 변환되서 처리)
SELECT 1 > '3mega'; -- 정수인 3으로 변환되어서 비교
SELECT 4 > '3MEGA'; -- 정수인 3으로 변환되어서 비교
SELECT 0 = 'mega3'; -- 문자는 0으로 변환됨

-- p.230
-- 내장함수

-- 제어 흐름 함수

SELECT IF (100>200, '참이다', '거짓이다'); 

SELECT IFNULL(NULL, '널이군요'), IFNULL(100, '널이군요');

SELECT NULLIF(100,100), IFNULL(200,100);

SELECT 	CASE 10
		WHEN 1  THEN  '일'
		WHEN 5  THEN  '오'
		WHEN 10 THEN  '십' 
		ELSE '모름'
END;

-- p.231
-- 문자열 함수

SELECT ASCII('A'), CHAR(65);

SELECT BIT_LENGTH('abc'),  CHAR_LENGTH('abc'), LENGTH('abc');
SELECT BIT_LENGTH('가나다'),  CHAR_LENGTH('가나다'), LENGTH('가나다');

SELECT CONCAT_WS('/', '2020', '01', '01');

-- p.232

SELECT ELT(2, '하나', '둘', '셋'), FIELD('둘', '하나', '둘', '셋'), FIND_IN_SET('둘', '하나,둘,셋'), INSTR('하나둘셋', '둘'), LOCATE('둘', '하나둘셋');

SELECT FORMAT(123456.123456, 4);

SELECT BIN(31), HEX(31), OCT(31);

SELECT INSERT('abcdefghi', 3, 4, '@@@@'), INSERT('abcdefghi', 3, 2, '@@@@');

-- p.233

SELECT LEFT('abcdefghi', 3), RIGHT('abcdefghi', 3);

SELECT LOWER('abcdEFGH'), UPPER('abcdEFGH');

SELECT LPAD('쿡북', 5, '##'), RPAD('쿡북', 5, '##');

SELECT LTRIM('   쿡북'), RTRIM('쿡북   ');

SELECT TRIM('   쿡북   '), TRIM(BOTH 'ㅋ' FROM 'ㅋㅋㅋ재미있어요.ㅋㅋㅋ');

SELECT REPEAT('쿡북', 3);

-- p.234

SELECT REPLACE ('IT 쿡북 MySQL', '쿡북' , 'CookBook');

SELECT REVERSE ('MySQL');

SELECT CONCAT('IT', SPACE(10), 'CookBook MySQL');

SELECT SUBSTRING('대한민국만세', 3, 2);

SELECT SUBSTRING_INDEX('www.mysql.com', '.', 2),  SUBSTRING_INDEX('www.mysql.com', '.', -2);

-- 수학함수
-- p.235

SELECT ABS(-100);

SELECT CEILING(4.7), FLOOR(4.7), ROUND(4.7);

SELECT CONV('AA', 16, 2), CONV(100, 10, 8);

SELECT DEGREES(PI()), RADIANS(180);

SELECT MOD(157, 10), 157 % 10, 157 MOD 10;

SELECT POW(2,3), SQRT(9);

-- p.236 

SELECT RAND(), FLOOR(1 + (RAND() * (6-1)));

SELECT SIGN(100), SIGN(0), SIGN(-100.123);

SELECT TRUNCATE(12345.12345, 2), TRUNCATE(12345.12345, -2);

-- 날짜/시간 함수
-- p.237

SELECT ADDDATE('2020-01-01', INTERVAL 31 DAY), ADDDATE('2020-01-01', INTERVAL 1 MONTH);
SELECT SUBDATE('2020-01-01', INTERVAL 31 DAY), SUBDATE('2020-01-01', INTERVAL 1 MONTH);

SELECT ADDTIME('2020-01-01 23:59:59', '1:1:1'), ADDTIME('15:00:00', '2:10:10');
SELECT SUBTIME('2020-01-01 23:59:59', '1:1:1'), SUBTIME('15:00:00', '2:10:10');

SELECT YEAR(CURDATE()), MONTH(CURRENT_DATE()), DAYOFMONTH(CURRENT_DATE);
SELECT HOUR(CURTIME()), MINUTE(CURRENT_TIME()), SECOND(CURRENT_TIME), MICROSECOND(CURRENT_TIME);

SELECT DATE(NOW()), TIME(NOW());

SELECT DATEDIFF('2023-01-01', NOW()), TIMEDIFF('23:23:59', '12:11:10');

-- p.238

SELECT DAYOFWEEK(CURDATE()), MONTHNAME(CURDATE()), DAYOFYEAR(CURDATE());

SELECT LAST_DAY('2020-02-01');

SELECT MAKEDATE(2020, 32);

SELECT MAKETIME(12, 11, 10);

SELECT PERIOD_ADD(202001, 11), PERIOD_DIFF(202001, 201812);

SELECT QUARTER('2020-07-07');

SELECT TIME_TO_SEC('12:11:10');

-- 시스템 정보 함수
-- p.239

SELECT CURRENT_USER(), DATABASE();

USE cookDB;
SELECT * FROM userTBL;
SELECT FOUND_ROWS();

USE cookDB;
UPDATE buyTBL SET price=price*2;
SELECT ROW_COUNT();

SELECT SLEEP(5);
SELECT '5초후에 이게 보여요';



-- JSON 데이터
-- p.242

-- (1)
USE cookDB;
SELECT JSON_OBJECT('name', userName, 'height', height) AS 'JSON 값'
	FROM userTBL 
    WHERE height >= 180;

-- (2)
SET @json='{ "userTBL" :
  [
	{"name":"강호동","height":182},
	{"name":"이휘재","height":180},
	{"name":"남희석","height":180},
	{"name":"박수홍","height":183}
  ]
}' ;
SELECT JSON_VALID(@json) AS JSON_VALID;
SELECT JSON_SEARCH(@json, 'one', '남희석') AS JSON_SEARCH;
SELECT JSON_EXTRACT(@json, '$.userTBL[2].name') AS JSON_EXTRACT;
SELECT JSON_INSERT(@json, '$.userTBL[0].mDate', '2019-09-09') AS JSON_INSERT;
SELECT JSON_REPLACE(@json, '$.userTBL[0].name', '토마스') AS JSON_REPLACE;
SELECT JSON_REMOVE(@json, '$.userTBL[0]') AS JSON_REMOVE;

-- 대용량 데이터 저장
-- <실습> [그림 7-13]의 영화사이트 데이터베이스를 구축하자.
-- p.243

-- (1)
CREATE DATABASE movieDB;

USE movieDB;
CREATE TABLE movieTBL 
  (movie_id        INT,
   movie_title     VARCHAR(30),
   movie_director  VARCHAR(20),
   movie_star      VARCHAR(20),
   movie_script    LONGTEXT,
   movie_film      LONGBLOB
) DEFAULT CHARSET=utf8mb4;

INSERT INTO movieTBL VALUES ( 1, '쉰들러 리스트', '스필버그', '리암 니슨',  
	LOAD_FILE('C:/SQL/Movies/Schindler.txt'), LOAD_FILE('C:/SQL/Movies/Schindler.mp4') );

SELECT * FROM movieTBL;


-- (2)
SHOW variables LIKE 'max_allowed_packet';

SHOW variables LIKE 'secure_file_priv';

/*
CD %PROGRAMDATA%
CD MySQL
CD "MySQL Server 8.0"
DIR

NOTEPAD my.ini 
max_allowed_packet=1024M

NOTEPAD my.ini 
secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads" 
secure-file-priv="C:/SQL/Movies"

NET STOP MySQL
NET START MySQL
*/

-- (3)
USE movieDB;
TRUNCATE movieTBL;

INSERT INTO movieTBL VALUES ( 1, '쉰들러 리스트', '스필버그', '리암 니슨',  
	LOAD_FILE('C:/SQL/Movies/Schindler.txt'), LOAD_FILE('C:/SQL/Movies/Schindler.mp4') );
INSERT INTO movieTBL VALUES ( 2, '쇼생크 탈출', '프랭크 다라본트', '팀 로빈스',  
	LOAD_FILE('C:/SQL/Movies/Shawshank.txt'), LOAD_FILE('C:/SQL/Movies/Shawshank.mp4') );    
INSERT INTO movieTBL VALUES ( 3, '라스트 모히칸', '마이클 만', '다니엘 데이 루이스',
	LOAD_FILE('C:/SQL/Movies/Mohican.txt'), LOAD_FILE('C:/SQL/Movies/Mohican.mp4') );
SELECT * FROM movieTBL;

-- (4)
SELECT movie_script FROM movieTBL WHERE movie_id=1 
	INTO OUTFILE 'C:/SQL/Movies/Schindler_out.txt'  
	LINES TERMINATED BY '\\n';

SELECT movie_film FROM movieTBL WHERE movie_id=3 
	INTO DUMPFILE 'C:/SQL/Movies/Mohican_out.mp4';
