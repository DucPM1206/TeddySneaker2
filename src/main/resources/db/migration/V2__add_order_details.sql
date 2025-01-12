-- Drop foreign key constraints first
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_product_fk;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_buyer_fk;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_created_by_fk;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_modified_by_fk;

-- Drop columns that will be moved to order_details
ALTER TABLE orders 
    DROP COLUMN IF EXISTS product_id,
    DROP COLUMN IF EXISTS size,
    CHANGE COLUMN price total_price BIGINT,
    CHANGE COLUMN buyer buyer_id BIGINT;

-- Create order_details table
CREATE TABLE order_details (
    id BIGINT PRIMARY KEY IDENTITY(1,1),
    order_id BIGINT NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    size INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    product_price BIGINT NOT NULL,
    subtotal BIGINT NOT NULL,
    CONSTRAINT order_details_order_fk FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT order_details_product_fk FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Re-add foreign key constraints to orders table
ALTER TABLE orders 
    ADD CONSTRAINT orders_buyer_fk FOREIGN KEY (buyer_id) REFERENCES users(id),
    ADD CONSTRAINT orders_created_by_fk FOREIGN KEY (created_by) REFERENCES users(id),
    ADD CONSTRAINT orders_modified_by_fk FOREIGN KEY (modified_by) REFERENCES users(id);

-- Update JSON and TEXT columns to use NVARCHAR(MAX)
ALTER TABLE orders ALTER COLUMN promotion NVARCHAR(MAX);
ALTER TABLE product ALTER COLUMN description NVARCHAR(MAX);
ALTER TABLE product ALTER COLUMN images NVARCHAR(MAX);
ALTER TABLE product ALTER COLUMN image_feedback NVARCHAR(MAX);
ALTER TABLE users ALTER COLUMN roles NVARCHAR(MAX);
