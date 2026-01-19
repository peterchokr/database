# 4장: WHERE 절과 조건식

---

## 📋 수업 개요

**수업 주제**: WHERE 절을 이용한 데이터 필터링

**수업 목표**
- 비교 연산자 및 논리 연산자 완벽 이해
- IN, BETWEEN, LIKE 연산자 활용
- NULL 값 처리 방법 습득
- 복잡한 조건식 작성 능력

---

## 📚 Part 1: 이론 학습

### 이 부분에서 배우는 것

이 섹션에서는 WHERE 절을 사용하여 데이터를 필터링하는 다양한 방법을 배웁니다. 비교 연산자, 논리 연산자, IN, BETWEEN, LIKE 등의 연산자를 학습하고, 복잡한 조건식을 작성하는 능력을 기릅니다. 또한 NULL 값의 처리 방법을 이해하여 정확한 데이터 조회를 할 수 있게 됩니다.

### 1-1. 비교 연산자

```
= (같다): SELECT * FROM customer WHERE grade = 'Gold';
!= 또는 <> (같지 않다): SELECT * FROM customer WHERE city != '서울';
< (작다): SELECT * FROM customer WHERE age < 30;
> (크다): SELECT * FROM customer WHERE age > 25;
<= (작거나 같다): SELECT * FROM customer WHERE salary <= 5000000;
>= (크거나 같다): SELECT * FROM customer WHERE age >= 20;
```

### 1-2. 논리 연산자

```
AND (모두 만족): WHERE city = '서울' AND age > 25;
OR (하나라도 만족): WHERE city = '서울' OR city = '부산';
NOT (조건 반대): WHERE NOT city = '서울';
```

### 1-3. IN, BETWEEN, LIKE, IS NULL

```
IN: WHERE grade IN ('Gold', 'Silver');
BETWEEN: WHERE age BETWEEN 20 AND 30;
LIKE: WHERE name LIKE '김%';
IS NULL: WHERE address IS NULL;
```

---

## 📚 Part 2: 샘플 데이터

### 이 부분에서 배우는 것

이 섹션에서는 WHERE 절 실습에 사용할 customer 테이블을 생성하고 다양한 고객 데이터를 삽입합니다. 실제 비즈니스 상황의 고객 정보를 기반으로 설계되어, 조건 필터링의 다양한 사례를 실습할 수 있습니다.

```sql
CREATE DATABASE ch4_filtering CHARACTER SET utf8mb4;
USE ch4_filtering;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    city VARCHAR(20),
    age INT,
    grade VARCHAR(10),
    salary INT,
    phone VARCHAR(15)
) CHARACTER SET utf8mb4;

INSERT INTO customer VALUES
(1, '김철수', '서울', 35, 'Gold', 5000000, '010-1111-1111'),
(2, '이영희', '부산', 28, 'Silver', 3500000, '010-2222-2222'),
(3, '박보영', '서울', 42, 'Gold', 6000000, '010-3333-3333'),
(4, '최민지', '대구', 25, 'Silver', 3000000, '010-4444-4444'),
(5, '정준호', '서울', 38, 'Platinum', 7500000, NULL);
```

---

## 💻 Part 3: 실습

### 이 부분에서 배우는 것

이 섹션에서는 배운 WHERE 절의 다양한 조건을 실제로 적용하여 데이터를 필터링합니다. 단일 조건부터 복합 조건까지 다양한 예제를 통해 WHERE 절을 자유롭게 사용할 수 있게 됩니다. 또한 조건식의 우선순위를 이해하고, 효율적인 쿼리를 작성하는 능력을 기르게 됩니다.

