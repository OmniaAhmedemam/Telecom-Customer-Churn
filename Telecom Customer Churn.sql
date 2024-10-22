--Data Cleaning--
--Check duplicate values
SELECT  customer_id,COUNT(Customer_ID)  
FROM telecom_customer_churn
GROUP BY Customer_ID

select count (distinct customer_id)
from telecom_customer_churn
--No Duplicate


-- Data Exploration--
--KPI
select SUM(case when customer_status='Churned' then 1 else 0 end)as Churned_num,
       ROUND(sum(case when customer_status = 'Churned' then 1 else 0 end)*1.0/(select COUNT (distinct customer_id) from telecom_customer_churn),2) as #Churned,
	   sum(case when customer_status='Joined' then 1 else 0 end) as Joined_num,
	   ROUND(sum(case when customer_status = 'Joined' then 1 else 0 end)*1.0/(select COUNT(distinct customer_id) from telecom_customer_churn),2) as #Joined,
       SUM(case when customer_status='Stayed' then 1 else 0 end)as Stayed_num,
       ROUND(sum(case when customer_status = 'Stayed' then 1 else 0 end)*1.0/(select COUNT (distinct customer_id) from telecom_customer_churn),2) as #Sta
	   from telecom_customer_churn

select ROUND(sum(total_revenue),2),
       (select ROUND(sum(total_revenue),2) from telecom_customer_churn where Customer_Status='Churned')as total_revenue_churned,
	   (select ROUND(sum(total_revenue),2) from telecom_customer_churn where Customer_Status='Joined') as total_revenue_Joined,
	   (select ROUND(sum(total_revenue),2) from telecom_customer_churn where Customer_Status='Stayed') as total_revenue_Stayed
	   from telecom_customer_churn

-- What are main reasons for churn?

select churn_category,ROUND(COUNT(churn_category)*1.0/(select count(*) from telecom_customer_churn where Customer_Status='Churned'),2) as percantage
from telecom_customer_churn
group by Churn_Category
order by percantage desc


-- Specific reason for churn

select churn_reason,ROUND(count(churn_reason)*1.0/(select count(*) from telecom_customer_churn where Customer_Status='Churned'),2) as percentage
from telecom_customer_churn
group by Churn_Reason
order by percentage desc


-- Top 5 cities have highest churn rate (>30 custoemrs) 
select  top (5)city ,COUNT(distinct customer_id)as churn_num,Round(sum(case when customer_status='Churned' then 1 else 0 end)*1.0/COUNT(distinct customer_id),2) as churn_rate
from telecom_customer_churn
group by City
Having COUNT(distinct Customer_ID)>30
order by churn_rate desc

--Gender
SELECT Gender,
    SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Gender
ORDER BY churned_num;


--which cities have poor support service ##
SELECT top(10)City, Churn_Reason, COUNT(*) AS num
FROM telecom_customer_churn
GROUP BY City,Churn_Reason
HAVING Churn_Reason = 'Attitude of support person'
ORDER BY num DESC;

--Married
SELECT Married,
	   SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Married
ORDER BY churned_num;

select gender,iif(age>=60,'senior customer','young customer') as age_segment,count(distinct customer_id)
from telecom_customer_churn
group by Gender,IIF(age>=60,'senior customer','young customer')

--Denpendents
SELECT IiF(Number_of_Dependents>0,'having dependents','no dependent') AS Dependent,
    SUM(case when Customer_Status='Churned'then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY IiF(Number_of_Dependents>0,'having dependents','no dependent')


--NO OF Referrals
SELECT 
	   (CASE
            WHEN Number_of_Referrals=0 THEN '0'
			WHEN Number_of_Referrals BETWEEN 1 AND 4 THEN '1-4'
			WHEN Number_of_Referrals BETWEEN 5 AND 8 THEN '5-8'
			ELSE '>8'
        END) AS Number_of_Referrals_segment,
	   SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY (CASE
            WHEN Number_of_Referrals=0 THEN '0'
			WHEN Number_of_Referrals BETWEEN 1 AND 4 THEN '1-4'
			WHEN Number_of_Referrals BETWEEN 5 AND 8 THEN '5-8'
			ELSE '>8'
        END) 


--Customer status of different tenture
SELECT 
    (CASE
   WHEN Tenure_in_Months BETWEEN 0 AND 6 THEN '<0.5 year'
   WHEN Tenure_in_Months BETWEEN 7 AND 12 THEN '0.5-1 year'
            WHEN Tenure_in_Months BETWEEN 13 AND 24 THEN '1-2 years'
   ELSE '>2 years'
        END) AS Tenure_in_Months_segment,
    SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end ) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY  (CASE
   WHEN Tenure_in_Months BETWEEN 0 AND 6 THEN '<0.5 year'
   WHEN Tenure_in_Months BETWEEN 7 AND 12 THEN '0.5-1 year'
            WHEN Tenure_in_Months BETWEEN 13 AND 24 THEN '1-2 years'
   ELSE '>2 years'
        END)
