SELECT * FROM publications.sales;

# Challenge 1
# Step 1
SELECT authors.au_id AS AuthorID,  titles.title_id AS Title, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper /100 AS sales_royalty
FROM  publications.titles
INNER JOIN publications.titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON sales.title_id = titles.title_id
INNER JOIN publications.authors ON authors.au_id = titleauthor.au_id;

# Step 2
SELECT titleauthor.au_id AS AuthorID,  titles.title_id AS Title, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper /100) AS sum_sales_royalty
FROM  publications.titles
INNER JOIN publications.titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON sales.title_id = titles.title_id
GROUP BY Title, AuthorID
ORDER BY sum_sales_royalty DESC;

# Step 3
CREATE TEMPORARY TABLE publications.royalties_per_title_per_author_3
SELECT titleauthor.au_id AS AuthorID,  titles.title_id AS Title, sum((titles.price * sales.qty) * titles.royalty / 100 * (titleauthor.royaltyper /100)) AS sum_sales_royalty, advance
FROM  publications.titles
INNER JOIN publications.titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON sales.title_id = titles.title_id
GROUP BY Title, AuthorID
ORDER BY sum_sales_royalty DESC;

SELECT AuthorID, sum(sum_sales_royalty + advance) as profits
FROM publications.royalties_per_title_per_author_3
GROUP BY AuthorID
ORDER BY profits DESC
LIMIT 3;

# Challange 3
CREATE TEMPORARY TABLE publications.sales_total
SELECT AuthorID, sum(sum_sales_royalty + advance) as profits
FROM publications.royalties_per_title_per_author_3
GROUP BY AuthorID;

CREATE TABLE most_profiting_authors
AS
SELECT AuthorID, profits
FROM publications.sales_total
ORDER BY profits DESC;