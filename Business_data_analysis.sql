

--  List all employees
SELECT * FROM jbemployee;

-- List the name of all departments in alphabetical order. Note: by “name”
SELECT name
FROM jbdept
ORDER BY name ASC;

-- What parts are not in store? Note that such parts have the value 0 (zero)
-- for the qoh attribute (qoh = quantity on hand).
SELECT name,qoh
FROM jbparts
WHERE qoh=0;

-- List all employees who have a salary between 9000 (included) and
SELECT id,name,salary
FROM jbemployee
WHERE salary BETWEEN 9000 AND 10000 ;

--  List all employees together with the age they had when they started
-- working? 

SELECT id,name, startyear,birthyear , startyear - birthyear as "job started age" 
FROM jbemployee;

--  List all employees who have a last name ending with “son”. 
SELECT *
FROM jbemployee
WHERE SUBSTRING_INDEX(name,',', 1) LIKE '%son';

-- Which items (note items, not parts) have been delivered by a supplier

SELECT *
FROM jbitem
WHERE supplier= (SELECT id FROM jbsupplier WHERE name = 'Fisher-Price');

SELECT *
FROM jbitem 
JOIN jbsupplier ON jbitem.supplier=jbsupplier.id
WHERE jbsupplier.name= "Fisher-Price";

--  List all cities that have suppliers located in them. 

SELECT DISTINCT jbcity.name
FROM jbcity
WHERE jbcity.id IN (SELECT DISTINCT jbsupplier.city FROM jbsupplier);

-- The name and the color of the parts that are heavier than a card reader

SELECT name, color , weight
FROM jbparts 
WHERE weight > (SELECT weight FROM jbparts WHERE name = 'card reader');


SELECT second.name, second.color , second.weight
FROM jbparts first, jbparts second
WHERE first.name="card reader" AND second.weight>first.weight; 

-- the average weight of all black parts
SELECT AVG(weight)
FROM jbparts
WHERE color = 'black';

-- For every supplier in Massachusetts (“Mass”), retrieve the name and the
-- total weight of all parts that the supplier has delivered

SELECT jbsupplier.name, SUM(jbparts.weight * jbsupply.quan) AS "total weight"
FROM jbparts
JOIN jbsupply ON jbparts.id = jbsupply.part
JOIN jbsupplier ON jbsupplier.id = jbsupply.supplier
JOIN jbcity ON jbcity.id = jbsupplier.city
WHERE jbcity.state = 'Mass'
GROUP BY jbsupplier.name;

-- a new relation with the same attributes as the jbitems relation 

CREATE TABLE jbNEW (
    id int NOT NULL,
    name varchar(255),
    dept int,
    price int,
    qoh int,
    supplier int,
    PRIMARY KEY (ID)
);
INSERT INTO jbNEW  (id, name, dept, price, qoh,supplier)
SELECT id, name, dept, price, qoh,supplier
FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem);


SELECT * FROM jbNEW;


--  a view that contains the items that cost less than the average 
-- price for items.
CREATE VIEW view_less_than_ave_price AS
SELECT *
FROM jbitem
WHERE price < (SELECT AVG(price) FROM jbitem);




--  a view that calculates the total cost of each debit, by considering 
-- price and quantity of each bought item. 

CREATE VIEW view_debit_total_cost AS
SELECT
    jbsale.debit AS debit,
    SUM(jbitem.price * jbsale.quantity) AS total_cost
FROM
    jbsale, jbitem
WHERE
    jbsale.item = jbitem.id
GROUP BY
    jbsale.debit;
    
  
    
   CREATE VIEW view_debit_total_cost2 AS
   SELECT
    jbsale.debit AS debit,
    SUM(jbitem.price * jbsale.quantity) AS total_cost
   FROM jbsale INNER JOIN jbitem ON jbsale.item = jbitem.id
   GROUP BY
		jbsale.debit;
    
    
    
    
    

-- Remove all suppliers in Los Angeles from the jbsupplier table. 
DELETE FROM jbsupplier
WHERE jbsupplier.city in (select jbcity.id from jbcity where jbcity.name = "Los Angeles" );



DELETE FROM jbitem
WHERE jbitem.supplier IN (SELECT jbsupplier.id FROM jbsupplier
                          WHERE jbsupplier.city IN (SELECT jbcity.id FROM jbcity WHERE jbcity.name = "Los Angeles"));


DELETE FROM jbsale
WHERE jbsale.item IN (SELECT jbitem.id FROM jbitem
                      WHERE jbitem.supplier IN (SELECT jbsupplier.id FROM jbsupplier
                                                WHERE jbsupplier.city IN (SELECT jbcity.id FROM jbcity WHERE jbcity.name = "Los Angeles")));
    

    
    
--  find out which suppliers have delivered items
-- that have been sold. 

    CREATE VIEW jbsale_supply(supplier, item, quantity) AS
    SELECT jbsupplier.name, jbitem.name, jbsale.quantity
    FROM jbsupplier, jbitem, jbsale
    WHERE jbsupplier.id = jbitem.supplier
    AND jbsale.item = jbitem.id;
    
SELECT supplier, sum(quantity) AS sum FROM jbsale_supply
­GROUP BY supplier;

DROP VIEW jbsale_supply;
    
CREATE VIEW jbsale_supply(supplier, item, quantity) as
SELECT jbsupplier.name, jbitem.name, jbsale.quantity
FROM jbsupplier JOIN jbitem ON jbsupplier.id = jbitem.supplier
				LEFT JOIN jbsale ON jbsale.item = jbitem.id;
    
SELECT supplier, sum(quantity) AS sum FROM jbsale_supply
­GROUP BY supplier;
    





    
    
    
