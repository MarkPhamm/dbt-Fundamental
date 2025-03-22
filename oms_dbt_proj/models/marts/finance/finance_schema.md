version: 2

models:
  - name: fct_orders
    description: One record order
    columns:
      - name: order_id
        description: Primary key
        tests:
          - unique
          - not_null
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('stg_jaffle_shop_customers')
              field: customer_id
      - name: order_date
        description: the order_date of the order_id
        tests: 
          - not_null 
      - name: amount
        description: the amount customer spent on a success payment
        tests:
          - not_null