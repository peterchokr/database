-- =====================================================================
-- MySQL SQL 예제 : 스토어드 프로시저, IF, CASE, WHILE, 동적SQL, 트리거
-- =====================================================================

CREATE DATABASE IF NOT EXISTS ss_db;
USE ss_db;


-- 테이블 생성
CREATE TABLE users (user_id INT PRIMARY KEY AUTO_INCREMENT, user_name VARCHAR(50), email VARCHAR(100), join_date DATE);
CREATE TABLE categories (category_id INT PRIMARY KEY AUTO_INCREMENT, category_name VARCHAR(50));
CREATE TABLE products (product_id INT PRIMARY KEY AUTO_INCREMENT, product_name VARCHAR(100), category_id INT, price DECIMAL(10,2), stock INT);
CREATE TABLE orders (order_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, order_date DATE, total_amount DECIMAL(10,2));
CREATE TABLE order_items (order_item_id INT PRIMARY KEY AUTO_INCREMENT, order_id INT, product_id INT, quantity INT, price DECIMAL(10,2));

-- 데이터 입력
INSERT INTO users VALUES (1,'김철수','kim@email.com','2024-01-15'), (2,'이영희','lee@email.com','2024-02-20'), (3,'박민수','park@email.com','2024-03-10'), (4,'최지은','choi@email.com','2024-04-05'), (5,'정태양','jung@email.com','2024-05-12');
INSERT INTO categories VALUES (1,'전자제품'), (2,'의류'), (3,'식품'), (4,'도서'), (5,'스포츠');
INSERT INTO products VALUES (1,'무선 이어폰',1,89000,50), (2,'블루투스 스피커',1,120000,30), (3,'청바지',2,59000,100), (4,'티셔츠',2,25000,150), (5,'초콜릿 세트',3,35000,80), (6,'커피 원두',3,18000,60), (7,'프로그래밍 입문서',4,32000,40), (8,'소설책',4,15000,70), (9,'요가 매트',5,45000,35), (10,'덤벨 세트',5,95000,20);
INSERT INTO orders VALUES (1,1,'2024-06-01',178000), (2,2,'2024-06-03',84000), (3,1,'2024-06-05',120000), (4,3,'2024-06-07',77000), (5,4,'2024-06-10',140000), (6,2,'2024-06-12',32000), (7,5,'2024-06-15',95000);
INSERT INTO order_items VALUES (1,1,1,2,89000), (2,2,3,1,59000), (3,2,4,1,25000), (4,3,2,1,120000), (5,4,5,1,35000), (6,4,6,2,18000), (7,4,8,1,15000), (8,5,9,2,45000), (9,5,7,1,32000), (10,6,7,1,32000), (11,7,10,1,95000);


-- ============================================
-- 1. 스토어드 프로시저 (Stored Procedure)
-- ============================================

-- 예제 1: 사용자의 총 주문액 조회
DELIMITER $$
CREATE PROCEDURE GetUserTotal(IN p_user_id INT, OUT p_total DECIMAL(10,2))
BEGIN
    SELECT COALESCE(SUM(total_amount), 0) INTO p_total FROM orders WHERE user_id = p_user_id;
END$$
DELIMITER ;

CALL GetUserTotal(1, @total); SELECT @total;

-- 예제 2: 상품 정보와 재고 상태 반환
DELIMITER $$
CREATE PROCEDURE GetProductDetail(IN p_product_id INT)
BEGIN
    SELECT product_id, product_name, price, stock,
           CASE 
				WHEN stock = 0 THEN '품절' 
				WHEN stock < 20 THEN '부족' 
				ELSE '충분' 
           END AS status
    FROM products WHERE product_id = p_product_id;
END$$
DELIMITER ;

CALL GetProductDetail(1);


-- ============================================
-- 2. IF 문 (조건문)
-- ============================================

-- 예제 1: 배송료 계산
DELIMITER $$
CREATE PROCEDURE CalcShipping(IN p_amount DECIMAL(10,2), OUT p_shipping DECIMAL(10,2))
BEGIN
    IF p_amount >= 100000 THEN SET p_shipping = 0;
		ELSEIF p_amount >= 50000 THEN SET p_shipping = 2500;
		ELSE SET p_shipping = 5000;
    END IF;
END$$
DELIMITER ;

CALL CalcShipping(75000, @fee); SELECT @fee;

