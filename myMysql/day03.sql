USE tabledb;
DROP TABLE IF EXISTS buytbl, usertbl;

CREATE TABLE usertbl (
	userID	  CHAR(8),
    name	  VARCHAR(10),
    birthYear INT,
    addr	  CHAR(2),
    mobile1	  CHAR(3),
    mobile2   CHAR(8),
    height	  SMALLINT,
    mDate	  DATE
);

CREATE TABLE buytbl (
	num INT AUTO_INCREMENT PRIMARY KEY,
    userid CHAR(8),
    prodName CHAR(6),
    groupName CHAR(4),
    price INT,
    amount SMALLINT
);
-- 테이블의 제약조건이 없으면 데이터의 유효성 검사가 이루어지지 않아 잘못된 데이터도 삽입이 된다.
INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', NULL, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1871, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buytbl VALUES(NULL,'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL,'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL,'BBK', '모니터', '전자', 200,  5);

-- 기본키 제약 조건 추가, 이때 자동으로 NOT NULL도 추가된다.
ALTER TABLE usertbl
	ADD CONSTRAINT pk_usertbl_userid
    PRIMARY KEY (userid);
    
DESC usertbl;

-- 외래키 제약 조건에 위배되는 데이터 삭제 후 다시 설정
DELETE FROM buytbl WHERE userid = 'BBK';

-- 외래키 제약조건을 설정하자.
ALTER TABLE buytbl
	ADD CONSTRAINT fk_usertbl_buytbl
    FOREIGN KEY (userid) REFERENCES usertbl (userid);
    
DESC buytbl;

-- 대용량 데이터를 처리하거나 테스트 데이터를 삽입할 때 예외적으로 외래키 제약조건을 비활성화 시킬 수 있다.
SET foreign_key_checks = 0;
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
-- 다시 활성화하기
SET foreign_key_checks = 1;

-- birthYear 체크 제약조건을 추가할 때 기존의 유효하지 않은 데이터로 인해 추가가 안됨.
-- 그러므로 데이터를 삭제하거나 UPDATE함.
-- buytbl에 자료를 가진 KBS의 경우 NULL을 UPDATE한다.
UPDATE usertbl SET birthYear = 1979 WHERE userid = 'KBS';
DELETE FROM usertbl WHERE birthYear < 1900 OR birthYear > 2025 OR (birthYear IS NULL);
-- CHECK 제약조건을 설정하자.
-- usertbl의 출생년도를 1900~2025까지 제한하자.
ALTER TABLE usertbl
	ADD CONSTRAINT ck_birthYear
    CHECK ((birthYear >= 1900 AND birthYear <= 2025) AND (birthYear IS NOT NULL));
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');

INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '00110011', 176, '2013-05-07');
-- 바비킴 회원이 id 변경 요청을 함.
UPDATE usertbl SET userid = 'VVK' WHERE userid = 'BBK';
SELECT * FROM usertbl;

-- usertbl 데이터 추가하기
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');

-- 1. 외래키 제약조건을 비활성화 한 후 UPDATE
SET foreign_key_checks = 0;
UPDATE usertbl SET userid = 'VVK' WHERE userid = 'BBK';
SET foreign_key_checks = 1;
SELECT * FROM usertbl;

-- 두 개의 테이블을 JOIN 해 보자.
-- 1. INNER JOIN
SELECT b.userid, u.name, b.prodname, u.addr, CONCAT(u.mobile1, u.mobile2) AS '연락처'
	FROM buytbl b
    INNER JOIN usertbl u
    ON b.userid = u.userid;
    
SELECT COUNT(*) FROM buytbl;

-- 2. OUTER JOIN으로 누락된 회원을 확인하자.
SELECT b.userid, u.name, b.prodname, u.addr, CONCAT(u.mobile1, u.mobile2) AS '연락처'
	FROM buytbl b
    LEFT OUTER JOIN usertbl u
    ON b.userid = u.userid;
    
-- FOREIGN KEY 제약조건을 비활성화 한 후 VVK -> BBK 변경
SET foreign_key_checks = 0;
UPDATE usertbl SET userid = 'BBK' WHERE userid = 'VVK';
SET foreign_key_checks = 1;

-- BBK의 userid 변경 시 두가지의 정책을 고려해 볼 수 있다.
-- 1. buytbl에도 업데이트를 적용하기
-- 2. 기존대로 변경을 못하게 할 수 있다.
ALTER TABLE buytbl DROP FOREIGN KEY fk_usertbl_buytbl;
ALTER TABLE buytbl
	ADD CONSTRAINT fk_usertbl_buytbl
    FOREIGN KEY (userid)
    REFERENCES usertbl (userid)
    ON UPDATE CASCADE;
    
