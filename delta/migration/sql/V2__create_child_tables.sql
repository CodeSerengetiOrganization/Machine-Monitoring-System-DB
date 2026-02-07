USE kir_server_db;

CREATE TABLE t_manufacturing_complex_result(
	f_id BIGINT NOT NULL AUTO_INCREMENT,
	f_barcode VARCHAR(255) NOT NULL,
	f_product_code BIGINT NOT NULL,	
	-- f_order_no varchar(255) not null,
	f_station_code BIGINT NOT NULL,	
	f_station_channel_no BIGINT NOT NULL,
	f_feature_type VARCHAR(50) NOT NULL,
	f_feature_name VARCHAR(50) NOT NULL,
	f_test_item VARCHAR(50) NOT NULL,
	f_result DOUBLE NOT NULL,
	f_operator VARCHAR(50),
	f_start_time TIMESTAMP,
	f_end_time TIMESTAMP,
	f_comment VARCHAR(255),

    CONSTRAINT pk_manufacturing_complex_result
        PRIMARY KEY(f_id)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

CREATE TABLE t_manufacturing_simple_result (
    f_id BIGINT NOT NULL AUTO_INCREMENT,
    f_barcode VARCHAR(255) NOT NULL,
    f_product_code BIGINT NOT NULL,
    f_station_code BIGINT NOT NULL,
    f_station_channel_no INT NOT NULL,
    f_result TINYINT(1) NOT NULL,
    f_operator VARCHAR(50) NOT NULL,
    f_start_time DATETIME NOT NULL,
    f_end_time DATETIME NOT NULL,
    f_comment VARCHAR(255),

    CONSTRAINT pk_manufacturing_simple_result
        PRIMARY KEY (f_id)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;
