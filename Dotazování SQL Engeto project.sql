--Výzkumná otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

/* Vytvoření dotazu, kde máme podle jednotlivých let seřazená jednotlivá odvětví, průměrnou mzdu aktuálního roku v odvětví, 
 * průměrnou mzdu v odvětví za předchozí rok a sloupec s rozdílem pro porovnání.
 V této tabulce dále vyfiltrujeme odvětví a roky, kdy nedošlo ke zvýšení mezd - sloupec rozdílu je menší nebo roven 0
 */

SELECT *
FROM (
  SELECT 
    industry_branch, 
    payroll_year, 
    avg_value AS avg_current_year,
    LAG(avg_value) OVER (
      PARTITION BY industry_branch
      ORDER BY payroll_year
    ) AS avg_last_year,
    avg_value - LAG(avg_value) OVER (
      PARTITION BY industry_branch
      ORDER BY payroll_year
    ) AS year_diff
  FROM payrolls
) AS sub
WHERE year_diff <= 0
ORDER BY payroll_year;

/* 
Analyzovala jsem vývoj průměrných mezd v jednotlivých odvětvích pomocí funkce LAG() 
a výpočtu meziročního rozdílu. Výsledky ukazují, že v některých letech a odvětvích došlo 
k poklesu průměrných mezd.
Tato analýza odpovídá na výzkumnou otázku, zda mzdy rostly ve všech odvětvích – a ukazuje, 
že růst nebyl vždy zcela plošný. V roce 2013 byl meziroční pokles mezd v největším počtu odvětví, celkem v jedenácti odvětvích.
V odvětví "Těžba a dobývání" došlo k meziročnímu poklesu mezd ve sledovaném období nejčastěji, celkem ve čtyřech letech.
*/

--Výzkumná otázka č.2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

/*Vytvoření dotazu, kde máme zobrazeno, kolik kilogramů chleba a litrů mléka bylo možné si koupit za průměrnou hrubou mzdu v letech 2006 a 2018.
Dále je zde výpočet, jaký byl procentuální nárůst mezd mezi lety 2006 a 2018 a jaký byl procentuální nárůst kupní síly.*/

SELECT payroll_year, ROUND(AVG(avg_value), 2) AS avg_payroll_value
FROM payrolls
WHERE payroll_year IN (2006, 2018)
GROUP BY payroll_year;

SELECT year, category, ROUND(avg_value::numeric, 2) AS avg_price
FROM prices
WHERE category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový') 
  AND year IN (2006, 2018)
ORDER BY category, year;

WITH data_2006 AS (
  SELECT 
    p.category AS price_category_name,
    AVG(pr.avg_value) AS avg_payroll_2006,
    AVG(p.avg_value) AS price_2006,
    (AVG(pr.avg_value) / NULLIF(AVG(p.avg_value), 0)) AS quantity_2006
  FROM prices p
  JOIN payrolls pr ON pr.payroll_year = p.year
  WHERE p.year = 2006
    AND p.category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
  GROUP BY p.category
),
data_2018 AS (
  SELECT 
    p.category AS price_category_name,
    AVG(pr.avg_value) AS avg_payroll_2018,
    AVG(p.avg_value) AS price_2018,
    (AVG(pr.avg_value) / NULLIF(AVG(p.avg_value), 0)) AS quantity_2018
  FROM prices p
  JOIN payrolls pr ON pr.payroll_year = p.year
  WHERE p.year = 2018
    AND p.category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
  GROUP BY p.category
)
SELECT 
  d06.price_category_name,
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
  ON d06.price_category_name = d18.price_category_name
ORDER BY d06.price_category_name;

 /* Výsledky ukázaly, že průměrná mzda v roce 2018 vzrostla na 32485 z 20677 z roku 2006.
V roce 2006 bylo možné z průměrné mzdy nakoupit přibližně 1437 litrů mléka, v roce 2018 to bylo zhruba 1639 litrů.
V roce 2006 bylo možné z průměrné mzdy nakoupit přibližně 1287 kilogramů chleba, v roce 2018 to bylo zhruba 1340 kilogramů.
Mezi lety 2006 a 2018 mzdy narostly přibližně o 56,8%, 
Cena chleba narostla o přibližně 50,3%, cena mléka narostla o přibližně 37,3%.
Kupní síla se tedy v případě chleba zvýšila o přibližně 4,3% a v případě mléka o přibližně 14,2%. 
Z toho je patrné, že zatímco mzdy rostly, ceny potravin se zvyšovaly také a kupní síla zůstala relativně podobná v průběhu sledovaného času*/

