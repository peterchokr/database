# Ch4 WHERE 절 - 연습문제

학생 여러분! 4장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

4장을 마친 후 다음을 이해해야 합니다:

- WHERE 절을 사용한 데이터 필터링
- 비교 연산자 (=, !=, <, >, <=, >=)
- 논리 연산자 (AND, OR, NOT)
- IN, BETWEEN, LIKE 연산자
- NULL 값 처리 (IS NULL, IS NOT NULL)
- 복합 조건식 작성

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** 다음 중 WHERE 절의 기본 목적은?

- ① 데이터를 정렬함
- ② 조건에 맞는 행을 필터링함
- ③ 데이터 타입을 변경함
- ④ 행의 개수를 제한함

---

**2번** 비교 연산자 != 와 <> 의 차이는?

- ① != 는 작동 안 함
- ② <> 는 작동 안 함
- ③ 둘 다 같은 의미 (같지 않다)
- ④ 기능이 완전히 다름

---

**3번** 다음 중 NULL 값을 올바르게 검사하는 SQL은?

- ① WHERE phone = NULL;
- ② WHERE phone != NULL;
- ③ WHERE phone IS NULL;
- ④ WHERE phone <> NULL;

---

**4번** IN 연산자의 주요 장점은?

- ① 더 빠른 실행 속도
- ② 가독성이 좋고 여러 값을 간결하게 표현
- ③ 더 정확한 검색
- ④ 메모리 사용 감소

---

**5번** LIKE '김%' 의 의미는?

- ① 정확히 '김' 만 검색
- ② '김'으로 시작하는 모든 문자열
- ③ '김'을 포함하는 모든 문자열
- ④ '김'으로 끝나는 모든 문자열

---

## 중급 수준 (3개) - 개념 적용

**6번** AND 와 OR의 우선순위에 관한 설명으로 올바른 것은?

- ① AND와 OR은 같은 우선순위
- ② AND가 OR보다 먼저 실행됨
- ③ OR이 AND보다 먼저 실행됨
- ④ 왼쪽에서 오른쪽으로만 실행됨

---

**7번** BETWEEN 20 AND 30 은 다음 중 어느 것과 같은가?

- ① age > 20 AND age > 30
- ② age >= 20 AND age <= 30
- ③ age > 20 AND age < 30
- ④ age >= 20 OR age <= 30

---

**8번** 다음 쿼리에서 실행 순서는?

```sql
WHERE city = '서울' AND salary > 5000000 AND position = '과장'
```

- ① 왼쪽에서 오른쪽으로 순차 실행
- ② 각 조건을 평가하고 모두 만족해야 TRUE
- ③ 조건 순서는 상관없음
- ④ 가장 선택도가 높은 조건부터

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 두 쿼리 중 성능이 더 좋은 것은?

```
쿼리 A:
WHERE city IN ('서울', '부산', '대구', '대전', '광주')

쿼리 B:
WHERE city = '서울' OR city = '부산' OR city = '대구' 
      OR city = '대전' OR city = '광주'
```

- ① 쿼리 A가 더 빠름 (더 간결)
- ② 쿼리 B가 더 빠름 (더 명시적)
- ③ 두 쿼리 성능은 같음
- ④ 상황에 따라 다름

---

**10번** 다음 상황을 분석하고 가장 효율적인 WHERE 절을 선택하시오.

"급여가 5000000원 이상이면서 직급이 '부장' 또는 '임원'인 직원을 조회하고,
대신 퇴직한 직원(resign_date가 NULL이 아닌)은 제외"

```
① WHERE salary >= 5000000 AND (position = '부장' OR position = '임원')
      AND resign_date IS NULL;

② WHERE salary >= 5000000 AND position IN ('부장', '임원')
      AND resign_date IS NULL;

③ WHERE salary >= 5000000 AND position IN ('부장', '임원')
      AND resign_date IS NOT NULL;
```

