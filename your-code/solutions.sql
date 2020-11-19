use lab_mysql;

-- Challenge 1 - Most Profiting Authors

-- Step 1: Calculate the royalties of each sales for each author

create temporary table step1
SELECT 
    titleauthor.title_id AS Title_ID,
    titleauthor.au_id AS Author_ID,
    (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM
    titleauthor
        LEFT JOIN
    titles ON titles.title_id = titleauthor.title_id
        LEFT JOIN
    sales ON sales.title_id = titleauthor.title_id;

-- Step 2: Aggregate the total royalties for each title for each author

create temporary table step2
SELECT 
    Title_ID,
    Author_ID,
    SUM(Sales_Royalty) AS Total_Royalties
FROM
    step1
GROUP BY 1, 2;

-- Step 3: Calculate the total profits of each author

SELECT 
    Author_ID,
    SUM(step2.Total_Royalties + titles.advance) AS Total_Profit
FROM
    step2
        LEFT JOIN
    titles ON step2.Title_id = titles.title_id
GROUP BY Author_ID
ORDER BY Total_Profit DESC
LIMIT 3;

-- Challenge 2 - Alternative Solution

-- Step 1: Calculate the royalties of each sales for each author

SELECT 
    titleauthor.title_id,
    titleauthor.au_id,
    (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
FROM
    titleauthor
        LEFT JOIN
    titles ON titles.title_id = titleauthor.title_id
        LEFT JOIN
    sales ON sales.title_id = titleauthor.title_id;
    
-- Step 2: Aggregate the total royalties for each title for each author

SELECT 
    title_id, au_id, SUM(Sales_Royalty) AS Total_Royalties
FROM
    (SELECT 
        titleauthor.title_id,
            titleauthor.au_id,
            (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
    FROM
        titleauthor
    LEFT JOIN titles ON titles.title_id = titleauthor.title_id
    LEFT JOIN sales ON sales.title_id = titleauthor.title_id) derived_sales_royalties
GROUP BY 1 , 2;

-- Step 3: Calculate the total profits of each author

SELECT 
    au_id,
    SUM(Total_Royalties + titles.advance) AS Total_Profits
FROM
    (SELECT 
        title_id, au_id, SUM(Sales_Royalty) AS Total_Royalties
    FROM
        (SELECT 
        titleauthor.title_id,
            titleauthor.au_id,
            (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Sales_Royalty
    FROM
        titleauthor
    LEFT JOIN titles ON titles.title_id = titleauthor.title_id
    LEFT JOIN sales ON sales.title_id = titleauthor.title_id) derived_sales_royalties
    GROUP BY 1 , 2) derived_total_profits
        LEFT JOIN
    titles ON titles.title_id = derived_total_profits.title_id
GROUP BY derived_total_profits.au_id
ORDER BY Total_Profits DESC
LIMIT 3;

-- Challenge 3

DROP TABLE IF EXISTS most_profiting_authors;
CREATE TABLE most_profiting_authors (
SELECT titleauthor.au_id AS au_id,
    SUM(step2.Total_Royalties + titles.advance) as profits FROM
    titleauthor
        LEFT JOIN
    step2 ON step2.Author_ID = titleauthor.au_id
        LEFT JOIN
    titles ON titles.title_id = titleauthor.title_id
GROUP BY 1
ORDER BY 2 DESC);   
        

