USE  labselect;

#Challenge 1 - Step1:

SELECT titleauthor.title_id as TitleID, titleauthor.au_id AS AuthorID, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
Left JOIN sales sales ON sales.title_id = titleauthor.title_id 
ORDER by 3 DESC

#Challenge 1 - Step2:


SELECT titleauthor.title_id as TitleID, titleauthor.au_id AS AuthorID, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
Left JOIN sales sales ON sales.title_id = titleauthor.title_id 
Group by 1,2 
ORDER by 3 DESC;

#Challenge 1 - Step3 with title:

SELECT titleauthor.au_id AS AuthorID, titleauthor.title_id as TitleID, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + sum(titles.advance) as sales_royalty_advance from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales sales ON sales.title_id = titleauthor.title_id 
Group by 1,2
ORDER by  3 DESC;

#Challenge 1 - Step3 without title:

SELECT titleauthor.au_id AS AuthorID, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + sum(titles.advance) as sales_royalty_advance from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales sales ON sales.title_id = titleauthor.title_id 
Group by 1
ORDER by  2 DESC;

#Challenge 2 Temporary table:

CREATE TEMPORARY TABLE sales_titles_royalties
SELECT titleauthor.au_id AS AuthorID, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + sum(titles.advance) as sales_royalty_advance from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales sales ON sales.title_id = titleauthor.title_id 
Group by 1
ORDER by  2 DESC;  


SELECT AuthorID, sales_royalty_advance FROM sales_titles_royalties

#Challenge 3:

CREATE TABLE most_profiting_authors 
SELECT titleauthor.au_id AS AuthorID, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + sum(titles.advance) as sales_royalty_advance from titleauthor titleauthor
LEFT JOIN titles titles ON titleauthor.title_id = titles.title_id 
LEFT JOIN sales sales ON sales.title_id = titleauthor.title_id 
Group by 1
ORDER by  2 DESC; 

Select * FROM most_profiting_authors








