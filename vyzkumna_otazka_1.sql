--Výzkumná otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

/* Vytvoření dotazu, kde máme podle jednotlivých let seřazená jednotlivá odvětví, průměrnou mzdu aktuálního roku v odvětví, 
 * průměrnou mzdu v odvětví za předchozí rok a sloupec s rozdílem pro porovnání.
 V této tabulce dále vyfiltrujeme odvětví a roky, kdy nedošlo ke zvýšení mezd - sloupec rozdílu je menší nebo roven 0
 */

SELECT *
FROM (
    SELECT 
        industry_branch, 
        year, 
        avg_payroll AS avg_current_year,
        LAG(avg_payroll) OVER (
            PARTITION BY industry_branch
            ORDER BY year
        ) AS avg_last_year,
        avg_payroll - LAG(avg_payroll) OVER (
            PARTITION BY industry_branch
            ORDER BY year
        ) AS year_diff
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY year, industry_branch, avg_payroll
) AS sub
WHERE year_diff <= 0
ORDER BY year;


/* 
Analyzovala jsem vývoj průměrných mezd v jednotlivých odvětvích pomocí funkce LAG() 
a výpočtu meziročního rozdílu. Výsledky ukazují, že v některých letech a odvětvích došlo 
k poklesu průměrných mezd.
Tato analýza odpovídá na výzkumnou otázku, zda mzdy rostly ve všech odvětvích – a ukazuje, 
že růst nebyl vždy zcela plošný. V roce 2013 byl meziroční pokles mezd v největším počtu odvětví, celkem v jedenácti odvětvích.
V odvětví "Těžba a dobývání" došlo k meziročnímu poklesu mezd ve sledovaném období nejčastěji, celkem ve čtyřech letech.
*/