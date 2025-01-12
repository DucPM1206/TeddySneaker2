-- Add product_code column to product table
ALTER TABLE product ADD product_code VARCHAR(50) NULL;

-- Update existing records with a default product code based on id
UPDATE product SET product_code = CONCAT('P', id) WHERE product_code IS NULL;

-- Make product_code not null and unique after populating data
ALTER TABLE product ALTER COLUMN product_code VARCHAR(50) NOT NULL;
ALTER TABLE product ADD CONSTRAINT UQ_Product_Code UNIQUE (product_code);
