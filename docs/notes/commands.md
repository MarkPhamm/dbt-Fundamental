# Common dbt commands

[Home](../index.md)

In this repo, run every command from `oms_dbt_proj` and add `--profiles-dir .`, for example `dbt run --profiles-dir . -s dim_customers`. The profile lives in the project, not in `~/.dbt`.

## Running and building models

| Command | Description |
|---|---|
| `dbt run` | Builds models by running their SQL and materializing the results in the warehouse. |
| `dbt build` | Builds models, seeds and snapshots and runs their tests, in DAG order. |
| `dbt run --select <model>` | Runs one model instead of the whole project. |
| `dbt run --exclude <model>` | Runs every model except the one named. |
| `dbt run --full-refresh` | Rebuilds incremental models from scratch. |
| `dbt run --select state:modified+ --state <path>` | Runs only models changed since the artifacts in `<path>`, plus everything downstream. |
| `dbt retry` | Re-runs the last command from the point of failure. |

## Testing

| Command | Description |
|---|---|
| `dbt test` | Runs every test in the project. |
| `dbt test --select test_type:generic` | Runs only generic tests (the ones declared in YAML). |
| `dbt test --select test_type:singular` | Runs only singular tests (SQL files in `tests/`). |
| `dbt test --select test_type:unit` | Runs only unit tests. |
| `dbt test --select <model>` | Runs the tests on one model. |

## Freshness and snapshots

| Command | Description |
|---|---|
| `dbt source freshness` | Checks how old each source is, using its `loaded_at_field`. |
| `dbt snapshot` | Records changes to slowly changing dimensions (SCD Type 2). |
| `dbt snapshot --select <snapshot>` | Runs one snapshot. |

## Documentation and exploration

| Command | Description |
|---|---|
| `dbt docs generate` | Builds the docs site, with descriptions and the lineage graph. |
| `dbt docs serve` | Serves the docs site locally (http://localhost:8080). |
| `dbt ls` | Lists models, tests, sources and other resources. |
| `dbt show --select <model>` | Runs a model's query and prints a preview of the rows. |

## Compiling and debugging

| Command | Description |
|---|---|
| `dbt compile` | Turns Jinja SQL into plain SQL in `target/compiled/` without running it. |
| `dbt debug` | Checks the profile and the warehouse connection. |
| `dbt debug --config-dir` | Prints where dbt looks for `profiles.yml`. |
| `dbt debug --target <target>` | Checks one target's connection. |
| `dbt parse` | Parses the project and reports errors, writing `manifest.json`. |

## Packages and cleanup

| Command | Description |
|---|---|
| `dbt deps` | Installs the packages in `packages.yml`. |
| `dbt clean` | Deletes the `clean-targets` folders, by default `target` and `dbt_packages`. |

## Seeds and operations

| Command | Description |
|---|---|
| `dbt seed` | Loads the CSV files in `seeds/` into the warehouse as tables. |
| `dbt seed --full-refresh` | Drops and reloads seed tables. |
| `dbt run-operation <macro>` | Runs a macro, for example `generate_model_yaml` from codegen. |

## Project setup

| Command | Description |
|---|---|
| `dbt init` | Creates a new dbt project with the standard folders and files. |
