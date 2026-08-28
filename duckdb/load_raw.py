#!/usr/bin/env python3
"""Load tutorial CSVs into duckdb/raw.duckdb (same layout as snowflake/raw_data.sql)."""

import os
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parent
RAW_DB = ROOT / "raw.duckdb"
SQL_FILE = ROOT / "raw_data.sql"


def main() -> None:
    os.chdir(ROOT)
    if RAW_DB.exists():
        RAW_DB.unlink()
    wal = Path(str(RAW_DB) + ".wal")
    if wal.exists():
        wal.unlink()

    con = duckdb.connect(str(RAW_DB))
    statements = [
        stmt.strip()
        for stmt in SQL_FILE.read_text().split(";")
        if stmt.strip() and not stmt.strip().lower().startswith("select")
    ]
    for statement in statements:
        con.execute(statement)

    counts = {
        "jaffle_shop.customers": con.execute(
            "select count(*) from jaffle_shop.customers"
        ).fetchone()[0],
        "jaffle_shop.orders": con.execute(
            "select count(*) from jaffle_shop.orders"
        ).fetchone()[0],
        "stripe.payment": con.execute("select count(*) from stripe.payment").fetchone()[
            0
        ],
    }
    con.close()

    print(f"Wrote {RAW_DB}")
    for relation, n in counts.items():
        print(f"  {relation}: {n} rows")


if __name__ == "__main__":
    main()
