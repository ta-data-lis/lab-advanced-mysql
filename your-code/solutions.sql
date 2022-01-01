USE publications;

-- Challenge 1 - Most Profiting Authors using Derived tables 

-- 1. Calculate the royalty of each sale for each author.
SELECT a.au_id, t.title_id, (t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id;

-- Step 2: Aggregate the total royalties for each title for each author
SELECT a.au_id, t.title_id, t.advance, sum(t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id
GROUP BY t.title_id, a.au_id;

-- Step 3: Calculate the total profits of each author
SELECT au_id, advance*royalty/100 AS 'profit'
FROM(
SELECT a.au_id, t.title_id, t.advance, sum(t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id
GROUP BY t.title_id, a.au_id)a
ORDER BY profit DESC
LIMIT 3;

-- Challenge 2 - Most Profiting Authors using Temporary tables 

-- 1. Calculate the royalty of each sale for each author.
SELECT a.au_id, t.title_id, (t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id;

-- Step 2: Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE author_royalty(
SELECT a.au_id, t.title_id, t.advance, SUM(t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id
GROUP BY title_id, au_id
);

-- Step 3: Calculate the total profits of each author
SELECT au_id, advance*royalty/100 AS 'profit'
FROM author_royalty
ORDER BY profit DESC
LIMIT 3;

-- Challenge 3 - Most Profiting Authors TABLE

CREATE TABLE most_profiting_authors(
SELECT au_id, advance*royalty/100 AS 'profit'
FROM(
SELECT a.au_id, t.title_id, t.advance, sum(t.price*s.qty*(t.royalty/100)*(ta.royaltyper/100)) AS 'royalty'
FROM authors as a 
INNER JOIN titleauthor AS ta ON ta.au_id = a.au_id
INNER JOIN titles AS t ON t.title_id = ta.title_id
INNER JOIN sales AS s ON s.title_id = t.title_id
GROUP BY t.title_id, a.au_id)a
ORDER BY profit DESC
LIMIT 3
);