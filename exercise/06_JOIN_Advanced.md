# Ch6 JOIN 고급 - 연습문제

학생 여러분! 6장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

6장을 마친 후 다음을 이해해야 합니다:

- LEFT JOIN과 RIGHT JOIN의 차이와 사용
- Self Join (같은 테이블 자신과 JOIN)
- FULL OUTER JOIN의 MySQL 구현 (LEFT + RIGHT + UNION)
- 3개 이상 테이블 다중 JOIN
- JOIN의 성능 최적화

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** RIGHT JOIN의 기본 특징은?

- ① 왼쪽 테이블의 모든 행 포함
- ② 오른쪽 테이블의 모든 행 포함
- ③ 양쪽 테이블 모두에 매칭되는 행만
- ④ 오른쪽 테이블만 NULL 허용

---

**2번** Self Join의 개념은?

- ① 두 개의 다른 테이블을 연결
- ② 같은 테이블을 두 번 사용하여 자신과 연결
- ③ 한 테이블을 여러 번 복사
- ④ 두 개의 데이터베이스를 연결

---

**3번** FULL OUTER JOIN은?

- ① MySQL에서 기본 제공됨
- ② MySQL에서는 지원 안 하며, LEFT JOIN + RIGHT JOIN + UNION으로 구현
- ③ LEFT JOIN과 RIGHT JOIN을 순서대로 실행
- ④ 양쪽 테이블의 모든 데이터를 하나로 합침

---

**4번** 다음 중 Self Join이 필요한 경우는?

- ① 서로 다른 두 테이블 연결
- ② 직원과 그 직원의 상급자(관리자) 관계 표현
- ③ 여러 테이블을 동시에 조회
- ④ 데이터를 정렬할 때

---

**5번** LEFT JOIN에서 오른쪽 테이블의 데이터가 없을 때 결과는?

- ① 해당 행은 결과에서 제외
- ② 오른쪽 테이블의 컬럼이 NULL로 표시
- ③ 왼쪽 데이터만 반복해서 표시
- ④ 오류 발생

---

## 중급 수준 (3개) - 개념 적용

**6번** Self Join을 사용하여 직원과 관리자를 표현하려면?

```sql
① SELECT e1.name, e2.name
   FROM employee e1
   LEFT JOIN employee e2 ON e1.manager_id = e2.employee_id;

② SELECT e1.name, e2.name
   FROM employee e1
   JOIN employee e2 ON e1.manager_id = e2.manager_id;

③ SELECT e1.name FROM employee e1
   WHERE e1.manager_id IS NOT NULL;
```

- ① 올바름 (직원과 그 관리자)
- ② 올바름 (같은 관리자인 동료)
- ③ 올바름 (관리자가 있는 직원)
- ④ ①과 ②가 올바름

---

**7번** 다음 상황에서 LEFT JOIN과 RIGHT JOIN 중 어느 것을 사용?

"모든 부서와 각 부서에 속한 직원을 조회하되,
직원이 없는 부서도 포함"

```sql
① SELECT d.dept_name, e.name
   FROM department d
   LEFT JOIN employee e ON d.dept_id = e.dept_id;

② SELECT d.dept_name, e.name
   FROM employee e
   RIGHT JOIN department d ON d.dept_id = e.dept_id;
```

- ① 올바름 (부서가 기준)
- ② 올바름 (같은 의미)
- ③ ①과 ②가 모두 올바름
- ④ 둘 다 잘못됨

---

**8번** FULL OUTER JOIN을 LEFT JOIN과 RIGHT JOIN으로 구현하려면?

- ① LEFT JOIN만 사용
- ② RIGHT JOIN만 사용
- ③ LEFT JOIN + RIGHT JOIN + UNION (중복 제거)
- ④ LEFT JOIN + RIGHT JOIN + UNION ALL (모든 행)

---

## 고급 수준 (2개) - 비판적 사고

**9번** 3개 이상 테이블을 LEFT JOIN할 때 주의할 점은?

```
SELECT *
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN salary_grades sg ON e.salary BETWEEN sg.min_salary AND sg.max_salary;
```

- ① 각 LEFT JOIN이 행 수를 증가시킬 수 있음
- ② 조인 조건을 명확히 해야 중복 방지
- ③ NULL 값이 증가할 수 있음
- ④ 모두 맞음

