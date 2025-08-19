--Výzkumná otázka č.3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

/* Dotaz, kde máme průměrnou cenu za jednotku pro každou kategorii a rok. 
 * Dále pomocí funkce LAG získanou meziroční procentuální změnu ceny pro každou kategorii. Zprůměrováním této hodnoty pro každou kategorii získáme 
 * průměrný meziroční nárůst ceny za celé sledované období. Výstupem je seznam kategorií seřazený podle toho, které zdražují nejpomaleji.
 */

WITH avg_prices AS (
    SELECT 
        food_category,
        year,
        ROUND(AVG(avg_price)::numeric, 2) AS avg_price
    FROM t_Michaela_Lindauerova_project_SQL_primary_final
    GROUP BY food_category, year
),
price_changes AS (
    SELECT 
        food_category,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY food_category ORDER BY year) AS last_year_price,
        ROUND(
            100.0 * (avg_price - LAG(avg_price) OVER (PARTITION BY food_category ORDER BY year)) 
            / NULLIF(LAG(avg_price) OVER (PARTITION BY food_category ORDER BY year), 0), 
            2
        ) AS year_pct_change
    FROM avg_prices
),
avg_price_growth AS (
    SELECT 
        food_category,
        ROUND(AVG(year_pct_change)::numeric, 2) AS avg_yearly_pct_change
    FROM price_changes
    WHERE year_pct_change IS NOT NULL
    GROUP BY food_category
)
SELECT *
FROM avg_price_growth
ORDER BY avg_yearly_pct_change ASC;

/* Z výsledků vyplývá, že kategorie Cukr krystalový a Rajská jablka červená kulatá dokonce v průběhu sledovaného období v průměru lehce zlevňovala.*/