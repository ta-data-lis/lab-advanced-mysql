
/* STEP 1 */
SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'Author ID', titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 as 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

/* STEP 2 */
SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'Author ID', SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1,2
ORDER BY 3 DESC;

/* STEP 3 */
SELECT titleauthor.au_id AS 'Author ID',sum(titles.advance) as 'Advance' , sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as Royalty, sum(titles.advance) + sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Advance + Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3;



/* CHALLENGE 2 */

/* STEP 1 */
CREATE TEMPORARY TABLE most_profitable
SELECT titleauthor.title_id AS `Title ID`, titleauthor.au_id AS `Author ID`, advance as Advance, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 as Royalty
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

/* STEP 2 */
SELECT `Title ID`, `Author ID`, sum(Royalty) as `Total Royalty` from most_profitable
GROUP BY 1,2
ORDER BY 3 DESC;

/* STEP 3 */
SELECT `Title ID`, `Author ID`, sum(Advance) as `Total Advance`, sum(Royalty) as `Total Royalty` from most_profitable
GROUP BY 1,2
ORDER BY 3 desc
limit 3;


/* CHALLENGE 3 */ 

CREATE TABLE most_profiting_authors

SELECT titleauthor.au_id AS 'Author ID', sum(advance) + sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty + Advance'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 2 DESC;
