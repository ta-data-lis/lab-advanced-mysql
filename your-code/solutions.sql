
## Challenge 1 - Most Profiting Authors

#STEP 1 - Royalty of each sale for each author
SELECT authors.au_id AS "AUTHOR ID", authors.au_lname AS "AUTHOR SURNAME", authors.au_fname AS "AUTHOR NAME",
titles.title_id AS "TITLE ID", titles.title AS "TITLE", sales.ord_num AS "SALES ID", 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS "SALES ROYALTY",
titles.advance AS "ADVANCES"
FROM titleauthor
JOIN authors ON titleauthor.au_id = authors.au_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id;

#STEP 2 - Aggregate the total royalties for each title for each author
SELECT authors.au_id AS "AUTHOR ID", authors.au_lname AS "AUTHOR SURNAME", authors.au_fname AS "AUTHOR NAME",
titles.title_id AS "TITLE ID", titles.title AS "TITLE", 
SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS "SALES ROYALTY",
titles.advance AS "ADVANCES"
FROM titleauthor
JOIN authors ON titleauthor.au_id = authors.au_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
GROUP BY authors.au_id, titles.title_id;

#STEP 3 - Calculate the total profits of each author

SELECT authors.au_id AS "AUTHOR ID", authors.au_lname AS "AUTHOR SURNAME", authors.au_fname AS "AUTHOR NAME",
(SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) AS "TOTAL_PROFIT"
FROM titleauthor
JOIN authors ON titleauthor.au_id = authors.au_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
GROUP BY authors.au_id, titles.title_id
ORDER BY TOTAL_PROFIT DESC
LIMIT 3;


## Challenge 2 - Alternative Solution
DROP TEMPORARY TABLE mp_au;

#STEP 1 - Most Profiting Authors
CREATE TEMPORARY TABLE mp_au
SELECT authors.au_id, titles.title_id,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS "SALES_ROYALTY"
	FROM titleauthor
	LEFT JOIN authors ON titleauthor.au_id = authors.au_id
	LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN sales ON titles.title_id = sales.title_id;

#STEP 2 - Aggregate the total royalties for each title for each author
DROP TEMPORARY TABLE agg_sales;

CREATE TEMPORARY TABLE agg_sales
SELECT au_id, title_id, SUM(SALES_ROYALTY) AS au_tot_royalties
	FROM mp_au
	GROUP BY au_id, title_id;

SELECT * FROM agg_sales;


#STEP 3 - Calculate the total profits of each author
SELECT agg_sales.au_id, SUM(agg_sales.au_tot_royalties+ titles.advance) AS tot_profit
	FROM agg_sales
	LEFT JOIN titles on agg_sales.title_id = titles.title_id
	GROUP BY agg_sales.au_id
	ORDER BY tot_profit DESC
	LIMIT 3;


# Challenge 3

#Create table
CREATE TABLE most_profiting_authors(
	ID INT AUTO_INCREMENT,
    au_id VARCHAR(25),
    tot_profit FLOAT,
    PRIMARY KEY (ID)
    );

#Populate using temp table
INSERT INTO most_profiting_authors (au_id, tot_profit)
	SELECT agg_sales.au_id, SUM(agg_sales.au_tot_royalties+ titles.advance) AS tot_profit
	FROM agg_sales
	LEFT JOIN titles on agg_sales.title_id = titles.title_id
	GROUP BY agg_sales.au_id
    ORDER BY tot_profit DESC;
    
#SELECT * FROM most_profiting_authors