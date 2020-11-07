USE database_name;

with ROYALTIES_PER_SALE AS(
	select titles.title_id,
		   titleauthor.au_id,
		   (titles.price * sales.qty * titles.royalty / 100) * (titleauthor.royaltyper / 100) as sales_royalty
 	    from titles
    	inner JOIN titleauthor on titleauthor.title_id = titles.title_id
    	inner join sales on sales.title_id = titles.title_id
),


AGG_ROYALTIES as (
	   select title_id,
	   		  au_id,
	          SUM(sales_royalty) as sales_royalty
	   from ROYALTIES_PER_SALE
	   group by title_id,au_id
)

select au_id,
	   sum(sales_royalty) as sales_royalty
from AGG_ROYALTIES
group by au_id
order by sales_royalty desc 
limit 3;
	  
create temporary table ROYALTIES_PER_SALE
as
select titles.title_id,
		   titleauthor.au_id,
		   (titles.price * sales.qty * titles.royalty / 100) * (titleauthor.royaltyper / 100) as sales_royalty
from titles
    inner JOIN titleauthor on titleauthor.title_id = titles.title_id
    inner join sales on sales.title_id = titles.title_id;
	   
create temporary table AGG_ROYALTIES
as
select title_id,
	   au_id,
	   SUM(sales_royalty) as sales_royalty
from ROYALTIES_PER_SALE
group by title_id,au_id;
	  
select au_id,
	   sum(sales_royalty) as sales_royalty
from AGG_ROYALTIES
group by au_id
order by sales_royalty desc 
limit 3;
	  
create table if not exists most_profiting_authors
as 
select au_id,
	   sum(sales_royalty) as profits
from AGG_ROYALTIES
group by au_id;



