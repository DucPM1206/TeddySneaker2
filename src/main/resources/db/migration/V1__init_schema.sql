-- Drop schema if it exists and create new one
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
BEGIN
    -- Drop existing tables if they exist (in reverse order of dependencies)
    DROP TABLE IF EXISTS shoes.dbo.statistic;
    DROP TABLE IF EXISTS shoes.dbo.comment;
    DROP TABLE IF EXISTS shoes.dbo.post;
    DROP TABLE IF EXISTS shoes.dbo.images;
    DROP TABLE IF EXISTS shoes.dbo.order_details;
    DROP TABLE IF EXISTS shoes.dbo.orders;
    DROP TABLE IF EXISTS shoes.dbo.product_category;
    DROP TABLE IF EXISTS shoes.dbo.product_size;
    DROP TABLE IF EXISTS shoes.dbo.product;
    DROP TABLE IF EXISTS shoes.dbo.promotion;
    DROP TABLE IF EXISTS shoes.dbo.category;
    DROP TABLE IF EXISTS shoes.dbo.brand;
    DROP TABLE IF EXISTS shoes.dbo.users;
END
GO

-- Create schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
BEGIN
    EXEC('CREATE SCHEMA dbo')
END
GO

-- Create brand table
CREATE TABLE shoes.dbo.brand (
    id int IDENTITY(1,1) NOT NULL,
    created_at datetime2(6) NULL,
    description nvarchar(255) NULL,
    modified_at datetime2(6) NULL,
    name nvarchar(255) NOT NULL,
    status bit NULL,
    thumbnail varchar(255) NULL,
    CONSTRAINT PK__brand__3213E83FE91D20F3 PRIMARY KEY (id)
);

-- Create category table
CREATE TABLE shoes.dbo.category (
    id int IDENTITY(1,1) NOT NULL,
    created_at datetime2(6) NULL,
    modified_at datetime2(6) NULL,
    name varchar(300) NULL,
    orders int NULL,
    slug varchar(255) NOT NULL,
    status bit NULL,
    CONSTRAINT PK__category__3213E83FF4B8436C PRIMARY KEY (id)
);

-- Create users table
CREATE TABLE shoes.dbo.users (
    id int IDENTITY(1,1) NOT NULL,
    address nvarchar(255) NULL,
    avatar varchar(255) NULL,
    created_at datetime2(6) NULL,
    email varchar(200) NOT NULL,
    full_name nvarchar(255) NULL,
    modified_at datetime2(6) NULL,
    password varchar(255) NOT NULL,
    phone varchar(255) NULL,
    roles varchar(255) NOT NULL,
    status bit NULL,
    CONSTRAINT PK__users__3213E83FCE7D3BE7 PRIMARY KEY (id)
);

-- Create product table
CREATE TABLE shoes.dbo.product (
    id varchar(255) NOT NULL,
    created_at datetime2(6) NULL,
    description text NULL,
    image_feedback varchar(MAX) NULL,
    images varchar(MAX) NULL,
    modified_at datetime2(6) NULL,
    name varchar(300) NULL,
    price bigint NULL,
    sale_price bigint NULL,
    slug varchar(255) NOT NULL,
    status int NULL,
    total_sold bigint NULL,
    product_view int NULL,
    brand_id int NULL,
    product_code varchar(255) NULL,
    CONSTRAINT PK__product__3213E83FB4C136B9 PRIMARY KEY (id),
    CONSTRAINT FK__product__brand_i__3D5E1FD2 FOREIGN KEY (brand_id) REFERENCES shoes.dbo.brand(id)
);

-- Create product_size table
CREATE TABLE shoes.dbo.product_size (
    product_id varchar(255) NOT NULL,
    size int NOT NULL,
    quantity int NULL,
    CONSTRAINT PK__product___85FA4A1BCD095C6E PRIMARY KEY (product_id, size),
    CONSTRAINT FK__product_size__product FOREIGN KEY (product_id) REFERENCES shoes.dbo.product(id)
);

-- Create product_category table
CREATE TABLE shoes.dbo.product_category (
    product_id varchar(255) NULL,
    category_id int NULL,
    CONSTRAINT FK__product_c__categ__403A8C7D FOREIGN KEY (category_id) REFERENCES shoes.dbo.category(id),
    CONSTRAINT FK__product_c__produ__3F466844 FOREIGN KEY (product_id) REFERENCES shoes.dbo.product(id)
);

-- Create promotion table
CREATE TABLE shoes.dbo.promotion (
    id int IDENTITY(1,1) NOT NULL,
    coupon_code varchar(255) NULL,
    created_at datetime2(6) NULL,
    discount_type int NULL,
    discount_value bigint NULL,
    expired_at datetime2(6) NULL,
    is_active bit NULL,
    is_public bit NULL,
    maximum_discount_value bigint NULL,
    name varchar(300) NULL,
    CONSTRAINT PK__promotio__3213E83F6F434365 PRIMARY KEY (id),
    CONSTRAINT UQ__promotio__ADE5CBB7195992A0 UNIQUE (coupon_code)
);

