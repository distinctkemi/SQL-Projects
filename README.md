# SQL Projects
This repository contains some projects I have done with SQL

**SQL QUERY** 


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

**RESULT**


![alt text](https://github.com/distinctkemi/SQL-Projects/blob/main/CTE%20Result.JPG)
