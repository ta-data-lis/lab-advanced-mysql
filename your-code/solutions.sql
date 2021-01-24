/*CHALLENGE 1*/

SELECT author_profit.Author_ID, sum(author_profit.sales_royalty) + author_profit.advance AS profit
FROM (
SELECT titles.title_id AS Title_ID, titleauthor.au_id AS Author_ID, titles.advance, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_royalty
FROM publications.titleauthor
INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON titleauthor.title_id = sales.title_id) AS author_profit
GROUP BY author_profit.Title_ID, author_profit.Author_ID
ORDER BY profit DESC
LIMIT 3;

/*CHALLENGE 2*/

CREATE TEMPORARY TABLE publications.author_profit
SELECT titles.title_id AS Title_ID, titleauthor.au_id AS Author_ID, titles.advance, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_royalty
FROM publications.titleauthor
INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON titleauthor.title_id = sales.title_id;

SELECT author_profit.Author_ID, sum(author_profit.sales_royalty) + author_profit.advance AS profit
FROM publications.author_profit
GROUP BY author_profit.Title_ID, author_profit.Author_ID
ORDER BY profit DESC
LIMIT 3;

/*CHALLENGE 3*/

CREATE TABLE publications.most_profiting_authors
SELECT author_profit.Author_ID AS au_id, sum(author_profit.sales_royalty) + author_profit.advance AS profits
FROM publications.author_profit
GROUP BY author_profit.Title_ID, author_profit.Author_ID
ORDER BY profits DESC;

SELECT * FROM publications.most_profiting_authors;
