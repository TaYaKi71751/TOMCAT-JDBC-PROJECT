# 📋 테이블 정의서

---

## 1. `TEAMS` (팀 테이블)

| 컬럼명  | 데이터 타입   | 제약 조건        | 설명        |
|---------|----------------|------------------|-------------|
| tm_id   | VARCHAR(2000)  | PK               | 팀 ID (고유 ID) |
| tm_name | VARCHAR2(2000) | NOT NULL         | 팀 이름     |

---

## 2. `COLORS` (색상 테이블)

| 컬럼명     | 데이터 타입   | 제약 조건        | 설명            |
|------------|----------------|------------------|-----------------|
| cl_id      | VARCHAR(2000)  | PK               | 색상 ID (고유 ID) |
| cl_name    | VARCHAR2(2000) | NOT NULL         | 색상 이름       |
| cl_hexcode | VARCHAR(2000)  | NOT NULL         | 색상 HEX 코드   |

---

## 3. `USERS` (사용자 테이블)

| 컬럼명  | 데이터 타입   | 제약 조건                                      | 설명         |
|---------|----------------|------------------------------------------------|--------------|
| user_id | NUMBER          | PK, IDENTITY                                   | 사용자 ID (자동 증가) |
| grade   | VARCHAR2(10)    | NOT NULL, CHECK ('admin', 'customer')         | 사용자 등급   |
| name    | VARCHAR(2000)   | NOT NULL                                      | 사용자 이름   |
| id      | VARCHAR(2000)   | NOT NULL                                      | 로그인 ID     |
| pw      | VARCHAR(2000)   | NOT NULL                                      | 비밀번호      |
| address | VARCHAR(2000)   | NOT NULL                                      | 주소          |
| hp      | VARCHAR(2000)   | NOT NULL                                      | 휴대폰 번호   |
| email   | VARCHAR(2000)   | NOT NULL                                      | 이메일        |
| regdate | DATE            | NOT NULL                                      | 가입 날짜     |

---

## 4. `PRODUCTS` (제품 테이블)

| 컬럼명        | 데이터 타입   | 제약 조건                                               | 설명         |
|---------------|----------------|---------------------------------------------------------|--------------|
| pr_id         | NUMBER          | PK, IDENTITY                                            | 제품 ID (자동 증가) |
| tm_id         | VARCHAR(2000)   | NOT NULL, FK → TEAMS.tm_id                              | 팀 ID        |
| ca_id         | VARCHAR(20)     | NOT NULL, CHECK ('BallCap', 'Hat', 'Season', 'Beanie') | 제품 카테고리 |
| pr_name       | VARCHAR2(1000)  | NOT NULL                                               | 제품 이름     |
| pr_regdate    | DATE            | NOT NULL                                               | 제품 등록일   |
| pr_thum_img   | VARCHAR(2000)   | NOT NULL                                               | 썸네일 이미지 |
| pr_detail_img | VARCHAR(2000)   | NOT NULL                                               | 상세 이미지   |

---

## 5. `PRODUCT_STOCKS` (제품 재고 테이블)

| 컬럼명   | 데이터 타입   | 제약 조건                                                  | 설명         |
|----------|----------------|-------------------------------------------------------------|--------------|
| pr_st_id | NUMBER          | PK, IDENTITY                                               | 재고 ID (자동 증가) |
| pr_id    | NUMBER          | NOT NULL, FK → PRODUCTS.pr_id                             | 제품 ID       |
| cl_id    | VARCHAR(2000)   | NOT NULL, FK → COLORS.cl_id                               | 색상 ID       |
| sz_id    | VARCHAR(3)      | NOT NULL, CHECK ('XS', 'S', 'M', 'L', 'XL', 'XXL')         | 사이즈        |
| quantity | NUMBER          | NOT NULL                                                  | 재고 수량     |
| price    | NUMBER          | NOT NULL                                                  | 가격          |

---

## 6. `ORDERS` (주문 테이블)

| 컬럼명           | 데이터 타입   | 제약 조건                                          | 설명           |
|------------------|----------------|---------------------------------------------------|----------------|
| order_id         | NUMBER          | PK, IDENTITY                                     | 주문 ID (자동 증가) |
| user_id          | NUMBER          | NOT NULL, FK → USERS.user_id                     | 사용자 ID      |
| order_date       | DATE            | NOT NULL                                         | 주문 날짜       |
| total_price      | NUMBER          | NOT NULL                                         | 총 주문 금액    |
| pay_id           | VARCHAR2(10)    | NOT NULL, CHECK ('card', 'kakao', 'naverpay')    | 결제 방식       |
| shipping_address | VARCHAR(2000)   | NOT NULL                                         | 배송 주소       |
| shipping_date    | DATE            | NULL 가능                                        | 배송 예정일     |

---

## 7. `ORDER_DETAILS` (주문 상세 테이블)

| 컬럼명         | 데이터 타입   | 제약 조건                                | 설명             |
|----------------|----------------|------------------------------------------|------------------|
| order_detail_id| NUMBER          | PK, IDENTITY                             | 주문 상세 ID (자동 증가) |
| order_id       | NUMBER          | FK → ORDERS.order_id                    | 주문 ID          |
| user_id        | NUMBER          | NOT NULL, FK → USERS.user_id            | 사용자 ID        |
| pr_st_id       | NUMBER          | NOT NULL, FK → PRODUCT_STOCKS.pr_st_id  | 제품 재고 ID     |
| order_quantity | NUMBER          | NOT NULL                                | 주문 수량        |
| order_price    | NUMBER          | NOT NULL                                | 주문 가격        |
