-- EXPERIMENT 8: Banking Transactions Using COMMIT, ROLLBACK, SAVEPOINT and Transaction Isolation

-- 1. Create Bank Account Table
CREATE TABLE BankAccount (
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(50),
    Balance DECIMAL(10,2)
);


-- 2. Insert Sample Records
INSERT INTO BankAccount VALUES
(101, 'Aman', 10000),
(102, 'Riya', 8000),
(103, 'Rahul', 12000);

-- 3. Display Account Records
SELECT * FROM BankAccount;


-- 4. Banking Transaction Using COMMIT (Aman transfers 1000 to Riya)
BEGIN;

UPDATE BankAccount
SET Balance = Balance - 1000
WHERE AccountID = 101;

UPDATE BankAccount
SET Balance = Balance + 1000
WHERE AccountID = 102;

COMMIT;

-- Verify Transaction
SELECT * FROM BankAccount;


-- 5. Implement ROLLBACK
BEGIN;

UPDATE BankAccount
SET Balance = Balance - 2000
WHERE AccountID = 101;

UPDATE BankAccount
SET Balance = Balance + 2000
WHERE AccountID = 102;

ROLLBACK;

-- Verify
SELECT * FROM BankAccount;


-- 6. Implement SAVEPOINT
BEGIN;

UPDATE BankAccount
SET Balance = Balance - 500
WHERE AccountID = 101;

SAVEPOINT sp1;

UPDATE BankAccount
SET Balance = Balance + 500
WHERE AccountID = 102;

ROLLBACK TO SAVEPOINT sp1;
COMMIT;


-- 7. Simulate Partial Transaction Failure
BEGIN;
UPDATE BankAccount
SET Balance = Balance - 1000
WHERE AccountID = 101;
-- Simulate failure
ROLLBACK;


-- 8. Set Transaction Isolation Level
-- READ UNCOMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- SERIALIZABLE
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;


-- 9. Demonstrate Concurrency Using Two Sessions
-- Session 1
BEGIN;
UPDATE BankAccount
SET Balance = 5000
WHERE AccountID = 101;
-- Do not commit yet.

-- Session 2
SELECT Balance
FROM BankAccount
WHERE AccountID = 101;
-- Depending on the isolation level, Session 2 may or may not see the uncommitted change.

-- Session 1
ROLLBACK;


-- 10. Demonstrate Non-Repeatable Read
-- Session 1
BEGIN;
SELECT Balance
FROM BankAccount
WHERE AccountID = 101;

-- Session 2
UPDATE BankAccount
SET Balance = Balance + 1000
WHERE AccountID = 101;
COMMIT;
-- Session 1
SELECT Balance
FROM BankAccount
WHERE AccountID = 101;
COMMIT;


-- 11. Demonstrate Phantom Read
-- Session 1
BEGIN;
SELECT *
FROM BankAccount
WHERE Balance > 5000;
-- Session 2
INSERT INTO BankAccount VALUES (104, 'Neha', 7000);
COMMIT;
-- Session 1
SELECT *
FROM BankAccount
WHERE Balance > 5000;
COMMIT;
