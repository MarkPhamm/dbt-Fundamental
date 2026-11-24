# dbt Fundamentals, hands on

![One dbt project, two warehouses: the jaffle_shop DAG from staging to dim_customers](assets/drawings/cover.png)

Learn dbt from zero. No analytics engineering background needed, only a little SQL. Every lesson uses the same coffee-shop data, jaffle_shop, and the same dbt project in [this repo](https://github.com/MarkPhamm/dbt-Fundamental).

Each lesson mixes three things:

- **Run SQL in your browser.** The playgrounds load the raw jaffle_shop data into DuckDB inside the page. No install, no login.
- **Take the quiz.** Pick an answer and get instant feedback.
- **Do the exercise.** Each **Try it** edits the real dbt project, with a hint and an answer. Mark it done when it works.

Your progress is saved in this browser.

<div class="progress-overall"></div>

## Start here

New to analytics engineering? Read these five in order. They take about an hour and need nothing installed until lesson 5.

| Lesson | You learn | Progress |
|---|---|---|
| [1. What is analytics engineering?](start/01-analytics-engineering.md) | the problem dbt solves, and who does what on a data team | <span data-progress></span> |
| [2. ELT and where dbt fits](start/02-elt-and-dbt.md) | ETL vs ELT, and what dbt is | <span data-progress></span> |
| [3. Meet the data](start/03-meet-the-data.md) | the jaffle_shop tables, and sources, models, tests and docs | <span data-progress></span> |
| [4. How dbt builds tables](start/04-how-dbt-builds.md) | models, `ref()`, the DAG, `dbt build` | <span data-progress></span> |
| [5. Set up the project](start/05-set-up.md) | the project layout, then your first `dbt build` | <span data-progress></span> |

## Follow the dbt Fundamentals course

Now follow dbt Learn's free [dbt Fundamentals](https://learn.getdbt.com/courses/dbt-fundamentals) course alongside the project. It uses the same jaffle_shop data, so each module maps to files you can open and run.

| Module | Open | Run | Progress |
|---|---|---|---|
| [Models](course/models.md) | `models/staging/`, `models/marts/` | `dbt run --profiles-dir .` | <span data-progress></span> |
| [Sources](course/sources.md) | `models/staging/*/*_source.yml` | `dbt source freshness --profiles-dir .` | <span data-progress></span> |
| [Tests](course/tests.md) | `models/**/*_schema.yml`, `tests/` | `dbt test --profiles-dir .` | <span data-progress></span> |
| [Documentation](course/documentation.md) | `models/**/*_doc.md` | `dbt docs generate --profiles-dir .` | <span data-progress></span> |
| [Deployment](course/deployment.md) | `.github/workflows/dbt.yml` | runs on every pull request | <span data-progress></span> |

Exercises edit the project. To undo one, run `git checkout -- oms_dbt_proj` from the repo root and delete any files the answer created.

## Next steps after Fundamentals

Four short chapters, in the order dbt Learn teaches them. Each one runs offline on DuckDB.

| Chapter | Progress |
|---|---|
| [1. Generic tests on a mart](next-steps/01-generic-tests.md) | <span data-progress></span> |
| [2. Macros, Jinja and packages](next-steps/02-macros-and-packages.md) | <span data-progress></span> |
| [3. Unit tests and CI](next-steps/03-unit-tests-and-ci.md) | <span data-progress></span> |
| [4. Seeds, analyses and snapshots](next-steps/04-seeds-analyses-snapshots.md) | <span data-progress></span> |

## Tools

<div class="grid" markdown>

[![QLineage: lifetime_value traced back to stripe.payment.amount](assets/drawings/tool-qlineage.png)](tools/qlineage.md)

[![qdbd: how the staging tables join](assets/drawings/tool-qdbd.png)](tools/qdbd.md)

[![CTE Diff: the rows a change touches in order_payments](assets/drawings/tool-cte-diff.png)](tools/cte-diff.md)

</div>

| Tool | What it shows | Progress |
|---|---|---|
| [QLineage](tools/qlineage.md) | How data flows, model to model and column by column. Reads files only. | |
| [qdbd ERD](tools/qdbd.md) | How tables relate: an ERD built from your dbt tests. Reads files only. | <span data-progress></span> |
| [CTE Diff](tools/cte-diff.md) | Which rows a SQL change touches, one CTE at a time. Runs on DuckDB. | <span data-progress></span> |
| [DuckDB UI](tools/duckdb-ui.md) | The built models, queried in a browser tab. | |

Want to explore the raw data freely? Open the [SQL playground](playground.md).
