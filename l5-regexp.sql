 select *
 from xx_address
 where REGEXP_LIKE(street_name, 's.i');

 select *
 from xx_address
 where REGEXP_LIKE(street_name, 's.+a');

 select REGEXP_REPLACE(street_name, 'i.+a', 'street'), xx_address.*
 from xx_address;