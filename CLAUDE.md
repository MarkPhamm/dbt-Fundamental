# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A dbt-fundamentals learning repo: the jaffle_shop tutorial project (`oms_dbt_proj/`, dbt project name `jaffle_shop`) that runs against two targets from one `oms_dbt_proj/profiles.yml`. DuckDB is the default and needs no login; Snowflake uses the same models and sources. Most of the root `README.md` below "common dbt Commands" is course notes, not project docs.

## Commands

Python deps live in the repo-root `.venv` (`pip install -r requirements.txt`). Run every dbt command from `oms_dbt_proj/` and always pass `--profiles-dir .`; the profile is in the project, not `~/.dbt`.

```sh
python duckdb/load_raw.py                          # repo root: rebuild duckdb/raw.duckdb from duckdb/data/*.csv
cd oms_dbt_proj
dbt deps --profiles-dir .                          # installs dbt-labs/codegen
dbt build --profiles-dir .                         # duckdb target (default)
dbt build --profiles-dir . --target snowflake      # needs SNOWFLAKE_ACCOUNT / _USER / _PASSWORD
dbt build --profiles-dir . -s dim_customers        # one model + its tests
dbt build --profiles-dir . -s +dim_customers       # model plus upstream
dbt test  --profiles-dir . -s stg_stripe__payments # tests for one model
dbt test  --profiles-dir . -s assert_positive_total_for_payments  # one singular test
dbt test  --profiles-dir . -s test_type:unit       # unit tests only
dbt source freshness --profiles-dir .
python ../duckdb/ui.py                             # browser UI on :4213 over analytics.duckdb
```

There is no linter. CI (`.github/workflows/dbt.yml`) runs `load_raw.py` then `dbt build` on DuckDB for every PR and push to main.

## Architecture

- **Data flow:** CSVs in `duckdb/data/` → `duckdb/raw_data.sql` (run by `load_raw.py`) → `duckdb/raw.duckdb` with schemas `jaffle_shop` and `stripe`. `snowflake/raw_data.sql` builds the same tables in Snowflake's `raw` database. Keep the two raw scripts in sync: sources declare `database: raw`, and both targets must expose identical `raw.<schema>.<table>` names.
- **DuckDB wiring:** the duckdb target writes models to `duckdb/analytics.duckdb` (schema `analytics`) and attaches `raw.duckdb` read-only as `raw`. Models are queried as `analytics.analytics.<model>` because the file and the schema share the name.
- **Layers:** `models/staging/<source>/` holds `stg_<source>__<entity>` views (rename and cast only, one per source table, with `<dir>_source.yml`, `<dir>_schema.yml`, `<dir>_doc.md` beside them). `models/marts/<domain>/` holds tables (`fct_orders` in finance, `dim_customers` in marketing) built only from `ref()` to staging or other marts. Materializations are set per folder in `dbt_project.yml`.
- **DAG:** `stg_jaffle_shop__orders` + `stg_stripe__payments` → `fct_orders` → `dim_customers` (+ `stg_jaffle_shop__customers`).
- **Business rules:** payment `amount` is converted from cents to dollars in staging via the `cents_to_dollars` macro. `fct_orders.amount` sums only `status = 'success'` payments; a unit test in `finance_schema.yml` guards this.
- **Learning chapters:** the root README's "Next steps after Fundamentals" section walks through generic tests, macros/codegen, unit tests/CI, and seeds/analyses/snapshots. Each chapter maps to files in this project; keep the README commands and "Check:" lines true when changing them.
- **Lineage:** `qlineage` (from `requirements.txt`) reads lineage offline. Run `dbt compile --profiles-dir .` first so it can use `target/manifest.json`. The root README covers its flags.

## Gotchas

- dbt only parses property files ending in `.yml`; `*_doc.md` files hold `{% docs %}` blocks only.
- `snap_customers` uses the `check` strategy because raw customers has no `updated_at`. Re-running `load_raw.py` rewrites raw data, so the next `dbt snapshot` records any differences as new history rows.
- `load_raw.py` deletes and recreates `raw.duckdb`. It splits `raw_data.sql` on `;` and skips statements starting with `select`, so keep semicolons out of string literals there.
- DuckDB allows one writer per file. Stop `duckdb/ui.py` (Ctrl+C) before running `dbt build`, or the build fails on the lock.
- The Snowflake target defaults `role` to `ACCOUNTADMIN` when `SNOWFLAKE_ROLE` is unset.
- `*.duckdb` files are gitignored, so a fresh clone must run `load_raw.py` before any dbt command touches the duckdb target.
