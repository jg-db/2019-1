select rownum, xa.*
from xx_address xa;

select rownum, xa.*
from xx_address xa
where rownum  < 10;

select rownum, xa.*
from xx_address xa
order by xa.address_id desc;