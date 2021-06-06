-- 9.integrity.sql
-- DB 자체적으로 강제적인 제약 사항 설정
-- 개발자 능력 + 시스템(HW/SW) 다 유기적으로 연계가 되어 안정적인 data 관리 및 보존 보장
-- 설정은 개발자의 책임

/*
1. table 생성시 제약조건을 설정하는 기법 

2. 제약 조건 종류
	emp와 dept의 관계
		- 주종관계 / 부모자식관계
		- emp의 deptno는 반드시 dept의 deptno 컬럼값에 종속적으로 사용된느 컬럼
			dept에서 제공하지 않는 데이터는 emp에서는 사용 불가
		- dept는 데이터 제공해주는 table / emp는 dept를 사용하는 table
		- dept는 주(부모), emp는 종(자식
		)
	
	2-1. PK[primary key] - 기본키, 중복불가, null불가, 데이터들 구분을 위한 핵심 데이터
		: not null + unique
	2-2. not null - 반드시 데이터 존재
	2-3. unique - 중복 불가 
	2-4. check - table 생성시 규정한 범위의 데이터만 저장 가능 
	2-5. default - insert시에 특별한 데이터 미저장시에도 자동 저장되는 기본 값
					- 자바 관점에는 멤버 변수 선언 후 객체 생성 직후 멤버 변수 기본값으로 초기화
	* 2-6. FK[foreign key] 
		- 외래키[참조키], 다른 table의 pk를 참조하는 데이터 
		- table간의 주종 관계가 형성
		- pk 보유 table이 부모, 참조하는 table이 자식
		- 부모의 미 존재하는 데이터를 자식에서 새로 생성가능? 불가 
		- 자식 table들이 존재할 경우 부모table만 삭제 가능? 불가
			- 해결책 : 관계를 해제도 가능하나 가급적 분석설계시 완벽하리만큼 고민후 설계
	

3. 사용자 정의하는 제약 조건에 제약 조건명 명시하는 방법
	3-1. oracle engine이 기본적으로 설정
		- 사용자가 제약 조건에 별도의 이름을 부여하지 않으면 오라클 자체적으로 SYS_시작하는 이름을 자동 부여
		- SYS_Xxxx

	3-2. sql개발자가 직접 설정
		- table명_컬럼명_제약조건명등 기술..단 순서는 임의 변경 가능
			: dept의 deptno이 제약조건명
				PK_DEPT
				pk_dept_deptno
		- 약어 사용도 가능[분석, 설계시 용어사전 제시후 작성 권장]
	
4. 제약조건 선언 위치
	4-1. 컬럼 레벨 단위
		- 컬럼선언 라인에 제약조건 설정 

	4-2. 테이블 레벨 단위 
		- 모든 컬럼 선언 직후 별도로 제약조건 설정 
	
5. 오라클 자체 특별한 table
	5-1. user_constraints
		- 딕셔너리 table
		- 제약조건 정보 보유 table
		- 개발자가 table의 데이터값 직접 수정 불가
		- select constraint_name, constraint_type, table_name 
			from user_constraints;
/*
CONSTRAINT_NAME          CO TABLE_NAME
------------------------ -- ------------------------------------------------------------
PK_DEPT                  P  DEPT
PK_EMP                   P  EMP
FK_DEPTNO                R  EMP

	dept의 제약조건 : deptno는 절대 중복 불가
	emp의 제약조건 : deptno의 값은 반드시 dept table로부터 참조해서 사용
	empno는 절대 중복 불가

1. CONSTRAINT_NAME : db  설계해서 sql문장 구성시 실제 dw에 부여하는 사용자 정의 제약조건 명
	PK - primary key(기본키, 주키), 절대 중복 불가인 세팅
	FK - foreign key(외래키, 참조키), 다른 table의 고유한 값을 보유한 컬럼을 참조

2. CO : CONSTRAINT의 약어
	- P : Primary Key
	- R : Reference Key


6. 이미 존재하는 table의 제약조건 수정(추가, 삭제)명령어
	6-1. 제약조건 추가
		alter table 테이블명 add constraint 제약조건명 제약조건(컬럼명);
		alter table dept01 add constraint dept01_deptno_pk primary key(deptno);
		
	6-2. 제약조건 삭제(drop)
		- table삭제 
		alter table 테이블명 cascade constraint;
		
		alter table 테이블명 drop 제약조건명;
		alter table dept01 drop primary key;
		
	6-3. 제약조건 임시 비활성화
		alter table emp01 disable constraint emp01_deptno_fk;

	6-4. 제약조건 활성화
		alter table emp01 enable constraint emp01_deptno_fk;

* tip
== 데이터베이스 모델링 -> 구축
	-- 데이터베이스 모델링 tool 종류가 다양
		ERD라는 도식화된 그림으로 모델링 작업 수행
		ERD 즉 그림으로 sql문장 자동 생성, 편집
			- 필수 사전 지식 
				DDL(create/drop/alter) ***

		tool들의 특징
			- create 후에 alter 명령들로 제약조건 추가 하는게 보편적 


1. 문자열 data를 표현하는 단일 따옴표로 number 타임의 컬럼에도 값 저장 가능
	number(2) - 정수 두 자까지만 허용되는 숫자 타입
	number(3,1) - 정수 두 자리, 소수점 이하 1자리 타입

2. 값 저장 시도
	insert into dept values(50, 'aaa','bbb'); - 허용
	insert into dept values('50', 'aaa','bbb'); - 중복 에러, 문자열 format이라도 number로 변환됨 
	insert into dept values(50.2, 'aaa','bbb'); - 중복 에러
	insert into dept values(50.7, 'aaa','bbb'); - 허용 (자동 반올림되어 51로 저장)
	- 문자열 format으로 저장 시도시 오라클 엔진이 숫자 number 포맷으로 자동 변환
*/

