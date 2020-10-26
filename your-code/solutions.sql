/*challenge 1 step 1*/
CREATE TEMPORARY TABLE step_1a
SELECT S.title_id, TA.au_id, (T.price * S.qty * T.royalty / 100  ) as royalty_value
FROM sales S
INNER JOIN titles T ON S.title_id = T.title_id
INNER JOIN titleauthor TA ON S.title_id = TA.title_id
ORDER BY S.title_id

/*challenge 1 step 2*/
CREATE TEMPORARY TABLE step_2a
SELECT title_id, au_id, sum(royalty_value) as Total_royalty
FROM step_1a
GROUP BY title_id, au_id
ORDER BY title_id, au_id

/*challenge 1 step 3*/
SELECT au_id, sum(Total_royalty) as total_earned_by_author
FROM step_2a
GROUP BY au_id 
ORDER BY total_earned_by_author DESC

/*challenge 2*/
SELECT  au_id, sum(Total_royalty) as total_earned_by_author FROM
	( SELECT title_id, au_id, sum(royalty_value) as Total_royalty FROM
		(SELECT S.title_id, TA.au_id, (T.price * S.qty * T.royalty / 100  ) as royalty_value
		FROM sales S
		INNER JOIN titles T ON S.title_id = T.title_id
		INNER JOIN titleauthor TA ON S.title_id = TA.title_id) as d1
	GROUP BY d1.title_id, d1.au_id) as d2
GROUP BY d2.au_id
ORDER BY total_earned_by_author DESC


/*challenge 3*/
CREATE TABLE author_profit
SELECT au_id, sum(Totals) as total_sold
FROM step_2
GROUP BY au_id 
ORDER BY total_sold DESC
