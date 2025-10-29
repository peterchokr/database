-- ============================================
-- MySQL OUTER JOIN 실습 예제 - 쇼핑몰 서비스
-- ============================================

-- 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS myshop;
USE myshop;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    email VARCHAR(50),
    registration_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    price INT,    
    total_amount INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price INT
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================
-- 샘플 데이터 삽입
-- ============================================

INSERT INTO customers VALUES
(1, '김철수', 'kim@email.com', '2024-01-15'),
(2, '이영희', 'lee@email.com', '2024-02-20'),
(3, '박민준', 'park@email.com', '2024-03-10'),
(4, '최수진', 'choi@email.com', '2024-04-05'),
(5, '정진호', 'jung@email.com', '2024-05-12'),
(6, '조은영', 'jo@email.com', '2024-06-01'),
(7, '황준석', 'hwang@email.com', '2024-07-08'),
(8, '송미경', 'song@email.com', '2024-08-15'),
(9, '강도현', 'kang@email.com', '2024-09-20'),
(10, '임하나', 'im@email.com', '2024-10-10');

INSERT INTO products VALUES
(1, '무선이어폰', '전자제품', 45000),
(2, '아이폰 케이스', '액세서리', 15000),
(3, '노트북', '전자제품', 800000),
(4, '마우스', '액세서리', 25000),
(5, '키보드', '액세서리', 65000),
(6, '모니터', '전자제품', 200000),
(7, '헤드폰', '전자제품', 120000),
(8, 'USB 허브', '액세서리', 35000),
(9, '노트북 가방', '가방', 50000),
(10, 'HDMI 케이블', '액세서리', 12000);

INSERT INTO orders VALUES
(1, 1, '2024-10-01', 45000, 1),
(2, 1, '2024-10-05', 15000, 1),
(3, 2, '2024-10-02', 800000, 1),
(4, 3, '2024-10-03', 90000, 1),
(5, 4, '2024-10-04', 65000, 1),
(6, 5, '2024-10-06', 200000, 1),
(7, 7, '2024-10-07', 120000, 1),
(8, 7, '2024-10-08', 35000, 1),
(9, 8, '2024-10-09', 50000, 1),
(10, 10, '2024-10-10', 57000, 1);

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 1),
(4, 4, 4, 1),
(5, 4, 5, 1),
(6, 5, 5, 1),
(7, 6, 6, 1),
(8, 7, 7, 1),
(9, 8, 8, 1),
(10, 9, 9, 1);

INSERT INTO reviews VALUES
(1, 1, 1, 5, '2024-10-02'),
(2, 3, 2, 4, '2024-10-06'),
(3, 4, 3, 5, '2024-10-08'),
(4, 1, 4, 4, '2024-10-05'),
(5, 5, 5, 5, '2024-10-10'),
(6, 2, 6, 3, '2024-10-09'),
(7, 6, 7, 5, '2024-10-11'),
(8, 7, 1, 4, '2024-10-12'),
(9, 9, 8, 5, '2024-10-13'),
(10, 4, 10, 4, '2024-10-14');


-- ═══════════════════════════════════════════════════════════════════
-- LEFT JOIN 예제
-- ═══════════════════════════════════════════════════════════════════

-- [LEFT 기초 1] 모든 고객과 각 고객의 주문 정보 (고객 기준으로 주문 정보 붙이기)
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- [LEFT 기초 2] 모든 고객과 고객의 평균 주문 갯수 (주문이 없는 고객도 0으로 표시)
SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(ROUND(AVG(o.total_amount), 0), 0) AS avg_order_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;

-- [LEFT 기초 3] 주문을 하지 않은 고객 찾기 (NULL 체크)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- [LEFT 기초 4] 각 고객별 주문 건수와 등록일자
SELECT 
    c.customer_id,
    c.customer_name,
    c.registration_date,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.registration_date
ORDER BY order_count DESC;

-- [LEFT 중급 1] 고객 - 주문 - 상품 연결 (3단계 LEFT JOIN)
SELECT 
    c.customer_name,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    (p.price * oi.quantity) AS item_total
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
ORDER BY c.customer_id, o.order_id;

-- [LEFT 중급 2] 각 고객의 구매 현황과 리뷰 작성 현황
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    COUNT(DISTINCT r.review_id) AS review_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN reviews r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- [LEFT 고급 1] 고객 세분화 분석 (구매 현황, 리뷰 활동, 충성도 판정)
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS purchase_count,
    COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
    COUNT(DISTINCT r.review_id) AS review_count,
    ROUND(COALESCE(AVG(r.rating), 0), 2) AS avg_rating,
    CASE 
        WHEN COUNT(DISTINCT o.order_id) = 0 THEN '미구매'
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN '신규'
        WHEN COUNT(DISTINCT o.order_id) < 5 THEN '일반'
        ELSE 'VIP'
    END AS customer_segment,
    CASE 
        WHEN COUNT(DISTINCT r.review_id) = 0 THEN '리뷰 미작성'
        WHEN COUNT(DISTINCT r.review_id) < COUNT(DISTINCT o.order_id) / 2 THEN '부분 작성'
        ELSE '활발히 작성'
    END AS review_activity
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN reviews r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;


