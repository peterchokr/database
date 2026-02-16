# Ch5 JOIN 기본 - 연습문제

학생 여러분! 5장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

5장을 마친 후 다음을 이해해야 합니다:
- INNER JOIN의 기본 개념과 문법
- LEFT JOIN으로 한쪽 테이블 모두 포함
- ON 절의 역할 (테이블 연결 조건)
- 다중 테이블 JOIN (3개 이상)
- JOIN의 필요성과 활용

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** INNER JOIN의 기본 특징은?
- ① 양쪽 테이블 모두에 매칭되는 행만 결과
- ② 왼쪽 테이블의 모든 행 포함
- ③ 오른쪽 테이블의 모든 행 포함
- ④ 모든 행을 중복으로 표시

---

**2번** ON 절의 역할은?
- ① 테이블을 연결할 조건 지정
- ② 결과를 필터링 (WHERE와 동일)
- ③ 데이터를 정렬
- ④ 행의 개수를 제한

---

**3번** LEFT JOIN의 특징은?
- ① 왼쪽 테이블의 모든 행을 포함
- ② 오른쪽 테이블의 모든 행을 포함
- ③ 양쪽 테이블이 같은 수의 행
- ④ 매칭되지 않은 행은 제외

---

**4번** 다음 중 JOIN의 가장 중요한 이유는?
- ① 데이터베이스가 빠르게 작동
- ② 정규화된 데이터를 다시 조합하여 의미 있는 정보 생성
- ③ 데이터 타입을 변환
- ④ 보안을 강화

---

**5번** INNER JOIN과 LEFT JOIN의 기본적인 차이는?
- ① 속도의 차이
- ② 매칭되지 않는 행 처리의 차이
- ③ 사용 가능한 연산자의 차이
- ④ 함수 사용 가능 여부

---

## 중급 수준 (3개) - 개념 적용

**6번** 3개 테이블을 JOIN할 때 올바른 순서는?

```sql
① SELECT s.name, c.course_name, e.grade
   FROM student s
   INNER JOIN enrollment e ON s.student_id = e.student_id
   INNER JOIN course c ON e.course_id = c.course_id;

② SELECT s.name, c.course_name, e.grade
   FROM student s
   INNER JOIN course c ON s.student_id = c.course_id
   INNER JOIN enrollment e ON e.course_id = c.course_id;
```

- ① 올바름 (student → enrollment → course 순서)
- ② 올바름 (다른 순서도 가능)
- ③ ①만 올바름
- ④ ②만 올바름

---

**7번** LEFT JOIN을 사용해야 하는 경우는?
- ① 양쪽 테이블에만 있는 데이터
- ② 왼쪽 테이블의 모든 데이터 + 오른쪽에서 매칭되는 정보
- ③ 오른쪽 테이블의 모든 데이터
- ④ 빠른 성능이 필요할 때

---

**8번** ON 절과 WHERE 절의 차이는?
- ① 기능이 완전히 같음
- ② ON은 JOIN 시점, WHERE는 JOIN 이후 필터링
- ③ ON은 성능이 더 좋음
- ④ WHERE만 인덱스를 사용

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 두 쿼리의 결과 차이는?

```
쿼리 A:
SELECT p.prof_name, c.course_name
FROM professor p
LEFT JOIN course c ON p.prof_id = c.prof_id;

쿼리 B:
SELECT p.prof_name, c.course_name
FROM professor p
LEFT JOIN course c ON p.prof_id = c.prof_id
WHERE c.course_name IS NOT NULL;
```

- ① 결과가 같음
- ② 쿼리 A는 강좌 없는 교수도 포함, 쿼리 B는 제외
- ③ 쿼리 B가 LEFT JOIN의 의미를 제대로 살림
- ④ 쿼리 A는 INNER JOIN과 같은 결과

---

**10번** 데이터베이스를 정규화하여 여러 테이블로 분리했을 때 JOIN이 필요한 이유는?

- ① 더 빠른 속도
- ② 데이터 중복을 제거했기 때문에 의미 있는 정보를 만들려면 다시 조합 필요
- ③ 보안 강화
- ④ 메모리 절감

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** INNER JOIN과 LEFT JOIN의 가장 근본적인 차이를 설명하시오.

