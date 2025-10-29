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
-- IN 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [IN 초급 1] 주문을 한 고객들만 조회
SELECT customer_id, customer_name, email
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- [IN 초급 2] 전자제품을 구매한 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = '전자제품'
);

-- [IN 중급 1] 평점이 4 이상인 상품을 리뷰한 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT r.customer_id
    FROM reviews r
    WHERE r.rating >= 4
);

-- [IN 중급 2] 액세서리를 구매한 고객들의 전체 주문 조회
SELECT o.order_id, o.customer_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_id IN (
    SELECT DISTINCT o2.customer_id
    FROM orders o2
    INNER JOIN order_items oi ON o2.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = '액세서리'
)
ORDER BY o.customer_id;


-- ═══════════════════════════════════════════════════════════════════
-- NOT IN 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [NOT IN 초급 1] 주문을 하지 않은 고객 조회
SELECT customer_id, customer_name, email
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- [NOT IN 초급 2] 리뷰가 없는 상품 조회
SELECT product_id, product_name, category, price
FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM reviews);

-- [NOT IN 중급 1] 고객 1번이 구매하지 않은 상품 조회
SELECT DISTINCT p.product_id, p.product_name, p.price
FROM products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT oi.product_id
    FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.customer_id = 1
);

-- [NOT IN 중급 2] 평점 5점을 받지 않은 상품 중에서 주문된 상품
SELECT DISTINCT p.product_id, p.product_name
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.product_id NOT IN (
    SELECT product_id FROM reviews WHERE rating = 5
);


-- ═══════════════════════════════════════════════════════════════════
-- ANY 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [ANY 초급 1] 어떤 주문 금액보다 더 비싼 상품 조회
SELECT product_id, product_name, price
FROM products
WHERE price > ANY (SELECT total_amount FROM orders);

-- [ANY 초급 2] 평점 4 이상인 리뷰들 조회
SELECT review_id, product_id, customer_id, rating, review_date
FROM reviews
WHERE rating = ANY (SELECT DISTINCT rating FROM reviews WHERE rating >= 4);

-- [ANY 중급 1] 특정 카테고리 상품보다 비싼 상품 조회
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE p.price > ANY (
    SELECT price FROM products WHERE category = '액세서리'
);

-- [ANY 중급 2] 평균 주문 수량보다 많이 팔린 상품 조회
SELECT DISTINCT p.product_id, p.product_name, SUM(oi.quantity) AS total_qty
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.quantity > ANY (SELECT AVG(quantity) FROM order_items)
GROUP BY p.product_id, p.product_name;


-- ═══════════════════════════════════════════════════════════════════
-- ALL 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [ALL 초급 1] 모든 주문 금액보다 더 비싼 상품 조회
SELECT product_id, product_name, price
FROM products
WHERE price > ALL (SELECT total_amount FROM orders);

-- [ALL 초급 2] 액세서리 카테고리의 모든 상품보다 비싼 상품
SELECT product_id, product_name, category, price
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category = '액세서리'
);

-- [ALL 중급 1] 액세서리보다 모두 비싼 상품을 구매한 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.price > ALL (SELECT price FROM products WHERE category = '액세서리');

-- [ALL 중급 2] 모든 평점보다 높거나 같은 평점을 받은 상품이 있는지 확인
SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE p.product_id IN (
    SELECT product_id FROM reviews GROUP BY product_id HAVING MIN(rating) >= 4
)
GROUP BY p.product_id, p.product_name;


-- ═══════════════════════════════════════════════════════════════════
-- EXISTS 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [EXISTS 초급 1] 주문 이력이 있는 고객 조회
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [EXISTS 초급 2] 평점 5점 리뷰가 있는 상품 조회
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id AND r.rating = 5
);

-- [EXISTS 중급 1] 10월에 주문한 고객의 프로필 조회
SELECT c.customer_id, c.customer_name, c.email, c.registration_date
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id AND MONTH(o.order_date) = 10
);

-- [EXISTS 중급 2] 자신이 구매한 상품에 대해 리뷰를 작성한 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = c.customer_id
    AND EXISTS (
        SELECT 1 FROM reviews r WHERE r.customer_id = c.customer_id AND r.product_id = oi.product_id
    )
);


-- ═══════════════════════════════════════════════════════════════════
-- NOT EXISTS 연산자 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [NOT EXISTS 초급 1] 주문 이력이 없는 고객 조회
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [NOT EXISTS 초급 2] 리뷰가 없는 상품 조회
SELECT p.product_id, p.product_name, p.category
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id
);

