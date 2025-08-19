--Výzkumná otázka č.4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH avg_by_year AS (
    SELECT 
        year,
        ROUND(AVG(avg_payroll)::numeric, 2) AS avg_payroll,
        ROUND(AVG(avg_price)::numeric, 2) AS avg_price
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY year
),
growths AS (
    SELECT 
        year,
        avg_payroll,
        avg_price,
        LAG(avg_payroll) OVER (ORDER BY year) AS prev_payroll,
        LAG(avg_price) OVER (ORDER BY year) AS prev_price
    FROM avg_by_year
),
growths_pct AS (
    SELECT 
        year,
        ROUND(100.0 * (avg_payroll - prev_payroll) / NULLIF(prev_payroll, 0), 2) AS payroll_pct_change,
        ROUND(100.0 * (avg_price - prev_price) / NULLIF(prev_price, 0), 2) AS price_pct_change,
        ROUND(
            (avg_price - prev_price) / NULLIF(prev_price, 0) * 100.0 
            - (avg_payroll - prev_payroll) / NULLIF(prev_payroll, 0) * 100.0, 
            2
        ) AS growth_diff
    FROM growths
)
SELECT *
FROM growths_pct
WHERE growth_diff > 10
ORDER BY year;

/*Na dotaz se žádná data nezobrazila, což znamená, že takto vysoký meziroční nárůst 
(o 10 %) cen potravin oproti mzdám se ve sledovaném období nestal.
V následujícím dotazu jsem tedy podmínku WHERE upravila tak, abychom zjistili, 
zda vůbec někdy tato situace nastala bez ohledu na to, o kolik procent.
*/

WITH avg_by_year AS (
    SELECT 
        year,
        ROUND(AVG(avg_payroll)::numeric, 2) AS avg_payroll,
        ROUND(AVG(avg_price)::numeric, 2) AS avg_price
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY year
),
growths AS (
    SELECT 
        year,
        avg_payroll,
        avg_price,
        LAG(avg_payroll) OVER (ORDER BY year) AS prev_payroll,
        LAG(avg_price) OVER (ORDER BY year) AS prev_price
    FROM avg_by_year
),
growths_pct AS (
    SELECT 
        year,
        ROUND(100.0 * (avg_payroll - prev_payroll) / NULLIF(prev_payroll, 0), 2) AS payroll_pct_change,
        ROUND(100.0 * (avg_price - prev_price) / NULLIF(prev_price, 0), 2) AS price_pct_change
    FROM growths
)
SELECT *
FROM growths_pct
WHERE price_pct_change > payroll_pct_change
ORDER BY year;

/* Zde už vidíme, že celkem ve čtyřech letech taková situace nastala. Nejvýraznější rozdíl byl v roce 2013, kdy došlo k meziročnímu poklesu mezd a zvýšení cen potravin. 
 Rozdíl byl ve výši 6,66% */