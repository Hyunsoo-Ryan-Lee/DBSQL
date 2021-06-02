-- 5.join.sql

/*
1. 조인이란?
	다수의 table간에  공통된 데이터를 기준으로 검색하는 명령어
	다수의 table이란?
		동일한 table을 논리적으로 다수의 table로 간주
			- self join
		물리적으로 다른 table간의 조인

2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관되어 있음

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관되어 있음

  
3. table에 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요, 
	서로 다른 table간의 컬럼명이 중복된 경우,
	컬럼 구분을 위해 오라클 엔진에게 정확한 table 소속명을 알려줘야 함
	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. 동등 조인
		 = 동등비교 연산자 사용
		 : 사용 빈도 가장 높음
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자)

	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계

	4. outer 조인 
		: 두개 이상의 테이블이 조인될때 특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 null값을 보유한 경우
		  검색되지 않는 문제를 해결하기 위해 사용되는 조인
		  null 값이기 때문에 배제된 행을 결과에 포함 할 수 있드며 (+) 기호를 조인 조건에서 정보가 부족한 컬럼쪽에 적용
		
		: oracle DB의 sql인 경우 데이터가 null 쪽 table 에 + 기호 표기 */

-- 1. dept table의 구조 검색
desc dept;
-- dept, emp, salgrade table의 모든 데이터 검색
select * from dept;
select * from emp;
select * from salgrade;


 



--*** 1. 동등 조인 ***
-- = 동등 비교
-- 2. SMITH 의 이름(ename), 사번(empno), 근무지역(부서위치)(loc) 정보를 검색
select ename, empno, loc
from emp, dept
where ename = 'SMITH';


-- deptno 는 두개의 table에 다 존재하기 때문에 어떤 table의 값인지 불명확해서 에러~!
-- ORA-00918: column ambiguously defined
select ename, empno, loc, deptno
from emp, dept
where ename = 'SMITH';

-- 출력은 되지만 복잡한 명령
select ename, empno, loc, emp.deptno, dept.deptno
from emp, dept
where ename = 'SMITH';
/*
ENAME                     EMPNO LOC                            DEPTNO     DEPTNO
-------------------- ---------- -------------------------- ---------- ----------
SMITH                      7369 NEW YORK                           20         10
SMITH                      7369 DALLAS                             20         20
SMITH                      7369 CHICAGO                            20         30
SMITH                      7369 BOSTON                             20         40
*/

-- 올바른 명령
select ename, empno, loc
from emp, dept
where ename = 'SMITH' and emp.deptno = dept.deptno;
/*
ENAME                     EMPNO LOC
-------------------- ---------- --------------------------
SMITH                      7369 DALLAS
*/


-- 3. deptno가 동일한 모든 데이터(*) 검색
-- emp & dept 
select * from emp,dept where emp.deptno = dept.deptno;


-- 4. 2+3 번 항목 결합해서 SMITH에 대한 모든 정보(ename, empno, sal, comm, deptno, loc) 검색하기

select ename, empno, loc
from emp, dept
where ename = 'SMITH' and emp.deptno = dept.deptno;



-- 5.  SMITH에 대한 이름(ename)과 부서번호(deptno), 부서명(dept의 dname) 검색하기
select ename, e.deptno, dname
from emp e, dept
where ename = 'SMITH' and e.deptno = dept.deptno;

-- 6. 조인을 사용해서 뉴욕에 근무하는 사원의 이름과 급여를 검색 
-- loc='NEW YORK', ename, sal
select loc from dept;

select loc, ename, sal
from emp e, dept d 
where loc = 'NEW YORK' and e.deptno = d.deptno;


-- 7. 조인 사용해서 ACCOUNTING 부서(dname)에 소속된 사원의 이름과 입사일 검색
select dname from dept;

select dname, ename, hiredate
from emp e, dept d
where dname = 'ACCOUNTING' and e.deptno = d.deptno
order by hiredate asc;
/*
DNAME                        ENAME                HIREDATE
---------------------------- -------------------- --------
ACCOUNTING                   CLARK                81/06/09
ACCOUNTING                   KING                 81/11/17
ACCOUNTING                   MILLER               82/01/23
*/


-- 8. 직급이 MANAGER인 사원의 이름, 부서명 검색
select job from emp;

select job, ename, dname
from emp e, dept d
where job = 'MANAGER' and e.deptno = d.deptno;
/*
JOB                ENAME                DNAME
------------------ -------------------- ----------------------------
MANAGER            JONES                RESEARCH
MANAGER            BLAKE                SALES
MANAGER            CLARK                ACCOUNTING
*/

-- 9. 사원(emp) 테이블의 부서 번호(deptno)로 부서 테이블을 참조하여 사원명, 부서번호, 부서의 이름(dname) 검색
select ename, emp.deptno, dname
from emp, dept
where emp.deptno = dept.deptno;


-- *** 2. not-equi 조인 ***

-- salgrade table(급여 등급 관련 table)
-- 9. 사원의 급여가 몇 등급인지 검색
-- between ~ and : 포함 
select ename, sal, grade
from emp, salgrade
where sal between losal and hisal;

