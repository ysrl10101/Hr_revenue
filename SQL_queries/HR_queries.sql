--Calculating a composite risk score for employee attrition based on multiple factors
WITH risk_factors AS (
    SELECT `EmployeeNumber`, `Attrition`,
    CASE WHEN `DistanceFromHome` < 8 THEN 1
         WHEN `DistanceFromHome` BETWEEN 8 AND 15 THEN 2
         ELSE 3 END AS distance_risk,
        
    CASE WHEN `MonthlyIncome` < 6000 THEN 3
         WHEN `MonthlyIncome` BETWEEN 6000 AND 12000 THEN 2
         ELSE 1 END AS income_risk,
    CASE WHEN `JobSatisfaction` = 1 THEN 3
         WHEN `JobSatisfaction` BETWEEN 2 AND 3 THEN 2
         ELSE 1 END AS jobdesk_risk,
    CASE WHEN `WorkLifeBalance` = 1 THEN 3
         WHEN `WorkLifeBalance` BETWEEN 2 AND 3 THEN 2
         ELSE 1 END AS worklife_risk 
    FROM employee)
SELECT `EmployeeNumber`, `Attrition`,
       (distance_risk + income_risk + jobdesk_risk + worklife_risk) AS total_risk
FROM risk_factors
ORDER BY total_risk DESC;;


--percentile analysis of MonthlyIncome and its correlation with Attrition
WITH income_percentile AS (
    SELECT 
        `EmployeeNumber`,
        MonthlyIncome,
        Attrition,
        NTILE(10) OVER (ORDER BY MonthlyIncome) AS income_decile
    FROM employee
)
SELECT 
    income_decile,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_employees,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM income_percentile
GROUP BY income_decile
ORDER BY income_decile;

--Finding most senior and most junior employees who left the company in each department
WITH rn AS(
    SELECT `EmployeeNumber`,department,`YearsAtCompany`,
            ROW_NUMBER () OVER(PARTITION BY department ORDER BY `YearsAtCompany` DESC ) AS senior_emp,
            ROW_NUMBER () OVER(PARTITION BY department ORDER BY `YearsAtCompany` ASC ) AS junior_emp
    FROM employee
    WHERE `Attrition`='YES'
)
SELECT `EmployeeNumber`,department,`YearsAtCompany`
From rn
WHERE senior_emp=1 OR junior_emp=1;

--Cross tabulation of JobSatisfaction and WorkLifeBalance for employees who left the company
SELECT 
    JobSatisfaction,
    SUM(CASE WHEN WorkLifeBalance = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS wl1,
    SUM(CASE WHEN WorkLifeBalance = 2 AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS wl2,
    SUM(CASE WHEN WorkLifeBalance = 3 AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS wl3,
    SUM(CASE WHEN WorkLifeBalance = 4 AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS wl4
FROM employee
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
--Identifying outliers in MonthlyIncome within each JobRole using Z-score method
With outliers AS (
    SELECT
        `JobRole`,
        AVG(`MonthlyIncome`) AS Avg_income,
        STDDEV(`MonthlyIncome`) AS Stddev_income
    FROM employee
    GROUP BY `JobRole`
)
SELECT
    e.`JobRole`,
    e.`MonthlyIncome`,
    ROUND((e.`MonthlyIncome`-o.avg_income)/o.Stddev_income,2) AS z_score
FROM employee e
JOIN outliers o 
ON e.`JobRole`=o.`JobRole`
WHERE ABS((e.`MonthlyIncome`-o.avg_income)/o.Stddev_income) > 2
ORDER BY  z_score

