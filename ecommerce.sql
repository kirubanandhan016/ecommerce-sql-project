PRAGMA foreign_keys = ON;

-- 1. Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    city TEXT NOT NULL,
    reg_date TEXT NOT NULL
);

-- 2. Products table
CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

-- 3. Orders and order items
CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price REAL NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert customers
INSERT INTO customers VALUES
(1, 'Anitha', 'anitha12@gmail.com', 'Chennai', '2026-10-20'),
(2, 'Priya Sharma', 'priya@example.com', 'Bengaluru', '2026-01-15'),
(3, 'Karthik Raj', 'karthik@example.com', 'Chennai', '2026-02-01'),
(4, 'Divya S', 'divya@example.com', 'Hyderabad', '2026-02-10'),
(5, 'Manoj Kumar', 'manoj@example.com', 'Bengaluru', '2026-03-05');

-- Insert products
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000, 10),
(2, 'Mouse', 'Accessories', 500, 50),
(3, 'Keyboard', 'Accessories', 1200, 30),
(4, 'Smartphone', 'Electronics', 25000, 15),
(5, 'Headphones', 'Audio', 1800, 20),
(6, 'Monitor', 'Electronics', 12000, 8),
(7, 'USB Cable', 'Accessories', 250, 100),
(8, 'Speaker', 'Audio', 3500, 12);

-- Insert orders
INSERT INTO orders VALUES
(1, 1, '2026-10-20', 'Delivered'),
(2, 2, '2026-10-18', 'Shipped'),
(3, 3, '2026-10-15', 'Delivered'),
(4, 4, '2026-10-12', 'Processing'),
(5, 5, '2026-10-10', 'Cancelled'),
(6, 1, '2026-10-05', 'Delivered');

-- Insert order items (unit_price preserves the price at the time of purchase)
INSERT INTO order_items VALUES
(1, 2, 2, 500),
(1, 3, 1, 1200),
(2, 4, 1, 25000),
(2, 7, 2, 250),
(3, 1, 1, 55000),
(3, 5, 1, 1800),
(4, 6, 1, 12000),
(4, 8, 1, 3500),
(5, 3, 2, 1200),
(6, 5, 2, 1800),
(6, 7, 3, 250);

-- 4. Basic data queries

-- Display all customers
SELECT *
FROM customers
ORDER BY customer_id;

-- Display products from highest to lowest price
SELECT product_id, product_name, category, price, stock_quantity
FROM products
ORDER BY price DESC, product_name;

-- Find products priced at or above 1,000
SELECT product_name, category, price
FROM products
WHERE price >= 1000
ORDER BY price DESC;

-- Find products with low stock (10 units or fewer)
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity <= 10
ORDER BY stock_quantity, product_name;

-- Find customers registered in Chennai
SELECT customer_id, name, email, reg_date
FROM customers
WHERE city = 'Chennai'
ORDER BY name;

-- 5. Aggregate analysis

-- Summarize products by category
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS average_price,
    SUM(stock_quantity) AS units_in_stock,
    ROUND(SUM(price * stock_quantity), 2) AS inventory_value
FROM products
GROUP BY category
ORDER BY inventory_value DESC;

-- Count customers in each city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city;

-- Show overall inventory statistics
SELECT
    COUNT(*) AS product_count,
    SUM(stock_quantity) AS total_units_in_stock,
    ROUND(AVG(price), 2) AS average_product_price,
    ROUND(SUM(price * stock_quantity), 2) AS total_inventory_value
FROM products;

-- Count registrations by month
SELECT
    strftime('%Y-%m', reg_date) AS registration_month,
    COUNT(*) AS customer_count
FROM customers
GROUP BY registration_month
ORDER BY registration_month;

-- 6. Order and sales analysis

-- Show each order with its customer and total
SELECT
    o.order_id,
    c.name AS customer_name,
    o.order_date,
    o.status,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_total
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY o.order_id, c.name, o.order_date, o.status
ORDER BY o.order_date DESC, o.order_id;

-- Show each customer's completed-order spending
SELECT
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
    AND o.status = 'Delivered'
LEFT JOIN order_items AS oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.name;

-- Rank products by units sold, excluding cancelled orders
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS sales_revenue
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, sales_revenue DESC, p.product_name;

-- 7. Advanced analysis

-- Rank products by price within each category
SELECT
    product_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS price_rank_in_category
FROM products
ORDER BY category, price_rank_in_category, product_name;

-- Find products priced above their category's average
SELECT
    p.product_name,
    p.category,
    p.price,
    ROUND(category_average.average_price, 2) AS category_average_price
FROM products AS p
JOIN (
    SELECT category, AVG(price) AS average_price
    FROM products
    GROUP BY category
) AS category_average
    ON category_average.category = p.category
WHERE p.price > category_average.average_price
ORDER BY p.category, p.price DESC;

-- Classify stock levels
SELECT
    product_name,
    stock_quantity,
    CASE
        WHEN stock_quantity = 0 THEN 'Out of stock'
        WHEN stock_quantity <= 10 THEN 'Low stock'
        WHEN stock_quantity <= 30 THEN 'Medium stock'
        ELSE 'Well stocked'
    END AS stock_status
FROM products
ORDER BY stock_quantity, product_name;

-- Find the most expensive product in each category (including ties)
WITH ranked_products AS (
    SELECT
        product_name,
        category,
        price,
        RANK() OVER (
            PARTITION BY category
            ORDER BY price DESC
        ) AS category_price_rank
    FROM products
)
SELECT product_name, category, price
FROM ranked_products
WHERE category_price_rank = 1
ORDER BY category, product_name;

-- 8. Indexes for common filters and joins
CREATE INDEX IF NOT EXISTS idx_customers_city
    ON customers(city);

CREATE INDEX IF NOT EXISTS idx_customers_reg_date
    ON customers(reg_date);

CREATE INDEX IF NOT EXISTS idx_products_category
    ON products(category);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);