- ① 올바름 (모든 조건이 적절)
- ② 올바름 (IN으로 더 간결)
- ③ 오류 (resign_date IS NOT NULL는 퇴직자)
- ④ ①과 ②가 모두 올바름

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** WHERE 절과 SELECT의 실행 순서를 설명하시오.

---

**12번** NULL 값을 검사할 때 = NULL이 작동하지 않는 이유를 설명하시오.

---

**13번** IN 연산자와 OR 연산자의 차이를 설명하고, 각각을 사용하는 상황을 예시하시오.

---

## 중급 수준 (1개)

**14번** AND 연산자의 우선순위가 OR보다 높은 이유를 설명하고, 괄호를 올바르게 사용해야 하는 상황을 실예시로 제시하시오.

---

## 고급 수준 (1개)

**15번** 복합 WHERE 절을 작성할 때 고려해야 할 성능 최적화 방법을 설명하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

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

SELECT * FROM customer;
```

제출: customer 테이블에 5명의 고객 정보가 모두 입력된 스크린샷 1장

---

**17번** customer 테이블에서 다음을 수행하고 결과를 확인하시오.

```sql
-- 1. 서울 거주 고객만 조회
SELECT * FROM customer WHERE city = '서울';

-- 2. 30세 이상 고객 조회
SELECT * FROM customer WHERE age >= 30;

-- 3. 월급 4000000원 이상 고객 조회
SELECT * FROM customer WHERE salary >= 4000000;
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** customer 테이블에서 다음 조회를 수행하시오.

```sql
-- 1. 서울 거주 AND 30세 이상 고객
SELECT * FROM customer 
WHERE city = '서울' AND age >= 30;

-- 2. Gold 등급 AND 월급 4000000원 이상
SELECT * FROM customer 
WHERE grade = 'Gold' AND salary >= 4000000;

-- 3. 부산 OR 대구 거주 고객 (IN 사용)
SELECT * FROM customer 
WHERE city IN ('부산', '대구');
```

제출: 3개 쿼리 결과가 모두 보이는 스크린샷

---

**19번** customer 테이블에서 다음 분석을 수행하시오.

```
질문:
1. 휴대폰 번호가 없는 고객을 조회하는 SQL 작성
2. 금액 범위로 필터링 (예: 3000000 이상 5000000 이하) SQL 작성
3. 이름이 '김'으로 시작하는 고객을 조회하는 SQL 작성
4. 각 쿼리의 결과를 스크린샷으로 제시

제출: 3개 SQL 코드 + 실행 결과 스크린샷
```

---

## 고급 수준 (1개)

**20번** customer 테이블을 사용하여 다음 복합 WHERE 절을 작성하고 실행하시오.

```
요구사항:
1. 서울 거주 AND (Gold 또는 Platinum 등급)인 고객
   SQL: WHERE city = '서울' AND (grade = 'Gold' OR grade = 'Platinum')
        또는 WHERE city = '서울' AND grade IN ('Gold', 'Platinum')

2. (30세 이상) AND (부산 또는 서울 거주) AND (월급 4000000원 이상)
   SQL 작성

3. 전화번호가 없으면서 월급이 5000000원 이상인 고객
   SQL 작성

4. 다음 조건을 만족하는 자유로운 WHERE 절 2개 이상 추가 작성:
   - NOT 연산자 활용
   - LIKE 패턴 활용
   - 3개 이상의 AND/OR 조합

제출: 
   - 각 쿼리의 SQL 코드
   - 각 쿼리의 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                            |
| :--: | :--: | :---------------------------------------------- |
| 1번 |  ②  | WHERE는 조건에 맞는 행을 필터링                 |
| 2번 |  ③  | != 와 <>는 둘 다 같지 않음을 의미 (동일)        |
| 3번 |  ③  | NULL은 IS NULL/IS NOT NULL로만 검사             |
| 4번 |  ②  | IN은 여러 값을 간결하게 표현                    |
| 5번 |  ②  | % 는 0개 이상의 문자를 의미 (앞뒤 상관없음)     |
| 6번 |  ②  | AND가 OR보다 우선순위가 높음                    |
| 7번 |  ②  | BETWEEN 20 AND 30 = >= 20 AND <= 30             |
| 8번 |  ③  | AND 조건들은 순서와 상관없이 모두 만족해야 TRUE |
| 9번 | ①② | 둘 다 가능하지만 IN이 더 간결 (①②가 정답)     |
| 10번 |  ④  | ①②가 모두 올바름 (③은 조건 반대)             |

---

## 주관식 모범 답안 (5개)

### 11번 WHERE와 SELECT 실행 순서

**모범 답안**:

```
1. FROM: 테이블 선택
2. WHERE: 조건으로 행 필터링
3. SELECT: 필터된 행에서 원하는 열만 선택
4. ORDER BY: 결과 정렬 (있으면)
5. LIMIT: 행 수 제한 (있으면)

