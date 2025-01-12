-- Create users table
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(200) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255),
    avatar VARCHAR(255),
    roles NVARCHAR(MAX) NOT NULL,
    status BIT,
    created_at DATETIME,
    modified_at DATETIME
);

-- Create brand table
CREATE TABLE brand (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(MAX),
    thumbnail VARCHAR(255),
    status BIT,
    created_at DATETIME,
    modified_at DATETIME
);

-- Create category table
CREATE TABLE category (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    status BIT,
    created_at DATETIME,
    modified_at DATETIME
);

-- Create product table
CREATE TABLE product (
    id VARCHAR(255) PRIMARY KEY,
    product_code VARCHAR(50) NOT NULL,
    name VARCHAR(300) NOT NULL,
    description NVARCHAR(MAX),
    price BIGINT,
    sale_price BIGINT,
    slug VARCHAR(255) NOT NULL,
    images NVARCHAR(MAX),
    image_feedback NVARCHAR(MAX),
    product_view INT,
    total_sold BIGINT,
    status INT,
    created_at DATETIME,
    modified_at DATETIME,
    brand_id BIGINT,
    FOREIGN KEY (brand_id) REFERENCES brand(id)
);

-- Create product_category table (many-to-many relationship)
CREATE TABLE product_category (
    product_id VARCHAR(255),
    category_id BIGINT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- Create product_size table
CREATE TABLE product_size (
    product_id VARCHAR(255),
    size INT,
    quantity INT,
    PRIMARY KEY (product_id, size),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Create orders table
CREATE TABLE orders (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    receiver_name VARCHAR(255),
    receiver_phone VARCHAR(15),
    receiver_address VARCHAR(255),
    note NVARCHAR(MAX),
    price BIGINT,
    total_price BIGINT,
    size INT,
    quantity INT,
    buyer BIGINT,
    product_id VARCHAR(255),
    status INT,
    created_at DATETIME,
    modified_at DATETIME,
    created_by BIGINT,
    modified_by BIGINT,
    promotion NVARCHAR(MAX),
    FOREIGN KEY (buyer) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (modified_by) REFERENCES users(id)
);

-- Create comment table
CREATE TABLE comment (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    content NVARCHAR(MAX),
    user_id BIGINT,
    product_id VARCHAR(255),
    created_at DATETIME,
    status INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Create promotion table
CREATE TABLE promotion (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    coupon_code VARCHAR(50) UNIQUE,
    discount_type INT,
    discount_value BIGINT,
    maximum_discount_value BIGINT,
    is_active BIT,
    is_public BIT,
    created_at DATETIME,
    expired_at DATETIME
);

-- Create user_used_promotion table
CREATE TABLE user_used_promotion (
    user_id BIGINT,
    promotion_id BIGINT,
    used_at DATETIME,
    PRIMARY KEY (user_id, promotion_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (promotion_id) REFERENCES promotion(id)
);

-- Create post table
CREATE TABLE post (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(300),
    content NVARCHAR(MAX),
    description NVARCHAR(MAX),
    slug VARCHAR(600),
    thumbnail VARCHAR(255),
    created_at DATETIME,
    modified_at DATETIME,
    published_at DATETIME,
    status INT,
    created_by BIGINT,
    modified_by BIGINT,
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (modified_by) REFERENCES users(id)
);

-- Create statistic table
CREATE TABLE statistic (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    views INT,
    created_at DATETIME
);

-- Create images table
CREATE TABLE images (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(50),
    size BIGINT,
    link VARCHAR(255) UNIQUE,
    created_at DATETIME,
    created_by BIGINT,
    FOREIGN KEY (created_by) REFERENCES users(id)
);
