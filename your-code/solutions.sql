/*Challenge 1*/

CREATE temporary TABLE royal_sales1
Select titles.title_id, titles.royalty, titles.price, titles.advance, sales.qty
from sub_queries.sales sales
LEFT join sub_queries.titles titles
on sales.title_id = titles.title_id;

CREATE temporary TABLE royal_titles
Select au.au_id, roy.title_id, roy.royalty, roy.price, roy.advance, roy.qty, au.royaltyper
from sub_queries.titleauthor au
LEFT join sub_queries.royal_sales1 roy
on au.title_id = roy.title_id;

CREATE temporary TABLE royal_sum_ad
Select au_id, title_id, sum((price * qty * royalty / 100 * royaltyper / 100)+advance) as royaltys
from royal_titles
group by au_id, title_id;

Select au_id, title_id, royaltys
from royal_sum_ad
order by royaltys desc
limit 3;

/* 2*/

Select au_id, title_id, royaltys
from (Select au_id, title_id, sum((price * qty * royalty / 100 * royaltyper / 100)+advance) as royaltys
from (Select au.au_id, roy.title_id, roy.royalty, roy.price, roy.advance, roy.qty, au.royaltyper
from sub_queries.titleauthor au
LEFT join sub_queries.royal_sales1 roy
on au.title_id = roy.title_id)summary
group by au_id, title_id)summary
order by royaltys desc
limit 3;

/* 3 */

Create table most_profiting_authors
Select au_id, title_id, royaltys
from (Select au_id, title_id, sum((price * qty * royalty / 100 * royaltyper / 100)+advance) as royaltys
from (Select au.au_id, roy.title_id, roy.royalty, roy.price, roy.advance, roy.qty, au.royaltyper
from sub_queries.titleauthor au
LEFT join sub_queries.royal_sales1 roy
on au.title_id = roy.title_id)summary
group by au_id, title_id)summary
order by royaltys desc
limit 3;




