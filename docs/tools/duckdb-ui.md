# DuckDB UI

[Tools](../index.md#tools)

After a local DuckDB build, launch the UI from the repo root to query models in the browser:

```sh
python duckdb/ui.py
```

That opens http://localhost:4213 against `duckdb/analytics.duckdb` and attaches `duckdb/raw.duckdb` as `raw`. Models use a 3-part name (`database.schema.table`) because the DuckDB file and the dbt schema are both called `analytics`:

```sql
select * from analytics.analytics.dim_customers;
select * from analytics.analytics.fct_orders;
select * from raw.jaffle_shop.customers;
```

Keep the process running while you use the UI. Press Ctrl+C to stop it.

DuckDB allows one writer per file. Stop the UI before you run `dbt build`, or the build fails on the lock.
