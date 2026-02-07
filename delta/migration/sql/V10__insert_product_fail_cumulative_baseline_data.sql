USE kir_server_db;

-- Process existing manufacturing data to calculate cumulative failure counts
-- This extracts failed products from t_manufacturing_simple_result and calculates running totals
-- Uses f_product_seq column added in V5
-- This should be executed before Spring Boot application starts processing new data

INSERT INTO t_product_fail_cumulative 
(f_product_code, f_product_seq, cumulative_fail_count, f_station_code, f_station_channel_no, created_at)
SELECT 
    f_product_code,
    f_product_seq,
    ROW_NUMBER() OVER (
        PARTITION BY f_product_code
        ORDER BY f_product_seq
    ) AS cumulative_fail_count,
    f_station_code,
    f_station_channel_no,
    CURRENT_TIMESTAMP
FROM t_manufacturing_simple_result
WHERE f_result = 0;