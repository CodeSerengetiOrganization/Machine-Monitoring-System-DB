USE kir_server_db;

-- Add foreign key constraints to false_alarm table
ALTER TABLE false_alarm
ADD CONSTRAINT fk_false_alarm_station 
    FOREIGN KEY (station_code) 
    REFERENCES t_machine_station(f_station_code);

-- Add foreign key constraint to false_alarm_summary table
ALTER TABLE false_alarm_summary
ADD CONSTRAINT fk_false_alarm_summary_station 
    FOREIGN KEY (station_code) 
    REFERENCES t_machine_station(f_station_code);

-- Add foreign key constraints to product_fail_cumulative table
ALTER TABLE product_fail_cumulative
ADD CONSTRAINT fk_product_fail_product 
    FOREIGN KEY (product_code) 
    REFERENCES t_product(f_product_code);

ALTER TABLE product_fail_cumulative
ADD CONSTRAINT fk_product_fail_station 
    FOREIGN KEY (station_code) 
    REFERENCES t_machine_station(f_station_code);
