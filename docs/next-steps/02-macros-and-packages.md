# 2. Macros, Jinja and packages

[Next steps](../index.md#next-steps-after-fundamentals) · Previous: [1. Generic tests on a mart](01-generic-tests.md) · Next: [3. Unit tests and CI](03-unit-tests-and-ci.md)

Run the commands from `oms_dbt_proj`, after a first `dbt build --profiles-dir .`.

`macros/cents_to_dollars.sql` replaces the hand-written `amount / 100` in `stg_stripe__payments`. The `codegen` package (from `packages.yml`) writes model YAML for you.

```sh
dbt compile --profiles-dir . -s stg_stripe__payments
dbt run-operation generate_model_yaml --profiles-dir . --args '{"model_names": ["fct_orders"]}'
```

Check: `target/compiled/.../stg_stripe__payments.sql` contains `round(amount / 100, 2)`, and the second command prints a YAML block for `fct_orders`.

## Run it in the browser

A macro only writes SQL. `{{ cents_to_dollars("amount") }}` becomes `round(amount / 100, 2)`, so the compiled staging model is plain SQL you can run here:

<div class="sql-playground" markdown>

```sql
select
    id as payment_id,
    orderid as order_id,
    amount as amount_cents,
    round(amount / 100, 2) as amount
from raw.stripe.payment
limit 5
```

</div>

## Try it

After the [Models exercise](../course/models.md#try-it), move the `full_name` logic into a `full_name(first_name, last_name)` macro.

<details class="tip" markdown>
<summary>Hint</summary>

Copy the shape of `macros/cents_to_dollars.sql`. Macro arguments are text, so pass the column names in quotes, and the macro pastes them into the SQL.

</details>

<details class="success" markdown>
<summary>Answer</summary>

Create `macros/full_name.sql`:

```sql
{% macro full_name(first_name, last_name) %}
    {{ first_name }} || ' ' || {{ last_name }}
{% endmacro %}
```

In `dim_customers.sql`, replace the `full_name` line with:

```sql
        {{ full_name('customers.first_name', 'customers.last_name') }} as full_name,
```

```sh
dbt run --profiles-dir . -s dim_customers
```

`full_name` still shows `Michael P.`. The compiled SQL in `target/compiled/` shows the expanded expression.
</details>
