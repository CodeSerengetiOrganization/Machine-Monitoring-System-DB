USE kir_server_db;

-- Create product table
CREATE TABLE t_product(
	f_id BIGINT PRIMARY KEY AUTO_INCREMENT,
	f_product_code BIGINT UNIQUE NOT NULL,
	f_product_name VARCHAR(50) NOT NULL,
	f_product_version VARCHAR(50),
	f_customer VARCHAR(50) NOT NULL,
	f_vehicle_platform VARCHAR(50) NOT NULL,
	f_create_time TIMESTAMP,
	f_modify_time TIMESTAMP,
	f_comment VARCHAR(255)
	
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
-- Create machine station table
CREATE TABLE t_machine_station(
	f_id BIGINT PRIMARY KEY AUTO_INCREMENT,
	f_station_code BIGINT UNIQUE NOT NULL,
	f_station_name VARCHAR(50) NOT NULL,
	f_station_version VARCHAR(50),
	f_channel_number BIGINT,
	f_deploy_location VARCHAR(50) NOT NULL,
	f_create_time TIMESTAMP,
	f_modify_time TIMESTAMP,
	f_comment VARCHAR(255)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;