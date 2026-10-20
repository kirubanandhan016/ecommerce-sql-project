# 🛒 E-Commerce SQL Analytics

### Turning E-Commerce Data into Business Insights with SQL

A hands-on database project using **SQLite and SQL** to manage customers, products, orders, and order items while analyzing inventory, sales performance, and customer spending.

![SQLite](https://img.shields.io/badge/Database-SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-blue?style=for-the-badge)
![GitHub](https://img.shields.io/badge/Version_Control-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

---

## 📌 Project Overview

This project simulates a small e-commerce database and demonstrates how SQL can support everyday business operations and analytical reporting.

It includes relational database design, data integrity constraints, sample transactional data, analytical queries, and indexes to support common filtering and join operations.

**Key objectives**
- Design a relational database with primary and foreign keys.
- Manage customer, product, order, and order-item data.
- Analyze product inventory and category-level performance.
- Calculate order totals and completed-order customer spending.
- Identify popular products and compare prices within categories.
- Practice advanced SQL techniques for data analysis.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| SQLite | Relational database management |
| SQL | Data manipulation and analytics |
| Git | Version control |
| GitHub | Source code hosting and portfolio |

## 🗄️ Database Schema

The project contains four related tables.

### 1. `customers`
Stores customer information, including name, email, city, and registration date.

### 2. `products`
Stores product names, categories, prices, and available stock quantities.

### 3. `orders`
Records customer orders, dates, and order statuses.

Supported statuses: `Pending`, `Processing`, `Shipped`, `Delivered`, and `Cancelled`.

### 4. `order_items`
Connects orders with products and records the quantity and unit price for each product in an order.

The `unit_price` column preserves the purchase price recorded at the time of the order.

### Relationships

- One customer can have multiple orders.
- One order can contain multiple products.
- One product can appear in multiple orders.
- The composite primary key on `order_items` prevents the same product from appearing twice as separate rows in the same order.

## 📊 SQL Analysis and Features

### Basic Queries
- Retrieve and sort customer records.
- Filter products by price.
- Identify products with low stock.
- Find customers by city.

### Inventory Analytics
- Count products by category.
- Calculate average product prices.
- Measure available stock quantities.
- Estimate inventory value using price multiplied by stock quantity.
- Classify products as out of stock, low stock, medium stock, or well stocked.

### Customer Analytics
- Count customers by city.
- Analyze registrations by month.
- Calculate completed-order spending for each customer.
- Include customers with no completed orders in spending reports.

### Sales Analytics
- Calculate order totals.
- Join orders with customer details.
- Rank products by units sold and sales revenue.
- Exclude cancelled orders from the product sales ranking.

### Advanced SQL
- Common Table Expressions (CTEs).
- Window functions using `RANK()`.
- Category-based product price rankings.
- Subqueries and category-average comparisons.
- Conditional logic using `CASE`.
- Null handling with `COALESCE`.
- Aggregate functions and multi-table joins.

### Database Optimization
The project creates indexes on frequently filtered or joined columns, including customer city, registration date, product category, order customer ID, order date, and order-item product ID.

## 🚀 Getting Started

### Prerequisites
Install SQLite and make sure `sqlite3` is available in your terminal.

### 1. Clone the repository

```bash
git clone https://github.com/kirubanandhan016/ecommerce-sql-project.git
```

### 2. Navigate to the project

```bash
cd ecommerce-sql-project
```

### 3. Execute the SQL script

```bash
sqlite3 ecommerce.db < project.sql
```

**Note:** The script creates tables and inserts sample records. Because the tables use `CREATE TABLE IF NOT EXISTS` but the sample inserts use fixed primary keys, running the script repeatedly against the same populated database may cause unique-constraint errors. Use a fresh database for a clean initial run.

### 4. Open the database

```bash
sqlite3 ecommerce.db
```

### 5. Explore the tables

```sql
.tables

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
```

## 📂 Project Structure

```text
ecommerce-sql-project/
│
├── project.sql
├── README.md
└── .gitignore
```

- `project.sql` — table definitions, sample data, analytical queries, and indexes.
- `README.md` — project documentation.
- `.gitignore` — specifies files that Git should exclude.

## 💡 Business Questions Answered

This project demonstrates how SQL can answer questions such as:

1. Which products have the highest prices?
2. Which product categories have the greatest inventory value?
3. Which cities have the most customers?
4. How much have customers spent on delivered orders?
5. Which products have sold the most units, excluding cancelled orders?
6. Which products are priced above their category average?
7. Which products have the highest prices within each category?
8. Which products need inventory replenishment?

## 🔮 Future Improvements

- Add a dedicated sales dashboard using Python.
- Generate visual reports using Pandas and Matplotlib.
- Add more realistic customer and transaction records.
- Build a REST API with FastAPI to expose product and order data.
- Add automated tests and repeatable database initialization.

## 👨‍💻 Author

**Kirubanandhan V**

GitHub: [@kirubanandhan016](https://github.com/kirubanandhan016)

---

*Built to develop practical SQL, database design, and data analysis skills as part of my journey toward becoming a Python Backend Developer.*

⭐ If you find this project useful, consider starring the repository.
