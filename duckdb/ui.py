#!/usr/bin/env python3
"""Open the local DuckDB UI against analytics.duckdb so you can query dbt models."""

import time
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parent
ANALYTICS_DB = ROOT / "analytics.duckdb"
RAW_DB = ROOT / "raw.duckdb"
UI_URL = "http://localhost:4213"


def main() -> None:
    if not ANALYTICS_DB.exists():
        raise SystemExit(
            "duckdb/analytics.duckdb not found. From oms_dbt_proj run:\n"
            "  dbt build --profiles-dir . --target duckdb"
        )
    if not RAW_DB.exists():
        raise SystemExit(
            "duckdb/raw.duckdb not found. From the repo root run:\n"
            "  python duckdb/load_raw.py"
        )

    con = duckdb.connect(str(ANALYTICS_DB))
    attached = {
        row[0]
        for row in con.execute("select database_name from duckdb_databases()").fetchall()
    }
    if "raw" not in attached:
        con.execute(f"attach '{RAW_DB}' as raw (read_only)")

    print("Opening DuckDB UI in your browser.")
    print(f"If it does not open, go to {UI_URL}")
    print()
    print("Query models with the 3-part name (database.schema.table):")
    print("  select * from analytics.analytics.dim_customers;")
    print("  select * from analytics.analytics.fct_orders;")
    print("Query sources on the attached raw database:")
    print("  select * from raw.jaffle_shop.customers;")
    print()
    print("Press Ctrl+C to stop the UI.")

    con.execute("call start_ui()")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        try:
            con.execute("call stop_ui_server()")
        except duckdb.Error:
            pass
        print("\nStopped DuckDB UI.")


if __name__ == "__main__":
    main()
