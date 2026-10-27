-- Q1: row count of every table in the shop schema
select 'category' as table_name, count(*) from shop.category
union all select 'customer',  count(*) from shop.customer
union all select 'order',     count(*) from shop."order"
union all select 'order_line',count(*) from shop.order_line
union all select 'product',   count(*) from shop.product
order by 1;
