Select *
From PortfolioProjects..covid_deaths
Where continent is not null
order by 3,4 

--Select *
--From PortfolioProjects..covid_vaccination
--order by 3,4

--- Select data that we are going to use

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..covid_deaths
order by 1,2

-- Looking at Total cases vs Total deaths
-- shows likelihood of dying if you contract covid in your country 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..covid_deaths
Where location like '%India%' and Where continent is not null
-- we get only india data by giving '%india%'
order by 1,2


-- Looking at Total cases vs Population
-- shows what percentage got covid
Select Location, date,Population, total_cases, (total_deaths/Population)*100 as Percentage
From PortfolioProjects..covid_deaths
Where location like '%India%' 
order by 1,2

Select Location, date,Population, total_cases, (total_deaths/Population)*100 as Percentage
From PortfolioProjects..covid_deaths
Where continent is not null
order by 1,2

--- Looking at Countries with Highest Infection Rate compared to Population
Select Location,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/Population))*100 as PercentPopulationInfected
From PortfolioProjects..covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Counries with Highest Death count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProjects..covid_deaths
Group by Location
order by TotalDeathCount desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..covid_deaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..covid_deaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..covid_deaths
Where continent is null
Group by location
order by TotalDeathCount desc

-- Showing continents with highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..covid_deaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
Select  date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjects..covid_deaths
--Where location like '%India%' and 
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjects..covid_deaths
--Where location like '%India%' and 
Where continent is not null
--Group by date
order by 1,2




Select *
From PortfolioProjects..covid_vaccination

--Looking at Total population vs Vaccination
Select *
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date




Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location)
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3




Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.Date)
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeoplevaccinated
---, (RollingPeoplevaccinated/Population) *100
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- use city
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeoplevaccinated
---, (RollingPeoplevaccinated/Population) *100
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
---order by 2,3
)
select *
From PopvsVac



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeoplevaccinated
---, (RollingPeoplevaccinated/Population) *100
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
---order by 2,3
)
select *, (RollingPeoplevaccinated/Population)*100
From PopvsVac



---TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeoplevaccinated
---, (RollingPeoplevaccinated/Population) *100
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
---where dea.continent is not null
---order by 2,3

select *, (RollingPeoplevaccinated/Population)*100
From  #PercentPopulationVaccinated


--- Creating view to store data for later visualtion

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeoplevaccinated
---, (RollingPeoplevaccinated/Population) *100
From PortfolioProjects..covid_deaths dea
Join PortfolioProjects..covid_vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
---order by 2,3


Select *
From PercentPopulationVaccinated 