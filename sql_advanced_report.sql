-- 1. Total Loan Applications

SELECT COUNT(*) AS total_loan_applications
FROM bank_loans_data
WHERE YEAR(issue_date) = 2021;


-- Month To Date (MTD) Loan Applications
SELECT COUNT(id) AS mtd_total_applications 
FROM bank_loans_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous Month To Date (PMTD) Loan Applications
SELECT COUNT(id) AS pmtd_total_applications 
FROM bank_loans_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Month-over-Month changes
WITH MonthlyStats AS (
    SELECT 
        YEAR(issue_date) AS issue_year,
        MONTH(issue_date) AS issue_month,
        COUNT(id) AS mtd_total_loan_applications
    FROM bank_loans_data
    GROUP BY YEAR(issue_date), MONTH(issue_date)
),
CalculatedStats AS (
    SELECT 
        issue_year,
        issue_month,
        mtd_total_loan_applications,
        LAG(mtd_total_loan_applications) OVER (ORDER BY issue_year, issue_month) AS pmtd_total_applications,
        (mtd_total_loan_applications - LAG(mtd_total_loan_applications) OVER (ORDER BY issue_year, issue_month)) 
        / NULLIF(CAST(LAG(mtd_total_loan_applications) OVER (ORDER BY issue_year, issue_month) AS DECIMAL(10,2)), 0) AS mom_change_percentage
    FROM MonthlyStats
)
SELECT issue_year,
       issue_month,
       mtd_total_loan_applications,
       CONCAT(CAST(mom_change_percentage*100.0 AS DECIMAL(10,2)),' ','%') AS mom_change_percentage
FROM CalculatedStats
ORDER BY issue_year DESC, issue_month DESC;




-- 2. Total Funded Amount

-- Total Funded Amount
SELECT CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ', 'Million') AS total_funded_amount 
FROM bank_loans_data;

