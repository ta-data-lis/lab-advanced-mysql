
### Challenge 1 - Most Profiting Authors

#Step 1: Step 1: Calculate the royalties of each sales for each author
#Step 2
DROP TEMPORARY TABLE IF EXISTS step1;
create temporary table step1
select authors.au_id, titles.title_id, sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) as sales_royalty 
from titleauthor  
left join authors on titleauthor.au_id = authors.au_id 
left join titles on titleauthor.title_id = titles.title_id
left join sales on titles.title_id = sales.title_id
group by au_id;

select * from step1;

### Step 3: Calculate the total profits of each author
select au_id, sum(sales_royalty)
from step1
group by au_id;

## Challenge 2 - Alternative Solution
select au_id, sum(sales_royalty)
from (select authors.au_id, titles.title_id, sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) as sales_royalty 
from titleauthor  
left join authors on titleauthor.au_id = authors.au_id 
left join titles on titleauthor.title_id = titles.title_id
left join sales on titles.title_id = sales.title_id
group by au_id)summary
group by au_id;

## Challenge 3
create table most_profiting_authors
select au_id, sum(profits)
from (select authors.au_id, titles.title_id, sum((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) as profits
from titleauthor  
left join authors on titleauthor.au_id = authors.au_id 
left join titles on titleauthor.title_id = titles.title_id
left join sales on titles.title_id = sales.title_id
group by au_id)summary
group by au_id;