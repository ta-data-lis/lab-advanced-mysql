-- IRONHACK DATA ANALYTICS BOOTCAMP --
-- WEEK 2

-- LAB: ADVANCED MySQL --

-- Challenge 1: Most Profiting Authors (With Temporary tables)

-- Step 1
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id;

-- Step 2
CREATE TEMPORARY TABLE salesroyalties
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id;

SELECT DISTINCT salesroyalties.title_id, salesroyalties.au_id, SUM(salesroyalties.sales_royalty) AS total_royalties
FROM salesroyalties
GROUP BY salesroyalties.au_id, salesroyalties.title_id;

-- Step 3
CREATE TEMPORARY TABLE aggreg_royalties
SELECT DISTINCT salesroyalties.title_id, salesroyalties.au_id, SUM(salesroyalties.sales_royalty) AS total_royalties
FROM salesroyalties
GROUP BY salesroyalties.au_id, salesroyalties.title_id;

SELECT aggreg_royalties.au_id, SUM(aggreg_royalties.total_royalties) AS profits
FROM aggreg_royalties
GROUP BY aggreg_royalties.au_id;


-- Challenge 2: Alternative solution - With Subqueries

-- This is the first query
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id;

-- This is the second query, the subquery inside is called 'salesroyalties'
SELECT DISTINCT salesroyalties.title_id, salesroyalties.au_id, SUM(salesroyalties.sales_royalty) AS total_royalties
FROM (
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id
) salesroyalties
GROUP BY salesroyalties.au_id, salesroyalties.title_id;

-- Final query, the subquery here is called 'aggreg_royalties'
SELECT aggreg_royalties.au_id, SUM(aggreg_royalties.total_royalties) AS profits
FROM (
SELECT DISTINCT salesroyalties.title_id, salesroyalties.au_id, SUM(salesroyalties.sales_royalty) AS total_royalties
FROM (
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id
) salesroyalties
GROUP BY salesroyalties.au_id, salesroyalties.title_id
) aggreg_royalties
GROUP BY aggreg_royalties.au_id;


-- Challenge 3: Creating the 'most_profiting_authors' table

CREATE TABLE IF NOT EXISTS
publications.most_profiting_authors(
au_id VARCHAR(11) PRIMARY KEY,
profits FLOAT
);

INSERT INTO most_profiting_authors (au_id, profits)
SELECT aggreg_royalties.au_id, SUM(aggreg_royalties.total_royalties) AS profits
FROM (
SELECT DISTINCT salesroyalties.title_id, salesroyalties.au_id, SUM(salesroyalties.sales_royalty) AS total_royalties
FROM (
SELECT sales.title_id, titleauthor.au_id, titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id
LEFT JOIN authors
ON titleauthor.au_id = authors.au_id
) salesroyalties
GROUP BY salesroyalties.au_id, salesroyalties.title_id
) aggreg_royalties
GROUP BY aggreg_royalties.au_id;


SELECT *
FROM most_profiting_authors;