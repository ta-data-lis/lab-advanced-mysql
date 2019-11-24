# Lab | Advanced MySQL

## Introduction
## Challenge 1 - Most Profiting Authors
# In order to solve this problem, it is important for you to keep the following points in mind:
#* In table `sales`, a title can appear several times. The royalties need to be calculated for each sale.
#* Despite a title can have multiple `sales` records, the advance must be calculated only once for each title.
#* In your eventual solution, you need to sum up the following profits for each individual author:
    #* All advances which is calculated exactly once for each title.
    #* All royalties in each sale.

# Step 1: Calculate the royalties of each sales for each author
# Write a SELECT query to obtain the following output:

# Title ID
SELECT titles.title_id, titles.price, titles.royalty
FROM titles;

# AuthorID
SELECT titleauthor.au_id, titleauthor.royaltyper
FROM titleauthor;

# Combining everything
SELECT titles.title_id, titles.price, titles.royalty, titleauthor.au_id, titleauthor.royaltyper, SUM(qty) AS title_quantity
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY title_id, au_id;

# Royalty of each sale for each author
# sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100

SELECT titles.title_id, (titles.price * SUM(qty) * (titles.royalty/100) * (titleauthor.royaltyper/100)) AS royalty, titleauthor.au_id
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY title_id, au_id; 

### Step 2: Aggregate the total royalties for each title for each author
# Using the output from Step 1, write a query to obtain the following output:

SELECT titles.title_id, titles.advance, (titles.price * SUM(qty) * (titles.royalty/100) * (titleauthor.royaltyper/100)) AS royalty, titleauthor.au_id
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY title_id, au_id; 

### Step 3: Calculate the total profits of each author
# Now that each title has exactly one row for each author where the advance and royalties are available, we are ready to obtain the eventual output. Using the output from Step 2, write a query to obtain the following output:
# Author ID
# Profits of each author by aggregating the advance and total royalties of each title
# Sort the output based on a total profits from high to low, and limit the number of rows to 3.

SELECT au_id, SUM(advance + royalty) AS total_profit
FROM (SELECT titles.title_id, titles.advance, (titles.price * SUM(qty) * (titles.royalty/100) * (titleauthor.royaltyper/100)) AS royalty, titleauthor.au_id
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY title_id, au_id) summary
GROUP BY au_id
ORDER BY au_id DESC
LIMIT 3; 

## Challenge 2 - Alternative Solution
# In the previous challenge, you may have developed your solution in either of the following ways:
# Either way you have used, we'd like you to try the other way. Include your alternative solution in `solutions.sql`.

CREATE TEMPORARY TABLE publications.profit_summary
SELECT titles.title_id, titles.advance, (titles.price * SUM(qty) * (titles.royalty/100) * (titleauthor.royaltyper/100)) AS royalty, titleauthor.au_id
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
GROUP BY title_id, au_id; 

SELECT * FROM publications.profit_summary;

SELECT au_id, SUM(advance + royalty) AS total_profit
FROM publications.profit_summary
GROUP BY au_id
ORDER BY au_id DESC
LIMIT 3;

## Challenge 3
#Elevating from your solution in Challenge 1 & 2, create a permanent table named `most_profiting_authors` to hold the data about the most profiting authors. The table should have 2 columns:
#* `au_id` - Author ID
#* `profits` - The profits of the author aggregating the advances and royalties

CREATE TABLE publications.most_profiting_authors
SELECT au_id, SUM(advance + royalty) AS profits
FROM publications.profit_summary
GROUP BY au_id;