ORDER BY churned_num

-- Average tenure of churned customers
select AVG(tenure_in_months)
from telecom_customer_churn
where Customer_Status='Churned'

-- Average and median value of customer lifespan 
SELECT AVG(Tenure_in_Months)
FROM telecom_customer_churn



-- Add service column
ALTER TABLE telecom_customer_churn  ADD service varchar(255) 
UPDATE telecom_customer_churn
SET service = case
              when Phone_Service=1 and Internet_Service= 1 then 'Both'
			  when Phone_Service= 1 and Internet_Service= 0 then 'Phone_service' else 'Internet_service' end

alter table telecom_customer_churn add contact varchar(255)

update telecom_customer_churn
set contact = IIF(married = 0 and Number_of_Dependents= 0,'no_contact','contact')


--Phone service
SELECT Phone_Service,
    Multiple_Lines,
    SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
     SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
     SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num  
FROM telecom_customer_churn
GROUP BY Phone_Service,Multiple_Lines
ORDER BY Phone_Service

--Internet service/type
SELECT Internet_Service,
       Internet_Type,
    SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Internet_Service,Internet_Type
ORDER BY Internet_Service,Internet_Type

--Contract
SELECT Contract,
	   SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Contract;


--Offer
SELECT Offer, Round (COUNT(Offer)*1.0/(SELECT COUNT(*) FROM telecom_customer_churn WHERE Customer_Status='Churned'),2) AS percentage
FROM telecom_customer_churn
WHERE Customer_Status='Churned'
GROUP BY Offer;


SELECT contact, Multiple_Lines, COUNT(iIF(Age>=60,1,NULL)) AS senior_citizen, COUNT(iIF(Age<60,1,NULL)) AS young_people
FROM telecom_customer_churn
WHERE Phone_Service = 1
GROUP BY contact, Multiple_Lines;


SELECT Churn_Category,Churn_Reason,COUNT(*)*1.0/(SELECT COUNT(*) FROM telecom_customer_churn WHERE Customer_Status='Churned') AS percentage
FROM telecom_customer_churn
WHERE Customer_Status='Churned' AND Internet_Type = 'Fiber Optic'
GROUP BY Churn_Category,Churn_Reason


--Payment method and billing type
--Paperless billing
SELECT Paperless_Billing,
	   SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Paperless_Billing

--Payment method
SELECT Payment_Method,
	   SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
FROM telecom_customer_churn
GROUP BY Payment_Method





-- Identify high-value customer
-- Factor analysis based on payment factor such as Monthly_Charge and loyalty factor such as Tenure_in_Months, Number_of_Referrals

-- Step 1: Calculate Quartile of Monthly_Charge and store it in a temp table
SELECT Customer_ID,
       CASE 
         WHEN PERCENT_RANK() OVER(ORDER BY Monthly_Charge) < 0.25 THEN 0
         WHEN PERCENT_RANK() OVER(ORDER BY Monthly_Charge) BETWEEN 0.25 AND 0.5 THEN 1
         WHEN PERCENT_RANK() OVER(ORDER BY Monthly_Charge) BETWEEN 0.5 AND 0.75 THEN 2
         ELSE 3
       END Monthly_Charge_score
INTO #chargescore
FROM telecom_customer_churn

