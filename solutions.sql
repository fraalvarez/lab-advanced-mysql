USE mysql_select;
-----------------------------------------------------------------------------------------------------------------
/*
Challenge 1/2 - Most Profiting Authors
*/

SELECT aut.au_id AS 'Author_ID'
	, aut.au_lname AS 'Lastname'
    , aut.au_fname AS 'Firstname'
    , (SELECT SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale 
		FROM authors 
        INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
        INNER JOIN titles ON titleauthor.title_id = titles.title_id
        INNER JOIN sales ON titles.title_id = sales.title_id
        WHERE authors.au_id = aut.au_id
			AND titleauthor.title_id = tit_a.title_id
		) + (tit.advance * tit_a.royaltyper / 100) AS 'Profits'
FROM authors AS aut
LEFT JOIN titleauthor AS tit_a
	ON aut.au_id = tit_a.au_id
LEFT JOIN titles AS tit
	ON tit.title_id = tit_a.title_id
LEFT JOIN sales as sal
	ON sal.title_id = tit.title_id
GROUP BY aut.au_id
	, aut.au_lname
    , aut.au_fname
ORDER BY Profits DESC
LIMIT 3;




---------------------------------------------------------------------------------------------------------------
/*
Challenge 3
*/

CREATE TABLE most_profiting_authors
	SELECT aut.au_id AS au_id
		, (SELECT SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS royalty_per_sale 
			FROM authors 
			INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
			INNER JOIN titles ON titleauthor.title_id = titles.title_id
			INNER JOIN sales ON titles.title_id = sales.title_id
			WHERE authors.au_id = aut.au_id
				AND titleauthor.title_id = tit_a.title_id
			) + (tit.advance * tit_a.royaltyper / 100) AS 'profits'
	FROM authors AS aut
	LEFT JOIN titleauthor AS tit_a
		ON aut.au_id = tit_a.au_id
	LEFT JOIN titles AS tit
		ON tit.title_id = tit_a.title_id
	LEFT JOIN sales as sal
		ON sal.title_id = tit.title_id
	GROUP BY aut.au_id;
    
SELECT * FROM most_profiting_authors ORDER BY profits DESC;