--2
create role accountant;
create role administrator;
create role support;

GRANT select, insert, update, delete ON accounts TO accountant;
GRANT select, insert, update, delete ON customers TO administrator;
GRANT select, insert ON transactions TO administrator;
GRANT all privileges ON accounts, customers, transactions TO support;

create user acc;
create user adm;
create user sup;

GRANT accountant TO acc;
GRANT administrator TO adm;
GRANT support TO sup;

GRANT all privileges ON accounts, customers, transactions TO sup WITH GRANT OPTION;
REVOKE delete ON customers FROM acc;

--3.2
ALTER TABLE transactions ALTER COLUMN amount set NOT NULL;
ALTER TABLE transactions ALTER COLUMN status set NOT NULL;

--5
CREATE UNIQUE INDEX cus_acc ON accounts(customer_id, currency);
DROP INDEX cus_acc;

CREATE INDEX cur_bal ON accounts(currency, balance)

--6
begin;
INSERT INTO transactions VALUES (4, '2021-11-05 18:00:56.000000', 'NT10204', 'AB10203', 1000, 'init');
UPDATE accounts set balance = balance-500 WHERE accounts.account_id = 'NT10204';
UPDATE accounts set balance = balance+500 WHERE accounts.account_id = 'AB10203';

UPDATE transactions set src_account = 'NK90123' WHERE status = 'commited';
ROLLBACK;
COMMIT;





/*

create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');
