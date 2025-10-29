-- ============================================
-- 테이블 생성
-- ============================================

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
(1, 1, '2024-10-01', 45000, 45000),
(2, 1, '2024-10-05', 15000, 30000),
(3, 2, '2024-10-02', 800000, 800000),
(4, 3, '2024-10-03', 25000, 50000),
(5, 4, '2024-10-04', 65000, 65000),
(6, 5, '2024-10-06', 200000, 200000),
(7, 7, '2024-10-07', 120000, 120000),
(8, 7, '2024-10-08', 35000, 35000),
(9, 8, '2024-10-09', 50000, 50000),
(10, 10, '2024-10-10', 57000, 57000);

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
-- IN 연산자
-- ═══════════════════════════════════════════════════════════════════

-- [IN 1] 주문을 한 고객들만 조회
SELECT customer_id, customer_name, email
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- [IN 2] 전자제품을 구매한 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = '전자제품'
);

-- ═══════════════════════════════════════════════════════════════════
-- NOT IN 연산자
-- ═══════════════════════════════════════════════════════════════════

-- [NOT IN 1] 주문을 하지 않은 고객 조회
SELECT customer_id, customer_name, email
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- [NOT IN 2] 리뷰가 없는 상품 조회
SELECT product_id, product_name, category, price
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM reviews);

-- ═══════════════════════════════════════════════════════════════════
-- ANY 연산자 
-- ═══════════════════════════════════════════════════════════════════

-- [ANY 1] 어떤 주문 금액보다 더 비싼 상품 조회
SELECT product_id, product_name, price
FROM products
WHERE price > ANY (SELECT price FROM orders);

-- [ANY 2] 평점 4 이상인 리뷰들 조회
SELECT review_id, product_id, customer_id, rating, review_date
FROM reviews
WHERE rating = ANY (SELECT DISTINCT rating FROM reviews WHERE rating >= 4);

-- ═══════════════════════════════════════════════════════════════════
-- ALL 연산자 
-- ═══════════════════════════════════════════════════════════════════

-- [ALL 1] 모든 주문 금액보다 더 비싼 상품 조회
SELECT product_id, product_name, price
FROM products
WHERE price > ALL (SELECT price FROM orders);

-- [ALL 2] 액세서리 카테고리의 모든 상품보다 비싼 상품
SELECT product_id, product_name, category, price
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category = '액세서리'
);

-- ═══════════════════════════════════════════════════════════════════
-- EXISTS 연산자 
-- ═══════════════════════════════════════════════════════════════════

-- [EXISTS 1] 주문 이력이 있는 고객 조회
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [EXISTS 2] 평점 5점 리뷰가 있는 상품 조회
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id AND r.rating = 5
);

-- ═══════════════════════════════════════════════════════════════════
-- NOT EXISTS 연산자 
-- ═══════════════════════════════════════════════════════════════════

-- [NOT EXISTS 1] 주문 이력이 없는 고객 조회
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [NOT EXISTS 2] 리뷰가 없는 상품 조회
SELECT p.product_id, p.product_name, p.category
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id
);

-- ═══════════════════════════════════════════════════════════════════
-- 스칼라 서브쿼리 
-- ═══════════════════════════════════════════════════════════════════

-- [스칼라 1] 각 주문의 고객 이름을 서브쿼리로 조회
SELECT 
    order_id,
    (SELECT customer_name FROM customers WHERE customer_id = orders.customer_id) AS customer_name,
    order_date,
    total_amount
FROM orders;

-- [스칼라 2] 각 상품의 리뷰 개수 조회
SELECT 
    product_id,
    product_name,
    price,
    (SELECT COUNT(*) FROM reviews WHERE product_id = products.product_id) AS review_count
FROM products;

-- ═══════════════════════════════════════════════════════════════════
-- FROM절의 서브쿼리
-- ═══════════════════════════════════════════════════════════════════

-- [FROM 1] 고객별 총 주문액 조회
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(price) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS customer_spending
ORDER BY total_spent DESC;

