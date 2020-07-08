/* 1st chalenge */


SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

drop table royalties;



CREATE TEMPORARY TABLE royalties
SELECT au.au_id AS "AUTHOR ID",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;


SELECT `AUTHOR ID`,`TITLE ID`,
SUM(`ROYALTIES`)
FROM royalties 
Group by `TITLE ID`, `AUTHOR ID`;


drop table  sum_royalties;

CREATE TEMPORARY TABLE sum_royalties 
SELECT au.au_id AS "AUTHOR ID", 
t.advance AS "ADVANCE",
t.title_id AS "TITLE ID",
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "ROYALTIES"
FROM sales AS s
INNER JOIN titles AS t
ON s.title_id = t.title_id
INNER JOIN titleauthor AS ta
ON ta.title_id = t.title_id
INNER JOIN authors as au
ON au.au_id = ta.au_id;

SELECT `AUTHOR ID`,
SUM(`ROYALTIES`), 
SUM(`ADVANCE`)
FROM sum_royalties 
Group by  `AUTHOR ID`;




