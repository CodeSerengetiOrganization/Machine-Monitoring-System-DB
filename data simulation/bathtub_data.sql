# This script creats bathtub data for machine?
# still use the t_machine_station table

USE kir_server_db;
# add a new station
INSERT INTO t_machine_station(f_station_code,f_station_name,f_station_version,f_channel_number,f_deploy_location,f_create_time,f_modify_time,f_comment) VALUES
(4,'MachineStationA','V1.0',2,'Canada Factory','2023-12-03 12:30:00','2023-12-03 12:30:00','New saation deployed');

SELECT * FROM t_machine_station;

## insert a new prodcut
INSERT INTO t_product(f_product_code,f_product_name,f_product_version,f_customer,f_vehicle_platform,f_create_time,f_modify_time,f_comment) VALUES
(112233,'productA','V1.0.1','New Customer','Platform1','2023-12-03 12:30:00','2023-12-03 12:30:00','First version');

#add the 1st set of 200 record:
INSERT INTO t_manufacturing_simple_result (
    f_barcode,
    f_product_code,
    f_station_code,
    f_station_channel_no,
    f_result,
    f_operator,
    f_start_time,
    f_end_time,
    f_comment
) VALUES
-- First 100 records (operator: OperatorA)
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorA', '2023-11-01 10:00:00', '2023-11-01 10:02:00', 'manufacturing line test'),
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorA', '2023-11-01 10:02:00', '2023-11-01 10:04:00', 'manufacturing line test'),
-- ... (generate the rest of the first 98 rows)
(REPEAT('barcode', 1) , 112233, 4, 1, 0, 'OperatorA', '2023-11-01 13:16:00', '2023-11-01 13:18:00', 'manufacturing line test'), -- record 100 with f_result =0.
-- ... (generate the rest of the first 99 rows)
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorA', '2023-11-01 13:18:00', '2023-11-01 13:20:00', 'manufacturing line test'),
-- Second 100 records (operator: OperatorB)
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorB', '2023-11-01 13:20:00', '2023-11-01 13:22:00', 'manufacturing line test'),
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorB', '2023-11-01 13:22:00', '2023-11-01 13:24:00', 'manufacturing line test'),
-- ... (generate the rest of the second 98 rows)
(REPEAT('barcode', 1) , 112233, 4, 1, 1, 'OperatorB', '2023-11-01 16:36:00', '2023-11-01 16:38:00', 'manufacturing line test');



SELECT * FROM t_manufacturing_simple_result;
SELECT * FROM t_product;


-- Insert 12 batches of 200 records each
DELIMITER //

CREATE PROCEDURE InsertManufacturingData()
BEGIN
    SET @batch_num = 1;
    SET @barcode_num = 1;
    SET @start_time = '2023-11-01 10:00:00';
    SET @operator_index = 1;

    WHILE @batch_num <= 12 DO
        SET @operator = CONCAT('Operator', CHAR(64 + @operator_index));

        SET @record_num = 1;
        WHILE @record_num <= 200 DO
            INSERT INTO t_manufacturing_simple_result (
                f_barcode,
                f_product_code,
                f_station_code,
                f_station_channel_no,
                f_result,
                f_operator,
                f_start_time,
                f_end_time,
                f_comment
            ) VALUES (
                CONCAT('barcode', LPAD(@barcode_num, 4, '0')),
                112233,
                4,
                1,
                CASE
                    WHEN @batch_num = 1 AND (@record_num = 50 OR @record_num = 75 OR @record_num = 100 OR @record_num = 125) THEN 0
                    WHEN @batch_num = 2 AND @record_num = 100 THEN 0
                    WHEN @batch_num = 8 AND @record_num = 100 THEN 0
                    WHEN @batch_num = 9 AND (@record_num = 75 OR @record_num = 125) THEN 0
                    WHEN @batch_num = 10 AND (@record_num = 50 OR @record_num = 100 OR @record_num = 150) THEN 0
                    WHEN @batch_num = 11 AND (@record_num = 25 OR @record_num = 50 OR @record_num = 100 OR @record_num = 150 OR @record_num = 175) THEN 0
                    WHEN @batch_num = 12 AND (@record_num = 25 OR @record_num = 50 OR @record_num = 75 OR @record_num = 125 OR @record_num = 150 OR @record_num = 175 OR @record_num = 195) THEN 0
                    ELSE 1
                END,
                @operator,
                @start_time,
                DATE_ADD(@start_time, INTERVAL 2 MINUTE),
                CONCAT('manufacturing line test - ', @operator)
            );

            SET @barcode_num = @barcode_num + 1;
            SET @start_time = DATE_ADD(@start_time, INTERVAL 2 MINUTE);
            SET @record_num = @record_num + 1;
        END WHILE;

        SET @batch_num = @batch_num + 1;
        SET @operator_index = IF(@operator_index = 2, 1, 2);
    END WHILE;
