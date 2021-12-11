USE publications;

/*Challenge 1 - Most Profiting Authors*/

SELECT t5.au_id, ROUND((t5.total_royalties + t6.advance)) AS profit
FROM (	SELECT t4.title_id, t4.au_id, SUM(t4.sales_royalty) AS total_royalties
		FROM (  SELECT t1.title_id, t2.au_id, (t1.price * t3.qty * t1.royalty / 100 * t2.royaltyper / 100) AS sales_royalty
				FROM titles AS t1
				INNER JOIN titleauthor AS t2 ON t1.title_id = t2.title_id
				INNER JOIN sales AS t3 ON t2.title_id = t3.title_id  ) AS t4
		GROUP BY t4.au_id, t4.title_id  ) t5
INNER JOIN titles t6 ON t5.title_id = t6.title_id
ORDER BY profit DESC
LIMIT 3;

/*Challenge 2 - Alternative Solution*/
CREATE TEMPORARY TABLE temp_1 (
SELECT t1.title_id, t2.au_id, (t1.price * t3.qty * t1.royalty / 100 * t2.royaltyper / 100) AS sales_royalty
FROM titles AS t1
INNER JOIN titleauthor AS t2 ON t1.title_id = t2.title_id
INNER JOIN sales AS t3 ON t2.title_id = t3.title_id );

CREATE TEMPORARY TABLE temp_2 (
SELECT title_id, au_id, SUM(sales_royalty) AS total_royalties
FROM temp_1
GROUP BY au_id, title_id );

SELECT temp_2.au_id, ROUND((temp_2.total_royalties + titles.advance)) AS profit
FROM temp_2
INNER JOIN titles ON temp_2.title_id = titles.title_id;

/*Challenge 3*/
CREATE TABLE publications.most_profiting_authors AS 
		SELECT temp_2.au_id, ROUND((temp_2.total_royalties + titles.advance)) AS profit
		FROM temp_2
		INNER JOIN titles ON temp_2.title_id = titles.title_id;

SELECT *
FROM publications.most_profiting_authors
ORDER BY profit DESC
LIMIT 3;