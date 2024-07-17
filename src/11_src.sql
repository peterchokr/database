/* 11장 */

-- p.383
-- 스토어드 프로시저

USE cookDB;
DROP PROCEDURE IF EXISTS userProc;

DELIMITER $$
CREATE PROCEDURE userProc()
BEGIN
    SELECT * FROM userTBL; -- 스토어드 프로시저 내용
END $$
DELIMITER ;

CALL userProc();

-- p.385
-- 스토어드 프로시저를 생성하고 활용하기 

-- cookDB.sql을 실행하여 cookDB 초기화

-- 입력매개 변수가 있는 스토어드 프로시저 실행하기
-- (1)
USE cookDB;
DROP PROCEDURE IF EXISTS userProc1;

DELIMITER $$
CREATE PROCEDURE userProc1(IN uName VARCHAR(10))
BEGIN
  SELECT * FROM userTBL WHERE userName= uName; 
END $$
DELIMITER ;

CALL userProc1('이경규');

-- p.386
-- (2)
DROP PROCEDURE IF EXISTS userProc2;
DELIMITER $$
CREATE PROCEDURE userProc2(
    IN userBirth INT, 
    IN userHeight INT
)
BEGIN
  SELECT * FROM userTBL 
    WHERE birthYear > userBirth AND height > userHeight;
END $$
DELIMITER ;

CALL userProc2(1970, 178);

-- 출력매개 변수가 있는 스토어드 프로세저 실행하기

DROP PROCEDURE IF EXISTS userProc3;
DELIMITER $$
CREATE PROCEDURE userProc3(
    IN txtValue CHAR(10),
    OUT outValue INT
)
BEGIN
  INSERT INTO testTBL VALUES(NULL,txtValue);
  SELECT MAX(id) INTO outValue FROM testTBL; 
END $$
DELIMITER ;

CREATE TABLE IF NOT EXISTS testTBL(
    id INT AUTO_INCREMENT PRIMARY KEY, 
    txt CHAR(10)
);

CALL userProc3 ('테스트값', @myValue);
SELECT CONCAT('현재 입력된 ID 값 ==>', @myValue);

-- p.387
-- 스토어드 프로시저 안에 SQL 프로그래밍하기

-- (1) IF문
DROP PROCEDURE IF EXISTS ifelseProc;
DELIMITER $$
CREATE PROCEDURE ifelseProc(
    IN uName VARCHAR(10)
)
BEGIN
    DECLARE bYear INT; -- 변수 선언
    SELECT birthYear into bYear FROM userTBL
        WHERE userName= uName;
    IF (bYear >= 1970) THEN
            SELECT '아직 젊군요..';
    ELSE
            SELECT '나이가 지긋하네요..';
    END IF;
END $$
DELIMITER ;

CALL ifelseProc ('김국진');

-- p.388

-- (2) CASE문
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc(
    IN uName VARCHAR(10)
)
BEGIN
    DECLARE bYear INT; 
    DECLARE tti  CHAR(3);-- 띠
    SELECT birthYear INTO bYear FROM userTBL
        WHERE userName= uName;
    CASE 
        WHEN ( bYear%12 = 0) THEN    SET tti = '원숭이';
        WHEN ( bYear%12 = 1) THEN    SET tti = '닭';
        WHEN ( bYear%12 = 2) THEN    SET tti = '개';
        WHEN ( bYear%12 = 3) THEN    SET tti = '돼지';
        WHEN ( bYear%12 = 4) THEN    SET tti = '쥐';
        WHEN ( bYear%12 = 5) THEN    SET tti = '소';
        WHEN ( bYear%12 = 6) THEN    SET tti = '호랑이';
        WHEN ( bYear%12 = 7) THEN    SET tti = '토끼';
        WHEN ( bYear%12 = 8) THEN    SET tti = '용';
        WHEN ( bYear%12 = 9) THEN    SET tti = '뱀';
        WHEN ( bYear%12 = 10) THEN    SET tti = '말';
        ELSE SET tti = '양';
    END CASE;
    SELECT CONCAT(uName, '의 띠 ==>', tti);
END $$
DELIMITER ;

CALL caseProc ('박수홍');

-- (3) WHILE 문
DROP TABLE IF EXISTS guguTBL;
CREATE TABLE guguTBL (txt VARCHAR(100)); -- 구구단 저장용 테이블

DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    DECLARE str VARCHAR(100); -- 각 단을 문자열로 저장
    DECLARE i INT; -- 구구단 앞자리
    DECLARE k INT; -- 구구단 뒷자리
    SET i = 2; -- 2단부터 계산
    
    WHILE (i < 10) DO  -- 바깥 반복문. 2단~9단까지.
        SET str = ''; -- 각 단의 결과를 저장할 문자열 초기화
        SET k = 1; -- 구구단 뒷자리는 항상 1부터 9까지.
        WHILE (k < 10) DO
            SET str = CONCAT(str, '  ', i, 'x', k, '=', i*k); -- 문자열 만들기
            SET k = k + 1; -- 뒷자리 증가
        END WHILE;
        SET i = i + 1; -- 앞자리 증가
        INSERT INTO guguTBL VALUES(str); -- 각 단의 결과를 테이블에 입력.
    END WHILE;
END $$
DELIMITER ;

CALL whileProc();
SELECT * FROM guguTBL;

-- p.389
-- 스토어드 프로시저 오류 처리하기

DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
    DECLARE i INT; -- 1씩 증가하는 값
    DECLARE hap INT; -- 합계 (정수형) 오버플로 발생시킬 예정
    DECLARE saveHap INT; -- 합계 (정수형) 오버플로 직전의 값을 저장

    DECLARE EXIT HANDLER FOR 1264 -- INT형 오버플로가 발생하면 이 부분 수행
    BEGIN
        SELECT CONCAT('INT 오버플로 직전의 합계 --> ', saveHap);
        SELECT CONCAT('1+2+3+4+...+',i ,'=오버플로');
    END;
    
    SET i = 1; -- 1부터 증가
    SET hap = 0; -- 합계를 누적
    
    WHILE (TRUE) DO  -- 무한 루프.
        SET saveHap = hap; -- 오버플로 직전의 합계를 저장
        SET hap = hap + i;  -- 오버플로가 나면 11, 12행을 수행함
        SET i = i + 1; 
    END WHILE;
END $$
DELIMITER ;

CALL errorProc();

-- p.390
-- 현재 저장된 프로시저의 이름과 내용 확인하기

-- (1)
SELECT routine_name, routine_definition FROM INFORMATION_SCHEMA.ROUTINES
    WHERE routine_schema = 'cookDB' AND routine_type = 'PROCEDURE';

-- p.391
-- (2) information_schema 데이터베이스의 parameters 테이블을 조회하면 프로시저의 매개변수를 볼 수 있다.
SELECT ORDINAL_POSITION, PARAMETER_MODE, PARAMETER_NAME, DTD_IDENTIFIER
  FROM information_schema.parameters
  WHERE SPECIFIC_SCHEMA = 'cookdb' AND SPECIFIC_NAME='userProc3';

-- (3) 스토어드 프로시저의 내용을 볼 수 있는 또 다른 방법
SHOW CREATE PROCEDURE cookDB.whileProc;

-- 테이블 이름을 입력 매개변수로 전달하기

-- (1) 테이블 이름을 직접 입력 매개변수로 전달할 수 없다. -> Error
DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(
    IN tableName VARCHAR(20)
)
BEGIN
 SELECT * FROM tableName;
END $$
DELIMITER ;

CALL nameProc ('userTBL');

-- p.392
-- (2) 동적 SQL을 활용해야 한다.
DROP PROCEDURE IF EXISTS nameProc;
DELIMITER $$
CREATE PROCEDURE nameProc(
    IN tableName VARCHAR(20)
)
BEGIN
  SET @sqlQuery = CONCAT('SELECT * FROM ', tableName);
  PREPARE myQuery FROM @sqlQuery;
  EXECUTE myQuery;
  DEALLOCATE PREPARE myQuery;
END $$
DELIMITER ;

CALL nameProc ('userTBL');

-- p.392
-- 스토어드 프로시저의 장점

-- p.395
-- 스토어드 함수

-- p.396
-- (1) 스토어드 함수를 생성하려면 log_bin_trust_function_creators를 ON으로 변경해야.
SET GLOBAL log_bin_trust_function_creators = 1;

-- (2)
USE cookDB;
DROP FUNCTION IF EXISTS userFunc;
DELIMITER $$
CREATE FUNCTION userFunc(value1 INT, value2 INT)
    RETURNS INT
BEGIN
    RETURN value1 + value2;
END $$
DELIMITER ;

SELECT userFunc(100, 200);

-- p.397
-- 스토어드 함수 사용하기

-- (1) CookDB 초기화하기

-- (2) 출생연도를 입력하면 나이가 출력되는 함수
USE cookDB;
DROP FUNCTION IF EXISTS getAgeFunc;
DELIMITER $$
CREATE FUNCTION getAgeFunc(bYear INT)
    RETURNS INT
