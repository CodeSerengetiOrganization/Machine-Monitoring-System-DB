USE kir_server_db
-- in order to insert values for the new created, we have to set it as Nullable, polulate the column, then set it to `NOT NULL`;
-- step1: inser the column
ALTER TABLE t_manufacturing_simple_result 
ADD COLUMN f_product_seq BIGINT UNSIGNED NULL AFTER f_product_code;

-- step2: polulate the column
  -- initialize a variable
SET @seq = 0;

  -- update the table in the order of f_end_time
UPDATE t_manufacturing_simple_result
SET f_product_seq = (@seq := @seq + 1)
ORDER BY f_end_time ASC;

  -- step3:set column to `NOT NULL`
ALTER TABLE t_manufacturing_simple_result
MODIFY COLUMN f_product_seq BIGINT UNSIGNED NOT NULL;



-- tool scrips for checking
DESCRIBE t_manufacturing_simple_result

SELECT * FROM t_manufacturing_simple_result 
	ORDER BY f_start_time ASC 
	LIMIT 10;

SELECT * FROM t_manufacturing_simple_result 
	ORDER BY f_start_time DESC;



-- another solution
ALTER TABLE t_manufacturing_simple_result
ADD COLUMN f_product_seq BIGINT NOT NULL DEFAULT 0;
