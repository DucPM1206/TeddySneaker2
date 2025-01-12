CREATE DATABASE shoess

CREATE TABLE shoess.dbo.brand (
	id bigint IDENTITY(1,1) NOT NULL,
	name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	description nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	thumbnail varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status bit NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	CONSTRAINT PK__brand__3213E83FACBF2759 PRIMARY KEY (id),
	CONSTRAINT UQ__brand__72E12F1BE01DA41B UNIQUE (name)
);


-- shoess.dbo.category definition

-- Drop table

-- DROP TABLE shoess.dbo.category;

CREATE TABLE shoess.dbo.category (
	id bigint IDENTITY(1,1) NOT NULL,
	name varchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	slug varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status bit NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	CONSTRAINT PK__category__3213E83F57F49A1E PRIMARY KEY (id)
);


-- shoess.dbo.promotion definition

-- Drop table

-- DROP TABLE shoess.dbo.promotion;

CREATE TABLE shoess.dbo.promotion (
	id bigint IDENTITY(1,1) NOT NULL,
	name varchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	coupon_code varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	discount_type int NULL,
	discount_value bigint NULL,
	maximum_discount_value bigint NULL,
	is_active bit NULL,
	is_public bit NULL,
	created_at datetime2(6) NULL,
	expired_at datetime2(6) NULL,
	CONSTRAINT PK__promotio__3213E83F302094D9 PRIMARY KEY (id),
	CONSTRAINT UQ__promotio__ADE5CBB77376A736 UNIQUE (coupon_code)
);


-- shoess.dbo.users definition

-- Drop table

-- DROP TABLE shoess.dbo.users;

CREATE TABLE shoess.dbo.users (
	id bigint IDENTITY(1,1) NOT NULL,
	full_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	phone varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	avatar varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	roles nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status bit NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	CONSTRAINT PK__users__3213E83F617FE753 PRIMARY KEY (id)
);


-- shoess.dbo.images definition

-- Drop table

-- DROP TABLE shoess.dbo.images;

CREATE TABLE shoess.dbo.images (
	id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[size] bigint NULL,
	link varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime2(6) NULL,
	created_by bigint NULL,
	CONSTRAINT PK__images__3213E83F08BB9DA4 PRIMARY KEY (id),
	CONSTRAINT UQ__images__A269238197A6C093 UNIQUE (link),
	CONSTRAINT FK__images__created___7755B73D FOREIGN KEY (created_by) REFERENCES shoess.dbo.users(id)
);


-- shoess.dbo.post definition

-- Drop table

-- DROP TABLE shoess.dbo.post;

CREATE TABLE shoess.dbo.post (
	id bigint IDENTITY(1,1) NOT NULL,
	title varchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	content text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	slug varchar(600) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	thumbnail varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	published_at datetime2(6) NULL,
	status int NULL,
	created_by bigint NULL,
	modified_by bigint NULL,
	CONSTRAINT PK__post__3213E83FE15D6E13 PRIMARY KEY (id),
	CONSTRAINT FK__post__created_by__70A8B9AE FOREIGN KEY (created_by) REFERENCES shoess.dbo.users(id),
	CONSTRAINT FK__post__modified_b__719CDDE7 FOREIGN KEY (modified_by) REFERENCES shoess.dbo.users(id)
);


-- shoess.dbo.product definition

-- Drop table

-- DROP TABLE shoess.dbo.product;

CREATE TABLE shoess.dbo.product (
	id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	product_code varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name varchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	description nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	price bigint NULL,
	sale_price bigint NULL,
	slug varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	images nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	image_feedback nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	product_view int NULL,
	total_sold bigint NULL,
	status int NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	brand_id bigint NULL,
	CONSTRAINT PK__product__3213E83F2065A03D PRIMARY KEY (id),
	CONSTRAINT FK__product__brand_i__56E8E7AB FOREIGN KEY (brand_id) REFERENCES shoess.dbo.brand(id)
);


-- shoess.dbo.product_category definition

-- Drop table

-- DROP TABLE shoess.dbo.product_category;

CREATE TABLE shoess.dbo.product_category (
	product_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	category_id bigint NOT NULL,
	CONSTRAINT PK__product___1A56936EF6C699BF PRIMARY KEY (product_id,category_id),
	CONSTRAINT FK__product_c__categ__5AB9788F FOREIGN KEY (category_id) REFERENCES shoess.dbo.category(id),
	CONSTRAINT FK__product_c__produ__59C55456 FOREIGN KEY (product_id) REFERENCES shoess.dbo.product(id)
);


-- shoess.dbo.product_size definition

-- Drop table

-- DROP TABLE shoess.dbo.product_size;

CREATE TABLE shoess.dbo.product_size (
	product_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[size] int NOT NULL,
	quantity int NULL,
	CONSTRAINT PK__product___85FA4A1BF9792C69 PRIMARY KEY (product_id,[size]),
	CONSTRAINT FK__product_s__produ__5D95E53A FOREIGN KEY (product_id) REFERENCES shoess.dbo.product(id)
);


