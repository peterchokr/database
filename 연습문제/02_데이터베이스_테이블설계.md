# Ch2 DDL 명령어 - 연습문제

학생 여러분! 2장을 완료한 후 다음 연습문제를 통해 개념을 확인해보세요.
각 섹션의 난이도를 확인하고 단계별로 공부하시면 됩니다.

---

## 📌 학습 목표 확인

2장을 마친 후 다음을 이해해야 합니다:

- DDL 명령어의 이해 (CREATE, ALTER, DROP)
- 데이터 타입 선택의 기준 (VARCHAR vs CHAR, INT vs DECIMAL)
- 제약조건의 종류와 용도 (PRIMARY KEY, UNIQUE, NOT NULL, DEFAULT)
- 테이블 구조 설계 및 수정

---

# 객관식 문제 (10개)

## 초급 수준 (5개) - 기본 개념 확인

**1번** VARCHAR(50)과 CHAR(50) 중 가변길이 문자를 저장하는 데 적합한 것은?

- ① VARCHAR(50) - 가변길이, 저장공간 효율적
- ② CHAR(50) - 고정길이, 항상 50바이트
- ③ 둘 다 가변길이임
- ④ 상황에 따라 다름

---

**2번** 금액을 저장할 때 DECIMAL(10,2)와 FLOAT 중 올바른 선택은?

- ① FLOAT가 정확함 (부동소수점)
- ② DECIMAL(10,2)가 정확함 (고정소수점)
- ③ 둘 다 같은 정밀도
- ④ 부동소수점이 더 안전

---

**3번** PRIMARY KEY와 UNIQUE의 가장 큰 차이점은?

- ① PRIMARY KEY는 NULL을 허용하지 않고, 테이블당 1개만 가능
- ② UNIQUE는 NULL을 여러 개 허용하고, 여러 개 가능
- ③ 기능상 완전히 같음
- ④ PRIMARY KEY가 더 느림

---

**4번** NOT NULL + UNIQUE 조합의 목적은?

- ① 값이 반드시 있고 중복되지 않아야 함
- ② 값이 없을 수도 있지만 중복 불가
- ③ NULL은 여러 개 허용
- ④ PRIMARY KEY와 동일

---

**5번** DEFAULT 제약조건의 역할은?

- ① 기본값을 지정하여 입력하지 않을 때 자동으로 저장
- ② 데이터 수정을 방지
- ③ 삭제를 방지
- ④ 조회 권한을 제한

---

## 중급 수준 (3개) - 개념 적용

**6번** 다음 중 올바른 CREATE TABLE 문법은?

```sql
① CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    gpa FLOAT,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

② CREATE TABLE student (
    student_id INT,
    name VARCHAR(30) NOT NULL,
    gpa FLOAT PRIMARY KEY
);

③ CREATE TABLE student (
    student_id INT PRIMARY KEY NULL,
    name VARCHAR(30),
    gpa FLOAT
);
```

- ① 올바름 (모든 제약조건 적절)
- ② 올바름 (gpa가 PRIMARY KEY)
- ③ 올바름 (PRIMARY KEY에 NULL 가능)
- ④ ①만 올바름

---

**7번** employee 테이블에서 salary 열을 INT에서 DECIMAL(12,2)로 변경하려면?

- ① DROP TABLE과 CREATE TABLE 반복만 가능
- ② ALTER TABLE employee MODIFY salary DECIMAL(12,2);
- ③ ALTER TABLE employee CHANGE salary salary DECIMAL(12,2);
- ④ ②와 ③ 모두 가능

---

**8번** AUTO_INCREMENT를 사용하는 이유는?

- ① 자동으로 1씩 증가하는 ID를 생성
- ② 중복된 ID 방지
- ③ 새 행 추가 시 ID를 직접 입력 안 해도 됨
- ④ 모두 맞음

---

## 고급 수준 (2개) - 비판적 사고

**9번** 다음 두 테이블 설계 중 더 나은 것은?

