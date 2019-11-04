USE publications;

# CHALLENGE 1

# Calculate the royalties of each sales for each author

SELECT titleauthor.title_id,titleauthor.au_id,titles.royalty,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id;

# Aggregate the total royalties for each title for each author

SELECT title, author, SUM(sales_royalty) AS sum_royalty
FROM (
SELECT titleauthor.title_id AS title,titleauthor.au_id AS author,titles.royalty AS royalty,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id) AS royalty
GROUP BY royalty.title,royalty.author
ORDER BY sum_royalty DESC;

# Calculate the total profits of each author, (profits of each author by aggregating the advance and total royalties of each title)

SELECT author,SUM(sum_royalty+advance)
FROM(
SELECT title, author, SUM(sales_royalty) AS sum_royalty
FROM (
SELECT titleauthor.title_id AS title,titleauthor.au_id AS author,titles.royalty AS royalty,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id) AS royalty
GROUP BY royalty.author
ORDER BY sum_royalty DESC) summary
INNER JOIN titles ON titles.title_id = summary.title
GROUP BY author;

# CHALLENGE 2

# Alternative Solution with tables
# Calculate the royalties of each sales for each author

CREATE TEMPORARY TABLE sales_royalties
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id,
(titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id;

SELECT * FROM sales_royalties;

#Aggregate the total royalties for each title for each author

CREATE TEMPORARY TABLE sum_royalties
SELECT sales_royalties.title_id, sales_royalties.author_id, SUM(sales_royalties.sales_royalty) AS sales_royalty
FROM sales_royalties
GROUP BY sales_royalties.title_id, sales_royalties.author_id
ORDER BY SUM(sales_royalties.sales_royalty) DESC;

SELECT * FROM sum_royalties;

#Calculate the total profits of each author
SELECT sum_royalties.author_id AS author_id, SUM(sum_royalties.sales_royalty+titles.advance) AS total_royalty
FROM sum_royalties
INNER JOIN titles ON titles.title_id = sum_royalties.title_id
GROUP BY sum_royalties.author_id
ORDER BY total_royalty DESC
LIMIT 3;

# CHALLENGE 3

CREATE TABLE most_profiting_authors (id INT PRIMARY KEY AUTO_INCREMENT,
au_id VARCHAR(30) NOT NULL,
profits INT(30) NOT NULL);

INSERT INTO most_profiting_authors (au_id,profits)
VALUES ('899-46-2035', '17673.64000000'),('213-46-8915', '15225.07850000'),('722-51-5454', '15038.27200000');