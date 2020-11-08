USE database_name3;

--CHALLENGE 1

--STEP1

SELECT titleauthor.title_id AS TITLE ,titleauthor.au_id AS AUTHORS ,titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS ROYALTY FROM titleauthor 

LEFT JOIN titles on titles.title_id = titleauthor.title_id
LEFT JOIN sales on sales.title_id = titleauthor.title_id
ORDER BY 3 DESC;

--STEP2


SELECT titleauthor.title_id AS TITLE ,titleauthor.au_id AS AUTHORS ,SUM( titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS ROYALTY FROM titleauthor 

LEFT JOIN titles on titles.title_id = titleauthor.title_id
LEFT JOIN sales on sales.title_id = titleauthor.title_id
GROUP BY 1,2;

--STEP3

SELECT titleauthor.au_id AS AUTHORS ,sum(titles.advance) AS ADVANCE, SUM( titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS ROYALTI, sum(titles.advance) + SUM( titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS ADVANCE_ROYALTI FROM titleauthor 

LEFT JOIN titles on titles.title_id = titleauthor.title_id
LEFT JOIN sales on sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3;



--CHALLENGE 2

-- AS I UNDERSTAND THE USE OF TEMPORARY TABLE AND AFTER DOING CHALLENGE 1, IN ORDER TO TAKE ADVANTADGE TO THEIR USE, THIS IS HOW
-- I WOULD USE IT TO OPTIMIZE TIME AND NOT TO REPEAT SAME QUERIES. 

--Step1


CREATE TEMPORARY TABLE tempor_authors

SELECT titleauthor.title_id AS TITLE ,titleauthor.au_id AS AUTHORS, titLes.advance AS ADVANCE ,titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS ROYALTY FROM titleauthor 

LEFT JOIN titles on titles.title_id = titleauthor.title_id
LEFT JOIN sales on sales.title_id = titleauthor.title_id

--Step2


SELECT TITLE, AUTHORS, SUM(ROYALTY) FROM tempor_authors
GROUP BY 1,2



--Step3

SELECT AUTHORS, SUM(ADVANCE) AS ADVANCE, SUM(ROYALTY) AS ROYALTI, SUM(ADVANCE)+SUM(ROYALTY) AS ADVANCE_ROYALTI FROM tempor_authors
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3


--CHALLENGE 3


CREATE TABLE most_profiting_authors

SELECT titleauthor.au_id AS AUTHORS ,sum(titles.advance) + SUM( titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS ADVANCE_ROYALTI FROM titleauthor 

LEFT JOIN titles on titles.title_id = titleauthor.title_id
LEFT JOIN sales on sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM most_profiting_authors