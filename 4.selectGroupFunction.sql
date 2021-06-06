--4.selectGroupFunction.sql
-- 그룹함수란? 다수의 행 데이터를 한번에 처리해서 하나의 결과값을 검색되는 함수

-- 장점 : 함수 연산시 null 데이터를 함수 내부적으로 사전에 고려해서 
--        null값 보유한 field는 함수 로직 연산시 제외, sql 문장 작업 용이
/*
1. count() : 개수 확인 함수
2. sum() : 합계 함수
3. avg() : 평균
4. max(), min() : 최대값, 최소값 
*/
 
/* 기본 문법
1. select절
2. from 절
3. where절 

 * 그룹함수시 사용되는 문법
1. select절 : 검색하고자 하는 속성
2. from절	: 검색 table
3. group by 절 : 특정 조건별 그룹화하고자 하는 속성
4. having 절 : 그룹함수 사용시 조건절
5. order by절 : 검색된 데이터를 정렬
*/

--1. count() : 개수 확인 함수
-- emp table의 직원이 몇명?


--? comm 받는 직원 수만 검색
select count(comm) as AAA from emp;

--2. sum() : 합계 함수
-- ? 모든 사원의 월급여(sal)의 합
select sum(sal) from emp;


--? 모든 직원이 받는 comm 합
 select sum(comm) from emp;

--?  MANAGER인 직원들의  월급여의 합 
select sum(sal) from emp where job = 'MANAGER';

-- 문법 오류! 논리적으로도 부적합
-- sum(sal)에 대한 data는 하나의 행, sal에 대한 data는 행이 여러개이기 때문에
-- 아래와 같은 명령으로는 실행시킬 수 없음.
select sal, sum(sal) from emp where job = 'MANAGER';


--? job 종류 counting[절대 중복 불가 = distinct]
-- 데이터 job 확인
select distinct job from emp; 
select count(distinct job) from emp; -- 중복을 제거한 후 count

-- 논리적인 오류 : 집계 이후에 distinct 는 의미 없음 
select distinct count(job) from emp; -- distinct가 적용되지 않음


--3. avg() : 평균
--? emp table의 모든 직원들의 급여(sal) 평균 검색
select avg(sal) from emp;


--? 커미션 받는 사원수, 총 커미션 합, 평균 구하기
select count(comm) from emp;
select sum(comm) from emp;
select avg(comm) from emp;


--4. max(), min() : 최대값, 최소값
-- 숫자, date 타입에 사용 가능

--최대 급여, 최소 급여 검색 -> 결과 data의 row 수가 동일해서 한 표에 출력 가능
select max(sal), min(sal) from emp;

--?최근 입사한 사원의 입사일과, 가장 오래된 사원의 입사일 검색
-- 오라클의 date 즉 날짜를 의미하는 타입도 연산 가능
-- max(), min() 함수 사용해 보기
select max(hiredate),min(hiredate) from emp; -- 가장 오래된 직원이 검색됨


--*** 
/* group by절
- 특정 컬럼값을 기준으로 그룹화
	가령, 10번 부서끼리, 20번 부서끼리..

SELECT 컬럼 FROM 테이블 GROUP BY 그룹화할 컬럼;

*/
-- group by 절 없이 select 절에선 그룹함수와 함께 출력 불가

-- 부서별 커미션 받는 사원수 
select deptno, count(comm)
from emp group by deptno;


--? 부서별(group by deptno) (월급여) 평균 구함(avg())(그룹함수 사용시 부서 번호별로 그룹화 작업후 평균 연산)
select deptno, round(avg(sal))
from emp group by deptno
order by deptno asc;


--? 소속 부서별 급여 총액과 평균 급여 검색[deptno 오름차순 정렬]
select deptno, round(sum(sal)) as total, round(avg(sal)) as average
from emp group by deptno;
/*
    DEPTNO      TOTAL    AVERAGE
---------- ---------- ----------
        30       9400       1567
        20       6775       2258
        10       8750       2917
*/


--? 소속 부서별 최대 급여와 최소 급여 검색[deptno 오름차순 정렬]
-- 컬럼명 별칭에 여백 포함한 문구를 사용하기 위해서는 쌍따옴표로만 처리
select deptno, max(sal) as "최대 급여", min(sal) as "최소 급여"
from emp group by deptno;
/*
    DEPTNO   MAX(SAL)   MIN(SAL)
---------- ---------- ----------
        30       2850        950
        20       3000        800
        10       5000       1300
*/


-- *** having절 *** [ 조건을 주고 검색하기 ]
-- 그룹함수 사용시 조건문
-- SELECT 컬럼 FROM 테이블 GROUP BY 그룹화할 컬럼 HAVING 조건식;


--1. ? 부서별(group by) 사원의 수(count(*))와 커미션(count(comm)) 받는 사원의 수
select deptno,count(*),count(comm)
from emp
group by deptno;

-- 조건 추가
--2. ? 부서별 그룹을 지은후(group by deptno), 
-- 부서별(deptno) 평균 급여(avg())가 2000 이상(>=)부서의 번호와 평균 급여 검색 






select deptno,count(*),count(comm),avg(sal)
from emp
group by deptno
having avg(sal) >= 2000;
/*
    DEPTNO   COUNT(*) COUNT(COMM)   AVG(SAL)
---------- ---------- ----------- ----------
        20          3           0 2258.33333
        10          3           0 2916.66667

실행순서 : from -> group by -> having -> select
*/
select deptno,count(*),count(comm),avg(sal) as 평균
from emp
group by deptno
having 평균 >= 2000;  -- 오류!!


--3. 부서별 급여중 최대값(max)과 최소값(min)을 구하되 최대 급여가 2900이상(having)인 부서만 출력
select deptno, max(sal), min(sal)
from emp
group by deptno
having max(sal) >= 2900;
/*
    DEPTNO   MAX(SAL)   MIN(SAL)
---------- ---------- ----------
        20       3000        800
        10       5000       1300
*/


-- WHERE는 그룹화 하기 전이고, HAVING은 그룹화 후에 조건입니다.