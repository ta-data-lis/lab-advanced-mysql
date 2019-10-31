USE publications;

# # CHALLENGE 1:
# Step 1
CREATE TEMPORARY TABLE step1
SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
	FROM authors a
	LEFT JOIN titleauthor ta ON ta.au_id = a.au_id
	LEFT JOIN titles t ON ta.title_id = t.title_id
	LEFT JOIN sales s ON s.title_id = t.title_id;

# Step 2
CREATE TEMPORARY TABLE step2
SELECT title_id, au_id, SUM(sales_royalty) as aggregated_royalties
	FROM step1
	GROUP BY title_id, au_id;

# Step 3
# ordered to facilitate comparison with challenge 2
SELECT s.au_id, SUM(s.aggregated_royalties+t.advance) as profits
	FROM step2 s
	LEFT JOIN titles t ON t.title_id = s.title_id
	GROUP BY s.au_id
	ORDER BY au_id;


# CHALLENGE 2:
# Step 1
SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
	FROM authors a
	LEFT JOIN titleauthor ta ON ta.au_id = a.au_id
	LEFT JOIN titles t ON ta.title_id = t.title_id
	LEFT JOIN sales s ON s.title_id = t.title_id;

# Step 2
SELECT title_id, au_id, SUM(sales_royalty) as aggregated_royalties
	FROM (SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
			FROM titles t
			LEFT JOIN titleauthor ta ON ta.title_id = t.title_id
			LEFT JOIN authors a ON ta.au_id = a.au_id
			JOIN sales s ON s.title_id = t.title_id)summary
	GROUP BY title_id, au_id;

# Step 3
# ordered to facilitate comparison with step 1
SELECT s.au_id, SUM(s.aggregated_royalties+t.advance) as profits
	FROM (SELECT title_id, au_id, SUM(sales_royalty) as aggregated_royalties
			FROM (SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty
					FROM titles t
					JOIN titleauthor ta ON ta.title_id = t.title_id
					JOIN authors a ON ta.au_id = a.au_id
					JOIN sales s ON s.title_id = t.title_id)summary
			GROUP BY title_id, au_id) s
	JOIN titles t ON t.title_id = s.title_id
	GROUP BY s.au_id
	ORDER BY au_id;


# CHALLENGE 3:
# create table
CREATE TABLE most_profiting_authors(
	id INT PRIMARY KEY AUTO_INCREMENT,
	au_id varchar(11),
	profits FLOAT
);

# populate table
# using step2 table from challenge 1
INSERT INTO most_profiting_authors (au_id, profits)
SELECT s.au_id, SUM(s.aggregated_royalties+t.advance) as profits
	FROM step2 s
	LEFT JOIN titles t ON t.title_id = s.title_id
	GROUP BY s.au_id
	ORDER BY au_id;
