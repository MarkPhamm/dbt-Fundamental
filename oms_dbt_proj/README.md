# jaffle_shop

This is the same dbt project with two targets in `profiles.yml`. Models, sources, and tests are shared; only the target changes.

- **DuckDB** (`--target duckdb`) — default. Runs locally with no warehouse login. Load raw data with `python duckdb/load_raw.py`, then models land in `duckdb/analytics.duckdb`.
- **Snowflake** (`--target snowflake`) — same models and sources. Load raw data with `snowflake/raw_data.sql`, then set `SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, and `SNOWFLAKE_PASSWORD`.

```sh
dbt build --profiles-dir . --target duckdb
dbt build --profiles-dir . --target snowflake
```

## Local DuckDB

Requires Python 3.10+. From the repo root:

```sh
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python duckdb/load_raw.py
```

That creates `duckdb/raw.duckdb` with the same `raw.jaffle_shop` / `raw.stripe` tables as `snowflake/raw_data.sql`.

Then from `oms_dbt_proj`:

```sh
dbt debug --profiles-dir . --target duckdb
dbt deps --profiles-dir .
dbt build --profiles-dir . --target duckdb
```

DuckDB files:

- `duckdb/raw.duckdb` — source tables (attached as database `raw`)
- `duckdb/analytics.duckdb` — dbt models (created on the first run)

## Snowflake

Load sources once with `snowflake/raw_data.sql`, then set:

- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_USER`
- `SNOWFLAKE_PASSWORD`
- optional: `SNOWFLAKE_ROLE`, `SNOWFLAKE_DATABASE` (default `analytics`), `SNOWFLAKE_WAREHOUSE` (default `transforming`), `SNOWFLAKE_SCHEMA` (default `dbt`)

```sh
dbt debug --profiles-dir . --target snowflake
dbt build --profiles-dir . --target snowflake
```
