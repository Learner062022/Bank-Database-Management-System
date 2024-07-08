CREATE TABLE IF NOT EXISTS customer_contacts (
    mobile CHAR(10) NOT NULL,
    email VARCHAR(50) NOT NULL PRIMARY KEY
);

INSERT INTO customer_contacts (mobile, email) VALUES
('0481816206', 'something@gmail.com'),
('0481816207', 'Idontknow@yahoo.com'),
('0481816208', 'neverknew@tafe.wa.edu.au');

CREATE TABLE IF NOT EXISTS accounts (
    account_number VARCHAR(20) NOT NULL PRIMARY KEY,
    balance DECIMAL(10, 2) UNSIGNED NOT NULL,
    interest_rate DECIMAL(5, 4) UNSIGNED NOT NULL,
    contact_email VARCHAR(50) NOT NULL,
    FOREIGN KEY (contact_email) REFERENCES customer_contacts(email)
);

INSERT INTO accounts (account_number, balance, interest_rate, contact_email) VALUES
('ACC001', 19000.00, 0.0386, 'something@gmail.com'),
('ACC002', 72000.50, 0.0386, 'Idontknow@yahoo.com'),
('ACC003', 14500.00, 0.0386, 'neverknew@tafe.wa.edu.au');

DELIMITER //
CREATE PROCEDURE add_monthly_interest()
BEGIN
    UPDATE accounts
    SET balance = balance + (balance * interest_rate / 12);
END //
DELIMITER ;

CREATE TABLE IF NOT EXISTS change_log (
    ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL,
    old_balance DECIMAL(10, 2) DEFAULT NULL,
    new_balance DECIMAL(10, 2) DEFAULT NULL,
    old_interest_rate DECIMAL(5, 4) DEFAULT NULL,
    new_interest_rate DECIMAL(5, 4) DEFAULT NULL,
    modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER update_change_log
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF NEW.balance != OLD.balance THEN
        INSERT INTO change_log(account_number, old_balance, new_balance, old_interest_rate, new_interest_rate, modified)
        VALUES (NEW.account_number, OLD.balance, NEW.balance, NULL, NULL, CURRENT_TIMESTAMP);
    END IF;

    IF NEW.interest_rate != OLD.interest_rate THEN
        INSERT INTO change_log(account_number, old_balance, new_balance, old_interest_rate, new_interest_rate, modified)
        VALUES (NEW.account_number, NULL, NULL, OLD.interest_rate, NEW.interest_rate, CURRENT_TIMESTAMP);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER empty_account 
BEFORE DELETE ON customer_contacts 
FOR EACH ROW
BEGIN
    UPDATE accounts 
    SET balance = 0.00 
    WHERE contact_email = OLD.email;
    
    INSERT INTO change_log(account_number, old_balance, new_balance, old_interest_rate, new_interest_rate, modified)
    SELECT account_number, balance, 0.00, interest_rate, interest_rate, CURRENT_TIMESTAMP
    FROM accounts
    WHERE contact_email = OLD.email;
    
    DELETE FROM accounts 
    WHERE contact_email = OLD.email;
END //
DELIMITER ;

UPDATE accounts SET balance = 1.00 WHERE account_number = 'ACC001';

UPDATE accounts SET interest_rate = 1.0000 WHERE account_number = 'ACC002';

DELETE FROM customer_contacts WHERE email = 'something@gmail.com';

SELECT * FROM change_log;

SELECT * FROM accounts;

| ID  | account_number | old_balance | new_balance | old_interest_rate | new_interest_rate | modified            |
|-----|----------------|-------------|-------------|-------------------|-------------------|---------------------|
| 1   | ACC001         | 19000.00    | 1.00        | NULL              | NULL              | 2023-04-13 14:07:57 |
| 2   | ACC002         | NULL        | NULL        | 0.0386            | 1.0000            | 2023-04-13 14:07:57 |
| 3   | ACC001         | 1.00        | 0.00        | NULL              | NULL              | 2023-04-13 14:07:57 |
| 4   | ACC001         | 1.00        | 0.00        | 0.0386            | 0.0386            | 2023-04-13 14:07:57 |

| account_number | balance  | interest_rate | contact_email            |
|----------------|----------|---------------|--------------------------|
| ACC002         | 72000.50 | 1.0000        | Idontknow@yahoo.com      |
| ACC003         | 14500.00 | 0.0386        | neverknew@tafe.wa.edu.au |
