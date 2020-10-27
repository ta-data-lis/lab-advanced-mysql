/*Temporary tables*/

	/*Challenge 1*/
CREATE TEMPORARY TABLE sales_royalty
SELECT titles.title_id, titleauthor.au_id,(titles.price*sales.qty * (titles.royalty/100)) * (titleauthor.royaltyper/100) AS Sales_royalty
FROM titles
INNER JOIN sales
ON titles.title_id=sales.title_id
INNER JOIN titleauthor
ON sales.title_id=titleauthor.title_id;

	/*Challenge 2*/
CREATE TEMPORARY TABLE agsales_royalty
SELECT titles.title_id, titleauthor.au_id, sum(sales_royalty)
FROM titles
INNER JOIN sales
ON titles.title_id=sales.title_id
INNER JOIN titleauthor
ON sales.title_id=titleauthor.title_id
INNER JOIN sales_royalty
ON sales.title_id=sales_royalty.title_id
GROUP BY title_id, au_id
LIMIT 3;

	/*Challenge3*/
SELECT titleauthor.au_id, titles.advance, sum(sales_royalty)
FROM titles
INNER JOIN sales
ON titles.title_id=sales.title_id
INNER JOIN titleauthor
ON sales.title_id=titleauthor.title_id
INNER JOIN sales_royalty
ON sales.title_id=sales_royalty.title_id
GROUP BY titleauthor.title_id, au_id;

/* Derived tables */
	/*Challenge 1*/
SELECT * 
FROM (SELECT titles.title_id , titleauthor.au_id, titles.price*sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 AS Sales_royalty
FROM titles
INNER JOIN sales
ON titles.title_id = sales.title_id
INNER JOIN titleauthor
ON sales.title_id = titleauthor.title_id) AS Sales_royalty
	/* Challenge 2 */
SELECT *
FROM (SELECT titles.title_id, titleauthor.au_id, sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_royalty)
FROM titles
INNER JOIN sales
ON titles.title_id =sales.title_id
INNER JOIN titleautor
ON sales.title_id = titleauthor.title_id) AS Sales_royalty
GROUP BY titles.title_id, titleauthor.au_id
LIMIT 3;

	/*Challenge 3*/
SELECT *
FROM (SELECT titleauthor.au_id, sum ((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_royalty)
FROM titles
INNER JOIN sales
ON titles.title_id = sales.title_id
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id) as Sales_royalty
GROUP BY titleauthor.au_id
ORDER BY Sales_royalty DESC;

/*Challenge 3, create a table*/
CREATE TABLE most_profiting_authors
SELECT titles.title_id, titleauthor.au_id, sum(titles.price*sales.qty * (titles.royalty/100)) * (titleauthor.royaltyper/100) AS Sales_royalty 
FROM titles
INNER JOIN titleauthor
ON titles.title_id=titleauthor.title_id
INNER JOIN sales
ON titleauthor.title_id=sales.title_id
GROUP BY titleauthor.au_id
ORDER BY Sales_royalty;