```sql
-- =====================================================
-- 3-1. 비교 연산자 실습
-- =====================================================
-- 실습 4-1~4-10: 기본 비교 연산자

-- 1. 서울 거주 고객 조회
SELECT * FROM customer WHERE city = '서울';

-- 2. 30세 이상 고객 조회
SELECT * FROM customer WHERE age >= 30;

-- 3. Gold 등급 고객 조회
SELECT * FROM customer WHERE grade = 'Gold';

-- 4. 35세 미만 고객 조회
SELECT * FROM customer WHERE age < 35;

-- 5. 4000000원 이상 월급 고객 조회
SELECT * FROM customer WHERE salary >= 4000000;

-- 6. 부산이 아닌 지역 거주 고객
SELECT * FROM customer WHERE city != '부산';

-- 7. 김철수가 아닌 다른 고객
SELECT * FROM customer WHERE name <> '김철수';

-- 8. 정확히 28세인 고객
SELECT * FROM customer WHERE age = 28;

-- 9. 5000000원 이하의 월급 고객
SELECT * FROM customer WHERE salary <= 5000000;

-- 10. Silver가 아닌 등급의 고객
SELECT * FROM customer WHERE grade != 'Silver';

-- =====================================================
-- 3-2. 논리 연산자 실습
-- =====================================================
-- 실습 4-11~4-20: AND, OR, NOT 연산자

-- 11. 서울 거주하면서 30세 이상인 고객
SELECT * FROM customer WHERE city = '서울' AND age >= 30;

-- 12. Gold 등급이면서 월급이 5000000 이상인 고객
SELECT * FROM customer WHERE grade = 'Gold' AND salary >= 5000000;

-- 13. 서울 또는 부산 거주 고객
SELECT * FROM customer WHERE city = '서울' OR city = '부산';

-- 14. Silver 또는 Gold 등급 고객
SELECT * FROM customer WHERE grade = 'Silver' OR grade = 'Gold';

-- 15. 30세 이상 50세 미만인 고객
SELECT * FROM customer WHERE age >= 30 AND age < 50;

-- 16. 대구 거주 고객 또는 Platinum 등급 고객
SELECT * FROM customer WHERE city = '대구' OR grade = 'Platinum';

-- 17. 서울 거주가 아닌 고객
SELECT * FROM customer WHERE NOT city = '서울';

-- 18. 월급이 4000000 이상이면서 Silver 등급인 고객
SELECT * FROM customer WHERE salary >= 4000000 AND grade = 'Silver';

-- 19. 35세 이상인 고객 중 서울 거주 고객
SELECT * FROM customer WHERE age >= 35 AND city = '서울';

-- 20. Gold 등급이면서 6000000 이상의 월급 고객
SELECT * FROM customer WHERE grade = 'Gold' AND salary >= 6000000;

-- =====================================================
-- 3-3. IN, BETWEEN, LIKE 실습
-- =====================================================
-- 실습 4-21~4-30: IN, BETWEEN, LIKE 연산자

-- 21. 서울, 부산, 대구에 거주하는 고객
SELECT * FROM customer WHERE city IN ('서울', '부산', '대구');

-- 22. Gold 또는 Platinum 등급인 고객
SELECT * FROM customer WHERE grade IN ('Gold', 'Platinum');

-- 23. 나이가 25~35세 사이인 고객
SELECT * FROM customer WHERE age BETWEEN 25 AND 35;

-- 24. 월급이 3000000~5000000 사이인 고객
SELECT * FROM customer WHERE salary BETWEEN 3000000 AND 5000000;

-- 25. 이름이 '김'으로 시작하는 고객
SELECT * FROM customer WHERE name LIKE '김%';

-- 26. 이름에 '영'을 포함하는 고객
SELECT * FROM customer WHERE name LIKE '%영%';

-- 27. 이름이 '호'로 끝나는 고객
SELECT * FROM customer WHERE name LIKE '%호';

-- 28. 휴대폰 번호가 '010-4'로 시작하는 고객
SELECT * FROM customer WHERE phone LIKE '010-4%';

-- 29. 서울, 부산 거주자이면서 Gold 등급
SELECT * FROM customer WHERE city IN ('서울', '부산') AND grade = 'Gold';

-- 30. 30세 이상 45세 이하이면서 월급이 4000000 이상
SELECT * FROM customer WHERE age BETWEEN 30 AND 45 AND salary >= 4000000;

-- =====================================================
-- 3-4. NULL 처리 및 복합 조건
-- =====================================================
-- 실습 4-31~4-40: NULL 처리 및 복합 조건

-- 31. 휴대폰 번호가 등록된 고객
SELECT * FROM customer WHERE phone IS NOT NULL;

-- 32. 휴대폰 번호가 없는 고객
SELECT * FROM customer WHERE phone IS NULL;

-- 33. 서울 거주자이거나 Platinum 등급인 고객
SELECT * FROM customer WHERE city = '서울' OR grade = 'Platinum';

-- 34. 월급이 3500000 미만인 고객
SELECT * FROM customer WHERE salary < 3500000;

-- 35. 월급이 5000000 초과인 고객
SELECT * FROM customer WHERE salary > 5000000;

-- 36. 25세 이상 40세 이하인 고객 중 휴대폰이 있는 고객
SELECT * FROM customer WHERE age BETWEEN 25 AND 40 AND phone IS NOT NULL;

-- 37. Silver 또는 Gold 등급이면서 월급이 4000000 이상
SELECT * FROM customer WHERE grade IN ('Silver', 'Gold') AND salary >= 4000000;

-- 38. 대구 거주하면서 나이가 30세 이상인 고객
SELECT * FROM customer WHERE city = '대구' AND age >= 30;

-- 39. 이름에 '지'를 포함하는 고객 중 30세 이상
SELECT * FROM customer WHERE name LIKE '%지%' AND age >= 30;

-- 40. Platinum 등급이거나 월급이 6000000 이상인 고객
SELECT * FROM customer WHERE grade = 'Platinum' OR salary >= 6000000;
```

