## Challenge 1 - Most Profiting Authors
-- Calculate the royalty of each sale for each author.

-- This code returns the 6 columns one of them called royalties its the royalty calculated according to the formula on the code below
-- Also, on the next step it was necessary to use this table, so I made it as a temporary table.

CREATE TEMPORARY TABLE royalty_perAuthor
SELECT sales.title_id, sales.ord_num, titles.price, titleauthor.au_id, 
titleauthor.royaltyper,round((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100),3) as royalties,
round((titles.advance / 100 * titleauthor.royaltyper / 100),3) AS "advanced_royalties"
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON sales.title_id = titleauthor.title_id;


-- This code shows the royalties aggregaded by author and title id resulting in profit by author if we sum the aggregaed royaltties.

SELECT royalty_perAuthor.title_id, royalty_perAuthor.au_id, sum(royalty_perAuthor.royalties) AS profit_per_author,
sum(advanced_royalties)
FROM royalty_perAuthor
GROUP BY royalty_perAuthor.title_id, royalty_perAuthor.au_id;



## Challenge 2 - Alternative Solution

-- This challenge returns a 3 column table using the method derived tables

SELECT royaties_calcs.title_id, royaties_calcs.au_id, sum(royaties_calcs.royalties) AS profit_per_author, sum(advanced_royalties) AS advanced_profit
FROM(SELECT sales.title_id, sales.ord_num, titles.price, titleauthor.au_id, 
titleauthor.royaltyper,round((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100),3) as royalties,
round((titles.advance / 100 * titleauthor.royaltyper / 100),3) AS "advanced_royalties"
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON sales.title_id = titleauthor.title_id) AS royaties_calcs
GROUP BY royaties_calcs.title_id, royaties_calcs.au_id;




## Challenge 3

-- This query returns a table with 2 columns displaying authors id and total profit
CREATE TABLE most_profiting_authors
AS 
SELECT titleauthor.au_id, 
sum(round((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100),3) +
round((titles.advance / 100 * titleauthor.royaltyper / 100),3)) AS TOTAL_PROFIT
FROM sales
INNER JOIN titles
ON sales.title_id = titles.title_id
INNER JOIN titleauthor
ON sales.title_id = titleauthor.title_id
group by titleauthor.au_id;


