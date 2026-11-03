# E-Commerce SQL Analytics

Relational database design and sales analytics using SQL and SQLite.

This project models a small e-commerce dataset and demonstrates how relational queries can answer questions about customers, products, inventory, orders, and sales.

## What it demonstrates

- Relational schema for customers, products, orders, and order items
- Primary keys, foreign keys, unique constraints, and check constraints
- Joins, aggregates, subqueries, and window functions
- Conditional expressions with `CASE` and null handling with `COALESCE`
- Inventory and customer-spending analysis
- Product ranking by units sold and sales revenue
- Indexes for selected filters and joins

## Technology

SQLite · SQL · Git

## Schema overview

- `customers`: customer name, email, city, and registration date
- `products`: product, category, price, and stock quantity
- `orders`: customer, order date, and order status
- `order_items`: products and quantities within an order, with the unit price at purchase time

One customer can place many orders. An order can contain many products through `order_items`. The stored unit price preserves the purchase price at order time.

## Run locally

Install SQLite and ensure the `sqlite3` command is available.

Clone the repository:

```bash
git clone https://github.com/kirubanandhan016/ecommerce-sql-project.git
cd ecommerce-sql-project
```

Create a fresh database and open the SQLite shell:

```bash
sqlite3 ecommerce.db
```

Run the actual script from the SQLite prompt:

```sql
.read ecommerce.sql
```

Inspect the created objects:

```sql
.tables
.schema
```

Exit SQLite with `.quit`.

## Important repeatability note

The script creates tables with `IF NOT EXISTS` and then inserts fixed sample IDs. Re-running it against a database that already contains the sample records can produce primary-key or unique-constraint errors. Use a new database file for a clean run.

## Example analysis questions

- Which products have low or zero stock?
- What is sales revenue by product?
- Which customers have the highest spending on delivered orders?
- How do products rank within their categories by price?
- Which categories have the highest average product prices?

The `ecommerce.sql` file contains the schema, sample data, analytical queries, and indexes. Execute the queries against the initialized database to inspect the actual results.

## Relevance to backend development

The project demonstrates relational modeling, constraints, joins, aggregation, and query patterns commonly used by API services and reporting endpoints.

## Author

**Kirubanandhan V**

- GitHub: [@kirubanandhan016](https://github.com/kirubanandhan016)
- Portfolio: [kirubanandhan016.github.io](https://kirubanandhan016.github.io/)
