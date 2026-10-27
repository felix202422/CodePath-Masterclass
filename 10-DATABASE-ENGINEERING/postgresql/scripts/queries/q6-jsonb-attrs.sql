-- Q6: document attributes stored beside relational columns (DB-18's hybrid shape)
select id, sku, attrs
  from shop.product
 where attrs <> '{}'::jsonb
 order by id;
