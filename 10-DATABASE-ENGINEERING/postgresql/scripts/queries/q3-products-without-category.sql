-- Q3: the optional foreign key — products with no category (LEFT JOIN anti-pattern)
select p.id, p.name
  from shop.product p
  left join shop.category c on c.id = p.category_id
 where c.id is null
 order by p.id;