예: SELECT name, salary FROM customer
    WHERE city = '서울'
  
실행 순서: customer 테이블 → city='서울'인 행 필터 → name, salary 열 선택
```

---

### 12번 NULL 검사 방법

**모범 답안**:

```
= NULL이 작동하지 않는 이유:
- NULL은 값이 아니라 상태
- NULL = NULL의 결과는 TRUE/FALSE가 아니라 UNKNOWN
- SQL은 UNKNOWN 행을 SELECT 결과에서 제외

올바른 검사:
- IS NULL: NULL 상태 확인
- IS NOT NULL: NULL이 아닌 경우 확인

예:
잘못된 쿼리: WHERE phone = NULL; → 결과 0행
올바른 쿼리: WHERE phone IS NULL; → 전화번호 없는 고객만
```

---

### 13번 IN vs OR

**모범 답안**:

```
IN 연산자:
- 문법: WHERE city IN ('서울', '부산', '대구')
- 장점: 간결하고 가독성 좋음
- 사용: 값이 3개 이상일 때

OR 연산자:
- 문법: WHERE city = '서울' OR city = '부산' OR city = '대구'
- 장점: 명시적이고 유연
- 사용: 값이 1-2개일 때

비교:
IN: 가독성 우수, 최적화 용이
OR: 각 조건을 명확히 표현 가능

실무 예시:
- 3개 이상 도시: WHERE city IN ('서울', '부산', '대구', '대전')
- 단순 2개 조건: WHERE grade = 'Gold' OR grade = 'Silver'
```

---

### 14번 AND 우선순위와 괄호 사용

**모범 답안**:

```
AND의 우선순위가 높은 이유:
- 더 구체적인 조건을 먼저 평가
- 데이터 필터링을 더 효율적으로 수행
- 복합 조건에서 의도한 결과를 얻음

괄호가 필요한 상황:

잘못된 예:
WHERE city = '서울' OR city = '부산' AND salary > 5000000;
실행: (city = '서울') OR (city = '부산' AND salary > 5000000)
→ 서울의 모든 사람 + 부산의 고액 직원

올바른 예:
WHERE (city = '서울' OR city = '부산') AND salary > 5000000;
→ 서울 또는 부산의 고액 직원만

결론: OR과 AND를 섞을 때는 반드시 괄호로 명시
```

---

### 15번 복합 WHERE 절의 성능 최적화

**모범 답안**:

```
최적화 방법 1: 선택도가 높은 조건 먼저
WHERE salary > 5000000 AND city = '서울'
(급여로 먼저 필터링하면 처리할 행이 적어짐)

최적화 방법 2: 인덱스 활용
WHERE indexed_column = value AND other_column = value
(인덱스가 있는 열을 조건에 포함)

최적화 방법 3: 함수 사용 최소화
좋은 예: WHERE hire_date >= '2024-01-01'
나쁜 예: WHERE YEAR(hire_date) = 2024 (함수 사용)