UPDATE usertbl SET userid = 'VVK' WHERE userid = 'BBK';

SELECT b.userid, u.name, b.prodname, u.addr, CONCAT(u.mobile1, u.mobile2) AS '연락처'
	FROM buytbl b
    INNER JOIN usertbl u
    ON b.userid = u.userid;
    
SELECT * FROM usertbl;
SELECT * FROM buytbl;
-- 구매 내역이 있는 회원의 정보를 usertbl에서 삭제할 때에도 UPDATE와 같은 정책을 사용한다.
ALTER TABLE buytbl
	DROP FOREIGN KEY fk_usertbl_buytbl;
    
ALTER TABLE buytbl
	ADD CONSTRAINT fk_usertbl_buytbl_cascade
    FOREIGN KEY (userid)
    REFERENCES usertbl (userid)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
DELETE FROM usertbl WHERE userid = 'VVK';
SELECT b.userid, u.name, b.prodname, u.addr, CONCAT(u.mobile1, u.mobile2) AS '연락처'
	FROM buytbl b
    INNER JOIN usertbl u
    ON b.userid = u.userid;
    
-- VIEW
CREATE VIEW v_usertbl
	AS SELECT userid, name, addr FROM usertbl;
SELECT * FROM v_usertbl;
-- VIEW의 장점 : 보안에 유리, 복잡한 쿼리의 단순화
CREATE VIEW v_userbuytbl
AS
SELECT u.userid, u.name, b.prodname, u.addr, CONCAT(u.mobile1, u.mobile2) AS '연락처'
	FROM usertbl u
    INNER JOIN buytbl b
    ON u.userid = b.userid;
SELECT * FROM v_userbuytbl;
-- VIEW를 생성할 때 컬럼명을 변경해서 저장이 가능하며, 이를 읽어올 때는 백틱(``)을 사용한다.
CREATE VIEW v_userbuytbl_as
AS
SELECT u.userid AS 'User ID', u.name AS 'User Name', b.prodname AS 'Product Name', u.addr, CONCAT(u.mobile1, u.mobile2) AS 'Mobile Phone'
	FROM usertbl u
    INNER JOIN buytbl b
    ON u.userid = b.userid;
    
SELECT * FROM v_userbuytbl_as;
-- `` 백틱을 사용하면 읽어올 수 있다.
SELECT `User Name` FROM v_userbuytbl_as;

-- 뷰의 구조를 확인하자.
DESC v_userbuytbl_as;
-- VIEW를 생성할 때의 쿼리문을 확인하려면 SHOW CREATE VIEW
SHOW CREATE VIEW v_userbuytbl_as;

-- VIEW를 통한 데이터 변경
SELECT * FROM v_usertbl;
UPDATE v_usertbl SET addr = '부산' WHERE userid = 'JKW';
SELECT 
    name, addr
FROM
    usertbl;

-- VIEW를 통한 데이터 입력
INSERT INTO v_usertbl VALUE ('LSH', '이선희', '서울');

-- INDEX
-- PRIMARY KEY: 클러스터형 인덱스, UNIQUE: 보조 인덱스
USE sqldb;
CREATE TABLE tbl1 (
    a INT PRIMARY KEY,
    b INT UNIQUE,
    c INT
);
SHOW INDEX FROM tbl1;

CREATE TABLE tbl2 (
    a INT UNIQUE NOT NULL,
    b INT UNIQUE,
    C INT
);
SHOW INDEX FROM tbl2;

-- PRIMARY KEY와 UNIQUE NOT NULL이면 PRIMARY KEY가 클러스터형 인덱스가 된다.
CREATE TABLE tbl3 (
    a INT UNIQUE NOT NULL,
    b INT UNIQUE,
    c INT PRIMARY KEY
);
SHOW INDEX FROM tbl3;

SELECT * FROM usertbl;

ALTER TABLE usertbl
	ADD CONSTRAINT pk_name PRIMARY KEY(name);
    
