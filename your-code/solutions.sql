USE publications;

SELECT * FROM authors;
SELECT * FROM pub_info;
SELECT * FROM publishers;
SELECT * FROM roysched;
SELECT * FROM sales;
SELECT * FROM stores;
SELECT * FROM titleauthor;
SELECT * FROM titles;


-- Challenge 1 - Most Profiting Authors

-- Step 1: Calculate the royalties of each sales for each author

SELECT titleauthor.title_id AS `Title ID`, au_id AS `Author ID`, 
ROUND((titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)),3) AS `Sales Royalty`
FROM publications.titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
ORDER BY titleauthor.title_id;

-- Step 2: Aggregate the total royalties for each title for each author

SELECT titleauthor.title_id AS `Title ID`, au_id AS `Author ID`, 
SUM(ROUND((titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)),3)) AS `Sales Royalty`
FROM publications.titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
GROUP BY titleauthor.au_id, titleauthor.title_id
ORDER BY titleauthor.title_id;

-- Step 3: Calculate the total profits of each author

SELECT au_id AS `Author ID`, 
SUM(ROUND((titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)),3)) AS `Sales Royalty`
FROM publications.titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
GROUP BY titleauthor.au_id
ORDER BY `Sales Royalty` DESC
LIMIT 3;

-- Challenge 2 - Alternative Solution

-- Using temporary tables

CREATE TEMPORARY TABLE salesroyalty
SELECT au_id AS `Author ID`, 
SUM(ROUND((titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)),3)) AS `Sales Royalty`
FROM publications.titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
GROUP BY titleauthor.au_id
ORDER BY `Sales Royalty` DESC
LIMIT 3;

SELECT * FROM salesroyalty;

-- Challenge 3

DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE most_profiting_authors
SELECT au_id AS `Author ID`, 
SUM(ROUND((titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)),3)) AS `Sales Royalty`
FROM publications.titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
GROUP BY titleauthor.au_id
ORDER BY `Sales Royalty` DESC
;

SELECT * FROM most_profiting_authors;