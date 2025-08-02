/*Vytvořila jsem doplňkovou tabulku přehledu HDP, jejímž podkladem je tabulka "economies". 
Filtrovala jsem údaje HDP pro Českou Republiku v letech 2006 - 2018, přidala meziroční rozdíl v absolutních číslech i procentuální */

CREATE TABLE gdps AS
SELECT 
  country,
  year,
  gdp,
  LAG(gdp::numeric) OVER (PARTITION BY country ORDER BY year) AS last_year_gdp,
  (gdp::numeric - LAG(gdp::numeric) OVER (PARTITION BY country ORDER BY year)) AS gdp_change_abs,
  ROUND(
    100.0 * (gdp::numeric - LAG(gdp::numeric) OVER (PARTITION BY country ORDER BY year)) 
    / NULLIF(LAG(gdp::numeric) OVER (PARTITION BY country ORDER BY year), 0), 
    2
  ) AS gdp_change_pct
FROM economies
WHERE country = 'Czech Republic'
  AND year BETWEEN 2006 AND 2018
ORDER BY year;

CREATE TABLE t_Michaela_Lindauerova_project_SQL_secondary_final AS
SELECT
  e.country,
  e.year,
  e.gdp,
  e.gini,
  e.population
FROM economies e
WHERE year BETWEEN 2006 AND 2018
  AND country IN (
    'Czech Republic', 'Germany', 'Austria', 'Slovakia', 'Poland' -- např.
  );