BEGIN
    DECLARE age INT;
    SET age = YEAR(CURDATE()) - bYear;
    RETURN age;
END $$
DELIMITER ;

-- p.398

-- (1)
SELECT getAgeFunc(1979);

-- (2)
SELECT getAgeFunc(1979) INTO @age1979;
SELECT getAgeFunc(1997) INTO @age1989;
SELECT CONCAT('1997년과 1979년의 나이차 ==> ', (@age1979-@age1989));

-- (3)
SELECT userID, userName, getAgeFunc(birthYear) AS '만 나이' FROM userTBL;

-- (4) 스토어드 함수의 이름과 내용을 확인
SHOW CREATE FUNCTION getAgeFunc;

-- (5) 스토어드 함수를 삭제
DROP FUNCTION getAgeFunc;

-- p.399
-- 커서 

-- p.400 
-- 커서 활용하기

DROP PROCEDURE IF EXISTS cursorProc;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN
    DECLARE userHeight INT; -- 고객의 키
    DECLARE cnt INT DEFAULT 0; -- 고객의 인원 수(=읽은 행의 수)
    DECLARE totalHeight INT DEFAULT 0; -- 키의 합계
    
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; -- 행의 끝 여부(기본을 FALSE)

    DECLARE userCuror CURSOR FOR-- 커서 선언
        SELECT height FROM userTBL;

    DECLARE CONTINUE HANDLER -- 행의 끝이면 endOfRow 변수에 TRUE를 대입 
        FOR NOT FOUND SET endOfRow = TRUE;

    OPEN userCuror;  -- 커서 열기

    cursor_loop: LOOP
        FETCH  userCuror INTO userHeight; -- 고객 키 1개를 대입

        IF endOfRow THEN -- 더이상 읽을 행이 없으면 Loop를 종료
            LEAVE cursor_loop;
        END IF;

        SET cnt = cnt + 1;
        SET totalHeight = totalHeight + userHeight;        
    END LOOP cursor_loop;
    
    -- 고객 키의 평균을 출력한다.
    SELECT CONCAT('고객 키의 평균 ==> ', (totalHeight/cnt));
    
    CLOSE userCuror;  -- 커서 닫기
END $$
DELIMITER ;

CALL cursorProc();

-- p.402
-- 고객 등급을 분류하는 스토어드 프로시저 작성하기

USE cookDB;
ALTER TABLE userTBL ADD grade VARCHAR(5);  -- 고객 등급 열 추가

DROP PROCEDURE IF EXISTS gradeProc;
DELIMITER $$
CREATE PROCEDURE gradeProc()
BEGIN
    DECLARE id VARCHAR(10); -- 사용자 아이디를 저장할 변수
    DECLARE hap BIGINT; -- 총 구매액을 저장할 변수
    DECLARE userGrade CHAR(5); -- 고객 등급 변수

    DECLARE endOfRow BOOLEAN DEFAULT FALSE; 

    DECLARE userCuror CURSOR FOR-- 커서 선언
        SELECT U.userid, sum(price*amount)
            FROM buyTBL B
                RIGHT OUTER JOIN userTBL U
                ON B.userid = U.userid
            GROUP BY U.userid, U.userName ;

    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET endOfRow = TRUE;

    OPEN userCuror;  -- 커서 열기
    grade_loop: LOOP
        FETCH  userCuror INTO id, hap; -- 첫 행 값을 대입
        IF endOfRow THEN
            LEAVE grade_loop;
        END IF;

        CASE  
            WHEN (hap >= 1500) THEN SET userGrade = '최우수고객';
            WHEN (hap  >= 1000) THEN SET userGrade ='우수고객';
            WHEN (hap >= 1) THEN SET userGrade ='일반고객';
            ELSE SET userGrade ='유령고객';
         END CASE;
        
        UPDATE userTBL SET grade = userGrade WHERE userID = id;
    END LOOP grade_loop;
    
    CLOSE userCuror;  -- 커서 닫기
END $$
DELIMITER ;

CALL gradeProc();
SELECT * FROM userTBL;

-- p.404 
-- 트리거 생성하고 작동 확인하기

-- cookDB 초기화하기

-- p.405
-- (1)
USE cookDB;
CREATE TABLE IF NOT EXISTS testTBL (id INT, txt VARCHAR(10));
INSERT INTO testTBL VALUES(1, '이엑스아이디');
INSERT INTO testTBL VALUES(2, '블랙핑크');
INSERT INTO testTBL VALUES(3, '에이핑크');

