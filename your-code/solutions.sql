USE Publications;
#chalenge 1

#Step 1
SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM titles t
LEFT JOIN titleauthor ta
ON t.title_id = ta.title_id
LEFT JOIN sales s 
ON t.title_id = s.title_id;

#Step 2
SELECT title_id, au_id, sum(sales_royalty) AS agg_sales_royalty
FROM (SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM titles t
LEFT JOIN titleauthor ta
ON t.title_id = ta.title_id
LEFT JOIN sales s 
ON t.title_id = s.title_id) summary
GROUP BY summary.title_id, summary.au_id;

#step 3
SELECT au_id, sum(agg_sales_royalty) + sum(t.advance) AS agg_royalties
FROM (SELECT title_id, au_id, sum(sales_royalty) AS agg_sales_royalty
FROM (SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
FROM titles t
LEFT JOIN titleauthor ta
ON t.title_id = ta.title_id
LEFT JOIN sales s 
ON t.title_id = s.title_id) summary
GROUP BY title_id, au_id) sum2
LEFT JOIN titles t
ON sum2.title_id = t.title_id
GROUP BY au_id
ORDER BY agg_royalties DESC
LIMIT 3;


# Chalange 2 

CREATE TEMPORARY TABLE step1
SELECT t.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS Royalty
FROM titles t
LEFT JOIN titleauthor ta
ON t.title_id = ta.title_id
LEFT JOIN sales s
ON t.title_id = s.title_id;

SELECT *
FROM step1;

CREATE TEMPORARY TABLE step02
SELECT s1.title_id, s1.au_id, sum(s1.Royalty) AS tot_roy
FROM step1 s1
GROUP BY title_id, au_id;

SELECT *
FROM step02;

CREATE TEMPORARY TABLE step3
SELECT s2.au_id, sum(s2.tot_roy) + sum(t.advance) AS total_revenue
FROM step02 s2
LEFT JOIN titles t
ON s2.title_id = t.title_id
GROUP BY au_id
ORDER BY total_revenue DESC
LIMIT 3;

SELECT *
FROM step3;

#chalenge 3 ##Make table queries -  LESSON ACTION QUERIES 

CREATE TABLE most_profiting_authors (id INT PRIMARY KEY AUTO_INCREMENT, au_id VARCHAR(20), total_revenue FLOAT);

INSERT INTO most_profiting_authors (au_id, total_revenue)
SELECT s2.au_id, sum(s2.tot_roy) + sum(t.advance) AS total_revenue
FROM step02 s2
LEFT JOIN titles t
ON s2.title_id = t.title_id
GROUP BY au_id;






