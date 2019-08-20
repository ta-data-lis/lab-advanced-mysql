select * from publications.titles;

#1
select titles.title_id, titleauthor.au_id,
(titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) AS sales_royalty
from titles
inner join titleauthor on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY (titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) DESC;

# 2
select titles.title_id, titleauthor.au_id,
sum((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100)) AS sales_royalty
from titles
inner join titleauthor on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY sum((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100)) DESC;

# 3
## Temp Tables:
create temporary table royalties_per_title_author_1_summay
select titles.title_id AS AUTHOR_ID, titleauthor.au_id AS TITLE_ID,
(titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) AS SALES_ROYALTY
from titles
inner join titleauthor on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY (titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100) DESC;

SELECT * FROM royalties_per_title_author_1_summay;

Select TITLE_ID, AUTHOR_ID, sum(SALES_ROYALTY) AS TOTAL_ROYALTIES from royalties_per_title_author_1_summay
GROUP BY AUTHOR_ID, TITLE_ID
ORDER BY sum(SALES_ROYALTY) DESC;


# 3rd Challenge 
select titleauthor.au_id,
sum((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100))+titles.advance AS profits
from titles
inner join titleauthor on titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
GROUP BY titles.title_id, titleauthor.au_id
ORDER BY sum((titles.price * sales.qty * titles.royalty) / (100 * titleauthor.royaltyper / 100)) DESC;
