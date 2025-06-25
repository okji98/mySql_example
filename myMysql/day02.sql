-- 날짜
SELECT CAST('2020-10-19 12:35:29.123' AS DATE) AS 'DATE';
-- 시간
SELECT CAST('2020-10-19 12:35:29.123' AS TIME) AS 'TIME';
-- 날짜, 시간
SELECT CAST('2020-10-19 12:35:29.123' AS DATETIME) AS 'DATETIME';

-- 변수 사용
SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름==>';

SELECT @myVar1;
SELECT @myVar2 + @myVar3;

SELECT @myVar4, Name FROM usertbl WHERE height > 100;

SET @myVar1 = 3;
PREPARE myQuery
	FROM 'SELECT Name, height FROM usertbl ORDER BY height LIMIT ?'
EXECUTE myQuery USING @myVar1;

-- 형변환
SELECT AVG(amount) AS '평균 구매 개수' FROM buytbl;

SELECT CAST(AVG(amount) AS SIGNED INTEGER) AS '평균 구매 개수' FROM buytbl;
-- 또는 
SELECT CONVERT(AVG(amount) , SIGNED INTEGER) AS '평균 구매 개수'  FROM buytbl ;

SELECT CAST('2020$12$12' AS DATE);
SELECT CAST('2020/12/12' AS DATE);
SELECT CAST('2020%12%12' AS DATE);
SELECT CAST('2020@12@12' AS DATE);

-- 구매테이블에서 단가, 수량을 가져와 텍스트 형식으로 형변환
SELECT num, CONCAT(CAST(price AS CHAR(10)), 'X', CAST(amount AS CHAR(4)) ,'=' )  AS '단가X수량',
    price*amount AS '구매액' 
  FROM buytbl ;
  
SELECT '100' + '200'; -- 문자와 문자를 더함 (정수로 변환되서 연산함)
SELECT CONCAT('100', '200'); -- 문자와 문자를 연결 (문자로 처리)
SELECT CONCAT(100, '200'); -- 정수와 문자를 연결(정수가 문자로 변환되서 처리)
SELECT 1 > '2mega'; -- 정수인 2로 변환되어서 비교
SELECT 3 > '2MEGA'; -- 정수인 2로 변환되어서 비교
SELECT 0 = 'mega2'; -- 문자는 0으로 변환됨.

CREATE TABLE pivotTest
	(uName CHAR(3),
	 season CHAR(3),
     amount INT);
     
INSERT INTO pivotTest VALUES
    ('김범수', '겨울', 10), ('윤종신', '여름', 15), ('김범수', '가을', 25), ('김범수', '봄', 3),
    ('김범수', '봄', 37), ('윤종신', '겨울', 40), ('김범수', '여름', 14), ('김범수', '겨울', 22),
    ('윤종신', '여름', 64) ;
SELECT * FROM pivotTest;

-- 피벗
SELECT uName,
	SUM(IF(season = '봄', amount, 0)) AS '봄',
    SUM(IF(season = '여름', amount, 0)) AS '여름',
    SUM(IF(season = '가을', amount, 0)) AS '가을',
    SUM(IF(season = '겨울', amount, 0)) AS '겨울',
    SUM(amount) AS '합계' FROM pivottest GROUP BY uName;
    
SELECT JSON_OBJECT('name', name, 'height', height) AS 'JSON 값'
	FROM usertbl
    WHERE height >= 180;
    
CREATE TABLE jsonusers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    info JSON -- info 컬럼을 JSON형식으로 지정
);

INSERT INTO jsonusers (info)
	VALUES ('{"name": "홍길동", "age": 25, "skills":["python", "MySQL"]}'),
		   ('{"name": "김연희", "age": 27, "skills":["Java", "PostgreSQL"]}');
           
SELECT * FROM jsonusers;
-- json형식의 파일의 값을 찾아올 때 키 값을 써준다.
SELECT info ->> '$.name' AS name,
	   info ->> '$.age' AS age,
       info ->> '$.skills' AS skills,
	FROM jsonusers;
-- 배열에서 원하는 값 꺼내기
SELECT info ->> '$.name' AS name,
	   JSON_EXTRACT(info, '$.skills[0]') AS skill_1
	FROM jsonusers;
    
-- JSON 데이터 수정하기
UPDATE jsonusers
	SET info = JSON_SET(info, '$.age', 30)
    WHERE info ->> '$.name' = '홍길동';
    
SELECT * FROM jsonusers;

-- JSON 데이터 삭제하기
UPDATE jsonusers
	SET info = JSON_REMOVE(info, '$.skills')
    WHERE info ->> '$.name' = '김연희';
SELECT * FROM jsonusers;

-- INNER JOIN
SELECT *
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
	WHERE buytbl.userID = 'JYP';
    
SELECT *
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
	ORDER BY num;
    
SELECT *
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
	ORDER BY buytbl.userID;
    
-- 택배 송장을 출력하기 위해 사용자 ID, 이름, 상품명, 주소, 전화번호 읽어오자.
SELECT buytbl.userID, name, prodName, addr, CONCAT(mobile1, mobile2) AS '전화번호'
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
	ORDER BY buytbl.num;
 -- 이렇게 쓰는게 관례   
SELECT buytbl.userID, name, prodName, addr, CONCAT(mobile1, mobile2) AS '전화번호'
	FROM buytbl, usertbl
	WHERE buytbl.userID = usertbl.userID
	ORDER BY buytbl.num;

SELECT b.userID ID, name 이름, prodName 상품명, addr 주소, CONCAT(mobile1, mobile2) 전화번호
	FROM buytbl b, usertbl u
    WHERE b.userID = u.userID AND u.userID = 'JYP';
    