-- 1. 81년 4월 1일 이후에 입사한 사원들이 가장 많은 부서의 부서명을 구하세요.
-- dname 개수를 카운팅해서 max 최대값
select max(count(hiredate)) as ans, dept.deptno, dname
from emp, dept
where emp.deptno = dept.deptno;

select hiredate, deptno
from emp
where hiredate > '81/04/01';

select hiredate, emp.deptno, dname
from emp, dept
where hiredate > '81/04/01' and emp.deptno = dept.deptno;
 
select min(dname) -- 문자열 max, min의 경우 알파벳 순으로 나온다.
from emp, dept
where hiredate > '81/04/01' and emp.deptno = dept.deptno;

select *
from(
	select dname 
	from emp, dept 
	where hiredate > '81/04/01' and emp.deptno = dept.deptno
	group by dname 
	order by count(ename) desc)
	where ROWNUM=1;



-- *** 3. self 조인 - 하나의 table로 다수의 table인 듯 논리적으로 작업***
-- 11. SMITH 직원(사원)의 manager(상사) 이름 검색
/* 사원 table의 별칭 : e / manager table의 별칭 : m
하나의 테이블을 별칭을 붙여 나눈다.
*/
select m.ename 
from emp e, emp m 
where e.ename = "SMITH" and e.mgr = m.empno;


-- 12. 메니저 이름이 KING(m ename='KING')인 사원들의 이름(e ename)과 직무(e job) 검색
select e.ename, e.job
from emp e, emp m
where m.ename='KING' and e.mgr = m.empno;




-- 13. SMITH와 동일한 근무지(deptno)에서 근무하는 사원의 이름 검색
select e.ename, e.deptno
from emp e, emp m
where m.ename = 'SMITH'
	and e.deptno = m.deptno 
	and not e.ename = 'SMITH';




--*** 4. outer join ***

/*
join은 ANSI join 즉, RDBMSㅇ 종속적이지 않은 표준 sql 문장 학습 필수!
*/ 

-- 14. 모든 사원명, 메니저 명 검색, 단 메니저가 없는 사원도 검색되어야 함

select e.ename 사원명, m.ename 매니저명
from emp e, emp m
where e.mgr = m.empno;

select e.ename 사원명, m.ename 매니저명
from emp e, emp m
where e.mgr = m.empno(+); --> null 값을 보유하고 있는 data들도 join에서 검색해서 적용
	
	
select e.ename 사원명, m.ename 매니저명, e.mgr, e.empno
from emp e, emp m
where e.mgr = m.empno;


-- 15. 모든 직원명(ename), 부서번호(deptno), 부서명(dname) 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join이용해서 40번 부서의 부서 이름도 검색하기 

select ename, dept.deptno, dname 
from emp, dept
where emp.deptno(+) = dept.deptno; -- >> data가 부족한 쪽에 (+)를 붙여줌.





-- *** hr/hr 계정에서 test 
--16. 직원의 이름과 직책(job_title)을 출력(검색)
--	단, 사용되지 않는 직책이 있다면 그 직책이 정보도 검색에 포함
--     검색 정보 이름(first_name)들과 job_title(직책) 

	-- 문제 풀이를 위한 table의 컬럼값들 확인해 보기
select first_name, job_title
from employees e, jobs j 
where e.job_id(+) = j.job_id;




desc employees;	
desc jobs;

select count(*) from employees;
select count(*) from jobs;
select job_id from emplpoyees;
select distinct job_id from employees;
select job_id from jobs;


--17. 직원들의 이름(employees-first_name), 입사일(employees-hire_date), 부서명(DEPARTMENTS-department_name) 검색하기
select first_name,hire_date,department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

select first_name,hire_date,department_name
from employees e, departments d
where e.manager_id = d.manager_id(+);


-- 단, 부서가 없는 직원이 있다면 그 직원 정보도 검색에 포함시키기
--경우1. 사원이 소속된 부서가 없을 경우
--경우2. 부서에 소속된 사원에 없을 경우

select nvl(first_name,'None') as name,hire_date,department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

/*
- null 값을 다른 값으로 치환하는 함수 : nvl(null보유컬럼, 변경할 값)
	-> select sal,comm, nvl(comm,0) from emp; (null값을 0으로 치환)
	-> select sal,comm, sal*12+nvl(comm,0) as 연봉 from emp;
*/






-- EMPLOYEES table과 JOB_HISTORY table을 이용
-- hire_date = start_date인 데이터들 중 JOB이 (job_id)IT_PROG인 사람들만 출력

select e.first_name,e.hire_date,j.job_id
from employees e, job_history j
where j.job_id = 'IT_PROG' and e.hire_date = j.start_date;

select e.employee_id
from employees e, job_history j
where e.hire_date = j.start_date and j.job_id = 'IT_PROG';

select region_name,count(region_name)
from countries c, regions r
where c.region_id = r.region_id
group by region_name;


-- 두 table의 REGION_ID를 join한 후 각 REGION_NAME의 개수를 COUNT한 후 4개이상의 
-- REGION_NAME, count 개수를 출력하시오.


SELECT region_name, count(region_name) as 국가수
from regions r, countries c
where r.region_id = c.region_id
group by region_name
having count(region_name) >= 6;


