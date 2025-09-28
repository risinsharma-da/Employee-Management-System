create database EmployeeDB;
use EmployeeDB;

select*from departments;
select*from job;
SELECT * FROM emp;
SELECT*FROM salary;
SELECT * FROM projects;
SELECT * FROM emp_projects;

#creating keys
alter table departments                              #department_id primary key
add primary key(department_id);

alter table job                                     #job_id primary key
add primary key (job_id);

alter table emp                                     #employee_id pk, job_id fk , department_id fk
add primary key(employee_id),
add constraint job_id
foreign key(job_id) references job(job_id),
add constraint department_id
foreign key(department_id) references departments(department_id);

alter table salary                                 #salary_id pk,employee_id fk
add primary key(salary_id),
add constraint employee_id
foreign key (employee_id) references emp(employee_id);

alter table projects                               #project_id pk
add primary key(project_id);

alter table emp_projects                          #id pk,emp_id fk, project_id fk
add primary key(id),
add constraint emp_id
foreign key (employee_id) references emp(employee_id),
add constraint project_id
foreign key(project_id) references projects(project_id);

describe departments;     
describe job;
describe emp;
describe salary;
describe projects;
describe emp_projects;

#change date format of emp hire_date

alter table emp
add column hire_date_new date;
update table emp
set hire_date_new=str_to_date(hire_date,'%d-%m-%Y');

-- Basic SQL Questions (1-15)
-- List all employees with their first and last names.
select 
       employee_id,
       concat(first_name," ",last_name) as full_name
from emp;

-- Retrieve employee names along with their department names.
select 
	 e.employee_id,
     concat(e.first_name," ",e.last_name) as full_name,
     e.department_id,
     d.department_name
from emp as e
join departments as d
on e.department_id=d.department_id;

-- Show all job titles available.
select job_title 
from job;

-- Find employees hired after January 1, 2020.
select 
     employee_id,
     concat(first_name," ",last_name) as full_name,
     hire_date_new
from emp
where hire_date_new>="2020-01-01";

-- List employees earning more than ₹50,000.
select 
      e.employee_id,
      concat(e.first_name," ",e.last_name) as full_name,
      s.salary
from emp as e
left join salary as s
on e.employee_id=s.employee_id
where salary>50000;

-- Count the total number of employees in each department.
select 
      e.department_id,
      d.department_name,
      count(e.employee_id) as no_of_emp_dep
from emp as e
left join departments as d
on e.department_id=d.department_id
group by department_id;

-- Find unique job titles from the job table.
select 
      distinct(job_title) 
from job;

-- Retrieve employees sorted by their hire date.
select*from emp
order by hire_date_new;

-- Find employees with missing phone numbers.
update emp
set phone=Null where employee_id=2;
select 
      employee_id,
      concat(first_name," ",last_name) as full_name
from emp 
where phone is null;

-- List employee names and their salaries.
select 
      e.employee_id,
      concat(e.first_name," ",e.last_name) as full_name,
      s.salary
from emp as e
left join salary as s
on e.employee_id=s.employee_id;


-- Show departments with more than and equal to 200 employees.
select 
      e.department_id,
      d.department_name,
      count(e.employee_id) as no_of_emp_dep
from emp as e
left join departments as d
on e.department_id=d.department_id
group by department_id
having count(e.employee_id)>=200;

-- Retrieve employees with the letter 'a' in their first name.
select 
      employee_id,
      first_name
from emp
where first_name like "A%";

-- List all projects.
select project_name from projects;

-- Show employees without any project assignment.
select 
       e.employee_id,
       e.first_name
from emp as e 
left join emp_projects as ep
on ep.employee_id=e.employee_id
where ep.project_id is null;

-- Find employees whose last name starts with 'S'.
select 
      employee_id,
      concat(first_name ," " ,last_name)
from emp
where last_name like "S%";

-- Intermediate SQL Questions (16-35)
-- Find the average salary per department.
select 
      e.department_id,
      avg(s.salary)
from emp as e
join salary as s
on e.employee_id=s.employee_id
group by department_id
order by department_id;

-- List employees working on each project.
select 
	  p.project_id,
      p.project_name,
      e.employee_id,
      concat(e.first_name, ' ', e.last_name) AS full_name
from projects as p
join emp_projects as ep
on p.project_id=ep.project_id
join emp as e
on e.employee_id=ep.employee_id
order by e.employee_id,p.project_id;



-- Get employees and their total number of projects.
select 
      ep.employee_id,
      concat(e.first_name," ",e.last_name) as full_name,
      count(project_id) as total_projects
from emp_projects as ep
join emp as e
on ep.employee_id=e.employee_id
group by employee_id
order by e.employee_id;

-- Display employees with salaries above the department average.
select*from emp;
select*from salary;
select e.employee_id,e.first_name,s.salary
from emp as e
join salary as s
on e.employee_id=s.employee_id
where s.salary>(select 
                       avg(s2.salary)
			     from emp as e2
                 join salary as s2
			     on e2.employee_id=s2.employee_id
                 where  e2.department_id=e.department_id);

