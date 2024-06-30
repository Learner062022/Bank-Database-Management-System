# Bank Database Management System

## Overview
This repository contains an SQL script to manage a bank database. The script creates tables for customers and accounts, implements a procedure for monthly interest calculations, maintains a change log for auditing purposes and handles the deletion of customer accounts with appropriate logging.

## Setup
1. Using Local MySQL Installation: 
    1. Ensure MySQL is installed.
    2. Clone this repository:
    ```sh
    git clone https://github.com/Learner062022/Bank-Database-Management-System.git
    ```
    3. Navigate to the project directory:
    ```sh
    cd triggers.sql
    ```
    4. Open and copy the file's content.
    5. Paste the contents into your MySQL client or command line interface and execute it:
    ```sh
    mysql -u yourusername -p yourpassword < triggers.sql
    ```
2. Using an Online MySQL Compiler:
    1. Open your preferred online MySQL compiler.
    2. Copy the file's contents.
    3. Paste and execute the contents into the online compiler.

## Database Schema
The database schema includs the following tables:
- customer_contacts: Store customer contact details.
- accounts: Store account information, including balanace and interest rate.
- change_log: Records changes to the accounts table for auditing purposes.

## Stored Procedures and Triggers
### Monthly Interest Calculation
The procedure 'add_monthly_interest' adds the correct amount of interest to each account monthly.

### Change Log Trigger
The trigger  'update_change_log' logs changes to the 'accounts' table.

### Customer Deletion Trigger
The trigger 'empty_account' withdraws all money from a customer's account and deletes it when the customer is deleted.

## Testing
Example updates and deletions are included in the script to test the triggers and procedures. Functionality can be verified with the following commands in your MySQL client or online compiler:
 ```sh
 -- Test updating account balance and interest rate
UPDATE accounts SET balance = 1 WHERE account_number = 1;
UPDATE accounts SET interest_rate = 1 WHERE account_number = 2;

-- Test deleting a customer
DELETE FROM customer_contacts WHERE email = 'something@gmail.com';

-- Verify change log
SELECT * FROM change_log;

-- Verify accounts
SELECT * FROM accounts;
```

## Contributing
1. Fork the repository.
2. Create a new branch.
 ```sh
 git checkout -b feature-branch
  ```
3. Commit changes.
 ```sh
git commit -m 'Add new feature'
  ```
4. Push to the branch.
 ```sh
git push origin feature-branch
  ```
5. Create a new Pull Request.

## License
[GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.txt)
