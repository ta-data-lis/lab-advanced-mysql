
/* 
Challenge 1 - Most Profiting Authors

Step 1:
*/


CREATE TEMPORARY TABLE title_sales_royaltys
SELECT titles.title_id, titles.title, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_per_Sale
FROM titles 
JOIN sales
ON titles.title_id = sales.title_id
JOIN titleauthor
ON sales.title_id = titleauthor.title_id
GROUP BY titles.title;

CREATE TEMPORARY TABLE author_royalty
SELECT ti.title_id, ti.au_id, tsr.Royalty_per_Sale
FROM title_info ti
JOIN title_sales_royaltys tsr
ON ti.title_id = tsr.title_id

/* Step 2: */

CREATE TEMPORARY TABLE title_info
SELECT aut.au_id, aut.au_lname, aut.au_fname, tta.title_id
FROM authors aut
LEFT JOIN titleauthor tta
ON aut.au_id = tta.au_id;

CREATE TEMPORARY TABLE total_royaltys
SELECT title_id, au_id, SUM(Royalty_per_Sale) AS TOTAL
FROM author_royalty
GROUP BY au_id, title_id
ORDER BY TOTAL DESC;

SELECT * FROM authors;
SELECT * FROM titles;
SELECT * FROM sales;
SELECT * FROM publishers;
SELECT * FROM titleauthor;
SELECT * FROM roysched;
SELECT * FROM pub_info;

/* Step 3: */

SELECT tr.au_id, (tr.total * s.qty) AS Profits
FROM total_royaltys tr
JOIN sales s
ON tr.title_id = s.title_id
ORDER BY Profits DESC
LIMIT 3;

/* Challenge 2 */

SELECT tr.au_id, (tr.total * s.qty) AS Profits
FROM (
SELECT ar.title_id, ar.au_id, SUM(ar.Royalty_per_Sale) AS TOTAL
FROM (
SELECT ti.title_id, ti.au_id, tsr.Royalty_per_Sale
FROM (
SELECT aut.au_id, aut.au_lname, aut.au_fname, tta.title_id
FROM authors aut
LEFT JOIN titleauthor tta
ON aut.au_id = tta.au_id) ti
JOIN(
SELECT titles.title_id, titles.title, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_per_Sale
FROM titles 
JOIN sales
ON titles.title_id = sales.title_id
JOIN titleauthor
ON sales.title_id = titleauthor.title_id
GROUP BY titles.title) tsr
ON ti.title_id = tsr.title_id) ar
GROUP BY ar.au_id, ar.title_id
ORDER BY TOTAL DESC) tr
JOIN sales s
ON tr.title_id = s.title_id
ORDER BY Profits DESC
LIMIT 3;

/* Challenge 3 */

CREATE VIEW view_most_profiting_au AS 
SELECT tr.au_id, (tr.total * s.qty) AS Profits
FROM (
SELECT ar.title_id, ar.au_id, SUM(ar.Royalty_per_Sale) AS TOTAL
FROM (
SELECT ti.title_id, ti.au_id, tsr.Royalty_per_Sale
FROM (
SELECT aut.au_id, aut.au_lname, aut.au_fname, tta.title_id
FROM authors aut
LEFT JOIN titleauthor tta
ON aut.au_id = tta.au_id) ti
JOIN(
SELECT titles.title_id, titles.title, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_per_Sale
FROM titles 
JOIN sales
ON titles.title_id = sales.title_id
JOIN titleauthor
ON sales.title_id = titleauthor.title_id
GROUP BY titles.title) tsr
ON ti.title_id = tsr.title_id) ar
GROUP BY ar.au_id, ar.title_id
ORDER BY TOTAL DESC) tr
JOIN sales s
ON tr.title_id = s.title_id
ORDER BY Profits DESC
LIMIT 3;


