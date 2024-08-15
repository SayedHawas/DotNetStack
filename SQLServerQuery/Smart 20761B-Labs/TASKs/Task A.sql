------created a database for the two tables called test--------
Create database test 
go 
use test
go
CREATE TABLE Departments (
   Code INTEGER PRIMARY KEY NOT NULL,
   Name varchar(50) NOT NULL ,
   Budget REAL NOT NULL 
 );

 Go

 CREATE TABLE Employees (
   SSN INTEGER PRIMARY KEY NOT NULL,
   Name varchar(50) NOT NULL ,
   LastName varchar(50) NOT NULL ,
   Department INTEGER NOT NULL , 
   CONSTRAINT fk_Departments_Code FOREIGN KEY(Department) 
   REFERENCES Departments(Code)
 );

Go

INSERT INTO Departments(Code,Name,Budget) VALUES(14,'IT',65000);
INSERT INTO Departments(Code,Name,Budget) VALUES(37,'Accounting',15000);
INSERT INTO Departments(Code,Name,Budget) VALUES(59,'Human Resources',240000);
INSERT INTO Departments(Code,Name,Budget) VALUES(77,'Research',55000);

INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('123234877','Michael','Rogers',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('152934485','Anand','Manikutty',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('222364883','Carol','Smith',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('326587417','Joe','Stevens',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332154719','Mary-Anne','Foster',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332569843','George','ODonnell',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('546523478','John','Doe',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('631231482','David','Smith',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('654873219','Zacary','Efron',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('745685214','Eric','Goldsmith',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657245','Elizabeth','Doe',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657246','Kumar','Swamy',14);

Go
--1-Select the last name of all employees.



-----------------------------------------------------------------------------------------------------------------------------------
--2-Select the last name of all employees, without duplicates.



-----------------------------------------------------------------------------------------------------------------------------------
--3-Select all the data of employees whose last name is "Smith".


-----------------------------------------------------------------------------------------------------------------------------------
--4-Select all the data of employees whose last name is "Smith" or "Doe".


--or


-----------------------------------------------------------------------------------------------------------------------------------
--5-Select all the data of employees that work in department 14.



-----------------------------------------------------------------------------------------------------------------------------------
--6-Select all the data of employees that work in department 37 or department 77.



-----------------------------------------------------------------------------------------------------------------------------------
--7-Select all the data of employees whose last name begins with an "S".



-----------------------------------------------------------------------------------------------------------------------------------
--8-Select the sum of all the departments' budgets.


-----------------------------------------------------------------------------------------------------------------------------------
--9-Select the number of employees in each department (you only need to show the department code and the number of employees).




--and Name 


-----------------------------------------------------------------------------------------------------------------------------------
--10-Select all the data of employees, including each employee's department's data.


-----------------------------------------------------------------------------------------------------------------------------------
--11-Select the name and last name of each employee, along with the name and budget of the employee's department.



-----------------------------------------------------------------------------------------------------------------------------------
--12-Select the name and last name of employees working for departments with a budget greater than $60,000.