select 
      e.department_id,
      avg(s.salary)
from emp as e
join salary as s
on e.employee_id=s.employee_id
group by department_id
order by department_id;




-- Show departments with no employees assigned.
select*from emp;
select*from departments;
update emp
set department_id=null
where employee_id=2;
select*
from emp where department_id is null;


-- List projects with no employees assigned.
select*from emp_projects;
update emp_projects
set project_id=NULL 
where project_id=1;
select
      p.project_id,
      p.project_name
from projects as p
left join emp_projects as ep on p.project_id=ep.project_id
left join emp as e on e.employee_id=ep.employee_id
where ep.project_id is null;

-- Find employees working on multiple projects.
select 
      e.employee_id,
      e.first_name,count(ep.project_id)
from emp_projects as ep
left join emp as e
on e.employee_id=ep.employee_id
group by ep.employee_id
having count(ep.project_id)>1
order by employee_id
; 


-- Show the total salary expense per department.
select 
      d.department_id,
      d.department_name,sum(s.salary)
from departments as d
join emp as e on e.department_id=d.department_id
join salary as s on s.employee_id = e.employee_id 
group by e.department_id;


-- List employees who have been with the company for more than 5 years.
select 
       employee_id,
       first_name,floor(datediff(curdate(),hire_date_new)/365) as years_worked
from emp
where floor(datediff(curdate(),hire_date_new)/365)>5
;

-- Find the lowest paid employee in each department.
select*from emp;
select*from departments;
select *from salary;
select e.employee_id,e.first_name,e.department_id,d.department_name,s.salary
from emp as e
join departments as d on e.department_id=d.department_id
join salary as s on e.employee_id=s.employee_id
;

select e.employee_id,e.first_name, d.department_name,d.department_name,s.salary
from emp as e
join departments as d on e.department_id=d.department_id
join salary as s on e.employee_id=s.employee_id
where s.salary=(select min(s.salary) from salary);

SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    s.salary
FROM emp e
JOIN salary s ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE s.salary = (
    SELECT MIN(salary)
    FROM emp em
    JOIN salary sa ON em.employee_id = sa.employee_id
    WHERE em.department_id = e.department_id
);


-- Show projects that have started but not completed.
select*from projects 
where end_date>curdate();

-- Count the number of employees per job title.
select
      j.job_id,
      j.job_title,
      count(e.employee_id) as total_emp
from job as j
join emp as e
on e.job_id=j.job_id
group by job_id;


-- Find employees with duplicate email addresses.
select*from emp;
update emp
set email="croberts@rivera.info"
where employee_id=3;

select distinct e1.*
from emp as e1
join emp as e2
on e1.email=e2.email and e1.employee_id!=e2.employee_id;


-- Calculate the difference between highest and lowest salary.
select *from salary;
select (max(salary)-min(salary)) as diiff_btw_high_low from salary;


-- List employees who were hired in the last 6 months.
select*from emp
where month(hire_date_new)= month(curdate() - interval 6 month)
and year(hire_date_new)=year(curdate()-interval 6 month);

-- Find departments with average salary above ₹75,000.
select 
      d.department_id,
      d.department_name,
      avg(s.salary)
from salary as s
join emp as e on s.employee_id=e.employee_id
join departments as d on d.department_id=e.department_id
group by e.department_id
having avg(s.salary)>75000;


-- Advanced SQL Questions
-- Rank employees by salary within their department.
select
     e.employee_id,
     e.first_name,
     e.department_id,
     s.salary_id,
     s.salary,
     rank() over (partition by e.department_id order by s.salary) as rank_by_salary
from emp as e
join salary as s
on e.employee_id=s.employee_id;


-- Calculate cumulative salary ordered by hire date.
SELECT
      e.employee_id,
      e.first_name,
      s.salary,
      SUM(s.salary) OVER (ORDER BY e.hire_date_new DESC) AS cume
FROM emp e
JOIN salary s ON e.employee_id = s.employee_id
ORDER BY e.hire_date_new;



-- Show employees and their projects with project duration.
select 
      e.employee_id,
      e.first_name,
      p.project_id,
      p.project_name,
      datediff(p.end_date,p.start_date) as duration_days
from emp_projects as ep
join emp as e on ep.employee_id=e.employee_id
join projects as p on p.project_id=ep.project_id
order by e.employee_id;

-- Calculate the percentage of employees per department.
select d.department_id,
       d.department_name,
       count(e.employee_id) as employee_count,
       (count(e.employee_id) * 100.0 / total.total_count) as percentage
from departments as d
join emp as e on d.department_id = e.department_id
cross join (select count(employee_id) as total_count from emp) as total
group by d.department_id, d.department_name, total.total_count;

