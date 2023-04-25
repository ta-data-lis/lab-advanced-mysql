/* Challenge 1 - Most Profiting Authors */

# Creating a temp table with the royalties per sale per author

CREATE TEMPORARY TABLE publications.royalties_per_sale
SELECT authors.au_id, titles.title_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS royalties
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id = authors.au_id
INNER JOIN publications.titles
ON titles.title_id = titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
INNER JOIN publications.roysched
ON roysched.title_id = titles.title_id;

# Creating a temp table with the total royalties per title per author

CREATE TEMPORARY TABLE publications.total_royalties_per_title
SELECT au_id, title_id, sum(royalties) AS total_royalties
FROM publications.royalties_per_sale
GROUP BY au_id, title_id;

# Query to find the 3 most profiting authors

SELECT au_id, total_royalties
FROM publications.total_royalties_per_title
GROUP BY au_id
ORDER BY total_royalties DESC
LIMIT 3;


/* Challenge 2 - Alternative Solution */

# using derived tables
SELECT au_id, total_royalties
FROM (SELECT au_id, title_id, sum(royalties) AS total_royalties
		FROM (
			SELECT authors.au_id, titles.title_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS royalties
			FROM publications.authors
			INNER JOIN publications.titleauthor
			ON titleauthor.au_id = authors.au_id
			INNER JOIN publications.titles
			ON titles.title_id = titleauthor.title_id
			INNER JOIN publications.sales
			ON sales.title_id = titles.title_id
			INNER JOIN publications.roysched
			ON roysched.title_id = titles.title_id) AS royalties_per_sale
		GROUP BY au_id, title_id) AS total_royalties_per_title
GROUP BY au_id
ORDER BY total_royalties DESC
LIMIT 3;

/* Challenge 3 */

CREATE TABLE publications.most_profiting_authors
SELECT au_id, total_royalties AS profits
FROM publications.total_royalties_per_title
GROUP BY au_id;