-- [NOT EXISTS 중급 1] 고객 1번이 구매하지 않은 상품 조회
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.customer_id = 1 AND oi.product_id = p.product_id
);

-- [NOT EXISTS 중급 2] 액세서리를 구매하지 않은 고객 조회
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = c.customer_id AND p.category = '액세서리'
);


-- ═══════════════════════════════════════════════════════════════════
-- 스칼라 서브쿼리 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [스칼라 초급 1] 각 주문의 고객 이름을 서브쿼리로 조회
SELECT 
    order_id,
    (SELECT customer_name FROM customers WHERE customer_id = orders.customer_id) AS customer_name,
    order_date,
    total_amount
FROM orders;

-- [스칼라 초급 2] 각 상품의 리뷰 개수 조회
SELECT 
    product_id,
    product_name,
    price,
    (SELECT COUNT(*) FROM reviews WHERE product_id = products.product_id) AS review_count
FROM products;

-- [스칼라 중급 1] 각 고객의 주문 통계 조회
SELECT 
    c.customer_id,
    c.customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) AS total_orders,
    (SELECT AVG(total_amount) FROM orders WHERE customer_id = c.customer_id) AS avg_order_amount,
    (SELECT MAX(total_amount) FROM orders WHERE customer_id = c.customer_id) AS max_order_amount
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders WHERE customer_id = c.customer_id);

-- [스칼라 중급 2] 각 상품의 평가 현황 조회
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    (SELECT COUNT(*) FROM reviews WHERE product_id = p.product_id) AS review_count,
    (SELECT ROUND(AVG(rating), 2) FROM reviews WHERE product_id = p.product_id) AS avg_rating
FROM products p
WHERE EXISTS (SELECT 1 FROM reviews WHERE product_id = p.product_id);


-- ═══════════════════════════════════════════════════════════════════
-- FROM절의 서브쿼리 (초급 2개, 중급 2개)
-- ═══════════════════════════════════════════════════════════════════

-- [FROM 초급 1] 고객별 총 주문액 조회
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS customer_spending
ORDER BY total_spent DESC;

-- [FROM 초급 2] 상품별 판매 통계 조회
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

-- [FROM 중급 1] 2개 이상 주문한 고객 조회
SELECT customer_id, customer_name, purchase_count, total_amount
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS purchase_count,
        SUM(o.total_amount) AS total_amount
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_stats
WHERE purchase_count >= 2
ORDER BY total_amount DESC;

-- [FROM 중급 2] 고객별 리뷰 현황 분류
SELECT customer_id, customer_name, review_count, avg_rating, review_category
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(r.review_id) AS review_count,
        ROUND(AVG(r.rating), 2) AS avg_rating,
        CASE 
            WHEN COUNT(r.review_id) = 0 THEN '리뷰 없음'
            WHEN AVG(r.rating) >= 4.5 THEN '매우 만족'
            ELSE '만족'
        END AS review_category
    FROM customers c
    LEFT JOIN reviews r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_review_stats
WHERE review_count > 0
ORDER BY avg_rating DESC;


-- ═══════════════════════════════════════════════════════════════════
-- 퀴즈 (정답 포함)
-- ═══════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────
-- IN/NOT IN 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 1] IN을 사용하여 '전자제품'을 구매한 고객의 고객ID, 고객명을 조회하세요.
-- 정답:
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = '전자제품'
);

-- [퀴즈 2] NOT IN을 사용하여 평점 5점을 받지 않은 상품 중에서 주문된 상품을 찾으세요.
-- 정답:
SELECT DISTINCT p.product_id, p.product_name
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.product_id NOT IN (
    SELECT product_id FROM reviews WHERE rating = 5
);

-- [퀴즈 3] IN을 사용하여 고객 ID 2번이 작성한 평점 4점 이상의 리뷰 상품을 조회하세요.
-- 정답:
SELECT DISTINCT p.product_id, p.product_name, p.price
FROM products p
WHERE p.product_id IN (
    SELECT product_id FROM reviews WHERE customer_id = 2 AND rating >= 4
);

-- [퀴즈 4] NOT IN을 사용하여 고객 1번이 구매하지 않은 액세서리 상품을 조회하세요.
-- 정답:
SELECT DISTINCT p.product_id, p.product_name, p.price
FROM products p
WHERE p.category = '액세서리'
AND p.product_id NOT IN (
    SELECT DISTINCT oi.product_id
    FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE o.customer_id = 1
);