-- 클러스터 인덱스와 보조 인덱스 구조
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
DROP TABLE IF EXISTS clustertbl;
CREATE TABLE clustertbl (
    userid CHAR(8),
    name VARCHAR(10)
);
INSERT INTO clustertbl VALUES('LSG', '이승기');
INSERT INTO clustertbl VALUES('KBS', '김범수');
INSERT INTO clustertbl VALUES('KKH', '김경호');
INSERT INTO clustertbl VALUES('JYP', '조용필');
INSERT INTO clustertbl VALUES('SSK', '성시경');
INSERT INTO clustertbl VALUES('LJB', '임재범');
INSERT INTO clustertbl VALUES('YJS', '윤종신');
INSERT INTO clustertbl VALUES('EJW', '은지원');
INSERT INTO clustertbl VALUES('JKW', '조관우');
INSERT INTO clustertbl VALUES('BBK', '바비킴');

-- PRIMARY KEY, UNIQUE등 인덱스가 정의 되지 않으면 입력한 순서대로 나옴.
SELECT * FROM clustertbl;

ALTER TABLE clustertbl
	ADD CONSTRAINT pk_clustertbl_userid
    PRIMARY KEY (userid);
-- 클러스터형 인덱스가 생성되면 인덱스 순으로 나옴.
SELECT * FROM clustertbl;

CREATE TABLE secondarytbl (
    userid CHAR(8),
    name VARCHAR(10)
);
INSERT INTO secondarytbl VALUES('LSG', '이승기');
INSERT INTO secondarytbl VALUES('KBS', '김범수');
INSERT INTO secondarytbl VALUES('KKH', '김경호');
INSERT INTO secondarytbl VALUES('JYP', '조용필');
INSERT INTO secondarytbl VALUES('SSK', '성시경');
INSERT INTO secondarytbl VALUES('LJB', '임재범');
INSERT INTO secondarytbl VALUES('YJS', '윤종신');
INSERT INTO secondarytbl VALUES('EJW', '은지원');
INSERT INTO secondarytbl VALUES('JKW', '조관우');
INSERT INTO secondarytbl VALUES('BBK', '바비킴');

SELECT * FROM secondarytbl;

ALTER TABLE secondarytbl
	ADD CONSTRAINT uk_secondarytbl_userid
    UNIQUE (userid);
    
INSERT INTO clustertbl VALUES('FNT', '푸니타');
INSERT INTO clustertbl VALUES('KAI', '카아이');

INSERT INTO secondarytbl VALUES('FNT', '푸니타');
INSERT INTO secondarytbl VALUES('KAI', '카아이');

-- 인덱스 
CREATE DATABASE IF NOT EXISTS indexdb;
USE indexdb;
SELECT COUNT(*) FROM employees.employees;

CREATE TABLE emp SELECT * FROM
    employees.employees
ORDER BY RAND();
CREATE TABLE emp_c SELECT * FROM
    employees.employees
ORDER BY RAND();
CREATE TABLE emp_se SELECT * FROM
    employees.employees
ORDER BY RAND();

SELECT * FROM emp LIMIT 5;
SELECT * FROM emp_c LIMIT 5;
SELECT * FROM emp_se LIMIT 5;

-- 테이블에 인덱스가 있는지 확인
SHOW TABLE STATUS;

ALTER TABLE emp_c ADD PRIMARY KEY(emp_no);
ALTER TABLE emp_se ADD INDEX idx_emp_no(emp_no);

SELECT * FROM emp LIMIT 5;
SELECT * FROM emp_c LIMIT 5;
SELECT * FROM emp_se LIMIT 5;

ANALYZE TABLE emp, emp_c, emp_se;

SHOW INDEX FROM emp;
SHOW INDEX FROM emp_c;
SHOW INDEX FROM emp_se;
SHOW TABLE STATUS;

-- 스토어드 프로시저
USE tabledb;
DROP PROCEDURE IF EXISTS userProc2;
DELIMITER $$
CREATE PROCEDURE userProc2(
	IN userbirth INT,
	IN userheight INT
)
BEGIN
	SELECT * FROM usertbl
		WHERE birthyear > userbirth AND height > userheight;
END $$
DELIMITER ;

CALL userProc2(170, 178);

DROP PROCEDURE IF EXISTS userProc3;
DELIMITER %%
CREATE PROCEDURE userProc3(
	IN	txtValue CHAR(10),
    OUT outValue INT
)
BEGIN
	INSERT INTO testtbl values(NULL, txtvalue);
    SELECT MAX(id) INTO outValue FROM testtbl;
END %%
DELIMITER ;

CREATE TABLE IF NOT EXISTS testtbl (
    id INT AUTO_INCREMENT PRIMARY KEY,
    txt CHAR(10)
);

CALL userProc3 ('테스트', @myValue);
SELECT @myValue;
CALL userProc3 ('테스트', @myValue);
SELECT @myValue;