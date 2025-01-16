CREATE DATABASE top_500_movies;
CREATE TABLE movies (
	title VARCHAR(255) NOT NULL,
	worldwide_gross_m INT,
	percentage_budget_recovered VARCHAR(20),
	X_times_budget_recovered  DECIMAL(5, 2),
	budget INT,
	domestic_gross INT,	
	domestic_percentage  DECIMAL(5, 2),
	international_gross INT,
	Percentage_of_gross_from_international  DECIMAL(5, 2),
	worldwide_gross INT,
	year INT,
	decade VARCHAR(50),
	source VARCHAR(255),
	budget_source VARCHAR(255), 
	force_label VARCHAR(255),
	horror VARCHAR(255)
);

ALTER TABLE movies
CHANGE budget budget_millions INT;

SELECT title, COUNT(*) sc
FROM movies
GROUP BY title
HAVING COUNT(*) > 1;

SELECT *
FROM movies
WHERE title = 'Godzilla';

SELECT year, SUM(worldwide_gross_m) B
FROM movies
GROUP BY year
ORDER BY B DESC;

---- DESCRIPTIVE ANALYSIS ----

---- 1. Which movie title has the highest worldwide gross (in millions)? ----
SELECT title, worldwide_gross
FROM movies
ORDER BY worldwide_gross DESC
LIMIT 1;

---- 2. Which movie title has the lowest worldwide gross (in millions)? ----
SELECT title, worldwide_gross
FROM movies
ORDER BY worldwide_gross ASC
LIMIT 1;

---- 3. What is the average budget (in millions) for movies released in each decade? ----
SELECT decade, ROUND(AVG(budget_millions))
FROM movies
GROUP BY decade
ORDER BY decade;

---- 4. How do the worldwide gross (in millions) and budget (in millions) relate to each other on average? ----
    SELECT decade, ROUND(AVG(budget_millions)) AVG_BUDGET
    FROM movies
    GROUP BY decade;
    
---- 5. Which movie has the highest percentage of gross from international markets? ----
SELECT title, percentage_of_gross_from_international
FROM movies
GROUP BY title, Percentage_of_gross_from_international
ORDER BY Percentage_of_gross_from_international DESC
LIMIT 1;

---- 6. What percentage of the worldwide gross comes from the domestic market versus the international market for each movie? ----
SELECT title, domestic_gross / worldwide_gross_m * 100 AS domestic_percentage,
       international_gross / worldwide_gross_m * 100 AS international_percentage
FROM movies;

---- 7. How does the domestic gross (in millions) compare to the international gross (in millions) for movies? ----
SELECT domestic_gross, international_gross
FROM movies;

---- 8. Which movie has the highest X times budget recovered? ----
SELECT title, X_times_budget_recovered
FROM movies
GROUP BY title, X_times_budget_recovered
ORDER BY X_times_budget_recovered DESC
LIMIT 1;

---- 9. What is the distribution of the "X times budget recovered" across different genres, such as horror or non-horror? ----
SELECT horror, SUM(X_times_budget_recovered)
FROM movies 
GROUP BY horror;

---- 10. On average, what is the ratio of worldwide gross to budget (X times budget recovered)? ----
SELECT AVG(worldwide_gross_m / budget_millions) AS avg_x_times_budget_recovered
FROM movies;

---- 11. How do movie budgets and worldwide grosses differ by year or decade? ----
SELECT year, SUM(budget_millions) movie_budget, SUM(worldwide_gross_m) worldwide_gross
FROM movies
GROUP BY year
ORDER BY year;

---- 12. What decade has the highest average worldwide gross (in millions)? ----
SELECT decade, AVG(worldwide_gross_m) highest_avg_worldwide_gross
FROM movies
GROUP BY decade
ORDER BY highest_avg_worldwide_gross DESC
LIMIT 1;

---- 12. How has the average budget for movies evolved over the decades? ----
SELECT decade, SUM(budget_millions)
FROM movies
GROUP BY decade
ORDER BY decade;

---- 13. What is the average percentage of budget recovered for movies that had a worldwide gross higher than $500 million? ----
SELECT ROUND(AVG(percentage_budget_recovered)) AVG_BUDGET_RECOVERED
FROM movies	
WHERE worldwide_gross_m > 500;

---- 14. How do movies with a higher budget recovery percentage compare in terms of gross (domestic vs international)? ----
SELECT title, percentage_budget_recovered, domestic_gross, international_gross
FROM movies
ORDER BY percentage_budget_recovered DESC;

---- EXPLORATORY DATA ANALYSIS -----

---- 15. Are movies that perform well domestically more likely to have a higher percentage of international gross? ----
SELECT title, domestic_gross, domestic_percentage, international_gross, Percentage_of_gross_from_international
FROM movies
WHERE domestic_percentage > 0.50
ORDER BY domestic_percentage DESC;

---- 16. Is there a significant difference in the worldwide gross of movies with high domestic percentages versus those with higher international percentages? ---
SELECT title, worldwide_gross_m, domestic_percentage, Percentage_of_gross_from_international
FROM movies
WHERE domestic_percentage > 0.50 OR Percentage_of_gross_from_international > 0.50;

SELECT *
FROM movies
WHERE title = 'The Last Exorcism';

SELECT title, worldwide_gross, worldwide_gross_m, domestic_gross, international_gross
FROM movies;

SELECT worldwide_gross, worldwide_gross_m, domestic_gross, international_gross, 
	CASE 
      WHEN domestic_gross + international_gross = worldwide_gross_m THEN 1
      ELSE 0
      END AS CON
FROM movies
ORDER BY CON;


---- 17. What patterns can be identified in the recovery of budget (e.g., movies that recover more than 500% of their budget versus those that recover less than 50%)? ----
SELECT title, percentage_budget_recovered, worldwide_gross_m,
	CASE WHEN  percentage_budget_recovered >= '500%' THEN 'VERY HIGH RETURN' END AS 500_percent_recoverd,
    CASE WHEN  percentage_budget_recovered <= '50%' THEN 'HIGH RETURN' END AS 50_percent_recovered
FROM movies;

SELECT 
    title, 
    percentage_budget_recovered, 
    worldwide_gross_m
FROM movies
WHERE percentage_budget_recovered >= '500%'
   OR  percentage_budget_recovered <= '50%';
   
---- 18. Do movies from certain decades show significantly higher or lower recovery rates? ----
SELECT decade, ROUND(AVG(percentage_budget_recovered))
FROM movies
GROUP BY decade
ORDER BY decade;

---- 19. Do horror movies have a different pattern of worldwide gross or percentage budget recovery compared to other genres? ----
SELECT horror, ROUND(AVG(worldwide_gross_m)) WORLDWIDEGROSS, ROUND(AVG(percentage_budget_recovered))PERCENTBUDGETRECOVERED
FROM movies
GROUP BY horror;

---- 20. How does the “horror” label impact the international gross percentage for movies in comparison to other genres? ----
SELECT horror, ROUND(AVG(international_gross / worldwide_gross_m * 100)) AVG_INTERNATIONAL_PERCENTAGE
FROM movies
GROUP BY horror;

