drop table company cascade;
drop table brands cascade ;
drop table models cascade ;
drop table options cascade ;
drop table vehicles cascade ;
drop table manufacturing_plants cascade ;
drop table mp_assemble cascade ;
drop table mp_parts cascade ;
drop table suppliers cascade ;
drop table parts cascade;
drop table assemble_cars cascade ;
drop table dealers cascade ;
drop table deal_purchase cascade ;
drop table orders cascade ;
drop table customers cascade ;
drop table individual_buyer;
drop table company_buyer;

create table company
(
    ID        varchar(5),
    comp_name varchar(25) UNIQUE,
    primary key (ID)
);

create table brands
(
    brand_id   varchar(5),
    brand_name varchar(25) UNIQUE ,
    comp_name  varchar(25),
    primary key (brand_id),
    foreign key (comp_name) references company (comp_name)
);

--------------------------------

create table models
(
    mod_id     varchar(5),
    mod_name   varchar(25) UNIQUE,
    brand_name varchar(25),
    cost       int,
    primary key (mod_id),
    foreign key (brand_name) references brands (brand_name)
);

create table options
(
    mod_id       varchar(5),
    color        varchar(20),
    engine       varchar(20),
    transmission varchar(25),
    primary key (mod_id, color, engine, transmission),
    foreign key (mod_id) references models (mod_id)
);

create table vehicles
(
    VIN    varchar(17),
    mod_id varchar(5),
    primary key (VIN),
    foreign key (mod_id) references models (mod_id)
);

--------------------------------

create table manufacturing_plants
(
    mp_id     varchar(5),
    comp_name varchar(25),
    primary key (mp_id),
    foreign key (comp_name) references company (comp_name)
);

create table mp_assemble
(
    mp_id   varchar(5),
    mp_name varchar(25) UNIQUE NOT NULL,
    primary key (mp_id),
    foreign key (mp_id) references manufacturing_plants (mp_id)
);

create table mp_parts
(
    mp_id     varchar(5),
    mp_name   varchar(25) NOT NULL,
    part_id   varchar(20) UNIQUE NOT NULL,
    part_name varchar(30) NOT NULL,
    date      date NOT NULL,
    primary key (part_id),
    foreign key (mp_id) references manufacturing_plants (mp_id)
);

create table suppliers
(
    sup_id    varchar(5) NOT NULL,
    sup_name  varchar(25) NOT NULL ,
    part_id   varchar(20) UNIQUE NOT NULL,
    part_name varchar(30),
    date      date,
    primary key (part_id)
);

create table parts as (
    select part_id as part_id
    from mp_parts
    union
    select part_id as part_id
    from suppliers
);
alter table parts
add UNIQUE (part_id);

create table assemble_cars
(
    assemble_id varchar(20),
    part_id     varchar(5),
    VIN         varchar(17),
    mp_id       varchar(5),
    date        date,
    primary key (assemble_id),
    foreign key (VIN) references vehicles (VIN),
    foreign key (mp_id) references mp_assemble (mp_id),
    foreign key (part_id) references parts (part_id)
);

-------------------------------------

create table dealers
(
    dealer_id   varchar(5),
    dealer_name varchar(30) NOT NULL,
    phone       varchar(16) NOT NULL,
    address     varchar(30) NOT NULL,
    primary key (dealer_id)
);

create table deal_purchase
(
    VIN       varchar(17),
    dealer_id varchar(5),
    date      date NOT NULL,
    primary key (VIN),
    foreign key (dealer_id) references dealers (dealer_id),
    foreign key (VIN) references vehicles (VIN)
);

create table orders
(
    ord_id     varchar(10),
    dealer_id  varchar(5),
    cus_id     varchar(5),
    VIN        varchar(17),
    date       date NOT NULL,
    primary key (ord_id),
    foreign key (VIN) references vehicles (VIN)
);

create table customers
(
    cus_id  varchar(5),
    address varchar(30) NOT NULL,
    phone   varchar(16) NOT NULL,
    primary key (cus_id)
);

create table individual_buyer
(
    cus_id varchar(5),
    name   varchar(30) NOT NULL,
    gender varchar(6) NOT NULL,
    income int NOT NULL,
    primary key (cus_id),
    foreign key (cus_id) references customers (cus_id)
);

create table company_buyer
(
    cus_id varchar(5),
    name   varchar(30) NOT NULL,
    income int NOT NULL,
    primary key (cus_id),
    foreign key (cus_id) references customers (cus_id)
);











