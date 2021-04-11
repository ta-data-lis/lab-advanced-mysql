-- STEP 1
SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'Author ID', titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 AS 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

-- STEP 2
SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'Author ID', SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) AS 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- STEP 3
SELECT titleauthor.au_id AS 'Author ID', SUM(titles.advance) AS 'Advance' , SUM(sales.qty) *SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) AS Royalty, SUM(titles.advance) + SUM(sales.qty) *SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) AS 'Advance + Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3;

-- CHALLENGE 2

CREATE TEMPORARY TABLE most_profitable
SELECT titleauthor.title_id AS `Title ID`, titleauthor.au_id AS `Author ID`, advance AS Advance, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 AS Royalty
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

SELECT `Title ID`, `Author ID`, SUM(Royalty) AS `Total Royalty` FROM most_profitable
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT `Title ID`, `Author ID`, SUM(Advance) AS `Total Advance`, SUM(Royalty) AS `Total Royalty` FROM most_profitable
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

-- CHALLENGE 3

CREATE TABLE most_profiting_authors

SELECT titleauthor.au_id AS 'Author ID', SUM(advance) + SUM(sales.qty) *SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) AS 'Royalty + Advance'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 2 DESC;