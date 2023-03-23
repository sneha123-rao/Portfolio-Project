SELECT 
Location,
date_format(str_to_date(date,'%m/%d/%Y'),'%b %Y')as Date,
population,
round((total_deaths/total_cases)*100 )as PercentDeaths,
round((total_cases/population)*100 )as PercentPolpulationInfected
FROM covid.covideaths
WHERE Continent != 'null';

SELECT
Location,
population,
max(total_cases) as HighestInfections,
round(max(total_cases/population)*100) as HighestInfectionsPercent,
max(cast(total_deaths as unsigned)) as HighestDeathCount
FROM covid.covideaths
GROUP BY Location , population
ORDER BY HighestDeathCount desc;

##Death count continent wise

SELECT continent,
max(cast(total_deaths as unsigned)) as HighestDeathCount
FROM covid.covideaths
WHERE continent !=''
GROUP BY continent
ORDER BY HighestDeathCount desc ;



#Covid Vaccination data exploration

select *
from covid.covidvaccinations;

##Looking at Total population and total vaccinations

select deaths.Date,deaths.continent,deaths.location,deaths.population,
vaccines.new_vaccinations,
sum(cast(new_vaccinations as  unsigned)) over (partition by deaths.location order by deaths.location,deaths.date) as RollingCountOfPeopleVaccinated
from covid.covideaths as deaths
join covid.covidvaccinations as vaccines
  on deaths.location= vaccines.location and deaths.Date=vaccines.Date
where deaths.continent != ''
limit 90000;

## CTE (Common Table Expressions)

With PopvsVac (date,continent,Location,population,New_vaccinations,RollingCountOfPeopleVaccinated)
as 
(
select deaths.Date,deaths.continent,deaths.location,deaths.population,
vaccines.new_vaccinations,
sum(cast(new_vaccinations as  unsigned)) over (partition by deaths.location order by deaths.location,deaths.date) as RollingCountOfPeopleVaccinated
from covid.covideaths as deaths
join covid.covidvaccinations as vaccines
  on deaths.location= vaccines.location and deaths.Date=vaccines.Date
where deaths.continent != ''
limit 90000
)
SELECT *,(RollingCountOfPeopleVaccinated/population)*100
FROM PopvsVac;




## TEMP TABLE

## 1--- Drop table if exists

drop table if exists PopulationVac;
create table PopulationVac
(
Date varchar(255),
continent  varchar(255),
location varchar(255),
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);
##select *
##from PopulationVac

INSERT ignore INTO PopulationVac
select deaths.Date,deaths.continent,deaths.location,deaths.population,
vaccines.new_vaccinations,
sum(cast(new_vaccinations as  unsigned)) over (partition by deaths.location order by deaths.location,deaths.date) as RollingCountOfPeopleVaccinated
from covid.covideaths as deaths
join covid.covidvaccinations as vaccines
  on deaths.location= vaccines.location and deaths.Date=vaccines.Date
where deaths.continent != ''
limit 90000;

select *,(RollingPeopleVaccinated/population)*100
from PopulationVac;

## 1 Creating a view for visualization
CREATE VIEW  DeathCount as
SELECT continent,
max(cast(total_deaths as unsigned)) as HighestDeathCount
FROM covid.covideaths
WHERE continent !=''
GROUP BY continent
ORDER BY HighestDeathCount desc ;

## 2 Creating a view for visualization

CREATE VIEW PopulationVaccinations as
select deaths.Date,deaths.continent,deaths.location,deaths.population,
vaccines.new_vaccinations,
sum(cast(new_vaccinations as  unsigned)) over (partition by deaths.location order by deaths.location,deaths.date) as RollingCountOfPeopleVaccinated
from covid.covideaths as deaths
join covid.covidvaccinations as vaccines
  on deaths.location= vaccines.location and deaths.Date=vaccines.Date
where deaths.continent != '';

## 3 Creating a view for visualization

CREATE VIEW RollingCountOfPeopleVaccinated as
select deaths.Date,deaths.continent,deaths.location,deaths.population,
vaccines.new_vaccinations,
sum(cast(new_vaccinations as  unsigned)) over (partition by deaths.location order by deaths.location,deaths.date) as RollingCountOfPeopleVaccinated
from covid.covideaths as deaths
join covid.covidvaccinations as vaccines
  on deaths.location= vaccines.location and deaths.Date=vaccines.Date
where deaths.continent != ''
limit 90000;





