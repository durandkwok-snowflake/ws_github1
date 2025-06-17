
create database IF NOT EXISTS loan_db;
use database loan_db;

create schema IF NOT EXISTS test_schema;
use schema test_schema;

use warehouse loan_wh;
use warehouse diamond_wh;

--ALTER WAREHOUSE loan_wh SET WAREHOUSE_SIZE = LARGE;


CREATE OR REPLACE SEQUENCE loan_db.test_schema.seq1 START = 1 INCREMENT = 1;

CREATE OR REPLACE TABLE loan_db.TEST_SCHEMA.loan_test (
    record_id NUMBER DEFAULT seq1.NEXTVAL,
    credit_score NUMERIC(4),
    first_payment_date VARCHAR(6),
    first_time_homebuyer_flag VARCHAR(1),
    maturity_date VARCHAR(6),
    msa_or_metropolitan_division NUMERIC(5),
    mortgage_insurance_percentage NUMERIC(3),
    number_of_units NUMERIC(2),
    occupancy_status VARCHAR(1),
    original_cltv NUMERIC(3),
    original_dti_ratio NUMERIC(3),
    original_upb NUMERIC(12),
    original_ltv NUMERIC(3),
    original_interest_rate NUMERIC(6, 3),
    channel VARCHAR(1),
    ppm_flag VARCHAR(1),
    amortization_type VARCHAR(5),
    property_state VARCHAR(2),
    property_type VARCHAR(2),
    postal_code NUMERIC(5),
    loan_sequence_number VARCHAR(12),
    loan_purpose VARCHAR(1),
    original_loan_term NUMERIC(3),
    number_of_borrowers NUMERIC(2),
    seller_name VARCHAR(60),
    servicer_name VARCHAR(60),
    super_conforming_flag VARCHAR(1),
    pre_harp_loan_sequence_number VARCHAR(12),
    program_indicator VARCHAR(1),
    harp_indicator VARCHAR(1),
    property_valuation_method NUMERIC(1),
    interest_only_indicator VARCHAR(1),
    mortgage_insurance_cancellation_indicator VARCHAR(1),
    filename VARCHAR
) DATA_RETENTION_TIME_IN_DAYS=1;


select * from loan_db.TEST_SCHEMA.loan_test;

Truncate table loan_db.test_schema.loan_test;

-- Load from External Stage
COPY INTO "LOAN_DB"."TEST_SCHEMA"."LOAN_TEST" (
    credit_score, 
    first_payment_date, 
    first_time_homebuyer_flag, 
    maturity_date, 
    msa_or_metropolitan_division, 
    mortgage_insurance_percentage, 
    number_of_units, 
    occupancy_status, 
    original_cltv, 
    original_dti_ratio, 
    original_upb, 
    original_ltv, 
    original_interest_rate, 
    channel, 
    ppm_flag, 
    amortization_type, 
    property_state, 
    property_type, 
    postal_code, 
    loan_sequence_number, 
    loan_purpose, 
    original_loan_term, 
    number_of_borrowers, 
    seller_name, 
    servicer_name, 
    super_conforming_flag, 
    pre_harp_loan_sequence_number, 
    program_indicator, 
    harp_indicator, 
    property_valuation_method, 
    interest_only_indicator, 
    mortgage_insurance_cancellation_indicator,
    filename
) 
FROM (
    SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, METADATA$FILENAME
    FROM '@"LOAN_DB"."PUBLIC"."S3_STAGE"'
)
file_format = (type = csv, skip_header=0, field_delimiter='|')
ON_ERROR=ABORT_STATEMENT;

-- 44,951,589 record count
select count(*) from loan_db.TEST_SCHEMA.LOAN_TEST;

select * from loan_db.TEST_SCHEMA.LOAN_TEST limit 10;

select * from loan_db.TEST_SCHEMA.LOAN_TEST;