-- Month To Date (MTD) Funded Amount
SELECT CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ', 'Million') AS mtd_total_funded_amount 
FROM bank_loans_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous Month To Date (PMTD) Funded Amount
SELECT CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ', 'Million') AS pmtd_total_funded_amount 
FROM bank_loans_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Month-over-Month changes 
WITH MonthlyStats AS (
    SELECT 
        YEAR(issue_date) AS issue_year,
        MONTH(issue_date) AS issue_month,
        SUM(loan_amount) AS total_funded_amount
    FROM bank_loans_data
    GROUP BY YEAR(issue_date), MONTH(issue_date)
),
CalculatedStats AS (
    SELECT 
        issue_year,
        issue_month,
        total_funded_amount,
        LAG(total_funded_amount) OVER (ORDER BY issue_year, issue_month) AS pmtd_total_funded_amount,
        (total_funded_amount - LAG(total_funded_amount) OVER (ORDER BY issue_year, issue_month)) 
        / NULLIF(CAST(LAG(total_funded_amount) OVER (ORDER BY issue_year, issue_month) AS DECIMAL(10,2)), 0) AS mom_change_percentage
    FROM MonthlyStats
)
SELECT issue_year,
       issue_month,
       CONCAT(CAST(total_funded_amount/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amount,
       CONCAT(CAST(mom_change_percentage*100.0 AS DECIMAL(10,2)),' ','%') AS mom_change_percentage
FROM CalculatedStats
ORDER BY issue_year DESC, issue_month DESC;





-- 3. Total Received Amount

-- Total Received Amount
SELECT CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ', 'Million') AS total_amount_received 
FROM bank_loans_data;

-- Month To Date (MTD) Received Amount
SELECT CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ', 'Million') AS mtd_total_amount_received  
FROM bank_loans_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Previous Month To Date (PMTD) Received Amount
SELECT SUM(total_payment) AS pmtd_total_amount_received 
FROM bank_loans_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Month-over-Month changes 
WITH MonthlyStats AS (
    SELECT 
        YEAR(issue_date) AS issue_year,
        MONTH(issue_date) AS issue_month,
        SUM(total_payment) AS total_amount_received 
    FROM bank_loans_data
    GROUP BY YEAR(issue_date), MONTH(issue_date)
),
CalculatedStats AS (
    SELECT 
        issue_year,
        issue_month,
        total_amount_received,
        LAG(total_amount_received) OVER (ORDER BY issue_year, issue_month) AS pmtd_total_amount_received,
        (total_amount_received - LAG(total_amount_received) OVER (ORDER BY issue_year, issue_month)) 
        / NULLIF(CAST(LAG(total_amount_received) OVER (ORDER BY issue_year, issue_month) AS DECIMAL(10,2)), 0) AS mom_change_percentage
    FROM MonthlyStats
)
SELECT issue_year,
       issue_month,
       total_amount_received,
       CONCAT(CAST(mom_change_percentage*100.0 AS DECIMAL(10,2)),' ','%') AS mom_change_percentage
FROM CalculatedStats
ORDER BY issue_year DESC, issue_month DESC;





-- 4. Average Interest Rate

-- Avg Interest Rate
SELECT CONCAT(ROUND(AVG(int_rate)*100.0,2),' ','%' ) AS avg_interest_rate 
FROM bank_loans_data;

-- Average interest rate MTD
SELECT CONCAT(ROUND(AVG(int_rate)*100.0,2),' ','%' ) AS mtd_avg_interest_rate 
FROM bank_loans_data 
WHERE YEAR(issue_date)= 2021 AND MONTH(issue_date) = 12;

-- Average interest rate PMTD 
SELECT CONCAT(ROUND(AVG(int_rate)*100.0,2),' ','%' ) AS pmtd_avg_interest_rate 
FROM bank_loans_data 
WHERE YEAR(issue_date)= 2021 AND MONTH(issue_date) = 11; 

-- Month-over-Month changes
WITH MonthlyStats AS (
    SELECT 
        YEAR(issue_date) AS issue_year,
        MONTH(issue_date) AS issue_month,
        ROUND(AVG(int_rate)*100.0,2) AS avg_interest_rate
    FROM bank_loans_data
    GROUP BY YEAR(issue_date), MONTH(issue_date)
),
CalculatedStats AS (
    SELECT 
        issue_year,
        issue_month,
        avg_interest_rate,
        LAG(avg_interest_rate) OVER (ORDER BY issue_year, issue_month) AS pmtd_avg_interest_rate,
        (avg_interest_rate - LAG(avg_interest_rate) OVER (ORDER BY issue_year, issue_month)) 
        / NULLIF(CAST(LAG(avg_interest_rate) OVER (ORDER BY issue_year, issue_month) AS DECIMAL(10,2)), 0) AS mom_change_percentage
    FROM MonthlyStats
)
SELECT issue_year,
       issue_month,
       CONCAT(avg_interest_rate,' ','%') AS total_avg_interest_rate,
       CONCAT(CAST(mom_change_percentage*100.0 AS DECIMAL(10,2)),' ','%') AS mom_change_percentage
FROM CalculatedStats
ORDER BY issue_year DESC, issue_month DESC;





-- 5. Average Debt To Income Ratio (DTI)

SELECT ROUND(AVG(dti)* 100.0,2) AS avg_dti 
FROM bank_loans_data;

-- Month-over-Month changes
WITH MonthlyStats AS (
    SELECT 
        YEAR(issue_date) AS issue_year,
        MONTH(issue_date) AS issue_month,
        ROUND(AVG(dti)*100.0,2) AS avg_dti
    FROM bank_loans_data
    GROUP BY YEAR(issue_date), MONTH(issue_date)
),
CalculatedStats AS (
    SELECT 
        issue_year,
        issue_month,
        avg_dti,
        LAG(avg_dti) OVER (ORDER BY issue_year, issue_month) AS pmtd_avg_dti,
        (avg_dti - LAG(avg_dti) OVER (ORDER BY issue_year, issue_month)) 
        / NULLIF(CAST(LAG(avg_dti) OVER (ORDER BY issue_year, issue_month) AS DECIMAL(10,2)), 0) AS mom_change_percentage
    FROM MonthlyStats
)
SELECT issue_year,
       issue_month,
       CONCAT(avg_dti,' ','%') AS total_avg_dti,
       CONCAT(CAST(mom_change_percentage*100.0 AS DECIMAL(10,2)),' ','%') AS mom_change_percentage
FROM CalculatedStats
ORDER BY issue_year DESC, issue_month DESC;





-- 6. Good Loan And Bad Loans

-- Good Loan Percentage
SELECT 
    CONCAT(CAST(SUM(CASE WHEN loan_Status = 'Fully Paid' OR loan_Status = 'Current' THEN 1 ELSE 0 END) * 100.0
    / COUNT(id) AS DECIMAL(10,2)),' ','%') AS good_loan_percentage
FROM bank_loans_data;

-- Total Good Loan Applications
SELECT CONCAT(CAST(COUNT(*)/1000.0 AS DECIMAL(10,3)),' ','k') AS total_good_loan_applications
FROM bank_loans_data
WHERE loan_status = 'Fully Paid' OR loan_Status = 'Current';

-- Total Good Loan Funded Amount
SELECT CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_good_loan_funded_amount
FROM bank_loans_data
WHERE loan_status = 'Fully Paid' OR loan_Status = 'Current';

-- Total Good Loan Received Amount
SELECT CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_good_loan_received_amount
FROM bank_loans_data
WHERE loan_status = 'Fully Paid' OR loan_Status = 'Current';

-- Bad Loan Percentage
SELECT 
    CONCAT(CAST(SUM(CASE WHEN loan_Status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0
    / COUNT(id) AS DECIMAL(10,2)),' ','%') AS bad_loan_percentage
FROM bank_loans_data;

-- Total Bad Loan Applications
SELECT CONCAT(CAST(COUNT(*)/1000.0 AS DECIMAL(10,3)),' ','k') AS total_bad_loan_applications
FROM bank_loans_data
WHERE loan_status = 'Charged Off';

-- Total Bad Loan Funded Amount 
SELECT CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_bad_loan_funded_amount
FROM bank_loans_data
WHERE loan_status = 'Charged Off';

-- Total Bad Loan Received Amount
SELECT CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_bad_loan_received_amount
FROM bank_loans_data
WHERE loan_status = 'Charged Off';





-- 7. Loan Status Grid View

SELECT loan_status,
       COUNT(*) AS total_loans,
       CONCAT(ROUND(AVG(int_rate)*100.0,2),' ','%') AS avg_interest_rate,
       ROUND(AVG(dti)*100.0,2) AS avg_dti,
       CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
       CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY loan_status;

-- Loans Month To Date (MTD) Grid
SELECT loan_status,
       COUNT(*) AS total_loans,
       CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
       CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
GROUP BY loan_status;




-- Monthly Summary
SELECT 
    DATENAME(MONTH, issue_date) AS month,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY DATENAME(MONTH, issue_date), MONTH(issue_date)
ORDER BY MONTH(issue_date);




-- Regional Summary
SELECT 
    address_state,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC;




-- Term Analysis
SELECT 
    term,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY term;




-- Dependency On Employee Length Analysis
SELECT 
    emp_length,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY emp_length
ORDER BY COUNT(*) DESC;




-- Purpose Analysis
SELECT 
    purpose,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY purpose
ORDER BY COUNT(*) DESC;




-- Home Ownership
SELECT 
    home_ownership,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
GROUP BY home_ownership
ORDER BY COUNT(*) DESC;




-- Grade A Analysis
SELECT 
    home_ownership,
    COUNT(*) AS total_loan_applications,
    CONCAT(CAST(SUM(loan_amount)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_funded_amt,
    CONCAT(CAST(SUM(total_payment)/1000000.0 AS DECIMAL(10,2)),' ','Million') AS total_received_amt
FROM bank_loans_data
WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY COUNT(*) DESC;