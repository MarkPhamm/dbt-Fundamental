# 1. Generic tests on a mart

[Next steps](../index.md#next-steps-after-fundamentals) · Next: [2. Macros, Jinja and packages](02-macros-and-packages.md)

Run the commands from `oms_dbt_proj`, after a first `dbt build --profiles-dir .`.

`models/marts/finance/finance_schema.yml` declares `unique`, `not_null` and `relationships` tests on `fct_orders`. A schema file only counts if it ends in `.yml`.

```sh
dbt test --profiles-dir . -s fct_orders
```

Check: 6 data tests pass.

## Try it

Add a `not_null` test to `dim_customers.number_of_orders`.

<details class="tip" markdown>
<summary>Hint</summary>

`number_of_orders` isn't listed in `marketing_schema.yml` yet. Add it as a new column entry with a `tests:` list.

</details>

<details class="success" markdown>
<summary>Answer</summary>

Add this to the end of the `columns:` list in `models/marts/marketing/marketing_schema.yml`:

```yaml
  - name: number_of_orders
    tests:
    - not_null
```

```sh
dbt test --profiles-dir . -s dim_customers
```

`not_null_dim_customers_number_of_orders` passes. It passes even for customers with no orders, because `dim_customers` uses `coalesce(..., 0)`.
</details>
