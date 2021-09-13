
SELECT*
FROM PortfolioProject..[ CovidDeaths]
 ORDER BY 3,4

SELECT*
FROM PortfolioProject..[ CovidVaccinations]
ORDER BY 3,4

--Total Cases Vs Total Deaths

SELECT Location, date, total_cases, total_deaths, population
 FROM PortfolioProject..[ CovidDeaths]
 ORDER BY 1,2

 SELECT Location, date, total_cases,   total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 FROM PortfolioProject..[ CovidDeaths]
 ORDER BY 1,2

 --Death Percentage by Country (Nigeria)

 SELECT Location, date, total_cases,   total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 FROM PortfolioProject..[ CovidDeaths]
 WHERE location like '%igeria%'
 ORDER BY 1,2

 --Percentage of Population Infected by COVID

 SELECT Location, date, total_cases,    population, (total_cases/population)*100 as  PercentPopulationInfected
 FROM PortfolioProject..[ CovidDeaths]
 WHERE location like  '%igeria%'
 ORDER BY 1,2

 --Highest Infection Rate compared to Population

 SELECT Location, population , Max (total_cases) as HighestIbfectionCount, Max (total_cases/population)*100 as  PercentPopulationInfected
 FROM PortfolioProject..[ CovidDeaths]
 GROUP BY location, population
 ORDER BY PercentPopulationInfected desc

 SELECT Location, date, population , Max (total_cases) as HighestIbfectionCount, Max (total_cases/population)*100 as  PercentPopulationInfected
 FROM PortfolioProject..[ CovidDeaths]
 WHERE location like '%igeria%'
 GROUP BY location, date, population
 ORDER BY PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

 SELECT Location, Max (cast(total_deaths as int)) as TotalDeathCount
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is not null
 GROUP BY location
 ORDER BY TotalDeathCount desc

 --  Continent with Highest Death Count per Population

SELECT Continent , Max (cast(total_deaths as int)) as TotalDeathCount
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is not null
 GROUP BY Continent
 ORDER BY TotalDeathCount desc
  
 -- New Cases

 SELECT date, location, Sum(new_cases) as SumOfNewCases
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is not null
 GROUP BY date, location
 ORDER BY 1,2

  SELECT date,location, Sum(new_cases) as SumOfNewCases
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is null
 GROUP BY date, location
 ORDER BY 1,2

 --Global Numbers

 SELECT date, Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
 (new_cases)*100 as DeathPercentage
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is not null
 GROUP BY date
 ORDER BY 1,2


 SELECT Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
 (new_cases)*100 as DeathPercentage
 FROM PortfolioProject..[ CovidDeaths]
 WHERE continent is not null
 ORDER BY 1,2

 
 SELECT*
 FROM PortfolioProject..[ CovidVaccinations]

 SELECT*
 FROM PortfolioProject..[ CovidVaccinations]

 --Total Population Vs Vaccinations

 SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) as RollingPeopleVaccinated
 FROM PortfolioProject ..[ CovidDeaths] Dea
 JOIN PortfolioProject..[ CovidVaccinations] Vac
 on Dea. location = Vac. location
 and Dea.date = Vac. date
 WHERE Dea.continent is not null
 ORDER BY 2,3

 --CTE

 WITH PopVsVac (continent, location,date, population, new_vaccination, RollingPeopleVaccinated)
 as
 (
 SELECT Dea.continent, Dea.location, Dea.date, Dea.Population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) as RollingPeopleVaccinated
 FROM PortfolioProject ..[ CovidDeaths] Dea
 JOIN PortfolioProject..[ CovidVaccinations] Vac
 on Dea. location = Vac. location
 and Dea.date = Vac. date
 WHERE Dea.continent is not null
 )
 select*, (RollingPeopleVaccinated/Population)*100 as PercentageByRollingPeopleVaccinated
 from PopVsVac

 --TEMP TABLE

 DROP TABLE if exists #PercentagePopulationVaccinated

 CREATE TABLE #PercentagePopulationVaccinated
 (
 continent nvarchar (255),
 Location nvarchar (255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 INSERT INTO #PercentagePopulationVaccinated
 SELECT Dea.continent, Dea.location, Dea.date, Dea.Population, Vac.new_vaccinations
 ,SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) as RollingPeopleVaccinated
 FROM PortfolioProject ..[ CovidDeaths] Dea
 JOIN PortfolioProject..[ CovidVaccinations] Vac
 on Dea. location = Vac. location
 and Dea.date = Vac. date
 where Dea.continent is  not null

  select*, (RollingPeopleVaccinated/Population)*100  
 from #PercentagePopulationVaccinated
 
 --View Created

 CREATE VIEW PercentagePopulationVaccinated as
 SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
 SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) as RollingPeopleVaccinated
 FROM PortfolioProject ..[ CovidDeaths] Dea
 JOIN PortfolioProject..[ CovidVaccinations] Vac
 on Dea. location = Vac. location
 and Dea.date = Vac. date
 WHERE Dea.continent is not null

SELECT*
FROM PercentagePopulationVaccinated

SELECT distinct location, date, new_vaccinations
FROM PercentagePopulationVaccinated