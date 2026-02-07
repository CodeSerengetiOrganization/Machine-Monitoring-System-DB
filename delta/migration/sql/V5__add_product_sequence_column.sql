USE kir_server_db;

-- in order to insert values for the new created column, we have to set it as Nullable, populate the column, then set it to `NOT NULL`;

-- step1: insert the column
ALTER TABLE t_manufacturing_simple_result 
ADD COLUMN f_product_seq BIGINT UNSIGNED NULL AFTER f_product_code;

-- step2: populate the column
  -- initialize a variable
SET @seq = 0;

  -- update the table in the order of f_end_time
UPDATE t_manufacturing_simple_result
SET f_product_seq = (@seq := @seq + 1)
ORDER BY f_end_time ASC;

-- step3: set column to `NOT NULL`
ALTER TABLE t_manufacturing_simple_result
MODIFY COLUMN f_product_seq BIGINT UNSIGNED NOT NULL;
