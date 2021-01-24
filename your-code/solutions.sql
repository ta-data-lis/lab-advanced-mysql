/*1. Write a SELECT query to obtain the following output:
Title ID
Author ID
Royalty of each sale for each author
The formular is:
sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
Note that titles.royalty and titleauthor.royaltyper are divided by 100 respectively because they are percentage numbers instead of floats.
In the output of this step, each title may appear more than once for each author. This is because a title can have more than one sales.*/

CREATE TEMPORARY TABLE titleauthor_title
SELECT titles.title_id, royalty, titles.price, au_id, royaltyper
FROM titles
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id;


CREATE TEMPORARY TABLE sales_royalty
SELECT titleauthor_title.title_id AS 'Title ID', titleauthor_title.au_id AS 'Author ID',titleauthor_title.price * sales.qty * titleauthor_title.royalty / 100 * titleauthor_title.royaltyper / 100 AS sales_royalty
FROM titleauthor_title
INNER JOIN sales
ON titleauthor_title.title_id = sales.title_id;

SELECT *
FROM sales_royalty;

/*Step 2: Aggregate the total royalties for each title for each author
Using the output from Step 1, write a query to obtain the following output:

Title ID
Author ID
Aggregated royalties of each title for each author
Hint: use the SUM subquery and group by both au_id and title_id
In the output of this step, each title should appear only once for each author.*/

/*Here I am recreating the table above without changing the names for a better usage on the next steps*/


CREATE TEMPORARY TABLE sales_royalty_2;
SELECT titleauthor_title.title_id, titleauthor_title.au_id ,titleauthor_title.price * sales.qty * titleauthor_title.royalty / 100 * titleauthor_title.royaltyper / 100 AS sales_royalty
FROM titleauthor_title
INNER JOIN sales
ON titleauthor_title.title_id = sales.title_id;


CREATE TEMPORARY TABLE sum_temporary
SELECT title_id, au_id, SUM(sales_royalty_2.sales_royalty) AS sum_royalty
FROM sales_royalty_2
GROUP BY  title_id, au_id;


/* Step 3: Calculate the total profits of each author
Now that each title has exactly one row for each author where the advance and royalties are available, we are ready to obtain the eventual output. 
Using the output from Step 2, write a query to obtain the following output:

Author ID
Profits of each author by aggregating the advance and total royalties of each title
Sort the output based on a total profits from high to low, and limit the number of rows to 3.*/

CREATE TEMPORARY TABLE title_adv
SELECT advance, title_id
FROM titles;


CREATE TEMPORARY TABLE profit;
SELECT au_id, (title_adv.advance + sum_temporary.sum_royalty) AS total_profit
FROM sum_temporary
INNER JOIN title_adv
ON sum_temporary.title_id = title_adv.title_id
ORDER BY total_profit DESC
LIMIT 3;

/* Challenge 2 - Alternative Solution
In the previous challenge, you may have developed your solution in either of the following ways:

Derived tables (see reference)
Creating MySQL temporary tables in the initial steps, and query the temporary tables in the subsequent steps.
Either way you have used, we'd like you to try the other way. Include your alternative solution in solutions.sql.*/


SELECT titleauthor_title.title_id, titleauthor_title.au_id ,titleauthor_title.price * sales.qty * titleauthor_title.royalty / 100 * titleauthor_title.royaltyper / 100 AS sales_royalty
FROM titleauthor_title
INNER JOIN sales
ON titleauthor_title.title_id = sales.title_id;

SELECT titles.title_id, au_id, SUM(sales_royalty) AS sum_royalty
FROM titles
INNER JOIN (SELECT titleauthor_title.title_id, titleauthor_title.au_id ,titleauthor_title.price * sales.qty * titleauthor_title.royalty / 100 * titleauthor_title.royaltyper / 100 AS sales_royalty
FROM titleauthor_title
INNER JOIN sales
ON titleauthor_title.title_id = sales.title_id) AS royalties 
ON titles.title_id = royalties.title_id
GROUP BY  title_id, au_id;


/*Challenge 3
Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to hold the data about the most profiting authors. The table should have 2 columns:

au_id - Author ID
profits - The profits of the author aggregating the advances and royalties
Include your solution in solutions.sql.*/


CREATE TABLE profits
SELECT au_id, SUM(sales_royalty) AS sum_royalty
FROM titles
INNER JOIN (SELECT titleauthor_title.title_id, titleauthor_title.au_id ,titleauthor_title.price * sales.qty * titleauthor_title.royalty / 100 * titleauthor_title.royaltyper / 100 AS sales_royalty
FROM titleauthor_title
INNER JOIN sales
ON titleauthor_title.title_id = sales.title_id) AS royalties 
ON titles.title_id = royalties.title_id
GROUP BY  au_id;








