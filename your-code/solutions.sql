  
/* Challenge 1*/
WITH
	table1 AS (
		SELECT tt.title_id,
		ta.au_id,
		tt.advance,
		tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		FROM publications.titles AS tt
		INNER JOIN publications.sales AS sa
			ON tt.title_id = sa.title_id
		INNER JOIN publications.titleauthor AS ta
			ON tt.title_id = ta.title_id),
		
	table2 AS (	
		SELECT table1.advance, table1.title_id, table1.au_id, sum(table1.sales_royalties) AS total_sales
		FROM table1
		GROUP BY table1.advance,table1.title_id, table1.au_id)
	
		
SELECT table2.au_id, sum(table2.advance) + sum(table2.total_sales) AS profit
FROM table2
GROUP BY table2.au_id
ORDER BY profit DESC
lIMIT 3;
	

/* Challenge 2*/
SELECT table2.au_id, sum(advance) + sum(table2.total_sales) AS profit
FROM (	
	SELECT table1.advance, table1.title_id, table1.au_id, sum(table1.sales_royalties) AS total_sales
	FROM (
		SELECT tt.title_id,
		ta.au_id,
		tt.advance,
		tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		FROM publications.titles AS tt
		INNER JOIN publications.sales AS sa
			ON tt.title_id = sa.title_id
		INNER JOIN publications.titleauthor AS ta
			ON tt.title_id = ta.title_id) AS table1
	GROUP BY table1.advance, table1.title_id, table1.au_id) AS table2
GROUP BY table2.au_id
ORDER BY profit DESC
lIMIT 3;


/*Challenge 3*/
CREATE TABLE publications.most_profiting_authors AS
SELECT temp.au_id, temp.profit AS profits
FROM (
		WITH
		table1 AS (
			SELECT tt.title_id,
			ta.au_id,
			tt.advance,
			tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
			FROM publications.titles AS tt
			INNER JOIN publications.sales AS sa
				ON tt.title_id = sa.title_id
			INNER JOIN publications.titleauthor AS ta
				ON tt.title_id = ta.title_id),
			
		table2 AS (	
			SELECT table1.advance, table1.title_id, table1.au_id, sum(table1.sales_royalties) AS total_royalties
			FROM table1
			GROUP BY table1.advance, table1.title_id, table1.au_id)
	
	SELECT table2.au_id, sum(table2.advance) + sum(table2.total_royalties) AS profit
	FROM table2
	GROUP BY table2.au_id
	ORDER BY profit DESC) AS temp;