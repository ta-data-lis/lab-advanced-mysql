#Challenge 1 -

#Step 1: Calculate the royalties of each sales for each author


CREATE TEMPORARY TABLE temp_table
AS
SELECT titleauthor.title_id, 
titleauthor.au_id,
titles.advance,
(titles.price * sales.qty) * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS royalty
from titleauthor
JOIN sales
ON sales.title_id = titleauthor.title_id 
JOIN titles 
ON titleauthor.title_id = titles.title_id 
;

Select * from temp_table;
#shows the royalty for each author & title

# Step 2: Aggregate the total royalties for each title for each author


CREATE TEMPORARY TABLE temp_table_two
AS
SELECT * FROM (SELECT title_id, au_id, SUM(royalty) Royalty, SUM(temp_table.advance) Advance 
FROM temp_table 
GROUP BY temp_table.title_id, temp_table.au_id) royalty_output;



#Step 3

SELECT temp_table_two.au_id AS 'Author ID', SUM(temp_table_two.royalty + temp_table_two.advance) Profit FROM temp_table_two
GROUP BY au_id
ORDER BY Profit DESC 
LIMIT 3
;

#Challenge 2 - Alternative Solution

SELECT derived_table_calc.au_id, sum(derived_table_calc.advance + derived_table_calc.royalty) Profit FROM
(SELECT titleauthor.title_id, titleauthor.au_id, titles.advance, (titles.price * sales.qty) * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS Royalty
FROM titleauthor
JOIN titles
ON titleauthor.title_id = titles.title_id
JOIN sales
ON sales.title_id = titleauthor.title_id) AS derived_table_calc
Group BY derived_table_calc.au_id
ORDER BY Profit DESC 
LIMIT 3
; 


#### Challenge 3

CREATE TABLE most_profiting_authors
AS
SELECT temp_table_two.au_id AS 'Author ID', SUM(temp_table_two.royalty + temp_table_two.advance) Profit FROM temp_table_two
GROUP BY au_id
ORDER BY Profit DESC;

SELECT * FROM most_profiting_authors; 