```
설계 A:
student (student_id INT, name VARCHAR(100), 
         phone VARCHAR(15) NOT NULL,
         email VARCHAR(50) NOT NULL UNIQUE,
         major VARCHAR(50))

설계 B:
student (student_id INT PRIMARY KEY AUTO_INCREMENT, 
         name VARCHAR(30) NOT NULL,
         phone VARCHAR(15),
         email VARCHAR(50) UNIQUE,
         major VARCHAR(30))
```

- ① 설계 A가 더 좋음 (모든 필드가 필수)
- ② 설계 B가 더 좋음 (PRIMARY KEY 명시적 정의, 유연성)
- ③ 설계 A가 더 좋음 (모든 필드가 NOT NULL)
- ④ 둘 다 같음

---

**10번** 테이블 구조를 설계할 때 VARCHAR의 길이를 결정하는 기준으로 가장 적절한 것은?

- ① 무조건 최대한 길게 (예: VARCHAR(1000))
- ② 저장될 데이터의 최대 길이를 고려 + 여유분
  (예: 이름 최대 30글자 → VARCHAR(50))
- ③ 아무거나 (성능 영향 없음)
- ④ 항상 CHAR 사용이 나음

---

# 주관식 문제 (5개)

## 초급 수준 (3개)

**11번** VARCHAR(30)과 CHAR(30)이 각각 '김철수'(5글자)를 저장할 때 차지하는 저장공간의 차이를 설명하시오.

---

**12번** 다음 4개의 데이터 타입 중 각각 어떤 상황에 사용하는지 설명하시오.

- INT, DECIMAL(10,2), VARCHAR(50), DATE

---

**13번** PRIMARY KEY와 UNIQUE의 차이를 3가지 이상 설명하시오.

---

## 중급 수준 (1개)

**14번** 회원 가입 시스템을 설계한다면, 다음 정보를 저장하는 user 테이블을 만드시오:
사용자ID(자동증가), 사용자명(필수), 이메일(중복불가), 전화번호, 가입일자(자동 현재날짜), 월급(소수점 2자리)

테이블 생성 SQL을 작성하고 각 제약조건을 선택한 이유를 설명하시오.

---

## 고급 수준 (1개)

**15번** 기존 employee 테이블에서 다음과 같은 변경이 필요합니다:

1. department 열을 새로 추가 (VARCHAR(30))
2. salary를 INT에서 DECIMAL(12,2)로 변경
3. hire_date 열을 새로 추가 (DATE, 기본값: 현재날짜)

ALTER TABLE을 사용하는 SQL을 작성하고, 이러한 변경이 기존 데이터에 미칠 영향을 분석하시오.

---

# 실습형 문제 (5개)

## 초급 수준 (2개)

**16번** 다음 SQL을 실행하고 결과 스크린샷을 제시하시오.

```sql
CREATE DATABASE ch2_practice CHARACTER SET utf8mb4;
USE ch2_practice;

CREATE TABLE professor (
    prof_id INT PRIMARY KEY AUTO_INCREMENT,
    prof_name VARCHAR(30) NOT NULL,
    department VARCHAR(30),
    position VARCHAR(20),
    salary DECIMAL(10,2)
);

DESC professor;
```

제출: DESC professor 결과가 보이는 스크린샷 1장

---

**17번** professor 테이블에 5명의 교수 데이터를 다음과 같이 입력하고 결과를 확인하시오.

```sql
INSERT INTO professor VALUES
(1, '김철수', '컴퓨터공학과', '교수', 7500000),
(2, '이영희', '소프트웨어학과', '부교수', 6800000),
(3, '박민준', '정보보안과', '조교수', 5900000),
(4, '최순신', '데이터사이언스과', '교수', 7800000),
(5, '강감찬', '컴퓨터공학과', '부교수', 6500000);

SELECT * FROM professor;
```

제출: 입력된 5명의 교수 정보가 모두 보이는 스크린샷 1장

---

## 중급 수준 (2개)