---

**12번** ON 절의 역할을 설명하고 WHERE 절과의 차이를 설명하시오.

---

**13번** 다음 상황에 JOIN을 사용해야 하는 이유를 설명하시오.
"학생이 수강한 강좌와 그 강좌의 담당 교수를 함께 표시해야 한다"

---

## 중급 수준 (1개)

**14번** 여러 테이블을 JOIN할 때 테이블의 순서가 결과에 영향을 미치는지 설명하고, 
LEFT JOIN의 경우 왼쪽 테이블의 위치가 중요한 이유를 설명하시오.

---

## 고급 수준 (1개)

**15번** 3개 이상의 테이블을 JOIN할 때 고려해야 할 사항들을 설명하고, 
NULL 값이 JOIN 결과에 미치는 영향을 분석하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch5_join CHARACTER SET utf8mb4;
USE ch5_join;

CREATE TABLE professor (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    professor_name VARCHAR(30) NOT NULL,
    department VARCHAR(30)
) CHARACTER SET utf8mb4;

CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(30) NOT NULL,
    credits INT,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professor(professor_id)
) CHARACTER SET utf8mb4;

INSERT INTO professor VALUES
(1, '박철수', 'AI소프트웨어학과'),
(2, '이영희', 'AI소프트웨어학과'),
(3, '최준호', 'AI소프트웨어학과');

INSERT INTO course VALUES
(1, '데이터베이스', 3, 1),
(2, '웹프로그래밍', 3, 2),
(3, '인공지능', 3, 1),
(4, '클라우드 컴퓨팅', 3, 3);

SELECT * FROM professor;
SELECT * FROM course;
```

제출: professor와 course 테이블 데이터가 모두 보이는 스크린샷

---

**17번** professor와 course 테이블을 INNER JOIN하여 다음을 조회하시오.

```sql
-- 1. 강좌와 담당 교수 조회
SELECT c.course_name, p.professor_name
FROM course c
INNER JOIN professor p ON c.professor_id = p.professor_id;

-- 2. 강좌명, 교수명, 학점
SELECT c.course_name, p.professor_name, c.credits
FROM course c
INNER JOIN professor p ON c.professor_id = p.professor_id;
```

제출: 2개 쿼리 결과가 모두 보이는 스크린샷

---

## 중급 수준 (2개)

**18번** student와 enrollment 테이블을 생성하고 다음을 수행하시오.

```sql
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(30) NOT NULL,
    major VARCHAR(30)
) CHARACTER SET utf8mb4;

CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
) CHARACTER SET utf8mb4;

INSERT INTO student VALUES
(1, '학생A', 'AI소프트웨어학과'),
(2, '학생B', 'AI소프트웨어학과'),
(3, '학생C', '컴퓨터공학과'),
(4, '학생D', 'AI소프트웨어학과');

INSERT INTO enrollment VALUES
(1, 1, 1, 'A'),
(2, 1, 2, 'B'),
(3, 2, 1, 'A'),
(4, 2, 3, 'B'),
(5, 3, 2, 'C'),
(6, 4, 1, 'A');

-- 학생, 강좌, 성적 조회
SELECT s.student_name, c.course_name, e.grade
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN course c ON e.course_id = c.course_id;
```

제출: student, enrollment 테이블 생성 후 3개 테이블 JOIN 결과 스크린샷

---

**19번** professor 테이블을 LEFT JOIN하여 다음을 조회하시오.

```sql
-- LEFT JOIN: 담당강좌 없는 교수도 포함
SELECT p.professor_name, c.course_name
FROM professor p
LEFT JOIN course c ON p.professor_id = c.professor_id;

-- 교수별 담당 강좌 수
SELECT p.professor_name, COUNT(c.course_id) AS course_count
FROM professor p
LEFT JOIN course c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.professor_name;
```

제출: 2개 쿼리 결과가 모두 보이는 스크린샷

---

## 고급 수준 (1개)

**20번** 다음의 복잡한 JOIN 쿼리를 작성하고 실행하시오.

```
요구사항:
1. student, enrollment, course, professor 4개 테이블 JOIN
   결과: 학생명, 강좌명, 성적, 담당 교수명

