---- KPIS

--- question 01 Total Loan Amount Funded
SELECT
    CONCAT(
        ROUND(SUM(Funded_Amount) / 1000000, 2),
        'M'
    ) AS Total_Loan_Amount
FROM loan_clean;

--- question 02 Total loans
SELECT
    CONCAT(
        ROUND(COUNT(*) / 1000, 2),
        'K'
    ) AS Total_Loans
FROM loan_clean;

--- question 3 total collection
select
	concat(
		round(sum(total_payment)/1000000,3),
        'M') as total_collection
from loan_clean;

--- question 4 total interest 
select 
	concat(
		round(sum(total_rrec_int)/1000000,2),
        'M') as Total_Interest
from loan_clean;

--- question 5 Branch wise perforamance((Interest, Fees, Total Revenue))
select 
branch_name,
concat(round(sum(total_rrec_int)/1000000,2),'M') as total_interest,
concat(round(sum(total_fees)/1000,2), 'K') as Total_fees,
concat(round(sum(total_rrec_int+total_fees)/1000000,2), 'K') as Total_Revenue
from loan_clean
group by Branch_Name;

--- 06 question state wise loan distribution
select state_name,
concat(round(sum(funded_amount)/1000000,2), ' M ')as Total_Amount
from loan_clean
group by State_Name
order by total_amount desc;

---- 07  religion wise loan distribution 
select
religion,
concat(round(count(*)/1000,2),'K')as total_amt
from loan_clean
group by Religion
order by total_amt desc;

--- 08 product group wise loan distribution
select 
purpose_category,
sum(funded_amount) as Total_amt,
count(*) as Total_Loans
from loan_clean
group by Purpose_Category
order by Total_amt desc;

--- question 09 Disbursement trend
SELECT
    YEAR(Disbursement_Date) AS Year,
    COUNT(*) AS Total_Loans,
    SUM(Funded_Amount) AS Total_Funded_Amount
FROM loan_clean
WHERE Disbursement_Date IS NOT NULL
GROUP BY YEAR(Disbursement_Date)
ORDER BY Year desc;

--- 10 Grade wise Loan
SELECT
    Grade,
    COUNT(*) AS Total_Loans,
    SUM(Funded_Amount) AS Total_Funded_Amount,
    ROUND(AVG(Int_Rate), 2) AS Average_Interest_Rate
FROM loan_clean
GROUP BY Grade
ORDER BY Total_Loans DESC;

--- 11. Count of Default Loans
select is_default_loan,
count(*) as total_loans from loan_clean
where is_default_loan ='Y';
use bank;
--- 12 count deliquent loan
select is_deliquent_loan,
count(*) as Total_loans
from loan_clean
where is_deliquent_loan = 'Y';

--- 13 Default loan rate 
select 
count(*) as total_loans,
sum(case when is_default_loan = 'Y' then 1 else 0 end) as default_loan,
round(
sum(case when is_default_loan = 'Y' then 1 else 0 end) / count(*) * 100,2) as Default_rate
from loan_clean;

--- 14 deliquent loan rate
select
count(*) as total_loans,
sum(case when is_deliquent_loan = 'Y' then 1 else 0 end) as Deliquent_loan,
round(
sum(case when is_deliquent_loan = 'Y' then 1 else 0 end) / count(*)*100,2) as Deliquent_Loan_Rate
from loan_clean;

--- 15 loan status wise loan distribution
SELECT
    Loan_Status,
    COUNT(*) AS Total_Loans,
    concat(round(SUM(Funded_Amount)/1000000,2), ' M ') AS Total_Funded_Amount
FROM loan_clean
GROUP BY Loan_Status
ORDER BY Total_Loans DESC;

--- 16 Age group wise loan distribution
SELECT
    Age,
    concat(round(COUNT(*)/1000,2),' K ') AS Total_Loans,
    concat(round(SUM(Funded_Amount)/1000000,2),' M ') AS Total_Funded_Amount,
    concat(ROUND(AVG(Funded_Amount)/1000, 2),' K ') AS Average_Loan
FROM loan_clean
GROUP BY Age
ORDER BY Total_Loans DESC;

--- 17 no verified loan
select verification_status, count(*) AS total_loans
from loan_clean
where Verification_Status = 'Not Verified';

---- 18 loan maturity 
SELECT
    Term,
    COUNT(*) AS Total_Loans
FROM loan_clean
GROUP BY Term
ORDER BY Term;