**18번** professor 테이블에 다음 변경을 수행하고 스크린샷을 제시하시오.

1. phone 열 추가 (VARCHAR(15))
2. salary를 DECIMAL(12,2)로 수정
3. 변경된 테이블 구조 확인

```sql
ALTER TABLE professor ADD phone VARCHAR(15);
ALTER TABLE professor MODIFY salary DECIMAL(12,2);
DESC professor;
```

제출: 최종 테이블 구조(DESC 결과)가 보이는 스크린샷 1장

---

**19번** 다음 상황에서 bank_account 테이블을 설계하시오.

```
정보:
- 계좌번호(자동증가, 기본키)
- 고객명(필수)
- 계좌타입(필수: 보통예금, 적금, 대출)
- 잔액(소수점 2자리, 기본값 0)
- 개설일자(현재날짜 기본값)
- 최종거래일(NULL 가능)

요구사항:
1. 적절한 데이터 타입 선택 이유 설명
2. 제약조건 선택 이유 설명
3. CREATE TABLE SQL 작성
4. 3개 계좌 샘플 데이터 입력 후 스크린샷

제출: SQL과 실행 결과 스크린샷
```

---

## 고급 수준 (1개)

**20번** 기존의 단순한 product 테이블을 다음과 같이 개선하시오.

```
현재 테이블:
product (product_id, product_name, price, stock)

개선 요구사항:
1. product_id는 PRIMARY KEY + AUTO_INCREMENT
2. product_name은 NOT NULL + UNIQUE
3. price는 DECIMAL(10,2) (음수 불가 CHECK)
4. stock은 기본값 0, 음수 불가 CHECK
5. category 열 추가 (VARCHAR(30))
6. created_date 열 추가 (현재날짜 기본값)
7. description 열 추가 (텍스트, NULL 가능)

질문:
1. 개선된 CREATE TABLE SQL 작성
2. 각 제약조건을 선택한 이유
3. 5개 샘플 상품 데이터 입력
4. 최종 테이블 구조와 데이터 확인

제출: 전체 SQL 코드와 실행 결과 스크린샷
```

---

---

# 📋 정답 및 모범 답안

## 객관식 정답 (10개)

| 문제 | 정답 | 해설                                                                         |
| :--: | :--: | :--------------------------------------------------------------------------- |
| 1번 |  ①  | VARCHAR는 가변길이로 효율적 (VARCHAR(50)에 5글자면 6바이트 사용)             |
| 2번 |  ②  | DECIMAL은 정확한 고정소수점, 금융/회계에 필수                                |
| 3번 |  ①  | PRIMARY KEY는 NULL 불가 + 1개만, UNIQUE는 NULL 여러 개 허용                  |
| 4번 |  ①  | NOT NULL + UNIQUE = 값이 반드시 있고 중복 불가 (완전 고유)                   |
| 5번 |  ①  | DEFAULT는 입력하지 않을 때 자동으로 지정값 저장                              |
| 6번 |  ①  | 올바른 문법 (②는 gpa를 PK로 하는 오류, ③는 PK에 NULL 지정 오류)            |
| 7번 |  ④  | MODIFY와 CHANGE 모두 가능 (MODIFY는 타입만, CHANGE는 이름도 변경 가능)       |
| 8번 |  ④  | AUTO_INCREMENT는 모든 이유를 만족                                            |
| 9번 |  ②  | 설계 B가 나음 (PRIMARY KEY 명시적, phone/email 선택 가능, VARCHAR 크기 적절) |
| 10번 |  ②  | 최대 길이 고려 + 여유분이 올바른 설계 원칙                                   |

---

## 주관식 모범 답안 (5개)

### 11번 VARCHAR(30)과 CHAR(30)의 저장공간 차이

**모범 답안**:

- **CHAR(30)**: 항상 30바이트 (고정길이)
- **VARCHAR(30)**: '김철수'(5글자) 저장 시 약 6~7바이트 (길이정보 1~2바이트 포함)
- **차이**: CHAR는 24바이트 낭비, VARCHAR는 낭비 없음
- **결론**: 가변길이 데이터는 VARCHAR가 저장공간 효율적

