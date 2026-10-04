create database bank;
use bank;

select * from loan_data
limit 10;

--- understand the column
select column_name,
data_type
from information_schema.columns
where
table_schema='bank' 
and table_name='loan_data'
order by ordinal_position;

--- clean data
use bank;
drop table if exists loan_clean;
create table loan_clean as select * from loan_data;
select count(*) from loan_clean;

-- sample data
SELECT *
FROM loan_clean
LIMIT 10;

-- 01 First see the exact column names
USE bank;

SHOW COLUMNS FROM loan_clean;
---- rename the column names

select credif_officer_name from loan_clean;
USE bank;

  SHOW COLUMNS FROM loan_clean;
  
  ALTER TABLE loan_clean
RENAME COLUMN Loan_Transferdate TO Loan_Transfer_Date;

ALTER TABLE loan_clean
RENAME COLUMN NextMeetingDate TO Next_Meeting_Date;

ALTER TABLE loan_clean
RENAME COLUMN  `Credif _Officer_Name` to Credit_officer_name;

alter table loan_clean
rename column `Grrade` to grade;

alter table loan_clean
rename column `Tranfer_Logic` to transfer_logic;

alter table loan_clean
rename column `Total_Pyament` to total_payment;

alter table loan_clean
rename column `Total_Pymnt_inv` to total_payment_inv;

alter table loan_clean
rename column `Dateof _Birth` to Date_of_birth;

alter table loan_clean
rename column `Client_Name` to client_name;

-- 02 check null ,blank and space 
SELECT
    SUM(CASE WHEN State_Abbr IS NULL THEN 1 ELSE 0 END) AS State_Abbr_NULL,
    SUM(CASE WHEN State_Abbr IS NOT NULL AND TRIM(State_Abbr) = '' THEN 1 ELSE 0 END) AS State_Abbr_Blank,

    SUM(CASE WHEN Account_ID IS NULL THEN 1 ELSE 0 END) AS Account_ID_NULL,
    SUM(CASE WHEN Account_ID IS NOT NULL AND TRIM(Account_ID) = '' THEN 1 ELSE 0 END) AS Account_ID_Blank,

    SUM(CASE WHEN BH_Name IS NULL THEN 1 ELSE 0 END) AS BH_Name_NULL,
    SUM(CASE WHEN BH_Name IS NOT NULL AND TRIM(BH_Name) = '' THEN 1 ELSE 0 END) AS BH_Name_Blank,

    SUM(CASE WHEN Bank_Name IS NULL THEN 1 ELSE 0 END) AS Bank_Name_NULL,
    SUM(CASE WHEN Bank_Name IS NOT NULL AND TRIM(Bank_Name) = '' THEN 1 ELSE 0 END) AS Bank_Name_Blank,

    SUM(CASE WHEN Branch_Name IS NULL THEN 1 ELSE 0 END) AS Branch_Name_NULL,
    SUM(CASE WHEN Branch_Name IS NOT NULL AND TRIM(Branch_Name) = '' THEN 1 ELSE 0 END) AS Branch_Name_Blank,

    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_NULL,
    SUM(CASE WHEN City IS NOT NULL AND TRIM(City) = '' THEN 1 ELSE 0 END) AS City_Blank

FROM loan_clean;

SELECT
    SUM(CASE WHEN Religion IS NULL THEN 1 ELSE 0 END) AS Religion_NULL,
    SUM(CASE WHEN Religion IS NOT NULL AND TRIM(Religion) = '' THEN 1 ELSE 0 END) AS Religion_Blank,

    SUM(CASE WHEN Loan_Status IS NULL THEN 1 ELSE 0 END) AS Loan_Status_NULL,
    SUM(CASE WHEN Loan_Status IS NOT NULL AND TRIM(Loan_Status) = '' THEN 1 ELSE 0 END) AS Loan_Status_Blank,

    SUM(CASE WHEN Verification_Status IS NULL THEN 1 ELSE 0 END) AS Verification_Status_NULL,
    SUM(CASE WHEN Verification_Status IS NOT NULL AND TRIM(Verification_Status) = '' THEN 1 ELSE 0 END) AS Verification_Status_Blank,

    SUM(CASE WHEN Product_Code IS NULL THEN 1 ELSE 0 END) AS Product_Code_NULL,
    SUM(CASE WHEN Product_Code IS NOT NULL AND TRIM(Product_Code) = '' THEN 1 ELSE 0 END) AS Product_Code_Blank,

    SUM(CASE WHEN Sub_Grade IS NULL THEN 1 ELSE 0 END) AS Sub_Grade_NULL,
    SUM(CASE WHEN Sub_Grade IS NOT NULL AND TRIM(Sub_Grade) = '' THEN 1 ELSE 0 END) AS Sub_Grade_Blank,

    SUM(CASE WHEN Purpose_Category IS NULL THEN 1 ELSE 0 END) AS Purpose_Category_NULL,
    SUM(CASE WHEN Purpose_Category IS NOT NULL AND TRIM(Purpose_Category) = '' THEN 1 ELSE 0 END) AS Purpose_Category_Blank

