--15.PLSqlProcedure.sql
/*
함수 개발의 필요성
	- login과 같은 무수히 많은 user가 똑같은 logic 요청
	- 함수가 계속 재사용됨 BUT, client별 인증 data는 명확히 구분
	- 잘 만들어서 무수히 재사용을 하겠다는 의미!

	class Customer:
		- Customer class 밖에 객체 생성 : 함수 호출 여부와 무관하게 관리됨
		- Customer class 안에 객체 생성 : 함수 호출시 실행, 종료시 없어짐.


1. 저장 프로시저
	- 이름을 부여해서 필요한 시점에 재사용 가능한 plsql
	- DB에 사용자 정의 기능을 등록 -> 필요한 시점에 사용

2. 문법
	2-1. 생성만
		- 이미 동일한 이름의 procedure가 존재할 경우 error 발생 
		create procedure  이름
		is
		begin
		end;
		/

	2-2. 생성 및 치환
    		- 미 존재할 경우 생성, 존재할 경우 치화
		create or replace procedure
		is
		begin
		end;
		/

3. 에러 발생시
show error
*/


--1. procedure 정보 확인 sql문장
desc user_source;
select * from user_source;


--2. 실습을 위한 test table
drop table dept01;
create table dept01 as select * from dept;
drop table emp01;
create table emp01 as select * from emp;


--3. emp01의 부서 번호가 20인 모든 사원의 job을 
-- STUDENT로 변경하는 프로시저 생성

create or REPLACE PROCEDURE update_job 
is 
begin 
	update emp01 set job='STUDENT' where deptno=30;
end;
/

select * from emp01;
select * from user_source;
-- db에 등록은 되어 있으나 호출은 아직 안 한 상태

-- 프로시저 실행하는 명령어
execute update_job;
select * from emp01;

rollback; -- 프로시져는 롤백이 가능
select * from emp01;



--5. 가변적인 사번(동적)으로 실행시마다 해당 사원의 급여에 +500 하는 프로시저 생성하기
-- sql문장 상의 컬럼에 plsql 변수값 대입할 경우엔 
-- 기본 대입 연산자 활용(=)
-- plsql 변수에 값 할당시에는 할당 연산자 활용(:=)
create or REPLACE PROCEDURE update_sal(ans emp.empno%type)
is 
begin 
	update emp01 set sal=sal+500 where empno=ans;
end;
/

select empno, sal from emp01 where empno=7369;
execute update_sal(7369);
select empno, sal from emp01 where empno=7369;


--5.? 사번(empno)과, 급여(sal)를 입력받아서 해당 직원의 희망급여를 변경하는 프로시저 
-- 프로시저명 : update_sal

create or replace procedure update_sal
(v_empno emp01.empno%type, v_sal emp01.sal%type)
is
begin
	update emp01 set sal=v_sal where empno=v_empno; 
end;
/

select empno, sal from emp01 where empno=7369;

execute update_sal(7369, 2000);
select empno, sal from emp01 where empno=7369;



--6. 이름과 사번, 급여 검색하기
	-- inout 모드(용도를 키워드로 표현)
	-- IN : procedure 내부에서 사용되기만 하는 변수 의미
	-- OUT : procedure 수행 후에 호출한 곳으로 값을 제공해주는 변수
	-- 일반 함수는 return 키워드를 통해 명확하게 값을 호출!

-- python에서 =  대입 / ==  동등비교
-- oracle에서 :=  대입 / =  동등비교
create or replace procedure info_empinfo
(
	v_ename IN emp01.ename%type,
	v_empno OUT emp01.empno%type,
	v_sal OUT emp01.sal%type
)
is
begin
	select empno, sal
		into v_empno, v_sal
	from emp
	where ename=v_ename;
end;
/ 
-- sqlplus 창에서 변수 선언
-- plsql procedure test를 위한 단순 변수 선언
variable vempno number;
variable vsal number;

-- 'SMITH'는 IN모드 변수에 값 대입
-- :vempno >> 이 변수에 값을 받아서 할당 받겠다는 의미 따라서 콜론(:) 필수!
execute info_empinfo('SMITH', :vempno, :vsal);

-- 변수값 출력
print vempno;
print vsal;




-- 프로시저에 예외 발생시 예외 처리 문법
--7. dept table은 pk(deptno) 설정되어 있음, dept에 새로운 데이터 저장 함수

create or replace procedure insert_dept3(
	v_deptno dept.deptno%type,
	v_dname dept.dname%type,
	v_loc dept.loc%type)
is
begin
	-- insert 시에 중복 예외 발생하면 exception 블록 실행, 정상 insert면 무시됨
	insert into dept values(v_deptno, v_dname, v_loc);
	exception
		when then -- 중복 예외가 발생할 경우 exception 실행
			insert into dept values(v_deptno+1, v_dname, v_loc);
end;
/
exec insert_dept3(77, 'a', 'a');
exec insert_dept3(77, 'a', 'a');

--8. procedure 또는 function에 문제 발생시 show error로 메세지 출력하기
show error









