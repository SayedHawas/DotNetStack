--================================================
--Storing & Querying XML Data in SQL Server 2016:
--================================================
/*
- XML: Extensible Markup Language (XML) is a plain-text.
- It is not tied to any programming language, operating system.
- XML is preferable to previous data formats because XML can easily represent 
  both tabular data (such as relational data from a database or spreadsheets) 
  and semi-structured data (such as a Web page or business document). 
- XML are text-based formats that provide mechanisms for describing document 
  structures using markup tags (words surrounded by ‘<’ and ‘>’).

- What is the xml Data Type?
- Used for tables, variables, or parameters
- The stored representation of xml data type instances cannot exceed 2 GB.
- This data type has several methods—query(), exist(), value(), nodes(), 
  and modify()—which implement an important set of the XML Query (XQuery) specification. 

*Use query() to return untyped XML
*Use value() to return a scalar value
*Use exist() to check for the existence of a specified value
*The modify() method supports these keywords:
  Insert adds child nodes to an XML document
  Replace value of updates node in an XML document
  Delete removes a node from the XML document
*/
-- Using XML Datatype
-- ------------------

-- Use implicit casting to assign an xml variable and column
DECLARE @itemString nvarchar(2000)
SET @itemString = '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>'

DECLARE @itemDoc xml
SET @itemDoc = @itemString
select @itemdoc

------------------------------------------------------------
-- Create a table that includes XML data
go
CREATE TABLE Stores(StoreID integer IDENTITY PRIMARY KEY,
                    StoreName nvarchar(40),
				    Manager nvarchar(40), 
					Invoices xml )

