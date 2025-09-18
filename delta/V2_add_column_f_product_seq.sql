USE kir_server_db
-- in order to insert values for the new created, we have to set it as Nullable, polulate the column, then set it to `NOT NULL`;
-- step1: inser the column
ALTER TABLE t_manufacturing_simple_result 
ADD COLUMN f_product_seq BIGINT UNSIGNED NULL AFTER f_product_code;
-- step2: polulate the column

-- step3:set column to `NOT NULL`


-- another solution
ALTER TABLE t_manufacturing_simple_result
ADD COLUMN f_product_seq BIGINT NOT NULL DEFAULT 0;
