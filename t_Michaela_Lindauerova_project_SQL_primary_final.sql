
/* Vytvořila jsem tabulky payrolls a prices, které budou sloužit jako podklad k následnému dotazování a hledání odpovědí na výzkumné otázky.
Filtrovala jsem datum mezi lety 2006 a 2018, protože tabulka Czechia_price obsahuje jen tato data. 
Zároveň bylo zjištěno, že rok ve sloupcích "date_from" a "date_to" je vždy stejný, pro přehlednost 
tedy uveden jen jeden sloupec "year" podle sloupce "date_from".  
Výběr sloupců je zaměřen pouze na ty, které pro zadání budou potřeba, nepotřebné sloupce nejsou zahrnuty.*/

CREATE TABLE payrolls AS 
SELECT cp.payroll_year, avg(cp.value) AS avg_value, cpib.name AS industry_branch
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch cpib 
ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 --value_type_code 5958 odpovídá „Průměrná hrubá mzda na zaměstnance“
AND (cp.payroll_year BETWEEN 2006 AND 2018) AND cp.value IS NOT NULL AND cpib.name IS NOT NULL 
GROUP BY cp.payroll_year, cpib.name;

CREATE TABLE prices AS
SELECT EXTRACT(YEAR FROM cp.date_from) AS YEAR, cpc.name AS category, avg(cp.value) AS avg_value
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc 
ON cp.category_code = cpc.code
GROUP BY EXTRACT(YEAR FROM cp.date_from), cpc.name;

CREATE TABLE t_Michaela_Lindauerova_project_SQL_primary_final AS
SELECT
  p.payroll_year AS year,
  p.industry_branch,
  p.avg_value AS avg_payroll,
  pr.category AS food_category,
  pr.avg_value AS avg_price
FROM payrolls p
JOIN prices pr
  ON p.payroll_year = pr.year;