---

**10번** JOIN의 성능을 고려할 때 가장 중요한 요소는?

- ① 테이블의 크기
- ② 조인 조건이 기본키/외래키이고 인덱스가 있는지 여부
- ③ JOIN 타입 (INNER vs LEFT)
- ④ 사용하는 함수의 개수

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** LEFT JOIN과 RIGHT JOIN의 관계를 설명하고,
같은 결과를 얻기 위해 LEFT JOIN과 RIGHT JOIN을 어떻게 변환하는지 설명하시오.

---

**12번** Self Join의 개념을 설명하고, 실무에서 필요한 경우를 3가지 이상 제시하시오.

---

**13번** FULL OUTER JOIN이 필요한 상황을 설명하고,
MySQL에서 이를 구현하는 방법을 설명하시오.

---

## 중급 수준 (1개)

**14번** 여러 LEFT JOIN을 연결할 때 각 JOIN이 결과 행 수에 미치는 영향을 설명하고,
예상 외의 결과를 피하기 위한 방법을 제시하시오.

---

## 고급 수준 (1개)

**15번** JOIN의 성능에 영향을 미치는 요소들(인덱스, 조인 순서, 조인 조건)을 설명하고,
각각의 최적화 방법을 제시하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch6_advanced CHARACTER SET utf8mb4;
USE ch6_advanced;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    manager_id INT,
    salary DECIMAL(10, 2)
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE salary_grades (
    grade CHAR(1) PRIMARY KEY,
    min_salary DECIMAL(10, 2),
    max_salary DECIMAL(10, 2)
);

INSERT INTO employees VALUES
(1, '김철수', 1, NULL, 5000000),
(2, '이영희', 1, 1, 4000000),
(3, '박민준', 2, 1, 4500000),
(4, '최순신', 2, 3, 3500000),
(5, '강감찬', 3, 1, 4200000),
(6, '이순신', 3, 5, 3800000),
(7, '장보고', 1, 1, 3200000);

INSERT INTO departments VALUES
(1, '영업부', '서울'),
(2, '기술부', '대전'),
(3, '인사부', '서울'),
(4, '재무부', '부산');

INSERT INTO salary_grades VALUES
('A', 5000000, 6000000),
('B', 4000000, 4999999),
('C', 3000000, 3999999),
('D', 2000000, 2999999);

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM salary_grades;
```

제출: 세 테이블의 데이터가 모두 보이는 스크린샷

---

**17번** employees와 departments를 LEFT JOIN하여 다음을 조회하시오.

```sql
-- 1. 모든 직원과 부서 정보
SELECT e.name, d.department_name, d.location
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- 2. 모든 부서와 직원 수 (직원 없는 부서도 포함)
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.department_name;
```

제출: 2개 쿼리 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** Self Join을 사용하여 다음을 조회하시오.

```sql
-- 1. 각 직원과 상급자명
SELECT e1.name AS employee_name, e2.name AS manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- 2. 같은 부서의 모든 직원 쌍
SELECT e1.name, e2.name
FROM employees e1
JOIN employees e2 ON e1.dept_id = e2.dept_id
WHERE e1.employee_id < e2.employee_id;
```

제출: 2개 쿼리 결과가 모두 보이는 스크린샷

---

**19번** 3개 테이블을 JOIN하여 다음을 조회하시오.

```sql
-- 1. 직원명, 부서명, 위치, 급여, 급여등급
SELECT e.name, d.department_name, d.location, e.salary, sg.grade
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN salary_grades sg ON e.salary BETWEEN sg.min_salary AND sg.max_salary;

-- 2. 부서별 평균 급여 및 급여 등급
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.department_name;
```

제출: 2개 쿼리 결과가 모두 보이는 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 고급 JOIN 쿼리를 작성하고 실행하시오.

```
요구사항:
1. FULL OUTER JOIN 구현 (LEFT + RIGHT + UNION)
   - 모든 부서와 모든 직원 표시 (배치되지 않은 직원도)

2. NOT EXISTS를 사용한 쿼리
   - 직원이 배치되지 않은 부서 조회

3. 급여 등급별 직원 수
   - LEFT JOIN으로 등급이 없는 직원도 포함

