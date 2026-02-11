SELECT * FROM "accounts";

-- MAKE A WITHDRAWAL FROM ALICE AND DEPOSIT TO BOB.
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice'; -- Withdrawal
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob'; -- Deposit

-- RETURN THE TRANSACTION.
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Alice'; -- Withdrawal
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Bob'; -- Deposit

-- USING A TRANSACTION TO MAKE A WITHDRAWAL FROM ALICE AND DEPOSIT TO BOB.
BEGIN TRANSACTION;
    UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice'; -- Withdrawal, but not committed yet
    UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob'; -- Deposit, but not committed yet
COMMIT; -- Commit the transaction

-- CHECK CONSTRAINTS FAILED BECAUSE NO MONEY IN ALICE'S ACCOUNT. THEREFORE, THE TRANSACTION IS ROLLED BACK.
BEGIN TRANSACTION;
    UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Bob'; -- Deposit, but not committed yet
    UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Alice'; -- Withdrawal, but not committed yet
ROLLBACK; -- Rollback the transaction

-- TRANSCTION SHOULD BE DONE SEQUENTIALLY, to be isolated from other transactions.

-- LOCK THE DATABASE TO PREVENT OTHER TRANSACTIONS. We have different types of locks:
-- 1. SHARED LOCK: Allows other transactions to read the database but not write.
-- 2. EXCLUSIVE LOCK: Prevents other transactions from reading or writing the database.
-- 3. IMMEDIATE LOCK: Prevents other transactions from writing the database but allows them to read.

BEGIN EXCLUSIVE TRANSACTION; -- Lock the database to prevent other transactions.
    UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Alice'; -- Withdrawal, but not committed yet
    UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Bob'; -- Deposit, but not committed yet
COMMIT; -- Commit the transaction

BEGIN IMMEDIATE TRANSACTION; -- Lock the database to prevent other transactions.
    UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "name" = 'Alice'; -- Withdrawal, but not committed yet
    UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "name" = 'Bob'; -- Deposit, but not committed yet
COMMIT; -- Commit the transaction
