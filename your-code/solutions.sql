#Challenge1
select *
from (select publications.titles.title_id as TitleID,
publications.titleauthor.au_id as AuthorID,
publications.titles.price * publications.sales.qty * publications.titles.royalty / 100 * titleauthor.royaltyper / 100 as RoyaltyEachSale
from publications.titles
inner join publications.titleauthor
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.titles.title_id = publications.sales.title_id) as royalties_each_sale;