#Challenge 1 - using derived tables
select Author_ID, (sum(table_2.Royalty)+sum(titles.advance)) as Profits
from 
(select Title_ID, Author_ID, sum(sales_royalty) as Royalty
from 
(select titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor 
on authors.au_id = titleauthor.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join sales
on sales.title_id = titles.title_id) as table_1
group by Title_ID, Author_ID) as table_2
inner join titles
on titles.title_id = table_2.Title_ID
group by Author_ID
order by Profits desc
limit 3;

#Challenge 2
create temporary table table_1_c2
select titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor 
on authors.au_id = titleauthor.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join sales
on sales.title_id = titles.title_id;

create temporary table table_2_c2
select Title_ID, Author_ID, sum(sales_royalty) as Royalty
from table_1_c2
group by Title_ID, Author_ID;

select Author_ID, (sum(table_2_c2.Royalty)+sum(titles.advance)) as Profits
from table_2_c2
inner join titles
on titles.title_id = table_2_c2.Title_ID
group by Author_ID
order by Profits desc
limit 3;

#Challenge 3
create table most_profiting_authors
select Author_ID, (sum(table_2.Royalty)+sum(titles.advance)) as Profits
from 
(select Title_ID, Author_ID, sum(sales_royalty) as Royalty
from 
(select titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
inner join titleauthor 
on authors.au_id = titleauthor.au_id
inner join titles
on titles.title_id = titleauthor.title_id
inner join sales
on sales.title_id = titles.title_id) as table_1
group by Title_ID, Author_ID) as table_2
inner join titles
on titles.title_id = table_2.Title_ID
group by Author_ID
order by Profits desc
limit 3;



