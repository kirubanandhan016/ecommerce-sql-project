import sqlite3
from pathlib import Path

import pytest


SQL_FILE = Path(__file__).resolve().parents[1] / "ecommerce.sql"


@pytest.fixture
def database():
    connection = sqlite3.connect(":memory:")
    connection.executescript(SQL_FILE.read_text(encoding="utf-8"))
    yield connection
    connection.close()


def test_schema_enables_foreign_keys_and_has_no_orphans(database):
    assert database.execute("PRAGMA foreign_keys").fetchone()[0] == 1
    assert database.execute("PRAGMA foreign_key_check").fetchall() == []


def test_completed_customer_spending_uses_historical_order_prices(database):
    row = database.execute(
        """
        SELECT ROUND(SUM(oi.quantity * oi.unit_price), 2)
        FROM orders AS o
        JOIN order_items AS oi ON oi.order_id = o.order_id
        WHERE o.customer_id = 1 AND o.status = 'Delivered'
        """
    ).fetchone()
    assert row[0] == 5800.0


def test_product_price_and_stock_constraints_reject_invalid_values(database):
    with pytest.raises(sqlite3.IntegrityError):
        database.execute(
            "INSERT INTO products VALUES (99, 'Invalid', 'Test', -1, 1)"
        )
    with pytest.raises(sqlite3.IntegrityError):
        database.execute(
            "INSERT INTO products VALUES (100, 'Invalid', 'Test', 1, -1)"
        )
