DROP TABLE royalty_author;
DROP TABLE royalty_author_summary;
DROP TABLE most_profiting_authors;

/* Challenge 1 - Most Profiting Authors
Step 1: Calculate the royalties of each sales for each author*/

CREATE TEMPORARY TABLE publications.royalty_author
SELECT ta.au_id, tt.title_id, tt.advance, tt.price * s.qty * tt.royalty / 100 * ta.royaltyper / 100 AS ROYALTIES
FROM titleauthor ta
JOIN
titles tt ON ta.title_id = tt.title_id
JOIN
publications.sales s ON tt.title_id = s.title_id;

-- Step 2: Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE publications.royalty_author_summary
SELECT au_id, title_id, SUM(advance) AS ADVANCE, SUM(ROYALTIES) AS ROYALTIES
FROM royalty_author
GROUP BY au_id, title_id;

-- Step 3: Calculate the total profits of each author
SELECT au_id AS AUTHOR, SUM(ADVANCE), SUM(ROYALTIES)
FROM royalty_author_summary
GROUP BY au_id;

/* Challenge 2 - Alternative Solution
Using derived tables now */

SELECT au_id AS AUTHOR, SUM(ADVANCE) AS ADVANCE, SUM(ROYALTIES) AS ROYALTIES
FROM
	(SELECT au_id, title_id, SUM(advance) AS ADVANCE, SUM(ROYALTIES) AS ROYALTIES
	FROM
		(SELECT ta.au_id, tt.title_id, tt.advance, tt.price * s.qty * tt.royalty / 100 * ta.royaltyper / 100 AS ROYALTIES
		FROM titleauthor ta
		JOIN
		titles tt ON ta.title_id = tt.title_id
		JOIN
		sales s ON tt.title_id = s.title_id) ra
	GROUP BY au_id, title_id) rsa
GROUP BY au_id;

-- Challenge 3
CREATE TABLE most_profiting_authors SELECT au_id, SUM(ADVANCE + ROYALTIES) AS PROFIT FROM
    royalty_author_summary
GROUP BY au_id
ORDER BY PROFIT DESC;

SELECT * FROM most_profiting_authors;