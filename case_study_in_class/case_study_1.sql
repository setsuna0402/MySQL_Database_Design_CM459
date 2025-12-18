#USE company_1;

CREATE TABLE Supervisors (
	supervisor_id   INT auto_increment primary key,
    supervisor_name	VARCHAR(100) not null,
    employment_date	DATE not null
);

CREATE TABLE Departments (
	dept_id       INT auto_increment primary key,
    dept_name	  VARCHAR(256) unique not null,
    supervisor_id INT not null,
    constraint fk_department_supervisor
		foreign key (supervisor_id) 
        references Supervisors (supervisor_id)
        on update cascade
        on delete restrict
);

CREATE TABLE Employees (
	employee_id     INT auto_increment primary key,
    employee_name	VARCHAR(100) not null,
    employment_date	DATE not null,
    dept_id	        INT  not null,
	constraint fk_main_department
		foreign key (dept_id) 
        references Departments (dept_id)
        on update cascade
        on delete restrict
);

CREATE TABLE Projects (
	project_id    INT auto_increment primary key,
    project_name  VARCHAR(256) unique not null,
    PI_id         INT not null,
    constraint fk_project_PI
		foreign key (PI_id) 
        references Employees (employee_id)
        on update cascade
        on delete restrict
);

CREATE TABLE Department_Employee (
	dept_id      INT not null,
    employee_id  INT not null,
    primary key (dept_id, employee_id), # ensure no duplicated relationships
    constraint fk_dept_emp_departments
		foreign key (dept_id) 
        references Departments (dept_id)
        on update cascade
        on delete cascade,
	constraint fk_dept_emp_employees
		foreign key (employee_id) 
        references Employees (employee_id)
        on update cascade
        on delete cascade
);

CREATE TABLE Project_Employee (
	project_id      INT not null,
    employee_id  INT not null,
    primary key (project_id, employee_id), # ensure no duplicated relationships
    constraint fk_proj_emp_projects
		foreign key (project_id) 
        references Projects (project_id)
        on update cascade
        on delete cascade,
	constraint fk_proj_emp_employees
		foreign key (employee_id) 
        references Employees (employee_id)
        on update cascade
        on delete cascade
);