-- ─────────────────────────────────────────────────────────────────
-- ANY/ALL 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 5] ANY를 사용하여 어떤 주문 금액보다 비싼 상품들을 조회하세요.
-- 정답:
SELECT product_id, product_name, price
FROM products
WHERE price > ANY (SELECT total_amount FROM orders);

-- [퀴즈 6] ALL을 사용하여 모든 액세서리 상품보다 더 비싼 상품을 조회하세요.
-- 정답:
SELECT product_id, product_name, category, price
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category = '액세서리'
);

-- [퀴즈 7] ANY를 사용하여 평균 구매 수량보다 많이 팔린 상품을 조회하세요.
-- 정답:
SELECT DISTINCT p.product_id, p.product_name
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.quantity > ANY (SELECT AVG(quantity) FROM order_items);

-- [퀴즈 8] ALL을 사용하여 모든 최소 평점보다 높거나 같은 평점의 상품을 찾으세요. (평점이 4 이상)
-- 정답:
SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE p.product_id IN (
    SELECT product_id FROM reviews GROUP BY product_id HAVING MIN(rating) >= 4
)
GROUP BY p.product_id, p.product_name;


-- ─────────────────────────────────────────────────────────────────
-- EXISTS/NOT EXISTS 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 9] EXISTS를 사용하여 주문 이력이 있는 고객을 조회하세요.
-- 정답:
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [퀴즈 10] NOT EXISTS를 사용하여 주문 이력이 없는 고객을 조회하세요.
-- 정답:
SELECT c.customer_id, c.customer_name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- [퀴즈 11] EXISTS를 사용하여 평점 5점 리뷰가 있는 상품을 조회하세요.
-- 정답:
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE EXISTS (
    SELECT 1 FROM reviews r WHERE r.product_id = p.product_id AND r.rating = 5
);

-- [퀴즈 12] NOT EXISTS를 사용하여 액세서리를 구매하지 않은 고객을 조회하세요.
-- 정답:
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = c.customer_id AND p.category = '액세서리'
);


-- ─────────────────────────────────────────────────────────────────
-- 스칼라 서브쿼리 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 13] 스칼라 서브쿼리를 사용하여 각 주문의 고객명과 함께 조회하세요.
-- 정답:
SELECT 
    order_id,
    (SELECT customer_name FROM customers WHERE customer_id = orders.customer_id) AS customer_name,
    order_date,
    total_amount
FROM orders;

-- [퀴즈 14] 스칼라 서브쿼리를 사용하여 각 상품의 리뷰 개수와 평균 평점을 조회하세요.
-- 정답:
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    (SELECT COUNT(*) FROM reviews WHERE product_id = p.product_id) AS review_count,
    (SELECT ROUND(AVG(rating), 2) FROM reviews WHERE product_id = p.product_id) AS avg_rating
FROM products p
WHERE EXISTS (SELECT 1 FROM reviews WHERE product_id = p.product_id);

-- [퀴즈 15] 스칼라 서브쿼리를 사용하여 각 고객의 총 주문수, 평균 주문액, 최대 주문액을 조회하세요.
-- 정답:
SELECT 
    c.customer_id,
    c.customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.customer_id) AS total_orders,
    (SELECT AVG(total_amount) FROM orders WHERE customer_id = c.customer_id) AS avg_order_amount,
    (SELECT MAX(total_amount) FROM orders WHERE customer_id = c.customer_id) AS max_order_amount
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders WHERE customer_id = c.customer_id);


-- ─────────────────────────────────────────────────────────────────
-- FROM절 서브쿼리 퀴즈
-- ─────────────────────────────────────────────────────────────────

-- [퀴즈 16] FROM절의 서브쿼리를 사용하여 고객별 총 주문액을 조회하고 100,000원 이상인 고객을 찾으세요.
-- 정답:
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS customer_spending
WHERE total_spent >= 100000
ORDER BY total_spent DESC;

-- [퀴즈 17] FROM절의 서브쿼리를 사용하여 2개 이상 주문한 고객을 조회하세요.
-- 정답:
SELECT customer_id, customer_name, purchase_count, total_amount
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS purchase_count,
        SUM(o.total_amount) AS total_amount
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_stats
WHERE purchase_count >= 2
ORDER BY total_amount DESC;

-- [퀴즈 18] FROM절의 서브쿼리를 사용하여 상품별 판매 통계 중 1개 이상 팔린 상품을 조회하세요.
-- 정답:
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
WHERE total_qty > 0
ORDER BY total_qty DESC;