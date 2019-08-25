#CHALLENGE 1 - Most Profiting Authors
#STEP 1 - Calculate the royalties of each sales for each author
CREATE TEMPORARY TABLE Sales_Royalties
SELECT titles.title_id AS TITLE_ID, titleauthor.au_id AS AUTHOR_ID,
(titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
ORDER BY (titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) DESC
;

#drop table Sales_Royalties;
SELECT * FROM Sales_Royalties;

#STEP 2 - Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE royalties_aggregated
SELECT Sales_Royalties.TITLE_ID, Sales_Royalties.AUTHOR_ID, SUM(Sales_Royalties.Sales_Royalty) AS Sales_Royalty
FROM Sales_Royalties
GROUP BY Sales_Royalties.TITLE_ID, Sales_Royalties.AUTHOR_ID
ORDER BY SUM(Sales_Royalties.Sales_Royalty) DESC
;

#drop table royalties_aggregated;
SELECT * FROM royalties_aggregated;

#STEP 3 - Calculate the total profits of each author
SELECT royalties_aggregated.AUTHOR_ID AS 'AUTHOR ID', SUM(royalties_aggregated.Sales_Royalty)
FROM royalties_aggregated
GROUP BY royalties_aggregated.AUTHOR_ID
ORDER BY sum(royalties_aggregated.Sales_Royalty) DESC
LIMIT 3;

#CHALLENGE 2 - Alternative Solution
#step1
SELECT titles.title_id, titleauthor.au_id, (titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
ORDER BY (titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) DESC
;

#step 2
SELECT title_id, author_id, sales_royalty
FROM (
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, SUM((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100)) AS sales_royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY SUM((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100)) DESC
) royalties_aggregated
;

#step 3
SELECT royalties_aggregated.author_id AS AUTHOR_ID, SUM(royalties_aggregated.sales_royalty) AS Total_Sales_Royalties
FROM royalties_aggregated
GROUP BY AUTHOR_ID
ORDER BY SUM(royalties_aggregated.sales_royalty) DESC
LIMIT 3
;

#CHALLENGE 3

CREATE TEMPORARY TABLE advance_and_royalties
SELECT titles.title_id AS TITLE_ID, titleauthor.au_id AS AUTHOR_ID,
((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) + titles.advance) AS advance_and_royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
ORDER BY ((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) + titles.advance) DESC
;

SELECT * FROM advance_and_royalties;

CREATE TEMPORARY TABLE advance_royalties_aggregated
SELECT advance_and_royalties.TITLE_ID, advance_and_royalties.AUTHOR_ID, SUM(advance_and_royalties.advance_and_royalty) AS Sales_Royalty
FROM advance_and_royalties
GROUP BY advance_and_royalties.TITLE_ID, advance_and_royalties.AUTHOR_ID
ORDER BY SUM(advance_and_royalties.advance_and_royalty) DESC
;

SELECT * FROM advance_royalties_aggregated;

CREATE TEMPORARY TABLE authors_profit
SELECT advance_royalties_aggregated.AUTHOR_ID AS au_ID, SUM(advance_royalties_aggregated.Sales_Royalty) AS Profits
FROM advance_royalties_aggregated
GROUP BY advance_royalties_aggregated.AUTHOR_ID
ORDER BY SUM(advance_royalties_aggregated.Sales_Royalty) DESC
;

SELECT * FROM authors_profit;

CREATE TABLE most_profiting_authors
AS
SELECT au_id , profits
FROM  authors_profit;
