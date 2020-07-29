/*Challenge 1 - Most Profiting Authors*/

/*Step 1: Calculate the royalties of each sales for each author*/
SELECT t.title_id, t.price,  t.royalty, s.qty, a.au_id, (t.price * s.qty * t.royalty * ta.royaltyper / 10000) as ROYALTIES
FROM titles t

INNER JOIN sales s ON s.title_id = t.title_id
INNER JOIN titleauthor ta ON ta.title_id = s.title_id
INNER JOIN authors a ON a.au_id = ta.au_id
ORDER BY t.title_id, a.au_id;

/*Step 2: Aggregate the total royalties for each title for each author*/

SELECT title_id, au_id, advance, sum(ROYALTIES) AS ROYALTIES FROM 

(
	SELECT t.title_id, t.price, t.advance, t.royalty, s.qty, a.au_id,  (t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS ROYALTIES
	FROM titles t
	INNER JOIN sales s ON s.title_id = t.title_id
	INNER JOIN titleauthor ta ON ta.title_id = s.title_id
	INNER JOIN authors a ON a.au_id = ta.au_id
) AS tmp

GROUP BY au_id, title_id
ORDER BY ROYALTIES DESC;

/*Step 3: Calculate the total profits of each author*/
SELECT au_id AS "AUTHOR ID", sum(advance + ROYALTIES) AS PROFITS FROM 

(
	SELECT title_id, au_id, advance, sum(ROYALTIES) AS ROYALTIES FROM (
		SELECT t.title_id, t.price, t.advance, t.royalty, s.qty, a.au_id,  ta.royaltyper, (t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS ROYALTIES
		FROM titles t
		INNER JOIN sales s ON s.title_id = t.title_id
		INNER JOIN titleauthor ta ON ta.title_id = s.title_id
		INNER JOIN authors a ON a.au_id = ta.au_id
	) AS tmp
	GROUP BY au_id, title_id
) AS tmp2

GROUP BY au_id
ORDER BY PROFITS DESC
limit 3;

/*Challenge 2 - Alternative Solution */

DROP Temporary TABLE IF EXISTS tmp1;

CREATE TEMPORARY TABLE tmp1
SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty * ta.royaltyper / 10000) AS sale_royalty
FROM titles t
INNER JOIN sales s ON s.title_id = t.title_id
INNER JOIN titleauthor ta ON ta.title_id = s.title_id
INNER JOIN authors a ON a.au_id = ta.au_id
ORDER BY t.title_id, a.au_id;

DROP TEMPORARY TABLE IF EXISTS tmp2;

CREATE TEMPORARY TABLE tmp2
SELECT title_id, au_id, sum(sale_royalty) AS ROYALTIES
FROM tmp1
GROUP BY title_id, au_id;

SELECT tmp2.au_id AS "AUTHOR ID", sum(t.advance + ROYALTIES) AS PROFITS 
FROM tmp2
INNER JOIN titles t ON t.title_id = tmp2.title_id
INNER JOIN authors a ON a.au_id = tmp2.au_id
GROUP BY tmp2.au_id
ORDER BY PROFITS DESC
LIMIT 3;

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

/* Challenge 3 */

SELECT * FROM most_profiting_authors;

SELECT authors.au_id, sales_values FROM titles, authors, (SELECT titles.title_id, authors.au_id ,sum(sales_royalty) AS sales_values FROM titles, authors, 
(SELECT titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titles, sales, titleauthor
GROUP By au_id) AS total_sales
GROUP BY titles.title_id)  AS money
GROUP BY authors.au_id
ORDER BY sales_values DESC;





