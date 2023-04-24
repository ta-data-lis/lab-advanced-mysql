# Use database publication:
USE publication;
# List all tables in publication database:
SHOW TABLES;


# Challenge 1 - Most Profiting Authors
#This challenge is solved using temorary talble:
# Calculate the royalty of each sale for each author
CREATE TEMPORARY TABLE publication.sales_royalty
SELECT titles.title_id,
		authors.au_id, 
        sales.ord_num,
        sales.qty,
        (titles.price * sales.qty * titles.royalty / 100 *titleauthor.royaltyper / 100) AS royalty_per_sales
FROM publication.authors
	INNER JOIN publication.titleauthor
		ON authors.au_id = titleauthor.au_id
	INNER JOIN publication.titles
		ON titleauthor.title_id = titles.title_id
	INNER JOIN publication.sales
		ON sales.title_id = titles.title_id
GROUP BY titles.title_id, authors.au_id, authors.au_fname, sales.ord_num, sales.qty;
      
# Using the output from Step 1 as a temp table, aggregate the total royalties for each title for each author.
	
CREATE TEMPORARY TABLE total_royalty
SELECT title_id, au_id, SUM(royalty_per_sales) AS royalty_per_title
FROM sales_royalty
GROUP BY title_id, au_id;


# Using the output from Step 2 as a temp table, calculate the total profits of each author
# by aggregating the advances and total royalties of each title.
SELECT au_id, sum(royalty_per_title + titles.advance) AS aggregate_royalty
FROM total_royalty
INNER JOIN titles
	ON total_royalty.title_id = titles.title_id
GROUP BY au_id
ORDER BY aggregate_royalty DESC
LIMIT 3;



## Challenge 2 - Alternative Solution
# Solutions using derived table
# Here in this solutions one derived table royalty_per_title is created and inner 
#join with the titles table to get aggregated royalty per author 

SELECT 	royalty_per_title.au_id, 
		SUM(per_title_royalty + titles.advance) AS total_royalty
FROM publication.titles
INNER JOIN (
		SELECT titles.title_id,
			authors.au_id,         
			SUM(titles.price * sales.qty * titles.royalty / 100 *titleauthor.royaltyper / 100) AS per_title_royalty
		FROM publication.authors
			INNER JOIN publication.titleauthor
				ON authors.au_id = titleauthor.au_id
			INNER JOIN publication.titles
				ON titleauthor.title_id = titles.title_id
			INNER JOIN publication.sales
				ON sales.title_id = titles.title_id
		GROUP BY titles.title_id, authors.au_id) AS royalty_per_title
ON titles.title_id = royalty_per_title.title_id
GROUP BY royalty_per_title.au_id
ORDER BY total_royalty DESC
LIMIT 3;

##  Challenge 3 -->> most_profiting_authors

CREATE TABLE publication.most_profiting_authors AS SELECT
au_id, sum(royalty_per_title + titles.advance) AS aggregate_royalty
FROM total_royalty
INNER JOIN publication.titles
	ON total_royalty.title_id = titles.title_id
GROUP BY au_id
ORDER BY aggregate_royalty DESC;

# wiew the table most_profiting_authors
SELECT * FROM publication.most_profiting_authors;

# add foreign key to table to make relations with the database:
ALTER TABLE publication.most_profiting_authors
ADD FOREIGN KEY (au_id) REFERENCEs authors(au_id);
