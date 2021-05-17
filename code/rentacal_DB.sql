create database rentacar;
use rentacar;

create table rent_comp (
rent_comp_id int,
rent_comp_name varchar(20) NOT NULL,
rent_comp_addr varchar(100) NOT NULL,
rent_comp_phone varchar(15) NOT NULL,
rent_comp_admin varchar(20) NOT NULL,
rent_comp_admin_email varchar(40) NOT NULL,
primary key (rent_comp_id)
)character set = 'utf8';

create table cars (
car_id int,
car_comp_id int NOT NULL,
car_name varchar(20) NOT NULL,
car_number varchar(10) NOT NULL,
car_cap int NOT NULL,
car_detail varchar(100) NOT NULL,
car_rent_pay int NOT NULL,
car_reg_date date NOT NULL,
primary key (car_id, car_comp_id),
foreign key (car_comp_id) references rent_comp(rent_comp_id) on delete cascade
) character set = 'utf8';

create table drivers (
driver_license varchar(20) NOT NULL,
dr_name varchar(20) NOT NULL,
dr_addr varchar(100) NOT NULL,
dr_phone varchar(15) NOT NULL,
dr_email varchar(40),
dr_last_use_date date,
dr_last_car varchar(20),
primary key (driver_license)
) character set = 'utf8';

create table repair_shop (
 shop_id int NOT NULL,
 shop_name          varchar(20) NOT NULL,
 shop_addr          varchar(100) NOT NULL,
 shop_phone         varchar(15) NOT NULL,
 shop_admin_name    varchar(25) NOT NULL,
 shop_admin_email   varchar(50) NOT NULL,
 primary key (shop_id)
) character set = 'utf8';

create table rent (
rent_id int NOT NULL,
car_id int,
driver_license varchar(20),
rent_comp_id int,
rent_start_date date NOT NULL,
rent_days int NOT NULL,
pay_date date NOT NULL,
rent_pay int NOT NULL,
extra_bill varchar(100),
extra_pay int,
primary key (rent_id),
foreign key (car_id, rent_comp_id) references cars(car_id, car_comp_id) on delete set null,
foreign key (driver_license) references drivers(driver_license) 
) character set = 'utf8';

create table repair (
 rep_number int NOT NULL,
 car_id int,
 shop_id int,
 rent_comp_id int,
 driver_license varchar(20),
 rep_detail varchar(30) NOT NULL,
 rep_date date NOT NULL,
 rep_price int NOT NULL,
 pay_deadline date NOT NULL,
 extra_rep_detail varchar(100),
 primary key (rep_number),
 foreign key (shop_id) references repair_shop(shop_id),
 foreign key (car_id, rent_comp_id) references cars(car_id, car_comp_id) on delete set null,
 foreign key (driver_license) references drivers(driver_license)
) character set = 'utf8';




    
    
    