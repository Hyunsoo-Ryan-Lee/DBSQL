--11.rownum.sql

-- *** rownum
-- oracle 자체적으로 제공하는 컬럼
-- table 당 무조건 자동 생성
-- 검색시 검색된 데이터 순서대로 rownum값 자동 반영(1부터 시작)

-- *** 인라인 뷰
	-- 검색시 빈번히 활용되는 스펙
	-- 다수의 글들이 있는 게시판에 필수로 사용(paging 처리)
	-- 서브쿼리의 일종으로 from절에 위치하여 테이블처럼 사용
	-- 원리 : sql문 내부에 view를 정의하고 이를 테이블처럼 사용 

select rownum, empno from emp;
select rownum, deptno from dept;



-- 1. ? dept의 deptno를 내림차순(desc)으로 검색, rownum

select rownum, deptno from dept order by deptno desc;
select rownum, deptno from dept order by deptno asc;



-- 2. ? deptno의 값이 오름차순으로 정렬해서 30번 까지만 검색, rownum 포함해서 검색

select rownum, deptno from dept where deptno <= 30 order by deptno asc;


-- 3. ? deptno의 값이 오름차순으로 정렬해서 상위 3개의 데이터만 검색, rownum 포함해서 검색

select rownum, deptno from dept where rownum < 4; -- 실행 잘 됨
select rownum, deptno from dept where rownum > 4; -- no rows selected 나옴. 왜???
select rownum, deptno from dept where rownum = 4; -- no rows selected 나옴. 왜???

-- //  ---------------------
/*
inline view 방식
	from절에 select문장으로 검색된 데이터가 반영되는 구조를 inline
	임시로 생성된 table로 간주 즉 물리적으로 존재하지는 않는 table로 간주
	논리적인 table 즉 view

select 검색 컬럼
from 존재하는table 또는 검색된 데이터(임시table)
*/
select rownum, deptno from dept;
select rownum, deptno from emp;

select rownum, deptno 
from (select rownum, deptno 
	 from dept 
	 where rownum < 4);



select rownum, deptno 
from (select rownum, deptno 
	 from dept 
	 where rownum < 4);



-- 4.  인라인 뷰를 사용하여 급여를 많이 받는 순서대로 3명만 이름과 급여 검색 

select ename, sal from emp order by sal desc;
select rownum, ename, sal from emp order by sal desc;
select rownum, ename, sal from emp;
-- from >> select >> order by
-- 암기사항 : rownum은 검색시에 검색된 결과에 자동 index를 부여
	-- 1부터 활용해야 함
	-- 4보다 크다의 경우엔 1이 아닌 4부터를 시작점으로 보기 때문에 문법 오류는 아니지만 무효화됨!

select ename, sal 
from (select rownum, ename, sal
	from emp order by sal desc);


select rownum, ename, sal 
from (select rownum, ename, sal
	from emp order by sal desc);


--5. emp의 deptno 값이 오름차순으로 정렬된 상태로 상위 3개 data 검색

select deptno from emp;
select rownum, deptno from emp order by deptno asc;

select rownum, deptno
from (select deptno from emp order by deptno asc) where rownum < 7;

select rownum, deptno
from (select deptno from emp order by deptno asc) where rownum > 4;
-- no rows selected

