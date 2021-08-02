
--looking at total cases vs total deaths
-- Shows likelihood of dying if you contract Covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage

from covid_project.covid_deaths

where location = "United States"
and continent is not null
order by 1,2

-- Showing contintents with the highest death count per population
select continent, MAX(cast(Total_deaths as int))as totaldeathcount
from covid_project.covid_deaths
where continent is not null
group by continent
order by totaldeathcount desc

--showing (Global Numbers)
select SUM(new_cases)AS TOTAL_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from covid_project.covid_deaths
where continent is not null
group by date
order by 1,2

--select *
--from covid_project.covid_deaths dea
--join covid_project.covid_vaccination vac
--  On dea.location = vac.location
--  and dea.date = vac.date

--looking at total population vs vacvtionations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast (vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vactinated
(rolling_people_vactinated/population)*100
from covid_project.covid_deaths dea
join covid_project.covid_vaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 1,2,3
-with popvsvac (continent,)



--looking at total population vs vacvtionations with Temp table

drop table if exists #percentpopulationVaccinated
CREATE TABLE #percentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vactinated numeric
)

insert into #percentpopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast (vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vactinated
,(rolling_people_vactinated/population)*100
from covid_project.covid_deaths dea
join covid_project.covid_vaccination vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3
 
 select *, (rolling_people_vaccinated/population)*100
 from #percentpopulationVaccinated
 
 creating view to store data for later visualizations

create view #percentpopulationVaccinated