-- 예제 2: 회원등급 판정
DELIMITER $$
CREATE PROCEDURE GetMemberGrade(IN p_user_id INT, OUT p_grade VARCHAR(20))
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT COALESCE(SUM(total_amount), 0) INTO v_total FROM orders WHERE user_id = p_user_id;
    IF v_total >= 300000 THEN SET p_grade = 'Gold';
		ELSEIF v_total >= 100000 THEN SET p_grade = 'Silver';
		ELSE SET p_grade = 'Bronze';
    END IF;
END$$
DELIMITER ;

CALL GetMemberGrade(1, @grade); SELECT @grade;


-- ============================================
-- 3. CASE 문 (다중 선택)
-- ============================================

-- 예제 1: 가격대별 분류
DELIMITER $$
CREATE PROCEDURE ProductsByPrice(IN p_category INT)
BEGIN
    SELECT product_id, product_name, price,
           CASE 
				WHEN price < 30000 THEN '저가'
                WHEN price < 80000 THEN '중가'
                ELSE '고가' 
		   END AS category
    FROM products WHERE category_id = p_category;
END$$
DELIMITER ;

CALL ProductsByPrice(1);

-- 예제 2: 주문액별 할인율
DELIMITER $$
CREATE PROCEDURE CalcDiscount(IN p_order_id INT, OUT p_discount INT)
BEGIN
    DECLARE v_amount DECIMAL(10,2);
    SELECT total_amount INTO v_amount FROM orders WHERE order_id = p_order_id;
    SET p_discount = CASE
        WHEN v_amount >= 150000 THEN 15
        WHEN v_amount >= 100000 THEN 10
        WHEN v_amount >= 50000 THEN 5
        ELSE 0 
        END;
END$$
DELIMITER ;

CALL CalcDiscount(1, @disc); SELECT @disc;


-- ============================================
-- 4. WHILE 문 (반복문)
-- ============================================

-- 예제 1: 숫자 생성
CREATE TABLE test_loop (num INT);

DELIMITER $$
CREATE PROCEDURE GenerateNum(IN p_count INT)
BEGIN
    DECLARE v_i INT DEFAULT 1;
    WHILE v_i <= p_count DO
        INSERT INTO test_loop VALUES (v_i);
        SET v_i = v_i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL GenerateNum(5); SELECT * FROM test_loop;

-- 예제 2: 카테고리별 상품 개수 집계
CREATE TABLE category_stats (category_id INT, product_count INT);

DELIMITER $$
CREATE PROCEDURE CountByCategory()
BEGIN
    DECLARE v_cat INT DEFAULT 1;
    DECLARE v_count INT;
    WHILE v_cat <= 5 DO
        SELECT COUNT(*) INTO v_count FROM products WHERE category_id = v_cat;
        INSERT INTO category_stats VALUES (v_cat, v_count);
        SET v_cat = v_cat + 1;
    END WHILE;
END$$
DELIMITER ;

CALL CountByCategory(); SELECT * FROM category_stats;


-- ============================================
-- 5. 동적 SQL (Dynamic SQL)
-- ============================================

-- 예제 1: 상품명 검색
DELIMITER $$
CREATE PROCEDURE SearchProduct(IN p_name VARCHAR(100))
BEGIN
    SET @query = 'SELECT * FROM products WHERE product_name LIKE ?';
    SET @search_term = CONCAT('%', p_name, '%');
    PREPARE stmt FROM @query;
    EXECUTE stmt USING @search_term;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

CALL SearchProduct('이어폰');

-- 예제 2: 가격 범위로 검색
DELIMITER $$
CREATE PROCEDURE SearchByPrice(IN p_min INT, IN p_max INT)
BEGIN
    DECLARE v_sql VARCHAR(500);
    SET @v_sql = 'SELECT * FROM products WHERE 1=1';
    IF p_min > 0 THEN SET @v_sql = CONCAT(@v_sql, ' AND price >= ', p_min); END IF;
    IF p_max > 0 THEN SET @v_sql = CONCAT(@v_sql, ' AND price <= ', p_max); END IF;
    PREPARE stmt FROM @v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

CALL SearchByPrice(50000, 100000);

-- ============================================
-- 6. 트리거(TRIGGER)
-- ============================================

-- 주문 항목(order_items)이 삽입될 때 자동으로 해당 상품의 재고를 감소시키는  AFTER INSERT 트리거
-- 트리거명: trg_update_stock_on_order

DELIMITER $$
CREATE TRIGGER trg_update_stock_on_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

-- 테스트: 
-- 트리거 생성 후 order_items에 데이터를 삽입하면 자동으로 products의 stock이 감소한다.
INSERT INTO order_items VALUES (13, 8, 5, 1, 45000);
SELECT * FROM products WHERE product_id = 5;
