/*
-- Using Conversion Functions :-
--------------------------------
  - Implicit conversion occurs automatically :- Follows data type precedence rules.
  - Use explicit conversion :-
                                A) When implicit would fail or is not permitted.
                                B) To override data type precedence.
 - Conversion Functions :- 
                           A) CAST    :-  To convert a value from one data type to another . " ANSI-Standard "
						   B) CONVERT :-  To convert a value from one data type to another . " SQL SERVER ONLY "
						   C) PARSE  :-  Converts strings to date, time, number types.     " SQL SERVER ONLY "  
						   D) TRY_PARS & TRY_CONVERT :-  like PARSE and CONVERT, But when failed conversions return NULL. 
*/

-- 1) CAST Syntax 
----------------
-- CAST(<Expression> AS DataType)
---------------------------------
-- CAST Example 1)   -- from DateTime to date
SELECT orderid,orderdate AS OrderDateTime,
	   CAST(orderdate AS DATE) AS OrderDateOnly  
FROM   Orders 

-- CAST Example 2)    -- from Int to String
SELECT CAST(1 AS Varchar(1))    AS RESULT 

-- CAST Example 2)    -- from String to Decimal
SELECT CAST('20.33' AS decimal(4,2))    AS RESULT 

---------------------------------------------------
-- 2) Convert Syntax 
------------------
-- 1) Normal             CONVERT(DataType , <Expression> ), "Optional Format")
-- 2) With Format        CONVERT(DataType , <Expression> , "Optional Format Number")
--------------------------------------------------------
-- CONVERT Example 1)   -- from DateTime to date
SELECT orderid,orderdate AS OrderDateTime,CONVERT(DATE , orderdate , 110) AS OrderDateOnly  
FROM Orders 

-- CONVERT Example 2)    -- from Int to String
SELECT CONVERT(Varchar(1) , 1)  AS RESULT 

-- CONVERT Example 2)    -- from String to Decimal
SELECT CONVERT(Decimal(4,2) , '20.33' )   AS RESULT 
------------------------------------------------------------
-- 3) Parse Syntax 
-----------------
-- 1) Normal          PARS (<String> AS DataType)
-- 2) With Culture    PARS (<String> AS DataType USING 'Culture Name') 
-----------------------------------------------------
-- Parse Example Normal
SELECT PARSE('02/12/2012' AS datetime2) AS Result

-- Parse Example Using Culture
SELECT PARSE('02/12/2012' AS datetime2 USING 'ar-EG') AS Result
-------------------------------------------------------------------------
/*
-- Why Try_Parse & Try_Convert ? 
---------------------------------
   - Some Conversion Never works 
   - If the data types are incompatible, 
   - such as attempting to convert a date to a numeric value,
   - (CAST,CONVERT,Parse)  will return an error.
   - So Try_Parse & Try_Convert Will Act Like (CONVERT,Parse) ,
   - AND When Conversion Failed Return NULL instead of Error.
   - Try_Parse Syntax = Parse Syntax
   - Try_Convert Syntax = Convert Syntax
*/
-- Conversion Failed with error like :-
-- CAST Error
SELECT CAST ( '12/12/2012' AS INT )

-- CONVERT Error
SELECT CONVERT ( INT , '12/12/2012' )
-- Parse Error
SELECT Parse ( '12/12/2012' AS INT )
-- USING Try_Parse    -- No Error
SELECT Try_Parse ( '02/30/2012' AS datetime ) AS Result

SELECT Try_Parse ( '02/28/2012' AS datetime ) AS Result
-- USING Try_Convert  -- No Error
SELECT Try_Convert ( datetime , '02/30/2012' ) AS Result
SELECT Try_Convert ( datetime , '12/12/2012' ) AS Result
-------------------------------------------------------------------------------------------------------
