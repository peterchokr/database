-- ============================================
-- MySQL INNER JOIN 실습 예제 - 쇼핑몰 서비스
-- ============================================

-- 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

-- ============================================
-- 1. 테이블 생성
-- ============================================

-- 회원 테이블
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    join_date DATE
);

-- 카테고리 테이블
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);

-- 상품 테이블
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10, 2),
    stock INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 주문 테이블
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 주문상세 테이블
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================
-- 2. 샘플 데이터 삽입
-- ============================================

-- 회원 데이터
INSERT INTO users (user_name, email, join_date) VALUES
('김철수', 'kim@email.com', '2024-01-15'),
('이영희', 'lee@email.com', '2024-02-20'),
('박민수', 'park@email.com', '2024-03-10'),
('최지은', 'choi@email.com', '2024-04-05'),
('정태양', 'jung@email.com', '2024-05-12');

-- 카테고리 데이터
INSERT INTO categories (category_name) VALUES
('전자제품'),
('의류'),
('식품'),
('도서'),
('스포츠');

-- 상품 데이터
INSERT INTO products (product_name, category_id, price, stock) VALUES
('무선 이어폰', 1, 89000, 50),
('블루투스 스피커', 1, 120000, 30),
('청바지', 2, 59000, 100),
('티셔츠', 2, 25000, 150),
('초콜릿 세트', 3, 35000, 80),
('커피 원두', 3, 18000, 60),
('프로그래밍 입문서', 4, 32000, 40),
('소설책', 4, 15000, 70),
('요가 매트', 5, 45000, 35),
('덤벨 세트', 5, 95000, 20);

-- 주문 데이터
INSERT INTO orders (user_id, order_date, total_amount) VALUES
(1, '2024-06-01', 178000),
(2, '2024-06-03', 84000),
(1, '2024-06-05', 120000),
(3, '2024-06-07', 77000),
(4, '2024-06-10', 140000),
(2, '2024-06-12', 32000),
(5, '2024-06-15', 95000);

-- 주문상세 데이터
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 89000),
(2, 3, 1, 59000),
(2, 4, 1, 25000),
(3, 2, 1, 120000),
(4, 5, 1, 35000),
(4, 6, 2, 18000),
(4, 8, 1, 15000),
(5, 9, 2, 45000),
(5, 7, 1, 32000),
(6, 7, 1, 32000),
(7, 10, 1, 95000);

-- ============================================
-- 3. INNER JOIN 실습 예제
-- ============================================

-- [기초] 2개 테이블 조인
-- ============================================

-- 예제 1: 주문과 회원 정보 조회
-- 누가 어떤 주문을 했는지 확인
SELECT 
    o.order_id,
    u.user_name,
    u.email,
    o.order_date,
    o.total_amount
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
ORDER BY o.order_date;

-- 예제 2: 상품과 카테고리 정보 조회
-- 각 상품이 어떤 카테고리에 속하는지 확인
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.stock
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.product_name;

-- 예제 3: 주문상세와 상품 정보 조회
-- 주문된 상품의 상세 정보 확인
SELECT 
    oi.order_item_id,
    p.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS subtotal
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id;

-- [중급] 3개 테이블 조인
-- ============================================

-- 예제 4: 주문 + 회원 + 주문상세
-- 누가 무엇을 주문했는지 상세히 확인
SELECT 
    u.user_name,
    o.order_id,
    o.order_date,
    oi.order_item_id,
    oi.quantity,
    oi.price
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
ORDER BY u.user_name, o.order_date;

-- 예제 5: 주문상세 + 주문 + 상품
-- 어떤 주문에 어떤 상품이 포함되었는지 확인
SELECT 
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- 예제 6: 상품 + 카테고리 + 주문상세
-- 카테고리별로 어떤 상품이 얼마나 판매되었는지 확인
SELECT 
    c.category_name,
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, p.product_name
ORDER BY c.category_name, total_revenue DESC;

-- [고급] 4개 테이블 조인
-- ============================================

-- 예제 7: 전체 주문 정보 통합 조회
-- 회원 + 주문 + 주문상세 + 상품
SELECT 
    u.user_name,
    u.email,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_total
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date DESC, u.user_name;

-- [심화] 집계 함수와 함께 사용
-- ============================================

-- 예제 8: 회원별 총 구매 금액 (상위 5명)
SELECT 
    u.user_name,
    u.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_spent,
    AVG(oi.quantity * oi.price) AS avg_item_price
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.user_name, u.email
ORDER BY total_spent DESC
LIMIT 5;

-- ============================================
-- 4. 연습 문제 (스스로 풀어보기)
-- ============================================

-- 문제 1: 5만원 이상 주문한 회원의 이름과 이메일, 주문 금액을 조회하세요.
-- (힌트: users와 orders 조인 + WHERE 조건)

-- 문제 2: '의류' 또는 '스포츠' 카테고리에 속한 상품들을 조회하세요.
-- (힌트: products와 categories 조인 + WHERE IN)

-- 문제 3: 회원별로 주문한 총 상품 개수와 총 금액을 조회하세요.
-- (힌트: users, orders, order_items 조인 + GROUP BY)

-- 문제 4: 상품별로 몇 번 주문되었는지 주문 횟수를 조회하세요.
-- (힌트: products와 order_items 조인 + GROUP BY + COUNT)

-- 문제 5: '이영희' 회원이 구매한 상품의 상품명, 가격, 구매 수량을 조회하세요.
-- (힌트: users, orders, order_items, products 조인)