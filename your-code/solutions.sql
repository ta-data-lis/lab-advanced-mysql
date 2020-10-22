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
