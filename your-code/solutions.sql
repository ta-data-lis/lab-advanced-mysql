USE publications;

SELECT * FROM titles;

# Challenge 1 - Most Profiting Authors

# Step 1: Calculate the royalties of each sales for each author
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id;

# Step 2: Aggregate the total royalties for each title for each author

# Using subquery
SELECT title_id, author_id, sum(royalty_per_sale)
FROM (SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id
) step1
GROUP BY title_id, author_id;

# Using without subquery
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id
GROUP BY title_id, author_id;


# Step 3: Calculate the total profits of each author

# Using subquery
SELECT author_id, (royalty_per_sale + titles.advance) AS total_profit
FROM (
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id
GROUP BY title_id, author_id
) table2
LEFT JOIN titles ON table2.title_id = titles.title_id
GROUP BY author_id
ORDER BY total_profit desc
LIMIT 3;

# Using without subquery
SELECT titleauthor.au_id AS author_id, (sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) + (titles.advance)) AS total_profit
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id
GROUP BY author_id
ORDER BY total_profit DESC
LIMIT 3;



# Challenge 2 - Alternative Solution (Using temporary tables)

CREATE TEMPORARY TABLE authorroyalty
SELECT titles.title_id AS title_id, titleauthor.au_id AS author_id, sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale
FROM sales
left join titles on titles.title_id = sales.title_id
left join titleauthor on titles.title_id = titleauthor.title_id
GROUP BY title_id, author_id;

SELECT author_id, (royalty_per_sale + titles.advance) AS total_profit
FROM authorroyalty
LEFT JOIN titles ON authorroyalty.title_id = titles.title_id
GROUP BY author_id
ORDER BY total_profit desc
LIMIT 3;


# Challenge 3

CREATE TABLE most_profiting_authors (
au_id VARCHAR(11),
profits DECIMAL(19,4)
);

SELECT * FROM most_profiting_authors;

INSERT INTO most_profiting_authors (au_id, profits)
VALUES
('722-51-5454', '15021.528000000000'),
('427-17-2319', '8050.000000000000'),
('846-92-7186', '8050.000000000000');





