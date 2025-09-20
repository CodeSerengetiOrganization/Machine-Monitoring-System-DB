`ProcessFalseAlarms`USE kir_server_db
#-------------------------------------------------------rework_summary table begines------------------------------------
## create the rework summary table
CREATE TABLE IF NOT EXISTS rework_summary(
    id INT AUTO_INCREMENT PRIMARY KEY,
    bar_code VARCHAR(50) NOT NULL,
    rework_decision ENUM('FalseAlarm','Defect','Other') NOT NULL,
    rework_date TIMESTAMP NULL,
    note VARCHAR(300) DEFAULT NULL    
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

# insert example record:

INSERT INTO rework_summary (bar_code, rework_decision, rework_date, note) VALUES
('product1', 'Defect', '2023-10-26 10:00:00', 'Minor scratch on surface.'),
('product2', 'FalseAlarm', '2023-10-26 11:30:00', 'Sensor reading error.'),
('product3', 'Other', '2023-10-26 12:45:00', 'Packaging issue.'),
('product4', 'Defect', '2023-10-26 14:15:00', 'Misaligned part.'),
('product5', 'FalseAlarm', '2023-10-26 15:30:00', 'Incorrect label.'),
('product6', 'Defect', '2023-10-27 09:00:00', 'Weld defect.'),
('product7', 'Other', '2023-10-27 10:30:00', 'Cleaning required.'),
('product8', 'FalseAlarm', '2023-10-27 12:00:00', 'Visual inspection error.'),
('product9', 'Defect', '2023-10-27 13:45:00', 'Broken component.'),
('product10', 'Other', '2023-10-27 15:15:00', 'Repainting needed.'),
('product11', 'Defect', '2023-10-28 08:30:00', 'Crack in material.'),
('product12', 'FalseAlarm', '2023-10-28 10:00:00', 'Calibration error.'),
('product13', 'Other', '2023-10-28 11:45:00', 'Reassembly required.'),
('product14', 'Defect', '2023-10-28 13:15:00', 'Incorrect dimensions.'),
('product15', 'FalseAlarm', '2023-10-28 14:45:00', 'Human error during test.'),
('product16', 'Defect', '2023-10-29 09:30:00', 'Surface contamination.'),
('product17', 'Other', '2023-10-29 11:00:00', 'Part exchange needed.'),
('product18', 'FalseAlarm', '2023-10-29 12:30:00', 'Software glitch.'),
('product19', 'Defect', '2023-10-29 14:00:00', 'Loose connection.'),
('product20', 'Other', '2023-10-29 15:30:00', 'Final inspection fail.');

# verify example record
SELECT * FROM rework_summary;
#-------------------------------------------------------rework_summary table ends------------------------------------

#-------------------------------------------------------machines table begines------------------------------------

# create the machines table
CREATE TABLE IF NOT EXISTS machines (
    machine_id INT PRIMARY KEY,
    machine_name VARCHAR(50) NOT NULL
);
DESC machines;
INSERT INTO machines(machine_id,machine_name) VALUES
(1,'machineA'),
(2,'machineB'),
(3,'machineC'),
(4,'machineD');

# verify data
SELECT * FROM machines;
#-------------------------------------------------------machines table ends------------------------------------

#-------------------------------------------------------false_alarm table begines------------------------------------
# create false_alarm table
CREATE TABLE IF NOT EXISTS false_alarm(
    id INT AUTO_INCREMENT PRIMARY KEY,
    bar_code VARCHAR(50) NOT NULL,
    machine_id INT NOT NULL,
    rack_id INT NOT NULL,
    channel_number INT DEFAULT 0,
    failure_item VARCHAR(50) NOT NULL,
    test_date TIMESTAMP NOT NULL 
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
# add foreign key
ALTER TABLE false_alarm
ADD CONSTRAINT fk_machine_id
FOREIGN KEY (machine_id)
REFERENCES machines(machine_id);

#verify false_alarm table;
DESC false_alarm;
SHOW CREATE TABLE false_alarm;

#insert example data
INSERT INTO false_alarm (bar_code, machine_id, rack_id, channel_number, failure_item, test_date) VALUES
('barcode1', 1, 101, 1, 'Sensor Failure', '2023-11-01 10:00:00'),
('barcode2', 2, 102, 2, 'Motor Overheat', '2023-11-01 11:30:00'),
('barcode3', 3, 103, 3, 'Calibration Error', '2023-11-01 13:00:00'),
('barcode4', 4, 101, 4, 'Wiring Issue', '2023-11-01 14:45:00'),
('barcode5', 1, 102, 5, 'Software Glitch', '2023-11-02 09:15:00'),
('barcode6', 2, 103, 6, 'Mechanical Jam', '2023-11-02 11:00:00'),
('barcode7', 3, 101, 7, 'Power Supply Fail', '2023-11-02 12:30:00'),
('barcode8', 4, 102, 8, 'Data Transmission Error', '2023-11-02 14:00:00'),
('barcode9', 1, 103, 9, 'Material Defect', '2023-11-03 10:30:00'),
('barcode10', 2, 101, 10, 'Human Error', '2023-11-03 12:00:00');

#verify data
SELECT * FROM  false_alarm;

#-------------------------------------------------------false_alarm table ends------------------------------------

#-------------------------------------------------------false_alarm_machine_summary table begines------------------
CREATE TABLE false_alarm_machine_summary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    machine_station_code INT NOT NULL,
    rack_code INT NOT NULL,
    channel_number INT NOT NULL,
    false_alarm_count INT NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

DESC false_alarm_machine_summary;
#-------------------------------------------------------false_alarm_machine_summary table ends   ------------------


#-------------------------------------------------------t_product_fail_cumulative table begines  ------------------
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
#-------------------------------------------------------t_product_fail_cumulative table ends     ------------------


#-------------------------------------------------------t_product_fail_cumulative table processing begines--------------
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
#-------------------------------------------------------t_product_fail_cumulative table processing ends   --------------

