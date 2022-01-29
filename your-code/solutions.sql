USE publications;

-- Challenge 1 - Most Profiting Authors
select titleauthor.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor on authors.au_id = titleauthor.au_id
inner join titles on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY authors.au_id
ORDER BY sales_royalty DESC;

select titleauthor.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor on authors.au_id = titleauthor.au_id
inner join titles on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY titleauthor.title_id, authors.au_id
ORDER BY sales_royalty DESC;

select authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor on authors.au_id = titleauthor.au_id
inner join titles on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY authors.au_id
ORDER BY sales_royalty DESC
LIMIT 3;

-- Challenge 2 - Alternative Solution
DROP TABLE temp1;

CREATE TEMPORARY TABLE temp1 (
SELECT authors.au_id,
       titles.title_id,
       titles.price,
       titles.royalty,
       titleauthor.royaltyper,
       sales.ord_num,
       sales.qty
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id
);

SELECT * FROM temp1;

select temp1.title_id, temp1.au_id, (temp1.price * temp1.qty * temp1.royalty / 100 * temp1.royaltyper / 100) as sales_royalty
from temp1
GROUP BY temp1.au_id
ORDER BY sales_royalty DESC;

select temp1.title_id, temp1.au_id, (temp1.price * temp1.qty * temp1.royalty / 100 * temp1.royaltyper / 100) as sales_royalty
from temp1
GROUP BY temp1.title_id, temp1.au_id
ORDER BY sales_royalty DESC;

select temp1.au_id, (temp1.price * temp1.qty * temp1.royalty / 100 * temp1.royaltyper / 100) as sales_royalty
from temp1
GROUP BY temp1.au_id
ORDER BY sales_royalty DESC
LIMIT 3;

-- Challenge 3
CREATE TABLE most_profiting_authors (
select authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor on authors.au_id = titleauthor.au_id
inner join titles on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY authors.au_id
ORDER BY sales_royalty DESC
);
