-- Selection od database to be used
USE publications;

/* Challenge 1 */

-- STEP 1 -- 
DROP TEMPORARY TABLE IF EXISTS `STEP 1`;

CREATE TEMPORARY TABLE IF NOT EXISTS `STEP 1` 
SELECT S.title_id AS `TITLE ID`, S.au_id AS `AUTHOR ID`, S.price*sales.qty*S.royalty/100*S.royaltyper/100 AS Royalty
FROM
(SELECT titleauthor.au_id, titleauthor.title_id, titleauthor.royaltyper, titles.price, titles.royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id) AS S
INNER JOIN sales
ON S.title_id = sales.title_id;

-- STEP 2 -- 
DROP TEMPORARY TABLE IF EXISTS `STEP 2`;

CREATE TEMPORARY TABLE IF NOT EXISTS `STEP 2`
SELECT `TITLE ID`, `AUTHOR ID`, SUM(Royalty) AS `Aggregated royalties`
FROM `STEP 1`
GROUP BY `AUTHOR ID`, `TITLE ID`;

-- STEP 3 -- 
SELECT `AUTHOR ID`, SUM(`Aggregated royalties`) AS `Total profits`
FROM `STEP 2`
GROUP BY `AUTHOR ID`
ORDER BY `Total profits` DESC
LIMIT 3;

/* Challenge 2 */

-- STEP 1 -- 
SELECT S.title_id AS `TITLE ID`, S.au_id AS `AUTHOR ID`, S.price*sales.qty*S.royalty/100*S.royaltyper/100 AS Royalty
FROM
(SELECT titleauthor.au_id, titleauthor.title_id, titleauthor.royaltyper, titles.price, titles.royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id) AS S
INNER JOIN sales
ON S.title_id = sales.title_id;

-- STEP 2 -- 
SELECT `TITLE ID`, `AUTHOR ID`, SUM(Royalty) AS `Aggregated royalties`
FROM 
(SELECT S1.title_id AS `TITLE ID`, S1.au_id AS `AUTHOR ID`, S1.price*sales.qty*S1.royalty/100*S1.royaltyper/100 AS Royalty
FROM
(SELECT titleauthor.au_id, titleauthor.title_id, titleauthor.royaltyper, titles.price, titles.royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id) AS S1
INNER JOIN sales
ON S1.title_id = sales.title_id) AS S2
GROUP BY `AUTHOR ID`, `TITLE ID`;

-- STEP 3 -- 
SELECT `AUTHOR ID`, SUM(`Aggregated royalties`) AS `Total profits`
FROM
(SELECT `TITLE ID`, `AUTHOR ID`, SUM(Royalty) AS `Aggregated royalties`
FROM 
(SELECT S1.title_id AS `TITLE ID`, S1.au_id AS `AUTHOR ID`, S1.price*sales.qty*S1.royalty/100*S1.royaltyper/100 AS Royalty
FROM
(SELECT titleauthor.au_id, titleauthor.title_id, titleauthor.royaltyper, titles.price, titles.royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id) AS S1
INNER JOIN sales
ON S1.title_id = sales.title_id) AS S2
GROUP BY `AUTHOR ID`, `TITLE ID`) AS S3
GROUP BY `AUTHOR ID`
ORDER BY `Total profits` DESC
LIMIT 3;


/* Challenge 3 */
DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE IF NOT EXISTS most_profiting_authors
(SELECT `AUTHOR ID`, SUM(`Aggregated royalties`) AS `Total profits`
FROM
(SELECT `TITLE ID`, `AUTHOR ID`, SUM(Royalty) AS `Aggregated royalties`
FROM 
(SELECT S1.title_id AS `TITLE ID`, S1.au_id AS `AUTHOR ID`, S1.price*sales.qty*S1.royalty/100*S1.royaltyper/100 AS Royalty
FROM
(SELECT titleauthor.au_id, titleauthor.title_id, titleauthor.royaltyper, titles.price, titles.royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id) AS S1
INNER JOIN sales
ON S1.title_id = sales.title_id) AS S2
GROUP BY `AUTHOR ID`, `TITLE ID`) AS S3
GROUP BY `AUTHOR ID`
ORDER BY `Total profits` DESC);

-- Let's check what is within table 'most_profiting_authors'
SELECT *
FROM most_profiting_authors;

