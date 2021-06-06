
/*
drop table movie;
drop table actor;
drop table director;
drop table genre;
drop table movie cascade constraint;



-- movie table 제작 (영화제목(PK), 개봉일, 평점, 관객 수, 상영 시간, 장르 ID)
create table movie (movie_id varchar2(20),
                    release_date date,
                    rating int,
                    audience_no int,
                    running_time int,
                    genre_id int,
                    primary key(movie_id));

-- actor table 제작 (배우 이름(PK), 출연 영화(FK), 역할, 소속사, 성별)
create table actor (actor_id varchar2(20),
                    movie_id varchar2(20),
                    character varchar2(20),
                    agency varchar2(20),
                    gender char(1) constraint actor_gender check (gender in ('F','M')), -- F 혹은 M만 적을 수 있도록 제한
                    primary key(actor_id),
                    foreign key(movie_id) references movie(movie_id));    

-- director table 제작 (감독 이름(PK), 제작 영화(FK), 대표작, 나이)
create table director (director_id varchar2(20),
                        movie_id varchar2(20),
                        popular varchar2(20),
                        age int,
                        primary key(director_id),
                        foreign key(movie_id) references movie(movie_id));

-- genre table 제작 (1:드라마 / 2:SF / 3:멜로 / 4:코미디)
create table genre (genre_id int,
                    genre_name varchar2(20),
                    primary key(genre_id));

-- movie 세부사항 추가
insert into movie values('jurassic park',to_date('1991-06-11','yyyy-mm-dd'),9.32,555,132,2);
insert into movie values('Titanic',to_date('1998-02-20','yyyy-mm-dd'),9.88,197,194,3);
INSERT INTO movie VALUES('기생충', to_date('2019-05-30','yyyy-mm-dd'), 9.07, 1030, 132, 1);
insert into movie values ('Cruella',to_date('2021-05-26','yyyy-mm-dd'),8.7,38,133,4);
insert into movie values('미나리', to_date('2021-03-03','yyyy-mm-dd'), 8.31, 110, 115, 1);

-- actor 세부사항 추가
insert into actor values('Sam Neill','jurassic park','DR.allen grant','Curtis Brown', 'M');
insert into actor values('Laura Dern','jurassic park','Ellie Sattler','IMDbPro', 'F');
insert into actor values('Jeff Goldblum','jurassic park','Ian Malcolm','Elevate Artist', 'M');
insert into actor values('Leonardo DiCaprio','Titanic','Jack Dawson','Creative Artists', 'M');
insert into actor values('Kate Winslet','Titanic','Rose DeWitt','United Agents', 'F');
insert into actor values('Billy Zane','Titanic','Caledon Hockley','MN2S', 'M');
INSERT INTO actor VALUES('송강호', '기생충', '기택 역', '써브라임', 'M');
INSERT INTO actor VALUES('이선균', '기생충', '동익 역', '호두앤유', 'M');
INSERT INTO actor VALUES('조여정', '기생충', '연교 역', '높은엔터', 'F');
INSERT INTO actor VALUES('최우식', '기생충', '기우 역', '매니지먼트 숲', 'M');
INSERT INTO actor VALUES('박소담', '기생충', '기정 역', '아티컴퍼니', 'F');
INSERT INTO actor VALUES('이정은', '기생충', '문광 역', '윌엔터', 'F');
INSERT INTO actor VALUES('장혜진', '기생충', '충숙 역', '아이오케이', 'F');
insert into actor values ('Emma Stone', 'Cruella', 'Cruella', '','F');
insert into actor values ('Emma Thompson', 'Cruella', 'Baroness', 'Hamilton','F');
insert into actor values ('Emily Beecham', 'Cruella', 'Catherine Miller' , 'Beaumont', 'F');
insert into actor values('스티븐연', '미나리', '제이콥', 'B앤C', 'M');
insert into actor values('한예리', '미나리', '모니카', '사람엔터', 'F');
insert into actor values('윤여정', '미나리', '순자', '후크엔터', 'F');
insert into actor values('앨런김', '미나리', '데이빗', 'CAA', 'M');

-- director 세부사항 추가
insert into director values('Steven Spielberg','jurassic park','ET',74);
insert into director values('James Cameron','Titanic','Avatar',66);
INSERT INTO director VALUES('봉준호','기생충','괴물', 53);
insert into director values ('Craig Gillespie', 'Cruella', 'Lars and Real Girl', 53);
insert into director values('정이삭','미나리','괴물',45);

-- genre 구분 추가
insert into genre values(1,'드라마');
insert into genre values(2,'SF');
insert into genre values(3,'Melo/Romance');
insert into genre values(4,'Comedy');

commit;

*/

select * from actor where movie_id = '기생충' and gender = 'M';




-- 다른 조 작품 참고

create table star(
	star_id number(4) primary key,
    star_name varchar2(20) not null,
	star_gender char(1) constraint ck_star_gender check (star_gender in ('F', 'M'))
);

create table day(
	day_id number(1) primary key,
    day_name varchar2(10) not null
);

create table genre(
	gen_id number(2) primary key,
    gen_name varchar2(20) not null
);