-- 1.  딕셔너리 table 검색
select * from user_constraints;
desc user_constraints;



--2. 사용자 정의 제약 조건명 명시하기
drop table emp02;
-- constraint emp02_empno_nn not null
-- constraint : 제약조건 설정함을 의미하는 oracle 키워드
-- emp02_empno_nn : 사용자가 설정한 이름
-- not null : null 불허의 제약조건 의미

create  table emp02(
	empno number(4) constraint emp02_empno_nn not null,
	ename varchar2(10)
);

-- 생성시 emp02라는 소문자로 생성
-- 관리를 위한 사전table에는 EMP02라는 대문자로 저장
select constraint_name, constraint_type, table_name
from user_constraints where table_name='EMP02';




--3. 사용자 정의 제약조건명 설정 후 위배시 출력되는 메세지에 사용자정의 제약조건명
	-- 확인 가능 : not null을 제외한 제약조건명은 에러 발생시 가시적인 확인 가능
drop table emp02;

create table emp02(
	empno number(4)  unique,
	ename varchar2(10)
);

insert into emp02 values(1, 'tester');

insert into emp02 (empno) values(1); -- NULL 값이 있어 에러 나옴



--4-1. 제약조건명을 오라클 엔진이 자동적으로 지정
	-- 에러 발생시 SYS_xxxx로 출력됨 
drop table emp02;
create table emp02(
	empno number(4)  unique,
	ename varchar2(10)
);

select constraint_name, constraint_type, table_name
from user_constraints where table_name='EMP02';


insert into emp02 values(1, 'tester');

insert into emp02 values(1, 'master'); -- empno 중복 에러
-- ORA-00001: unique constraint (SCOTT.SYS_C007026) violated

select * from emp02;


--4-2. 사용자가 설정하는 제약조건명 확인
drop table emp02;
create table emp02(
	empno number(4) constraint u_emp02_empno unique,
	ename varchar2(10)
);

select constraint_name, constraint_type, table_name
from user_constraints where table_name='EMP02';


insert into emp02 values(1, 'tester');

insert into emp02 values(1, 'master'); -- empno 중복 에러
-- ORA-00001: unique constraint (SCOTT.U_EMP02_EMPNO) violated

select * from emp02;

--5-1. pk설정 : 선언 위치에 따른 구분 학습
-- pk 오류시 unique constraint 와 별 다름 없음

drop table emp02;
create table emp02(
	empno number(4) primary key,
	ename varchar2(20) not null
);
insert into emp02 values (1, 'test');
insert into emp02 values (2, 'master');
select * from emp02;


--5-2. 제약조건 설정을 컬럼 선언시에 함께 작업
drop table emp02;
create table emp02(
	empno number(4) constraint pk_emp02_empno primary key,
	ename varchar2(20) not null
);
insert into emp02 values (1, 'test');
insert into emp02 values (2, 'master');
select * from emp02;


--5-3. table 레벨 단위로 작업 (조건들 다 적어놓은 후 마지막에 제약조건 설정)
drop table emp02;
create table emp02(
	empno number(4),
	ename varchar2(20) not null,
	constraint pk_emp02_empno primary key(empno)
);
insert into emp02 values (1, 'test');
insert into emp02 values (2, 'master');
select * from emp02;



--6. 외래키[참조키]
-- 이미 제약 조건이 설정된 dept table의 pk컬럼인 deptno값을 기준으로 emp02의 deptno에도 반영(참조키, 외래키, fk)
-- emp02에서 deptno에서 dept의 deptno를 참조
drop table emp02;
create table emp02(
	empno number(4),
	ename varchar2(20) not null,
	deptno number(2) constraint fk_emp02_deptno References dept(deptno),
	-- 참조 table의 조건과 동일하게 설정
	constraint pk_emp02_empno primary key(empno)
);
insert into emp02 values (1, 'test',10);
insert into emp02 values (2, 'master',20);
select * from emp02;



--7. 6번의 내용을 table 레벨 단위로 설정해 보기
drop table emp02;
create table emp02(
	empno number(4),
	ename varchar2(20) not null,
	deptno number(2),
	constraint pk_emp02_empno primary key (empno),
	constraint fk_emp02_deptno foreign key (deptno) References dept(deptno)
);
insert into emp02 values (1, 'test',10);
insert into emp02 values (2, 'master',20);
select * from emp02;




