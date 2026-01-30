USE kir_server_db;

-- add a new station for bathtub curve for Machine Monitoring System
INSERT INTO t_machine_station(f_station_code,f_station_name,f_station_version,f_channel_number,f_deploy_location,f_create_time,f_modify_time,f_comment) VALUES
(4,'MachineStationA','V1.0',2,'Canada Factory','2023-12-03 12:30:00','2023-12-03 12:30:00','New saation deployed');

-- insert a new prodcut for bathtub curve for Machine Monitoring System
INSERT INTO t_product(f_product_code,f_product_name,f_product_version,f_customer,f_vehicle_platform,f_create_time,f_modify_time,f_comment) VALUES
(112233,'productA','V1.0.1','New Customer','Platform1','2023-12-03 12:30:00','2023-12-03 12:30:00','First version');