-- ═══════════════════════════════════════════════════════════════════
-- RIGHT JOIN 예제
-- ═══════════════════════════════════════════════════════════════════

-- [RIGHT 기초 1] 모든 주문과 주문 고객의 정보
SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- [RIGHT 기초 2] 모든 주문과 함께 고객 이메일 조회
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    c.customer_name,
    c.email
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- [RIGHT 기초 3] 모든 주문 항목과 상품 정보
SELECT 
    oi.order_item_id,
    oi.order_id,
    p.product_id,
    p.product_name,
    oi.quantity,
    p.price
FROM products p
RIGHT JOIN order_items oi ON p.product_id = oi.product_id
ORDER BY oi.order_id;

-- [RIGHT 기초 4] 모든 리뷰와 함께 상품명 조회
SELECT 
    r.review_id,
    r.rating,
    r.review_date,
    p.product_id,
    p.product_name,
    p.category
FROM products p
RIGHT JOIN reviews r ON p.product_id = r.product_id
ORDER BY r.review_date DESC;

-- [RIGHT 중급 1] 모든 주문 항목과 고객 정보를 함께 조회 (주문 항목 기준)
SELECT 
    oi.order_item_id,
    o.order_id,
    c.customer_name,
    p.product_name,
    oi.quantity,
    p.price,
    (p.price * oi.quantity) AS line_total
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- [RIGHT 중급 2] 모든 리뷰와 함께 리뷰를 작성한 고객 정보 조회
SELECT 
    r.review_id,
    r.rating,
    r.review_date,
    c.customer_name,
    c.email,
    p.product_name
FROM customers c
RIGHT JOIN reviews r ON c.customer_id = r.customer_id
LEFT JOIN products p ON r.product_id = p.product_id
ORDER BY r.review_date DESC;

-- [RIGHT 고급 1] 주문 판매 분석 (우측 테이블 기준의 복합 RIGHT JOIN)
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(o.total_amount) AS monthly_revenue,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    ROUND(AVG(o.total_amount), 0) AS avg_order_value,
    CASE 
        WHEN SUM(o.total_amount) > 1000000 THEN '고성장'
        WHEN SUM(o.total_amount) > 500000 THEN '중성장'
        ELSE '저성장'
    END AS performance
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;


-- ═══════════════════════════════════════════════════════════════════
-- FULL OUTER JOIN 예제 (UNION으로 시뮬레이션)
-- ═══════════════════════════════════════════════════════════════════

-- [FULL 1] 고객 또는 주문 (어느 한쪽이라도 정보가 있으면 표시)
SELECT 
    COALESCE(c.customer_id, 0) AS customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT 
    o.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY customer_id;

-- [FULL 2] 상품 또는 주문 항목 (상품은 있지만 주문되지 않은 상품도 포함)
SELECT 
    p.product_id,
    p.product_name,
    oi.order_item_id,
    oi.quantity
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
UNION
SELECT 
    p.product_id,
    p.product_name,
    oi.order_item_id,
    oi.quantity
FROM products p
RIGHT JOIN order_items oi ON p.product_id = oi.product_id
ORDER BY product_id;


-- ═══════════════════════════════════════════════════════════════════
-- 퀴즈
-- ═══════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────
-- LEFT JOIN 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [LEFT 기초 퀴즈 1] 모든 고객과 각 고객의 주문 건수를 조회하세요. 주문이 없는 고객도 0으로 표시해야 합니다.


-- [LEFT 기초 퀴즈 2] 고객별 총 구매 금액을 계산하고, 가장 높은 금액부터 정렬하세요. 주문 없는 고객은 0으로 표시합니다.


-- [LEFT 중급 퀴즈 3] 고객이 구매한 상품 목록을 조회하세요. 고객명, 상품명, 구매 수량을 표시하고, 고객별로 정렬합니다.


-- [LEFT 중급 퀴즈 4] 각 고객이 구매한 총 금액과 작성한 리뷰 개수를 조회하세요. (주문이나 리뷰가 없어도 모든 고객이 나타나야 함)


-- ─────────────────────────────────────────────────────────────────
-- RIGHT JOIN 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [RIGHT 기초 퀴즈 1] 모든 주문을 조회하고, 각 주문을 한 고객의 이름을 함께 표시하세요.


-- [RIGHT 기초 퀴즈 2] 모든 리뷰의 상품명을 함께 조회하세요. 평점순(높은 것부터)으로 정렬합니다.


-- [RIGHT 중급 퀴즈 3] 모든 주문에 대해 각 주문에 포함된 항목 개수를 조회하세요. 주문 ID, 주문날짜, 고객명, 항목 개수를 표시합니다.


-- [RIGHT 중급 퀴즈 4] 각 주문별로 포함된 상품들의 목록을 조회하세요. 주문 ID, 고객명, 상품 목록(쉼표로 구분)을 표시합니다.


