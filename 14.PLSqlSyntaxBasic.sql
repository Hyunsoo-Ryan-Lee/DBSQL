--14.PLSqlSyntaxBasic.sql
/* 
* 프로시저 & 함수
- 재사용을 위한 기능 구현
1. 프로시저
	- 호출 방법이 함수와 차이가 있음
2. 함수
	- oracle 함수 호출하듯 사용자 정의 함수 호출 가능

------
1. oracle db만의 프로그래밍 개발 방법
	1. 이름 없이 단순 개발
	2. 프로스저라는 타이틀로 개발 - 이름 부여(재사용)
	3. 함수라는 타이틀로 개발 - 이름 부여(재사용)

2. 장점
	- 단 한번의 실행 만으로 내장 함수처럼 만들어서 필요시 호출해서 실행 가능
	- 프로시저와 함수로 구현시 db내부에 pcode로 변환

3. test를 위한 필수 셋팅 
	- set serveroutput on 
	
4. 필수 암기 
	1. 할당(대입) 연산자  :=
	2. 선언, 시작, 끝
		declare 
			변수 선언
		begin 
			로직 처리
		end;
		/ >> 슬래쉬 꼭 붙임!!
*/

--1. 실행 결과 확인을 위한 필수 설정 명령어
set serveroutput on
--위의 명령어 생략시 dbms_output.put_line('이름 : ' || name); 해당 구문 실행 안됨.
set serveroutput off

--2. 연산을 통한 간단한 문법 습득
declare
	no integer; 						-- 변수 선언, 정수 의미
begin									-- 로직 구현
	no := 10;			-- 10값을 no변수에 할당(대입, 초기화)
	dbms_output.put_line('결과 : ' || no);	-- 출력 함수(|| = 결합 연산자)

	no := 10 / 5;		-- 10/5 결과물을 no 변수에 할당
	dbms_output.put_line('결과 : ' || no);  -- 출력 함수
end;
/

--변수를 직접 선언 후 대입해도 됨
declare
	no integer := 10; 					
begin		
	dbms_output.put_line('결과 : ' || no);	
	dbms_output.put_line(concat('결과 : ',no/2));	
	dbms_output.put_line('결과 : ' || no/5); 
end;
/


--* 이름값을 출력할 수 있는 procedure 구현
	-- name 변수 선언해서 활용(varchar2)

declare 
	name varchar(10);
begin 
	name := '이현수';
	dbms_output.put_line('이름 : ' || name);
end;
/





--3. 연산을 통한 간단한 문법 습득 + 예외 처리 문장
-- 혹여 문제가 생겨도 프로그램 종료가 아니라 유연하게 실행 유지

-- 예외처리시 실행 유지
-- 예외 미처리시 실행 강제 종료

-- 1단계 >> 문제가 발생했을 때 중지를 확인하는 단순 test code
declare
	no integer := 10; 					
begin		
	dbms_output.put_line('결과 : ' || no);	
	dbms_output.put_line('결과 : ' || no/5); 
end;
/

-- 2단계 >> 프로그램 중지를 방지하기 위한 해결책 : exception
declare
	no integer := 10; 					
begin		
	dbms_output.put_line('결과 : ' || no);	
	dbms_output.put_line('결과 : ' || no/0); 

	exception				-- 오류 발생시 예외처리 후 진행
		when others then 
			dbms_output.put_line('예외 발생!!');
			
	dbms_output.put_line('결과 : ' || no*12);		
end;
/


--4. 중첩 block & 변수 선언 위치에 따른 구분
-- step01 - 전역(global), 로컬(local) 변수 선언 및 활용

declare 
------------1------------- 전역 변수는 1,2에서 모두 사용 가능
BEGIN
	declare 
	----------2---------- 로컬 변수는 2에서만 사용 가능
	BEGIN

	end;

end;
/


declare 
	v_global varchar(10) := 'GLOBAL';
BEGIN
	dbms_output.put_line(v_global);
	declare 
		v_local varchar(10) := 'LOCAL';
	BEGIN
		dbms_output.put_line(v_local);
		dbms_output.put_line('내부에서 실행>>'||v_global);
	end;
	--dbms_output.put_line(v_local); >> 로컬 변수가 내부에서 벗어나면 에러가 남!!
	dbms_output.put_line(v_global);
end;
/

DECLARE
	abc varchar(10) := '글로발';
begin 
	dbms_output.put_line(abc);
	DECLARE
		bcd varchar(10) := '로컬';
	begin 
	dbms_output.put_line(bcd);
	dbms_output.put_line(abc);
end;
dbms_output.put_line(abc);
end;
/




--5. emp01 table의 컬럼 타입을 그대로 사용하고 싶다면?
	-- %type : db의 특정 컬럼의 타입 의미
drop table emp01;
create table emp01 as select * from emp;

-- 사번으로 이름 검색해서 출력하는 PROCEDURE 개발
-- select ename from emp where empno=7369;
declare 
	v_empno emp01.empno%type;
	v_ename emp01.ename%type;
BEGIN
	select ename, empno
		into v_ename, v_empno
	from emp01 
	where empno = 7369;

	dbms_output.put_line(v_ename ||'  '||v_empno);