--Výzkumná otázka č.3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

/* Dotaz, kde máme průměrnou cenu za jednotku pro každou kategorii a rok. 
 * Dále pomocí funkce LAG získanou meziroční procentuální změnu ceny pro každou kategorii. Zprůměrováním této hodnoty pro každou kategorii získáme 
 * průměrný meziroční nárůst ceny za celé sledované období. Výstupem je seznam kategorií seřazený podle toho, které zdražují nejpomaleji.
 */

WITH price_changes AS (
  SELECT 
    category,
    year,
    avg_value::numeric AS avg_value,
    LAG(avg_value::numeric) OVER (PARTITION BY category ORDER BY year) AS last_year_price,
    ROUND(
      100.0 * (avg_value::numeric - LAG(avg_value::numeric) OVER (PARTITION BY category ORDER BY year)) 
      / NULLIF(LAG(avg_value::numeric) OVER (PARTITION BY category ORDER BY year), 0), 
      2
    ) AS year_pct_change
  FROM prices
),
avg_price_growth AS (
  SELECT 
    category,
    ROUND(AVG(year_pct_change)::numeric, 2) AS avg_yearly_pct_change
  FROM price_changes
  WHERE year_pct_change IS NOT NULL
  GROUP BY category
)
SELECT *
FROM avg_price_growth
ORDER BY avg_yearly_pct_change ASC;

/* Z výsledků vyplývá, že kategorie Cukr krystalový a Rajská jablka červená kulatá dokonce v průběhu sledovaného období v průměru lehce zlevňovala.*/

--Výzkumná otázka č.4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_avg_payroll AS (
  SELECT 
    payroll_year AS year,
    ROUND(AVG(avg_value)::numeric, 2) AS avg_payroll
  FROM payrolls
  GROUP BY payroll_year
),
yearly_avg_price AS (
  SELECT 
    year,
    ROUND(AVG(avg_value)::numeric, 2) AS avg_price
  FROM prices
  GROUP BY year
),
payroll_with_growth AS (
  SELECT 
    year,
    avg_payroll,
    LAG(avg_payroll) OVER (ORDER BY year) AS last_year_payroll,
    ROUND(100.0 * (avg_payroll - LAG(avg_payroll) OVER (ORDER BY year)) 
          / NULLIF(LAG(avg_payroll) OVER (ORDER BY year), 0), 2) AS payroll_pct_change
  FROM yearly_avg_payroll
),
price_with_growth AS (
  SELECT 
    year,
    avg_price,
    LAG(avg_price) OVER (ORDER BY year) AS last_year_price,
    ROUND(100.0 * (avg_price - LAG(avg_price) OVER (ORDER BY year)) 
          / NULLIF(LAG(avg_price) OVER (ORDER BY year), 0), 2) AS price_pct_change
  FROM yearly_avg_price
),
joined_growth AS (
  SELECT 
    p.year,
    p.payroll_pct_change,
    pr.price_pct_change,
    ROUND(pr.price_pct_change - p.payroll_pct_change, 2) AS growth_diff
  FROM payroll_with_growth p
  JOIN price_with_growth pr ON p.year = pr.year
)
SELECT *
FROM joined_growth
WHERE growth_diff > 10
ORDER BY year;

/*Na dotaz se žádná data nezobrazila, což znamená, že takto vysoký meziroční nárůst (o 10%) cen potravin oproti mzdám, se ve sledovaném období nestal.
V následujícím dotazu jsem tedy podmínku WHERE upravila tak, abychom zjistili, zda vůbec někdy tato situace nastala bez ohledu na to, o kolik procent
 */

