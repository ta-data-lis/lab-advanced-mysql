 USE publications;

# Challenge 1 - Most Profiting Authors

# Calculate the royalty of each sale for each author.
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS 'royalties'
FROM titleauthor
INNER JOIN AUTHORS ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id;

# From Step 1 output as a temp table, aggregate the total royalties for each title for each author.
SELECT titles.title_id, authors.au_id, SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS 'royalties'
FROM titleauthor
INNER JOIN AUTHORS ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id;

# Using the output from Step 2 as a temp table, calculate the total profits of each author by aggregating the advances and total royalties of each title.
SELECT authors.au_id, SUM((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) AS 'profits'
FROM titleauthor
INNER JOIN AUTHORS ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id
ORDER BY profits DESC
LIMIT 3;

# Challenge 2 - Alternative Solution

# I did not understand what would be the alternative solution if not moving the summary into
# a subquery

# Challenge 3

# I'm lost.