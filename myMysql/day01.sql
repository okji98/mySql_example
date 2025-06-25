USE employees;
SHOW TABLES;
SELECT * FROM employees;
-- employees table에서 first_name, gender을 가져오자.
SELECT first_name, gender FROM employees; 
/* employees table에서 이름, 성별, 입사일을 가져오되,
칼럼이름도 이름, 성별, 입사일로 출력하자 */
SELECT first_name as '이름', gender '성별', hire_date as '입사일' FROM employees; 

DROP DATABASE if exists sqldb; -- 만약에 sqldb가 있으면 삭제
CREATE DATABASE sqldb;

--
use sqldb;
create table usertbl 
( userID	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  name		VARCHAR(10) NOT NULL, -- 이름
  birthYear	INT NOT NULL, -- 출생년도
  addr		CHAR(2) NOT NULL, -- 지역(경기, 서울, 경남 식으로 2글자만 입력)
  mobile1 	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height	SMALLINT, -- 키
  mDate		DATE -- 회원 가입일
);

CREATE TABLE buytbl -- 회원 구매 테이블(Buy Table의 약자)
(  num         INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID      CHAR(8) NOT NULL, -- 아이디(FK)
   prodName     CHAR(6) NOT NULL, --  물품명
   groupName     CHAR(4)  , -- 분류
   price         INT  NOT NULL, -- 단가
   amount        SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '010', '12341234', 180, '2020-08-08');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');

SELECT * FROM usertbl;
SELECT count(name) FROM usertbl;

INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL, 50, 2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

SELECT * FROM buytbl;

-- 1970년 이후에 출생하고 신장이 180이상인 사람의 아이디와 이름을 조회해보자.
SELECT userID '아이디', name '이름', height '키', birthYear '출생년도' 
	FROM usertbl
    WHERE height >= 180 and birthYear >=1970;
    
-- 위의 조건은 BETWEEN 으로 사용할 수 있다.
SELECT userID 아이디, name 이름 FROM usertbl
	WHERE height BETWEEN 180 AND 183;
    
SELECT userID 아이디, name 이름 FROM usertbl
	WHERE birthYear BETWEEN 1970 AND 2025;
    
SELECT userID 아이디, name 이름 FROM usertbl
	WHERE height BETWEEN 180 AND 190
    AND	  birthYear BETWEEN 1970 AND 2025;
    
-- 주소가 '경남', '전남', '경북'
SELECT name 이름, addr 주소 FROM usertbl
	WHERE addr = '경남' or addr = '전남' or addr = '경북';
    
-- in 키워드를 사용하여 주소가 '경남', '전남', '경북'인 사용자의 이름과 주소를 가져오자.
SELECT name 이름, addr 주소 FROM usertbl
	WHERE addr IN ('경남', '전남', '경북');
    
-- 이름이 '김'자로 시작하는 회원의 명단을 출력하자.
SELECT * FROM usertbl
	WHERE name LIKE '김%';
    
-- 이름이 '종신'으로 끝나는 회원의 명단을 출력하자.
SELECT * FROM usertbl
	WHERE name LIKE '%종신';
    
-- 이름이 '종신'으로 끝나고 앞 글자가 1자리인 회원의 명단을 출력하자.
SELECT * FROM usertbl
	WHERE name LIKE '_종신';
    
-- 서브쿼리
-- 회원중에 '김경호'보다 키가 작은 회원의 이름과 키를 출력하자.
SELECT name 이름, height 키 FROM usertbl
	WHERE height <
	(SELECT height FROM usertbl
		WHERE name = '김경호');
        
-- 회원중에 주소가 '경남'인 사람의 키보다 큰 회원 명단을 출력하자.
-- ANY 는 OR와 같다.
SELECT * FROM usertbl
	WHERE height >
    ANY (SELECT height FROM usertbl
			WHERE addr = '경남');
-- ALL은 둘 다 만족해야한다.
SELECT * FROM usertbl
	WHERE height >
    ALL (SELECT height FROM usertbl
			WHERE addr = '경남');
-- IN : 170인 사람, 173인 사람만 읽어와라
SELECT * FROM usertbl
	WHERE height
    IN (SELECT height FROM usertbl WHERE addr = '경남');
-- 경남인 사람들의 평균키보다 전체회원들의 키가 큰 회원을 구해라.
SELECT * FROM usertbl
	WHERE height >
     (SELECT AVG(height) FROM usertbl WHERE addr = '경남');
     
-- order by: 정렬
-- 회원 테이블에서 가입일 순으로 이름과 가입일을 출력하자.
SELECT name 이름, mDate 가입일 FROM usertbl
	order by mDate;
-- 역순
select name 이름, mDate 가입일 from usertbl
	order by mDate desc;
-- 회원 테이블에서 가입일 순으로 이름, 키, 가입일을 키는 역순으로, 가입일은 순서대로 출력하자.
select name 이름, height 키, mDate 가입일 from usertbl
	order by height desc, mDate;
    
