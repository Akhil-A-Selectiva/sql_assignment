SELECT SUM(population) AS total_population
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085';


SELECT gender, SUM(population) AS headcount
FROM bigquery-public-data.census_bureau_usa.population_by_zip_2010
WHERE zipcode = '94085' AND gender IN ('male', 'female')
GROUP BY gender;

#3. I want which Age group has max headcount for both male and female genders combine (zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

WITH CombinedAgeGroups AS (
    SELECT 
        minimum_age,
        maximum_age,
        gender,
        SUM(population) AS total_population,
        RANK() OVER(PARTITION BY gender ORDER BY SUM(population) DESC) AS population_rank
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        zipcode = '94085'
    GROUP BY 
        minimum_age, maximum_age, gender
)
SELECT 
    minimum_age,
    maximum_age,
    gender,
    total_population
FROM 
    CombinedAgeGroups
WHERE 
    population_rank in (1);


#--- 4,5,6 questions doubtful for there correctness
#4. I want age group for male gender which has max male population zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

WITH MaleAgeGroups AS (
    SELECT 
        minimum_age,
        maximum_age,
        SUM(population) AS total_population_male,
        RANK() OVER(ORDER BY SUM(population) DESC) AS population_rank
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        zipcode = '94085' AND gender = 'male'
    GROUP BY 
        minimum_age, maximum_age
)
SELECT 
    minimum_age,
    maximum_age,
    total_population_male
FROM 
    MaleAgeGroups
WHERE 
    population_rank in (1,2);




#5. I want age group for female gender which has max male population zipcode 94085 (Sunnyvale CA)) Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

WITH FemaleAgeGroups AS (
    SELECT 
        minimum_age,
        maximum_age,
        SUM(population) AS total_population_female,
        RANK() OVER(ORDER BY SUM(population) DESC) AS population_rank
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        zipcode = '94085' AND gender = 'female'
    GROUP BY 
        minimum_age, maximum_age
)
SELECT 
    minimum_age,
    maximum_age,
    total_population_female
FROM 
    FemaleAgeGroups
WHERE 
    population_rank in (1,2);



#6: 6. I want zipcode which has highest male and female population in USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010


WITH ZipcodePopulations AS (
    SELECT 
        zipcode,
        gender,
        SUM(population) AS total_population,
        RANK() OVER(PARTITION BY gender ORDER BY SUM(population) DESC) AS population_rank
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    GROUP BY 
        zipcode, gender
)
SELECT 
    zipcode,
    gender,
    total_population
FROM 
    ZipcodePopulations
WHERE 
    population_rank =1;




#----

#7: 7. I want first five age groups which has highest male and female population in USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010

#---

WITH AgeGroupPopulations AS (
    SELECT 
        minimum_age AS min_age,
        maximum_age AS max_age,
        gender,
        SUM(population) AS total_population,
        ROW_NUMBER() OVER(PARTITION BY gender ORDER BY SUM(population) DESC) AS row_num
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        gender IN ('male', 'female') and minimum_age is not null and maximum_age is not null
    GROUP BY 
        minimum_age, maximum_age, gender
)

SELECT 
    min_age,
    max_age,
    gender,
    total_population
FROM 
    AgeGroupPopulations
WHERE 
    row_num <= 5;



#8:8. I want first five zipcodes which has highest female population in entire USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010



WITH ZipcodeFemalePopulations AS (
    SELECT 
        zipcode,
        SUM(population) AS total_female_population,
        ROW_NUMBER() OVER(ORDER BY SUM(population) DESC) AS row_num
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        gender = 'female'
    GROUP BY 
        zipcode
)

SELECT 
    zipcode,
    total_female_population
FROM 
    ZipcodeFemalePopulations
WHERE 
    row_num <= 5;





#9. I want first 10 which has lowest male population in entire USA Table = bigquery-public-data.census_bureau_usa.population_by_zip_2010


WITH ZipcodeMalePopulations AS (
    SELECT 
        zipcode,
        SUM(population) AS total_male_population,
        ROW_NUMBER() OVER(ORDER BY SUM(population) ASC) AS row_num
    FROM 
        bigquery-public-data.census_bureau_usa.population_by_zip_2010
    WHERE 
        gender = 'male'
    GROUP BY 
        zipcode
)

SELECT 
    zipcode,
    total_male_population
FROM 
    ZipcodeMalePopulations
WHERE 
    row_num <= 10;