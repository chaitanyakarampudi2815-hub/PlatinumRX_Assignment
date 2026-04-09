CREATE DATABASE clinic_management;
USE clinic_management;

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10, 2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description TEXT,
    amount DECIMAL(10, 2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
INSERT INTO clinics VALUES ('cnc-0100001', 'XYZ clinic', 'lorem', 'ipsum', 'dolor');
INSERT INTO clinics VALUES
('cnc-0100002', 'ABC Clinic', 'Hyderabad', 'Telangana', 'India'),
('cnc-0100003', 'Care Plus Clinic', 'Bangalore', 'Karnataka', 'India'),
('cnc-0100004', 'Health First', 'Chennai', 'Tamil Nadu', 'India');

SELECT * FROM clinics;

INSERT INTO customer VALUES
('bk-09f3e-95hj', 'Jon Doe', '97XXXXXXXX'),
('bk-10f3e-95hj', 'Rahul Sharma', '98XXXXXXXX'),
('bk-11f3e-95hj', 'Ananya Reddy', '99XXXXXXXX'),
('bk-12f3e-95hj', 'Kiran Kumar', '91XXXXXXXX'),
('bk-13f3e-95hj', 'Sneha Gupta', '90XXXXXXXX');

SELECT * FROM customer;

INSERT INTO clinic_sales VALUES
('ord-001', 'bk-09f3e-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'sodat'),
('ord-002', 'bk-10f3e-95hj', 'cnc-0100002', 1500, '2021-10-01 10:30:00', 'online'),
('ord-003', 'bk-11f3e-95hj', 'cnc-0100002', 2000, '2021-10-02 11:00:00', 'offline'),

('ord-004', 'bk-12f3e-95hj', 'cnc-0100003', 3000, '2021-10-05 12:15:00', 'online'),
('ord-005', 'bk-13f3e-95hj', 'cnc-0100003', 1200, '2021-10-06 13:20:00', 'offline'),

('ord-006', 'bk-09f3e-95hj', 'cnc-0100004', 5000, '2021-11-01 09:45:00', 'online'),
('ord-007', 'bk-10f3e-95hj', 'cnc-0100004', 2200, '2021-11-02 10:10:00', 'offline'),

('ord-008', 'bk-11f3e-95hj', 'cnc-0100001', 1800, '2021-12-01 08:30:00', 'online'),
('ord-009', 'bk-12f3e-95hj', 'cnc-0100002', 2500, '2021-12-03 09:00:00', 'offline');

SELECT * FROM clinic_sales;

INSERT INTO expenses VALUES
('exp-010', 'cnc-0100001', 'first-aid supplies', 557, '2021-09-23 07:36:48'),
('exp-002', 'cnc-0100002', 'medicine stock', 800, '2021-10-01 08:00:00'),
('exp-003', 'cnc-0100002', 'electricity bill', 600, '2021-10-03 18:00:00'),

('exp-004', 'cnc-0100003', 'staff salary', 2000, '2021-10-05 19:00:00'),
('exp-005', 'cnc-0100003', 'equipment maintenance', 700, '2021-10-06 17:00:00'),

('exp-006', 'cnc-0100004', 'rent', 3000, '2021-11-01 07:00:00'),
('exp-007', 'cnc-0100004', 'cleaning', 500, '2021-11-02 20:00:00'),

('exp-008', 'cnc-0100001', 'lab supplies', 900, '2021-12-01 06:30:00'),
('exp-009', 'cnc-0100002', 'marketing', 1200, '2021-12-03 15:00:00');

SELECT * FROM expenses;

-- 1. Revenue from each sales channel in 2021
SELECT sales_channel, SUM(amount) as revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

-- 2. Top 10 most valuable customers in 2021
SELECT uid, SUM(amount) as total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Month wise revenue, expense, profit, and status
SELECT 
    r.month, 
    rev as revenue, 
    exp as expense, 
    (rev - exp) as profit,
    CASE 
        WHEN (rev - exp) > 0 THEN 'profitable' 
        ELSE 'not-profitable' 
    END as status
FROM (
    SELECT MONTH(datetime) as month, SUM(amount) as rev
    FROM clinic_sales 
    WHERE YEAR(datetime) = 2021 
    GROUP BY MONTH(datetime)
) r
JOIN (
    SELECT MONTH(datetime) as month, SUM(amount) as exp
    FROM expenses 
    WHERE YEAR(datetime) = 2021 
    GROUP BY MONTH(datetime)
) e 
ON r.month = e.month;

-- 4. Most profitable clinic for each city in a given month (e.g., September)
WITH ClinicProfit AS (
    SELECT 
        c.city, 
        c.cid, 
        (SUM(s.amount) - IFNULL(SUM(e.amount), 0)) as profit
    FROM clinics c
    LEFT JOIN clinic_sales s 
        ON c.cid = s.cid AND MONTH(s.datetime) = 9
    LEFT JOIN expenses e 
        ON c.cid = e.cid AND MONTH(e.datetime) = 9
    GROUP BY c.city, c.cid
)
SELECT city, cid, profit
FROM (
    SELECT *, 
           RANK() OVER(PARTITION BY city ORDER BY profit DESC) as rnk
    FROM ClinicProfit
) t 
WHERE rnk = 1;

-- 5. Second least profitable clinic for each state in a given month
WITH ClinicProfit AS (
    SELECT 
        c.state, 
        c.cid, 
        (SUM(s.amount) - IFNULL(SUM(e.amount), 0)) as profit
    FROM clinics c
    LEFT JOIN clinic_sales s 
        ON c.cid = s.cid AND MONTH(s.datetime) = 9
    LEFT JOIN expenses e 
        ON c.cid = e.cid AND MONTH(e.datetime) = 9
    GROUP BY c.state, c.cid
)
SELECT state, cid, profit
FROM (
    SELECT *, 
           RANK() OVER(PARTITION BY state ORDER BY profit ASC) as rnk
    FROM ClinicProfit
) t 
WHERE rnk = 2;