/*  ZHU Yingshi   20308862*/

/* 1. Find the user name and name of those faculty who have not posted any FYPs to supervise.*/
select username, facultyName
from Faculty
minus
select username, facultyName
from Faculty natural join Supervises;


/* 2. Find the number of FYPs in each project category. 
Order the result first by the number of FYPs in descending order and then by category in ascending order.*/
select ProjectCategory.fypCategory,count(FYProject.fypCategory) as NumberProject
from ProjectCategory left outer join FYProject on FYProject.fypCategory = ProjectCategory.fypCategory
group by ProjectCategory.fypCategory 
order by NumberProject desc, ProjectCategory.fypCategory asc;


/* 3. Find the names of the faculty who posted the most FYPs and the number of FYPs posted.*/
with result (username, numberPost,facultyName) as 
	(select username, count(*), facultyName
	from Faculty natural join Supervises 
	group by username,facultyName)
select facultyName, numberPost
from result
where numberPost = (select max(numberPost)
					from result);

/* 4. Find the title and category of the FYP and the names of the students in the group for
those groups of exactly four students that have expressed an interest with a priority equal 
to one in the FYP. Order the result first by category ascending and then by student name ascending. */
    
select title, fypCategory, studentName
from FYProject natural join ProjectGroup natural join Students natural join InterestedIn
where groupId in (select groupId
                from ProjectGroup natural join Students
                group by groupId
                having count(*)=4)
    and fypPriority =1
order by fypCategory, studentName;

    

/* 5. Find the FYP title, supervisor name, names of the students in the project group and 
the priority specified for the FYP for those project groups that specified an interest in 
only one FYP and were assigned to that FYP. */
      
select title, facultyName, studentName, fypPriority
from ProjectGroup, InterestedIn, FYProject, Students, Faculty, Supervises
where FYProject.fypId = ProjectGroup.fypAssigned
    and Students.groupId = ProjectGroup.groupId
    and Faculty.username = Supervises.username
    and Supervises.fypId = FYProject.fypId
    and ProjectGroup.groupId = InterestedIn.groupId
    and InterestedIn.fypId = ProjectGroup.fypAssigned
    and InterestedIn.groupId in (select groupId
                    from ProjectGroup natural join InterestedIn
                    group by groupId
                    having count(*)=1);

