
/* CHALLENGE 1 */

/* Step 1 */
CREATE TEMPORARY TABLE publications.royalties_per_sale
SELECT 
t.title_id AS 'TITLE_ID',
a.au_id AS 'AUTHOR_ID',
(t.price * sal.qty * t.royalty / 100 * ta.royaltyper / 100) AS 'ROYALTY'
FROM publications.sales AS sal
INNER JOIN publications.titleauthor as ta
ON sal.title_id = ta.title_id
INNER JOIN publications.authors as a
ON ta.au_id = a.au_id
INNER JOIN publications.titles as t
ON ta.title_id = t.title_id;

/* Step 2 */
CREATE TEMPORARY TABLE publications.royalties_per_title
SELECT 
AUTHOR_ID, 
TITLE_ID,
SUM(ROYALTY) AS 'ROYALTY_PER_TITLE'
FROM publications.royalties_per_sale
GROUP BY AUTHOR_ID, TITLE_ID;

/* Step 3 */
SELECT 
AUTHOR_ID, 
SUM(ROYALTY_PER_TITLE) AS 'ROYALTY_PER_AUTHOR'
FROM publications.royalties_per_title
GROUP BY AUTHOR_ID
ORDER BY SUM(ROYALTY_PER_TITLE) DESC
LIMIT 3;

/* CLEAR TEMP TABLE */
DROP TABLE publications.royalties_per_sale;
DROP TABLE publications.royalties_per_title;


/* CHALLENGE 2 */
SELECT 
AUTHOR_ID, 
SUM(ROYALTY_PER_TITLE) AS 'ROYALTY_PER_AUTHOR'
FROM
	(SELECT 
	AUTHOR_ID, 
	TITLE_ID,
	SUM(ROYALTY) AS 'ROYALTY_PER_TITLE'
	FROM 
		(SELECT 
		t.title_id AS 'TITLE_ID',
		a.au_id AS 'AUTHOR_ID',
		(t.price * sal.qty * t.royalty / 100 * ta.royaltyper / 100) AS 'ROYALTY'
		FROM publications.sales AS sal
		INNER JOIN publications.titleauthor as ta
		ON sal.title_id = ta.title_id
		INNER JOIN publications.authors as a
		ON ta.au_id = a.au_id
		INNER JOIN publications.titles as t
		ON ta.title_id = t.title_id) AS royalties_per_sale
	GROUP BY AUTHOR_ID, TITLE_ID) AS royalties_per_title
GROUP BY AUTHOR_ID
ORDER BY SUM(ROYALTY_PER_TITLE) DESC
LIMIT 3;


/* CHALLENGE 3 */
CREATE TABLE publications.most_profiting_authors (
au_id VARCHAR(11),
profits VARCHAR(80)
)
SELECT 
AUTHOR_ID AS au_id, 
SUM(ROYALTY_PER_TITLE) AS profits
FROM
	(SELECT 
	AUTHOR_ID, 
	TITLE_ID,
	SUM(ROYALTY + ADVANCE) AS 'ROYALTY_PER_TITLE'
	FROM 
		(SELECT 
		t.title_id AS 'TITLE_ID',
		a.au_id AS 'AUTHOR_ID',
		(t.price * sal.qty * t.royalty / 100 * ta.royaltyper / 100) AS 'ROYALTY',
        t.advance AS 'ADVANCE'
		FROM publications.sales AS sal
		INNER JOIN publications.titleauthor as ta
		ON sal.title_id = ta.title_id
		INNER JOIN publications.authors as a
		ON ta.au_id = a.au_id
		INNER JOIN publications.titles as t
		ON ta.title_id = t.title_id) AS royalties_per_sale
	GROUP BY AUTHOR_ID, TITLE_ID) AS royalties_per_title
GROUP BY AUTHOR_ID
ORDER BY SUM(ROYALTY_PER_TITLE) DESC;

SELECT *
FROM publications.most_profiting_authors;