-- (2)
DROP TRIGGER IF EXISTS testTrg;
DELIMITER // 
CREATE TRIGGER testTrg  -- 트리거 이름
    AFTER  DELETE -- 삭제후에 작동하도록 지정
    ON testTBL -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
	SET @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행시 작동되는 코드들
END // 
DELIMITER ;

-- (3)
SET @msg = '';
INSERT INTO testTBL VALUES(4, '여자친구');
SELECT @msg;
UPDATE testTBL SET txt = '레드벨벳' WHERE id = 3;
SELECT @msg;
DELETE FROM testTBL WHERE id = 4;
SELECT @msg;

-- p.407
-- AFTER 트리거 생성하고 작동 확인하기
-- 회원 테이블에 데이터 변경(삽입, 수정, 삭제) 작업을 시도하면 별도의 테이블에 기록하는 트리거 만들기

-- (1) 백업 테이블 생성
USE cookDB;
DROP TABLE buyTBL; -- 구매테이블은 실습에 필요없으므로 삭제.
CREATE TABLE backup_userTBL
( userID  char(8) NOT NULL, 
  userName   varchar(10) NOT NULL, 
  birthYear   int NOT NULL,  
  addr	  char(2) NOT NULL, 
  mobile1	char(3), 
  mobile2   char(8), 
  height    smallint,  
  mDate    date,
  modType  char(2), -- 변경된 타입. '수정' 또는 '삭제'
  modDate  date, -- 변경된 날짜
  modUser  varchar(256) -- 변경한 사용자
);

-- (2) 수정했을 때 작동하는 트리거를 생성
DROP TRIGGER IF EXISTS backUserTBL_UpdateTrg;
DELIMITER // 
CREATE TRIGGER backUserTBL_UpdateTrg  -- 트리거 이름
    AFTER UPDATE -- 변경 후에 작동하도록 지정
    ON userTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    INSERT INTO backup_userTBL VALUES( OLD.userID, OLD.userName, OLD.birthYear, 
        OLD.addr, OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate, 
        '수정', CURDATE(), CURRENT_USER() );
END // 
DELIMITER ;

-- p.408
-- (3) 삭제했을 때 작동하는 트리거를 생성
DROP TRIGGER IF EXISTS backUserTBL_DeleteTrg;
DELIMITER // 
CREATE TRIGGER backUserTBL_DeleteTrg  -- 트리거 이름
    AFTER DELETE -- 삭제 후에 작동하도록 지정
    ON userTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    INSERT INTO backup_userTBL VALUES( OLD.userID, OLD.userName, OLD.birthYear, 
        OLD.addr, OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate, 
        '삭제', CURDATE(), CURRENT_USER() );
END // 
DELIMITER ;

-- (4) 데이터를 수정, 삭제
UPDATE userTBL SET addr = '제주' WHERE userID = 'KJD';
DELETE FROM userTBL WHERE height >= 180;

-- (5) 백업 테이블 확인
SELECT * FROM backup_userTBL;

-- p.409
-- (6) TRUNCATE 문으로 테이블 삭제하기
TRUNCATE TABLE userTBL;

-- (8) 백업 테이블 확인
SELECT * FROM backup_userTBL;

-- (9) 삽입시 경고 메시지 보내도록 트리거 만들기
DROP TRIGGER IF EXISTS userTBL_InsertTrg;
DELIMITER // 
CREATE TRIGGER userTBL_InsertTrg  -- 트리거 이름
    AFTER INSERT -- 입력 후에 작동하도록 지정
    ON userTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '데이터의 입력을 시도했습니다. 귀하의 정보가 서버에 기록되었습니다.';
END // 
DELIMITER ;

-- p.410
-- (10) 삽입시 경고 메시지 출력
INSERT INTO userTBL VALUES('ABC', '에비씨', 1977, '서울', '011', '1111111', 181, '2019-12-25');

-- p.411
-- BEFORE 트리거 생성하고 작동 확인하기
-- 출생 연도가 1900년 미만이면 잘못 입력한 것으로 간주하여 0을 입력하고,
-- 출생연도가 올해를 초과하면 올해 연도로 변경하여 입력하는 트리거를 만들기

