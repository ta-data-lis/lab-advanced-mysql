/* Challenge 1*/
WITH
	t1 AS (
		SELECT tt.title_id,
		ta.au_id,
		tt.advance,
		tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		FROM publications.titles AS tt
		INNER JOIN publications.sales AS sa
			ON tt.title_id = sa.title_id
		INNER JOIN publications.titleauthor AS ta
			ON tt.title_id = ta.title_id),
		
	t2 AS (	
		SELECT t1.advance, t1.title_id, t1.au_id, sum(t1.sales_royalties) AS total_sales
		FROM t1
		GROUP BY t1.advance,t1.title_id, t1.au_id)
	
		
SELECT t2.au_id, sum(t2.advance) + sum(t2.total_sales) AS profit
FROM t2
GROUP BY t2.au_id
ORDER BY profit DESC
lIMIT 3;
	

/* Challenge 2*/
SELECT t2.au_id, sum(advance) + sum(t2.total_sales) AS profit
FROM (	
	SELECT t1.advance, t1.title_id, t1.au_id, sum(t1.sales_royalties) AS total_sales
	FROM (
		SELECT tt.title_id,
		ta.au_id,
		tt.advance,
		tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		FROM publications.titles AS tt
		INNER JOIN publications.sales AS sa
			ON tt.title_id = sa.title_id
		INNER JOIN publications.titleauthor AS ta
			ON tt.title_id = ta.title_id) AS t1
	GROUP BY t1.advance, t1.title_id, t1.au_id) AS t2
GROUP BY t2.au_id
ORDER BY profit DESC
lIMIT 3;


/*Challenge 3*/
CREATE TABLE publications.most_profiting_authors AS
SELECT temp.au_id, temp.profit AS profits
FROM (
		WITH
		t1 AS (
			SELECT tt.title_id,
			ta.au_id,
			tt.advance,
			tt.price * sa.qty * tt.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
			FROM publications.titles AS tt
			INNER JOIN publications.sales AS sa
				ON tt.title_id = sa.title_id
			INNER JOIN publications.titleauthor AS ta
				ON tt.title_id = ta.title_id),
			
		t2 AS (	
			SELECT t1.advance, t1.title_id, t1.au_id, sum(t1.sales_royalties) AS total_royalties
			FROM t1
			GROUP BY t1.advance, t1.title_id, t1.au_id)
	
	SELECT t2.au_id, sum(t2.advance) + sum(t2.total_royalties) AS profit
	FROM t2
	GROUP BY t2.au_id
	ORDER BY profit DESC) AS temp;