최적화 방법 4: 불필요한 OR 제거
WHERE city IN ('서울', '부산') ← IN 사용
대신
WHERE city = '서울' OR city = '부산' ← OR 반복 피함

최적화 방법 5: 데이터 타입 일치
WHERE salary = 5000000 (타입 일치)
대신
WHERE salary = '5000000' (암시적 변환 발생)
```

---

## 실습형 모범 답안 (5개)

### 16번 customer 테이블 생성 및 데이터 입력

**완료 기준**:
✅ ch4_filtering 데이터베이스 생성
✅ customer 테이블 생성 (7개 열)
✅ 5명의 고객 데이터 입력
✅ SELECT * FROM customer 실행

**예상 결과**:

```
customer_id | name    | city | age | grade     | salary  | phone
1           | 김철수  | 서울 | 35  | Gold      | 5000000 | 010-1111-1111
2           | 이영희  | 부산 | 28  | Silver    | 3500000 | 010-2222-2222
3           | 박보영  | 서울 | 42  | Gold      | 6000000 | 010-3333-3333
4           | 최민지  | 대구 | 25  | Silver    | 3000000 | 010-4444-4444
5           | 정준호  | 서울 | 38  | Platinum  | 7500000 | NULL
```

---

### 17번 customer 테이블 기본 WHERE 조회

**완료 기준**:
✅ 서울 거주 3명 (김철수, 박보영, 정준호)
✅ 30세 이상 3명 (김철수, 박보영, 정준호)
✅ 월급 4000000원 이상 3명 (김철수, 박보영, 정준호) ※ 이영희는 3500000

---

### 18번 AND, OR 조건 조회

**완료 기준**:
✅ 서울 AND 30세 이상: 김철수, 박보영, 정준호 (3명)
✅ Gold AND 4000000원 이상: 김철수, 박보영 (2명)
✅ 부산 OR 대구: 이영희, 최민지 (2명)

---

### 19번 NULL, BETWEEN, LIKE 조회

**모범 답안**:

```sql
-- 1. 전화번호 NULL
SELECT * FROM customer WHERE phone IS NULL;
결과: 정준호 1명

-- 2. BETWEEN (3000000 이상 5000000 이하)
SELECT * FROM customer 
WHERE salary BETWEEN 3000000 AND 5000000;
결과: 이영희, 최민지, 김철수 (3명)

-- 3. LIKE 이름이 '김'으로 시작
SELECT * FROM customer WHERE name LIKE '김%';
결과: 김철수 1명
```

---

### 20번 복합 WHERE 절 및 자유로운 쿼리

**모범 답안**:

```sql
-- 1. 서울 AND (Gold OR Platinum)
SELECT * FROM customer 
WHERE city = '서울' AND (grade = 'Gold' OR grade = 'Platinum');

결과: 김철수, 박보영, 정준호 (3명)

-- 또는 IN 사용
SELECT * FROM customer 
WHERE city = '서울' AND grade IN ('Gold', 'Platinum');

-- 2. (30세 이상) AND (부산/서울) AND (4000000원 이상)
SELECT * FROM customer 
WHERE age >= 30 AND city IN ('부산', '서울') AND salary >= 4000000;

결과: 김철수, 박보영, 정준호 (3명)

-- 3. 전화번호 NULL AND 월급 5000000원 이상
SELECT * FROM customer 
WHERE phone IS NULL AND salary >= 5000000;

결과: 정준호 1명

-- 추가 쿼리 예시 1: NOT 활용
SELECT * FROM customer 
WHERE NOT grade = 'Silver' AND NOT city = '대구';

-- 추가 쿼리 예시 2: LIKE 활용
SELECT * FROM customer 
WHERE name LIKE '%영%' OR name LIKE '%호%';

-- 추가 쿼리 예시 3: 복합 조건
SELECT * FROM customer 
WHERE (city = '서울' OR city = '부산') 
AND age >= 25 AND salary < 6000000;
```

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
