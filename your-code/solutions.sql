
# Challenge 1

#step 1
select title_id, au_id, prices * quantity * royalty / 100 * royalties_book / 100 as sales_royalty from (
select titles.title_id, authors.au_id, titles.price as prices,  sales.qty as quantity,  titles.royalty as royalty, titleauthor.royaltyper as royalties_book
from titles
join  sales on sales.title_id = titles.title_id
join  titleauthor on titleauthor.title_id = titles.title_id
join  authors on titleauthor.au_id = authors.au_id
) 
first_royalties;

#step 2 


CREATE TEMPORARY TABLE publications.sales_summary
select title_id, au_id, sum(prices * quantity * royalty / 100 * royalties_book / 100)as sales_royalty, advance
from (
select titles.advance, titles.title_id, authors.au_id, titles.price as prices,  sales.qty as quantity,  titles.royalty as royalty, titleauthor.royaltyper as royalties_book
from titles
join  sales on sales.title_id = titles.title_id
join  titleauthor on titleauthor.title_id = titles.title_id
join  authors on titleauthor.au_id = authors.au_id
join roysched on titles.title_id = roysched.title_id
) first_royalties
group by au_id, title_id;

select au_id, sales_royalty from  publications.sales_summary
;


#step 3
select au_id, sum(sales_royalty + advance) as profits from publications.sales_summary
group by au_id;



#Challenge 3

CREATE TEMPORARY TABLE publications.sales_total
select au_id, sum(sales_royalty + advance) as profits from publications.sales_summary
group by au_id;

CREATE TABLE most_profiting_authors
AS
SELECT au_id , profits
  FROM  sales_total;

