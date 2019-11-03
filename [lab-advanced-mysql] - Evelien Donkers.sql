#Challenge 1 - Most Profiting Authors
#Step1
SELECT titleauthor.au_id, titleauthor.title_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper /100)
FROM titleauthor, titles, sales;

#Step2
SELECT titleauthor.au_id, titleauthor.title_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper /100)
FROM titleauthor, titles, sales
group by au_id, title_id;

#Step3
SELECT titleauthor.au_id, titles.advance + SUM(titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper /100))
as Profits FROM titleauthor, titles, sales
group by au_id
ORDER BY profits DESC LIMIT 3;

#Challenge 2 - Alternative Solution
SELECT titleauthor.au_id,  titles.advance + SUM(titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper /100))
as profits FROM titleauthor
LEFT JOIN titles ON titles.title_id	= titleauthor.title_id
LEFT JOIN sales ON sales.title_id = titles.title_id
group by au_id
ORDER BY profits DESC LIMIT 3;	


#Challenge 3
DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE most_profiting_authors (
Author_ID VARCHAR(45), 
Profits decimal(19,4),
PRIMARY KEY (Author_ID));

INSERT INTO most_profiting_authors 
    (Author_ID, Profits)
VALUES 
(486-29-1786, 4033359.882000000000),
(998-72-3567, 4026719.911500000000),
(213-46-8915, 4025391.917400000000); 
