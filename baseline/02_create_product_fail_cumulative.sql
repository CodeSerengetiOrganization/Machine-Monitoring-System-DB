-- this is a helper table to calculate the failed product account
CREATE TABLE IF NOT EXISTS t_product_fail_cumulative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    f_product_code BIGINT NOT NULL,                -- Product identifier
    f_product_seq BIGINT UNSIGNED NOT NULL,        -- Sequence number per product
    cumulative_fail_count BIGINT NOT NULL,         -- Running total of failed parts for this product
    f_station_code BIGINT NOT NULL,                -- Machine/station code
    f_station_channel_no BIGINT NOT NULL,          -- Fixture/channel
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (f_product_code) REFERENCES t_product(f_product_code),
    FOREIGN KEY (f_station_code) REFERENCES t_machine_station(f_station_code),

    -- Indexes for fast window/batch queries
    UNIQUE KEY uq_product_seq (f_product_code, f_product_seq),
    INDEX idx_product_station_channel (f_product_code, f_station_code, f_station_channel_no, f_product_seq)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;


-- Process existing data: get data from table "t_manufacturing_simple_result", calculate the cumulative sum, save into the table
-- This procedure should be done manully before Springboot started and take over the in
INSERT INTO t_product_fail_cumulative 
(f_product_code, f_product_seq, cumulative_fail_count, f_station_code, f_station_channel_no)
SELECT 
    f_product_code,
    f_product_seq,
    SUM(1) OVER (
        PARTITION BY f_product_code
        ORDER BY f_product_seq
    ) AS cumulative_fail_count,
    f_station_code,
    f_station_channel_no
    -- 1 AS fail_count   -- each failed row counts as 1 at that seq
FROM t_manufacturing_simple_result
WHERE f_result = FALSE;
 

