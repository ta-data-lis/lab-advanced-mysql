-- Challenge 1
-- step1
SELECT titles.title_id, titleauthor.au_id,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
ORDER BY Royalty DESC;

-- Step2
SELECT titles.title_id, titleauthor.au_id, advance,
sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY Royalty DESC;

-- step3
SELECT titles.title_id, titleauthor.au_id,
sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) AS profits
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY profits DESC;

-- Challenge 2

-- Challenge 3
create table most_profiting_authors(
SELECT titles.title_id, titleauthor.au_id,
sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + titles.advance) AS profits
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY profits DESC
limit 3);