FROM loan_clean;

SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_NULL,

    SUM(CASE WHEN Loan_Amount IS NULL THEN 1 ELSE 0 END) AS Loan_Amount_NULL,

    SUM(CASE WHEN Funded_Amount IS NULL THEN 1 ELSE 0 END) AS Funded_Amount_NULL,

    SUM(CASE WHEN Int_Rate IS NULL THEN 1 ELSE 0 END) AS Int_Rate_NULL,

    SUM(CASE WHEN Total_Pyament IS NULL THEN 1 ELSE 0 END) AS Total_Payment_NULL,

    SUM(CASE WHEN Total_Rec_Prncp IS NULL THEN 1 ELSE 0 END) AS Total_Rec_Prncp_NULL,

    SUM(CASE WHEN Total_Fees IS NULL THEN 1 ELSE 0 END) AS Total_Fees_NULL,

    SUM(CASE WHEN Total_Rrec_int IS NULL THEN 1 ELSE 0 END) AS Total_Rec_int_NULL,

    SUM(CASE WHEN Recoveries IS NULL THEN 1 ELSE 0 END) AS Recoveries_NULL

FROM loan_clean;

---- 03 replace null and blank values 
---- religion column has 7 null values we do not know exactly which religion is it so it's better to replace with "Unknown"

use bank;
update loan_clean
set religion = "Unknown"
where religion is null
or trim(religion)='';

select religion,
count(*) as total_loan
from loan_clean
group by religion;

--- 3A verification status column has 25818 null values 
select verification_status,
count(*) as Total_loans
from loan_clean
group by verification_status;
--- There are 25,818 NULL values.

--- A NULL value does not confirm that a loan was not verified.
--- It only indicates that verification information is unavailable
--- in the source data.
---- Therefore, NULL values are classified as 'Unknown' rather than
--- ' Not Verified'
--- This prevents missing information from being incorrectly treated
-- as a business outcome.

UPDATE loan_clean
SET Verification_Status = 'Unknown'
WHERE TRIM(Verification_Status) = '';

--- 3B sub_grade column has 25818
SELECT
    Grade,
    COUNT(*) AS Blank_Sub_Grade
FROM loan_clean
WHERE TRIM(Sub_Grade) = ''
GROUP BY Grade
ORDER BY Blank_Sub_Grade DESC;

--- Confirm both are blank
SELECT COUNT(*) AS Both_Blank
FROM loan_clean
WHERE TRIM(Grade) = ''
  AND TRIM(Sub_Grade) = '';
  
  UPDATE loan_clean
SET Grade = 'Unknown'
WHERE TRIM(Grade) = '';

UPDATE loan_clean
SET Home_Ownership = 'Unknown'
WHERE TRIM(Home_Ownership) = '';

UPDATE loan_clean
SET Sub_Grade = 'Unknown'
WHERE TRIM(Sub_Grade) = '';

-- Verify
SELECT
    Grade,
    Sub_Grade,
    COUNT(*) AS Total_Loans
FROM loan_clean
GROUP BY Grade, Sub_Grade
ORDER BY Total_Loans DESC;

--- 04 Standardize text values 
select bh_name from loan_clean;

UPDATE loan_clean
SET BH_Name = TRIM(BH_Name);

select branch_name from loan_clean;
--- remove space 
update loan_clean
set branch_name= trim(branch_name);

