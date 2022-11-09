/*
-- Blog database schema
created by Md Farzan

All Entities:
Admin, Reader, Auther,
Admin credentials, Author credentials,
Blogs, Comments, Openion,


*/

create database if not exists blog_db;
use blog_db;

create table admins(
	id int primary key,
    email varchar(255) not null unique,
    passkey varchar(255) not null,
    created_at datetime default current_timestamp(),
    updated_at datetime default null on update current_timestamp()
);

alter table admins rename to admin_cred;

create table if not exists admin_details(
    admin_id int not null unique,
    u_name varchar(255) default null,
    contact_no varchar(10) default null,
    city varchar(30) default null,
    updated_at datetime default null on update current_timestamp(),
    constraint fk_admin_id foreign key(admin_id) references admin_cred(id)
);

desc admin_details;

show create table admin_details;

select table_name, constraint_type, constraint_name from information_schema.table_constraints where table_name = 'admin_details' ;

show tables from information_schema like '%cons%';

create table if not exists blogs(
	id int primary key,
    author_id int not null,
    title varchar(255) not null,
    content text not null,
    feature_img_src varchar(255) default null,
    created_at datetime default current_timestamp(),
    updated_at datetime default null on update current_timestamp()
);

alter table blogs add private bool default 0 after feature_img_src;
desc blogs;

create table if not exists author_cred(
	id int primary key,
    email varchar(255) not null,
    passkey varchar(255) not null,
    active_status enum('active', 'suspended') default 'active',
    created_at datetime default current_timestamp(),
    updated_at datetime default null on update current_timestamp()
);

alter table blogs add constraint fk_author_id foreign key(author_id) references author_cred(id);
desc blogs;

alter table blogs change feature_img_src feature_img varchar(255) default null;

create table if not exists author_details(
	author_id int,
    a_name varchar(255) default null,
    contact varchar(10) default null,
    bio varchar(255) default null,
    constraint fk_author_id_for_details foreign key(author_id) references author_cred(id)
);

desc author_details;

create table if not exists comments(
	id int primary key auto_increment,
    parent_id int default 0,
    blog_id int not null,
    reader_id int not null,
    comment_content text not null,
    created_at datetime default current_timestamp()
);

show tables;

set foreign_key_checks = 0;

alter table admin_cred modify id int auto_increment;
alter table author_cred modify id int auto_increment;
alter table blogs modify id int auto_increment;
create table if not exists openion(
id int primary key auto_increment,
blog_id int,
likes int default 0,
dislikes int default 0,
constraint fk_blog_id_for_openion foreign key(blog_id) references blog(id) on delete cascade
);


select * from author_cred;

create table reader(
id int primary key,
email varchar(255) unique not null,
passkey varchar(255) not null,
r_name varchar(255) default null,
age int default null
);

select * from comments;

alter table comments add constraint reader_id foreign key(reader_id) references reader(id);

show tables;

desc admin_cred;

select * from admin_cred;
alter table admin_cred drop column avtar;
alter table admin_cred add column avtar varchar(255) not null after id;

show tables;

select * from reader;
desc reader;

alter table reader modify r_name varchar(255) not null;
alter table reader add column created_at datetime default current_timestamp();


use test_blog_db;
show tables;
select * from reader;
desc reader;

set foreign_key_checks = 0;

alter table reader drop primary key;
alter table reader modify id int primary key auto_increment;

show tables;

select database();

show tables;

drop table openion;

create table blog_opinions(
id int primary key auto_increment,
blog_id int,
likes int default 0,
dislikes int default 0,
constraint fk_blog_id_for_openion foreign key(blog_id) references blogs(id)
);

drop database blog_db;

create database db_blog;


/* database filled with dummy data till now */
use db_blog;
show tables;

drop trigger create_blog_openion_on_blog_insertion;

delimiter && 


create trigger create_blog_openion_on_blog_insertion after insert on blogs
for each row
begin

insert into blog_opinions(blog_id) values(new.id);
end && 
delimiter ;

desc blog_opinions;

select * from blogs;
select * from blog_opinions limit 10 offset 199;

insert into blogs(author_id, title, content) values(5, 'This is Test 3', 'I am testing opanion creator trigger');


delimiter &&
create trigger delete_blog_openion_on_blog_deletion before delete on blogs
for each row
begin

delete from blog_opinions where blog_id = old.id;

end && 
delimiter ;

select * from blogs limit 10 offset 198;
delete from blogs where id = 203;

select * from blog_opinions limit 10 offset 198;
show tables;
select * from author_details;

select blogs.id, blogs.title, blogs.content, author_details.a_name, blog_opinions.likes, blog_opinions.dislikes
 from blogs inner join blog_opinions on blogs.id = blog_opinions.blog_id inner join author_details on blogs.author_id = author_details.author_id
 AND blog_opinions.blog_id = blogs.id
 having blog_opinions.likes > 4177;
 
select * from blog_opinions  where likes > 4177; 
select * from blogs;
select * from blog_opinions;

select * from author_details;
delete from author_details where author_id > 0 limit 100 ;

truncate table author_details;


select blogs.id, blogs.title, blogs.content, blog_opinions.likes, blog_opinions.dislikes,author_details.a_name  from blogs inner join blog_opinions
on blogs.id = blog_opinions.blog_id inner join author_details on blogs.author_id = author_details.author_id  where blog_opinions.likes > 4177;

show tables;
select * from reader;

show triggers;

drop trigger create_blog_openion_on_blog_insertion;

show triggers;