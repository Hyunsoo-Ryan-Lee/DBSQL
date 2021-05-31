-- 1.select.sql 
-- OR /* >> oracle db에서의 주석 표기

존재하는 데이터를 검색하는 명령어 학습

1. 기본 syntax
	select 기본검색하려는column명 from table명;
	실행순서 : from -> select


2. 정렬 syntax
	select 기본검색하려는column명 from table명 order by 기준column명 asc/desc;
	실행순서 : from -> select -> order by


3. 조건절 & order by syntax
	from -> where -> select -> order by



		  
--1. sqlplus창 보기 화면 여백 조절 편집 명령어
	-- 단순 sqlplus tool만의 편집 명령어
	-- 영구 저장 안됨. sqlplus 실행시마다 해 줘야 함
set linesize 200
set pagesize 200
 

--2. 해당 계정의 모든 table 목록 검색
select * from tab;


--3. emp table의 모든 정보 검색
select * from emp;


--4. emp table의 구조 검색[묘사]
desc emp;
	- NUMBER(4) : 정수 4자리
	- VARCHAR2(10) : 철자 10개까지 허용하는 문자열
	- NUMBER(7,2) : 실수, 전체 자릿수 7자리. 단, 소수점 이하 2자리


--5. emp table의 사번(empno)과 이름(ename)만 검색
	- select empno, ename from emp; (ctrl+c 후 cmd창 우클릭하면 붙여넣기 됨)


--6. emp table의 입사일(hiredate) 검색
	 -select hiredate from emp;

	
--7. emp table의 검색시 칼럼명 empno를 사번이란 별칭으로 검색 
	- select empno as 사번 from emp;


--8. emp table에서 부서번호(deptno) 검색시 중복 데이터 제거후 검색 
	- select distinct deptno from emp; 
	- distinct >> 중복 제거 기능의 keyword

--9. 데이터를 오름차순(asc)으로 검색하기(순서 정렬)

-- ? 사번을 오름차순으로 정렬 해서 사번만 검색
	- select distinct deptno from emp order by deptno asc;
	- select distinct deptno from emp order by deptno desc;



-- 10.emp table 에서 deptno 내림차순 정렬 적용해서 ename과 deptno 검색하기
	- select ename,deptno from emp order by deptno desc;

--? empno와 deptno를 검색하되 단 deptno는 오름차순 검색
	- select ename,deptno from emp order by deptno asc;


-- 11. 입사일(date 타입의 hiredate) 검색, date 타입은 정렬가능 따라서 경력자(입사일이 오래된 직원)부터 검색(asc)
	- select empno,hiredate from emp order by hiredate asc;

	- 잉여 table(dummy table - dual table) : syntax 문법 오류 방지용으로 주로 사용


-- *** 연산식 ***
--12. emp table의 모든 직원명(ename), 월급여(sal), 연봉(sal*12) 검색
-- 단 sal 컴럼값은 comm을 제외한 sal만으로 연봉 검색
	- select ename,sal,sal*12 from emp;



-- 13. 모든 직원의 연봉 검색(sal *12 + comm) 검색
	- data 자체가 null인 경우 연산 자체가 무효화되어 결과도 null로 나옴
	  해결 : null은 연산불가하므로 0으로 치환하여 연산
	-> select sal,comm,sal*12+comm as total from emp;
	  (sal *12 + comm -> total로 이름 변경함)

	- null 값을 다른 값으로 치환하는 함수 : nvl(null보유컬럼, 변경할 값)
	-> select sal,comm, nvl(comm,0) from emp; (null값을 0으로 치환)
	-> select sal,comm, sal*12+nvl(comm,0) as 연봉 from emp;



-- *** 조건식 ***
--14. comm이 null인 사원에 대한 검색(ename, comm)
	- select ename,comm from emp where comm is null;

	
--15. comm이 null이 아닌(not) 사원에 대한 검색(ename, comm)
	- select ename,comm from emp where comm is not null;


--16. ename, 전체연봉... comm 포함 연봉 검색
	- select enamem,sal*12+nvl(comm,0) as 전체연봉 from emp;


--17. emp table에서 deptno 값이 20인(조건식 where) 직원 정보 모두(*) 출력하기  : = [sql 동등비교 연산자]
	- select * from emp where deptno=20;

--? 검색된 데이터의 sal 값이 내림차순으로 정렬 검색 
	- select sal from emp order by sal desc;


--18. emp table에서 ename이 smith(SMITH)에 해당하는 deptno값 검색
	->>sql상에서 문자열 데이터 표기 : '  ' (단일 따옴표)
	- select ename,deptno from emp where ename='SMITH'; (대소문자 구분해서 써야함)

--19. sal가 900이상(>=)인 직원들의 이름(ename), sal 검색
	- select ename,sal from emp where sal>=900;


<<<조건식이 하나 이상>>>

--20. deptno가 10이고(and) job이 메니저인 사원이름 검색
	- select deptno, job from emp where deptno=10 and job='MANAGER';


-- 21. ?deptno가 10이거나(or) job이 메니저(MANAGER)인 사원이름(ename) 검색
	- select deptno, job from emp where deptno=10 or job='MANAGER';

-- 22. deptno가 10이 아닌 모든 사원명(ename) 검색
	>>>부정 연산자 : !=, <>, not
	- select ename,deptno from emp where deptno!=10;


-- Application에서 sql 문장 사용시 권장 형식
		-> SELECT ~~~ FROM ~~~

--23. sal이 2000 이하(sal<=2000)이거나(or) 3000이상인(sal>=3000) 사원명(ename) 검색
	- select sal,ename from emp where sal<=2000 or sal>=3000;



--24. comm이 300 or 500 or 1400인 사원명, comm 검색
	- select comm, ename from emp where comm=300 or comm=500 or comm=1400;
	- select comm, ename from emp where comm in (300,500,1400);
	
	

--25. comm이 300 or 500 or 1400이 아닌(not) 사원명, comm 검색
	- select ename,comm from emp where comm not in (300,500,1400);
	- select ename,comm from emp where not comm in (300,500,1400);


-- 26. 81년도에 입사(hiredate)한 사원 이름(ename) 검색
	(date 타입도 비교 연산이 가능할까? -> between-and 연산자)
select ename,hiredate from emp
where hiredate between '81/01/01' and '81/12/31'; (양 끝단 포함)



-- 27. ename이 M으로 시작되는 모든 사원번호(empno), 이름(ename) 검색  
-- 연산자 like : 한 음절 _ , 음절 개수 무관하게 검색할 경우 %
select empno,ename from emp
where ename like 'M%';


-- 28. ename이 M으로 시작되는 전체 자리수가 두음절의 사원번호, 이름 검색
select empno, ename from emp
where ename like 'M_'; (_ : 음절)

-- 29. 두번째 음절의 단어가 M인 모든 사원명 검색 
select empno, ename from emp
where ename like '_M%';


-- 30. 단어가 M을 포함한 모든 사원명 검색 
select empno, ename from emp
where ename like '%M%';

 
<<<Some of The Most Important SQL Commands>>>

SELECT - extracts data from a database
UPDATE - updates data in a database
DELETE - deletes data from a database
INSERT INTO - inserts new data into a database
CREATE DATABASE - creates a new database
ALTER DATABASE - modifies a database
CREATE TABLE - creates a new table
ALTER TABLE - modifies a table
DROP TABLE - deletes a table
CREATE INDEX - creates an index (search key)
DROP INDEX - deletes an index