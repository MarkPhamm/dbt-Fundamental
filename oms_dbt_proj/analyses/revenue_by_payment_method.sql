-- Analyses compile but never build. Run with:
--   dbt compile --profiles-dir . -s revenue_by_payment_method
-- then paste target/compiled/.../revenue_by_payment_method.sql into the DuckDB UI.
select
    payment_methods.label as payment_method,
    count(*) as successful_payments,
    sum(payments.amount) as revenue

from {{ ref('stg_stripe__payments') }} as payments
left join {{ ref('payment_methods') }} as payment_methods using (payment_method)
where payments.status = 'success'
group by 1
order by revenue desc