USE employees;
-- 사원번호를 입자일사순으로 10명만 출력해보자
SELECT emp_no 사원번호, hire_date 입사일자
  FROM employees
  ORDER BY hire_date
  LIMIT 10;
-- OFFSET: 5, LIMIT: 10
SELECT emp_no 사원번호, hire_date 입사일자
  FROM employees
  ORDER BY hire_date
  LIMIT 5, 10;
SELECT emp_no 사원번호, hire_date 입사일자
  FROM employees
  ORDER BY hire_date
  LIMIT 10 OFFSET 5;
  
-- SELECT문을 이용하여 테이블 복사하기
-- key, extra같은 제약조건은 못가져온다.
USE sqldb;
CREATE TABLE buytbl2 (
	SELECT * FROM buytbl);
    
SELECT * FROM buytbl2;

DESC buytbl;
DESC buytbl2;

-- buytbl에서 사용자별 순으로 사용자ID와 amount를 출력해보자.
SELECT userid 사용자, amount 구매수량
	FROM buytbl
    ORDER BY userid;
    
SELECT userid 사용자, sum(amount) 구매수량
	FROM buytbl
    GROUP BY userid;
    
SELECT userid 사용자, SUM(price * amount) 구매합계
	FROM buytbl
    GROUP BY userid;
    
-- 전체 사용자의 구매액 합계를 출력하자.
-- 같은 SELECT 문에서는 alias 명 사용이 안된다.
SELECT SUM(price * amount) '총 구매액', AVG(price * amount) '총 평균액'
	FROM buytbl;
    
-- 사용자중 가장 키가 작은 사람의 이름과 키를 구하자.
SELECT name, height FROM usertbl
	WHERE height = (SELECT MIN(height) FROM usertbl);
-- 사용자중 가장 키가 큰 사람의 이름과 키를 구하자.
SELECT name, height FROM usertbl
	WHERE height = (SELECT MAX(height) FROM usertbl);
    
-- 사용자별 총구매금액이 1000원 이상인 사용자ID와 금액을 구하자.
SELECT userid, SUM(price * amount) FROM buytbl
	GROUP BY userid
    HAVING SUM(price * amount) >= 1000;
    
-- 사용자별 총구매금액이 1000원 이상인 사용자ID와 금액을 금액순서대로 구하자.
SELECT userid, SUM(price * amount) '총구매액' FROM buytbl
	GROUP BY userid
    HAVING 총구매액 >= 1000
    ORDER BY 총구매액;
    
-- 부분합, 총합을 구하는 ROLLUP
SELECT num, groupName, SUM(price * amount) 비용
	FROM buytbl
    GROUP BY groupName, num
    WITH ROLLUP;
    
SELECT groupName, SUM(price * amount) 비용
	FROM buytbl
    GROUP BY groupName
    WITH ROLLUP;
    
-- DDL에 속하는 CREATE
CREATE TABLE testtbl1 (id int, username char(3), age int);
-- INSERT에서 일부 컬럼에만 데이터를 입력할 때에는 컬럼명과 값을 명시적으로 사용
INSERT INTO testtbl1 (id, username) VALUES (1, '홍길동');
-- INSERT에서 모든 컬럼에 데이터를 입력할 때에는 컬럼명을 생략
INSERT INTO testtbl1 VALUES (2, '김자바', 25);
-- AUTO INCREMENT는 NULL로 주면 DB엔진에서 자동으로 번호를 매긴다.

-- 테이블을 생성할 때 데이터를 복사하고, 구조는 따로 만들 수 있다.
CREATE TABLE testtbl4 (id int, fname varchar(50), lname varchar(50));
INSERT INTO testtbl4
	SELECT emp_no, first_name, last_name
		FROM employees.employees;
-- 아래의 경우 지정한 컬럼이 생성 된 후 employees의 컬럼이 또 생성된다.
CREATE TABLE testtbl5 (id int, fname varchar(50), lname varchar(50))
	(SELECT emp_no, first_name, last_name FROM employees.employees);
    
SELECT lname FROM testtbl4 WHERE fname = 'Kyoichi';
-- 입력된 컬럼의 데이터를 변경하는 UPDATE
UPDATE testtbl4
	SET lname = '없음'
    WHERE fname = 'Kyoichi';
-- ***주의*** WHERE 구문이 없으면 몽땅 지워짐.
DELETE FROM testtbl4 WHERE fname = 'Kyoichi';

-- DELETE와 DROP과 TRUNCATE
CREATE TABLE bigtbl1 (SELECT * FROM employees.employees);
CREATE TABLE bigtbl2 (SELECT * FROM employees.employees);
CREATE TABLE bigtbl3 (SELECT * FROM employees.employees);

DELETE FROM bigtbl1; -- 구조는 남기고 데이터만 삭제
DROP TABLE bigtbl2; -- 구조까지 삭제
TRUNCATE TABLE bigtbl3; -- 구조는 남기고 데이터만 삭제