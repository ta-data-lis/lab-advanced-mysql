#Challenge 1

SELECT au_id, advance + sales_royalties AS total_profits
FROM(
SELECT title_id, au_id, sum(sale_royalty) as sales_royalties, advance
FROM(
SELECT T.title_id , A.au_id, price * qty * royalty / 100 * royaltyper / 100 AS "sale_royalty", advance
FROM authors A
INNER JOIN titleauthor TA ON A.au_id = TA.au_id
INNER JOIN titles T ON TA.title_id = T.title_id
INNER JOIN sales S ON T.title_id = S.title_id)step1
GROUP BY title_id, au_id)step2
GROUP BY au_id ORDER BY total_profits DESC
LIMIT 3;

#Challenge 2

CREATE TEMPORARY TABLE step_1
SELECT T.title_id , A.au_id, price * qty * royalty / 100 * royaltyper / 100 AS "sale_royalty", advance
FROM authors A
INNER JOIN titleauthor TA ON A.au_id = TA.au_id
INNER JOIN titles T ON TA.title_id = T.title_id
INNER JOIN sales S ON T.title_id = S.title_id;

CREATE TEMPORARY TABLE step_2
SELECT title_id, au_id, sum(sale_royalty) as sales_royalties, advance
FROM step_1
GROUP BY title_id, au_id;

CREATE TEMPORARY TABLE step_3
SELECT au_id, advance + sales_royalties AS total_profits
FROM step_2
GROUP BY au_id ORDER BY total_profits DESC
LIMIT 3;

SELECT * FROM step_3;

#Challenge 3

CREATE TABLE most_profiting_authors AS 
SELECT * FROM step_3;