WITH yearly_avg_payroll AS (
  SELECT 
    payroll_year AS year,
    ROUND(AVG(avg_value)::numeric, 2) AS avg_payroll
  FROM payrolls
  GROUP BY payroll_year
),
yearly_avg_price AS (
  SELECT 
    year,
    ROUND(AVG(avg_value)::numeric, 2) AS avg_price
  FROM prices
  GROUP BY year
),
payroll_with_growth AS (
  SELECT 
    year,
    avg_payroll,
    LAG(avg_payroll) OVER (ORDER BY year) AS last_year_payroll,
    ROUND(100.0 * (avg_payroll - LAG(avg_payroll) OVER (ORDER BY year)) 
          / NULLIF(LAG(avg_payroll) OVER (ORDER BY year), 0), 2) AS payroll_pct_change
  FROM yearly_avg_payroll
),
price_with_growth AS (
  SELECT 
    year,
    avg_price,
    LAG(avg_price) OVER (ORDER BY year) AS last_year_price,
    ROUND(100.0 * (avg_price - LAG(avg_price) OVER (ORDER BY year)) 
          / NULLIF(LAG(avg_price) OVER (ORDER BY year), 0), 2) AS price_pct_change
  FROM yearly_avg_price
),
joined_growth AS (
  SELECT 
    p.year,
    p.payroll_pct_change,
    pr.price_pct_change
  FROM payroll_with_growth p
  JOIN price_with_growth pr ON p.year = pr.year
)
SELECT *
FROM joined_growth
WHERE price_pct_change > payroll_pct_change
ORDER BY year;

/* Zde už vidíme, že celkem ve čtyřech letech taková situace nastala. Nejvýraznější rozdíl byl v roce 2013, kdy došlo k meziročnímu poklesu mezd a zvýšení cen potravin. 
 Rozdíl byl ve výši 6,66% */

/* Výzkumná otázka č.5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

WITH gdp_growth AS (
  SELECT 
    year,
    ROUND(gdp_change_pct::numeric, 2) AS gdp_growth
  FROM gdps
),
wage_growth AS (
  SELECT 
    payroll_year AS year,
    ROUND(
      100.0 * (AVG(avg_value)::numeric - LAG(AVG(avg_value)::numeric) OVER (ORDER BY payroll_year)) 
      / NULLIF(LAG(AVG(avg_value)::numeric) OVER (ORDER BY payroll_year), 0), 
      2
    ) AS wage_growth
  FROM payrolls
  GROUP BY payroll_year
),
price_growth AS (
  SELECT 
    year,
    ROUND(
      100.0 * (AVG(avg_value)::numeric - LAG(AVG(avg_value)::numeric) OVER (ORDER BY year)) 
      / NULLIF(LAG(AVG(avg_value)::numeric) OVER (ORDER BY year), 0), 
      2
    ) AS price_growth
  FROM prices
  GROUP BY year
),
joined AS (
  SELECT 
    g.year,
    g.gdp_growth,
    w.wage_growth,
    p.price_growth,
    -- posun o 1 rok dopředu
    LEAD(w.wage_growth) OVER (ORDER BY g.year) AS wage_growth_next_year,
    LEAD(p.price_growth) OVER (ORDER BY g.year) AS price_growth_next_year
  FROM gdp_growth g
  LEFT JOIN wage_growth w ON g.year = w.year
  LEFT JOIN price_growth p ON g.year = p.year
)
SELECT *
FROM joined
ORDER BY YEAR;

/* Z výstupu vyplývá, že mezi růstem HDP a růstem mezd i cen potravin existuje určitá míra souvislosti.
Například v letech 2007 a 2017, kdy došlo k významnému růstu HDP, následoval i růst mezd a cen jak ve stejném roce,
tak i v roce následujícím.

Naopak v roce 2009, kdy HDP výrazně pokleslo, klesly také ceny potravin a růst mezd se výrazně zpomalil.
To naznačuje, že HDP může být indikátorem ekonomické kondice, která se promítá i do vývoje mezd a cen.

Nicméně objevily se i výjimky – například v roce 2013 došlo k prudkému růstu cen potravin bez odpovídajícího růstu HDP,
což ukazuje, že kromě HDP na vývoj cen mohou působit i jiné faktory.

Celkově lze říci, že HDP má určitý vliv na vývoj mezd a cen potravin, ale ne vždy a ne s okamžitým účinkem.
Vliv může být částečný, zpožděný nebo kombinovaný s dalšími faktory. */

