USE publications;


/*Challenge 1 - Most Profiting Authors*/
/*Using temporary tables*/

/*Step 1: Calculate the royalties of each sales for each author*/
CREATE TEMPORARY TABLE royalties_sale_author
SELECT titles.title_id, titleauthor.au_id, 
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS sales_royalty
FROM titleauthor
INNER JOIN sales
ON sales.title_id = titleauthor.title_id
INNER JOIN titles
ON titles.title_id = sales.title_id;

SELECT * FROM royalties_sale_author;

/*Step 2: Aggregate the total royalties for each title for each author*/
CREATE TEMPORARY TABLE total_royalties_title_author
SELECT title_id, au_id, SUM(sales_royalty) AS aggregated_royalties
FROM royalties_sale_author
GROUP BY title_id, au_id;

SELECT * FROM total_royalties_title_author;


/*Step 3: Calculate the total profits of each author*/
SELECT au_id, SUM(aggregated_royalties + titles.advance) AS profits
FROM total_royalties_title_author
INNER JOIN titles
ON titles.title_id = total_royalties_title_author.title_id
GROUP BY au_id
ORDER BY profits DESC
LIMIT 3;


/*Challenge 2 - Alternative Solution*/
/*Using derived tables*/

SELECT au_id, SUM(aggregated_royalties + advance) AS profits
FROM (
    SELECT titleauthor.au_id, titleauthor.title_id, titles.advance,
    SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS aggregated_royalties
    FROM titleauthor
    INNER JOIN sales 
    ON sales.title_id = titleauthor.title_id
    INNER JOIN titles 
    ON titles.title_id = titleauthor.title_id
    GROUP BY titleauthor.au_id, titleauthor.title_id, titles.advance
	) AS author_royalties
GROUP BY au_id
ORDER BY profits DESC
LIMIT 3;


/*Challenge 3*/

CREATE TABLE most_profiting_authors (au_id VARCHAR(11), profits FLOAT);

INSERT INTO most_profiting_authors
SELECT au_id, SUM(aggregated_royalties + advance) AS profits
FROM (
    SELECT titleauthor.au_id, titleauthor.title_id, titles.advance,
    SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS aggregated_royalties
    FROM titleauthor
    INNER JOIN sales 
    ON sales.title_id = titleauthor.title_id
    INNER JOIN titles 
    ON titles.title_id = titleauthor.title_id
    GROUP BY titleauthor.au_id, titleauthor.title_id, titles.advance
) AS author_royalties
GROUP BY au_id
ORDER BY profits DESC;

SELECT * FROM most_profiting_authors