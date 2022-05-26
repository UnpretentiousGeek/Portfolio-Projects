Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select the Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows Likelihood of dying if you contract covid in your country
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location Like 'India'
and continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location Like 'India'
and continent is not null
Order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location Like 'India'
Where continent is not null
Group by location, population
Order by 4 DESC


-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location Like 'India'
Where continent is not null
Group by location
Order by TotalDeathCount DESC


-- LET'S BREAK THINGS DOWN BY CONTINENT


-- Showing continents with the Highest Death Count per Population 

Select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location Like 'India'
Where continent is not null
Group by continent
Order by TotalDeathCount DESC


-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths, SUM(cast (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location Like 'India'
Where continent is not null
Group By date
Order by 1,2



-- Looking at Total Population vs Vaccinations 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast (vac.new_vaccinations as int)) OVER (Partition By dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3
