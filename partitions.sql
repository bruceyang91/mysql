
-- mysql表算法
show variables like 'query_cache%';

set global query_cache_type = 1;
set global query_cache_size = 64*1024*1024;

select * from bruce_stu where last_name = 'WOLF';

select sql_no_cache * from bruce_stu where last_name = 'WOLF';



-- mysql分区算法

drop table if exists p_stu_hash;
create table p_stu_hash(
	id int auto_increment,
	name varchar(12),
	time timestamp,
	primary key (id)
) engine=innodb charset=utf8
partition by hash(id) partitions 10
-- 利用 hash(id) 分成10个区
-- id求余映射分区
;



insert into p_stu_hash values (12, '赵子龙', '1990-01-01');
insert into p_stu_hash values (26, '李四', '1991-01-01');
insert into p_stu_hash values (11, '张丰', '1931-01-01');
insert into p_stu_hash values (23, '三丰', '1941-01-01');
insert into p_stu_hash values (24, '李小龙', '1995-01-01');
insert into p_stu_hash values (25, '武媚娘', '1995-01-01');
insert into p_stu_hash values (27, '周杰伦', '1995-01-01');
insert into p_stu_hash values (28, '张杰', '1991-05-01');
insert into p_stu_hash values (29, '周杰', '1998-01-01');
insert into p_stu_hash values (30, '李连杰', '1991-01-01');

-- key分区法
create table p_stu_key (
	id int auto_increment,
	name varchar(12),
	time timestamp,
	primary key (id, name)
) engine=innodb charset=utf8
partition by key(name) partitions 10
-- 利用 key(name) 分成10个区
-- name求余映射分区
;

-- range分区方法
create table p_stu_range (
	id int auto_increment,
	name varchar(12),
	time timestamp,
	birthday date,-- 生日
	primary key (id, birthday)
) engine=innodb charset=utf8
partition by range (year(birthday)) 
-- 使用生日中的年，进行分区操作
(
	partition p70 values less than (1980),
	-- p70的分区，存储值year(birthday)，小于1980
	partition p80 values less than (1990),
	partition p90 values less than (2000),
	partition p00 values less than (2010),
	partition p values less than max_value
);

insert into p_stu_range values (23, 'bruce', '2016-09-09', '1990-12-12');

-- list分区法
create table p_stu_list (
	id int auto_increment,
	name varchar(12),
	intime date,
	birthday date,-- 生日
	primary key (id, intime)
) engine=innodb charset=utf8
partition by list (month(intime)) (
	partition chun values in (3, 4, 5),
	partition xia values in (6, 7, 8, 9, 10),
	partition qiu values in (11),
	partition dong values in (12, 1, 2)
);

insert into p_stu_list values (null, '赵无极', '2015-04-01', '2000-00-00');
insert into p_stu_list values (null, '李寻欢', '2015-09-10', '2000-00-00');
insert into p_stu_list values (null, '孙二娘', '2015-11-11', '2000-00-00');
insert into p_stu_list values (null, '王五', '2015-12-01', '2000-00-00');
alter table p_stu_list add partition 
(partition other values in (0));

alter table p_stu_list drop partition chun;


ALTER TABLE p_stu_hash COALESCE PARTITION 3;
ALTER TABLE p_stu_hash ADD PARTITION PARTITIONS 5;

-- 最大连接数 缓存大小
show variables like 'max_connections';
show variables like 'innodb_buffer_pool_size';
show variables like 'key_buffer_size';