# Projekt-SQL
# Analýza mezd, cen a ekonomických ukazatelů v ČR (2006–2018)

## Cíl projektu
Cílem projektu je zodpovědět pět výzkumných otázek pomocí SQL dotazování nad reálnými daty. Projekt je součástí kurzu datové analýzy a je zaměřen na praktické využití SQL při tvorbě datových výstupů.

---

## Výzkumné otázky

1. **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**  
   **Odpověď:** Růst mezd nebyl vždy zcela plošný. V roce 2013 byl meziroční pokles mezd v největším počtu odvětví, celkem v jedenácti odvětvích.  
   V odvětví *Těžba a dobývání* došlo k meziročnímu poklesu mezd ve sledovaném období nejčastěji, celkem ve čtyřech letech.  
   Ve většině odvětví ovšem dochází k postupnému růstu průměrné mzdy. U několika málo odvětví byl zaznamenán dočasný pokles, ale dlouhodobý trend je rostoucí.

2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**  
   **Odpověď:** Mezi lety 2006 a 2018 mzdy narostly přibližně o 56,8 %.  
   Cena chleba narostla o přibližně 50,3 %, cena mléka narostla o přibližně 37,3 %.  
   Kupní síla se tedy v případě chleba zvýšila o přibližně 4,3 % a v případě mléka o přibližně 14,2 %.  
   Z toho je patrné, že zatímco mzdy rostly, ceny potravin se zvyšovaly také, a kupní síla zůstala relativně podobná v průběhu sledovaného času.

3. **Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**  
   **Odpověď:** Z výsledků vyplývá, že kategorie *Cukr krystalový* a *Rajská jablka červená kulatá* dokonce v průběhu sledovaného období v průměru lehce zlevňovala.

4. **Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**  
   **Odpověď:** Ukázalo se, že takto vysoký meziroční nárůst (o 10 %) cen potravin oproti mzdám se ve sledovaném období nestal.  
   Pokusila jsem se tedy zjistit, zda vůbec někdy tato situace nastala bez ohledu na to, o kolik procent.  
   Bylo tedy následně zjištěno, že celkem ve čtyřech letech taková situace nastala. Nejvýraznější rozdíl byl v roce 2013, kdy došlo k meziročnímu poklesu mezd a zvýšení cen potravin. Rozdíl byl ve výši 6,66 %.

5. **Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**  
   **Odpověď:** Z výstupu vyplývá, že mezi růstem HDP a růstem mezd i cen potravin existuje určitá míra souvislosti.  
   Například v letech 2007 a 2017, kdy došlo k významnému růstu HDP, následoval i růst mezd a cen jak ve stejném roce, tak i v roce následujícím.  
   Naopak v roce 2009, kdy HDP výrazně pokleslo, klesly také ceny potravin a růst mezd se výrazně zpomalil.  
   To naznačuje, že HDP může být indikátorem ekonomické kondice, která se promítá i do vývoje mezd a cen.  
   Nicméně objevily se i výjimky – například v roce 2013 došlo k prudkému růstu cen potravin bez odpovídajícího růstu HDP, což ukazuje, že kromě HDP na vývoj cen mohou působit i jiné faktory.  
   Celkově lze říci, že HDP má určitý vliv na vývoj mezd a cen potravin, ale ne vždy a ne s okamžitým účinkem. Vliv může být částečný, zpožděný nebo kombinovaný s dalšími faktory.

---

## Struktura projektu

- `t_Michaela_Lindauerova_project_SQL_primary_final`  
  Vytváří primární tabulky `payrolls`, `prices` a `t_Michaela_Lindauerova_project_SQL_primary_final` spojením mezd a cen.

- `t_Michaela_Lindauerova_project_SQL_secondary_final`  
  Vytváří doplňkovou tabulku z datasetu `economies`, obsahující HDP pro ČR.

- `Dotazování SQL Engeto project`  
  Obsahuje dotazy odpovídající na pět výzkumných otázek včetně komentářů a interpretace výsledků.

---

## Použité datové zdroje

- `czechia_payroll`, `czechia_price`, `czechia_price_category`, `czechia_payroll_industry_branch` – veřejná data ČSÚ
- `economies` – datový přehled makroekonomických ukazatelů

---

## Použité nástroje

- PostgreSQL
- DBeaver
- GitHub

---

## Autor

**Michaela Lindauerová**  
Kurz: Engeto Datový analytik s Pythonem  
Rok: 2025
