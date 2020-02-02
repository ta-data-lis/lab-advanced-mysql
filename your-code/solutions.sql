use publications;
select * from sales;
select * from roysched;
select * from authors;
select * from titleauthor;
select * from titles;
select * from most_profiting_authors;

CREATE TABLE most_profiting_authors 
AS (
select title_id,au_id,advance+total_royal as profits from(
select title_id,au_id,advance,sum(royal_sale) as total_royal from(select a.title_id,c.au_id,b.royaltyper,a.qty,d.price,d.advance,e.royalty,d.price*a.qty*(e.royalty/100)*(b.royaltyper/100) as royal_sale
from sales as a left join titleauthor as b on a.title_id=b.title_id 
left join authors as c on b.au_id=c.au_id
left join titles as d on b.title_id=d.title_id
left join roysched as e on d.title_id=e.title_id where e.lorange=0) as tab1 group by au_id,title_id) as tab3 order by 3 desc limit 3);

with tab2 as (with tab1 as (select a.title_id,c.au_id,b.royaltyper,a.qty,d.price,d.advance,e.royalty,d.price*a.qty*(e.royalty/100)*(b.royaltyper/100) as royal_sale
from sales as a left join titleauthor as b on a.title_id=b.title_id 
left join authors as c on b.au_id=c.au_id
left join titles as d on b.title_id=d.title_id
left join roysched as e on d.title_id=e.title_id where e.lorange=0)
select title_id,au_id,advance,sum(royal_sale) as total_royal from tab1 group by au_id,title_id) 
select title_id,au_id,advance+total_royal as profits from tab2 order by 3 desc limit 3;

