-- Q7: revenue by category (three joins + aggregate + ordering)
select c.name as category,
       sum(l.qty * l.unit_price) as revenue
  from shop.order_line l
  join shop.product p    on p.id = l.product_id
  join shop.category c   on c.id = p.category_id
 group by c.name
 order by revenue desc;
