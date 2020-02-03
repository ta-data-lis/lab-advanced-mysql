#Calculate the royalties of each sales for each author
select ta.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as sales_royalty
from titleauthor as ta
left join titles as t on ta.title_id = t.title_id 
left join sales  as s on t.title_id = s.title_id;

#Step 2: Aggregate the total royalties for each title for each author
create temporary table royalty_a_t
select ta.title_id, ta.au_id, sum((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100)) as sales_royalty, t.advance
from titleauthor as ta
left join titles as t on ta.title_id = t.title_id 
left join sales  as s on t.title_id = s.title_id
group by ta.au_id, t.title_id;
describe  royalty_a_t;

#Step 3: Calculate the total profits of each author;

select royalty_a_t.au_id, sum(sales_royalty + royalty_a_t.advance) as profits
from royalty_a_t
group by  royalty_a_t.au_id 
order by profits desc
limit 3;

#Challenge 2 - Alternative Solution

select au_id, sum(sales_royalty + advance) as profits
from (select ta.title_id, ta.au_id, sum((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100)) as sales_royalty, t.advance
from titleauthor as ta
left join titles as t on ta.title_id = t.title_id 
left join sales  as s on t.title_id = s.title_id
group by ta.au_id, t.title_id) summary
group by  au_id
order by profits desc
limit 3; 

#Challenge 3
create table most_profiting_authors
select au_id, sum((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100)+ advance) as profits                  
from titleauthor as ta
left join titles as t on ta.title_id = t.title_id 
left join sales  as s on t.title_id = s.title_id
group by  au_id
order by profits desc;

