USE    db_countries;

#1. What countries have a total GDP above the mean?
# 77 rows returned
SELECT country, GDP FROM countries_of_the_world
WHERE GDP > (SELECT avg (GDP) FROM countries_of_the_world);

#2.How many countries are above the mean on each region in Area, GDP and another variable
#decided by yourself?

#Area Answer: 57
SELECT count(*) FROM countries_of_the_world AS t1
INNER JOIN 
(SELECT region, avg(area) AS avg_area FROM countries_of_the_world GROUP BY Region) AS t2
ON t1.region = t2.region
WHERE t1.area > t2.avg_area;

#GDP Answer: 86
SELECT count(*) FROM countries_of_the_world AS t1
INNER JOIN 
(SELECT region, avg(GDP) AS avg_GDP FROM countries_of_the_world GROUP BY Region) AS t2
ON t1.region = t2.region
WHERE t1.GDP > t2.avg_GDP;

#Phones Answer: 87
SELECT count(*) FROM countries_of_the_world AS t1
INNER JOIN 
(SELECT region, avg(Phones) AS avg_phone FROM countries_of_the_world GROUP BY Region) AS t2
ON t1.region = t2.region
WHERE t1.Phones > t2.avg_phone;


#3. How many regions have more than 65% of their countries with a GDP per capita above 6000?

#Answer: 4
Create temporary table tbl_above
  Select region, count(country) as above6000 from countries_of_the_world
  where countries_of_the_world.GDP > 6000 group by region; 
Create temporary table tbl_percent
  Select region, 0.65*count(country) as total from countries_of_the_world group by region; 
Select count(*) from tbl_above AS a inner join tbl_percent p on a.region=p.region
  where a.above6000 > p.total;

SELECT count(*)
FROM (SELECT count(*) as region_count_all, region FROM countries_of_the_world GROUP BY Region) as A NATURAL JOIN 
(SELECT region, count(*) as region_count_a6000 FROM countries_of_the_world WHERE GDP > 6000 GROUP BY Region) AS ab
WHERE region_count_a6000/region_count_all > 0.65;


#4. List all the countries with a GDP that is 40% below the mean or less.

#88 rows returned
SELECT country, GDP FROM countries_of_the_world WHERE GDP < 0.4 * (
SELECT avg(GDP) FROM countries_of_the_world);

#5. List all the countries with a GDP per capita that is between 40% and 60% the mean GDP per capita

#29 rows returned
SELECT country, GDP FROM countries_of_the_world WHERE GDP BETWEEN 0.4 * (
SELECT avg(GDP) FROM countries_of_the_world) AND 
0.6 * (SELECT avg(GDP) FROM countries_of_the_world);

#6. Which letter is the most popular first letter among all the countries? (i.e. what is the letter that
#starts the largest number of countries?)

#Answer: letter S, 27
SELECT count(country), SUBSTRING(SOUNDEX(Country),1,1) AS firstletter
FROM countries_of_the_world 
GROUP BY  firstletter ORDER BY count(country) DESC limit 1; 

#(Prof's solution:
#SELECT country, REGEXP_SUBSTR(country, '[A-Z]) AS "First_Ltter"
#from countries_of_the_world;
#SELECT * FROM new_tbl;
#SELECT First_Letter,COUNT(First_letter) FROM new_tbl GROUP BY First_Ltter;)

#7. What are the countries with a coast to area ratio in the top 50?

#50 rows returned
SELECT country, coastline/area AS coast_to_area_ratio FROM countries_of_the_world
ORDER BY coast_to_area_ratio DESC LIMIT 50;

#a. From these countries, how many of them belong to the bottom 30 countries by GDP per
#capita?

#Answer: 4
Create temporary table new_table_bottom30
SELECT t3.country FROM (SELECT country, coastline / area AS coast_to_area_ratio FROM countries_of_the_world
ORDER BY coast_to_area_ratio DESC LIMIT 50) AS t3
 INNER JOIN (SELECT country FROM countries_of_the_world ORDER BY GDP LIMIT 30) 
 AS t4 ON t3.country = t4.country;
 SELECT COUNT(country) FROM new_table_bottom30;

#b.From these countries, how many of them belong to the top 30 countries by GDP per
#capita?

#Answer: 7
Create temporary table new_table_top30
SELECT t1.country FROM (SELECT country, coastline / area AS coast_to_area_ratio FROM countries_of_the_world
ORDER BY coast_to_area_ratio DESC LIMIT 50) AS t1
 INNER JOIN (SELECT country FROM countries_of_the_world ORDER BY GDP DESC LIMIT 30) 
 AS t2 ON t1.country = t2.country;
 
 SELECT COUNT(country) FROM new_table_top30;
 
 
#8. Is the average Agriculture, Industry, Service distribution of the top 20 richest countries different
#than the one of the lowest 20?

#Answer:-0.298
SELECT (SELECT avg(agriculture) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP DESC LIMIT 20) AS avg_rich)-
(SELECT avg(agriculture) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP LIMIT 20) AS avg_poor) AS diff_agriculture;

#Answer:0.01768
SELECT (SELECT avg(industry) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP DESC LIMIT 20) AS avg_rich)-
(SELECT avg(industry) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP LIMIT 20) AS avg_poor) AS diff_industry;

#Answer:0.283
SELECT (SELECT avg(service) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP DESC LIMIT 20) AS avg_rich)-
(SELECT avg(service) FROM (SELECT agriculture, industry, service FROM countries_of_the_world 
ORDER BY GDP LIMIT 20) AS avg_poor) AS diff_service;


#9. How much higher is the average literacy level in the 20% percentile of the richest countries
#relative to the poorest 20% countries?

#Answer: 38.204999
SELECT COUNT(country) FROM countries_of_the_world;
#227 * 0.2 = 45

SELECT (SELECT avg(Literacy) FROM (SELECT Literacy FROM countries_of_the_world ORDER BY GDP DESC LIMIT 45) AS t1) -
(SELECT avg(Literacy) FROM (SELECT Literacy FROM countries_of_the_world ORDER BY GDP LIMIT 45) AS t2) AS
diff_avg_Literacy;


#10. From all the countries with a coast ratio at least 50% lower than the mean, which % of them stay
#in Africa?

#Answer: 0.2676, which is 26.76%
CREATE TEMPORARY TABLE new_tbl_2
SELECT tALL.country FROM (SELECT country, region FROM countries_of_the_world WHERE coastline/area <
(SELECT 0.5 * avg(coastline/area) FROM countries_of_the_world)) AS tALL ;

CREATE TEMPORARY TABLE new_tbl_3
SELECT tA.country FROM (SELECT country, region FROM countries_of_the_world WHERE coastline/area <
(SELECT 0.5 * avg(coastline/area) FROM countries_of_the_world)) AS tA
WHERE Region like '%AFRICA%';

SELECT COUNT(*)/(SELECT COUNT(*) FROM new_tbl_2) FROM new_tbl_3 AS percent;


#a. How many of them start with the letter C?
#Answer: 20
SELECT count(*) FROM countries_of_the_world 
  WHERE coastline/area < (SELECT 0.5*avg(coastline/area) 
  FROM countries_of_the_world) and Country REGEXP '^C';
  

















