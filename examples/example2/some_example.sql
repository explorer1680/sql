SELECT select_list
FROM ...
[WHERE ...]
GROUP BY grouping_column_reference [, grouping_column_reference]...

SELECT product_id, p.name, (sum(s.units) * p.price) AS sales
FROM products p LEFT JOIN sales s USING (product_id)
GROUP BY product_id, p.name, p.price;

SELECT x, sum(y) FROM test1 GROUP BY x HAVING sum(y) > 3;



DELETE FROM table_name WHERE some_column=some_value;

DELETE FROM table_name;
or
DELETE * FROM table_name;

UPDATE table_name
SET column1=value1,column2=value2,...
WHERE some_column=some_value;


some query used in evo project:

SELECT pg.id, COUNT(p.id) FROM evo_Profile p, evo_ProfileGroup pg WHERE p.profile_group_id = pg.id  AND p.id IN ( SELECT id FROM evo_Profile WHERE status = 'ACTIVE') GROUP BY pg.id ORDER BY COUNT(p.id) DESC LIMIT 10;

SELECT pg.id FROM evo_Profile p, evo_ProfileGroup pg WHERE p.status = 'ACTIVE' AND p.profile_group_id = pg.id

SELECT pg.id, COUNT(p.id) FROM evo_Profile p, evo_ProfileGroup pg WHERE p.profile_group_id = pg.id  AND pg.id IN ( SELECT pg.id FROM evo_Profile p, evo_ProfileGroup pg WHERE p.status = 'ACTIVE' AND p.profile_group_id = pg.id ) GROUP BY pg.id ORDER BY COUNT(p.id) DESC LIMIT 10;

SELECT pg.id pg_id, COUNT(p.id) profile_count FROM evo_Profile p, evo_ProfileGroup pg WHERE p.profile_group_id = pg.id  AND pg.id IN ( SELECT pg.id FROM evo_Profile p, evo_ProfileGroup pg WHERE p.status = 'SUBMITTED' AND p.profile_group_id = pg.id ) AND  pg.id NOT IN (SELECT pg.id FROM evo_Profile p, evo_ProfileGroup pg WHERE p.status = 'ACTIVE' AND p.profile_group_id = pg.id) GROUP BY pg.id ORDER BY COUNT(p.id) DESC LIMIT 10;