-- Step 2: Calculate Quartile of Tenure and store it in a temp table
SELECT Customer_ID,
       CASE 
         WHEN PERCENT_RANK() OVER(ORDER BY Tenure_in_Months) < 0.25 THEN 0
         WHEN PERCENT_RANK() OVER(ORDER BY Tenure_in_Months) BETWEEN 0.25 AND 0.5 THEN 1
         WHEN PERCENT_RANK() OVER(ORDER BY Tenure_in_Months) BETWEEN 0.5 AND 0.75 THEN 2
         ELSE 3
       END Tenure_in_Months_score
INTO #tenurescore
FROM telecom_customer_churn

-- Step 3: Calculate Quartile of Referrals and store it in a temp table
SELECT Customer_ID,
       CASE 
         WHEN PERCENT_RANK() OVER(ORDER BY Number_of_Referrals) < 0.25 THEN 0
         WHEN PERCENT_RANK() OVER(ORDER BY Number_of_Referrals) BETWEEN 0.25 AND 0.5 THEN 1
         WHEN PERCENT_RANK() OVER(ORDER BY Number_of_Referrals) BETWEEN 0.5 AND 0.75 THEN 2
         ELSE 3
       END Number_of_Referrals_score
INTO #referralscore
FROM telecom_customer_churn

-- Step 4: Combine the scores and calculate the total score for each customer
SELECT c.Customer_ID, 
       (0.6 * c.Monthly_Charge_score + 0.2 * t.Tenure_in_Months_score + 0.2 * r.Number_of_Referrals_score) total_score
INTO customervalue
FROM #chargescore c
JOIN #tenurescore t ON c.Customer_ID = t.Customer_ID
JOIN #referralscore r ON c.Customer_ID = r.Customer_ID;

-- Step 5: Clean up temp tables
DROP TABLE #chargescore;
DROP TABLE #tenurescore;
DROP TABLE #referralscore;

alter table customervalue add customer_value varchar(50)
update customervalue set customer_value = case when total_score>=2 then 'high_value' else 'low_value'end



select customer_value,
       SUM(case when Customer_Status='Churned' then 1 else 0 end) AS churned_num,
       SUM(case when Customer_Status='Stayed' then 1 else 0 end) AS stayed_num,
       SUM(case when Customer_Status='Joined' then 1 else 0 end) AS joined_num
from customervalue c join telecom_customer_churn t
on t.Customer_ID=c.Customer_ID
group by customer_value

alter table customervalue add churned_risk varchar(50)

UPDATE customervalue
SET churned_risk = CASE
   WHEN (isnull (IIF(Age >= 60, 1, 0),0) + ISNULL( IIF(contact = 'no contact', 1, 0),0) +
         isnull (IIF(Number_of_Referrals <= 4, 1, 0),0) +ISNULL( IIF(Tenure_in_Months < 6, 1, 0),0) +
         isnull (IIF(Internet_Type = 'Fiber Optic', 1, 0),0) + isnull (IIF(OFFER = 'Offer E', 1, 0),0) +
         isnull (IIF(Contract = 'Month-to-Month', 1, 0),0) + isnull (IIF(Online_Security = 0, 1, 0),0) +
        isnull( IIF(Online_Backup = 0, 1, 0),0) + isnull (IIF(Device_Protection_Plan = 0, 1, 0),0)+
        isnull( IIF(Premium_Tech_Support = 0, 1, 0),0) + ISNULL( IIF(Unlimited_Data = 0, 1, 0),0) +
        isnull( IIF(Paperless_Billing = 0, 1, 0),0)) > 4 THEN 'High risk'
   WHEN ( isnull (IIF(Age >= 60, 1, 0),0) + isnull (IIF(contact = 'no contact', 1, 0),0) +
        isnull( IIF(Number_of_Referrals <= 4, 1, 0),0) +ISNULL( IIF(Tenure_in_Months < 6, 1, 0),0) +
       ISNULL(  IIF(Internet_Type = 'Fiber Optic', 1, 0),0) +ISNULL( IIF(OFFER = 'Offer E', 1, 0),0) +
        ISNULL( IIF(Contract = 'Month-to-Month', 1, 0),0) +ISNULL( IIF(Online_Security = 0, 1, 0),0) +
       ISNULL(  IIF(Online_Backup = 0, 1, 0),0) + isnull (IIF(Device_Protection_Plan = 0, 1, 0),0) +
        ISNULL( IIF(Premium_Tech_Support = 0, 1, 0),0) + isnull (IIF(Unlimited_Data = 0, 1, 0),0) +
      isnull(   IIF(Paperless_Billing = 0, 1, 0),0)) < 3 THEN 'Low risk'
   ELSE 'Middle risk'
