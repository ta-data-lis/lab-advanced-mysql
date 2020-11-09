-- Challenge 1

-- STEP 1

USE publications;

SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'AUTHOR ID', titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 as 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

-- STEP 2

SELECT titleauthor.title_id AS 'Title ID', titleauthor.au_id AS 'AUTHOR ID', sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- STEP 3

SELECT titleauthor.au_id AS 'AUTHOR ID',sum(advance) as 'Advance' , sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty', sum(advance) + sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty + Advance'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3;

-- Challenge 2

-- STEP 1

CREATE TEMPORARY TABLE cal_authors

SELECT titleauthor.title_id AS TitleID, titleauthor.au_id AS AUTHORID, advance as Advance, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100 as Royalty
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id;

-- STEP 2

CREATE TEMPORARY TABLE cal_authors_step2

SELECT TitleID, AUTHORID, sum(Advance) as sum_advance, sum(Royalty) as sum_royalty from cal_authors
GROUP BY 1,2
ORDER BY 3 DESC;

DROP TABLE IF EXISTS cal_authors_step2;

-- STEP 3

SELECT * from cal_authors_step2

-- Challenge 3

CREATE TABLE final_cal_authors

SELECT titleauthor.au_id AS 'AUTHOR ID', sum(advance) + sum(sales.qty) *sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper/ 100) as 'Royalty + Advance'
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON sales.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 2 DESC;

select * from final_cal_authors