2. student LEFT JOIN enrollment로 수강 강좌가 없는 학생도 포함
   결과: 모든 학생과 그들이 수강한 강좌 (수강 강좌 없으면 NULL)

3. professor LEFT JOIN course로 담당 강좌가 없는 교수도 포함
   결과: 모든 교수와 그들의 강좌

4. 자유로운 JOIN 쿼리 2개 이상 추가 작성:
   - INNER JOIN과 LEFT JOIN 조합
   - GROUP BY와 함께 사용

제출:
   - 각 쿼리의 SQL 코드
   - 각 쿼리의 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설 |
|:---:|:---:|:---|
| 1번 | ① | INNER JOIN은 양쪽 모두에 매칭되는 행만 |
| 2번 | ① | ON은 두 테이블 연결 조건 지정 |
| 3번 | ① | LEFT JOIN은 왼쪽 테이블 모든 행 포함 |
| 4번 | ② | 정규화된 데이터를 조합하여 의미 있는 정보 생성 |
| 5번 | ② | 매칭되지 않는 행 처리의 차이 (INNER는 제외, LEFT는 포함) |
| 6번 | ③ | ①만 올바름 (student_id와 course_id로 연결 가능) |
| 7번 | ② | 왼쪽 모든 데이터 + 오른쪽 매칭 정보 |
| 8번 | ② | ON은 JOIN 조건, WHERE는 JOIN 후 필터링 |
| 9번 | ② | LEFT JOIN에서 WHERE로 필터링하면 INNER JOIN처럼 작동 |
| 10번 | ② | 정규화로 중복 제거했기에 JOIN으로 다시 조합 필요 |

---

## 주관식 모범 답안 (5개)

### 11번 INNER JOIN vs LEFT JOIN

**모범 답안**:
```
INNER JOIN:
- 결과: 두 테이블 모두에 매칭되는 행만
- 특징: 교집합
- 예: 강좌를 수강한 학생만 표시

LEFT JOIN:
- 결과: 왼쪽 테이블의 모든 행 + 오른쪽 매칭 정보
- 특징: 왼쪽 테이블이 기준
- 예: 모든 학생 + 수강 강좌 (수강 안 한 학생은 NULL)
```

---

### 12번 ON과 WHERE의 역할

**모범 답안**:
```
ON 절:
- 역할: 두 테이블을 어떻게 연결할지 지정
- 시점: JOIN 실행 시점
- 특징: LEFT JOIN에서 WHERE와 다른 결과

WHERE 절:
- 역할: JOIN 결과에서 추가 필터링
- 시점: JOIN 이후
- 특징: 행을 제외할 수 있음

차이 예시:
LEFT JOIN ... WHERE: 한쪽 테이블 데이터 손실 가능
LEFT JOIN ... ON: 왼쪽 테이블 모든 데이터 보존
```

---

### 13번 JOIN이 필요한 이유

**모범 답안**:
```
상황: 학생, 수강정보, 강좌, 교수가 분리된 테이블에 있음

정규화 전 문제:
- 같은 강좌와 교수 정보가 매 학생 행마다 반복
- 교수 정보 수정 시 모든 행 수정 필요
- 데이터 일관성 문제

JOIN으로 해결:
SELECT s.student_name, c.course_name, p.professor_name
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
JOIN professor p ON c.professor_id = p.professor_id;

장점:
- 정규화의 이점 유지 (중복 제거)
- 필요할 때만 정보 조합
- 한 쿼리로 의미 있는 정보 생성
```

---

### 14번 JOIN 테이블 순서의 중요성

**모범 답안**:
```
INNER JOIN: 순서 영향 없음
- 양쪽 테이블이 대칭적
- 다음 두 쿼리는 같은 결과:
  SELECT * FROM A JOIN B ON ...
  SELECT * FROM B JOIN A ON ...

LEFT JOIN: 순서 중요
- 왼쪽 테이블이 기준
- SELECT * FROM professor LEFT JOIN course
  → 모든 교수 (강좌 없으면 NULL)
  
- SELECT * FROM course LEFT JOIN professor
  → 모든 강좌 (교수 없으면 NULL)
  
따라서 LEFT JOIN에서는 기준이 될 테이블을 왼쪽에 배치
```

