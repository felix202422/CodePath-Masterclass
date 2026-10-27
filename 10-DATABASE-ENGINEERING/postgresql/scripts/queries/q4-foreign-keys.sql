-- Q4: every foreign key in the shop schema, read from the catalog
select c.conrelid::regclass::text        as child_table,
       a.attname                         as column_name,
       c.confrelid::regclass::text       as parent_table,
       c.confdeltype                    as on_delete
  from pg_constraint c
  join pg_attribute a
    on a.attrelid = c.conrelid and a.attnum = any (c.conkey)
 where c.contype = 'f'
   and c.connamespace = 'shop'::regnamespace
 order by 1, 2;
