-- Q2: total per order from its lines (join + aggregate)
select o.id as order_id, o.customer_id,
       sum(l.qty * l.unit_price) as total
  from shop."order" o
  join shop.order_line l on l.order_id = o.id
 group by o.id, o.customer_id
 order by o.id;
