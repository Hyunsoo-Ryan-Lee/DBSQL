--16.PLSqlFunction.sql
/*
1. 저장 함수(function)
	- 오라클 사용자 정의 함수 
	- 오라클 함수 종류
		- 지원함수(count(??){ }, avg()...) + 사용자 정의 함수
2. 주의사항
	- 절대 기존 함수명들과 중복 불가
3. 프로시저와 다른 문법
	- plsql에서의 함수는 반드시 return값 있음
	- 리턴 타입 선언 + 리턴 값

4. oracle DB 내에 구현하는 사용자 정의 함수 문법

	4-1. 함수 생성만
		create function 함수명( )
		return 리턴 타입명시
		is
			함수 내에서 사용될 변수 선언
		begin
			처리 로직
			return 리턴할 값
		end;
		/

	4-2 함수 생성 또는 치홤(기존 함수 대신 새로 경신)
		create or replace function 함수명( )
		return 함수 실행 결과
		is
			함수 내에서 사용될 변수 선언
		begin
			처리 로직
		end;
		/
*/
-- 별 찍기!

declare -- 재사용성 고려 X
	test emp.empno%type := &no; 
	v_ename emp.ename%type;
	v_number number(3);
	v_star varchar(10);

begin
	select ename, length(ename)
	into v_ename, v_number
	from emp 
	where empno=test;

	for i in 1..v_number loop
		v_star := v_star || '*';
	end loop;
		dbms_output.put_line(v_star);
end;
/

-- 함수로 변경
create or replace function mystar(no number)
return varchar2 -- return type 명시시에는 타입의 사이즈 생략! 경고 나옴.
is
	v_empno emp.empno%type := &no; 
	v_ename emp.ename%type;
	v_number number(3);
	v_star varchar2(10) := '';
begin
	select ename, length(ename)
	into v_ename, v_number
	from emp 
	where empno=v_empno;

	for i in 1..v_number loop
		v_star := v_star || '*';
	end loop;

	return v_star;
end;
/
select mystar(7369) from dual;


create or replace function mystar(no number)
return varchar2     -- 리턴 타입 명시할 경우 타입의 사이즈 생략!!
is 
	v_empno emp.empno%type := no;
	v_ename emp.ename%type;
	v_number number(3);
	v_star varchar2(10) := '';
begin
	select ename, length(ename)
	into v_ename, v_number
	from emp
	where empno=v_empno;

	for i in 1..v_number loop
		v_star := v_star || '*';
	end loop;
	
	return v_star;
end;
/

select mystar(7369) from dual;

--2차 개선
create or replace function mystar(v_empno emp.empno%type)
return emp.ename%type  
is 
	v_ename emp.ename%type;
	v_number number(3);
	v_star varchar(10) := '';
begin
	select ename, length(ename)
	into v_ename, v_number
	from emp
	where empno=v_empno;

	for i in 1..v_number loop
		v_star := v_star || '*';
	end loop;
	
	return v_star;
end;
/

select mystar(7369) from dual;



--1. emp table의 사번으로 사원 이름
-- (리턴 값, 이름의 타입이 리턴타입) 검색 로직 함수 
create function user_fun(num number) -- 함수명 : user_fun
return varchar2				 -- 리턴 타입 명시
is
	v_ename emp.ename%type;  --새로운 변수 선언
begin
	select ename	
		into v_ename
	from emp where empno=num;

	return v_ename;			-- 리턴 데이터
end;
/
select user_fun(7369) from dual;


--2.? %type 사용해서 사원명으로 해당 사원의 직무(job) 반환하는 함수 
-- 함수명 : emp_job

create or replace function my_job(v_name emp.ename%type) -- 함수명 : user_fun
return emp.job%type				 -- 리턴 타입 명시
is
	v_job emp.job%type;   --새로운 변수 선언
begin
	select job	
		into v_job
	from emp where ename = v_name;

	return v_job;			-- 리턴 데이터
end;
/
select my_job('FORD') from dual;



select my_job('SMITH') from dual;



--3.? 특별 보너스를 지급하기 위한 저장 함수
	-- 급여를 200% 인상해서 지급(sal*2)
-- 함수명 : cal_bonus
-- test sql문장
create or replace function cal_bonus(v_empno emp.empno%type)
return emp.sal%type
is
	v_sal emp.sal%type;
begin 
	select sal*2 into v_sal from emp where empno=v_empno;
	return v_sal;
end;
/

select empno, job, sal, cal_bonus(7369) from emp where empno=7369;





-- 4.? 부서 번호를 입력 받아 최고 급여액(max(sal))을 반환하는 함수
-- 사용자 정의 함수 구현시 oracle 자체 함수도 호출
-- 함수명 : s_max_sal
create or REPLACE FUNCTION s_max_sal(high emp.deptno%type)
return emp.sal%type
is
	v_sal emp.sal%type;
begin 
	select max(sal) into v_sal from emp where high=deptno;
	return v_sal;
end;
/

select distinct deptno, s_max_sal(deptno) from emp;
select s_max_sal(10) from dual;


--5. ? 부서 번호를 입력 받아 부서별 평균 급여를 구해주는 함수
-- 함수명 : avg_sal
-- 함수 내부에서 avg() 호출 가능
create or REPLACE FUNCTION avg_sal(average emp.deptno%type)
return emp.sal%TYPE
IS
	v_sal emp.sal%type;
begin 
	select avg(sal) into v_sal from emp where average=deptno;
	return v_sal;
end;
/

select distinct deptno, avg_sal(deptno) from emp;
select avg_sal(10) from dual;


--job을 입력받아 해당 job의 평균 급여를 구해주는 함수를 만드세요.
--함수명 : job_avg
create or replace function job_avg(v_job emp.job%type)
return emp.job%type 
is 
	v_sal emp.sal%type;
begin 
	select avg(sal) into v_sal from emp where v_job=job;
	return v_sal;
end;
/
select job_avg('CLERK') from dual;


--6. 존재하는 함수 삭제 명령어
drop function avg_sal;



-- 함수 내용 검색
desc user_source;
select text from user_source where type='FUNCTION';



