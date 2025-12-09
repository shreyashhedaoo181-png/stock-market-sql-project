
-- Stock Market SQL System - Advanced Analysis Queries

-- 1. Daily return using LAG()
SELECT 
    c.ticker,
    d.trade_date,
    d.close_price,
    LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date) AS prev_close,
    ROUND(
        (d.close_price - LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date)) 
        / LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date) * 100, 2
    ) AS daily_return_pct
FROM daily_prices d
JOIN companies c ON d.company_id = c.company_id
ORDER BY c.ticker, d.trade_date;

-- 2. 3-day moving average
SELECT
    c.ticker,
    d.trade_date,
    d.close_price,
    ROUND(AVG(d.close_price) OVER (
        PARTITION BY d.company_id ORDER BY d.trade_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS ma_3
FROM daily_prices d
JOIN companies c ON d.company_id = c.company_id
ORDER BY c.ticker, d.trade_date;

-- 3. Top 3 gainers on a specific date
SELECT ticker, trade_date, close_price, prev_close, daily_return_pct
FROM (
    SELECT
        c.ticker,
        d.trade_date,
        d.close_price,
        LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date) AS prev_close,
        ROUND(
            (d.close_price - LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date)) 
            / LAG(d.close_price) OVER (PARTITION BY d.company_id ORDER BY d.trade_date) * 100, 2
        ) AS daily_return_pct
    FROM daily_prices d
    JOIN companies c ON d.company_id = c.company_id
) x
WHERE trade_date = '2024-11-04'
ORDER BY daily_return_pct DESC
LIMIT 3;

-- 4. Portfolio Market Value (AUM)
SELECT
    p.portfolio_name,
    i.full_name AS investor,
    SUM(h.quantity * dp.close_price) AS total_value
FROM portfolio_holdings h
JOIN portfolios p ON h.portfolio_id = p.portfolio_id
JOIN investors i ON p.investor_id = i.investor_id
JOIN (
    SELECT company_id, close_price
    FROM daily_prices
    WHERE (company_id, trade_date) IN (
        SELECT company_id, MAX(trade_date)
        FROM daily_prices
        GROUP BY company_id
    )
) dp ON dp.company_id = h.company_id
GROUP BY p.portfolio_name, i.full_name;

-- 5. Unrealized P/L
SELECT
    i.full_name,
    p.portfolio_name,
    c.ticker,
    h.quantity,
    h.avg_buy_price,
    dp.close_price,
    ROUND((dp.close_price - h.avg_buy_price) * h.quantity, 2) AS unrealized_pl
FROM portfolio_holdings h
JOIN portfolios p ON h.portfolio_id = p.portfolio_id
JOIN investors i ON p.investor_id = i.investor_id
JOIN companies c ON c.company_id = h.company_id
JOIN (
    SELECT company_id, close_price
    FROM daily_prices
    WHERE (company_id, trade_date) IN (
        SELECT company_id, MAX(trade_date)
        FROM daily_prices
        GROUP BY company_id
    )
) dp ON dp.company_id = h.company_id
ORDER BY i.full_name, p.portfolio_name;

-- 6. Realized P/L from SELL trades
SELECT
    p.portfolio_name,
    c.ticker,
    SUM(CASE WHEN t.trade_type = 'SELL' THEN t.price * t.quantity ELSE 0 END) AS sell_value,
    SUM(CASE WHEN t.trade_type = 'BUY' THEN t.price * t.quantity ELSE 0 END) AS buy_value,
    SUM(
        CASE 
            WHEN t.trade_type = 'SELL' THEN t.price * t.quantity
            ELSE -(t.price * t.quantity)
        END
    ) AS approx_realized_pl
FROM trades t
JOIN portfolios p ON t.portfolio_id = p.portfolio_id
JOIN companies c ON c.company_id = t.company_id
GROUP BY p.portfolio_name, c.ticker;

-- 7. Dividend Income
SELECT
    i.full_name,
    SUM(h.quantity * d.amount_per_share) AS total_dividend
FROM dividends d
JOIN portfolio_holdings h ON h.company_id = d.company_id
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN investors i ON i.investor_id = p.investor_id
GROUP BY i.full_name
ORDER BY total_dividend DESC;

-- 8. Sector Allocation
SELECT
    p.portfolio_name,
    c.sector,
    SUM(h.quantity * dp.close_price) AS sector_value
FROM portfolio_holdings h
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN companies c ON c.company_id = h.company_id
JOIN (
    SELECT company_id, close_price
    FROM daily_prices
    WHERE (company_id, trade_date) IN (
        SELECT company_id, MAX(trade_date)
        FROM daily_prices
        GROUPGROUP BY company_id
    )
) dp ON dp.company_id = h.company_id
GROUP BY p.portfolio_name, c.sector;

-- 9. Most Traded Stocks
SELECT
    c.ticker,
    COUNT(*) AS trade_count,
    SUM(t.quantity) AS total_qty
FROM trades t
JOIN companies c ON c.company_id = t.company_id
GROUP BY c.ticker
ORDER BY total_qty DESC;

-- 10. Monthly Trading Activity
SELECT
    i.full_name,
    DATE_FORMAT(t.trade_date, '%Y-%m') AS month,
    COUNT(*) AS total_trades
FROM trades t
JOIN portfolios p ON p.portfolio_id = t.portfolio_id
JOIN investors i ON i.investor_id = p.investor_id
GROUP BY i.full_name, DATE_FORMAT(t.trade_date, '%Y-%m')
ORDER BY i.full_name, month;