insert into emp02 values(1, 'tester', 10);
-- 오류 : insert into emp02 values(2, 'master', 60);
select * from emp02;


--8. emp01과 dept01 table 생성
-- create와 as select로 복제되는 table은 원본 table의 데이터와 구조는 복제되나 제약조건은 복제 안됨.

drop table dept01;
drop table emp01;

create table dept01 as select * from dept;
create table emp01 as select * from emp;

select table_name, constraint_type, constraint_name
from user_constraints 
where table_name='DEPT01';

-- dept01의 dept처럼, deptno를 pk로 설정하세요.
alter table dept01 add constraint pk_dept01_deptno primary key(deptno); 
-- dept와 포맷만 같은 dept01 table에 pk_dept01_deptno를 pk로 추가


--9. 이미 존재하는 table에 제약조건 추가하는 명령어 

select table_name, constraint_type, constraint_name
from user_constraints 
where table_name='DEPT01';



-- ? emp01에 제약조건 추가해 보기
select table_name, constraint_type, constraint_name
from user_constraints 
where table_name='EMP01';

-- 제약조건 두 개 : empno : pk  /  deptno가 dept01 table 참조
	--empno : pk >> pk_emp_empno\
	--deptno : fk >> fk_emp01_deptno
alter table emp01 add constraint pk_emp_empno primary key(empno);

alter table emp01 add constraint fk_emp01_deptno foreign key(deptno)
References dept01(deptno);

-- dept01은 emp01의 부모(주), emp01은 자식(종)
delete from dept01 where deptno >= 60;
select * from dept01;

-- emp01에서 사용중인 data 삭제해보기
delete from dept01 where deptno = 10;
select * from dept01;
-- 오류! ORA-02292: integrity constraint (SCOTT.FK_EMP01_DEPTNO) violated - child record found
-- child record found >> 자식이 사용하고 있는데 부모의 data가 지워질 수 없다.




--10. 참조 당하는 key의 컬럼이라 하더라도 자식 table에서 미 사용되는 데이터에 한해서는
	-- 삭제 가능  
-- emp01이 이미 참조하는 데이터가 있는 dept01 table 삭제해보기 




--11.참조되는 컬럼 데이터라 하더라도 삭제 가능한 명령어
	-- *** 현업에선 부득이하게 이미 개발중에 table 구조를 변경해야 할 경우가 간혹 발생
	-- 자식 존재 유무 완전 무시하고 부모 table삭제 

drop table dept01;
--오류 >> ORA-02449: unique/primary keys in table referenced by foreign keys
		
drop table dept01 cascade constraint; -- cascade >> 자식 존재 유무 완전 무시하고 부모 table삭제. 
	
--12. check : if 조건식과 같이 저장 직전의 데이터의 유효 유무 검증하는 제약조건 
-- age값이 1~100까지만 DB에 저장
drop table emp01;

create table emp01(
	name varchar2(10) not null,
	age number(3) constraint ck_emp01_age check (age between 1 and 100)
);

insert into emp01 values('master', 10);
-- 에러 발생 : 1~100까지만 유효 
insert into emp01 values('master', 102);
-- 100이 넘어가서 오류! >> ORA-02290: check constraint (SCOTT.CK_EMP01_AGE) violated

select * from emp01;
select table_name, constraint_type, constraint_name
	from user_constraints where table_name='EMP01';

-- 제약조건 확인 후 emp01 table 삭제 후 다시 딕셔너리 table 검색
-- 결과 : 딕셔너리 table의 정보도 자동 삭제, 딕셔너리 table은 직접 수정 불가.




-- 12.? gender라는 컬럼에는 데이터가 M 또는(or) F만 저장되어야 함
/*
varchar2(10)
	- 가변 문자열 type
	- 3byte data만 저장했을 경우 10byte가 아닌 3byte만 소진

char(10)
	- 고정 문자열 type
	- 3byte data만 저장했을 경우에도 10byte가 소진

결론 : 문자열 데이터의 길이가 가변적이라면 varchar을 사용, 고정 길이 문자열을 사용한다면 char
*/


drop table emp01;


create table emp01(
	name varchar2(10) not null,
	age number(3) constraint ck_emp01_age check (age between 1 and 100),
	gender char(1) constraint ck_emp10_gender check (gender in ('F','M')) 
);

insert into emp01 values('master', 10,'F');
insert into emp01 values('mastow', 20,'M');
insert into emp01 values('masMAS', 30,'T');
-- T가 들어가서 에러! >> ORA-02290: check constraint (SCOTT.CK_EMP10_GENDER) violated
 



insert into emp01 values('master', 'F');
-- 오류 : insert into emp01 values('master', 'T'); 
select * from emp01;




--13. default : insert시에 데이터를 생략해도 자동으로 db에 저장되는 기본값 
drop table emp01;


create table emp01(
	id varchar(10) primary key,
	gender char(1) default 'F' -- gender 항을 입력하지 않아도 자동으로 F가 들어감
);


insert into emp01 (id) values('master');
insert into emp01 values('tester', 'M');
select * from emp01;