---Insert 
-----------------------------------------------------------------------------------------------------
INSERT INTO Stores
VALUES
('Astro Mountain Bike Company', 'Jeff Adell', '<InvoiceList>
                                                 <Invoice InvoiceNo="1000">
                                                   <Customer>Kim Abercrombie</Customer>
                                                   <Items>
                                                     <Item Product="1" Price="1.99" Quantity="2"/>
                                                     <Item Product="3" Price="2.49" Quantity="1"/>
                                                   </Items>
                                                  </Invoice>
                                                  <Invoice InvoiceNo="1001">
                                                    <Customer>Sean Chai</Customer> 
                                                    <Items>
                                                      <Item Product="1" Price="2.45" Quantity="2"/>
                                                    </Items>
                                                  </Invoice>
                                                </InvoiceList>')
--------------------------------------------------------------------------------------------------------
INSERT INTO Stores VALUES
('Clocktower Sporting Goods', 'Karen Berge', '<InvoiceList>
												<Invoice InvoiceNo="999">
                                                   <Customer>Sarah Akhtar</Customer>
                                                   <Items>
                                                     <Item Product="8" Price="2.99" Quantity="3"/>
                                                   </Items>
                                                </Invoice>
                                                <Invoice InvoiceNo="1000">
                                                    <Customer>Bei-Jing Guo</Customer> 
                                                    <Items>
                                                      <Item Product="1" Price="1.95" Quantity="7"/>
                                                      <Item Product="100" Price="112.99" Quantity="1"/>
                                                    </Items>
                                                </Invoice>
                                              </InvoiceList>')

INSERT INTO Stores VALUES ('HiaBuy Toys', 'Scott Cooper', NULL)
select * from Stores
----Retrieving XML by Using FOR XML
--------------------------------------------
 -- RAW mode (Retrieve Unstructured XML Data)
USE Northwind
select * from Products
go
SELECT ProductID, ProductName, unitPrice
FROM Products
go
SELECT ProductID, ProductName, unitPrice
FROM Products FOR XML RAW
go
----------------------------------------------------------------------------------
-- Structured XMl (with elements option)
 -- ELEMENTS with RAW mode
 --( An element represents each row in the result set that the query returns)
SELECT ProductID, ProductName, unitPrice
FROM Products FOR XML RAW, ELEMENTS
go
-----------------------------------------------------------------------------------
-- To specify the name for the raw 
SELECT ProductID, ProductName, unitPrice
FROM Products FOR XML RAW('Product'), ELEMENTS
-----------------------------------------------------------------------------------
-- root element
SELECT ProductID, ProductName, unitPrice
FROM Products FOR XML RAW, ROOT('Products')
-----------------------------------------------------------------------------------
SELECT ProductID, ProductName, unitPrice
FROM Products FOR XML RAW('Product'), ROOT('Products')

SELECT ProductID, ProductName, unitPrice
FROM Products  FOR XML RAW('Product'), Elements,ROOT('Products')
------------------------------------------------------------------------------------


-- Join in RAW mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML RAW


SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML RAW('Category'),Elements,Root ('Categories')

-- AUTO Mode(convert data to xml elements in a simple tree)

SELECT ProductID, Name, ListPrice
FROM Production.Product Product
FOR XML AUTO --(name the row automatic with the table name)


SELECT ProductID, Name, ListPrice
FROM Production.Product Product
FOR XML AUTO,elements 


-- Join in AUTO mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML AUTO

go
-----------------------------------
Use Northwind
Select c.customerID , C.CompanyName, o.orderID,O.orderDate
From Customers c join orders o
ON C.customerId = O.CustomerID
And C.CustomerID='Alfki'
For XML Auto , Elements 

Use Northwind
Select c.customerID , C.CompanyName, o.orderID,O.orderDate
From Customers c join orders o
ON C.customerId = O.CustomerID
And C.CustomerID='Alfki'
For XML Auto , Elements ,Root('Orders')

-- X.Query
-- -------
/*
- A subset of the XQuery language that is used for querying the xml data type. 
- This XQuery implementation is aligned in July 2004 . 
- The language is under development by the World Wide Web Consortium (W3C),
  with the participation of all major database vendors and also Microsoft.
- XQuery is based on the existing XPath query language
- The XQuery results that can be typed or untyped. 
  The type information is based on the types provided by the W3C XML Schema language.
  If no typing information is available, XQuery handles the data as untyped
*/

Declare @myDoc xml
set @myDoc = 
'<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'
--SELECT @myDoc.query('//Features')
select @myDoc.query('/Root/ProductDescription/Features')
go

DECLARE @myDoc xml
DECLARE @ProdID int
SET @myDoc = '<Root>
<ProductDescription ProductID="555" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'

SET @ProdID =  @myDoc.value('(/Root/ProductDescription/@ProductID)[1]', 'int' )
SELECT @ProdID
go
-- check value is exists
DECLARE @myDoc xml
DECLARE @ProdID int
SET @myDoc = '<Root>
<ProductDescription ProductID="555" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'

SET @ProdID =  @myDoc.exist('(/Root/ProductDescription/@ProductID)[2]' )
SELECT @ProdID
go 
------------------------------------------------
--insert
DECLARE @myDoc xml       
SET @myDoc = '<Root>       
    <ProductDescription ProductID="1" ProductName="Road Bike">       
        <Features>       
        </Features>       
    </ProductDescription>       
</Root>'       
SELECT @myDoc   
    
-- insert first feature child (no need to specify as first or as last)       
SET @myDoc.modify('       
insert <Maintenance>3 year parts and labor extended maintenance is available</Maintenance> 
into (/Root/ProductDescription/Features)[1]') 
SELECT @myDoc  

     
-- insert second feature. We want this to be the first in sequence so use 'as first'       
set @myDoc.modify('       
insert <Warranty>1 year parts and labor</Warranty>        
as first       
into (/Root/ProductDescription/Features)[1]')         
  
   
SELECT @myDoc    

-- insert third feature child. This one is the last child of <Features> so use 'as last'       
SELECT @myDoc       
SET @myDoc.modify('       
insert <Material>Aluminium</Material>        
as last       
into (/Root/ProductDescription/Features)[1]')       
      
SELECT @myDoc   
    
-- Add fourth feature - this time as a sibling (and not a child)       
-- 'after' keyword is used (instead of as first or as last child)       
SELECT @myDoc       
set @myDoc.modify('       
insert <BikeFrame>Strong long lasting</BikeFrame> 
after (/Root/ProductDescription/Features/Material)[1]')      
      
SELECT @myDoc;
GO
------------------------------------------------------------------
--delete
DECLARE @myDoc xml
SET @myDoc = '
<Root>
<Location LocationID="10" 
            LaborHours="1.1"
            MachineHours=".2" >Some text 1
<step>Manufacturing step 1 at this work center</step>
<step>Manufacturing step 2 at this work center</step>
</Location>
</Root>'
SELECT @myDoc

-- delete an attribute
SET @myDoc.modify('
  delete /Root/Location/@MachineHours')

SELECT @myDoc

-- delete an element
SET @myDoc.modify('
  delete /Root/Location/step[2]')

SELECT @myDoc

-- delete text node (in <Location>
SET @myDoc.modify('
  delete /Root/Location/text()')

SELECT @myDoc
go
----------------------------------------------------------------------------
--replace
DECLARE @myDoc xml
SET @myDoc = '<Root>
<Location LocationID="10" 
            LaborHours="1.1"
            MachineHours=".2" >Manufacturing steps are described here.
<step>Manufacturing step 1 at this work center</step>
<step>Manufacturing step 2 at this work center</step>
</Location>
</Root>'
SELECT @myDoc

-- update text in the first manufacturing step
SET @myDoc.modify('
  replace value of (/Root/Location/step[1]/text())[1]
  with     "new text describing the main step"
')
SELECT @myDoc
-- update attribute value
SET @myDoc.modify('
  replace value of (/Root/Location/@LaborHours)[1]
  with     "100.0"
')
SELECT @myDoc

-- Nested XML with TYPE
 Use Northwind
 Select customerID,
(Select orderID From dbo.orders Where orders.customerID = customers.CustomerID  For XML Auto) AS My_Orders      
 From Customers
--for xml auto

 Use Northwind
 Select customerID,
(Select orderID From dbo.orders 
 Where orders.customerID = customers.CustomerID 
 For XML Auto,type) AS My_Orders           
 From Customers
 for xml auto

-- Shredding XML by Using OPENXML
-- ------------------------------
/*
- OPENXML : keyword, provides a rowset over in-memory XML documents that is similar to 
            a table or a  view
- OPENXML allows access to XML data as it is a relational rowset. 
  by providing a rowset view of the internal representation of an XML document. 
  The records in the rowset can be stored in database tables.

- To write queries against an XML document by using OPENXML, 
  you must first call sp_xml_preparedocument ,

- This parses the XML document and returns a handle to the parsed document that is 
  ready for process.
- The parsed document is a document object model (DOM) tree representation of 
  various nodes in the XML document ,

    - This handle is valid for the duration of the session or until the  
      handle is invalidated by executing sp_xml_removedocument.

- The document handle is passed to OPENXML, OPENXML then provides a rowset view of the 
  document, based on the parameters passed to it.

- The internal representation of an XML document must be removed from memory by 
  calling the sp_xml_removedocument system stored procedure to free the memory.

- OPENXML Parameters:
- ------------------
  1- An XML document handle (idoc).
  2- An XPath expression to identify the nodes to be mapped to rows .
  3- A description of the rowset to be generated.
  4- Mapping between the rowset columns and the XML nodes .


*/

DECLARE @i int
DECLARE @doc varchar(1000)
SET @doc ='
<people>
	<person id="123">
		<fname>ahmed</fname>
		<lname>mohamed</lname>
	<address>
		<street>123 elhorya</street>
		<city>alex</city>
	</address>
	</person>
<person id="124">
<fname>heba</fname>
<lname>Ali</lname>
<address>
<street>222 elhorya</street>
<city>cairo</city>
</address>
</person>
</people>'
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @i OUTPUT, @doc
-- SELECT stmt using OPENXML rowset provider OR Select Into Stmt
SELECT * 
                      
FROM   OPENXML (@i, '/people/person/address',2)                   -- 1 : attribute ,2: element
         WITH  (ID     int '../@id'  ,           
                fname  varchar(10)'../fname' ,
                lname  varchar(10)'../lname',
                city varchar(10) ,
                street varchar(10)
                 )

Exec sp_xml_removedocument @i
go


-- OPENXML using attributes only
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 1)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))
Exec sp_xml_removedocument @docHandle

-- -- OPENXML using elements only
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 2)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))

Exec sp_xml_removedocument @docHandle



-- -- OPENXML using either attributes or elements
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 3)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))

EXEC sp_xml_removedocument @docHandle
GO

Module 17: Storing XML Data in SQL Server 2012
Module 18: Querying XML Data in SQL Server 2012
*/
--use my folder of "FullTextIndexes".
--====================================

--Storing & Querying XML Data in SQL Server 2012:
--===============================================
/*
- XML: Extensible Markup Language (XML) is a plain-text.
- It is not tied to any programming language, operating system.
- XML is preferable to previous data formats because XML can easily represent 
  both tabular data (such as relational data from a database or spreadsheets) 
  and semi-structured data (such as a Web page or business document). 
- XML are text-based formats that provide mechanisms for describing document 
  structures using markup tags (words surrounded by ‘<’ and ‘>’).

- What is the xml Data Type?
- Used for tables, variables, or parameters
- The stored representation of xml data type instances cannot exceed 2 GB.
- This data type has several methods—query(), exist(), value(), nodes(), 
  and modify()—which implement an important set of the XML Query (XQuery) specification. 

*Use query() to return untyped XML
*Use value() to return a scalar value
*Use exist() to check for the existence of a specified value
*The modify() method supports these keywords:
  Insert adds child nodes to an XML document
  Replace value of updates node in an XML document
  Delete removes a node from the XML document


  
*/
-- Using XML Datatype
-- ------------------
use  AdventureWorks2012

SELECT ProductModelID
      ,Name
      ,ModifiedDate
      ,CatalogDescription  -- Xml Datatype
      ,Instructions        -- Xml Datatype
FROM   Production.ProductModel

create database testxml
USE testxml

CREATE TABLE #Invoices(InvoiceID	int,SalesDate	datetime, CustomerID	int, ItemList	xml)

 


 go
-- Use implicit casting to assign an xml variable and column
DECLARE @itemString nvarchar(2000)
SET @itemString = '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>'

DECLARE @itemDoc xml
SET @itemDoc = @itemString

INSERT INTO #Invoices VALUES(1, GetDate(), 2, @itemDoc)
go
INSERT INTO #Invoices
VALUES(1, GetDate(), 2,
				  '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>
                   </Items>')

SELECT * FROM #Invoices

-- Well-formed document. This will succeed
INSERT INTO #Invoices
VALUES
(2, GetDate(), 2, '<Items>
                     <Item ProductID="1" Quantity="3"/>
                     <Item ProductID="3" Quantity="1"/>
                   </Items>')

SELECT * FROM #Invoices

-- Not well-formed. This will fail
INSERT INTO #Invoices
VALUES
(1, GetDate(), 2, '<Items>
                     <Item ProductID="2" Quantity="3"/>
                     <Item ProductID="4" Quantity="1"/>')

-- Create a table that includes XML data

CREATE TABLE #Stores(StoreID integer IDENTITY PRIMARY KEY,StoreName nvarchar(40), Manager nvarchar(40), Invoices xml )


 


INSERT INTO #Stores
VALUES
('Astro Mountain Bike Company', 'Jeff Adell', '<InvoiceList>
                                                 <Invoice InvoiceNo="1000">
                                                   <Customer>Kim Abercrombie</Customer>
                                                   <Items>
                                                     <Item Product="1" Price="1.99" Quantity="2"/>
                                                     <Item Product="3" Price="2.49" Quantity="1"/>
                                                   </Items>
                                                  </Invoice>
                                                  <Invoice InvoiceNo="1001">
                                                    <Customer>Sean Chai</Customer> 
                                                    <Items>
                                                      <Item Product="1" Price="2.45" Quantity="2"/>
                                                    </Items>
                                                  </Invoice>
                                                </InvoiceList>')

INSERT INTO #Stores
VALUES
('Clocktower Sporting Goods', 'Karen Berge', '<InvoiceList>
												<Invoice InvoiceNo="999">
                                                   <Customer>Sarah Akhtar</Customer>
                                                   <Items>
                                                     <Item Product="8" Price="2.99" Quantity="3"/>
                                                   </Items>
                                                </Invoice>
                                                <Invoice InvoiceNo="1000">
                                                    <Customer>Bei-Jing Guo</Customer> 
                                                    <Items>
                                                      <Item Product="1" Price="1.95" Quantity="7"/>
                                                      <Item Product="100" Price="112.99" Quantity="1"/>
                                                    </Items>
                                                </Invoice>
                                              </InvoiceList>')

INSERT INTO #Stores
VALUES
('HiaBuy Toys', 'Scott Cooper', NULL)

select * from #Stores

----Retrieving XML by Using FOR XML
--------------------------------------------
 -- RAW mode (Retrieve Unstructured XML Data)


USE AdventureWorks2012
select * from Production.Product
go
SELECT ProductID, Name, ListPrice
FROM Production.Product
go
SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW
go
-- Structured XMl (with elements option)

 -- ELEMENTS with RAW mode
 --( An element represents each row in the result set that the query returns)


SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW, ELEMENTS
go
-- To specify the name for the raw 

SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW('Product'), ELEMENTS

-- root element
SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW, ROOT('Products')

SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW('Product'), ROOT('Products')

SELECT ProductID, Name, ListPrice
FROM Production.Product
FOR XML RAW('Product'), Elements,ROOT('Products')




-- Join in RAW mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML RAW


SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML RAW('Category'),Elements,Root ('Categories')

-- AUTO Mode(convert data to xml elements in a simple tree)

SELECT ProductID, Name, ListPrice
FROM Production.Product Product
FOR XML AUTO --(name the row automatic with the table name)


SELECT ProductID, Name, ListPrice
FROM Production.Product Product
FOR XML AUTO,elements 


-- Join in AUTO mode
SELECT Category.Name CategoryName, Product.ProductID, Product.Name
FROM Production.ProductSubCategory Category
JOIN Production.Product Product
ON Product.ProductSubCategoryID = Category.ProductSubCategoryID
ORDER BY Category.Name, Product.ProductID
FOR XML AUTO

go
-----------------------------------
Use Northwind
Select c.customerID , C.CompanyName, o.orderID,O.orderDate
From Customers c join orders o
ON C.customerId = O.CustomerID
And C.CustomerID='Alfki'
For XML Auto , Elements 

Use Northwind
Select c.customerID , C.CompanyName, o.orderID,O.orderDate
From Customers c join orders o
ON C.customerId = O.CustomerID
And C.CustomerID='Alfki'
For XML Auto , Elements ,Root('Orders')

-- X.Query
-- -------
/*
- A subset of the XQuery language that is used for querying the xml data type. 
- This XQuery implementation is aligned in July 2004 . 
- The language is under development by the World Wide Web Consortium (W3C),
  with the participation of all major database vendors and also Microsoft.
- XQuery is based on the existing XPath query language
- The XQuery results that can be typed or untyped. 
  The type information is based on the types provided by the W3C XML Schema language.
  If no typing information is available, XQuery handles the data as untyped
*/

Declare @myDoc xml
set @myDoc = 
'<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'
--SELECT @myDoc.query('//Features')
select @myDoc.query('/Root/ProductDescription/Features')
go

DECLARE @myDoc xml
DECLARE @ProdID int
SET @myDoc = '<Root>
<ProductDescription ProductID="555" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'

SET @ProdID =  @myDoc.value('(/Root/ProductDescription/@ProductID)[1]', 'int' )
SELECT @ProdID
go
-- check value is exists
DECLARE @myDoc xml
DECLARE @ProdID int
SET @myDoc = '<Root>
<ProductDescription ProductID="555" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>'

SET @ProdID =  @myDoc.exist('(/Root/ProductDescription/@ProductID)[2]' )
SELECT @ProdID
go 
------------------------------------------------
--insert
DECLARE @myDoc xml       
SET @myDoc = '<Root>       
    <ProductDescription ProductID="1" ProductName="Road Bike">       
        <Features>       
        </Features>       
    </ProductDescription>       
</Root>'       
SELECT @myDoc   
    
-- insert first feature child (no need to specify as first or as last)       
SET @myDoc.modify('       
insert <Maintenance>3 year parts and labor extended maintenance is available</Maintenance> 
into (/Root/ProductDescription/Features)[1]') 
SELECT @myDoc  

     
-- insert second feature. We want this to be the first in sequence so use 'as first'       
set @myDoc.modify('       
insert <Warranty>1 year parts and labor</Warranty>        
as first       
into (/Root/ProductDescription/Features)[1]')         
  
   
SELECT @myDoc    

-- insert third feature child. This one is the last child of <Features> so use 'as last'       
SELECT @myDoc       
SET @myDoc.modify('       
insert <Material>Aluminium</Material>        
as last       
into (/Root/ProductDescription/Features)[1]')       
      
SELECT @myDoc   
    
-- Add fourth feature - this time as a sibling (and not a child)       
-- 'after' keyword is used (instead of as first or as last child)       
SELECT @myDoc       
set @myDoc.modify('       
insert <BikeFrame>Strong long lasting</BikeFrame> 
after (/Root/ProductDescription/Features/Material)[1]')      
      
SELECT @myDoc;
GO
------------------------------------------------------------------
--delete
DECLARE @myDoc xml
SET @myDoc = '
<Root>
<Location LocationID="10" 
            LaborHours="1.1"
            MachineHours=".2" >Some text 1
<step>Manufacturing step 1 at this work center</step>
<step>Manufacturing step 2 at this work center</step>
</Location>
</Root>'
SELECT @myDoc

-- delete an attribute
SET @myDoc.modify('
  delete /Root/Location/@MachineHours')

SELECT @myDoc

-- delete an element
SET @myDoc.modify('
  delete /Root/Location/step[2]')

SELECT @myDoc

-- delete text node (in <Location>
SET @myDoc.modify('
  delete /Root/Location/text()')

SELECT @myDoc
go
----------------------------------------------------------------------------
--replace
DECLARE @myDoc xml
SET @myDoc = '<Root>
<Location LocationID="10" 
            LaborHours="1.1"
            MachineHours=".2" >Manufacturing steps are described here.
<step>Manufacturing step 1 at this work center</step>
<step>Manufacturing step 2 at this work center</step>
</Location>
</Root>'
SELECT @myDoc

-- update text in the first manufacturing step
SET @myDoc.modify('
  replace value of (/Root/Location/step[1]/text())[1]
  with     "new text describing the main step"
')
SELECT @myDoc
-- update attribute value
SET @myDoc.modify('
  replace value of (/Root/Location/@LaborHours)[1]
  with     "100.0"
')
SELECT @myDoc

-- Nested XML with TYPE
 Use Northwind
 Select customerID,
(Select orderID From dbo.orders Where orders.customerID = customers.CustomerID  For XML Auto) AS My_Orders      
 From Customers
--for xml auto

 Use Northwind
 Select customerID,
(Select orderID From dbo.orders 
 Where orders.customerID = customers.CustomerID 
 For XML Auto,type) AS My_Orders           
 From Customers
 for xml auto

-- Shredding XML by Using OPENXML
-- ------------------------------
/*
- OPENXML : keyword, provides a rowset over in-memory XML documents that is similar to 
            a table or a  view
- OPENXML allows access to XML data as it is a relational rowset. 
  by providing a rowset view of the internal representation of an XML document. 
  The records in the rowset can be stored in database tables.

- To write queries against an XML document by using OPENXML, 
  you must first call sp_xml_preparedocument ,

- This parses the XML document and returns a handle to the parsed document that is 
  ready for process.
- The parsed document is a document object model (DOM) tree representation of 
  various nodes in the XML document ,

    - This handle is valid for the duration of the session or until the  
      handle is invalidated by executing sp_xml_removedocument.

- The document handle is passed to OPENXML, OPENXML then provides a rowset view of the 
  document, based on the parameters passed to it.

- The internal representation of an XML document must be removed from memory by 
  calling the sp_xml_removedocument system stored procedure to free the memory.

- OPENXML Parameters:
- ------------------
  1- An XML document handle (idoc).
  2- An XPath expression to identify the nodes to be mapped to rows .
  3- A description of the rowset to be generated.
  4- Mapping between the rowset columns and the XML nodes .


*/

DECLARE @i int
DECLARE @doc varchar(1000)
SET @doc ='
<people>
	<person id="123">
		<fname>ahmed</fname>
		<lname>mohamed</lname>
	<address>
		<street>123 elhorya</street>
		<city>alex</city>
	</address>
	</person>
<person id="124">
<fname>heba</fname>
<lname>Ali</lname>
<address>
<street>222 elhorya</street>
<city>cairo</city>
</address>
</person>
</people>'
--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @i OUTPUT, @doc
-- SELECT stmt using OPENXML rowset provider OR Select Into Stmt
SELECT * 
                      
FROM   OPENXML (@i, '/people/person/address',2)                   -- 1 : attribute ,2: element
         WITH  (ID     int '../@id'  ,           
                fname  varchar(10)'../fname' ,
                lname  varchar(10)'../lname',
                city varchar(10) ,
                street varchar(10)
                 )

Exec sp_xml_removedocument @i
go


-- OPENXML using attributes only
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 1)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))
Exec sp_xml_removedocument @docHandle

-- -- OPENXML using elements only
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 2)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))

Exec sp_xml_removedocument @docHandle



-- -- OPENXML using either attributes or elements
DECLARE @doc xml
SET @doc = '<?xml version="1.0" ?>
            <SalesInvoice InvoiceID="1000" CustomerID="123" OrderDate="2004-03-07">
              <Items>
                <Item ProductCode="12" Quantity="2" UnitPrice="12.99"><ProductName>Bike</ProductName></Item>
                <Item ProductCode="41" Quantity="1" UnitPrice="17.45"><ProductName>Helmet</ProductName></Item>
                <Item ProductCode="2" Quantity="1" UnitPrice="2.99"><ProductName>Water Bottle</ProductName></Item>
              </Items>
            </SalesInvoice>'
DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @doc
SELECT * FROM
OPENXML(@docHandle, '/SalesInvoice/Items/Item', 3)
WITH
(	ProductCode	int,
	Quantity	int,
	UnitPrice	float,
	ProductName nvarchar(20))

EXEC sp_xml_removedocument @docHandle
GO


----------------------------------------------------------------------------------------