4. 자유로운 복합 JOIN 쿼리 2개 이상:
   - INNER JOIN과 LEFT JOIN 조합
   - GROUP BY와 HAVING 활용
   - 정렬 및 제한

제출:
   - 각 쿼리의 SQL 코드
   - 각 쿼리의 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                                      |
| :--: | :--: | :-------------------------------------------------------- |
| 1번 |  ②  | RIGHT JOIN은 오른쪽 테이블 모두 포함                      |
| 2번 |  ②  | Self Join은 같은 테이블을 자신과 연결                     |
| 3번 |  ②  | MySQL은 FULL OUTER JOIN 미지원, LEFT+RIGHT+UNION으로 구현 |
| 4번 |  ②  | 계층 관계(직원-관리자) 표현에 Self Join 사용              |
| 5번 |  ②  | LEFT JOIN에서 오른쪽 데이터 없으면 NULL                   |
| 6번 |  ④  | ①②가 모두 올바름 (문맥에 따라 사용)                     |
| 7번 |  ③  | ①②가 같은 의미 (부서 기준 + UNION 효과)                 |
| 8번 |  ③  | FULL OUTER = LEFT + RIGHT + UNION (중복 제거)             |
| 9번 |  ④  | 모두 맞음 (다중 LEFT JOIN의 주의사항)                     |
| 10번 |  ②  | 인덱스와 기본키/외래키 관계가 가장 중요                   |

---

## 주관식 모범 답안 (5개)

### 11번 LEFT JOIN과 RIGHT JOIN의 관계

**모범 답안**:

```
LEFT JOIN과 RIGHT JOIN의 관계:
- LEFT JOIN A LEFT JOIN B: A의 모든 데이터 + B 매칭
- RIGHT JOIN B RIGHT JOIN A: B의 모든 데이터 + A 매칭
- 테이블 순서만 바뀌면 같은 의미

변환 예시:
LEFT JOIN 방식:
SELECT * FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;

RIGHT JOIN으로 변환:
SELECT * FROM employees e
RIGHT JOIN departments d ON d.dept_id = e.dept_id;

결과: 동일 (부서가 기준, 직원이 NULL 가능)
```

---

### 12번 Self Join의 필요한 경우

**모범 답안**:

```
Self Join이 필요한 경우:

1. 직원-관리자 관계
   SELECT e.name, m.name
   FROM employees e
   LEFT JOIN employees m ON e.manager_id = m.employee_id;
   → 직원의 상급자 표시

2. 분류-세분류 관계
   SELECT c1.category AS 대분류, c2.category AS 소분류
   FROM categories c1
   JOIN categories c2 ON c1.category_id = c2.parent_category_id;
   → 상위 카테고리와 하위 카테고리

3. 제품-관련제품 관계
   SELECT p1.product_name, p2.product_name
   FROM products p1
   JOIN product_relations pr ON p1.product_id = pr.product_id1
   JOIN products p2 ON pr.product_id2 = p2.product_id;
   → 관련 제품 표시

4. 도시-도시 거리
   SELECT c1.city, c2.city, d.distance
   FROM cities c1
   JOIN cities c2 ON c1.city_id < c2.city_id
   JOIN distances d ON ...;
   → 두 도시 간 거리
```

---

### 13번 FULL OUTER JOIN

**모범 답안**:

```
FULL OUTER JOIN이 필요한 상황:
- 양쪽 테이블의 모든 데이터를 비교
- 매칭 여부와 관계없이 모든 데이터 표시
- 데이터 불일치 확인 (예: 배치되지 않은 직원, 직원이 없는 부서)

MySQL 구현 방법:

SELECT d.department_name, e.name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id

UNION

SELECT d.department_name, e.name
FROM departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id;

결과:
- 모든 부서 표시 (직원 없으면 NULL)
- 모든 직원 표시 (부서 없으면 NULL)
- 중복 제거 (UNION)
```

---

### 14번 다중 LEFT JOIN의 주의사항

**모범 답안**:

