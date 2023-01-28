### Challenge 1 - Most Profiting Authors
#In this challenge let's have a close look at the bonus challenge of the previous 
#*MySQL SELECT* lab -- **who are the top 3 most profiting authors**? 


### Step 1: Calculate the royalties of each sales for each author

SELECT a.au_id AS 'Author_ID', titles.title_id AS 'Title_ID',
    titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100 AS 'Royalty'
FROM lab2_select.authors AS a 
	JOIN lab2_select.titleauthor ON titleauthor.au_id = a.au_id
	JOIN lab2_select.titles ON titleauthor.title_id = titles.title_id
    JOIN lab2_select.sales ON titles.title_id = sales.title_id
ORDER BY a.au_id; 
#--34 rows, not grouped


### Step 2: Aggregate the total royalties for each title for each author
 
CREATE TEMPORARY TABLE royalty_each_sale
SELECT a.au_id AS 'Author_ID', titles.title_id AS 'Title_ID',
	sum(titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100) AS royalty_agg
FROM lab2_select.authors AS a 
	JOIN lab2_select.titleauthor ON titleauthor.au_id = a.au_id
	JOIN lab2_select.titles ON titleauthor.title_id = titles.title_id
    JOIN lab2_select.sales ON titles.title_id = sales.title_id
GROUP BY a.au_id, titles.title_id ORDER BY a.au_id; 


### Step 3: Calculate the total profits of each author

SELECT res.author_ID, res.royalty_agg + titles.advance AS profits 
FROM royalty_each_sale res JOIN lab2_select.titles
ON res.Title_ID = titles.title_id
ORDER BY profits DESC LIMIT 3;



## Challenge 2 - Alternative Solution

#all in one, with a subquery instead of a temporary table

SELECT res.author_ID, res.royalty_agg + titles.advance AS profits 
FROM lab2_select.titles JOIN (
	SELECT a.au_id AS 'Author_ID', titles.title_id AS 'Title_ID',
		sum(titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100) AS royalty_agg
	FROM lab2_select.authors AS a 
		JOIN lab2_select.titleauthor ON titleauthor.au_id = a.au_id
		JOIN lab2_select.titles ON titleauthor.title_id = titles.title_id
		JOIN lab2_select.sales ON titles.title_id = sales.title_id
	GROUP BY a.au_id, titles.title_id ORDER BY a.au_id
) AS res
ON res.Title_ID = titles.title_id
ORDER BY profits DESC LIMIT 3;



## Challenge 3
CREATE TABLE most_profiting_authors (
	au_id varchar(11) PRIMARY KEY, 
    profits float);

INSERT INTO most_profiting_authors (au_id, profits) 
SELECT res.author_ID, res.royalty_agg + titles.advance 
FROM royalty_each_sale res JOIN lab2_select.titles
ON res.Title_ID = titles.title_id
ORDER BY res.royalty_agg + titles.advance DESC LIMIT 3;

SELECT * FROM most_profiting_authors;