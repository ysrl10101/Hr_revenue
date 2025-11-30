# HR-Analytics-Employee-Attrition


**Project type:** Data Analysis (SQL, Dashboard)


**Goal:** Analyze employee attrition, identify main drivers and high-risk groups, and provide actionable recommendations to HR.


## 🚀 What’s included
- `dataset/` : sample dataset CSV (employee_data.csv)
- `sql/` : advanced SQL queries used for analysis (CTEs, window functions, z-score, cohort)
- `dashboard/` : Power BI file (`hr_dashboard.pbix`) or Excel workbook (`hr_dashboard.xlsx`)
- `README.md` : this file


## 📁 Data schema (employee_data)
Typical columns used:
- EmployeeID, Age, Gender, Department, JobRole, HireDate, ExitDate, YearsAtCompany
- MonthlyIncome, JobSatisfaction (1-5), WorkLifeBalance (1-4), OverTime (Yes/No)
- PerformanceRating, Education, MaritalStatus, Location

## 🧭 How to run this project
1. Clone the repo
bash
git clone <repo-url>
cd HR-Analytics-Employee-Attrition
3. Load dataset

Place employee_data.csv in /dataset folder.

3. Run SQL queries

Use a SQL client (Postgres, Redshift, BigQuery, SQL Server). Example: run files in /sql.

4. Open dashboard

Open dashboard/hr_dashboard.xlsx in Excel.

## Recommendations 

Targeted pay adjustment for bottom 2 income deciles in high-risk departments.

Review overtime policies and workload distribution.

Create fast-track promotion for high-performing employees without promotions.

Implement stay interviews for employees with risk_score > threshold.