```
문제: 각 LEFT JOIN이 행 수를 증가시킬 수 있음

예시:
employee: 10행
department: 5행
salary_grades: 5행

SELECT *
FROM employees e
LEFT JOIN departments d ...
LEFT JOIN salary_grades sg ...

주의:
- e와 d의 JOIN: 가능한 최대 50행 (1:N 관계)
- 거기에 sg 추가: 가능한 최대 250행

원하는 결과:
- 각 직원 1행, 부서 1개, 급여등급 1개

해결 방법:
1. GROUP BY로 집계
2. DISTINCT 사용
3. 조인 조건을 더 구체적으로
4. 필요한 열만 선택해서 집계
```

---

### 15번 JOIN 성능 최적화

**모범 답안**:

```
요소 1: 인덱스
- 조인 조건이 되는 열에 인덱스 필수
- 예: CREATE INDEX idx_dept_id ON employees(dept_id);
- 효과: 조인 속도 수십 배 향상

요소 2: 조인 순서
- 선택도가 높은 테이블 먼저
- 예: WHERE로 이미 필터된 테이블 먼저 JOIN
- 효과: 처리할 행 수 감소

요소 3: 조인 조건
- 기본키-외래키 관계 사용
- 함수 사용 최소화
- 예: 나쁨 - ON YEAR(e.hire_date) = YEAR(d.created_date)
       좋음 - ON e.dept_id = d.dept_id

최적화 쿼리 예:
SELECT e.name, d.department_name
FROM employees e              -- 인덱스 있는 열
LEFT JOIN departments d 
  ON e.dept_id = d.dept_id    -- 기본키-외래키
WHERE e.salary > 5000000      -- 먼저 필터링
ORDER BY e.employee_id;
```

---

## 실습형 모범 답안 (5개)

### 16번 테이블 생성 및 데이터 입력

**완료 기준**:
✅ ch6_advanced 데이터베이스 생성
✅ employees: 7명
✅ departments: 4개
✅ salary_grades: 4등급

---

### 17번 LEFT JOIN 조회

**예상 결과 1**:

```
name     | department_name | location
김철수   | 영업부         | 서울
이영희   | 영업부         | 서울
박민준   | 기술부         | 대전
최순신   | 기술부         | 대전
강감찬   | 인사부         | 서울
이순신   | 인사부         | 서울
장보고   | 영업부         | 서울
```

**예상 결과 2**:

```
department_name | employee_count
영업부         | 3
기술부         | 2
인사부         | 2
재무부         | 0
```

---

### 18번 Self Join 조회

**예상 결과 1**:

```
employee_name | manager_name
김철수        | NULL
이영희        | 김철수
박민준        | 김철수
최순신        | 박민준
강감찬        | 김철수
이순신        | 강감찬
장보고        | 김철수
```

**예상 결과 2**:

```
name1    | name2
김철수   | 이영희
김철수   | 장보고
이영희   | 장보고
박민준   | 최순신
강감찬   | 이순신
```

---

### 19번 3개 테이블 JOIN

**완료 기준**:
✅ 직원-부서-급여등급 조회
✅ 모든 직원 및 부서 포함
✅ 부서별 평균 급여 계산

---

### 20번 고급 JOIN 쿼리

**모범 답안**:

```sql
-- 1. FULL OUTER JOIN (LEFT + RIGHT + UNION)
SELECT COALESCE(d.dept_id, e.dept_id) AS dept_id,
       d.department_name, e.name
FROM departments d
FULL OUTER JOIN employees e ON d.dept_id = e.dept_id
-- MySQL에서는:
SELECT d.dept_id, d.department_name, e.name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
UNION
SELECT e.dept_id, d.department_name, e.name
FROM departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id;

-- 2. NOT EXISTS (배치되지 않은 부서)
SELECT d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- 3. 급여 등급별 직원 수
SELECT sg.grade, COUNT(e.employee_id) AS employee_count
FROM salary_grades sg
LEFT JOIN employees e 
  ON e.salary BETWEEN sg.min_salary AND sg.max_salary
GROUP BY sg.grade;

-- 4. 창의적 쿼리 1: 부서별 최고급여 직원
SELECT d.department_name, e.name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary = (
    SELECT MAX(salary) FROM employees
    WHERE dept_id = e.dept_id
);

-- 5. 창의적 쿼리 2: 급여가 평균보다 높은 직원
SELECT e.name, e.salary, d.department_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > (
    SELECT AVG(salary) FROM employees
)
ORDER BY e.salary DESC;
```

---


수고했습니다.  
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
