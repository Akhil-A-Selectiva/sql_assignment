SELECT SUM(population) AS total_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085';


SELECT gender, SUM(population) AS headcount
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085' AND gender IN ('male', 'female')
GROUP BY gender;

#3. I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010
SELECT minimum_age AS min_age, maximum_age AS max_age, SUM(population) AS total_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085'
GROUP BY minimum_age, maximum_age
ORDER BY total_population DESC;

#--- 4,5,6 questions doubtful for there correctness
#4. I want age group for male gender which has max male population zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010
SELECT minimum_age, maximum_age,SUM(population) AS total_population_male
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085'AND gender = 'male'
GROUP BY minimum_age, maximum_age
ORDER BY total_population_male DESC
LIMIT 2;


#5. I want age group for female gender which has max male population zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010
SELECT minimum_age, maximum_age,SUM(population) AS total_population_male
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085'AND gender = 'female'
GROUP BY minimum_age, maximum_age
ORDER BY total_population_male DESC
LIMIT 2;


#6: 6. I want zipcode which has highest male and female population in USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

(SELECT 
    zipcode,
    SUM(CASE WHEN gender = 'male' THEN population ELSE 0 END) AS total_male_population
FROM 
    bigquery-public-data.census_bureau_usa.population_by_zip_2010
GROUP BY 
    zipcode
ORDER BY total_male_population DESC LIMIT 1)
UNION ALL
(
SELECT 
    zipcode,
    SUM(CASE WHEN gender = 'female' THEN population ELSE 0 END) AS total_female_population
FROM 
    bigquery-public-data.census_bureau_usa.population_by_zip_2010
GROUP BY 
    zipcode
ORDER BY total_female_population DESC LIMIT 1);
#----

#7: 7. I want first five age groups which has highest male and female population in USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

WITH AgeGroupPopulations AS (
    SELECT 
        MIN(minimum_age) AS min_age,
        MAX(maximum_age) AS max_age,
        gender,
        SUM(population) AS total_population
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        gender IN ('male', 'female')
    GROUP BY 
        minimum_age, maximum_age, gender
)

(SELECT 
    min_age,
    max_age,
    gender,
    total_population
FROM 
    AgeGroupPopulations
WHERE 
    (gender = 'male' AND min_age IS NOT NULL)
ORDER BY 
    gender, total_population DESC
LIMIT 5)
UNION ALL(
SELECT 
    min_age,
    max_age,
    gender,
    total_population
FROM 
    AgeGroupPopulations
WHERE 
    (gender = 'female' AND min_age IS NOT NULL)
ORDER BY 
    gender, total_population DESC
LIMIT 5);


#8:

SELECT 
    zipcode,
    SUM(CASE WHEN gender = 'female' THEN population ELSE 0 END) AS total_female_population
FROM 
    bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE 
    gender = 'female' 
GROUP BY 
    zipcode
ORDER BY 
    total_female_population DESC
LIMIT 5;

#9. I want first 10 which has lowest male population in entire USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

SELECT 
    zipcode,
    SUM(CASE WHEN gender = 'male' THEN population ELSE 0 END) AS total_male_population
FROM 
    bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE 
    gender = 'male'
GROUP BY 
    zipcode
ORDER BY 
    total_male_population ASC
LIMIT 10;