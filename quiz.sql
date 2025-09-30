1. 'iPhone'으로 시작하는 모든 제품을 찾으세요.
2. 이름에 'Pro'가 포함된 모든 제품을 찾으세요.
3. 이름이 정확히 5글자인 제품을 찾으세요. 
4.  SKU 코드의 네 번째 문자가 'T'인 제품을 찾으세요.







CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    sku_code VARCHAR(20),
    description TEXT
);

-- 샘플 데이터 삽입
INSERT INTO products VALUES
(1, 'iPhone 14 Pro', '전자기기', 1500000, 'ELEC-IP14P-001', '애플의 최신 프로 모델 스마트폰'),
(2, 'Galaxy S23 Ultra', '전자기기', 1400000, 'ELEC-GS23U-002', '삼성 갤럭시 울트라 시리즈'),
(3, 'MacBook Pro 16', '노트북', 3200000, 'LAPT-MBP16-003', '16인치 맥북 프로'),
(4, 'LG Gram 17', '노트북', 2100000, 'LAPT-LGG17-004', 'LG 그램 17인치 초경량'),
(5, 'iPad Air', '태블릿', 850000, 'TABL-IPA-005', '애플 아이패드 에어'),
(6, 'AirPods Pro 2', '액세서리', 350000, 'ACCE-APP2-006', '노이즈캔슬링 무선 이어폰'),
(7, 'Magic Mouse', '액세서리', 120000, 'ACCE-MM-007', '애플 매직 마우스'),
(8, 'Xbox Series X', '게임기', 650000, 'GAME-XSX-008', '마이크로소프트 엑스박스'),
(9, 'PlayStation 5', '게임기', 680000, 'GAME-PS5-009', '소니 플레이스테이션 5'),
(10, 'iPhone SE', '전자기기', 550000, 'ELEC-IPSE-010', '아이폰 SE 3세대'),
(11, 'Galaxy Tab S8', '태블릿', 920000, 'TABL-GTS8-011', '삼성 갤럭시 탭'),
(12, 'AirTag 4-pack', '액세서리', 150000, 'ACCE-AT4P-012', '애플 에어태그 4개 세트');
