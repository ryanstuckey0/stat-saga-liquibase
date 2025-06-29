create schema statsaga;
GRANT ALL PRIVILEGES
ON
statsaga.*
TO 'liquibase' @'%'
WITH GRANT OPTION;

select * from statsaga.DATABASECHANGELOG;

drop table DATABASECHANGELOGLOCK ;

drop user backend_user;
create user 'backend_user'@'%' identified by 'password';
grant select,update on statsaga.* to 'backend_user';

flush privileges;
GRANT RELOAD ON *.* TO 'liquibase';

select * from app_user;


select * from DATABASECHANGELOG d ;

select * from app_user;
