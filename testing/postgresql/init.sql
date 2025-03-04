CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    balance DECIMAL(10, 2) DEFAULT 0
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(id),
    amount DECIMAL(10, 2),
    transaction_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add a default account for testing
INSERT INTO accounts (name, balance) VALUES ('John Doe', 1000.00);
