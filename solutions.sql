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
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

DROP TABLE sum_royalties;

/* Step 2 */
CREATE TEMPORARY TABLE sum_royalties
SELECT r.`AUTHOR ID` AS "AUTHOR ID",
r.`TITLE ID` AS "TITLE ID",
SUM(r.`ROYALTIES`) AS "ROYALTIES PER TITLE"
FROM royalties as r
GROUP BY r.`AUTHOR ID`, r.`TITLE ID`;

DROP TABLE sum_royalties_advance;

/* Step 3 */
CREATE TEMPORARY TABLE sum_royalties_advance
SELECT sr.`AUTHOR ID`,
SUM(sr.`ROYALTIES PER TITLE`) + SUM(t.advance) AS "TOTAL PROFITS"
FROM sum_royalties AS sr
INNER JOIN titles AS t
ON sr.`TITLE ID` = t.title_id
GROUP BY sr.`AUTHOR ID`
ORDER BY `TOTAL PROFITS` DESC;
/*LIMIT 3;*/


/* Challenge 2 - Alternative Solution */
/*. Sub queries */

/* Step 1 */
SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

/* Step 2 */
SELECT `AUTHOR ID`, /*`TITLE ID`,*/ 
SUM(`ROYALTIES`),
SUM(`ADVANCE`) /* AS "TOTAL PROFITS",*/
FROM (SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
t.advance. AS "ADVANCE",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id) summary
GROUP BY `AUTHOR ID`;

/* Step 3 */
SELECT `AUTHOR ID`,
`TITLE ID`,
SUM(`ROYALTIES`) + SUM(`ADVANCE`) AS "TOTAL PROFITS",
FROM (SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
t.advance. AS "ADVANCE",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id) summary2
GROUP BY `AUTHOR ID`
ORDER BY `TOTAL PROFITS` DESC
LIMIT 3;


/* Gonçalo Nobre's solution - work in progress */

/* Step 1 */
SELECT titles.advance AS 'adv money', titles.title_id AS 'Title ID', authors.au_id AS 'Authors ID', (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS 'Royalties'
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN authors
ON authors.au_id = titleauthor.au_id;

/* Step 2 */
SELECT `Title ID`, `Authors ID`, `Royalties`, `adv money`
FROM
( SELECT SUM(titles.advance) AS 'adv money',
titles.title_id AS 'Title ID',
authors.au_id AS 'Authors ID',
SUM((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) AS 'Royalties'
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN authors
ON authors.au_id = titleauthor.au_id) summary
GROUP BY `Title ID`, `Authors ID`;

/* Step 3 */
SELECT `Title ID`, `Authors ID`, `Royalties`, `adv money`, (`Royalties` - `adv money`) AS Profit
FROM
( SELECT SUM(titles.advance) AS 'adv money',
titles.title_id AS 'Title ID',
authors.au_id AS 'Authors ID',
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS 'Royalties'
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN authors
ON authors.au_id = titleauthor.au_id) summary
GROUP BY `Title ID`, `Authors ID`
ORDER BY Profit
LIMIT 3;

/* Rafael Mello */

SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

SELECT `AUTHOR ID`,`TITLE ID`,
SUM(`ROYALTIES`)
FROM
(SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id) sumary
Group by `TITLE ID`, `AUTHOR ID`;

SELECT `AUTHOR ID`,
SUM(`ROYALTIES`) + SUM(`ADVANCE`)
FROM
(SELECT au.au_id AS "AUTHOR ID",
t.advance AS "ADVANCE",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id) sumary_royal
Group by  `AUTHOR ID`;

/* Challenge 3 */
/* Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to 
hold the data about the most profiting authors. The table should have 2 columns:

    au_id - Author ID
    profits - The profits of the author aggregating the advances and royalties

Include your solution in solutions.sql. */

CREATE TABLE most_profiting_authors
AS (SELECT *
FROM sum_royalties_advance);
/* WHERE "TOTAL PROFITS" > 300.000); */

SELECT * FROM most_profiting_authors;




