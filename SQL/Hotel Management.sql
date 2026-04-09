CREATE DATABASE hotelManagement;
USE hotelManagement;
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10, 2)
);
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
INSERT INTO users VALUES ('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City');
INSERT INTO users VALUES ('22wrcxuy-67erfn', 'Max well', '99XXXXXXXX', 'max.well@example.com', 'XA, Street A, ABA City');
INSERT INTO users VALUES ('23wrcxuy-67erfn', 'Virat Kohli', '99XXXXXXXX', 'virat.kohli@example.com', 'AA, Street 8, BBA City');
INSERT INTO users VALUES 
('24wrcxuy-67erfn', 'Ananya Sharma', '98XXXXXXXX', 'ananya@gmail.com', 'Delhi, India'),
('25wrcxuy-67erfn', 'Rahul Verma', '91XXXXXXXX', 'rahul@gmail.com', 'Mumbai, India'),
('26wrcxuy-67erfn', 'Sneha Reddy', '90XXXXXXXX', 'sneha@gmail.com', 'Hyderabad, India');

SELECT * FROM users;

INSERT INTO bookings VALUES ('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn');
INSERT INTO bookings VALUES ('bk-10f3e-95hj', '2021-09-24 07:36:48', 'rm-bhf9-aerjn', '22wrcxuy-67erfn');
INSERT INTO bookings VALUES ('bk-11f3e-95hj', '2021-09-25 07:36:48', 'rm-bhf9-aerjn', '23wrcxuy-67erfn');
INSERT INTO bookings VALUES
('bk-12f3e-95hj', '2021-10-01 08:20:00', 'rm-x1', '24wrcxuy-67erfn'),
('bk-13f3e-95hj', '2021-10-05 09:15:00', 'rm-x2', '25wrcxuy-67erfn'),
('bk-14f3e-95hj', '2021-11-10 10:30:00', 'rm-x3', '26wrcxuy-67erfn'),
('bk-15f3e-95hj', '2021-11-12 11:00:00', 'rm-x2', '21wrcxuy-67erfn'),
('bk-16f3e-95hj', '2021-12-01 07:45:00', 'rm-x1', '22wrcxuy-67erfn');

SELECT * FROM bookings;

INSERT INTO items VALUES ('itm-a9e8-q8fu', 'Tawa Paratha', 18), ('itm-a07vh-aer8', 'Mix Veg', 89);
INSERT INTO items VALUES
('itm-b1', 'Paneer Butter Masala', 150),
('itm-b2', 'Fried Rice', 120),
('itm-b3', 'Chicken Biryani', 200),
('itm-b4', 'Coffee', 40);

SELECT * FROM items;

INSERT INTO booking_commercials VALUES ('q34r-3q408-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3);
INSERT INTO booking_commercials VALUES ('q304-ahf32-02u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1);
INSERT INTO booking_commercials VALUES ('q33r-3q408-q34u', 'bk-10f3e-95hj', 'bl-0a87y-q341', '2021-09-24 12:03:25', 'itm-a9e8-q8fu', 4);
INSERT INTO booking_commercials VALUES ('q354-ahf32-02u4', 'bk-11f3e-95hj', 'bl-0a87y-q342', '2021-09-25 12:03:26', 'itm-a07vh-aer8', 1);
INSERT INTO booking_commercials VALUES
('q400', 'bk-12f3e-95hj', 'bl-101', '2021-10-01 13:00:00', 'itm-b1', 2),
('q401', 'bk-12f3e-95hj', 'bl-101', '2021-10-01 13:00:00', 'itm-b4', 3),

('q402', 'bk-13f3e-95hj', 'bl-102', '2021-10-05 14:10:00', 'itm-b2', 1),
('q403', 'bk-13f3e-95hj', 'bl-102', '2021-10-05 14:10:00', 'itm-a9e8-q8fu', 2),

('q404', 'bk-14f3e-95hj', 'bl-103', '2021-11-10 15:20:00', 'itm-b3', 1),
('q405', 'bk-14f3e-95hj', 'bl-103', '2021-11-10 15:20:00', 'itm-b4', 2),

('q406', 'bk-15f3e-95hj', 'bl-104', '2021-11-12 16:00:00', 'itm-b1', 1),
('q407', 'bk-15f3e-95hj', 'bl-104', '2021-11-12 16:00:00', 'itm-a07vh-aer8', 2),

('q408', 'bk-16f3e-95hj', 'bl-105', '2021-12-01 12:30:00', 'itm-b2', 3),
('q409', 'bk-16f3e-95hj', 'bl-105', '2021-12-01 12:30:00', 'itm-b3', 1);

SELECT * FROM booking_commercials;

-- 1. For every user, get user_id and last booked room_no
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no, 
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY booking_date DESC) as last_booking
    FROM bookings
) t
WHERE last_booking = 1;

-- 2. Booking_id and total billing amount for bookings in November 2021
SELECT b.booking_id, SUM(bc.item_quantity * i.item_rate) AS total_billing
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date BETWEEN '2021-11-01' AND '2021-11-30 23:59:59'
GROUP BY b.booking_id;

-- 3. Bill_id and amount for October 2021 where amount > 1000
SELECT bc.bill_id, SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date BETWEEN '2021-10-01' AND '2021-10-31 23:59:59'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- 4. Most and least ordered item of each month of year 2021
WITH MonthlyStats AS (
    SELECT 
        MONTH(bill_date) as month, 
        item_id, 
        SUM(item_quantity) as total_qty
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), item_id
),
RankedItems AS (
    SELECT 
        month, 
        item_id,
        RANK() OVER(PARTITION BY month ORDER BY total_qty DESC) as rank_desc,
        RANK() OVER(PARTITION BY month ORDER BY total_qty ASC) as rank_asc
    FROM MonthlyStats
)
SELECT 
    month, 
    MAX(CASE WHEN rank_desc = 1 THEN item_id END) as most_ordered,
    MAX(CASE WHEN rank_asc = 1 THEN item_id END) as least_ordered
FROM RankedItems
GROUP BY month;

-- 5. Customers with second highest bill value of each month 2021
WITH CustomerMonthlyBills AS (
    SELECT 
        MONTH(bc.bill_date) as month, 
        b.user_id, 
        SUM(bc.item_quantity * i.item_rate) as total_bill
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id
),
RankedBills AS (
    SELECT *, 
           DENSE_RANK() OVER(PARTITION BY month ORDER BY total_bill DESC) as rnk
    FROM CustomerMonthlyBills
)
SELECT month, user_id, total_bill
FROM RankedBills
WHERE rnk = 2;
