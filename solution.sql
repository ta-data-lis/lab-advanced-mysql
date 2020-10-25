/*Challenge 1 ### Step 1: Calculate the royalties of each sales for each author*/

CREATE TABLE royalty_sales
AS
(SELECT titles.title_id, titleauthor.au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS royalty_sales
FROM titles
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id);

/*Write a SELECT query to obtain the following output:

* Title ID
* Author ID
* Royalty of each sale for each author
    * The formular is:
        ```
        sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
        ```
    * Note that `titles.royalty` and `titleauthor.royaltyper` are divided by 100 respectively because they are percentage numbers instead of floats.

In the output of this step, each title may appear more than once for each author. This is because a title can have more than one sales.
*/


/*Step 2: Aggregate the total royalties for each title for each author
Using the output from Step 1, write a query to obtain the following output:

Title ID
Author ID
Aggregated royalties of each title for each author
Hint: use the SUM subquery and group by both au_id and title_id
In the output of this step, each title should appear only once for each author.*/

SELECT royalty_sales.title_id, royalty_sales.au_id, SUM(royalty_sales.royalty_sales) AS royaltypertitle
FROM royalty_sales
GROUP BY royalty_sales.au_id, royalty_sales.title_id;

/*Step 3: Calculate the total profits of each author
Now that each title has exactly one row for each author where the advance and royalties are available, we are ready to obtain the eventual output. Using the output from Step 2, write a query to obtain the following output:

Author ID
Profits of each author by aggregating the advance and total royalties of each title
Sort the output based on a total profits from high to low, and limit the number of rows to 3.*/

SELECT royalty_sales.au_id, SUM(royalty_sales.royalty_sales) AS royaltiesperauthor
FROM royalty_sales
GROUP BY royalty_sales.au_id
ORDER BY royalty_sales.royalty_sales DESC
LIMIT 3;

/*Challenge 3
Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to hold the data about the most profiting authors. The table should have 2 columns:

au_id - Author ID
profits - The profits of the author aggregating the advances and royalties
Include your solution in solutions.sql.*/

CREATE TABLE most_profiting_authors AS
SELECT royalty_sales.au_id, SUM(royalty_sales.royalty_sales) AS royaltyperauthor
FROM royalty_sales
GROUP BY royalty_sales.au_id
ORDER BY royalty_sales.royalty_sales DESC;