CREATE TABLE stdtbl
( stdName	VARCHAR(10) NOT NULL PRIMARY KEY,
  addr		CHAR(4) NOT NULL
);

CREATE TABLE clubtbl
( clubName	VARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo	CHAR(4) NOT NULL
);

CREATE TABLE stdclubtbl
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  stdName 	VARCHAR(10) NOT NULL,
  clubName	VARCHAR(10) NOT NULL,
FOREIGN KEY(stdName) REFERENCES stdtbl(stdName),
FOREIGN KEY(clubName) REFERENCES clubtbl(clubName)
);

INSERT INTO stdtbl VALUES ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'), ('은지원', '경북'), ('바비킴', '서울');
INSERT INTO clubtbl VALUES ('수영','101호'), ('바둑','102호'), ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubtbl VALUES (NULL, '김범수','바둑'), (NULL,'김범수','축구'), (NULL,'조용필','축구'), (NULL,'은지원','축구'), (NULL,'은지원','봉사'), (NULL,'바비킴','봉사');

SELECT * FROM stdtbl;
SELECT * FROM clubtbl;
SELECT * FROM stdclubtbl;

SELECT s.stdName, s.addr, sc.clubname, c.roomno
	FROM stdtbl s
    INNER JOIN stdclubtbl sc
		ON s.stdName = sc.stdName
	INNER JOIN clubtbl c
		ON sc.clubname = c.clubname
	ORDER BY s.stdname;
    
-- 정렬기준을 clubname으로 하고, 클럽별 학생을 조회하자.
SELECT sc.clubname, c.roomno, s.stdName, s.addr 
	FROM stdtbl s
    INNER JOIN stdclubtbl sc
		ON s.stdName = sc.stdName
	INNER JOIN clubtbl c
		ON sc.clubname = c.clubname
	ORDER BY sc.clubname;

-- 구매이력이 없는 회원들도 출력하려면 OUTER JOIN을 적용한다.
-- 1. LEFT OUTER JOIN
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM usertbl U
		LEFT OUTER JOIN buytbl B
			ON U.userID = B.userID
	ORDER BY U.userID;
-- 2. RIGHT OUTER JOIN
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buytbl B
		LEFT OUTER JOIN usertbl U
			ON B.userID = U.userID
	ORDER BY B.userID;
    
-- CROSS JOIN : 각 행을 다른 TABLE의 모든 행에 JOIN
SELECT * FROM buytbl
	CROSS JOIN usertbl;

-- SELF JOIN
CREATE TABLE emptbl (emp CHAR(3), maneger CHAR(3), empTel VARCHAR(8));
INSERT INTO empTbl VALUES('나사장', NULL, '0000');
INSERT INTO empTbl VALUES('김재무','나사장','2222');
INSERT INTO empTbl VALUES('김부장','김재무','2222-1');
INSERT INTO empTbl VALUES('이부장','김재무','2222-2');
INSERT INTO empTbl VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTbl VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTbl VALUES('이영업','나사장','1111');
INSERT INTO empTbl VALUES('한과장','이영업','1111-1');
INSERT INTO empTbl VALUES('최정보','나사장','3333');
INSERT INTO empTbl VALUES('윤차장','최정보','3333-1');
INSERT INTO empTbl VALUES('이주임','윤차장','3333-1-1');

SELECT a.emp 부하직원, b.emp 직속상관, b.emptel 직속상관연락처
	FROM empTbl a
    INNER JOIN empTbl b
    ON a.maneger = b.emp
    WHERE a.emp = '우대리';

-- UNION ALL: 쿼리의 결과를 위, 아래로 쌓기
-- UNION: 중복을 제거하고 쌓기
SELECT stdname, addr FROM stdtbl
UNION ALL
SELECT clubname, roomno FROM clubtbl;

SELECT * FROM usertbl;

CREATE DATABASE tabledb; 
USE tabledb;

CREATE TABLE usertbl (
	userid 	  CHAR(8) NOT NULL,
    name 	  VARCHAR(10) NOT NULL,
    birthyear INT NOT NULL,
    addr 	  CHAR(2) NOT NULL,
    mobile1   CHAR(3) NULL,
    mobile2   CHAR(8) NULL,
    height 	  SMALLINT NULL,
    mdate 	  DATE NULL
);

ALTER TABLE usertbl
	ADD CONSTRAINT pk_usertbl_userid
    PRIMARY KEY (userid);

CREATE TABLE buytbl (
	num INT NOT NULL AUTO_INCREMENT,
    userid CHAR(8) NOT NULL,
    prodname CHAR(6) NOT NULL,
    groupname CHAR(4) NULL,
    price INT NOT NULL,
    amount SMALLINT NOT NULL,
    CONSTRAINT PRIMARY KEY(num),
    FOREIGN KEY(userid) REFERENCES usertbl(userid)
);

-- UNIQUE 제약조건
DROP TABLE IF EXISTS buytbl, usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthyear INT NOT NULL,
    email CHAR(30) NULL UNIQUE
);

-- CHECK 제약조건
-- 출생연도가 1900년 이후 그리고 2026년 이전, 이름은 반드시 넣어야 함.
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl (
	userID CHAR(8) PRIMARY KEY,
    name VARCHAR(10),
    birthyear INT CHECK (birthyear >= 1900 AND birthyear <= 2026),
    mobile1 CHAR(3) NULL,
    CONSTRAINT CK_name CHECK (name IS NOT NULL)
);

SELECT * FROM information_schema.table_constraints
	WHERE table_schema = 'usertbl';