/* challenge1: the following code outputs the requested table, in total there are 25 rows which is equal to the total of rows in title_authore */

SELECT a.au_id as "AUTHOR ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", t.title as "TITLES", p.pub_name as "PUBLISHER"
FROM publications.authors as a
INNER JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
INNER JOIN publications.titles as t
ON t.title_id = ta.title_id
INNER JOIN publications.publishers as p
ON p.pub_id = t.pub_id;


/*challenge 2: Who Have Published How Many At Where?*/

SELECT a.au_id as "AUTHOR ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", p.pub_name as "PUBLISHER",count(*) as "TITLE COUNT"
FROM publications.authors as a
INNER JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
INNER JOIN publications.titles as t
ON t.title_id = ta.title_id
INNER JOIN publications.publishers as p
ON p.pub_id = t.pub_id
GROUP BY a.au_id, p.pub_name, a.au_lname, a.au_fname;


/* Challenge 3 - Best Selling Authors */
SELECT a.au_id as "AUTHOR ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", sum(s.qty) as "TOTAL SALES"
FROM publications.authors as a
INNER JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
INNER JOIN publications.sales as s
ON s.title_id = ta.title_id
GROUP BY a.au_id, a.au_lname, a.au_fname
ORDER BY "TOTAL SALES" DESC
LIMIT 3;


/* Challenge 4 - Best Selling Authors Ranking */

SELECT a.au_id as "AUTHOR ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", coalesce(sum(s.qty),0) as "TOTAL SALES"
FROM publications.authors as a
LEFT JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
LEFT JOIN publications.sales as s
ON s.title_id = ta.title_id
GROUP BY a.au_id, a.au_lname, a.au_fname;



/* Challenge 1 - Most Profiting Authors */
/* Calculate the royalty of each sale for each author */
/* sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 */
CREATE temporary TABLE Sales_Royalty
SELECT ta.au_id as "AUTHOR ID", ta.title_id as "TITLE ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", t.price as "PRICE OF TITLE", t.royalty as "TITLE ROYALTY", s.qty as "QTY OF SALES",ta.royaltyper as "ROYALTY PER", r.royalty as "Royalty for each sale", t.price*s.qty*t.royalty/100*ta.royaltyper/100 as "SALES ROYALTY"
FROM publications.authors as a
LEFT JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
LEFT JOIN publications.roysched as r
ON r.title_id = ta.title_id
LEFT JOIN publications.sales as s
ON s.title_id = ta.title_id
LEFT JOIN publications.titles as t
ON t.title_id=ta.title_id;

SELECT *
FROM Sales_Royalty;

DROP TABLE Sales_Royalty;

/* Step 2: Aggregate the total royalties for each title for each author */
SELECT `TITLE ID`,`AUTHOR ID`
FROM Sales_Royalty;


CREATE TEMPORARY TABLE mid_step
SELECT `TITLE ID`,`AUTHOR ID`,`FIRST NAME`,`LAST NAME`, sum(`SALES ROYALTY`) as `SUM OF SALES ROYALTY`
FROM (SELECT ta.au_id as "AUTHOR ID", ta.title_id as "TITLE ID",a.au_lname as "LAST NAME", a.au_fname as "FIRST NAME", t.price as "PRICE OF TITLE", t.royalty as "TITLE ROYALTY", s.qty as "QTY OF SALES",ta.royaltyper as "ROYALTY PER", r.royalty as "Royalty for each sale", t.price*s.qty*t.royalty/100*ta.royaltyper/100 as "SALES ROYALTY"
FROM publications.authors as a
LEFT JOIN publications.titleauthor as ta
ON ta.au_id=a.au_id
LEFT JOIN publications.roysched as r
ON r.title_id = ta.title_id
LEFT JOIN publications.sales as s
ON s.title_id = ta.title_id
LEFT JOIN publications.titles as t
ON t.title_id=ta.title_id) summary
GROUP BY `TITLE ID`,`AUTHOR ID`,`FIRST NAME`,`LAST NAME`;

DROP TABLE mid_step;

/* Step 3: Calculate the total profits of each author */
CREATE TEMPORARY TABLE next_file
SELECT `AUTHOR ID`, sum(`SUM OF SALES ROYALTY`) AS "TOTAL PROFIT"
FROM mid_step
GROUP BY `AUTHOR ID`;

/* Challenge 2 - Alternative Solution */
/* my answer above is a mix of both temporary tables and subqueries */


/* Challenge 3 */
/* create a permanent table named most_profiting_authors to hold the data about the most profiting authors */


CREATE TABLE most_profiting_authors
AS (SELECT * 
FROM next_file
WHERE `TOTAL PROFIT`>300.000);


SELECT * FROM most_profiting_authors;
 