--- Standardize capitalization
UPDATE loan_clean
SET branch_name = CONCAT(UPPER(LEFT(TRIM(branch_name),1)), LOWER(SUBSTRING(TRIM(branch_name),2)))
WHERE branch_name IS NOT NULL;

select city from loan_clean;
update loan_clean
set city = trim(city);

--- standardize capitalization
update loan_clean
SET branch_name = CONCAT(UPPER(LEFT(TRIM(city),1)), LOWER(SUBSTRING(TRIM(city),2)))
WHERE city IS NOT NULL;

select client_name from loan_clean
limit 1000;
--- remove extra space 
update loan_clean
set client_name = trim(client_name);

select home_ownership from loan_clean;
update loan_clean
set home_ownership = trim(home_ownership);

update loan_clean
set home_ownership = concat(upper(left(trim(home_ownership),1)),lower(substring(trim(home_ownership),2)))
where home_ownership is not null;

--- 05 check data types and convert right data types
select center_id from loan_clean;
SELECT COUNT(*) AS Blank_Center_ID
FROM loan_clean
WHERE TRIM(Center_ID) = '';

-- Convert blank → NULL
UPDATE loan_clean
SET Center_ID = NULL
WHERE TRIM(Center_ID) = '';

SELECT COUNT(*) AS Missing_Center_ID
FROM loan_clean
WHERE Center_ID IS NULL;

ALTER TABLE loan_clean
MODIFY COLUMN Center_ID INT NULL;

select disbursement_date from loan_clean;

---  Check how many values use /
SELECT COUNT(*) AS Slash_Dates
FROM loan_clean
WHERE Disbursement_Date LIKE '%/%';

SELECT COUNT(*) AS Dash_Dates
FROM loan_clean
WHERE Disbursement_Date LIKE '%-%';

-- Fix Disbursement_Date - handles both / and -
UPDATE loan_clean
SET disbursement_date = 
  CASE 
    WHEN disbursement_date LIKE '%/%' THEN STR_TO_DATE(TRIM(disbursement_date), '%d/%m/%Y')
    WHEN disbursement_date LIKE '%-%' THEN STR_TO_DATE(TRIM(disbursement_date), '%d-%m-%Y')
    ELSE NULL
  END;
  
  select disbursement_date from loan_clean;
  ALTER TABLE loan_clean
MODIFY COLUMN Disbursement_Date DATE;

--- A1
select date_of_birth from loan_clean;
UPDATE loan_clean
SET date_of_birth  = 
  CASE 
    WHEN date_of_birth LIKE '%/%' THEN STR_TO_DATE(TRIM(date_of_birth), '%d/%m/%Y')
    WHEN date_of_birth  LIKE '%-%' THEN STR_TO_DATE(TRIM(date_of_birth), '%d-%m-%Y')
    ELSE NULL
  END;
  
   ALTER TABLE loan_clean
MODIFY COLUMN date_of_birth DATE;

--- A2
select next_meeting_date from loan_clean;

UPDATE loan_clean
SET next_meeting_date   = 
  CASE 
    WHEN next_meeting_date  LIKE '%/%' THEN STR_TO_DATE(TRIM(next_meeting_date), '%d/%m/%Y')
    WHEN next_meeting_date  LIKE '%-%' THEN STR_TO_DATE(TRIM(next_meeting_date), '%d-%m-%Y')
    ELSE NULL
  END;
  
   ALTER TABLE loan_clean
MODIFY COLUMN next_meeting_date  DATE;

 ALTER TABLE loan_clean
MODIFY COLUMN loan_amount decimal;

 ALTER TABLE loan_clean
MODIFY COLUMN funded_amount decimal;

 ALTER TABLE loan_clean
MODIFY COLUMN funded_amount_inv decimal;

 ALTER TABLE loan_clean
MODIFY COLUMN  int_rate decimal;

---- 06 find duplicate records 

select account_id,
count(*) as Duplicate_counts
from loan_clean
group by account_id
having count(*)>1
order by duplicate_counts desc;

--- 07 data validation
--- before calculate kpi we need to make sure data makes business sence

-- 1. Check total records
select count(*) total_loans from loan_clean;

--- 02 check age
select min(loan_amount) as minimum_amount,
max(loan_amount) as maximum_amt,
round(avg(loan_amount),2) as average_amt
from loan_clean;

