#  Bank Loan Analytics Report (End-to-End Project)

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Data_Analysis_Expressions-blue?style=for-the-badge)

## 📊 Project Overview
This project involves the development of a comprehensive **Bank Loan Report** to monitor lending activities and assess performance. The goal was to provide stakeholders with actionable insights into loan applications, funded amounts, and borrower repayment behaviors.

The solution utilizes **SQL** for backend data verification and complex calculation testing, and **Power BI** for the frontend interactive dashboard.

### 🖼️ Dashboard Previews

| **Summary View** | **Overview View** |
|:---:|:---:|
| ![Summary Dashboard](Summary.PNG) | ![Overview Dashboard](Overview.PNG) |

---

##  Business Problem & Objectives
The bank lacked a centralized view of their lending data, making it difficult to assess the quality of their loan portfolio. They required a solution to answer:
1.  **Portfolio Health:** What is the percentage of Good Loans (Fully Paid) vs. Bad Loans (Charged Off)?
2.  **Temporal Trends:** How are loan applications and funded amounts growing Month-over-Month (MoM)?
3.  **Regional Performance:** Which states have the highest lending activity?
4.  **Borrower Demographics:** How does employee length and home ownership status correlate with loan approval?

---

##  Tech Stack & Methods

* **Database:** Microsoft SQL Server
* **ETL & Analysis:** SQL (Advanced Queries, CTEs, Window Functions)
* **Visualization:** Power BI (Multi-page Dashboard, Navigation, Bookmarks)
* **Calculations:** DAX (Time Intelligence, Measures, Calculated Columns)

---

## 🔍 SQL Data Analysis (Backend)
Before building the dashboard, rigorous testing was performed using SQL to ensure data accuracy. Key SQL features demonstrated in `Advanced Report.sql` include:

* **Data Aggregation:** Calculating total applications, funded amounts, and average interest rates.
* **Time-Series Analysis:** Using **CTEs** and **Window Functions (`LAG`)** to calculate **Month-over-Month (MoM)** growth percentages for all key metrics.
* **Segmentation:** Grouping data by Loan Status (Good/Bad), State, Grade, and Purpose to validate Power BI results.

*Example SQL Logic for MoM Growth:*

WITH MonthlyStats AS (
    SELECT MONTH(issue_date) AS issue_month, COUNT(id) AS mtd_applications
    FROM bank_loans_data
    GROUP BY MONTH(issue_date)
)
SELECT 
    issue_month, 
    (mtd_applications - LAG(mtd_applications) OVER (ORDER BY issue_month)) / 
    LAG(mtd_applications) OVER (ORDER BY issue_month) * 100 AS mom_growth
FROM MonthlyStats;

## Power BI Dashboard Architecture
The Power BI report consists of three strategic pages:

## 1. Summary Page (KPI Focus)
Designed for executives to get a quick snapshot of the bank's health.

Key Metrics: Total Loan Applications (38.6K), Total Funded Amount ($435M), Total Received Amount ($473M).

Good vs. Bad Loans:

Good Loans: 86.18% of all loans (Fully Paid or Current).

Bad Loans: 13.82% (Charged Off).

Loan Status Grid: A detailed breakdown of averages (DTI, Interest Rate) by loan status.

## 2. Overview Page (Exploratory Analysis)
Allows managers to identify trends and patterns.

Monthly Trends: Visualizing the surge in applications towards the end of the year (December peak).

Regional Analysis: Heatmap showing California (CA), New York (NY), and Texas (TX) as the top lending states.

Loan Purpose: "Debt Consolidation" is the primary reason for borrowing.

Borrower Profile: Analysis by Employee Length (10+ years dominance) and Home Ownership (Mortgage vs. Rent).

## 3. Details Page (Operational View)
A granular grid view allowing operational staff to investigate specific loan IDs, checking individual metrics like Interest Rate, DTI, and specific Loan Status.

## Key DAX Measures
Advanced DAX was used to create dynamic time-based calculations. Key measures included in DAX_measures_used.docx:

MTD (Month-to-Date): CALCULATE(TOTALMTD([Total Funded Amount], 'Date'[Date]))

PMTD (Previous Month-to-Date): Used for calculating calculating MoM variance.

Good Loan Percentage: (Good Loan Applications / Total Applications)

Dynamic Visuals: Creating measures to filter data dynamically based on user selection.

## Key Insights & Results
Profitability: The bank has received $473M against $435M funded, indicating a healthy profit margin despite the 13% Bad Loan rate.

Risk Segment: Renters and small business owners showed slightly higher DTI ratios, suggesting areas for tighter credit scoring.

Growth: There was a significant Month-over-Month growth in applications (6.9%) and funded amounts (13%) in the final quarter of 2021.
