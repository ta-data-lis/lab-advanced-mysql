USE publications;

# Challenge 1 - Calculate royalties

#Step 1: Calculate the royalties of each sales for each author
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'royalties'
FROM titleauthor
INNER JOIN authors ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id;

# Step 2: Aggregate the total royalties for each title for each author
SELECT titles.title_id, authors.au_id, SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'royalties'
FROM titleauthor
INNER JOIN authors ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id;

#Step 3: Calculate the total profits of each author
SELECT authors.au_id, SUM((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) as 'profits'
FROM titleauthor
INNER JOIN authors ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id
ORDER BY profits DESC
LIMIT 3;

# Challenge 2 - Alternative Solution

# Use temporary table
CREATE TEMPORARY TABLE au_royalties
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'royalties', titles.advance
FROM titleauthor
INNER JOIN authors ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id;

#CREATE TEMPORARY TABLE au_royalties_sum
SELECT title_id, au_id, advance, SUM(au_royalties) FROM au_royalties
GROUP BY title_id, au_id;

SELECT au_id, SUM(royalties + advance) as 'profits'
FROM au_royalties_sum
ORDER BY profits DESC
LIMIT 3;

# Challenge 3

CREATE TABLE most_profiting_authors
SELECT authors.au_id, SUM((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) as 'profits'
FROM titleauthor
INNER JOIN authors ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id
ORDER BY profits DESC
LIMIT 3;