-- (1) BEFORE INSERT 트리거를 작성
USE cookDB;
DROP TRIGGER IF EXISTS userTBL_InsertTrg; -- 앞 실습의 트리거 제거
DROP TRIGGER IF EXISTS userTBL_BeforeInsertTrg;
DELIMITER // 
CREATE TRIGGER userTBL_BeforeInsertTrg  -- 트리거 이름
    BEFORE INSERT -- 입력 전에 작동하도록 지정
    ON userTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    IF NEW.birthYear < 1900 THEN
        SET NEW.birthYear = 0;
    ELSEIF NEW.birthYear > YEAR(CURDATE()) THEN
        SET NEW.birthYear = YEAR(CURDATE());
    END IF;
END // 
DELIMITER ;

-- (2) 데이터를 삽입하면 출생연도가 변경되어 있다.
INSERT INTO userTBL VALUES
  ('AAA', '에이', 1877, '서울', '011', '11112222', 181, '2019-12-25');
INSERT INTO userTBL VALUES
  ('BBB', '비이', 2977, '경기', '011', '11113333', 171, '2011-3-25');

SELECT * FROM userTBL;

-- p.412
-- (3) 생성된 트리거 확인
SHOW TRIGGERS FROM cookDB;

-- p.412
-- 다중 트리거와 중첩 트리거

-- p.413
-- 중첩 트리거 생성하고 작동 확인하기 

-- (1) 연습용 데이터베이스 생성
USE mysql;
DROP DATABASE IF EXISTS triggerDB;
CREATE DATABASE IF NOT EXISTS triggerDB;

-- p.414

-- (2) 테이블 생성
USE triggerDB;
CREATE TABLE orderTBL -- 구매 테이블
	    (orderNo INT AUTO_INCREMENT PRIMARY KEY, -- 구매 일련번호
        userID VARCHAR(5), -- 구매한 회원아이0디
        prodName VARCHAR(5), -- 구매한 물건
        orderamount INT );  -- 구매한 개수
CREATE TABLE prodTBL -- 물품 테이블
        (prodName VARCHAR(5), -- 물건 이름
        account INT ); -- 남은 물건수량
CREATE TABLE deliverTBL -- 배송 테이블
        (deliverNo  INT AUTO_INCREMENT PRIMARY KEY, -- 배송 일련번호
        prodName VARCHAR(5), -- 배송할 물건		  
        account INT UNIQUE); -- 배송할 물건개수

-- (3) 데이터 삽입
INSERT INTO prodTBL VALUES('사과', 100);
INSERT INTO prodTBL VALUES('배', 100);
INSERT INTO prodTBL VALUES('귤', 100);

-- (3) 중첩 트리거의 작동 확인하기

-- 구매 테이블에 삽입(INSERT) 작업이 발생하면 물품 테이블에서 개수를 감소시키는 트리거
DROP TRIGGER IF EXISTS orderTrg;
DELIMITER // 
CREATE TRIGGER orderTrg  -- 트리거 이름
    AFTER  INSERT 
    ON orderTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    UPDATE prodTBL SET account = account - NEW.orderamount 
        WHERE prodName = NEW.prodName ;
END // 
DELIMITER ;

-- 물품 테이블에 UPDATE가 발생하면 배송테이블에 새 배송 건을 입력하는 트리거
DROP TRIGGER IF EXISTS prodTrg;
DELIMITER // 
CREATE TRIGGER prodTrg  -- 트리거 이름
    AFTER  UPDATE 
    ON prodTBL -- 트리거를 부착할 테이블
    FOR EACH ROW 
BEGIN
    DECLARE orderAmount INT;
    -- 주문 개수 = (변경 전의 개수 - 변경 후의 개수)
    SET orderAmount = OLD.account - NEW.account;
    INSERT INTO deliverTBL(prodName, account)
        VALUES(NEW.prodName, orderAmount);
END // 
DELIMITER ;

-- p.415 

-- (4) 고객이 물건을 구매 
INSERT INTO orderTBL VALUES (NULL,'JOHN', '배', 5);

-- (5) 중첩 트리거가 작동하여 삽입-수정-삽입이 모두 성공한 것을 확인
SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;

-- p.416

-- (1) 배송 테이블의 열이름을 변경하여 삽입이 실패하도록.
ALTER TABLE deliverTBL CHANGE prodName productName VARCHAR(5);

-- (2) 물건을 구매 -> deliverTBL을 사용하는 UPDATE 트리거에서 작업 실패 발생
INSERT INTO orderTBL VALUES (NULL, 'DANG', '사과', 9);

-- (3) 롤백되어 데이터 변경이 없다.
SELECT * FROM orderTBL;
SELECT * FROM prodTBL;
SELECT * FROM deliverTBL;


