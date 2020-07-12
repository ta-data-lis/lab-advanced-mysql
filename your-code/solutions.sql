/*Challange 1  --> Temporary Tables*/
/*Step 1 - Calculate the royalties of each sales for each author */
select ta.title_id, ta.au_id, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as "Royalty of each sale for each author"
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id;

/*Step 2 - Aggregate the total royalties for each title for each author */
create temporary table royalty_sales_author
select ta.title_id as `Title ID`, ta.au_id as `Author ID`, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as `Royalty of each sale for each author`
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id;

DROP TEMPORARY TABLE IF EXISTS royalty_sales_author;

select `Title ID`, `Author ID`, sum(`Royalty of each sale for each author`) as `Aggregated royalties of each title for each author`
from publications.royalty_sales_author as rsa
group by `Title ID`, `Author ID`;

/*Step 3 - Aggregate the total royalties for each title for each author */
create temporary table royalty_author
select `Title ID`, `Author ID`, sum(`Royalty of each sale for each author`) as`Aggregated royalties of each title for each author`
from publications.royalty_sales_author as rsa
group by `Title ID`, `Author ID`;

DROP TEMPORARY TABLE IF EXISTS royalty_author;

select `Author ID`, sum(`Aggregated royalties of each title for each author`+ t.advance ) as "Profits of each author by aggregating the advance and total royalties of each title"
from publications.royalty_author as ra
inner join publications.titles as t
on  `Title ID` = t.title_id
group by `Author ID`
order by sum(`Aggregated royalties of each title for each author`+ t.advance ) desc
limit 3;


/*Challange 2 --> Derived Tables*/
/*Step 1 - Calculate the royalties of each sales for each author */
select ta.title_id, ta.au_id, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as "Royalty of each sale for each author"
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id;

/*Step 2 - Aggregate the total royalties for each title for each author */
select `Title ID`, `Author ID`, sum(`Royalty of each sale for each author`) as `Aggregated royalties of each title for each author`
from (select ta.title_id as `Title ID`, ta.au_id as `Author ID`, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as `Royalty of each sale for each author`
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id) as rsa
group by `Title ID`, `Author ID`;

/*Step 3 - Aggregate the total royalties for each title for each author */
select `Author ID`, sum(`Aggregated royalties of each title for each author`+ t.advance ) as "Profits of each author by aggregating the advance and total royalties of each title"
from (select `Title ID`, `Author ID`, sum(`Royalty of each sale for each author`) as`Aggregated royalties of each title for each author`
from (select ta.title_id as `Title ID`, ta.au_id as `Author ID`, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as `Royalty of each sale for each author`
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id) as rsa
group by `Title ID`, `Author ID`) as ra
inner join publications.titles as t
on  `Title ID` = t.title_id
group by `Author ID`
order by sum(`Aggregated royalties of each title for each author`+ t.advance ) desc;


/*Challange 3*/
/*Step 1 - Calculate the royalties of each sales for each author */
create table most_profiting_authors
select `Author ID`, sum(`Aggregated royalties of each title for each author`+ t.advance) as "The profits of the author aggregating the advances and royalties" from (select `Title ID`, `Author ID`, sum(`Royalty of each sale for each author`) as`Aggregated royalties of each title for each author`
from (select ta.title_id as `Title ID`, ta.au_id as `Author ID`, (t.price*s.qty*t.royalty/100* ta.royaltyper/100) as `Royalty of each sale for each author`
from publications.titleauthor as ta
inner join publications.sales as s
on ta.title_id = s.title_id
inner join publications.titles as t
on t.title_id = s.title_id
inner join publications.roysched as r
on t.title_id = r.title_id) as rsa
group by `Title ID`, `Author ID`) as ra
inner join publications.titles as t
on  `Title ID` = t.title_id
group by  `Author ID`
order by sum(`Aggregated royalties of each title for each author`+ t.advance ) desc;

select *
from publications.most_profiting_authors