-- Local DuckDB equivalent of snowflake/raw_data.sql.
-- Run via: python duckdb/load_raw.py
-- Paths are relative to the duckdb/ directory.

create schema if not exists jaffle_shop;
create schema if not exists stripe;

create or replace table jaffle_shop.customers as
select
    cast(id as integer) as id,
    cast(first_name as varchar) as first_name,
    cast(last_name as varchar) as last_name
from read_csv(
    'data/jaffle_shop_customers.csv',
    header = true,
    normalize_names = true
);

create or replace table jaffle_shop.orders as
select
    cast(id as integer) as id,
    cast(user_id as integer) as user_id,
    cast(order_date as date) as order_date,
    cast(status as varchar) as status,
    current_timestamp as _etl_loaded_at
from read_csv(
    'data/jaffle_shop_orders.csv',
    header = true,
    normalize_names = true
);

create or replace table stripe.payment as
select
    cast(id as integer) as id,
    cast(orderid as integer) as orderid,
    cast(paymentmethod as varchar) as paymentmethod,
    cast(status as varchar) as status,
    cast(amount as integer) as amount,
    cast(created as date) as created,
    current_timestamp as _batched_at
from read_csv(
    'data/stripe_payments.csv',
    header = true,
    normalize_names = true
);

select * from jaffle_shop.customers;
select * from jaffle_shop.orders;
select * from stripe.payment;
