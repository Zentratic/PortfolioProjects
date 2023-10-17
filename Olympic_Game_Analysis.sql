

-- 1.Number of gold medals won by each athlete along with their respective rank   

SELECT name, team, COUNT(medal) AS Total_gold_medal , DENSE_RANK() OVER (ORDER BY COUNT(medal) desc) AS rankings
FROM athlete 
WHERE medal = 'Gold' 
GROUP BY name, team
ORDER BY COUNT(medal) desc


-- 2. Total of gold, silver, bronze medals won by each country 
SELECT r.region as Country , COUNT (CASE WHEN medal = 'Gold' THEN 1 END) AS Gold ,COUNT (CASE WHEN medal = 'Silver' THEN 1 END) AS Silver , COUNT (CASE WHEN medal = 'Bronze' THEN 1 END) AS Bronze 
FROM athlete a 
JOIN regions r
ON a.NOC = r.NOC
GROUP BY r.region
ORDER BY COUNT (CASE WHEN medal = 'Gold' THEN 1 END) desc


-- 3. Number of sports played in each olympic game
SELECT games, COUNT (DISTINCT(sport)) as no_of_sports
FROM athlete 
GROUP BY games 
ORDER BY no_of_sports desc 


-- 4. Fething top 5 most successful countries in the olympics. (Success is defined by number of medals won)   
SELECT TOP 5 r.region , COUNT(a.medal) as Number_of_medals, DENSE_RANK () OVER (ORDER BY COUNT (a.medal) desc) as rnk 
FROM athlete a
JOIN regions r 
ON a.NOC = r.NOC 
WHERE a.medal <> 'NA'
GROUP BY r.region 

-- 5. TOP 5 sports USA won the most medals with their respective sport 
SELECT TOP 5 a.sport, r.region , COUNT(a.medal) as total_medals 
FROM athlete a
JOIN regions r
ON a.NOC = r.NOC
WHERE  a.medal <> 'NA' AND r.region = 'USA'
GROUP BY a.sport , r.region 
ORDER BY COUNT(a.medal) desc


-- 6. What year did USA win the most medals ? 

SELECT TOP 1 r.region , a.year, COUNT(a.medal) as total_medals 
FROM athlete a
JOIN regions r
ON a.NOC = r.NOC
WHERE  a.medal <> 'NA' AND r.region = 'USA'
GROUP BY r.region , a.year
ORDER BY COUNT(a.medal) desc

-- 7 Atheletes who are taller than the average height of all athletes who participated in the olympic games 
SELECT DISTINCT(name), height 
FROM athlete 
WHERE height IS NOT NULL 
AND height > (SELECT AVG(height) FROM athlete)
ORDER BY height desc 


-- 8. Number of countries who participated in each olypic game 
WITH all_countries as 
( 
	SELECT a.games , r.region 
	FROM athlete a
	JOIN regions r
	ON a.NOC = r.NOC 
	GROUP BY a.games, r.region
) 

SELECT games, count(1) as total_countries 
FROM all_countries
GROUP BY games
ORDER BY total_countries desc

--9. How many male and female athletes particpated in each olympic game 
WITH athlete_sex as 
(	SELECT DISTINCT (name) ,games ,sex  
	FROM athlete 	
)

SELECT games,  COUNT(CASE WHEN sex = 'M' THEN 1 END) as male_count , COUNT (CASE WHEN sex = 'F' THEN 1 END) as female_count 
FROM athlete_sex
GROUP BY games 
ORDER BY games 

--10. The average height and weight of male athletes within each country 

WITH t1 as 
(
	SELECT DISTINCT name, height, weight, r.region 
	FROM athlete a
	JOIN regions r 
	ON r.NOC = a.NOC
	WHERE height IS NOT NULL 
	AND weight IS NOT NULL 
	AND sex = 'M'

)


SELECT region, ROUND (AVG(height),2) as Male_Avg_Height , ROUND (AVG (weight),2) as Male_Avg_Weight
FROM t1
GROUP BY region


-- 11. The average height and weight of female athletes within each country 
WITH t1 as 
(
	SELECT DISTINCT name, height, weight, r.region 
	FROM athlete a
	JOIN regions r 
	ON r.NOC = a.NOC
	WHERE height IS NOT NULL 
	AND weight IS NOT NULL 
	AND sex = 'F'

)


SELECT region, ROUND (AVG(height),2) as Female_Avg_Height , ROUND (AVG (weight),2) as Female_Avg_Weight
FROM t1
GROUP BY region


-- 12. Determining if Male athletes are younger or older than the avg age of all male athletes 

SELECT DISTINCT (name) , age, 
CASE 
	WHEN age > AVG(age) OVER () THEN 'Older than the average age' 
	WHEN age < AVG(age) OVER () THEN 'Younger than the average age'
	END as age_compared_to_avg_age
FROM athlete 
WHERE age IS NOT NULL 
AND sex = 'M'
GROUP BY name, age, sex 
ORDER BY name


-- 13. Determining if female athletes are younger or older than the average age of all female athletes
SELECT DISTINCT (name) , age, 
CASE 
	WHEN age > AVG(age) OVER () THEN 'Older than the average age' 
	WHEN age < AVG(age) OVER () THEN 'Younger than the average age'
	END as age_compared_to_avg_age
FROM athlete 
WHERE age IS NOT NULL 
AND sex = 'F'
GROUP BY  name, age, sex 
ORDER BY name

--14. Total amount of medals won each year with their respective year for team USA  

SELECT  a.year, a.sport, COUNT(medal) as total_of_medals
FROM athlete a
JOIN regions r
ON a.NOC = r.NOC
WHERE medal <> 'NA' AND  r.region = 'USA'
GROUP BY a.year,  a.sport
order by a.year , total_of_medals 

-- 15. Number of male and female athletes who participated in each olypic game 

SELECT games, COUNT(DISTINCT(name))  as no_of_participants
FROM athlete 
GROUP BY games 
ORDER BY games 