---

### 12번 데이터 타입별 사용 상황

**모범 답안**:

```
1. INT
   - 정수 데이터 저장
   - 예: 학번(202401), 나이(25), 가격(50000)

2. DECIMAL(10,2)
   - 소수점 정확도가 필요한 금액
   - 예: 급여(7500000.00), 금리(4.25)

3. VARCHAR(50)
   - 가변길이 문자열
   - 예: 이름(김철수), 이메일(kim@example.com), 주소

4. DATE
   - 날짜 저장
   - 예: 입학일(2024-01-15), 졸업일(2028-02-20)
```

---

### 13번 PRIMARY KEY vs UNIQUE

**모범 답안** (3가지 이상):

1. **NULL 처리**: PRIMARY KEY는 NULL 불가, UNIQUE는 NULL 여러 개 허용
2. **개수 제한**: PRIMARY KEY는 테이블당 1개만, UNIQUE는 여러 개 가능
3. **성능**: PRIMARY KEY는 인덱스 자동 생성, UNIQUE도 보통 인덱스 생성
4. **용도**: PRIMARY KEY는 행 식별, UNIQUE는 중복 방지
5. **외래키**: PRIMARY KEY만 다른 테이블의 외래키로 참조 가능

---

### 14번 user 테이블 설계

**모범 답안**:

```sql
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(15),
    signup_date DATE DEFAULT CURRENT_DATE,
    monthly_salary DECIMAL(12,2)
);
```

**제약조건 선택 이유**:

- **user_id**: PRIMARY KEY + AUTO_INCREMENT → 자동 증가, 중복 없음
- **username**: NOT NULL → 사용자명은 반드시 필요
- **email**: UNIQUE → 중복 가입 방지, 로그인에 필수
- **phone**: NULL 가능 → 선택 정보
- **signup_date**: DEFAULT CURRENT_DATE → 자동으로 현재 날짜 저장
- **monthly_salary**: DECIMAL(12,2) → 소수점 정확도 필요

---

### 15번 ALTER TABLE 변경

**모범 답안**:

```sql
-- 1. department 열 추가
ALTER TABLE employee ADD department VARCHAR(30);

-- 2. salary를 INT에서 DECIMAL(12,2)로 변경
ALTER TABLE employee MODIFY salary DECIMAL(12,2);

-- 3. hire_date 열 추가
ALTER TABLE employee ADD hire_date DATE DEFAULT CURRENT_DATE;
```

**기존 데이터에 미치는 영향**:

1. **department 추가**: 기존 행의 department는 NULL로 설정됨 (기존 데이터 보존)
2. **salary 변경**: INT에서 DECIMAL(12,2)로 변환 (소수점 자동 생성, 데이터 안전)
3. **hire_date 추가**: 기존 행의 hire_date는 NULL로 설정됨 (추후 UPDATE로 값 입력 필요)

---

## 실습형 모범 답안 (5개)

### 16번 professor 테이블 생성

**완료 기준**:
✅ ch2_practice 데이터베이스 생성됨
✅ professor 테이블 생성됨 (5개 열)
✅ DESC professor 결과: prof_id, prof_name, department, position, salary 모두 표시
✅ 제약조건 확인: prof_id PRIMARY KEY AUTO_INCREMENT, prof_name NOT NULL

**스크린샷 포함 내용**:

- DESC professor 결과
- 모든 열의 데이터 타입과 제약조건 표시

---

### 17번 professor 테이블 데이터 입력

**완료 기준**:
✅ 5명의 교수 데이터 입력됨
✅ SELECT * FROM professor 실행
✅ 모든 데이터가 올바르게 저장됨

**스크린샷 포함 내용**:

- 5행의 교수 정보 모두 표시

**예상 결과**:

