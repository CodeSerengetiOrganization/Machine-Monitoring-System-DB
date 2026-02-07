USE kir_server_db;
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
        INSERT INTO false_alarm (barcode, station_code, rack_id, channel_number, failure_item, test_date)
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
        GROUP BY f_station_code, f_station_code + 100, f_station_channel_no
        ON DUPLICATE KEY UPDATE 
            false_alarm_count = false_alarm_count + VALUES(false_alarm_count),
            updated_at = CURRENT_TIMESTAMP;

        -- Drop the temporary table
        DROP TEMPORARY TABLE batch_data;
        DROP TEMPORARY TABLE false_alarm_in_batch_data;

        -- Update offset
        SET offset_value = offset_value + batch_size;
    END WHILE;
END //

DELIMITER ;
