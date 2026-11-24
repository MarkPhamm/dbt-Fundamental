# Documentation

[Course map](../index.md#follow-the-dbt-fundamentals-course) · Previous: [Tests](tests.md) · Next: [Deployment](deployment.md)

Descriptions in `*_schema.yml` become the docs site. Longer text lives in `{% docs %}` blocks in `*_doc.md` files, used with `'{{ doc("name") }}'`. See `order_status` in `stg_jaffle_shop_doc.md`.

| Open | Run (from `oms_dbt_proj`) |
|---|---|
| `models/**/*_doc.md` | `dbt docs generate --profiles-dir .` then `dbt docs serve --profiles-dir .` |

The same descriptions show up in the [ERD](../tools/qdbd.md) that qdbd builds from `dbt docs generate` output.

Background: [Documentation](../notes/dbt-concepts.md#documentation).

## Quiz

<div class="quiz" data-answer="2" markdown>

**Where do column descriptions for `dim_customers` live?**

- In comments inside `dim_customers.sql`
- In `marketing_schema.yml`, beside the model
- In the docs site, edited by hand

<details class="success" markdown>
<summary>Answer</summary>

**In the YAML beside the model.** Docs live next to the code, so they change in the same pull request. `dbt docs generate` reads them into the site.

</details>
</div>

<div class="quiz" data-answer="3" markdown>

**You wrote `{% docs order_status %}` in a `_doc.md` file. How does a column use it?**

- `description: order_status`
- `{{ ref('order_status') }}` in the model SQL
- `description: '{{ doc("order_status") }}'`

<details class="success" markdown>
<summary>Answer</summary>

**`doc()` in a description.** See the `status` column in `stg_jaffle_shop_schema.yml`. The quotes matter: YAML needs them around `{{ }}`.

</details>
</div>

<div class="quiz" data-answer="1" markdown>

**Which command writes the docs site, including the lineage graph?**

- `dbt docs generate`
- `dbt docs serve`
- `dbt compile`

<details class="success" markdown>
<summary>Answer</summary>

**`dbt docs generate`.** It writes `manifest.json`, `catalog.json` and the site into `target/`. `dbt docs serve` only serves what generate wrote.

</details>
</div>

## Try it

Write a `lifetime_value` doc block and use it for `dim_customers.lifetime_value`.

<details class="tip" markdown>
<summary>Hint</summary>

You need two edits: a new `models/marts/marketing/marketing_doc.md` with the `{% docs %}` block, and a `lifetime_value` entry in `marketing_schema.yml` that points at it.

</details>

<details class="success" markdown>
<summary>Answer</summary>

Create `models/marts/marketing/marketing_doc.md`:

```
{% docs lifetime_value %}
Total of successful payments, in dollars, across all of a customer's orders.
NULL when the customer has no orders.
{% enddocs %}
```

Add this to the end of the `columns:` list in `models/marts/marketing/marketing_schema.yml`:

```yaml
  - name: lifetime_value
    description: '{{ doc("lifetime_value") }}'
```

```sh
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

Open `dim_customers` in the docs site (http://localhost:8080). The `lifetime_value` column shows your text. Press Ctrl+C to stop the server.
</details>