-- [FROM 2] 상품별 판매 통계 조회
SELECT product_id, product_name, total_qty
FROM (
    SELECT 
        p.product_id,
        p.product_name,
        COALESCE(SUM(oi.quantity), 0) AS total_qty
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
) AS product_stats
ORDER BY total_qty DESC;

-- ═══════════════════════════════════════════════════════════════════
-- 퀴즈 (정답 포함)
-- ═══════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────
-- IN/NOT IN 퀴즈 
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 1] IN을 사용하여 10월에 주문을 한 고객들이 구매한 모든 상품을 조회하세요.
-- 정답:
SELECT DISTINCT p.product_id, p.product_name, p.price
FROM products p
WHERE p.product_id IN (
    SELECT DISTINCT oi.product_id
    FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE MONTH(o.order_date) = 10
);

-- [퀴즈 2] NOT IN을 사용하여 어떤 고객도 구매하지 않은 상품을 조회하세요.
-- 정답:
SELECT product_id, product_name, category, price
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- ─────────────────────────────────────────────────────────────────
-- ANY/ALL 퀴즈 
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 3] ANY를 사용하여 최소 1개 이상의 판매 수량보다 많이 주문된 주문항목을 조회하세요.
-- 정답:
SELECT order_item_id, order_id, product_id, quantity
FROM order_items
WHERE quantity >= ANY (SELECT quantity FROM order_items WHERE quantity >= 1);

-- [퀴즈 4] ALL을 사용하여 모든 주문 금액보다 더 높은 가격의 상품을 조회하세요.
-- 정답:
SELECT product_id, product_name, price
FROM products
WHERE price > ALL (SELECT total_amount FROM orders);

-- ─────────────────────────────────────────────────────────────────
-- EXISTS/NOT EXISTS 퀴즈 
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 5] EXISTS를 사용하여 리뷰를 작성한 고객을 조회하세요.
-- 정답:
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM reviews r WHERE r.customer_id = c.customer_id
);

-- [퀴즈 6] NOT EXISTS를 사용하여 어떤 고객도 리뷰를 작성하지 않은 상품을 조회하세요.
-- 정답:
SELECT p.product_id, p.product_name, p.category
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id
);

-- ─────────────────────────────────────────────────────────────────
-- 스칼라 서브쿼리 퀴즈 
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 7] 스칼라 서브쿼리를 사용하여 각 주문항목의 상품명과 상품 가격을 함께 조회하세요.
-- 정답:
SELECT 
    oi.order_item_id,
    oi.order_id,
    (SELECT product_name FROM products WHERE product_id = oi.product_id) AS product_name,
    (SELECT price FROM products WHERE product_id = oi.product_id) AS product_price,
    oi.quantity
FROM order_items oi;

-- [퀴즈 8] 스칼라 서브쿼리를 사용하여 각 리뷰와 함께 상품명, 상품 가격, 고객명을 조회하세요.
-- 정답:
SELECT 
    r.review_id,
    (SELECT product_name FROM products WHERE product_id = r.product_id) AS product_name,
    (SELECT price FROM products WHERE product_id = r.product_id) AS product_price,
    (SELECT customer_name FROM customers WHERE customer_id = r.customer_id) AS customer_name,
    r.rating,
    r.review_date
FROM reviews r;

-- ─────────────────────────────────────────────────────────────────
-- FROM절 서브쿼리 퀴즈 
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 9] FROM절의 서브쿼리를 사용하여 평균 주문액이 70,000원 이상인 고객을 조회하세요.
-- 정답:
SELECT customer_id, avg_order_amount
FROM (
    SELECT customer_id, ROUND(AVG(total_amount), 0) AS avg_order_amount
    FROM orders
    GROUP BY customer_id
) AS customer_avg
WHERE avg_order_amount >= 70000
ORDER BY avg_order_amount DESC;

-- [퀴즈 10] FROM절의 서브쿼리를 사용하여 카테고리별 평균 가격을 조회하고 평균 가격이 50,000원 이상인 카테고리를 찾으세요.
-- 정답:
SELECT category, avg_price
FROM (
    SELECT category, ROUND(AVG(price), 0) AS avg_price
    FROM products
    GROUP BY category
) AS category_avg
WHERE avg_price >= 50000
ORDER BY avg_price DESC;
