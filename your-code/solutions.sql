/*Challenge 1 */

CREATE TEMPORARY TABLE money
SELECT titles.title_id,titleauthor.au_id,titles.advance, titles.title, titles.price, titles.royalty, sales.qty, titleauthor.royaltyper, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titles
INNER JOIN sales
ON titles.title_id = sales.title_id
INNER JOIN titleauthor
ON titleauthor.title_id = titles.title_id;

SELECT money.au_id, money.title_id, authors.au_lname, authors.au_fname,money.advance + SUM(money.sales_royalty) AS profit
FROM money
INNER JOIN authors
ON authors.au_id = money.au_id
GROUP BY au_id, title_id
ORDER BY profit desc
LIMIT 3;

/*Challenge 2 */
SELECT table1.au_id AS Author_ID, table1.title_id, authors.au_lname, authors.au_fname,table1.advance + SUM(table1.sales_royalty) AS profit
FROM (SELECT titles.title_id,titleauthor.au_id,titles.advance, titles.title, titles.price, titles.royalty, sales.qty, titleauthor.royaltyper, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty FROM titles INNER JOIN sales ON titles.title_id = sales.title_id INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id) as table1
INNER JOIN authors
ON authors.au_id = table1.au_id
GROUP BY Author_ID, title_id
ORDER BY profit desc
LIMIT 3;

/*Challenge 3 */
CREATE VIEW publications.most_profiting_authors AS
(SELECT table1.au_id AS Author_ID,table1.advance + SUM(table1.sales_royalty) AS profit
FROM (SELECT titles.title_id,titleauthor.au_id,titles.advance, titles.title, titles.price, titles.royalty, sales.qty, titleauthor.royaltyper, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty FROM titles INNER JOIN sales ON titles.title_id = sales.title_id INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id) as table1
INNER JOIN authors
ON authors.au_id = table1.au_id
GROUP BY Author_ID, title_id
ORDER BY profit desc
LIMIT 10);

SELECT *
FROM publications.most_profiting_authors;
