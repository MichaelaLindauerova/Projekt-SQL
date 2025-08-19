/* Výzkumná otázka č.5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

WITH gdp_growth AS (
    SELECT 
        year,
        ROUND(
            100.0 * (gdp::numeric - LAG(gdp::numeric) OVER (ORDER BY year)) 
            / NULLIF(LAG(gdp::numeric) OVER (ORDER BY year), 0), 
            2
        ) AS gdp_growth
    FROM t_Michaela_Lindauerova_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
wage_growth AS (
    SELECT 
        year,
        ROUND(
            100.0 * (AVG(avg_payroll)::numeric - LAG(AVG(avg_payroll)::numeric) OVER (ORDER BY year)) 
            / NULLIF(LAG(AVG(avg_payroll)::numeric) OVER (ORDER BY year), 0), 
            2
        ) AS wage_growth
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY year
),
price_growth AS (
    SELECT 
        year,
        ROUND(
            100.0 * (AVG(avg_price)::numeric - LAG(AVG(avg_price)::numeric) OVER (ORDER BY year)) 
            / NULLIF(LAG(AVG(avg_price)::numeric) OVER (ORDER BY year), 0), 
            2
        ) AS price_growth
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY year
),
joined AS (
    SELECT 
        g.year,
        g.gdp_growth,
        w.wage_growth,
        p.price_growth,
        LEAD(w.wage_growth) OVER (ORDER BY g.year) AS wage_growth_next_year,
        LEAD(p.price_growth) OVER (ORDER BY g.year) AS price_growth_next_year
    FROM gdp_growth g
    LEFT JOIN wage_growth w ON g.year = w.year
    LEFT JOIN price_growth p ON g.year = p.year
)
SELECT *
FROM joined
ORDER BY year;

/* Z výstupu vyplývá, že mezi růstem HDP a růstem mezd i cen potravin existuje určitá míra souvislosti.
Například v letech 2007 a 2017, kdy došlo k významnému růstu HDP, následoval i růst mezd a cen jak ve stejném roce,
tak i v roce následujícím.

Naopak v roce 2009, kdy HDP výrazně pokleslo, klesly také ceny potravin a růst mezd se výrazně zpomalil.
To naznačuje, že HDP může být indikátorem ekonomické kondice, která se promítá i do vývoje mezd a cen.

Nicméně objevily se i výjimky – například v roce 2013 došlo k prudkému růstu cen potravin bez odpovídajícího růstu HDP,
což ukazuje, že kromě HDP na vývoj cen mohou působit i jiné faktory.

Celkově lze říci, že HDP má určitý vliv na vývoj mezd a cen potravin, ale ne vždy a ne s okamžitým účinkem.
Vliv může být částečný, zpožděný nebo kombinovaný s dalšími faktory. */