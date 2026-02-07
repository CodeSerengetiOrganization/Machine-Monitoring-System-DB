USE kir_server_db;

ALTER TABLE t_manufacturing_simple_result
ADD CONSTRAINT fk_simple_result_product
    FOREIGN KEY (f_product_code)
    REFERENCES t_product(f_product_code);

ALTER TABLE t_manufacturing_simple_result
ADD CONSTRAINT fk_simple_result_station
    FOREIGN KEY (f_station_code)
    REFERENCES t_machine_station(f_station_code);
