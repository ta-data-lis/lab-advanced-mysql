/*Challenge 1*/
/*Step 1- calculate the royalties of each sales for each author*/
select * 
from (select publications.titles.title_id as TitleID, 
publications.titleauthor.au_id as AuthorID, 
publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100 as RoyaltyEachSale
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id) as royalties_each_sale;


/*Step 2 - aggregate the total royalties for each title for each author*/
select *
from (select publications.titles.title_id as TitleID, 
publications.titleauthor.au_id as AuthorID, 
sum ((publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100) as RoyaltyEachSale) 
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id) as royalties_each_sale
group by AuthorID, TitleID;


/*Step 3 - calculate the total profits of each author*/
select*
from (select publications.titleauthor.au_id as AuthorID, 
sum ((publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100) as RoyalityEachSale)
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id) as royalties_each_sale
group by AuthorID
order by RoyaltyEachSale desc
limit 3;


/*challenge 2 - temporary table*/
create temporary table royaltytable
select publications.titles.title_id as TitleID, 
publications.titleauthor.au_id as AuthorID, 
publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100 as RoyaltyEachSale
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id;

/*query the temporary table */
select * from
royaltytable;

create temporary table royaltytable
select publications.titles.title_id as TitleID, 
publications.titleauthor.au_id as AuthorID, 
sum ((publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100) as RoyaltyEachSale) 
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id
group by AuthorID, TitleID;

create temporary table royaltytable
select publications.titleauthor.au_id as AuthorID, 
sum ((publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100) as RoyaltyEachSale)
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id 
group by publications.titleauthor.au_id 
order by RoyaltyEachSale desc
limit 3;

/*challenge 3*/
create table most_profiting_authors 
select publications.author.au_id as AuthorID, sum ((publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100) as RoyaltyEachSale)  
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id 
group by AuthorID
order by RoyaltyEachSale desc; 