---

### 15번 다중 TABLE JOIN과 NULL 처리

**모범 답안**:
```
고려 사항:

1. 기본 테이블 선택
   - 가장 중요한 데이터를 FROM에 배치

2. JOIN 순서
   - 관계도에 따라 순차적으로 JOIN

3. NULL 처리
   - INNER JOIN: NULL 조인 조건에서 매칭 실패 → 행 제외
   - LEFT JOIN: NULL 발생 가능 → COALESCE로 처리

4. 성능
   - 조건에 인덱스 사용
   - 조인 조건 개수 최소화

NULL의 영향:
SELECT * FROM student s
LEFT JOIN enrollment e ON s.student_id = e.student_id
- enrollment에서 student_id = NULL이면 JOIN 실패
- enrollment가 없는 학생은 e.* 컬럼이 모두 NULL
```

---

## 실습형 모범 답안 (5개)

### 16번 professor, course 테이블 생성

**완료 기준**:
✅ ch5_join 데이터베이스 생성
✅ professor 테이블: 3명 교수
✅ course 테이블: 4개 강좌
✅ FOREIGN KEY로 관계 설정

---

### 17번 INNER JOIN 조회

**완료 기준**:
✅ 강좌-교수 매칭 4개 행
✅ 학점 정보 포함

**예상 결과**:
```
course_name         | professor_name
데이터베이스        | 박철수
웹프로그래밍        | 이영희
인공지능            | 박철수
클라우드 컴퓨팅     | 최준호
```

---

### 18번 3개 테이블 JOIN

**완료 기준**:
✅ student 테이블 생성 (4명)
✅ enrollment 테이블 생성 (6개 수강)
✅ 3개 테이블 JOIN 성공
✅ 학생명, 강좌명, 성적 조회

**예상 결과**:
```
student_name | course_name      | grade
학생A         | 데이터베이스     | A
학생A         | 웹프로그래밍     | B
학생B         | 데이터베이스     | A
학생B         | 인공지능         | B
학생C         | 웹프로그래밍     | C
학생D         | 데이터베이스     | A
```

---

### 19번 LEFT JOIN 조회

**모범 답안**:

```sql
-- 1. 교수와 강좌 조회
SELECT p.professor_name, c.course_name
FROM professor p
LEFT JOIN course c ON p.professor_id = c.professor_id;

결과:
professor_name | course_name
박철수         | 데이터베이스
박철수         | 인공지능
이영희         | 웹프로그래밍
최준호         | 클라우드 컴퓨팅

-- 2. 교수별 강좌 수
SELECT p.professor_name, COUNT(c.course_id) AS course_count
FROM professor p
LEFT JOIN course c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.professor_name;

결과:
professor_name | course_count
박철수         | 2
이영희         | 1
최준호         | 1
```

---

### 20번 복잡한 다중 JOIN

**모범 답안**:

```sql
-- 1. 4개 테이블 JOIN
SELECT s.student_name, c.course_name, e.grade, p.professor_name
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
JOIN professor p ON c.professor_id = p.professor_id;

-- 2. LEFT JOIN으로 모든 학생 포함
SELECT s.student_name, c.course_name
FROM student s
LEFT JOIN enrollment e ON s.student_id = e.student_id
LEFT JOIN course c ON e.course_id = c.course_id;

-- 3. LEFT JOIN으로 모든 교수 포함
SELECT p.professor_name, COUNT(DISTINCT c.course_id) AS course_count
FROM professor p
LEFT JOIN course c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.professor_name;

-- 4. 창의적 쿼리 1: 학생별 수강 강좌 수
SELECT s.student_name, COUNT(e.course_id) AS course_count
FROM student s
LEFT JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name;

-- 5. 창의적 쿼리 2: 강좌별 수강 학생 수
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM course c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
```

---

조정현 교수 (peterchokr@gmail.com)
