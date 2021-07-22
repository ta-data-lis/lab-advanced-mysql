/* CHALLENGE 1 */
/* Step 1 */
SELECT ta.title_id AS "TITLE ID", a.au_id AS "AUTHOR ID", ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100,2) as sales_royalty, t.advance as ADVANCE
FROM authors as a
INNER JOIN titleauthor as ta ON a.au_id = ta.au_id
INNER JOIN titles as t on t.title_id = ta.title_id
INNER JOIN sales as s on s.title_id = t.title_id
;

/* Step 2 */
SELECT r_per_title.TITLE_ID AS TITLE_ID, r_per_title.AUTHOR_ID AS AUTHOR_ID, sum(r_per_title.sales_royalty) as total_royalties, r_per_title.advance as ADVANCE
FROM
	(SELECT ta.title_id AS TITLE_ID, a.au_id AS AUTHOR_ID, ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100,2) as sales_royalty, t.advance as ADVANCE
FROM authors as a
INNER JOIN titleauthor as ta ON a.au_id = ta.au_id
INNER JOIN titles as t on t.title_id = ta.title_id
INNER JOIN sales as s on s.title_id = t.title_id
) r_per_title

GROUP BY r_per_title.AUTHOR_ID, r_per_title.TITLE_ID
ORDER BY `total_royalties` DESC
;



/* Step 3 */
SELECT r_per_author_title.AUTHOR_ID, 
SUM(r_per_author_title.total_royalties) as TOTAL_ROYALTIES, 
round(sum(r_per_author_title.advance),2) as SUM_ADVANCE,  
round(sum(r_per_author_title.TOTAL_ROYALTIES + r_per_author_title.ADVANCE),2) AS 'TOTAL PROFIT'
FROM (SELECT r_per_title.TITLE_ID AS TITLE_ID, r_per_title.AUTHOR_ID AS AUTHOR_ID, sum(r_per_title.sales_royalty) as total_royalties, r_per_title.advance as ADVANCE
FROM
	(SELECT ta.title_id AS TITLE_ID, a.au_id AS AUTHOR_ID, ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100,2) as sales_royalty, t.advance as ADVANCE
FROM authors as a
INNER JOIN titleauthor as ta ON a.au_id = ta.au_id
INNER JOIN titles as t on t.title_id = ta.title_id
INNER JOIN sales as s on s.title_id = t.title_id
) r_per_title

GROUP BY r_per_title.AUTHOR_ID, r_per_title.TITLE_ID
ORDER BY `total_royalties` DESC
) r_per_author_title
GROUP BY r_per_author_title.AUTHOR_ID
ORDER BY 'TOTAL PROFIT' DESC
;

/* CHALLENGE 2 */
/* Step 1 */

CREATE TEMPORARY TABLE sales_t_a
(TITLE_ID VARCHAR(10),
AUTHOR_ID VARCHAR(20),
sales_royalty FLOAT,
advances INT)

/*DROP TABLE sales_t_a*/

INSERT INTO sales_t_a (TITLE_ID, AUTHOR_ID, sales_royalty,advances)
SELECT ta.title_id AS "TITLE ID", a.au_id AS "AUTHOR ID", ROUND(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100,2) as sales_royalty, t.advance as ADVANCE
FROM authors as a
INNER JOIN titleauthor as ta ON a.au_id = ta.au_id
INNER JOIN titles as t on t.title_id = ta.title_id
INNER JOIN sales as s on s.title_id = t.title_id
;

/* Step 2 */
CREATE TEMPORARY TABLE sales_a
(TITLE_ID VARCHAR(10),
AUTHOR_ID VARCHAR(20),
sales_royalty FLOAT,
advances INT)

/*DROP TABLE sales_a*/

INSERT INTO sales_a (TITLE_ID, AUTHOR_ID, sales_royalty,advances)
SELECT sales_t_a.TITLE_ID, sales_t_a.AUTHOR_ID, sum(sales_t_a.sales_royalty), sales_t_a.advances
FROM sales_t_a
GROUP BY sales_t_a.AUTHOR_ID, sales_t_a.TITLE_ID


/* Step 3 */
CREATE TEMPORARY TABLE total_royalties
(AUTHOR_ID VARCHAR(20),
sales_royalty FLOAT,
advances INT,
total_royalties FLOAT);

/*DROP TABLE total_royalties*/

INSERT INTO total_royalties (AUTHOR_ID, sales_royalty,advances,total_royalties)
SELECT
sales_a.AUTHOR_ID,
sum(sales_a.sales_royalty) as TOTAL_ROYALTIES,
sum(sales_a.advances) as ADVANCES,
round((sum(sales_a.advances) + sum(sales_a.sales_royalty)),2) as TOTAL_R
FROM sales_a
GROUP BY sales_a.AUTHOR_ID
;

/* Challenge 3 */
CREATE TABLE most_profiting_authors
(AUTHOR_ID VARCHAR(20),
profits FLOAT)

INSERT INTO most_profiting_authors (AUTHOR_ID, profits)
SELECT t.AUTHOR_ID, t.TOTAL_ROYALTIES
FROM total_royalties as t
ORDER BY t.TOTAL_ROYALTIES DESC
LIMIT 3




