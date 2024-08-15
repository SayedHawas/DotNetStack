 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(6,'Nickelodeon',NULL);

Go
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
---------------------------------------------------------------------------------------------------------------------------------
--1-Select the title of all movies.
--2-Select the last name of all employees, without duplicates.
--3-Show all unrated movies.
--4-Select all movie theaters that are not currently showing a movie.
--5-Select all data from all movie theaters and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
--6-Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
--7-Show the titles of movies not currently being shown in any theaters. (subQuery)
--Good Luck :)