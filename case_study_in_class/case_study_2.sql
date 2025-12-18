# USE sell_detail_29_11_2025;

CREATE TABLE Customers (
	customer_id      INT auto_increment primary key,
    customer_name	 VARCHAR(100) not null,
    customer_address VARCHAR(256)
);

CREATE TABLE Products (
    product_id	 INT auto_increment primary key,
	product_name VARCHAR(50) not null,
	price	     DECIMAL(10, 2) not null
);

CREATE TABLE Weekdays (
    weekday_id   INT auto_increment	primary key,
	weekday_name VARCHAR(100) unique not null
);

CREATE TABLE Timeslots (
    timeslot_id INT auto_increment primary key,
	timeslot    VARCHAR(100) unique not null
);

CREATE TABLE Payment_Methods (
    payment_method_id INT auto_increment primary key,
	payment_method    VARCHAR(100) unique not null
);

CREATE TABLE Delivery_Methods (
    delivery_method_id INT auto_increment primary key,
	delivery_method    VARCHAR(100) unique not null
);

CREATE TABLE Orders (
    order_id           INT auto_increment primary key,
    address	           VARCHAR(256) not null,
    customer_id        INT not null,
	payment_method_id  INT not null,
	delivery_method_id INT not null,
	weekday_id	       INT not null,
	timeslot_id		   INT not null,
    constraint fk_order_customer
		foreign key (customer_id) 
        references Customers (customer_id),
    constraint fk_order_payment_method
		foreign key (payment_method_id) 
        references Payment_Methods (payment_method_id),
	constraint fk_order_delivery_method
		foreign key (delivery_method_id) 
        references Delivery_Methods (delivery_method_id),
	constraint fk_order_weekday
		foreign key (weekday_id) 
        references Weekdays (weekday_id),
	constraint fk_order_timeslot
		foreign key (timeslot_id) 
        references Timeslots (timeslot_id)
);

CREATE TABLE Order_Details (
    order_id	INT not null,
	product_id	INT	not null,
	quantity	INT	not null,
    constraint fk_order_detail_order
		foreign key (order_id) 
        references Orders (order_id),
	constraint fk_order_detail_product
		foreign key (product_id) 
        references Products (product_id)
);

