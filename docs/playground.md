# SQL playground

Query the jaffle_shop raw data in your browser. The page loads the same CSVs with the same script as `python duckdb/load_raw.py`, so the tables match `duckdb/raw.duckdb`.

| Table | Rows | dbt reads it with |
|---|---|---|
| `raw.jaffle_shop.customers` | 100 | `{{ source('jaffle_shop', 'customers') }}` |
| `raw.jaffle_shop.orders` | 99 | `{{ source('jaffle_shop', 'orders') }}` |
| `raw.stripe.payment` | 120 | `{{ source('stripe', 'payment') }}` |

The playground runs plain DuckDB SQL. dbt is not running here, so write table names in full instead of `ref()` and `source()`. Your tables last until you leave the page.

<div class="sql-playground" markdown>

```sql
select * from raw.jaffle_shop.orders limit 10
```

</div>

Try these:

- `describe raw.stripe.payment` lists the columns and types.
- `select status, count(*) from raw.jaffle_shop.orders group by status` counts orders per status.
- `create view stg_customers as select id as customer_id, first_name, last_name from raw.jaffle_shop.customers` builds your own staging view. Query it with `select * from stg_customers`.
