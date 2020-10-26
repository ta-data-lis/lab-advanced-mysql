/*Challenge1*/

/*Step1*/
CREATE TEMPORARY TABLE publication.Royalties_Sales_Author
SELECT publication.titleauthor.au_id, publication.titleauthor.title_id,(Step1_2.price * Step1_2.qty * Step1_2.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publication.titleauthor
INNER JOIN 
(SELECT publication.titles.title_id, price, royalty, Step1.qty
FROM publication.titles
INNER JOIN
(SELECT title_id, qty
FROM publication.sales) AS Step1
ON publication.titles.title_id=Step1.title_id) AS Step1_2
ON publication.titleauthor.title_id=Step1_2.title_id;

/*Step2*/
CREATE TEMPORARY TABLE publication.Royalties_Title_Author
SELECT title_id AS Title_ID, au_id AS Author_ID, sum(Sales_Royalty) AS Royalties
FROM publication.Royalties_Sales_Author
GROUP BY Author_ID, Title_ID;

/*Step3*/
SELECT Author_ID, sum(Advance.advance+publication.Royalties_Title_Author.Royalties) AS Profit
FROM publication.Royalties_Title_Author
LEFT JOIN
(SELECT title_id, advance
FROM publication.titles) AS Advance
ON publication.Royalties_Title_Author.Title_ID=Advance.title_id
GROUP BY publication.Royalties_Title_Author.Author_ID, publication.Royalties_Title_Author.Title_ID
ORDER BY Profit DESC
LIMIT 3;

/*Challenge2*/

/*Step1*/
SELECT publication.titleauthor.au_id, publication.titleauthor.title_id,(Step1_2.price * Step1_2.qty * Step1_2.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publication.titleauthor
INNER JOIN 
(SELECT publication.titles.title_id, price, royalty, Step1.qty
FROM publication.titles
INNER JOIN
(SELECT title_id, qty
FROM publication.sales) AS Step1
ON publication.titles.title_id=Step1.title_id) AS Step1_2
ON publication.titleauthor.title_id=Step1_2.title_id;

/*Step2*/
SELECT title_id AS Title_ID, au_id AS Author_ID, sum(Sales_Royalty) AS Royalties
FROM (SELECT publication.titleauthor.au_id, publication.titleauthor.title_id,(Step1_2.price * Step1_2.qty * Step1_2.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publication.titleauthor
INNER JOIN 
(SELECT publication.titles.title_id, price, royalty, Step1.qty
FROM publication.titles
INNER JOIN
(SELECT title_id, qty
FROM publication.sales) AS Step1
ON publication.titles.title_id=Step1.title_id) AS Step1_2
ON publication.titleauthor.title_id=Step1_2.title_id) AS Royalties_Title_Author
GROUP BY Author_ID, Title_ID;

/*Step3*/
SELECT Author_ID, sum(Advance.advance+publication.Royalties_Title_Author.Royalties) AS Profit
FROM (SELECT title_id AS Title_ID, au_id AS Author_ID, sum(Sales_Royalty) AS Royalties
FROM (SELECT publication.titleauthor.au_id, publication.titleauthor.title_id,(Step1_2.price * Step1_2.qty * Step1_2.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publication.titleauthor
INNER JOIN 
(SELECT publication.titles.title_id, price, royalty, Step1.qty
FROM publication.titles
INNER JOIN
(SELECT title_id, qty
FROM publication.sales) AS Step1
ON publication.titles.title_id=Step1.title_id) AS Step1_2
ON publication.titleauthor.title_id=Step1_2.title_id) AS Royalties_Title_Author
GROUP BY Author_ID, Title_ID) AS Royalties_Title_Author
LEFT JOIN
(SELECT title_id, advance
FROM publication.titles) AS Advance
ON publication.Royalties_Title_Author.Title_ID=Advance.title_id
GROUP BY publication.Royalties_Title_Author.Author_ID, publication.Royalties_Title_Author.Title_ID
ORDER BY Profit DESC
LIMIT 3;

/*Challenge3*/

CREATE TABLE publication.most_profiting_authors
SELECT Author_ID, sum(Advance.advance+publication.Royalties_Title_Author.Royalties) AS Profit
FROM (SELECT title_id AS Title_ID, au_id AS Author_ID, sum(Sales_Royalty) AS Royalties
FROM (SELECT publication.titleauthor.au_id, publication.titleauthor.title_id,(Step1_2.price * Step1_2.qty * Step1_2.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM publication.titleauthor
INNER JOIN 
(SELECT publication.titles.title_id, price, royalty, Step1.qty
FROM publication.titles
INNER JOIN
(SELECT title_id, qty
FROM publication.sales) AS Step1
ON publication.titles.title_id=Step1.title_id) AS Step1_2
ON publication.titleauthor.title_id=Step1_2.title_id) AS Royalties_Title_Author
GROUP BY Author_ID, Title_ID) AS Royalties_Title_Author
LEFT JOIN
(SELECT title_id, advance
FROM publication.titles) AS Advance
ON publication.Royalties_Title_Author.Title_ID=Advance.title_id
GROUP BY publication.Royalties_Title_Author.Author_ID, publication.Royalties_Title_Author.Title_ID
ORDER BY Profit DESC;



