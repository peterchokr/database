-- 1번 과제: 판매 데이터에서 다음의 집계 쿼리를 작성하세요:
-- 전체 판매 건수, 판매액 합계, 평균 판매액
select count(sale_id), sum(quantity * unit_price),  round(avg(quantity * unit_price),2)
from sales as s;

-- 상품별 판매 건수, 판매액 합계, 평균 판매액
select product_id, count(product_id), sum(quantity * unit_price),  round(avg(quantity * unit_price),2)
from sales as s
GROUP BY product_id;

-- 직원별 판매 실적 (판매액, 건수, 평균)
select employee_id, count(employee_id), sum(quantity * unit_price),  round(avg(quantity * unit_price),2)
from sales as s
GROUP BY employee_id;

-- 판매액이 높은 순서대로 상위 2개 상품
select product_id, (quantity * unit_price) as total_sales
from sales as s
GROUP BY product_id
order by total_sales desc
limit 2;

-- 2번 과제: GROUP BY와 HAVING을 사용하여 다음을 조회하세요:
-- 판매 건수가 3건 이상인 상품
select product_id, count(product_id)
from sales
GROUP BY product_id
HAVING count(product_id) >=3 ;

-- 판매액 합계가 2500000 이상인 직원
select employee_id, sum(quantity * unit_price)
from sales
GROUP BY employee_id 
HAVING sum(quantity * unit_price) >= 2500000;

-- 평균 판매액이 전체 평균보다 높은 상품
select product_id, avg(quantity * unit_price)
from sales
group by product_id
having avg(quantity * unit_price) > (select avg(quantity * unit_price) from sales);

-- 3번 과제: NULL 처리, CASE 문, 형식 변환을 포함한 복합 집계를 수행하세요
-- 직원별 총 판매액 계산
SELECT employee_id, SUM(quantity * unit_price)
FROM sales as e
GROUP BY employee_id;

-- 판매 건별 금액 범주화 (CASE 문): 각 판매 건(sale_id)마다 총액(quantity * unit_price)을 기준으로 대(100만 원 이상), 중(50만 원 이상 ~ 100만 원 미만), 소(50만 원 미만) 범주로 분류.
SELECT sale_id, 
       quantity * unit_price AS total_amount,
       CASE 
           WHEN (quantity * unit_price) >= 1000000 THEN '대'
           WHEN (quantity * unit_price) >= 500000 THEN '중'
           ELSE '소'
       END AS sales_category
FROM sales;

-- 날짜 형식 변환 및 분기별 판매 성과 분석: sale_date의 형식을 변환(DATE_FORMAT 등 활용)하거나 추출하여, 연도별·분기별 총 판매 성과를 분석.
SELECT DATE_FORMAT(sale_date, '%Y') AS sale_year,
       CONCAT(QUARTER(sale_date), '분기') AS sale_quarter,
       SUM(quantity * unit_price) AS quarterly_total
FROM sales
GROUP BY sale_year, sale_quarter
ORDER BY sale_year, sale_quarter;

-- 4번 과제: WITH ROLLUP을 사용하여 계층적 집계를 수행하세요
-- 카테고리별, 상품별 판매액 소계 및 전체 합계: products 테이블의 category와 product_name을 기준으로 판매액의 소계와 총합계를 WITH ROLLUP을 이용해 계층적으로 출력
SELECT p.category, 
       p.product_name, 
       SUM(s.quantity * s.unit_price) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category, p.product_name WITH ROLLUP;

-- 월별, 일별 판매 실적 계층적 표시: sale_date를 기반으로 연/월별, 그리고 일별 판매 실적의 소계와 누적 합계가 나타나도록 WITH ROLLUP 집계를 수행.
SELECT YEAR(sale_date) AS 판매연도,
       MONTH(sale_date) AS 판매월,
       DAY(sale_date) AS 판매일,
       count(sale_date) AS 건수,
       SUM(quantity * unit_price) AS daily_sales
FROM sales
GROUP BY YEAR(sale_date), MONTH(sale_date), DAY(sale_date) WITH ROLLUP;
