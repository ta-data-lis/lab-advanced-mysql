/*CHALLENGE 1*/
/*Step 1: Calculate the royalties of each sales for each author*/
CREATE TABLE Question1Table AS
SELECT *
FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS RoyaltyEachSale
FROM titles
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id) as royalties_for_each_sale;

/*Step 2: Aggregate the total royalties for each title for each author*/
SELECT question1table.TitleID, question1table.AuthorID, SUM(question1table.RoyaltyEachSale) AS RoyaltiesEachTitle
FROM question1table
GROUP BY question1table.AuthorID, question1table.TitleID;

/*Step 3: Calculate the total profits of each author*/
SELECT question1table.AuthorID, SUM(question1table.RoyaltyEachSale) AS RoyaltiesPerAuthor
FROM question1table
GROUP BY question1table.AuthorID
ORDER BY question1table.RoyaltyEachSale DESC
LIMIT 3;

/*Challenge1: Completed*/

/*CHALLENGE 2*/
/*TEMPORARY TABLES ALTERNATIVE SOLUTION 2*/

/*Step 1: Calculate the royalties of each sales for each author*/
CREATE TEMPORARY TABLE Question1TTable AS
SELECT *
FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS RoyaltyEachSale
FROM titles
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id) as royalties_for_each_sale;

/*Step 2: Aggregate the total royalties for each title for each author*/
SELECT Question1TTable.TitleID, Question1TTable.AuthorID, SUM(Question1TTable.RoyaltyEachSale) AS RoyaltiesEachTitle
FROM Question1TTable
GROUP BY Question1TTable.AuthorID, Question1TTable.TitleID;

/*Step 3: Calculate the total profits of each author*/
SELECT Question1TTable.AuthorID, SUM(Question1TTable.RoyaltyEachSale) AS RoyaltiesPerAuthor
FROM Question1TTable
GROUP BY Question1TTable.AuthorID
ORDER BY Question1TTable.RoyaltyEachSale DESC
LIMIT 3;

/*CHALLENGE 3*/
CREATE TABLE most_profiting_authors AS
SELECT question1table.AuthorID, SUM(question1table.RoyaltyEachSale) AS RoyaltiesPerAuthor
FROM question1table
GROUP BY question1table.AuthorID
ORDER BY question1table.RoyaltyEachSale DESC;



