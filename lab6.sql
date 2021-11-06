/* 1a */
SELECT * FROM dealer JOIN client ON dealer.id = client.dealer_id;

/* 1b */
SELECT dealer, c.name, c.city, c.priority, s.id, s.date, s.amount
FROM dealer dealer
LEFT JOIN client c ON dealer.id = c.dealer_id
LEFT JOIN sell s ON c.id = s.client_id
WHERE c.name is not null and c.city is not null and c.priority is not null
AND s.id is not null and s.date is not null and s.amount is not null;

/* 1c */
SELECT dealer, client
FROM dealer INNER JOIN client ON client.city = dealer.location;

/* 1d */
SELECT s.id, s.amount, c.name, c.city
FROM sell s INNER JOIN client c ON s.client_id = c.id
WHERE s.amount >= 100 AND s.amount <= 500;

/* 1e */
SELECT * FROM dealer LEFT JOIN client ON dealer.location = client.city;

/* 1f */
SELECT c.name, c.city, d.name, d.charge
FROM client c JOIN dealer d ON c.dealer_id = d.id;

/* 1g */
SELECT c.name, c.city, dealer
FROM  client c
JOIN dealer ON dealer_id = dealer.id
WHERE dealer.charge > 0.12;

/* 1h */
SELECT c.name, c.city, s.id, s.date, s.amount, d.name, d.charge
FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id;

/* 1i */
SELECT c.name, c.priority, d.name, s.id, s.amount
FROM dealer d
LEFT JOIN client c ON d.id = c.dealer_id
LEFT JOIN sell s ON c.id = s.client_id
WHERE s.amount >= 2000 AND c.priority is not null;


/* 2a */
CREATE VIEW n2a as
SELECT s.date , COUNT(DISTINCT s.client_id), AVG(s.amount) as average, SUM(s.amount) as total_amount
FROM sell s
GROUP BY s.date;
SELECT * FROM n2a;
DROP VIEW n2a;

/* 2b */
CREATE VIEW n2b as
SELECT sell.date, sell.amount
FROM sell
ORDER BY sell.amount desc
LIMIT 5;
SELECT * FROM n2b;
DROP VIEW n2b ;

/* 2c */
CREATE VIEW n2c as
SELECT dealer, COUNT(s.amount), AVG(s.amount) as average, SUM(s.amount) as total_amount
FROM sell s
JOIN dealer ON dealer.id = s.dealer_id
GROUP BY dealer;
SELECT * FROM n2c;
DROP VIEW n2c;

/* 2d */
CREATE VIEW n2d as
SELECT dealer, SUM(amount * dealer.charge)
FROM sell s
JOIN dealer ON dealer.id = s.dealer_id
GROUP BY dealer;
SELECT * FROM n2d;
DROP VIEW n2d;

/* 2e */
CREATE VIEW n2e as
SELECT d.location, COUNT(s.amount), AVG(s.amount) as average, SUM(s.amount) as total_amount
FROM dealer d
JOIN sell s ON d.id = s.dealer_id
GROUP BY d.location;
SELECT * FROM n2e;
DROP VIEW n2e;

/* 2f */
CREATE VIEW n2f as
SELECT c.city, COUNT(s.amount), AVG(s.amount * (d.charge + 1)) as average, SUM(s.amount * (d.charge + 1)) as total_amount
FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id
GROUP BY c.city;
SELECT * FROM n2f;
DROP VIEW n2f;

/* 2g */
CREATE VIEW n2g as
SELECT c.city, sum(s.amount * (d.charge + 1)) as total_expense, sum(s.amount) as total_amount
FROM client c
JOIN sell s ON c.id = s.client_id
JOIN dealer d ON s.dealer_id = d.id and c.city = d.location
GROUP BY c.city;
SELECT * FROM n2g;
DROP VIEW n2g;
