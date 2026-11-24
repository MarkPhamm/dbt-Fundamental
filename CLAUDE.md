# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A dbt-fundamentals learning repo: the jaffle_shop tutorial project (`oms_dbt_proj/`, dbt project name `jaffle_shop`) that runs against two targets from one `oms_dbt_proj/profiles.yml`. DuckDB is the default and needs no login; Snowflake uses the same models and sources. The root `README.md` is a short landing page; learner docs live in `docs/` (`course/`, `next-steps/`, `tools/`, `notes/`), with images in `docs/assets/`.

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
dbt docs generate --profiles-dir . && qdbd import dbt target/ -o erd/ --infer-fks  # ERD into gitignored erd/
```

Lesson site (repo root, `pip install -r requirements-docs.txt`): `mkdocs serve` to preview, `mkdocs build --strict` to check. `.github/workflows/pages.yml` builds it on every PR and deploys `main` to GitHub Pages.

There is no linter. CI (`.github/workflows/dbt.yml`) runs `load_raw.py` then `dbt build` on DuckDB for every PR and push to main.

## Architecture

- **Data flow:** CSVs in `duckdb/data/` → `duckdb/raw_data.sql` (run by `load_raw.py`) → `duckdb/raw.duckdb` with schemas `jaffle_shop` and `stripe`. `snowflake/raw_data.sql` builds the same tables in Snowflake's `raw` database. Keep the two raw scripts in sync: sources declare `database: raw`, and both targets must expose identical `raw.<schema>.<table>` names.
- **DuckDB wiring:** the duckdb target writes models to `duckdb/analytics.duckdb` (schema `analytics`) and attaches `raw.duckdb` read-only as `raw`. Models are queried as `analytics.analytics.<model>` because the file and the schema share the name.
- **Layers:** `models/staging/<source>/` holds `stg_<source>__<entity>` views (rename and cast only, one per source table, with `<dir>_source.yml`, `<dir>_schema.yml`, `<dir>_doc.md` beside them). `models/marts/<domain>/` holds tables (`fct_orders` in finance, `dim_customers` in marketing) built only from `ref()` to staging or other marts. Materializations are set per folder in `dbt_project.yml`.
- **DAG:** `stg_jaffle_shop__orders` + `stg_stripe__payments` → `fct_orders` → `dim_customers` (+ `stg_jaffle_shop__customers`).
- **Business rules:** payment `amount` is converted from cents to dollars in staging via the `cents_to_dollars` macro. `fct_orders.amount` sums only `status = 'success'` payments; a unit test in `finance_schema.yml` guards this.
- **Learner path (README + `docs/`):** the audience is beginners taking dbt Learn's Fundamentals course. The root README links out to one page per module, chapter and tool. Terms:
  - **Module:** a dbt Fundamentals course unit (Models, Sources, Tests, Documentation, Deployment), one row of the "Follow the dbt Fundamentals course" map and one page in `docs/course/`.
  - **Chapter:** a numbered page in `docs/next-steps/`, covering material beyond the course.
  - **Exercise:** a **Try it** task at the end of a module or chapter, with a `<details class="tip" markdown>` Hint and a `<details class="success" markdown>` Answer. Exercises are not applied to the project. Apply each answer exactly as written and confirm its stated result before changing it.
  Keep commands and "Check:" lines in the README and `docs/` true when changing the files they point to.
- **Lesson site:** MkDocs Material renders `docs/` (nav in `mkdocs.yml`); `docs/index.md` is the site home and the pages' back-links target it. `docs/javascripts/lesson.js` upgrades plain markdown: `<div class="sql-playground" markdown>` around a ```sql block becomes a DuckDB-WASM editor (optional `data-expect-rows` check), `<div class="quiz" data-answer="N" markdown>` turns its list into choices (N is 1-based), and the Answer `<details>` gets a "Mark exercise done" button. Progress lives in the browser's localStorage. `mkdocs_hooks.py` serves `duckdb/raw_data.sql` and the CSVs at `data/`, and the playground runs that script, so playground tables match `raw.duckdb`. Keep playground checks and quiz answers true when changing data or models. Block HTML needs the `markdown` attribute or its contents stay unparsed.
- **Images:** every picture is a hand drawing in the `/draw-like-me` style (rough.js, Architects Daughter, one violet `#7c3aed` swipe, `AE Handbook` signature), stored in `docs/assets/drawings/`. The values drawn are real jaffle_shop data (e.g. customer 1 = 2 orders, 33.0; order 5 = 17 → 34), so redraw the affected image when models or raw data change. The site theme uses the same violet and font (`docs/stylesheets/lesson.css`).
- **Codespaces:** `.devcontainer/devcontainer.json` installs requirements, loads raw data and runs `dbt deps`, but deliberately not `dbt build` (the learner's first step).
- **Tools:** `docs/tools/` covers three. `qlineage` and `qdbd` (`quickdbd-cli`, Python 3.11+) come from `requirements.txt` and read files offline: qlineage needs `target/manifest.json` (`dbt compile`), qdbd's ERD import also wants `catalog.json` (`dbt docs generate`). CTE Diff is a VS Code extension (in the devcontainer) that runs `dbt show` on the DuckDB target, so it hits the same one-writer lock as `ui.py`.

## Gotchas

- dbt only parses property files ending in `.yml`; `*_doc.md` files hold `{% docs %}` blocks only.
- `snap_customers` uses the `check` strategy because raw customers has no `updated_at`. Re-running `load_raw.py` rewrites raw data, so the next `dbt snapshot` records any differences as new history rows.
- `load_raw.py` deletes and recreates `raw.duckdb`. It splits `raw_data.sql` on `;` and skips statements starting with `select`, so keep semicolons out of string literals there.
- DuckDB allows one writer per file. Stop `duckdb/ui.py` (Ctrl+C) before running `dbt build`, or the build fails on the lock.
- The Snowflake target defaults `role` to `ACCOUNTADMIN` when `SNOWFLAKE_ROLE` is unset.
- `*.duckdb` files are gitignored, so a fresh clone must run `load_raw.py` before any dbt command touches the duckdb target.
