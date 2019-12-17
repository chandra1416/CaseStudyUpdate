-- Database Creatation Mysql Query
CREATE DATABASE IF NOT EXISTS moneesha;

-- Change Database as current database Mysql Query 
USE DATABASE Healthcare ;

-- Create Policy Table 
CREATE TABLE IF NOT EXISTS Policy(PolicyId BIGINT,PolicyNumber INT,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL,PRIMARY KEY(PolicyId,PolicyNumber))engine=InnoDB;

--Create CLAIMS Table 
CREATE TABLE IF NOT EXISTS claims(PolicyId BIGINT PRIMARY KEY,ClaimID INT  NOT NULL,ClaimApplyDate DATE  NOT NULL,ClaimServiceDate DATE,ClaimStatus VARCHAR(10)  NOT NULL,ClaimCompletionDate DATE)engine=InnoDB;

--Create CLAIMS_Transaction Table
CREATE TABLE IF NOT EXISTS CLAIMS_Transaction(TransactionId INT PRIMARY KEY,PolicyId BIGINT NOT NULL,PolicyNumber INT NOT NULL,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL,ClaimID INT NOT NULL,ClaimType VARCHAR(20)NOT NULL,ClaimApplyDate DATE NOT NULL,ClaimServiceDate DATE,ClaimStatus VARCHAR(10)NOT NULL,ClaimCompletionDate DATE);

--DML Operations

--POLICY Table INSERT query 
INSERT ignore INTO POLICY(
  PolicyId,PolicyNumber,
  PolicYHolderName,
  PolicyStartDate,
  PolicyExpirationDate,
  PolicyType
)
select
  PolicyId,
  PolicyNumber,
  PolicYHolderName,
  PolicyStartDate,
  PolicyExpirationDate,
  PolicyType 
from 
  claims_transaction;

--CLAIMS Table INSERT query 

INSERT INTO CLAIMS(
	PolicyId,ClaimID,
	ClaimApplyDate,
	ClaimServiceDate,
	ClaimStatus,
	ClaimCompletionDate
) 
WITH CTE AS (
select 
	PolicyId,
    ClaimID,
    ClaimApplyDate,
    ClaimServiceDate,
    ClaimStatus,
    ClaimCompletionDate,
    ROW_NUMBER() OVER(
    partition by 
		PolicyId,
        claimId
	ORDER BY 
    ClaimApplyDate desc,
    ClaimCompletionDate desc,
    ClaimStatus desc
    ) row_num 
    FROM
		claims_transaction
)
select 
	PolicyId,
    ClaimID,
    ClaimApplyDate,
    ClaimServiceDate,
    ClaimStatus,
    ClaimCompletionDate
from 
	CTE 
where 
	row_num =1;
