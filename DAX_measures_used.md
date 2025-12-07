# Bank Loan Analytics - DAX Measures

A compact, well-structured Markdown reference of all Data Analysis Expressions (DAX) used in the **Bank Loan Analytics Dashboard**. Measures are grouped by function (KPIs, Time Intelligence, Risk Analysis, etc.) to make the file easy to browse and copy into Power BI.

---

## Table of contents

1. [Base Key Performance Indicators (KPIs)](#1-base-key-performance-indicators-kpis)
2. [Good vs. Bad Loan Analysis](#2-good-vs-bad-loan-analysis)
3. [Time Intelligence](#3-time-intelligence)
4. [Data Modeling & Parameters](#4-data-modeling--parameters)
5. [Date Table (Calculated Table)](#5-date-table-calculated-table)


---

## 1. Base Key Performance Indicators (KPIs)

Core metrics used throughout the dashboard.

**Total Loan Applications**

```dax
Total Loan Applications = COUNT(bank_loans_data[id])
```

**Total Funded Amount**

```dax
Total Funded Amount = SUM(bank_loans_data[loan_amount])
```

**Total Received Amount**

```dax
Total Received Amount = SUM(bank_loans_data[total_payment])
```

**Avg Interest Rate**

```dax
Avg Interest Rate = AVERAGE(bank_loans_data[int_rate])
```

**Avg DTI**

```dax
Avg DTI = AVERAGE(bank_loans_data[dti])
```

---

## 2. Good vs. Bad Loan Analysis

Measures to assess portfolio risk and quality.

### Good Loans

**Good Loan Applications**

```dax
Good Loan Applications = CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Good Loans")
```

**Good Loan Application %**

```dax
Good Loan Application % = DIVIDE(
    CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Good Loans"),
    [Total Loan Applications]
)
```

**Good Loan Funded Amount**

```dax
Good Loan Funded Amount = CALCULATE([Total Funded Amount], bank_loans_data[Good vs Bad Loans] = "Good Loans")
```

**Good Loan Received Amount**

```dax
Good Loan Received Amount = CALCULATE([Total Received Amount], bank_loans_data[Good vs Bad Loans] = "Good Loans")
```

### Bad Loans

**Bad Loan Applications**

```dax
Bad Loan Applications = CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Bad Loans")
```

**Bad Loan %**

```dax
Bad Loan % = DIVIDE(
    CALCULATE([Total Loan Applications], bank_loans_data[Good vs Bad Loans] = "Bad Loans"),
    [Total Loan Applications]
)
```

**Bad Loan Funded Amount**

```dax
Bad Loan Funded Amount = CALCULATE([Total Funded Amount], bank_loans_data[Good vs Bad Loans] = "Bad Loans")
```

**Bad Loan Received Amount**

```dax
Bad Loan Received Amount = CALCULATE([Total Received Amount], bank_loans_data[Good vs Bad Loans] = "Bad Loans")
```

---

## 3. Time Intelligence

Month-to-Date (MTD) metrics and month-over-month (MoM) comparisons.

### Month-to-Date (MTD)

Metrics calculated for the current month in the evaluation context.

**MTD Loan Applications**

```dax
MTD Loan Applications = CALCULATE(TOTALMTD([Total Loan Applications], 'Date Table'[Date]))
```

**MTD Funded Amount**

```dax
MTD Funded Amount = CALCULATE(TOTALMTD([Total Funded Amount], 'Date Table'[Date]))
```

**MTD Received Amount**

```dax
MTD Received Amount = CALCULATE(TOTALMTD([Total Received Amount], 'Date Table'[Date]))
```

**MTD Interest Rate**

```dax
MTD Interest Rate = CALCULATE(TOTALMTD([Avg Interest Rate], 'Date Table'[Date]))
```

**MTD DTI**

```dax
MTD DTI = CALCULATE(TOTALMTD([Avg DTI], 'Date Table'[Date]))
```

### Previous Month-to-Date (PMTD)

Calculated for the same period in the previous month (used for MoM variance).

**PMTD Loan Applications**

```dax
PMTD Loan Applications = CALCULATE([Total Loan Applications], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
```

**PMTD Funded Amount**

```dax
PMTD Funded Amount = CALCULATE([Total Funded Amount], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
```

**PMTD Amount Received**

```dax
PMTD Amount Received = CALCULATE([Total Received Amount], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
```

**PMTD Interest Rate**

```dax
PMTD Interest Rate = CALCULATE([Avg Interest Rate], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
```

**PMTD DTI**

```dax
PMTD DTI = CALCULATE([Avg DTI], DATESMTD(DATEADD('Date Table'[Date], -1, MONTH)))
```

### Month-over-Month (MoM) Growth

Percentage change metrics to track growth trends.

**MoM Loan Applications**

```dax
MoM Loan Applications = DIVIDE(([MTD Loan Applications] - [PMTD Loan Applications]), [PMTD Loan Applications])
```

**MoM Funded Amount**

```dax
MoM Funded Amount = DIVIDE(([MTD Funded Amount] - [PMTD Funded Amount]), [PMTD Funded Amount])
```

**MoM Amount Received**

```dax
MoM Amount Received = DIVIDE(([MTD Received Amount] - [PMTD Amount Received]), [PMTD Amount Received])
```

**MoM Interest Rate**

```dax
MoM Interest Rate = DIVIDE(([MTD Interest Rate] - [PMTD Interest Rate]), [PMTD Interest Rate])
```

**MoM DTI**

```dax
MoM DTI = DIVIDE(([MTD DTI] - [PMTD DTI]), [PMTD DTI])
```

---

## 4. Data Modeling & Parameters

**Dynamic Measure Selector** - for dynamic visuals where a user can switch between metrics.

```dax
Select Measure = {
    ("Total Received Amount", NAMEOF('bank_loans_data'[Total Received Amount]), 0),
    ("Total Loan Applications", NAMEOF('bank_loans_data'[Total Loan Applications]), 1),
    ("Total Funded Amount", NAMEOF('bank_loans_data'[Total Funded Amount]), 2)
}
```

---

## 5. Date Table (Calculated Table)

A dedicated calendar table for time intelligence functions.

```dax
Date Table =
CALENDAR(
    MIN(bank_loans_data[issue_date]),
    MAX(bank_loans_data[issue_date])
)
```


---
