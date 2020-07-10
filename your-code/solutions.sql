/* Challenge 1 - Most Profiting Authors */

/*
sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
*/

/*
SELECT name,
 price*quantity  AS total_price
FROM purchase;
*/

SELECT * FROM titles;
SELECT * FROM authors;
SELECT * FROM titleauthor;
SELECT * FROM sales;

/* Solution with temporary tables */

/* Step 1 */
CREATE TEMPORARY TABLE royalties
SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES PER SALE",
(t.advance / 100 * ta.royaltyper / 100) AS "ADVANCE"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

SELECT * FROM royalties;

/* DROP TABLE royalties;  */ /*Use as needed,cannot reacreate a temp table without dropping it first */

/* Step 2 */
CREATE TEMPORARY TABLE sum_royalties
SELECT r.`AUTHOR ID` AS "AUTHOR ID",
r.`TITLE ID` AS "TITLE ID",
SUM(r.`ROYALTIES PER SALE`) AS "ROYALTIES PER TITLE",
r.`ADVANCE` AS "ADVANCE"
FROM royalties as r
GROUP BY r.`AUTHOR ID`, r.`TITLE ID`, r.`ADVANCE`;

SELECT * FROM sum_royalties;

/* DROP TABLE sum_royalties; */

/* Step 3 */
CREATE TEMPORARY TABLE sum_royalties_advance
SELECT sr.`AUTHOR ID`,
(SUM(sr.`ROYALTIES PER TITLE`) + SUM(sr.`ADVANCE`)) AS "TOTAL PROFITS"
FROM sum_royalties AS sr
GROUP BY sr.`AUTHOR ID`
ORDER BY `TOTAL PROFITS` DESC
LIMIT 3;

SELECT * FROM sum_royalties_advance;

/* DROP TABLE sum_royalties_advance; */

/* Challenge 2 - Alternative Solution */
/*. Sub queries */
SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES PER SALE",
(t.advance / 100 * ta.royaltyper / 100) AS "ADVANCE"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON ta.au_id = au.au_id;


/* Step 2 */
SELECT `AUTHOR ID`,
`TITLE ID`,
SUM(`ROYALTIES PER SALE`),
`ADVANCE`
FROM (SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES PER SALE",
(t.advance / 100 * ta.royaltyper / 100) AS "ADVANCE"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON ta.au_id = au.au_id) summary
GROUP BY `AUTHOR ID`, `TITLE ID`, `ADVANCE`;


/* Step 3 */
SELECT `AUTHOR ID`,
SUM(`ROYALTIES PER SALE`) + SUM(`ADVANCE`) AS "TOTAL PROFITS"
FROM (SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES PER SALE",
(t.advance / 100 * ta.royaltyper / 100) AS "ADVANCE"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON ta.au_id = au.au_id) summary
GROUP BY `AUTHOR ID`
ORDER BY `TOTAL PROFITS` DESC
LIMIT 3;


/* Challenge 3 */
/* Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to 
hold the data about the most profiting authors. The table should have 2 columns:

    au_id - Author ID
    profits - The profits of the author aggregating the advances and royalties

Include your solution in solutions.sql. */

CREATE TABLE most_profiting_authors
AS (SELECT * FROM sum_royalties_advance);

SELECT * FROM most_profiting_authors;

CREATE TABLE most_profiting_authors
SELECT `AUTHOR ID`,
SUM(`ROYALTIES PER SALE`) + SUM(`ADVANCE`) AS "TOTAL PROFITS"
FROM (SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES PER SALE",
(t.advance / 100 * ta.royaltyper / 100) AS "ADVANCE"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON ta.au_id = au.au_id) summary
GROUP BY `AUTHOR ID`
ORDER BY `TOTAL PROFITS` DESC
LIMIT 3;