END //

DELIMITER ;

-- Call the stored procedure to insert the 12 batch data
CALL InsertManufacturingData();
-- varify data
SELECT * FROM t_manufacturing_simple_result WHERE f_result = 0;

SELECT * FROM t_manufacturing_simple_result WHERE f_barcode = 'barcode2395';

#-------------------------------------------------------extract data into falase alarm related table begins ------------------
DROP PROCEDURE IF EXISTS ProcessFalseAlarms;

DELIMITER //

CREATE PROCEDURE ProcessFalseAlarms()
BEGIN
    -- Declare local variables
    DECLARE product_code INT DEFAULT 112233;
    DECLARE batch_size INT DEFAULT 200;
    DECLARE offset_value INT DEFAULT 0;
    DECLARE total_count INT;
    -- DECLARE batch_false_alarm_count INT;

    -- Get total number of records
    SELECT COUNT(*) INTO total_count FROM t_manufacturing_simple_result WHERE f_product_code = product_code;

    -- Loop through batches
    WHILE total_count > offset_value DO
        -- Drop temporary tables if they exist
        DROP TEMPORARY TABLE IF EXISTS batch_data;
        DROP TEMPORARY TABLE IF EXISTS false_alarm_in_batch_data;
        -- Create a temporary table to store batch data
        SELECT offset_value;
        CREATE TEMPORARY TABLE batch_data AS
        SELECT * FROM t_manufacturing_simple_result 
        WHERE f_product_code = product_code #AND f_result = 0
        ORDER BY f_start_time
        LIMIT batch_size OFFSET offset_value;
        
	-- Create a temporary table to store products with false alarm in batch_data table
	CREATE TEMPORARY TABLE false_alarm_in_batch_data AS
	SELECT * FROM batch_data
	WHERE f_result = 0;       
       
        -- Insert into false_alarm table
        INSERT INTO false_alarm (bar_code, machine_id, rack_id, channel_number, failure_item, test_date)
        SELECT  
            f_barcode,  
            f_station_code, -- machine_id
            f_station_code + 100, -- rack_id (example, adjust as needed)
            f_station_channel_no,
            'False Alarm',
            f_start_time
        FROM false_alarm_in_batch_data;
    
        INSERT INTO false_alarm_machine_summary (machine_station_code, rack_code, channel_number, false_alarm_count)
        SELECT  
            f_station_code,  
            f_station_code + 100, -- rack_code (example, adjust as needed)
            f_station_channel_no,
            COUNT(CASE WHEN f_result = 0 THEN 1 END)
        FROM batch_data
        GROUP BY f_station_code; #--, f_station_code + 100, f_station_channel_no;

        -- Drop the temporary table
        DROP TEMPORARY TABLE batch_data;
        DROP TEMPORARY TABLE false_alarm_in_batch_data;

        -- Update offset
        SET offset_value = offset_value + batch_size;
    END WHILE;
END //

DELIMITER ;

-- Call the stored procedure
CALL ProcessFalseAlarms();

-- varify data 
SELECT * FROM false_alarm;
SELECT * FROM false_alarm_machine_summary;

#delete from false_alarm where rack_id=104;
#delete from false_alarm_machine_summary;
#-------------------------------------------------------extract data into falase alarm related table ends ------------------