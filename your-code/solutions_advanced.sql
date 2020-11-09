

#NEW LAB FROM HERE Saturday 7.11.20

#STEP 1 

USE Challenge2;

DROP TABLE part1;

CREATE TEMPORARY TABLE part1
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)  AS sales_royalty 
FROM  authors
LEFT JOIN titleauthor ON authors.au_id = titleauthor.au_id 
LEFT JOIN titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales ON sales.title_id = titles.title_id;


#STEP 2

SELECT title_id, au_id, SUM(sales_royalty)
FROM part1
GROUP BY 1,2;

#Step 3 

SELECT  au_id, (SUM(titles.advance) + SUM(sales_royalty )) AS Profit
from part1, titles
Group BY 1
order by profit DESC 
Limit 3; 



# Challenge 2 
# Alternative solution


CREATE TABLE part2
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)  AS sales_royalty 
FROM  authors
LEFT JOIN titleauthor ON authors.au_id = titleauthor.au_id 
LEFT JOIN titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales ON sales.title_id = titles.title_id;

SELECT * FROM part2;

SELECT * FROM titles;

#STEP 2

SELECT title_id, au_id, SUM(sales_royalty)
FROM part2
GROUP BY 1,2;

#Step 3 

SELECT  au_id, (SUM(titles.advance) + SUM(sales_royalty )) AS Profit
from part2, titles
Group BY 1
order by profit DESC 
Limit 3; 


# Challenge 3

Drop table most_profiting_authors;

CREATE TABLE most_profiting_authors
SELECT part2.au_id, (SUM(titles.advance) + SUM(sales_royalty )) AS profits FROM part2
LEFT JOIN titles ON part2.title_id = titles.title_id
GROUP BY 1;

SELECT * from most_profiting_authors
ORDER BY profits desc
Limit 10;