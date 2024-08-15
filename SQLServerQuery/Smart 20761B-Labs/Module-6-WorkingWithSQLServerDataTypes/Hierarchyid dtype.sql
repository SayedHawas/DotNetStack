--Hierarchyid Data Type
/*
The hierarchyid data type allows you to construct relationships among
 data elements within a table, specifically to represent a 
 position in a hierarchy
 */
 
USE MASTER
GO
CREATE DATABASE MyCompany
GO
USE MyCompany
GO

--Create a table called employee that will store
--the data for the employees for MyCompany.
    
CREATE TABLE employee
(
    EmployeeID int NOT NULL,
    EmpName    varchar(20) NOT NULL,
    Title      varchar(20) NULL,
    Salary     decimal(18, 2) NOT NULL,
    hireDate   datetimeoffset(0) NOT NULL,
)
GO

--These statements will insert the data for the employees of MyCompany.

INSERT INTO employee
VALUES(6,'David',  'CEO'  ,  35900.00, '2000-05-23T08:30:00-08:00') ,
(46,  'Sariya', 'Specialist' , 14000.00,  '2002-05-23T09:00:00-08:00'),
(271, 'John',   'Specialist' , 14000.00,  '2002-05-23T09:00:00-08:00'),
(119, 'Jill',   'Specialist' , 14000.00,  '2007-05-23T09:00:00-08:00'),
(269, 'Wanida', 'Assistant'  ,  8000.00 , '2003-05-23T09:00:00-08:00')  ,
(272, 'Mary',   'Assistant'  ,  8000.00 , '2004-05-23T09:00:00-08:00')

select * from employee


/*
Every business has a reporting structure :
All employees of MyCompany report to David, 
the CEO. Some employees report directly, as in the case of Jill.
Others, like Mary, report through an intermediary. 

David : at the top :reports to no one (parent or ancestor)
The employees that report to David are beneath (nodes:children or descendants)
David can have as many descendants as needed to represent his direct reports.

figure 1 : structure 
 
*/

--Rebuilds the MyCompany database using the hierarchyid data type, 
--constructing a relationship that matches the reporting structure for MyCompany.
--The ALTER TABLE statement is used to first add a column of type hierarchyid. 
--David's node is then inserted using hierarchyid's GetRoot method. 
--David's directs are then added to the tree using the GetDescendant method.

 DELETE employee
GO
ALTER TABLE employee ADD OrgNode hierarchyid  NULL
GO

DECLARE @child hierarchyid,
@Manager hierarchyid = hierarchyid::GetRoot()

--The first step is to add the node at the top of the
--tree. Since David is the CEO his node will be the
--root node.

INSERT INTO employee
VALUES(6,   'David',  'CEO', 35900.00,
       '2000-05-23T08:30:00-08:00', @Manager)

--The next step is to insert the records for
--the employees that report directly to David.

SELECT @child = @Manager.GetDescendant(NULL, NULL)

INSERT INTO employee
VALUES(46,  'Sariya', 'Specialist', 14000.00,
       '2002-05-23T09:00:00-08:00', @child)

SELECT @child = @Manager.GetDescendant(@child, NULL)
INSERT INTO employee
VALUES(271,'John', 'Specialist', 14000.00,
       '2002-05-23T09:00:00-08:00', @child)

SELECT @child = @Manager.GetDescendant(@child, NULL)
INSERT INTO employee
VALUES(119,'Jill','Specialist', 14000.00,
       '2007-05-23T09:00:00-08:00', @child)

--We can now insert the employee that reports to
--Sariya.
SELECT @manager = OrgNode.GetDescendant(NULL, NULL)
FROM employee WHERE EmployeeID = 46

INSERT INTO employee
VALUES(269,'Wanida','Assistant', 8000.00,
       '2003-05-23T09:00:00-08:00', @manager)

--Next insert the employee that report to John.
SELECT @manager = OrgNode.GetDescendant(NULL, NULL)
FROM employee WHERE EmployeeID = 271

INSERT INTO employee
VALUES(272,'Mary','Assistant', 8000.00,
       '2004-05-23T09:00:00-08:00', @manager)
GO


/*
Once the database records are added and the hierarchy is constructed,
the contents of the employee table can be displayed with a query like this:
*/

SELECT EmpName, Title, Salary, OrgNode.ToString() AS OrgNode
FROM employee ORDER BY OrgNode


/*
-OrgNode is the hierarchyid column. 
-Each slash / character in the result indicates a node in the hierarchy tree.
-David is at the root, which is shown with a single slash. 
-Sariya, John, and Jill report to David and have two slash marks, 
 indicating that they are the second node in the hierarchy. 
-The numbers 1, 2, or 3 show the order of the respective child node. 
-This system is very flexible.
-Child nodes can be removed, inserted, or added as needed.
-If we added an employee between John and Jill, for example, 
 that employee would be listed in the resultset as: /2.1/.
 
To answer the question, for example, 
"Who reports to Sariya?" 
you can create a query as shown in the following T-SQL code:

*/
DECLARE @Sariya hierarchyid

SELECT @Sariya = OrgNode
FROM employee WHERE EmployeeID = 46

SELECT EmpName, Title, Salary, OrgNode.ToString() AS 'OrgNode'
FROM employee
WHERE OrgNode.GetAncestor(1) = @Sariya
GO

/*
-The query uses the hierarchyid's GetAncestor method, 
 which returns the parent of the current hierarchyid node. 
-In the previous code, the variable @Sariya is set to the hierarchy node 
 for Sariya. 
 This is because Sariya is the direct ancestor of any employee that 
 reports to her. Therefore, writing a query that returns the employees 
 that report directly to Sariya consists of retrieving Sariya's node from
 the tree and then selecting all employees whose ancestor node is Sariya's node.
-Hierarchyid columns tend to be very compact because the number of bits
 required to represent a node in a tree depends on the average number 
 of children for the node (commonly referred to as the node's fanout). 
 
  For example, a new node in an organizational hierarchy of 100,000 employees,
  with an average fanout of six levels, would take about five bytes of 
  storage.
  
-The hierarchyid data type provides several methods that facilitate 
working with hierarchical data. A summary of these methods is shown 
in Figure 9. Detailed information on all of the methods is available 
in SQL Server Books Online (msdn2.microsoft.com/ms130214).



Method Description 
GetAncestor Returns a hierarchyid that represents the nth ancestor of this hierarchyid node. 
GetDescendant Returns a child node of this hierarchyid node. 
GetLevel Returns an integer that represents the depth of this hierarchyid node in the overall hierarchy. 
GetRoot Returns the root hierarchyid node of this hierarchy tree. Static. 
IsDescendant Returns true if the passed-in child node is a descendant of this hierarchyid node. 
Parse Converts a string representation of a hierarchy to a hierarchyid value. Static. 
Reparent Moves a node of a hierarchy to a new location within the hierarchy. 
ToString Returns a string that contains the logical representation of this hierarchyid. 

*/