create table age(
	age_id number(2) primary key,
    age_name varchar2(20) not null
);

create table program(
    pro_id number(6) primary key,
    pro_name varchar2(50) not null,
    day_id number(1),
    gen_id number(2),
    age_id number(2),
    pro_ratings number(3,1) not null,
    constraint fk_program_day_id foreign key (day_id) references day(day_id),
    constraint fk_program_gen_id foreign key (gen_id) references genre(gen_id),
    constraint fk_program_age_id foreign key (age_id) references age(age_id)
);

create table casting(
	pro_id number(2),
    star_id number(4),
    constraint pk_casting primary key (pro_id,star_id),
    constraint fk_casting_pro_id foreign key (pro_id) references program(pro_id)
    constraint fk_casting_star_id foreign key (star_id) references star(star_id)
);



-- 2. 데이터 insert

-- 2-1. star 테이블 정보
insert into star values('1', '강호동', 'M');
insert into star values('2', '규현', 'M');
insert into star values('3', '김구라', 'M');
insert into star values('4', '김국진', 'M');
insert into star values('5', '김동현', 'M');
insert into star values('6', '김성주', 'M');
insert into star values('7', '김숙', 'F');
insert into star values('8', '김영철', 'M');
insert into star values('9', '김종국', 'M');
insert into star values('10', '김준현', 'M');
insert into star values('11', '김희철', 'M');
insert into star values('12', '민경훈', 'M');
insert into star values('13', '박성광', 'M');
insert into star values('14', '서장훈', 'M');
insert into star values('15', '송민호', 'M');
insert into star values('16', '송지효', 'F');
insert into star values('17', '신동엽', 'M');
insert into star values('18', '안영미', 'F');
insert into star values('19', '양세찬', 'M');
insert into star values('20', '오지호', 'M');
insert into star values('21', '유세윤', 'M');
insert into star values('22', '유재석', 'M');
insert into star values('23', '은지원', 'M');
insert into star values('24', '이경규', 'M');
insert into star values('25', '이광수', 'M');
insert into star values('26', '이덕화', 'M');
insert into star values('27', '이상민', 'M');
insert into star values('28', '이수근', 'M');
insert into star values('29', '이태곤', 'M');
insert into star values('30', '장동민', 'M');
insert into star values('31', '전소민', 'F');
insert into star values('32', '전진', 'M');
insert into star values('33', '지석진', 'M');
insert into star values('34', '츄', 'F');
insert into star values('35', '피오', 'M');
insert into star values('36', '하하', 'M');

-- 2-2 요일 테이블 정보
insert into day values('1', '월요일');
insert into day values('2', '화요일');
insert into day values('3', '수요일');
insert into day values('4', '목요일');
insert into day values('5', '금요일');
insert into day values('6', '토요일');
insert into day values('7', '일요일');

-- 2-3 장르 테이블 정보
insert into genre values(1, '둘다');
insert into genre values(2, '실내');
insert into genre values(3, '실외');

-- 2-4 나이 테이블 정보
insert into age values('1', '15세');
insert into age values('2', '12세');

-- 2-5 프로그램 테이블 정보
insert into program values(1,'동상이몽',1,1,1,6.4);
insert into program values(2,'미운오리새끼',7,1,1,14.6);
insert into program values(3,'아는형님',6,2,1,3.1);

-- 2-6 캐스팅 테이블 정보
insert into casting values(1,3);
insert into casting values(1,14);
insert into casting values(1,7);
insert into casting values(1,13);
insert into casting values(1,32);
insert into casting values(1,20);

insert into casting values(2,17);
insert into casting values(2,14);
insert into casting values(2,11);
insert into casting values(2,27);
insert into casting values(2,9);

insert into casting values(3,1);
insert into casting values(3,14);
insert into casting values(3,28);
insert into casting values(3,11);
insert into casting values(3,12);
insert into casting values(3,9);
insert into casting values(3,8);

insert into casting values(4,22);
insert into casting values(4,9);
insert into casting values(4,36);
insert into casting values(4,33);
insert into casting values(4,31);
insert into casting values(4,25);
insert into casting values(4,19);
insert into casting values(4,16);

insert into casting values(5,3);
insert into casting values(5,4);
insert into casting values(5,18);
insert into casting values(5,21);

insert into casting values(6,1);
insert into casting values(6,2);
insert into casting values(6,23);
insert into casting values(6,15);
insert into casting values(6,28);
insert into casting values(6,35);

insert into casting values(7,6);
insert into casting values(7,30);
insert into casting values(7,11);
insert into casting values(7,5);
insert into casting values(7,34);

insert into casting values(8,28);
insert into casting values(8,14);

insert into casting values(9,24);
insert into casting values(9,26);
insert into casting values(9,28);
insert into casting values(9,10);
insert into casting values(9,29);

-- 3. 조회할 데이터 select문

-- 3-1. 프로그램별 출연자 정보 조회
select p.pro_name, s.star_name, s.star_gender
from program p inner join casting c on p.pro_id = c.pro_id
               inner join star s on c.star_id = s.star_id;