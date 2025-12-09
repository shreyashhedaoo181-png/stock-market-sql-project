# Stock Market SQL System

## 📌 Overview
This project is a **Stock Market SQL System** that models companies, daily stock prices, investors, portfolios, trades, and dividends.  
It is designed like a mini backend for a brokerage or trading analytics platform.

You can use this project to practice **real-world, company-level SQL**, including:
- Window functions (LAG, moving averages)
- Portfolio valuation logic
- Realized & unrealized P/L
- Volatility analysis
- Dividend calculation
- Sector allocation analytics

---

## 📂 Project Structure
```
stock-market-sql-project/
├── stock_schema.sql        # All CREATE TABLE + sample data
├── stock_queries.sql       # Advanced SQL analysis queries
└── README.md               # Documentation
```

---

## 🧱 Database Design (ER Style)

### Entities:
- **companies**
- **daily_prices**
- **investors**
- **portfolios**
- **portfolio_holdings**
- **trades**
- **dividends**

### Relationships:
```
companies (company_id) 1 --- n daily_prices
investors (investor_id) 1 --- n portfolios
portfolios (portfolio_id) 1 --- n portfolio_holdings
companies (company_id) 1 --- n portfolio_holdings
portfolios (portfolio_id) 1 --- n trades
companies (company_id) 1 --- n trades
companies (company_id) 1 --- n dividends
```

---

## 🚀 How to Use

### 1. Create database
```sql
CREATE DATABASE stock_market_system;
USE stock_market_system;
```

### 2. Run schema
```sql
SOURCE stock_schema.sql;
```

### 3. Run analysis queries
```sql
SOURCE stock_queries.sql;
```

---

## 📊 Key SQL Insights Included

### ✔ Daily returns with LAG()  
### ✔ 3-day moving average  
### ✔ Top 3 gainers by % return  
### ✔ Portfolio market value (AUM)  
### ✔ Unrealized profit/loss  
### ✔ Realized P/L from trades  
### ✔ Dividend income  
### ✔ Sector allocation  
### ✔ Volatility (STDDEV)  
### ✔ Wash trade detection  
### ✔ Monthly trading activity per investor  

---

## 🔮 Extensions

You can extend this project by adding:

- Intraday 5-minute OHLC data  
- Options trading tables (OI, Greeks)  
- Portfolio rebalancing stored procedures  
- API integration for price updates  
- Materialized views for faster dashboards  

---

## 👨‍💻 Author  
**Shreyash Hedaoo**  
Aspiring Data Analyst | SQL • Python • Power BI • ML  