end;
/

declare 
	v_empno emp01.empno%type;
	v_ename emp01.ename%type;
begin 
select empno, ename into v_empno, v_ename
from emp01 where empno=7369;
dbms_output.put_line(concat(v_ename,v_empno));
end;
/


--6. 이미 존재하는 table의 record의 모든 컬럼 타입 활용 키워드 : %rowtype
/* 7369 사번으로 해당 사원의 모든 정보를 검색해서 사번, 이름만 착출해서 출력 */
DECLARE




DECLARE
	v_rows emp01%rowtype;
BEGIN
	SELECT * into v_rows
	FROM emp where empno = 7369;
	dbms_output.put_line(v_rows.sal ||'  '|| v_rows.ename);

end;
/


--7. ???
-- emp05라는 table을 데이터 없이 emp table로 부터 생성하기
-- %rowtype을 사용하셔서 emp의 사번이 7369인 사원 정보 검색해서 
-- emp05 table에 insert
-- 힌트 : begin 부분엔 다수의 sql문장 작성 가능, into 절

drop table emp05;
create table emp05 as select * from emp where 1=0;

DECLARE
	v_row emp05%rowtype; -- emp05의 모든 row type들을 선택
BEGIN
	SELECT * 
		into v_row
	FROM emp where empno = 7369;
	insert into emp05 values v_row;
end;
/

select * from emp05;


--8. 조건식
/*  1. 단일 조건식
	if(조건) then
		
	end if;
	
   2. 다중 조건
	if(조건1) then
		조건1이 true인 경우 실행되는 블록 
	elsif(조건2) then
		조건2가 true인 경우 실행되는 블록
	end if; 
*/
-- 사원의 연봉을 계산해서 합을 구하는 procedure 개발[comm이 null인 
-- 직원들은 0으로 치환]


select empno, ename, sal, comm 
	from emp 
	where ename='SMITH';

select empno, ename, sal, comm, sal+nvl(comm,0) as total
	from emp 
	where ename='SMITH';	


DECLARE
	v_emp emp%rowtype;
	total_sal number(7,2);
BEGIN
	SELECT empno, ename, sal, comm
		into v_emp.empno, v_emp.ename, v_emp.sal, v_emp.comm
	from emp where ename='SMITH';

	if (v_emp.comm is null) then --True 일 때 실행
		v_emp.comm := 0;
	end if;

	total_sal := v_emp.sal*12 + v_emp.comm;
	dbms_output.put_line(total_sal);
end;
/

-- 존재하는 TABLE의 특정 컬럼 타입 하나 : %type
-- 존재하는 table의 모든 컬럼 타입 : %rowtype

-- 9.??? 실행시 가변적인 데이터 적용해 보기
-- 실행시마다 가변적인 데이터(동적 데이터) 반영하는 문법 : 변수 선언시 "&변수명"
-- 동적 변수 선언시 "&변수명"

-- emp table의 deptno=10 : ACCOUNT 출력, 
-- deptno=20 이라면 RESEARCH 출력
-- test data는 emp table의 각 사원의 사번(empno)

declare
	ck_empno emp.empno%type := &v; 
							-- 실행시마다 새로운 data를 입력받는 동작변수 할당 문법
	v_empno emp.empno%type;
	v_deptno emp.deptno%type;
	v_dname varchar2(10);
begin
	select empno, deptno
		into v_empno, v_deptno
	from emp
	where empno=ck_empno; -- 입력받은 값이랑 empno와 비교

	if (v_deptno=10) then	
		dbms_output.put_line('ACCOUNT');
	elsif (v_deptno=20) then	
		dbms_output.put_line('RESEARCH');
	else
		dbms_output.put_line('None');
	end if;
end;
/



--10. 반복문
/* 
1. 기본
	loop 
		ps/sql 문장들 + 조건에 사용될 업데이트
		exit 조건;
	end loop;

2. while 기본문법
	 while 조건식 loop
		plsql 문장;
	 end loop;

3. for 기본 문법
	for 변수 in [reverse] start ..end loop
		plsql문장
	end loop;
*/
-- loop 
-- 조건에 부합하는 상황에서만 반복
-- 조건식은 어떤 영역(위치)에 반영해서 반복 중지
declare  
	num number(2) := 0;
begin
	loop  -- for문과 비슷
		dbms_output.put_line(num);
		num := num+1;
		exit when num > 5;
	end loop;
end;
/

declare 
	num number(2) := 1;
begin
	loop
		dbms_output.put_line(num);
		num := num+1;
		exit when num = 5;
	end loop;
end;
/

-- while

declare
	num number(2) := 0;
begin
	while num < 5 loop 
	dbms_output.put_line(num);
	num := num + 1;

	end loop;
end;
/


-- for 
-- 오름차순
declare

begin
	for num in 0..9 loop
	dbms_output.put_line(num);
	end loop;
end;
/


-- 내림차순
begin
	for num in reverse 0..9 loop
	dbms_output.put_line(num);
	end loop;
end;
/


--11.? emp table 직원들의 사번을 입*력받아서(동적데이터) 해당하는 
-- 사원의 이름 음절 수 만큼 * 표 찍기 
-- length()





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