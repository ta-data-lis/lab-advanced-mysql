# PART ONE
CREATE TEMPORARY TABLE part1
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale_per_author
FROM authors
LEFT JOIN titleauthor
ON titleauthor.au_id = authors.au_id 
LEFT JOIN titles
ON titles.title_id = titleauthor.title_id
LEFT JOIN sales
ON sales.title_id = titles.title_id
;

#PART TWO
CREATE TEMPORARY TABLE part2;
SELECT title_id, au_id , SUM(royalty_per_sale_per_author) AS total_royalties
FROM part1
GROUP BY title_id, au_id; 

DROP TABLE part2;

#PART THREE
SELECT part2.au_id, SUM(part2.total_royalties)+ titles.advance AS profit
FROM part2
LEFT JOIN titles ON part2.title_id = titles.title_id
GROUP BY part2.au_id;