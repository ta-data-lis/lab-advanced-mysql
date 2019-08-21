#Challenge 1 - Most Profiting Authors
#Step 1: Calculate the royalties of each sales for each author
SELECT titles.title_id, titleauthor.au_id,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM sales
JOIN titles ON sales.title_id = titles.title_id
JOIN titleauthor ON titleauthor.title_id = titles.title_id;

#Step 2: Aggregate the total royalties for each title for each author
SELECT titles.title_id, titleauthor.au_id,
SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sum_sales_royalty
FROM sales
JOIN titles ON sales.title_id = titles.title_id
JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY titles.title_id, titleauthor.au_id;

#Step 3: Calculate the total profits of each author
SELECT titles.title_id, titleauthor.au_id,
SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance AS advance_sales_royalty
FROM sales
JOIN titles ON sales.title_id = titles.title_id
JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY titles.title_id, titleauthor.au_id;

#Challenge 2 - Alternative Solution
CREATE TEMPORARY TABLE royalty_for_title_author
SELECT titles.title_id, titleauthor.au_id,
SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance 
AS advance_sales_royalty
FROM sales
JOIN titles ON sales.title_id = titles.title_id
JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY titles.title_id, titleauthor.au_id;

SELECT * FROM royalty_for_title_author;

SELECT title_id, au_id, 
SUM(advance_sales_royalty) AS total_royalty
FROM royalty_for_title_author
GROUP BY title_id, au_id
ORDER BY total_royalty DESC;

#Challenge 3
SELECT titleauthor.au_id,
SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance 
AS profits
FROM titles
INNER JOIN titleauthor on titleauthor.title_id = titles.title_id
INNER JOIN sales on titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) 
DESC;