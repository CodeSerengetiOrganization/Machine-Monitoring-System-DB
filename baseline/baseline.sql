USE kir_server_db
## create the rework summary table
CREATE TABLE IF NOT EXISTS rework_summary(
    id INT AUTO_INCREMENT PRIMARY KEY,
    bar_code VARCHAR(255) NOT NULL,
    rework_decision ENUM('FalseAlarm','Defect','Other') NOT NULL,
    rework_date TIMESTAMP NULL,
    note VARCHAR(300) DEFAULT NULL    
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

# insert example record:

INSERT INTO rework_summary (bar_code, rework_decision, rework_date, note) VALUES
('product1', 'Defect', '2023-10-26 10:00:00', 'Minor scratch on surface.'),
('product2', 'FalseAlarm', '2023-10-26 11:30:00', 'Sensor reading error.'),
('product3', 'Other', '2023-10-26 12:45:00', 'Packaging issue.'),
('product4', 'Defect', '2023-10-26 14:15:00', 'Misaligned part.'),
('product5', 'FalseAlarm', '2023-10-26 15:30:00', 'Incorrect label.'),
('product6', 'Defect', '2023-10-27 09:00:00', 'Weld defect.'),
('product7', 'Other', '2023-10-27 10:30:00', 'Cleaning required.'),
('product8', 'FalseAlarm', '2023-10-27 12:00:00', 'Visual inspection error.'),
('product9', 'Defect', '2023-10-27 13:45:00', 'Broken component.'),
('product10', 'Other', '2023-10-27 15:15:00', 'Repainting needed.'),
('product11', 'Defect', '2023-10-28 08:30:00', 'Crack in material.'),
('product12', 'FalseAlarm', '2023-10-28 10:00:00', 'Calibration error.'),
('product13', 'Other', '2023-10-28 11:45:00', 'Reassembly required.'),
('product14', 'Defect', '2023-10-28 13:15:00', 'Incorrect dimensions.'),
('product15', 'FalseAlarm', '2023-10-28 14:45:00', 'Human error during test.'),
('product16', 'Defect', '2023-10-29 09:30:00', 'Surface contamination.'),
('product17', 'Other', '2023-10-29 11:00:00', 'Part exchange needed.'),
('product18', 'FalseAlarm', '2023-10-29 12:30:00', 'Software glitch.'),
('product19', 'Defect', '2023-10-29 14:00:00', 'Loose connection.'),
('product20', 'Other', '2023-10-29 15:30:00', 'Final inspection fail.');

# verify example record
SELECT * FROM rework_summary;