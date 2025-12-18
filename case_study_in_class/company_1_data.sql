USE company_1;
INSERT INTO Supervisors (supervisor_name, employment_date)
VALUES 
	('Ray', '2010-10-1'),
    ('Jerry', '2010-10-1'),
    ('David', '2010-10-1');

INSERT INTO Departments (dept_name, supervisor_id)
VALUES 
	('HR', 1),
    ('MKT', 2),
    ('Hotel', 3);
    
INSERT INTO Employees (dept_id, employee_name, employment_date)
VALUES 
	( 1, 'John', '2010-10-1' ),
    ( 1, 'Peter', '2010-10-1'),
    ( 1, 'Mary', '2010-10-1' ),
    ( 2, 'Benson', '2010-10-1')
    ;
    
INSERT INTO Projects (PI_id, project_name)
VALUES 
	(2, 'HR revamp'),
    (1, 'Hotel new system')
    ;
    
INSERT INTO Department_Employee (dept_id, employee_id)
VALUES 
	(1, 1),
    (3, 1),
    (1, 2),
    (1, 3),
    (3, 3),
    (2, 4)
    ;
  
INSERT INTO Project_Employee (project_id, employee_id)
VALUES 
	(1, 2),
    (2, 3),
    (1, 3),
    (2, 1)
    ;
    
    