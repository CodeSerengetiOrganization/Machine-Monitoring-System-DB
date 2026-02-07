USE kir_server_db;
-- add the 1st set of 200 record-for bathtub curve for Machine Monitoring System
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

-- Insert 12 batches of 200 records each--for bathtub curve for Machine Monitoring System
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

-- Insert 12 batches of 200 records each--for bathtub curve for Machine Monitoring System for channel2
DELIMITER //
CREATE PROCEDURE InsertManufacturingDataChannel2()
BEGIN
    SET @batch_num = 1;
    SET @barcode_num = 1;
    SET @start_time = '2023-11-01 10:05:00';
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
                2,
                CASE
                    WHEN @batch_num = 1 AND (@record_num = 50 OR @record_num = 75 OR @record_num = 100 OR @record_num = 125) THEN 0
                    WHEN @batch_num = 2 AND @record_num = 100 THEN 0
                    WHEN @batch_num = 3 AND @record_num = 100 THEN 0
                    WHEN @batch_num = 10 AND (@record_num = 50 OR @record_num = 100 OR @record_num = 150) THEN 0
                    WHEN @batch_num = 11 AND (@record_num = 25 OR @record_num = 50 OR @record_num = 100 OR @record_num = 150 OR @record_num = 175 OR @record_num = 185) THEN 0
                    WHEN @batch_num = 12 AND (@record_num = 25 OR @record_num = 50 OR @record_num = 75 OR @record_num = 125 OR @record_num = 150 OR @record_num = 175 OR @record_num = 175 OR @record_num = 195) THEN 0
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
call InsertManufacturingDataChannel2();
-- Clean up: Drop the procedure after use
DROP PROCEDURE IF EXISTS InsertManufacturingData;
DROP PROCEDURE IF EXISTS InsertManufacturingDataChannel2;