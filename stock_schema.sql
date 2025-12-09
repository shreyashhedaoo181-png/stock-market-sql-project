
-- Stock Market SQL System - Schema + Sample Data

CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    ticker VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    sector VARCHAR(100),
    industry VARCHAR(150),
    listed_date DATE
);

CREATE TABLE daily_prices (
    price_id INT PRIMARY KEY,
    company_id INT NOT NULL,
    trade_date DATE NOT NULL,
    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    adj_close DECIMAL(10,2),
    volume BIGINT,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE investors (
    investor_id INT PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(150),
    country VARCHAR(100),
    joined_at DATE
);

CREATE TABLE portfolios (
    portfolio_id INT PRIMARY KEY,
    investor_id INT NOT NULL,
    portfolio_name VARCHAR(100),
    risk_profile VARCHAR(50),
    created_at DATE,
    FOREIGN KEY (investor_id) REFERENCES investors(investor_id)
);

CREATE TABLE portfolio_holdings (
    holding_id INT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    company_id INT NOT NULL,
    quantity INT,
    avg_buy_price DECIMAL(10,2),
    last_updated DATE,
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE trades (
    trade_id INT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    company_id INT NOT NULL,
    trade_date DATE,
    trade_type VARCHAR(10),
    quantity INT,
    price DECIMAL(10,2),
    fees DECIMAL(10,2),
    source VARCHAR(50),
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE dividends (
    dividend_id INT PRIMARY KEY,
    company_id INT NOT NULL,
    ex_date DATE,
    record_date DATE,
    pay_date DATE,
    amount_per_share DECIMAL(10,2),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
