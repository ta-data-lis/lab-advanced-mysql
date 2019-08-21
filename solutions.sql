#Challenge 1
#Step 1: Calculate the royalties of each sales for each author

SELECT titleauthor.title_id, titleauthor.au_id, titles.price *  sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titles.title_id;


# Step 2: Aggregate the total royalties for each title for each author

CREATE TEMPORARY TABLE royalties_summary
SELECT title_id, au_id, sum(sales_royalty) AS total_royalties, advance
FROM (SELECT titleauthor.title_id, titleauthor.au_id, titles.price *  sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty, advance
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titles.title_id) Sales_royalties
GROUP BY au_id, title_id;

SELECT * FROM royalties_summary;


#Step 3: Calculate the total profits of each author

SELECT au_id, SUM(total_royalties + advance) AS Profits
FROM royalties_summary
GROUP BY au_id
ORDER BY Profits DESC
LIMIT 3;

# Challenge 2 - Alternative Solution | done both 

# Challenge 3 
CREATE TEMPORARY TABLE profits
SELECT au_id, SUM(total_royalties + advance) AS Profits
FROM royalties_summary
GROUP BY au_id
ORDER BY Profits DESC;

SELECT * FROM profits;

CREATE TABLE most_profiting_authors
AS 
SELECT au_id, profits
FROM profits;



