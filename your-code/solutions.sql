#Challenge 1 - Most Profiting Authors

#Step 1: Calculate the royalties of each sales for each author
#sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100

Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id;

#Step 2: Aggregate the total royalties for each title for each author

Select titles.title_id, authors.au_id ,sum(sales_royalty) as sales_values from titles, authors, (Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id) as total_sales
group by titles.title_id; 

#Step 3: Calculate the total profits of each author

Select authors.au_id, sales_values from titles, authors, (Select titles.title_id, authors.au_id ,sum(sales_royalty) as sales_values from titles, authors, (Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id) as total_sales
group by titles.title_id)  as money
group by authors.au_id
order by sales_values desc;

#Challenge 2 - Alternative Solution

#Step 1: Calculate the royalties of each sales for each author

Create temporary table royalities_au
Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id;

#Step 2: Aggregate the total royalties for each title for each author

Create temporary table royalities_title
Select titles.title_id, authors.au_id ,sum(sales_royalty) as sales_values from titles, authors, (Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id) as total_sales
group by titles.title_id; 

#Step 3: Calculate the total profits of each author

create temporary table profits_a
Select authors.au_id, sales_values from titles, authors, (Select titles.title_id, authors.au_id ,sum(sales_royalty) as sales_values from titles, authors, (Select titles.title_id, au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty
from titles, sales, titleauthor
group by au_id) as total_sales
group by titles.title_id)  as money
group by authors.au_id
order by sales_values desc;

#Challenge 3

create table most_profiting_authors
as (select * from profits_a);

select * from profits_a;




