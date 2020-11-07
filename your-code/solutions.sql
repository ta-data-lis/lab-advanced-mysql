/***** EXPLANATION *****/
/* sales_by_author temp table gives us quantities summed by title from sales table
 * Then advsqlCH1 gives us our answer to challenge 1. 
 * Note that if we wanted to do the intermediate step 2 we would simply add the title column to the first SELECT statement 
 * and remove the last group by. 
 *
 * n.b.: Challenge 2 (which is a reading) suggests that one would likely use simply derived tables... 
 *      I used both, though I recognise mostly derived ones
 * 
 * challenge 3 seemed easy with things done this way, maybe I am missing something...
 */

DROP TABLE IF EXISTS sales_by_author;
CREATE TEMPORARY TABLE sales_by_author
SELECT sales.title_ID as `TITLE ID`, sum(qty) AS `SALE QTY BY TITLE`
FROM sales
GROUP BY title_id;

DROP TABLE IF EXISTS advsqlCH1_temp;
CREATE TEMPORARY TABLE advsqlCH1_temp
SELECT `AUTHOR ID`, sum(`TITLE PRICE` * sales_by_author.`SALE QTY BY TITLE` * `TITLE ROYALTY` * `ROYAL TYPER`) as `SALES ROYALTY`, `ADVANCES`
FROM(
	SELECT `AUTHOR ID`, `TITLE ID` , titles.price as `TITLE PRICE`, titles.royalty/100 as `TITLE ROYALTY`, `ROYAL TYPER`, COALESCE(advance,0) as `ADVANCES`
	FROM(
		SELECT authors.au_id as `AUTHOR ID`, titleauthor.title_id as `TITLE ID`, titleauthor.royaltyper/100 as `ROYAL TYPER`
		FROM authors 
		LEFT JOIN titleauthor ON titleauthor.au_id = authors.au_id
		WHERE titleauthor.title_id IS NOT NULL
		) part_a
	LEFT JOIN titles on part_a.`Title ID` = titles.title_id
	) part_b
	LEFT JOIN sales_by_author on part_b.`TITLE ID` = sales_by_author.`TITLE ID`
GROUP BY 1;

SELECT * from advsqlCH1_temp;

CREATE TABLE most_profiting_authors
SELECT `AUTHOR ID`, advsqlCH1_temp.`SALES ROYALTY` + `ADVANCES` as `PROFITS`
FROM advsqlCH1_temp;

SELECT * from most_profiting_authors;
