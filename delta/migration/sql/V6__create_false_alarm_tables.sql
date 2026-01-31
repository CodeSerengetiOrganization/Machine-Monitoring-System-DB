USE kir_server_db;

-- Create false_alarm table
CREATE TABLE false_alarm (
    id INT NOT NULL AUTO_INCREMENT,
    barcode VARCHAR(255) NOT NULL,
    station_code BIGINT NOT NULL,
    rack_id INT NOT NULL,
    channel_number INT NOT NULL DEFAULT 0,
    failure_item VARCHAR(100) NOT NULL,
    test_date DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_false_alarm PRIMARY KEY (id),
    
    INDEX idx_station_code (station_code),
    INDEX idx_test_date (test_date),
    INDEX idx_barcode (barcode)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- Create false_alarm_summary table
CREATE TABLE false_alarm_summary (
    id INT NOT NULL AUTO_INCREMENT,
    station_code BIGINT NOT NULL,
    rack_code INT NOT NULL,
    channel_number INT NOT NULL,
    false_alarm_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_false_alarm_summary PRIMARY KEY (id),
    
    UNIQUE INDEX uk_station_rack_channel (station_code, rack_code, channel_number),
    INDEX idx_station (station_code)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- Create product_fail_cumulative table for failure tracking
CREATE TABLE product_fail_cumulative (
    id BIGINT NOT NULL AUTO_INCREMENT,
    product_code BIGINT NOT NULL,
    product_sequence BIGINT UNSIGNED NOT NULL,
    cumulative_fail_count BIGINT NOT NULL DEFAULT 0,
    station_code BIGINT NOT NULL,
    station_channel_number BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_product_fail_cumulative PRIMARY KEY (id),
    
    UNIQUE INDEX uk_product_sequence (product_code, product_sequence),
    INDEX idx_product_station_channel (product_code, station_code, station_channel_number, product_sequence)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;