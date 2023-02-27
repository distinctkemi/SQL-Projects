

-- Querying data
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- TOTAL CASES  VS TOTAL DEATHS(LIKELIHOOD OF DYING)
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM [Portfolio Project].dbo.CovidDeaths
WHERE Location LIKE 'Nigeria'
ORDER BY 1,2

-- TOTAL CASES VS POPULATION (Percentage of people that got Covid)
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS DeathPercent
FROM [Portfolio Project].dbo.CovidDeaths
WHERE Location LIKE 'United Kingdom'
ORDER BY 1,2

--Countries with highest infection rate
SELECT Location, MAX(total_cases) AS Total_cases, MAX (total_cases/population)*100 AS DeathPercent
FROM [Portfolio Project].dbo.CovidDeaths
GROUP BY Location , Population
WHERE continent IS NOT NULL
ORDER BY 3 DESC

-- Countries with highest death counts
SELECT Location, MAX(CAST(total_deaths as INT)) AS Total_Deaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC

-- -- Continents with highest death counts
SELECT location,  MAX(CAST(total_deaths as INT)) AS Total_Deaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE Continent IS NULL
GROUP BY location
ORDER BY 2 DESC

--Continents with highest death counts
SELECT continent, MAX(CAST(total_deaths as INT)) AS Total_Deaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE Continent IS not NULL
GROUP BY continent
ORDER BY 2 DESC

--Continents with highest death counts
SELECT continent, MAX(CAST(total_deaths as INT)) AS Total_Deaths
FROM [Portfolio Project].dbo.CovidDeaths
WHERE Continent IS not NULL
GROUP BY continent
ORDER BY 2 DESC

-- Global Numbers
SELECT  date, SUM(new_cases)AS Total_cases, SUM(cast (new_deaths as INT)) AS Total_Deaths, 
SUM(cast (new_deaths as INT))/ SUM(new_cases) * 100 AS DeathPercentage
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT  NULL
GROUP BY date
ORDER BY 1,2

---TOTAL CASES AND TOTAL DEATHS
SELECT  SUM(new_cases)AS Total_cases, SUM(cast (new_deaths as INT)) AS Total_Deaths, 
SUM(cast (new_deaths as INT))/ SUM(new_cases) * 100 AS DeathPercentage
FROM [Portfolio Project].dbo.CovidDeaths
WHERE continent IS NOT  NULL
ORDER BY 1,2

-- JOIN QUERIES
SELECT * 
FROM [Portfolio Project]..CovidDeaths de
JOIN [Portfolio Project]..CovidVaccinations$ va
    ON de.location = va.location
	AND de.date = va.date

-- Total population and total people vaccinated
SELECT de.population, de.date, va.new_vaccinations, de.continent, de.location
FROM [Portfolio Project]..CovidDeaths de
JOIN [Portfolio Project]..CovidVaccinations$ va
    ON de.location = va.location
	AND de.date = va.date
WHERE de.continent IS NOT NULL
ORDER BY 4,5

--Calculating the number of vacinnated population
SELECT de.continent, de.location, de.date, de.population,  va.new_vaccinations,  
SUM(CONVERT(INT, va.new_vaccinations)) OVER (Partition by de.location ORDER BY de.location, de.date) AS  PeopleVaccinated
FROM [Portfolio Project]..CovidDeaths de
JOIN [Portfolio Project]..CovidVaccinations$ va
    ON de.location = va.location
	AND de.date = va.date
WHERE de.continent IS NOT NULL
ORDER BY 2,3

-- Calculating number of people vaccinated in each country
-- Using CTE

With PopulationVaccinated (Continent, Location, Date, Population, PeopleVaccinated, New_Vaccinations)
AS 
(
SELECT de.continent, de.location, de.date, de.population,  va.new_vaccinations,  
SUM(CONVERT(INT, va.new_vaccinations)) OVER (Partition by de.location ORDER BY de.location, de.date) AS  PeopleVaccinated
FROM [Portfolio Project]..CovidDeaths de
JOIN [Portfolio Project]..CovidVaccinations$ va
    ON de.location = va.location
	AND de.date = va.date
WHERE de.continent IS NOT NULL
)

SELECT * , (PeopleVaccinated/Population) * 100
FROM PopulationVaccinated

-- CREATING VIEW TO STORE DATA FOR VISUALISATION
CREATE VIEW 
VaccinatedPop AS
SELECT de.continent, de.location, de.date, de.population,  va.new_vaccinations,  
SUM(CONVERT(INT, va.new_vaccinations)) OVER (Partition by de.location ORDER BY de.location, de.date) AS  PeopleVaccinated
FROM [Portfolio Project]..CovidDeaths de
JOIN [Portfolio Project]..CovidVaccinations$ va
    ON de.location = va.location
	AND de.date = va.date
WHERE de.continent IS NOT NULL