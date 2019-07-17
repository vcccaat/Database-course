-- ZHU Yingshi 20308862
set feedback off;


drop table InterestedIn;
drop table Supervises;
drop table Requirement;
drop table Students;
drop table ProjectGroup;
drop table FYProject;
drop table ProjectCategory;
drop table Faculty;



create table Faculty(
    username varchar2(15) primary key, 
    facultyName varchar2(30) not null, 
    roomNo varchar2(5) not null, 
    facultyCode char(2) not null,
    constraint CHK_facultyCode check (regexp_like(facultyCode, '[A-Z]')),
    constraint CHK_roomno check(regexp_like(roomNo,'[0-9]{4}[A-Z]{0,1}')),
    constraint CHK_username check(regexp_like(username,'[a-z]{3,15}')));
    
create table ProjectCategory(
    fypCategory varchar2(30) primary key,
    constraint CHK_category check (fypCategory in ('Artificial Intelligence',
     'Computer Games', 'Computer Security', 'Database',
    'Embedded Systems and Software', 'Human Language Technology',
    'Miscellaneous', 'Mobile and Wireless Computing', 'Mobile Applications',
    'Mobile Gaming', 'Networking', 'Operating Systems', 'Software Technology',
    'Theory', 'Vision and Graphics')));
    
create table FYProject(
    fypId smallint primary key, 
    title varchar2(100) not null, 
    fypDescription varchar2(1200) not null, 
    fypCategory varchar2(30) not null references ProjectCategory(fypCategory) on delete cascade, 
    fypType varchar2(7) not null, 
    requirement varchar2(200),  
    minStudents smallint default 1, 
    maxStudents smallint default 1, 
    isAvailable char(1) default 'Y',
    constraint CHK_fypType check(fypType in ('project','thesis')),
    constraint CHK_isavailable check(isAvailable in ('Y','N')),
    constraint CHK_min check(minStudents between 1 and maxStudents),
    constraint CHK_thesis check(type!= 'thesis' or maxStudents=1),
    constraint CHK_max check(maxStudents between minStudents and 4));

   
    
create table ProjectGroup(
    groupId smallint primary key, 
    groupCode varchar2(5) unique not null, 
    fypAssigned smallint unique references FYProject(fypId) on delete set null,  
    reader varchar2(15) references Faculty(username) on delete set null,
    constraint CHK_groupcode check (regexp_like(groupCode,'[A-Z]{2,4}[1-4]')));

    
create table Students(
    username varchar2(15) primary key, 
    studentName varchar2(30) not null, 
    groupId smallint references ProjectGroup(groupId) on delete set null);
    
create table Requirement(
    facultyUsername varchar2(15) not null references Faculty(username) on delete cascade, 
    studentUsername varchar2(15) not null references Students(username) on delete cascade, 
    proposalGrade number(4,1) , 
    progressGrade number(4,1), 
    presentationGrade number(4,1), 
    finalGrade number(4,1),
    primary key(facultyUsername,studentUsername),
    constraint CHK_grade01 check (regexp_like(proposalGrade,'[0-100]')),
    constraint CHK_grade02 check (regexp_like(progressGrade,'[0-100]')), 
    constraint CHK_grade03 check (regexp_like(presentationGrade,'[0-100]')), 
    constraint CHK_grade04 check (regexp_like(finalGrade,'[0-100]')));

    
create table InterestedIn(
    fypId smallint references FYProject(fypId) on delete cascade, 
    groupId smallint references ProjectGroup(groupId) on delete cascade, 
    fypPriority smallint not null,
    primary key(fypId,groupId),
    constraint CHK_priority check(regexp_like(fypPriority,'[1-5]')));
    
create table Supervises(
    username varchar2(15) references Faculty(username) on delete cascade, 
    fypId smallint references FYProject(fypId) on delete cascade,
    primary key(username,fypId));
    
 
 -- test
/*

insert into Faculty values ('prof1','prof1name1','0000','AA');
insert into Faculty values ('prof2','prof1name2','1111','BB');
insert into Faculty values ('prof3','prof1name3','1111','BB');

insert into ProjectCategory values ('Database');
insert into ProjectCategory values ('Computer Security');
insert into ProjectCategory values ('Artificial Intelligence');
insert into ProjectCategory values ('Miscellaneous');

insert into FYProject values (99,'FYP1','Test description','Database','project','Test skill',1,1,'Y');
insert into FYProject values (98,'FYP2','Test description','Artificial Intelligence','project','Test skill',1,1,'Y');
insert into FYProject values (97,'FYP3','Test description','Database','project','Test skill',1,1,'Y');
insert into FYProject values (96,'FYP4','Test description','Miscellaneous','project','Test skill',1,1,'Y');
insert into FYProject values (95,'FYP5','Test description','Miscellaneous','thesis','Test skill',1,2,'Y');

   
insert into ProjectGroup values (10,'FN1',99,null);
insert into ProjectGroup values (9,'FN2',96,null);
insert into ProjectGroup values (8,'FN3',98,null);

insert into Students values ('a','a',9);
insert into Students values ('b','b',9);
insert into Students values ('c','c',9);
insert into Students values ('e','e',8);
insert into Students values ('f','f',8);
insert into Students values ('g','g',8);
insert into Students values ('h','h',8);
insert into Students values ('Z','Z',10);

 
insert into InterestedIn values (99,10,1);
insert into InterestedIn values (98,8,1);
insert into InterestedIn values (98,10,2);
insert into InterestedIn values (96,9,3);

insert into Requirement values ('prof1','a',1,1,null,1);



insert into Supervises values ('prof1',99);
insert into Supervises values ('prof1',98);
insert into Supervises values ('prof2',96);
*/
  
commit;    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    