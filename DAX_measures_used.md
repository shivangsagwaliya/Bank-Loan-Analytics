## DAX Measures Documentation.
This document lists all the Data Analysis Expressions (DAX) used in the Bank Loan Analytics Dashboard. The measures are categorized by their function (KPIs, Time Intelligence, Risk Analysis, etc.) for easier navigation.
## 1.Base Key Performance Indicators (KPIs)Core metrics used throughout the dashboard.Total Loan Applications = COUNT(bank_loans_data[id])
Total Funded Amount = SUM(bank_loans_data[loan_amount])
Total Received Amount = SUM(bank_loans_data[total_payment])
Avg Interest Rate = AVERAGE(bank_loans_data[int_rate])
Avg DTI = AVERAGE(bank_loans_data[dti])

## 2.Good vs. Bad Loan Analysis: Measures to assess portfolio risk and quality.Good LoansGood Loan Applications = CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Good Loans")
Good Loan Application % = DIVIDE(CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Good Loans"), [Total Loan Applications])
Good Loan Funded Amount = CALCULATE([Total Funded Amount], bank_loans_data[Good vs Bad Loans] = "Good Loans")
Good Loan Received Amount = CALCULATE([Total Received Amount], bank_loans_data[Good vs Bad Loans] = "Good Loans")
Bad LoansBad Loan Applications = CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Bad Loans")
Bad Loan % = DIVIDE(CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Bad Loans"), [Total Loan Applications])
Bad Loan Funded Amount = CALCULATE([Total Funded Amount], bank_loans_data[Good vs Bad Loans] = "Bad Loans")
Bad Loan Received Amount = CALCULATE([Total Received Amount], bank_loans_data[Good vs Bad Loans] = "Bad Loans")

## 3.Time Intelligence: Month-to-Date (MTD)Metrics calculated for the current month in the context.MTD Loan Applications = CALCULATE(TOTALMTD([Total Loan Applications], 'Date Table'[Date]))
MTD Funded Amount = CALCULATE(TOTALMTD([Total Funded Amount], 'Date Table'[Date]))
MTD Received Amount = CALCULATE(TOTALMTD([Total Received Amount], 'Date Table'[Date]))
MTD Interest Rate = CALCULATE(TOTALMTD([Avg Interest Rate], 'Date Table'[Date]))
MTD DTI = CALCULATE(TOTALMTD([Avg DTI], 'Date Table'[Date]))
** Previous Month-to-Date (PMTD) Metrics  calculated for the same period in the previous month (used for MoM variance)**.
PMTD Loan Applications = CALCULATE([Total Loan Applications], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
PMTD Funded Amount = CALCULATE([Total Funded Amount], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
PMTD Amount Received = CALCULATE([Total Received Amount], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
PMTD Interest Rate = CALCULATE([Avg Interest Rate], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
PMTD DTI = CALCULATE([Avg DTI], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
** Month-over-Month (MoM) GrowthPercentage change metrics to track growth trends**.
MoM Loan Applications = DIVIDE(([MTD Loan Applications] - [PMTD Loan Applications]), [PMTD Loan Applications])
MoM Funded Amount = DIVIDE(([MTD Funded Amount] - [PMTD Funded Amount]), [PMTD Funded Amount])
MoM Amount Received = DIVIDE(([MTD Received Amount] - [PMTD Amount Received]), [PMTD Amount Received])
MoM Interest Rate = DIVIDE(([MTD Interest Rate] - [PMTD Interest Rate]), [PMTD Interest Rate])
MoM DTI = DIVIDE(([MTD DTI] - [PMTD DTI]), [PMTD DTI])

## 4. Data Modeling & ParametersDynamic Measure SelectorUsed for dynamic visuals where the user can switch between metrics.
Select Measure = {
    ("Total Received Amount", NAMEOF('bank_loans_data'[Total Received Amount]), 0),
    ("Total Loan Applications", NAMEOF('bank_loans_data'[Total Loan Applications]), 1),
    ("Total Funded Amount", NAMEOF('bank_loans_data'[Total Funded Amount]), 2)
}
## 5. Date Table (Calculated Table)A dedicated calendar table for time intelligence functions.Date Table = 
CALENDAR(
    MIN(bank_loans_data[issue_date]),
    MAX(bank_loans_data[issue_date])
)