-- shoess.dbo.user_used_promotion definition

-- Drop table

-- DROP TABLE shoess.dbo.user_used_promotion;

CREATE TABLE shoess.dbo.user_used_promotion (
	user_id bigint NOT NULL,
	promotion_id bigint NOT NULL,
	used_at datetime NULL,
	CONSTRAINT PK__user_use__1B75A25958E7303F PRIMARY KEY (user_id,promotion_id),
	CONSTRAINT FK__user_used__promo__6DCC4D03 FOREIGN KEY (promotion_id) REFERENCES shoess.dbo.promotion(id),
	CONSTRAINT FK__user_used__user___6CD828CA FOREIGN KEY (user_id) REFERENCES shoess.dbo.users(id)
);


-- shoess.dbo.comment definition

-- Drop table

-- DROP TABLE shoess.dbo.comment;

CREATE TABLE shoess.dbo.comment (
	id bigint IDENTITY(1,1) NOT NULL,
	content text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	user_id bigint NULL,
	product_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime2(6) NULL,
	status int NULL,
	post_id bigint NULL,
	CONSTRAINT PK__comment__3213E83F2DAB4992 PRIMARY KEY (id),
	CONSTRAINT FK__comment__product__671F4F74 FOREIGN KEY (product_id) REFERENCES shoess.dbo.product(id),
	CONSTRAINT FK__comment__user_id__662B2B3B FOREIGN KEY (user_id) REFERENCES shoess.dbo.users(id),
	CONSTRAINT FKs1slvnkuemjsq2kj4h3vhx7i1 FOREIGN KEY (post_id) REFERENCES shoess.dbo.post(id)
);


-- shoess.dbo.orders definition

-- Drop table

-- DROP TABLE shoess.dbo.orders;

CREATE TABLE shoess.dbo.orders (
	id bigint IDENTITY(1,1) NOT NULL,
	receiver_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	receiver_phone varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	receiver_address varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	note varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	price bigint NULL,
	total_price bigint NULL,
	[size] int NULL,
	quantity int NULL,
	buyer bigint NULL,
	product_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime2(6) NULL,
	modified_at datetime2(6) NULL,
	created_by bigint NULL,
	modified_by bigint NULL,
	promotion nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	buyer_id bigint NULL,
	product nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	coupon_code varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__orders__3213E83FF067F9B5 PRIMARY KEY (id),
	CONSTRAINT FK__orders__buyer__607251E5 FOREIGN KEY (buyer) REFERENCES shoess.dbo.users(id),
	CONSTRAINT FK__orders__created___625A9A57 FOREIGN KEY (created_by) REFERENCES shoess.dbo.users(id),
	CONSTRAINT FK__orders__modified__634EBE90 FOREIGN KEY (modified_by) REFERENCES shoess.dbo.users(id),
	CONSTRAINT FK__orders__product___6166761E FOREIGN KEY (product_id) REFERENCES shoess.dbo.product(id),
	CONSTRAINT FKhtx3insd5ge6w486omk4fnk54 FOREIGN KEY (buyer_id) REFERENCES shoess.dbo.users(id)
);


-- shoess.dbo.statistic definition

-- Drop table

-- DROP TABLE shoess.dbo.statistic;

CREATE TABLE shoess.dbo.statistic (
	id bigint IDENTITY(1,1) NOT NULL,
	name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	views int NULL,
	created_at datetime2(6) NULL,
	profit bigint NULL,
	quantity int NULL,
	sales bigint NULL,
	order_id bigint NULL,
	CONSTRAINT PK__statisti__3213E83F7AFD7443 PRIMARY KEY (id),
	CONSTRAINT FKok7jp7mh6y9tghumc2do51ieq FOREIGN KEY (order_id) REFERENCES shoess.dbo.orders(id)
);


-- shoess.dbo.order_details definition

-- Drop table

-- DROP TABLE shoess.dbo.order_details;

CREATE TABLE shoess.dbo.order_details (
	id bigint IDENTITY(1,1) NOT NULL,
	product_price bigint NOT NULL,
	quantity int NOT NULL,
	[size] int NOT NULL,
	subtotal bigint NOT NULL,
	order_id bigint NOT NULL,
	product_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	coupon_code varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	discount bigint NULL,
	CONSTRAINT PK__order_de__3213E83FE9CE3A55 PRIMARY KEY (id),
	CONSTRAINT FKftr3hhnbjfadovtpjoiaibtjd FOREIGN KEY (coupon_code) REFERENCES shoess.dbo.promotion(coupon_code),
	CONSTRAINT FKinivj2k1370kw224lavkm3rqm FOREIGN KEY (product_id) REFERENCES shoess.dbo.product(id),
	CONSTRAINT FKjyu2qbqt8gnvno9oe9j2s2ldk FOREIGN KEY (order_id) REFERENCES shoess.dbo.orders(id)
);