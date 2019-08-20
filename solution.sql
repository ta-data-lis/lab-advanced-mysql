## Challenge 1 - Royalty

# 1.Selecting the columns we want to depict and choosing column names according to the info in the lab instructions. 
CREATE TEMPORARY TABLE Royalty_Table
SELECT authors.au_id as AUTHORS_ID, titles.title_id as TITLE_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as Royalty 
FROM authors
# 2. Joining authors and titleauthor tables on the author id 
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
# 3. Joining titleauthor and titles tables on the title id 
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
# 4. Joining sales and titles tables on the title id 
INNER JOIN sales
ON sales.title_id=titles.title_id
# 4. Joining sales and roysched tables on the title id 
INNER JOIN roysched
ON roysched.title_id=sales.title_id
group by authors.au_id,titles.title_id, royalty
order by royalty desc;

SELECT * FROM Royalty_Table;

# Step 2: Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE AGGR_ROYALTY_TABLE
SELECT TITLE_ID,AUTHORS_ID, SUM(Royalty) AS AGGR_ROYALTY
FROM Royalty_Table
group by TITLE_ID,AUTHORS_ID
order by sum(royalty) desc;

SELECT * FROM AGGR_ROYALTY_TABLE;

# Step 3: Calculate the total profits of each author

CREATE TEMPORARY TABLE TOTAL_PROFITS
SELECT distinct(AUTHORS_ID), AGGR_ROYALTY
FROM AGGR_ROYALTY_TABLE
order by AGGR_ROYALTY desc
LIMIT 3;

# Challenge 3

CREATE TABLE most_profiting_authors
SELECT distinct(AUTHORS_ID), AGGR_ROYALTY AS PROFITS
FROM AGGR_ROYALTY_TABLE
order by AGGR_ROYALTY desc

