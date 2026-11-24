# 3. Unit tests and CI

[Next steps](../index.md#next-steps-after-fundamentals) · Previous: [2. Macros, Jinja and packages](02-macros-and-packages.md) · Next: [4. Seeds, analyses and snapshots](04-seeds-analyses-snapshots.md)

Run the commands from `oms_dbt_proj`, after a first `dbt build --profiles-dir .`.

Data tests check the data you have. Unit tests check the logic against rows you write. `test_fct_orders_counts_only_successful_payments` in `finance_schema.yml` proves failed payments are ignored.

```sh
dbt test --profiles-dir . -s test_type:unit
```

Check: 1 unit test passes. Then change `case when status = 'success' then amount end` to `amount` in `fct_orders.sql` and run it again: it fails. Revert the change.

A unit test tells you the logic broke. To see which rows the change touches in real data, compare the CTE before and after with [CTE Diff](../tools/cte-diff.md), or run this query: the orders where summing every payment gives a different amount from summing only successful ones.

<div class="sql-playground" data-expect-rows="7" markdown>

```sql
select
    orderid as order_id,
    sum(case when status = 'success' then amount end) / 100 as success_only,
    sum(amount) / 100 as all_payments
from raw.stripe.payment
group by orderid
having success_only is distinct from all_payments
order by order_id
```

</div>

`.github/workflows/dbt.yml` runs `dbt build` on DuckDB for every pull request, so forks get CI with no secrets.

## Try it

Add a unit test proving a customer with no orders gets `number_of_orders = 0` and a null `lifetime_value`.

<details class="tip" markdown>
<summary>Hint</summary>

Copy `test_fct_orders_counts_only_successful_payments` from `finance_schema.yml`. `dim_customers` reads two inputs, so `given:` needs rows for both, and one customer must have no orders.

</details>

<details class="success" markdown>
<summary>Answer</summary>

Add this to the end of `models/marts/marketing/marketing_schema.yml`:

```yaml
unit_tests:
- name: test_dim_customers_handles_customers_without_orders
  model: dim_customers
  given:
  - input: ref('stg_jaffle_shop__customers')
    rows:
    - {customer_id: 1, first_name: Ann, last_name: A.}
    - {customer_id: 2, first_name: Bob, last_name: B.}
  - input: ref('fct_orders')
    rows:
    - {order_id: 10, customer_id: 1, amount: 5}
    - {order_id: 11, customer_id: 1, amount: 3}
  expect:
    rows:
    - {customer_id: 1, number_of_orders: 2, lifetime_value: 8}
    - {customer_id: 2, number_of_orders: 0, lifetime_value: null}
```

```sh
dbt test --profiles-dir . -s test_type:unit
```

2 unit tests pass. Columns you leave out of `rows` are null in the input and ignored in `expect`.
</details>