---

## 📝 Part 4: 과제 안내

### 이론 과제

**1번 과제**: AND와 OR 연산자의 개념과 우선순위를 설명하고, 복합 조건식을 작성할 때 괄호를 올바르게 사용해야 하는 이유를 구체적인 예시를 들어 설명하세요.

**2번 과제**: IN 연산자와 OR 연산자의 차이점을 설명하고, IN을 사용했을 때의 가독성 개선 효과를 논의하세요.

**3번 과제**: LIKE 연산자의 와일드카드 문자인 %와 _의 차이를 설명하고, 각각을 사용하는 실무 예시를 제시하세요.

**4번 과제**: NULL 값이 무엇인지 설명하고, IS NULL과 = NULL의 차이점을 명확히 서술하세요.

**5번 과제**: 복합 WHERE 절을 작성할 때 성능을 고려한 조건식 구성 방법을 설명하고, 효율적인 쿼리 작성의 원칙을 제시하세요.

제출 형식: Word 또는 PDF 문서 (1-2페이지)

---

### 실습 과제

**1번 과제**: customer 테이블에서 서울 거주하면서 나이가 30세 이상인 고객을 조회하는 SQL 문을 작성하고 결과를 제시하세요.

**2번 과제**: 월급이 4000000원 이상인 Gold 등급 고객을 조회하는 쿼리를 작성하세요.

**3번 과제**: 휴대폰 번호가 없는 고객을 조회하는 SQL 문을 작성하세요.

**4번 과제**: 부산 또는 대구 거주 고객을 IN 연산자를 사용하여 조회하세요.

**5번 과제**: Part 3의 실습 4-1부터 4-40까지 제공된 모든 쿼리를 직접 실행하고, 각 쿼리의 결과를 스크린샷으로 첨부하세요.

제출 형식: SQL 파일 (Ch4_WHERE_Practice_[학번].sql) 및 스크린샷

---

수고했습니다.

조정현 교수(peterchokr@gmail.com). 영남이공대학교