```
prof_id | prof_name | department        | position | salary
1       | 김철수    | 컴퓨터공학과      | 교수     | 7500000.00
2       | 이영희    | 소프트웨어학과    | 부교수   | 6800000.00
3       | 박민준    | 정보보안과        | 조교수   | 5900000.00
4       | 최순신    | 데이터사이언스과  | 교수     | 7800000.00
5       | 강감찬    | 컴퓨터공학과      | 부교수   | 6500000.00
```

---

### 18번 ALTER TABLE 수정

**완료 기준**:
✅ ALTER TABLE professor ADD phone VARCHAR(15); 실행됨
✅ ALTER TABLE professor MODIFY salary DECIMAL(12,2); 실행됨
✅ DESC professor 결과: 6개 열 표시 (phone 추가, salary 타입 변경)

**스크린샷 포함 내용**:

- 수정된 테이블 구조
- 새로 추가된 phone 열 표시
- salary 타입이 DECIMAL(12,2)로 변경됨

---

### 19번 bank_account 테이블 설계

**모범 답안**:

```sql
CREATE TABLE bank_account (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(30) NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0,
    opening_date DATE DEFAULT CURRENT_DATE,
    last_transaction_date DATETIME
);

INSERT INTO bank_account VALUES
(1, '김철수', '보통예금', 5000000.00, CURRENT_DATE, NULL),
(2, '이영희', '적금', 2000000.00, CURRENT_DATE, '2024-12-25 14:30:00'),
(3, '박민준', '대출', 10000000.00, CURRENT_DATE, '2024-12-24 09:15:00');

SELECT * FROM bank_account;
```

**데이터 타입 선택 이유**:

- **account_id**: INT PRIMARY KEY AUTO_INCREMENT → 계좌번호 자동 생성, 중복 없음
- **customer_name**: VARCHAR(30) NOT NULL → 고객명은 필수
- **account_type**: VARCHAR(20) NOT NULL → 계좌타입 필수
- **balance**: DECIMAL(15,2) DEFAULT 0 → 금액은 정확도 필요, 기본값 0
- **opening_date**: DATE DEFAULT CURRENT_DATE → 자동으로 현재 날짜 저장
- **last_transaction_date**: DATETIME → 시간 정보 필요 (NULL 가능)

---

### 20번 product 테이블 개선

**모범 답안**:

```sql
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) CHECK (price >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    category VARCHAR(30),
    created_date DATE DEFAULT CURRENT_DATE,
    description TEXT
);

INSERT INTO product VALUES
(1, '무선 마우스', 45000.00, 100, '전자제품', CURRENT_DATE, '편안한 그립감의 무선 마우스'),
(2, '기계식 키보드', 120000.00, 50, '전자제품', CURRENT_DATE, 'RGB LED 기계식 키보드'),
(3, '모니터 암', 65000.00, 75, '전자제품', CURRENT_DATE, '스탠드형 모니터 암'),
(4, '책상', 250000.00, 20, '가구', CURRENT_DATE, '원목 서재용 책상'),
(5, '의자 쿠션', 28000.00, 150, '가구', CURRENT_DATE, '통풍 메쉬 의자 쿠션');

SELECT * FROM product;
```

**제약조건 선택 이유**:

- **product_id**: PRIMARY KEY + AUTO_INCREMENT → 상품ID 자동 생성, 중복 없음
- **product_name**: NOT NULL + UNIQUE → 상품명 필수, 중복 불가
- **price**: DECIMAL(10,2) + CHECK (price >= 0) → 금액 정확도 필요, 음수 방지
- **stock**: DEFAULT 0 + CHECK (stock >= 0) → 기본값 0, 음수 방지
- **category**: VARCHAR(30) NULL 가능 → 분류 정보
- **created_date**: DEFAULT CURRENT_DATE → 자동으로 등록일 저장
- **description**: TEXT → 상세 설명 저장 가능

---


수고했습니다.   
조정현 교수([peterchokr@gmail.com](mailto:peterchokr@gmail.com)) 영남이공대학교

이 연습문제는 Claude 및 Gemini와 협업으로 제작되었습니다.
