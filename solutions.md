# lab-advanced-mysql
# Challenge 1
# Step 1
select titles.title_id as `Title ID`, titleauthor.au_id as `Author ID`, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_Sales
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY Royalty_Sales DESC;
# Step2
drop table if exists royalties;

# We use the query of the previous step to create a temporary table and then perform the query on that table
create temporary table royalties
select titles.title_id, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_Sales
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY Royalty_Sales DESC;

select title_id, au_id, sum(Royalty_Sales) as aggregated_royalties
from royalties
group by title_id, au_id
order by aggregated_royalties desc;

# step 3
select  titles.title_id, titleauthor.au_id, 
sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)+titles.advance) AS Profits
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
group by titles.title_id, titleauthor.au_id
order by Profits desc
limit 3;

# Challenge 2
# 2.1
select title_id, au_id, sum(Royalty_Sales) as summed_royalties
from (
select titles.title_id as title_id, titleauthor.au_id as au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_Sales
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY Royalty_Sales DESC) step_1
group by title_id, au_id
order by summed_royalties DESC;

# 2.2
select title_id, au_id, sum(Royalty_Sales + advance) as Profits
from (
select titles.title_id as title_id, titleauthor.au_id as au_id, titles.advance as advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty_Sales
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
ORDER BY Royalty_Sales DESC) step_2
group by title_id, au_id
order by Profits DESC;

# Challenge 3
drop table if exists profits;

create temporary table mysql_lab_select.profits
select  titles.title_id, titleauthor.au_id, 
sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)+titles.advance) AS Profits
from titles
INNER Join titleauthor ON titleauthor.title_id = titles.title_id
inner join sales on titles.title_id = sales.title_id
group by titles.title_id, titleauthor.au_id
order by Profits desc;

drop table if exists most_profitable_authors;

create table most_profitable_authors
select au_id, profits
from profits;

select * from most_profitable_authors;
