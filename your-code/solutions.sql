#Challenge 1

#step 1
SELECT titles.title_id AS TitleID, authors.au_id AS AuthorID, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS SalesRoyalty
FROM publications.titles
JOIN publications.titleauthor ON titles.title_id = titleauthor.title_id
JOIN publications.authors ON titleauthor.au_id = authors.au_id
JOIN publications.sales ON titles.title_id = sales.title_id;

#step2
SELECT titles.title_id AS TitleID, authors.au_id AS AuthorID, SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS SalesRoyalty, titles.advance AS Advance
FROM publications.titles
JOIN publications.titleauthor ON titles.title_id = titleauthor.title_id
JOIN publications.authors ON titleauthor.au_id = authors.au_id
JOIN publications.sales ON titles.title_id = sales.title_id
GROUP BY TitleID, AuthorID
ORDER BY SalesRoyalty DESC;
#I follow the steps but I don't understand fully the output...

#step 3
SELECT authors.au_id AS AuthorID, (SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + SUM(titles.advance)) AS Profits
FROM publications.titles
JOIN publications.titleauthor ON titles.title_id = titleauthor.title_id
JOIN publications.authors ON titleauthor.au_id = authors.au_id
JOIN publications.sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, AuthorID
ORDER BY Profits DESC;
#Will need feedback and explanations on this pliiiiiise
#Did I just do derived tables?


#Challenge 2
#Do the above with temp tables. I have to work on this

#Challenge 3
CREATE TABLE most_profiting_authors
SELECT authors.au_id AS AuthorID, (SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + SUM(titles.advance)) AS Profits
FROM publications.titles
JOIN publications.titleauthor ON titles.title_id = titleauthor.title_id
JOIN publications.authors ON titleauthor.au_id = authors.au_id
JOIN publications.sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, AuthorID
ORDER BY Profits DESC;
