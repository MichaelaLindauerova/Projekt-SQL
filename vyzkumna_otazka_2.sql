-- Výzkumná otázka č.2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

/*
Vytvoření dotazu, kde máme zobrazeno, kolik kilogramů chleba a litrů mléka bylo možné si koupit za průměrnou hrubou mzdu v letech 2006 a 2018.
Dále je zde výpočet, jaký byl procentuální nárůst mezd mezi lety 2006 a 2018 a jaký byl procentuální nárůst kupní síly.
*/

WITH data_2006 AS (
    SELECT 
        food_category,
        AVG(avg_payroll) AS avg_payroll_2006,
        AVG(avg_price) AS price_2006,
        (AVG(avg_payroll) / NULLIF(AVG(avg_price), 0)) AS quantity_2006
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    WHERE year = 2006
        AND food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
    GROUP BY food_category
),
data_2018 AS (
    SELECT 
        food_category,
        AVG(avg_payroll) AS avg_payroll_2018,
        AVG(avg_price) AS price_2018,
        (AVG(avg_payroll) / NULLIF(AVG(avg_price), 0)) AS quantity_2018
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    WHERE year = 2018
        AND food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
    GROUP BY food_category
)
SELECT 
    d06.food_category,
    ROUND(d06.avg_payroll_2006) AS avg_payroll_2006,
    ROUND(d18.avg_payroll_2018) AS avg_payroll_2018,
    ROUND(((d18.avg_payroll_2018 - d06.avg_payroll_2006) / NULLIF(d06.avg_payroll_2006, 0) * 100)::numeric, 1) AS payroll_pct_change,
    ROUND(d06.price_2006::numeric, 2) AS price_2006,
    ROUND(d18.price_2018::numeric, 2) AS price_2018,
    ROUND(((d18.price_2018 - d06.price_2006) / NULLIF(d06.price_2006, 0) * 100)::numeric, 1) AS price_pct_change,
    ROUND(d06.quantity_2006) AS quantity_affordable_2006,
    ROUND(d18.quantity_2018) AS quantity_affordable_2018,
    ROUND(((d18.quantity_2018 - d06.quantity_2006) / NULLIF(d06.quantity_2006, 0) * 100)::numeric, 1) AS quantity_pct_change
FROM data_2006 d06
JOIN data_2018 d18
    ON d06.food_category = d18.food_category
ORDER BY d06.food_category;

/* Výsledky ukázaly, že průměrná mzda v roce 2018 vzrostla na 32536 z 20754 z roku 2006.
V roce 2006 bylo možné z průměrné mzdy nakoupit přibližně 1437 litrů mléka, v roce 2018 to bylo zhruba 1642 litrů.
V roce 2006 bylo možné z průměrné mzdy nakoupit přibližně 1287 kilogramů chleba, v roce 2018 to bylo zhruba 1342 kilogramů.
Mezi lety 2006 a 2018 mzdy narostly přibližně o 56,8%, 
Cena chleba narostla o přibližně 50,3%, cena mléka narostla o přibližně 37,3%.
Kupní síla se tedy v případě chleba zvýšila o přibližně 4,3% a v případě mléka o přibližně 14,2%. 
Z toho je patrné, že zatímco mzdy rostly, ceny potravin se zvyšovaly také a kupní síla zůstala relativně podobná v průběhu sledovaného času*/