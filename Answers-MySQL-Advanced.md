/* Challenge 1 */
WITH T1 AS (SELECT pb.title_id,
				   ta.au_id,
				   pb.advance,
				   pb.price * sa.qty * pb.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		      FROM publications.titles AS pb
						JOIN publications.sales AS sa	
							ON pb.title_id = sa.title_id
						JOIN publications.titleauthor AS ta
							ON pb.title_id = ta.title_id),

	T2 AS ( SELECT T1.advance, T1.title_id, T1.au_id, SUM(T1.sales_royalties) AS total_sales
			  FROM T1
		  GROUP BY 1, 2, 3)

SELECT T2.au_id,
	   SUM(T2.advance) + SUM(T2.Total_sales) AS profit
	  FROM T2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3; 

/* Challenge 2 */
/* Step 1 */
 CREATE TEMPORARY TABLE publications.royalties
	SELECT pb.title_id,
		   ta.au_id,
		   pb.advance,
		   pb.price * sa.qty * pb.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
	FROM  publications.titles AS pb
						JOIN publications.sales AS sa	
							ON pb.title_id = sa.title_id
						JOIN publications.titleauthor AS ta
							ON pb.title_id = ta.title_id;
  /* Step 2 */                          
	SELECT *
    FROM publications.royalties;

CREATE TEMPORARY TABLE publications.total_sales
SELECT title_id, 
	   au_id, 
       SUM(sales_royalties) + advance AS 'Royalty_per_title'
  FROM publications.royalties
GROUP BY 1, 2;

	SELECT *
    FROM publications.total_sales;

SELECT au_id,
	   SUM(Royalty_per_title) AS 'Royalty_per_author'
  FROM publications.total_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

/*CLEANING TEMPORARY TABLES */
DROP TABLE IF EXISTS publications.total_sales
DROP TABLE IF EXISTS publications.royalties


/* Challenge 3 */

CREATE TABLE publications.most_profitable_authors AS
SELECT prof.au_id, prof.profit AS profits
FROM (
		WITH T1 AS (SELECT pb.title_id,
						   ta.au_id,
						   pb.advance,
						   pb.price * sa.qty * pb.royalty / 100 * ta.royaltyper / 100 AS sales_royalties
		              FROM publications.titles AS pb
								JOIN publications.sales AS sa	
								ON pb.title_id = sa.title_id
								JOIN publications.titleauthor AS ta
								ON pb.title_id = ta.title_id),
                                
			 T2 AS ( SELECT T1.advance, T1.title_id, T1.au_id, SUM(T1.sales_royalties) AS total_sales
			           FROM T1
		           GROUP BY 1, 2, 3)
                   
			SELECT T2.au_id,
			SUM(T2.advance) + SUM(T2.Total_sales) AS profit
			FROM T2
			GROUP BY 1
			ORDER BY 2 DESC) AS prof;
    
SELECT *
FROM publications.most_profitable_authors;
    
  