-- Create orders table
CREATE TABLE shoes.dbo.orders (
    id int IDENTITY(1,1) NOT NULL,
    created_at datetime2(6) NULL,
    modified_at datetime2(6) NULL,
    note nvarchar(255) NULL,
    promotion varchar(MAX) NULL,
    total_quantity int NULL,
    receiver_address nvarchar(255) NULL,
    receiver_name nvarchar(255) NULL,
    receiver_phone nvarchar(255) NULL,
    status int NULL,
    total_price bigint NULL,
    buyer_id int NULL,
    created_by int NULL,
    modified_by int NULL,
    CONSTRAINT PK__orders__3213E83F8DDB99B9 PRIMARY KEY (id),
    CONSTRAINT FK__orders__buyer__4CA06362 FOREIGN KEY (buyer_id) REFERENCES shoes.dbo.users(id),
    CONSTRAINT FK__orders__created___4D94879B FOREIGN KEY (created_by) REFERENCES shoes.dbo.users(id),
    CONSTRAINT FK__orders__modified__4E88ABD4 FOREIGN KEY (modified_by) REFERENCES shoes.dbo.users(id)
);

-- Create order_details table
CREATE TABLE shoes.dbo.order_details (
    id int IDENTITY(1,1) NOT NULL,
    order_id int NULL,
    product_id varchar(255) NULL,
    size int NULL,
    quantity int NULL,
    product_price bigint NOT NULL DEFAULT 0,
    discount bigint NOT NULL DEFAULT 0,
    subtotal bigint NOT NULL DEFAULT 0,
    coupon_code varchar(255) NULL,
    CONSTRAINT PK__order_de__3213E83F6CA3B160 PRIMARY KEY (id),
    CONSTRAINT FK__order_det__order__5165187F FOREIGN KEY (order_id) REFERENCES shoes.dbo.orders(id),
    CONSTRAINT FK__order_det__produ__52593CB8 FOREIGN KEY (product_id) REFERENCES shoes.dbo.product(id),
    CONSTRAINT FK_order_details_promotion FOREIGN KEY (coupon_code) REFERENCES shoes.dbo.promotion(coupon_code)
);

-- Create post table
CREATE TABLE shoes.dbo.post (
    id int IDENTITY(1,1) NOT NULL,
    content text NULL,
    created_at datetime2(6) NULL,
    description text NULL,
    modified_at datetime2(6) NULL,
    published_at datetime2(6) NULL,
    slug varchar(600) NULL,
    status int DEFAULT 0 NULL,
    thumbnail nvarchar(255) NULL,
    title varchar(300) NULL,
    created_by int NULL,
    modified_by int NULL,
    CONSTRAINT PK__post__3213E83FA0336AD0 PRIMARY KEY (id),
    CONSTRAINT FK__post__created_by__48CFD27E FOREIGN KEY (created_by) REFERENCES shoes.dbo.users(id),
    CONSTRAINT FK__post__modified_b__49C3F6B7 FOREIGN KEY (modified_by) REFERENCES shoes.dbo.users(id)
);

-- Create images table
CREATE TABLE shoes.dbo.images (
    id varchar(255) NOT NULL,
    created_at datetime2(6) NULL,
    link varchar(255) NULL,
    name varchar(255) NULL,
    size bigint NULL,
    type varchar(255) NULL,
    created_by int NULL,
    CONSTRAINT PK__images__3213E83F604C14B8 PRIMARY KEY (id),
    CONSTRAINT UQ__images__A26923811A858FE3 UNIQUE (link),
    CONSTRAINT FK__images__created___59063A47 FOREIGN KEY (created_by) REFERENCES shoes.dbo.users(id)
);

-- Create comment table
CREATE TABLE shoes.dbo.comment (
    id int IDENTITY(1,1) NOT NULL,
    content text NULL,
    created_at datetime2(6) NULL,
    post_id int NULL,
    product_id varchar(255) NULL,
    user_id int NULL,
    CONSTRAINT PK__comment__3213E83FD1F87F4C PRIMARY KEY (id),
    CONSTRAINT FK_comment_post FOREIGN KEY (post_id) REFERENCES shoes.dbo.post(id),
    CONSTRAINT FK_comment_user FOREIGN KEY (user_id) REFERENCES shoes.dbo.users(id),
    CONSTRAINT FK_comment_product FOREIGN KEY (product_id) REFERENCES shoes.dbo.product(id)
);

-- Create statistic table
CREATE TABLE shoes.dbo.statistic (
    id int IDENTITY(1,1) NOT NULL,
    created_at datetime2(6) NULL,
    profit bigint NULL,
    quantity int NULL,
    sales bigint NULL,
    order_id int NULL,
    CONSTRAINT PK__statisti__3213E83F93647310 PRIMARY KEY (id),
    CONSTRAINT FK__statistic__order__5535A963 FOREIGN KEY (order_id) REFERENCES shoes.dbo.orders(id)
);