END
FROM customervalue c
JOIN telecom_customer_churn t
ON t.customer_ID = c.Customer_ID
WHERE Customer_Status = 'Stayed' OR Customer_Status = 'Joined';







SELECT  Customer_Status,customers_value,
    (CASE
   WHEN num_risk_factors>4 Then 'High risk'
   WHEN num_risk_factors<3 Then 'Low risk'
   ELSE 'Middle risk'
        END) AS churned_risk
FROM
(
SELECT 
 iIF(total_score>=2,'high value','low value') AS customers_value,
    Customer_Status,
 (iIF(Age>=60,1,0)+
   iIF(contact='no contact',1,0)+
   iIF(Number_of_Referrals<=4,1,0)+
   iIF(Tenure_in_Months<6,1,0)+
   IIF(Internet_Type = 'Fiber Optic',1,0)+
  IIF(OFFER = 'Offer E',1,0)+
  IIF(Contract = 'Month-to-Month',1,0)+
  IIF(Online_Security = 0,1,0)+
  IIF(Online_Backup = 0,1,0)+
  IIF(Device_Protection_Plan = 0,1,0)+
  IIF(Premium_Tech_Support=0,1,0)+
   IIF(Unlimited_Data = 0,1,0)+
  iIF(Paperless_Billing = 0,1,0)
     ) AS num_risk_factors
FROM customervalue c
JOIN telecom_customer_churn t
on t.customer_ID=c.Customer_ID
WHERE Customer_Status='Stayed' OR Customer_Status='Joined'
) temp
GROUP BY Customer_Status,customers_value, (CASE
   WHEN num_risk_factors>4 Then 'High risk'
   WHEN num_risk_factors<3 Then 'Low risk'
   ELSE 'Middle risk'
        END) 
ORDER BY Customer_Status,customers_value






-- create riskfactor table
SELECT *
INTO riskfactor
FROM (
    SELECT 
        'senior citizen' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Age >= 60) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Age >= 60 

    UNION

    SELECT 
        'no contact' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE contact = 'no contact') AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND contact = 'no contact'
    GROUP BY contact

    UNION

    SELECT 
        '<=0.5 year tenure' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Tenure_in_Months <= 6) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Tenure_in_Months <= 6

    UNION

    SELECT 
        '<=4 referrals' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Number_of_Referrals <= 4) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Number_of_Referrals <= 4

    UNION

    SELECT 
        'Offer E' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Offer = 'Offer E') AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Offer = 'Offer E'

    UNION

    SELECT 
        'Online_Security NO' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Online_Security = 0) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Online_Security = 0

    UNION

    SELECT 
        'Premium_Tech_Support NO' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Premium_Tech_Support = 0) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Premium_Tech_Support = 0

    UNION

    SELECT 
        'Paperless billing' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Paperless_Billing = 1) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Paperless_Billing = 1

    UNION

    SELECT 
        'Bank Withdrawal' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Payment_Method = 'Bank Withdrawal') AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Payment_Method = 'Bank Withdrawal'

    UNION

    SELECT 
        'Mailed Check' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Payment_Method = 'Mailed Check') AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Payment_Method = 'Mailed Check'

    UNION

    SELECT 
        '80-100 Monthly Payment' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Monthly_Charge BETWEEN 80 AND 100) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Monthly_Charge BETWEEN 80 AND 100

    UNION

    SELECT 
        'Online_Backup No' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Online_Backup = 0) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Online_Backup = 0

    UNION

    SELECT 
        'Device_Protection_Plan No' AS factor, 
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM telecom_customer_churn WHERE Device_Protection_Plan = 0) AS churn_rate
    FROM 
        telecom_customer_churn
    WHERE 
        Customer_Status = 'Churned' AND Device_Protection_Plan = 0
) AS TempResult


select factor,churn_rate
from riskfactor


select @@SERVERNAME