SELECT
    iso_code,
    continent,
    location,
    CONVERT(date, date, 103) AS date,
    TRY_CAST(population AS BIGINT) AS population,

    TRY_CAST(total_cases AS FLOAT) AS total_cases,
    TRY_CAST(new_cases AS FLOAT) AS new_cases,
    TRY_CAST(new_cases_smoothed AS FLOAT) AS new_cases_smoothed,
    TRY_CAST(total_deaths AS FLOAT) AS total_deaths,
    TRY_CAST(new_deaths AS FLOAT) AS new_deaths,
    TRY_CAST(new_deaths_smoothed AS FLOAT) AS new_deaths_smoothed,

    TRY_CAST(total_cases_per_million AS FLOAT) AS total_cases_per_million,
    TRY_CAST(new_cases_per_million AS FLOAT) AS new_cases_per_million,
    TRY_CAST(new_cases_smoothed_per_million AS FLOAT) AS new_cases_smoothed_per_million,
    TRY_CAST(total_deaths_per_million AS FLOAT) AS total_deaths_per_million,
    TRY_CAST(new_deaths_per_million AS FLOAT) AS new_deaths_per_million,
    TRY_CAST(new_deaths_smoothed_per_million AS FLOAT) AS new_deaths_smoothed_per_million,

    TRY_CAST(reproduction_rate AS FLOAT) AS reproduction_rate,

    TRY_CAST(icu_patients AS FLOAT) AS icu_patients,
    TRY_CAST(icu_patients_per_million AS FLOAT) AS icu_patients_per_million,
    TRY_CAST(hosp_patients AS FLOAT) AS hosp_patients,
    TRY_CAST(hosp_patients_per_million AS FLOAT) AS hosp_patients_per_million,

    TRY_CAST(weekly_icu_admissions AS FLOAT) AS weekly_icu_admissions,
    TRY_CAST(weekly_icu_admissions_per_million AS FLOAT) AS weekly_icu_admissions_per_million,
    TRY_CAST(weekly_hosp_admissions AS FLOAT) AS weekly_hosp_admissions,
    TRY_CAST(weekly_hosp_admissions_per_million AS FLOAT) AS weekly_hosp_admissions_per_million

INTO ProjectCovid.dbo.CovidDeaths_Clean
FROM ProjectCovid.dbo.CovidDeathsData;

SELECT
    iso_code,
    continent,
    location,
    CONVERT(date, date, 103) AS date,
    
    TRY_CAST(new_tests AS FLOAT) AS new_tests,
    TRY_CAST(total_tests AS FLOAT) AS total_tests,
    TRY_CAST(total_tests_per_thousand AS FLOAT) AS total_tests_per_thousand,
    TRY_CAST(new_tests_per_thousand AS FLOAT) AS new_tests_per_thousand,
    TRY_CAST(new_tests_smoothed AS FLOAT) AS new_tests_smoothed,
    TRY_CAST(new_tests_smoothed_per_thousand AS FLOAT) AS new_tests_smoothed_per_thousand,
    TRY_CAST(positive_rate AS FLOAT) AS positive_rate,
    TRY_CAST(tests_per_case AS FLOAT) AS tests_per_case,
    tests_units,

    TRY_CAST(total_vaccinations AS FLOAT) AS total_vaccinations,
    TRY_CAST(people_vaccinated AS FLOAT) AS people_vaccinated,
    TRY_CAST(people_fully_vaccinated AS FLOAT) AS people_fully_vaccinated,
    TRY_CAST(new_vaccinations AS FLOAT) AS new_vaccinations,
    TRY_CAST(new_vaccinations_smoothed AS FLOAT) AS new_vaccinations_smoothed,

    TRY_CAST(total_vaccinations_per_hundred AS FLOAT) AS total_vaccinations_per_hundred,
    TRY_CAST(people_vaccinated_per_hundred AS FLOAT) AS people_vaccinated_per_hundred,
    TRY_CAST(people_fully_vaccinated_per_hundred AS FLOAT) AS people_fully_vaccinated_per_hundred,
    TRY_CAST(new_vaccinations_smoothed_per_million AS FLOAT) AS new_vaccinations_smoothed_per_million,

    TRY_CAST(stringency_index AS FLOAT) AS stringency_index,
    TRY_CAST(population_density AS FLOAT) AS population_density,
    TRY_CAST(median_age AS FLOAT) AS median_age,
    TRY_CAST(aged_65_older AS FLOAT) AS aged_65_older,
    TRY_CAST(aged_70_older AS FLOAT) AS aged_70_older,
    TRY_CAST(gdp_per_capita AS FLOAT) AS gdp_per_capita,
    TRY_CAST(extreme_poverty AS FLOAT) AS extreme_poverty,
    TRY_CAST(cardiovasc_death_rate AS FLOAT) AS cardiovasc_death_rate,
    TRY_CAST(diabetes_prevalence AS FLOAT) AS diabetes_prevalence,
    TRY_CAST(female_smokers AS FLOAT) AS female_smokers,
    TRY_CAST(male_smokers AS FLOAT) AS male_smokers,
    TRY_CAST(handwashing_facilities AS FLOAT) AS handwashing_facilities,
    TRY_CAST(hospital_beds_per_thousand AS FLOAT) AS hospital_beds_per_thousand,
    TRY_CAST(life_expectancy AS FLOAT) AS life_expectancy,
    TRY_CAST(human_development_index AS FLOAT) AS human_development_index

INTO ProjectCovid.dbo.CovidVaccinations_Clean
FROM ProjectCovid.dbo.CovidVaccinations;



SELECT *
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
order by 3,4;

--SELECT *
--FROM ProjectCovid.dbo.CovidVaccinations_Clean

SELECT location, date, total_cases,new_cases, total_deaths, population
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
order by 1,2;


--Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths / NULLIF(total_cases, 0)) * 100, 2) AS DeathRate
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
ORDER BY 1,2;

--HighestInfectionRate

SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfectionCount, 
    ROUND(MAX(total_cases / NULLIF(population, 0)) * 100, 2) AS PercentPopulationInfected
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY  PercentPopulationInfected DESC;

SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfectionCount, 
    ROUND((MAX(total_cases) * 100.0) / NULLIF(population, 0), 2) AS PercentPopulationInfected
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

---Daily Infetions
SELECT 
    location, date,
    population, 
    MAX(total_cases) AS HighestInfectionCount, 
    ROUND((MAX(total_cases) * 100.0) / NULLIF(population, 0), 2) AS PercentPopulationInfected
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;

---check this one
SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND((total_cases * 100.0) / NULLIF(population, 0), 2) 
        AS PercentPopulationInfected
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
ORDER BY PercentPopulationInfected DESC;

--SELECT DISTINCT continent
--FROM ProjectCovid.dbo.CovidDeaths_Clean;

--Total Deaths country level

SELECT 
    location, 
    MAX(total_deaths) AS HighestDeathCount
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
AND location NOT IN ('World', 'Europe', 'North America', 'Asia', 'Africa', 'South America', 'European Union', 'International')
GROUP BY location
ORDER BY HighestDeathCount DESC;

SELECT *
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NULL OR continent = '';


--- The right continent death counts
--total deaths stays the same and never decreases, must be cummulative

SELECT continent, SUM(latest_deaths) AS TotalDeaths
FROM (
    SELECT 
        location,
        continent,
        MAX(total_deaths) AS latest_deaths
    FROM ProjectCovid.dbo.CovidDeaths_Clean
    WHERE continent IS NOT NULL   
    AND location NOT IN ('World', 'Europe', 'North America', 'Asia', 'Africa', 'South America', 'European Union', 'International', 'Oceania')
    GROUP BY location, continent
) AS sub
GROUP BY continent
ORDER BY TotalDeaths DESC;


--This one shows my continent numbers are true. Look at the continent numbers,
--they are the same as the results of the above query
SELECT 
    location, 
    MAX(total_deaths) AS HighestDeathCount
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC;

--Across the world now, no location continent filter

SELECT 
    date, 
    SUM(new_cases) AS NewInfection, 
    SUM(new_deaths) AS NewDeaths, 
    ROUND((SUM(new_deaths) * 100.0) / NULLIF(SUM(new_cases), 0),2) AS DeathPercent
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


--Rolling Vaccinations
SELECT 
    dea.continent,
    dea.location, 
    dea.date,
    dea.population, 
    vac.people_fully_vaccinated,
    MAX(vac.people_fully_vaccinated) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
        ROWS UNBOUNDED PRECEDING
    ) AS RollingVaccinations
FROM ProjectCovid..CovidDeaths_Clean dea
JOIN ProjectCovid..CovidVaccinations_Clean vac
    ON dea.location = vac.location  
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

--Common Table Expression. Calculate RollingVac inside CTE then calculate % in the outer query

WITH PopVsVac AS (
    SELECT 
        dea.continent,
        dea.location, 
        dea.date,
        dea.population, 
        vac.people_fully_vaccinated,
        MAX(vac.people_fully_vaccinated) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.date
            ROWS UNBOUNDED PRECEDING
        ) AS RollingVaccinations
    FROM ProjectCovid..CovidDeaths_Clean dea
    JOIN ProjectCovid..CovidVaccinations_Clean vac
        ON dea.location = vac.location  
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    AND dea.location NOT IN (
        'World', 'Europe', 'North America', 'Asia', 'Africa',
        'South America', 'European Union', 'International', 'Oceania'
    )
)

SELECT 
    continent,
    location,
    date,
    population,
    people_fully_vaccinated,
    RollingVaccinations,
    ROUND((RollingVaccinations * 100.0) / NULLIF(population, 0), 2) 
        AS PopulationPercentVaccinated
FROM PopVsVac
ORDER BY location, date;

--SELECT @@VERSION;


--CREATE VIEW 

CREATE OR ALTER VIEW vw_PopVsVac AS
WITH PopVsVac AS (
    SELECT 
        dea.continent,
        dea.location, 
        dea.date,
        dea.population, 
        vac.people_fully_vaccinated,
        MAX(vac.people_fully_vaccinated) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.date
            ROWS UNBOUNDED PRECEDING
        ) AS RollingVaccinations
    FROM ProjectCovid..CovidDeaths_Clean dea
    JOIN ProjectCovid..CovidVaccinations_Clean vac
        ON dea.location = vac.location  
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT 
    continent,
    location,
    date,
    population,
    people_fully_vaccinated,
    RollingVaccinations,
    ROUND((RollingVaccinations * 100.0) / NULLIF(population, 0), 2)
        AS PopulationPercentVaccinated
FROM PopVsVac;

SELECT name
FROM sys.views;

---TOP 1O Vaccinated
SELECT TOP 10
    location,
    MAX(PopulationPercentVaccinated) AS MaxVaccinationPercent
FROM vw_PopVsVac
GROUP BY location
ORDER BY MaxVaccinationPercent DESC;

---New cases, deaths and death %
SELECT 
    SUM(new_cases) AS NewInfection, 
    SUM(new_deaths) AS NewDeaths, 
    ROUND((SUM(new_deaths) * 100.0) / NULLIF(SUM(new_cases), 0),2) AS DeathPercent
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
ORDER BY 1,2

---Use this one for continent death count analysis not MAX(total_deaths)
SELECT 
    continent,
    SUM(new_deaths) AS TotalDeathCount
FROM ProjectCovid.dbo.CovidDeaths_Clean
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

