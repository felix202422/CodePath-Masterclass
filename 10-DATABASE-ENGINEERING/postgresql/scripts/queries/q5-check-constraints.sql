-- Q5: CHECK constraints of the shop schema, with their expressions
select conname, pg_get_expr(conbin, conrelid) as expression
  from pg_constraint
 where connamespace = 'shop'::regnamespace
   and contype = 'c'
 order by conname;
