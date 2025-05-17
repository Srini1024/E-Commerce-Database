CREATE TABLE Customers (
    customer_id CHAR(36) PRIMARY KEY, -- Unique identifier for each customer
    email VARCHAR(100) UNIQUE NOT NULL, -- Customer email must be unique
    first_name VARCHAR(50) NOT NULL, -- First name is mandatory
    last_name VARCHAR(50) NOT NULL, -- Last name is mandatory
    phone_number VARCHAR(20) NOT NULL, -- Phone number is mandatory
    address VARCHAR(255) NOT NULL, -- Address is mandatory
    age INT, -- Optional age column
    gender VARCHAR(10), -- Optional gender column (e.g., Male, Female, Other)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Timestamp for record creation
);

CREATE TABLE Orders (
    order_id CHAR(36) PRIMARY KEY,
    customer_id CHAR(36) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Products (
    product_id CHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    units_in_stock INT NOT NULL CHECK (units_in_stock >= 0)
);

CREATE TABLE OrderItems (
    order_item_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Categories (
    category_id CHAR(36) PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE ProductCategories (
    product_id CHAR(36),
    category_id CHAR(36),
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Suppliers (
    supplier_id CHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE ProductSuppliers (
    product_id CHAR(36),
    supplier_id CHAR(36),
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Shipping (
    shipping_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    shipping_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
CREATE TABLE Reviews (
    review_id CHAR(36) PRIMARY KEY,
    product_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Wishlists (
    wishlist_id CHAR(36) PRIMARY KEY,
    customer_id CHAR(36),
    product_id CHAR(36),
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Payments (
    payment_id CHAR(36) PRIMARY KEY, -- Unique identifier for each payment
    order_id CHAR(36) UNIQUE NOT NULL, -- Links to the order being paid
    customer_id CHAR(36) NOT NULL, -- Links to the customer making the payment
    total_amount DECIMAL(10, 2) NOT NULL, -- Total payment amount
    payment_status ENUM('Pending', 'Completed', 'Failed') NOT NULL, -- Payment status
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Timestamp of payment
    cc_flag BOOLEAN DEFAULT FALSE, -- Indicates if a credit card was used
    gc_flag BOOLEAN DEFAULT FALSE, -- Indicates if a gift card was used
    FOREIGN KEY (order_id) REFERENCES Orders(order_id), -- Link to Orders table
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id), -- Link to Customers table
    CHECK (cc_flag = TRUE OR gc_flag = TRUE) -- At least one flag must be TRUE
);

CREATE TABLE PaymentDetails (
    payment_detail_id CHAR(36) PRIMARY KEY,
    payment_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_type ENUM('Credit Card', 'Gift Card') NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);
CREATE TABLE CreditCardPayments (
    credit_card_payment_id CHAR(36) PRIMARY KEY, -- Unique identifier for credit card payments
    payment_id CHAR(36) UNIQUE NOT NULL, -- Link to Payments table
    card_number VARCHAR(16) NOT NULL,
    card_holder_name VARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

CREATE TABLE GiftCardPayments (
    gift_card_payment_id CHAR(36) PRIMARY KEY, -- Unique identifier for gift card payments
    payment_id CHAR(36) UNIQUE NOT NULL, -- Link to Payments table
    gift_card_code VARCHAR(50) NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

INSERT INTO Customers (customer_id, first_name, last_name, age, gender, email, phone_number, address, created_at)
VALUES
('C001', 'John', 'Doe', 30, 'Male', 'john.doe@example.com', '123-456-7890', '123 Elm Street', '2024-01-01 10:00:00'),
('C002', 'Jane', 'Smith', 25, 'Female', 'jane.smith@example.com', '234-567-8901', '456 Oak Avenue', '2024-01-02 11:00:00'),
('C003', 'Alice', 'Johnson', 28, 'Female', 'alice.johnson@example.com', '345-678-9012', '789 Pine Road', '2024-01-03 12:00:00'),
('C004', 'Bob', 'Brown', 35, 'Male', 'bob.brown@example.com', '456-789-0123', '101 Maple Lane', '2024-01-04 13:00:00'),
('C005', 'Michael', 'Williams', 40, 'Male', 'michael.williams@example.com', '567-890-1234', '202 Birch Street', '2024-01-05 14:00:00'),
('C006', 'Emily', 'Jones', 22, 'Female', 'emily.jones@example.com', '678-901-2345', '303 Cedar Avenue', '2024-01-06 15:00:00'),
('C007', 'David', 'Miller', 45, 'Male', 'david.miller@example.com', '789-012-3456', '404 Pine Street', '2024-01-07 16:00:00'),
('C008', 'Sarah', 'Davis', 32, 'Female', 'sarah.davis@example.com', '890-123-4567', '505 Oak Lane', '2024-01-08 17:00:00'),
('C009', 'James', 'Garcia', 27, 'Male', 'james.garcia@example.com', '901-234-5678', '606 Maple Avenue', '2024-01-09 18:00:00'),
('C010', 'Laura', 'Martinez', 29, 'Female', 'laura.martinez@example.com', '012-345-6789', '707 Birch Lane', '2024-01-10 19:00:00'),
('C011', 'Robert', 'Rodriguez', 33, 'Male', 'robert.rodriguez@example.com', '123-456-7891', '808 Cedar Street', '2024-01-11 20:00:00'),
('C012', 'Linda', 'Martinez', 31, 'Female', 'linda.martinez@example.com', '234-567-8902', '909 Pine Avenue', '2024-01-12 21:00:00'),
('C013', 'William', 'Hernandez', 36, 'Male', 'william.hernandez@example.com', '345-678-9013', '1010 Oak Street', '2024-01-13 22:00:00'),
('C014', 'Barbara', 'Lopez', 38, 'Female', 'barbara.lopez@example.com', '456-789-0124', '1111 Maple Lane', '2024-01-14 23:00:00'),
('C015', 'Richard', 'Gonzalez', 42, 'Male', 'richard.gonzalez@example.com', '567-890-1235', '1212 Birch Avenue', '2024-01-15 08:00:00'),
('C016', 'Susan', 'Wilson', 34, 'Female', 'susan.wilson@example.com', '678-901-2346', '1313 Cedar Lane', '2024-01-16 09:00:00'),
('C017', 'Joseph', 'Anderson', 37, 'Male', 'joseph.anderson@example.com', '789-012-3457', '1414 Pine Street', '2024-01-17 10:00:00'),
('C018', 'Jessica', 'Thomas', 26, 'Female', 'jessica.thomas@example.com', '890-123-4568', '1515 Oak Avenue', '2024-01-18 11:00:00'),
('C019', 'Charles', 'Taylor', 39, 'Male', 'charles.taylor@example.com', '901-234-5679', '1616 Maple Lane', '2024-01-19 12:00:00'),
('C020', 'Karen', 'Moore', 41, 'Female', 'karen.moore@example.com', '012-345-6780', '1717 Birch Street', '2024-01-20 13:00:00');
select * from customers;


INSERT INTO Orders (order_id, customer_id, status, created_at)
VALUES
-- Orders for Customer C001
('O001', 'C001', 'Completed', '2024-07-01 12:00:00'),
('O002', 'C001', 'Processing', '2024-07-15 09:00:00'),

-- Orders for Customer C002
('O003', 'C002', 'Completed', '2024-07-10 08:00:00'),
('O004', 'C002', 'Completed', '2024-06-30 11:45:00'),

-- Orders for Customer C003
('O005', 'C003', 'Completed', '2024-07-12 14:15:00'),
('O006', 'C003', 'Processing', '2024-07-20 16:45:00'),

-- Orders for Customer C004
('O007', 'C004', 'Processing', '2024-07-18 10:30:00'),

-- Orders for Customer C005
('O008', 'C005', 'Completed', '2024-07-01 12:00:00'),
('O009', 'C005', 'Processing', '2024-07-10 08:00:00'),

-- Orders for Customer C006
('O010', 'C006', 'Completed', '2024-07-12 14:15:00'),
('O011', 'C006', 'Processing', '2024-07-12 14:15:00'),

-- Orders for Customer C007
('O012', 'C007', 'Completed', '2024-07-15 09:00:00'),

-- Orders for Customer C008
('O013', 'C008', 'Processing', '2024-07-18 10:30:00'),

-- Orders for Customer C009
('O014', 'C009', 'Completed', '2024-07-01 12:00:00'),
('O015', 'C009', 'Processing', '2024-07-10 08:00:00'),

-- Orders for Customer C010
('O016', 'C010', 'Completed', '2024-07-12 14:15:00'),
('O017', 'C010', 'Processing', '2024-07-12 14:15:00'),

-- Orders for Customer C011
('O018', 'C011', 'Completed', '2024-07-15 09:00:00'),

-- Orders for Customer C012
('O019', 'C012', 'Processing', '2024-07-18 10:30:00'),

-- Orders for Customer C013
('O020', 'C013', 'Completed', '2024-07-01 12:00:00'),
('O021', 'C013', 'Processing', '2024-07-10 08:00:00'),

-- Orders for Customer C014
('O022', 'C014', 'Completed', '2024-07-12 14:15:00'),
('O023', 'C014', 'Processing', '2024-07-12 14:15:00'),

-- Orders for Customer C015
('O024', 'C015', 'Completed', '2024-07-15 09:00:00'),

-- Orders for Customer C016
('O025', 'C016', 'Processing', '2024-07-18 10:30:00'),

-- Orders for Customer C017
('O026', 'C017', 'Completed', '2024-07-01 12:00:00'),
('O027', 'C017', 'Processing', '2024-07-10 08:00:00'),

-- Orders for Customer C018
('O028', 'C018', 'Completed', '2024-07-12 14:15:00'),
('O029', 'C018', 'Processing', '2024-07-12 14:15:00'),

-- Orders for Customer C019
('O030', 'C019', 'Completed', '2024-07-15 09:00:00'),

-- Orders for Customer C020
('O031', 'C020', 'Processing', '2024-07-18 10:30:00');



select * from orders;

INSERT INTO Products (product_id, name, description, price, units_in_stock)
VALUES
('P001', 'Smartphone', 'Latest model smartphone with 128GB storage', 699.99, 50),
('P002', 'Jeans', 'Comfortable blue jeans', 49.99, 100),
('P003', 'Cookbook', 'Healthy recipes for everyday cooking', 19.99, 200),
('P004', 'Blender', 'High-speed blender for smoothies', 89.99, 30),
('P005', 'Laptop', '15-inch laptop with 256GB SSD', 999.99, 40),
('P006', 'T-shirt', 'Cotton t-shirt in various colors', 14.99, 150),
('P007', 'Headphones', 'Noise-cancelling over-ear headphones', 199.99, 60),
('P008', 'Sneakers', 'Running shoes with breathable fabric', 79.99, 80),
('P009', 'Coffee Maker', 'Automatic coffee maker with grinder', 129.99, 25),
('P010', 'Backpack', 'Durable backpack with multiple compartments', 59.99, 70),
('P011', 'Tablet', '10-inch tablet with 64GB storage', 299.99, 45),
('P012', 'Dress', 'Elegant evening dress', 89.99, 90),
('P013', 'Novel', 'Bestselling fiction novel', 24.99, 120),
('P014', 'Microwave', 'Compact microwave oven', 149.99, 35),
('P015', 'Action Figure', 'Collectible action figure', 29.99, 110),
('P016', 'Basketball', 'Official size basketball', 29.99, 95),
('P017', 'Lipstick', 'Long-lasting matte lipstick', 19.99, 130),
('P018', 'Yoga Mat', 'Non-slip yoga mat', 39.99, 85),
('P019', 'Car Charger', 'Fast charging car charger', 14.99, 140),
('P020', 'Sofa', '3-seater fabric sofa', 499.99, 20),
('P021', 'Keyboard', 'Mechanical gaming keyboard', 99.99, 60),
('P022', 'Camera', 'Digital SLR camera', 499.99, 20);


INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date)
VALUES
('W001', 'C018', 'P021', '2024-12-07 00:00:00'),
('W002', 'C013', 'P012', '2024-06-15 00:00:00'),
('W003', 'C015', 'P005', '2024-12-24 00:00:00'),
('W004', 'C002', 'P012', '2024-09-26 00:00:00'),
('W005', 'C005', 'P012', '2024-09-03 00:00:00'),
('W006', 'C019', 'P015', '2024-04-16 00:00:00'),
('W007', 'C016', 'P001', '2024-07-18 00:00:00'),
('W008', 'C014', 'P007', '2024-11-13 00:00:00'),
('W009', 'C013', 'P011', '2024-08-10 00:00:00'),
('W010', 'C016', 'P011', '2024-05-28 00:00:00'),
('W011', 'C010', 'P018', '2024-07-22 00:00:00'),
('W012', 'C005', 'P020', '2024-11-08 00:00:00'),
('W013', 'C011', 'P018', '2024-11-17 00:00:00'),
('W014', 'C019', 'P021', '2024-06-21 00:00:00'),
('W015', 'C017', 'P008', '2024-10-14 00:00:00'),
('W016', 'C020', 'P010', '2024-01-05 00:00:00'), 
('W017', 'C018', 'P009', '2024-07-13 00:00:00'), 
('W018', 'C015', 'P013', '2024-12-07 00:00:00'),
('W019', 'C020', 'P017', '2024-06-21 00:00:00'),
('W020', 'C014', 'P006', '2024-03-09 00:00:00');


INSERT INTO Categories (category_id, name)
VALUES
('CAT001', 'Electronics'),
('CAT002', 'Home Appliances'),
('CAT003', 'Books'),
('CAT004', 'Clothing'),
('CAT005', 'Toys'),
('CAT006', 'Furniture'),
('CAT007', 'Health & Beauty'),
('CAT008', 'Sports'),
('CAT009', 'Automotive');


INSERT INTO ProductCategories (product_id, category_id)
VALUES
-- Electronics
('P001', 'CAT001'), -- Smartphone
('P005', 'CAT001'), -- Laptop
('P007', 'CAT001'), -- Headphones
('P011', 'CAT001'), -- Tablet
('P021', 'CAT001'), -- Keyboard
('P022', 'CAT001'), -- Camera

-- Home Appliances
('P004', 'CAT002'), -- Blender
('P009', 'CAT002'), -- Coffee Maker
('P014', 'CAT002'), -- Microwave

-- Books
('P003', 'CAT003'), -- Cookbook
('P013', 'CAT003'), -- Novel

-- Clothing
('P002', 'CAT004'), -- Jeans
('P006', 'CAT004'), -- T-shirt
('P012', 'CAT004'), -- Dress
('P010', 'CAT004'), -- Backpack (Added under Clothing)
('P008', 'CAT004'),

-- Toys
('P015', 'CAT005'), -- Action Figure
('P016', 'CAT005'),

-- Furniture
('P020', 'CAT006'), -- Sofa

-- Health & Beauty
('P017', 'CAT007'), -- Lipstick

-- Sports
('P008', 'CAT008'), -- Sneakers
('P016', 'CAT008'), -- Basketball
('P018', 'CAT008'), -- Yoga Mat
('P010', 'CAT008'),

-- Automotive
('P019', 'CAT009'); -- Car Charger

INSERT INTO Suppliers (supplier_id, name, contact_info)
VALUES
('S001', 'TechGurus Inc.', 'techgurus@example.com, +1-800-555-0101'),
('S002', 'Fashionista Co.', 'contact@fashionista.com, +1-800-555-0202'),
('S003', 'Home Essentials', 'support@homeessentials.com, +1-800-555-0303'),
('S004', 'FitLife Supplies', 'info@fitlife.com, +1-800-555-0404'),
('S005', 'BooksWorld', 'books@example.com, +1-800-555-0505'),
('S006', 'GadgetPros', 'sales@gadgetpros.com, +1-800-555-0606'),
('S007', 'Sporty Gear', 'contact@sportygear.com, +1-800-555-0707'),
('S008', 'FurnishWell', 'furnish@example.com, +1-800-555-0808'),
('S009', 'BrightTech', 'hello@brighttech.com, +1-800-555-0909'),
('S010', 'Healthy Living', 'healthyliving@example.com, +1-800-555-1010'),
('S011', 'ElectroHub', 'contact@electrohub.com, +1-800-555-1111'),
('S012', 'WearItWell', 'info@wearitwell.com, +1-800-555-1212'),
('S013', 'ApplianceMart', 'support@appliancemart.com, +1-800-555-1313'),
('S014', 'SportsEmpire', 'sales@sportsempire.com, +1-800-555-1414'),
('S015', 'KitchenPros', 'info@kitchenpros.com, +1-800-555-1515'),
('S016', 'EcoEssentials', 'hello@ecoessentials.com, +1-800-555-1616'),
('S017', 'MegaBooks', 'support@megabooks.com, +1-800-555-1717'),
('S018', 'StyleFirst', 'contact@stylefirst.com, +1-800-555-1818'),
('S019', 'ActiveGear', 'info@activegear.com, +1-800-555-1919'),
('S020', 'UrbanHome', 'sales@urbanhome.com, +1-800-555-2020');

INSERT INTO ProductSuppliers (product_id, supplier_id)
VALUES
-- Smartphone (P001) is supplied by TechGurus, GadgetPros, and ElectroHub
('P001', 'S001'),
('P001', 'S006'),
('P001', 'S011'),

-- Jeans (P002) is supplied by Fashionista Co. and StyleFirst
('P002', 'S002'),
('P002', 'S018'),

-- Cookbook (P003) is supplied by BooksWorld and MegaBooks
('P003', 'S005'),
('P003', 'S017'),

-- Blender (P004) is supplied by Home Essentials and KitchenPros
('P004', 'S003'),
('P004', 'S015'),

-- Laptop (P005) is supplied by TechGurus, BrightTech, and ElectroHub
('P005', 'S001'),
('P005', 'S009'),
('P005', 'S011'),

-- T-shirt (P006) is supplied by Fashionista Co., WearItWell, and StyleFirst
('P006', 'S002'),
('P006', 'S012'),
('P006', 'S018'),

-- Headphones (P007) is supplied by GadgetPros and ElectroHub
('P007', 'S006'),
('P007', 'S011'),

-- Sneakers (P008) is supplied by Sporty Gear, ActiveGear, and SportsEmpire
('P008', 'S007'),
('P008', 'S014'),
('P008', 'S019'),

-- Coffee Maker (P009) is supplied by Home Essentials and KitchenPros
('P009', 'S003'),
('P009', 'S015'),

-- Backpack (P010) is supplied by Fashionista Co. and UrbanHome
('P010', 'S002'),
('P010', 'S020'),

-- Tablet (P011) is supplied by BrightTech and ElectroHub
('P011', 'S009'),
('P011', 'S011'),

-- Dress (P012) is supplied by Fashionista Co. and StyleFirst
('P012', 'S002'),
('P012', 'S018'),

-- Novel (P013) is supplied by BooksWorld and MegaBooks
('P013', 'S005'),
('P013', 'S017'),

-- Microwave (P014) is supplied by Home Essentials, KitchenPros, and ApplianceMart
('P014', 'S003'),
('P014', 'S015'),
('P014', 'S013'),

-- Action Figure (P015) is supplied by GadgetPros and BrightTech
('P015', 'S006'),
('P015', 'S009'),

-- Basketball (P016) is supplied by Sporty Gear, ActiveGear, and FitLife Supplies
('P016', 'S007'),
('P016', 'S019'),
('P016', 'S004'),

-- Lipstick (P017) is supplied by Healthy Living and EcoEssentials
('P017', 'S010'),
('P017', 'S016'),

-- Yoga Mat (P018) is supplied by FitLife Supplies, ActiveGear, and SportsEmpire
('P018', 'S004'),
('P018', 'S019'),
('P018', 'S014'),

-- Car Charger (P019) is supplied by GadgetPros and BrightTech
('P019', 'S006'),
('P019', 'S009'),

-- Sofa (P020) is supplied by FurnishWell, UrbanHome, and EcoEssentials
('P020', 'S008'),
('P020', 'S020'),
('P020', 'S016'),

-- Keyboard (P021) is supplied by TechGurus, ElectroHub, and BrightTech
('P021', 'S001'),
('P021', 'S011'),
('P021', 'S009'),

-- Camera (P022) is supplied by BrightTech, ElectroHub, and TechGurus
('P022', 'S009'),
('P022', 'S011'),
('P022', 'S001');

INSERT INTO Shipping (shipping_id, order_id, address, city, postal_code, country, shipping_date)
VALUES
-- Shipping for Customer C001
('S001', 'O001', '123 Elm Street', 'New York', '10001', 'USA', '2024-07-02 10:00:00'),
('S002', 'O002', '456 Another St', 'Brooklyn', '11201', 'USA', '2024-07-16 12:00:00'),

-- Shipping for Customer C002
('S003', 'O003', '789 New Address Lane', 'Los Angeles', '90002', 'USA', '2024-07-11 14:00:00'),
('S004', 'O004', '456 Oak Avenue', 'Los Angeles', '90001', 'USA', '2024-07-01 16:00:00'),

-- Shipping for Customer C003
('S005', 'O005', '303 Different Blvd', 'Chicago', '60602', 'USA', '2024-07-13 09:00:00'),
('S006', 'O006', '789 Pine Road', 'Chicago', '60601', 'USA', '2024-07-21 11:00:00'),

-- Shipping for Customer C004
('S007', 'O007', '202 Temporary Lane', 'Houston', '77002', 'USA', '2024-07-19 15:00:00'),

-- Shipping for Customer C005
('S008', 'O008', '202 Birch Street', 'Phoenix', '85001', 'USA', '2024-07-02 08:00:00'),
('S009', 'O009', '808 Vacation Ave', 'Phoenix', '85003', 'USA', '2024-07-11 10:00:00'),

-- Shipping for Customer C006
('S010', 'O010', '909 Rental Road', 'Philadelphia', '19102', 'USA', '2024-07-13 13:00:00'),
('S011', 'O011', '303 Cedar Avenue', 'Philadelphia', '19101', 'USA', '2024-07-13 15:00:00'),

-- Shipping for Customer C007
('S012', 'O012', '404 Pine Street', 'San Antonio', '78201', 'USA', '2024-07-16 17:00:00'),

-- Shipping for Customer C008
('S013', 'O013', '121 Alternate Dr', 'San Diego', '92103', 'USA', '2024-07-19 10:00:00'),

-- Shipping for Customer C009
('S014', 'O014', '606 Maple Avenue', 'Dallas', '75201', 'USA', '2024-07-02 11:00:00'),
('S015', 'O015', '456 Work Blvd', 'Dallas', '75203', 'USA', '2024-07-11 12:00:00'),

-- Shipping for Customer C010
('S016', 'O016', '555 Vacation Street', 'San Jose', '95103', 'USA', '2024-07-13 14:00:00'),
('S017', 'O017', '707 Birch Lane', 'San Jose', '95101', 'USA', '2024-07-13 16:00:00'),

-- Shipping for Customer C011
('S018', 'O018', '303 Short Stay Lane', 'Austin', '73303', 'USA', '2024-07-16 18:00:00'),

-- Shipping for Customer C012
('S019', 'O019', '909 Pine Avenue', 'Fort Worth', '76101', 'USA', '2024-07-19 19:00:00'),

-- Shipping for Customer C013
('S020', 'O020', '121 Friend St', 'Columbus', '43086', 'USA', '2024-07-02 20:00:00'),
('S021', 'O021', '1010 Oak Street', 'Columbus', '43085', 'USA', '2024-07-11 21:00:00'),

-- Shipping for Customer C014
('S022', 'O022', '404 Family Blvd', 'Indianapolis', '46203', 'USA', '2024-07-13 22:00:00'),
('S023', 'O023', '1111 Maple Lane', 'Indianapolis', '46201', 'USA', '2024-07-13 23:00:00'),

-- Shipping for Customer C015
('S024', 'O024', '1212 Birch Avenue', 'Charlotte', '28201', 'USA', '2024-07-16 08:00:00'),

-- Shipping for Customer C016
('S025', 'O025', '141 Guest Ave', 'Seattle', '98103', 'USA', '2024-07-19 09:00:00'),

-- Shipping for Customer C017
('S026', 'O026', '1414 Pine Street', 'Denver', '80201', 'USA', '2024-07-02 10:00:00'),
('S027', 'O027', '999 Neighbor Rd', 'Denver', '80203', 'USA', '2024-07-11 11:00:00'),

-- Shipping for Customer C018
('S028', 'O028', '1515 Oak Avenue', 'Washington', '20001', 'USA', '2024-07-13 12:00:00'),
('S029', 'O029', '777 Retreat Blvd', 'Washington', '20003', 'USA', '2024-07-13 13:00:00'),

-- Shipping for Customer C019
('S030', 'O030', '1616 Maple Lane', 'Boston', '02101', 'USA', '2024-07-16 14:00:00'),

-- Shipping for Customer C020
('S031', 'O031', '202 Home Rd', 'Nashville', '37203', 'USA', '2024-07-19 15:00:00');

INSERT INTO OrderItems (order_item_id, order_id, product_id, quantity, price)
VALUES
-- Order O001 (Customer C001)
('OI001', 'O001', 'P001', 1, 699.99), -- Smartphone
('OI002', 'O001', 'P005', 1, 999.99), -- Laptop

-- Order O002 (Customer C001)
('OI003', 'O002', 'P007', 2, 199.99), -- Headphones
('OI004', 'O002', 'P008', 1, 79.99),  -- Sneakers

-- Order O003 (Customer C002)
('OI005', 'O003', 'P012', 1, 89.99),  -- Dress
('OI006', 'O003', 'P017', 3, 19.99),  -- Lipstick

-- Order O004 (Customer C002)
('OI007', 'O004', 'P018', 2, 39.99),  -- Yoga Mat

-- Order O005 (Customer C003)
('OI008', 'O005', 'P009', 1, 129.99), -- Coffee Maker
('OI009', 'O005', 'P022', 1, 499.99), -- Camera

-- Order O006 (Customer C003)
('OI010', 'O006', 'P003', 2, 19.99),  -- Cookbook

-- Order O007 (Customer C004)
('OI011', 'O007', 'P021', 1, 99.99),  -- Keyboard
('OI012', 'O007', 'P014', 1, 149.99), -- Microwave

-- Order O008 (Customer C005)
('OI013', 'O008', 'P013', 1, 24.99),  -- Novel
('OI014', 'O008', 'P010', 1, 59.99),  -- Backpack

-- Order O009 (Customer C005)
('OI015', 'O009', 'P019', 2, 14.99),  -- Car Charger

-- Order O010 (Customer C006)
('OI016', 'O010', 'P004', 1, 89.99),  -- Blender
('OI017', 'O010', 'P002', 3, 49.99),  -- Jeans

-- Order O011 (Customer C006)
('OI018', 'O011', 'P016', 2, 29.99),  -- Basketball

-- Order O012 (Customer C007)
('OI019', 'O012', 'P020', 1, 499.99), -- Sofa

-- Order O013 (Customer C008)
('OI020', 'O013', 'P001', 1, 699.99), -- Smartphone
('OI021', 'O013', 'P011', 1, 299.99), -- Tablet

-- Order O014 (Customer C009)
('OI022', 'O014', 'P015', 2, 29.99),  -- Action Figure
('OI023', 'O014', 'P020', 1, 499.99), -- Sofa

-- Order O015 (Customer C009)
('OI024', 'O015', 'P006', 1, 14.99), -- T-shirt
('OI025', 'O015', 'P012', 1, 89.99), -- Dress

-- Order O016 (Customer C010)
('OI026', 'O016', 'P022', 1, 49.99), -- Camera
('OI027', 'O016', 'P008', 2, 79.99), -- Sneakers

-- Order O017 (Customer C010)
('OI028', 'O017', 'P021', 1, 99.99), -- Keyboard

-- Order O018 (Customer C011)
('OI029', 'O018', 'P001', 1, 699.99), -- Smartphone
('OI030', 'O018', 'P007', 2, 199.99), -- Headphones

-- Order O019 (Customer C012)
('OI031', 'O019', 'P017', 1, 19.99), -- Lipstick
('OI032', 'O019', 'P016', 2, 29.99), -- Basketball

-- Order O020 (Customer C013)
('OI033', 'O020', 'P003', 3, 19.99), -- Cookbook
('OI034', 'O020', 'P009', 1, 129.99), -- Coffee Maker

-- Order O021 (Customer C013)
('OI035', 'O021', 'P002', 2, 49.99), -- Jeans
('OI036', 'O021', 'P010', 1, 59.99), -- Backpack

-- Order O022 (Customer C014)
('OI037', 'O022', 'P006', 1, 14.99), -- T-shirt
('OI038', 'O022', 'P005', 1, 999.99), -- Laptop

-- Order O023 (Customer C014)
('OI039', 'O023', 'P012', 1, 89.99), -- Dress
('OI040', 'O023', 'P019', 2, 14.99), -- Car Charger

-- Order O024 (Customer C015)
('OI041', 'O024', 'P001', 1, 699.99), -- Smartphone
('OI042', 'O024', 'P007', 1, 199.99), -- Headphones

-- Order O025 (Customer C016)
('OI043', 'O025', 'P018', 2, 39.99), -- Yoga Mat

-- Order O026 (Customer C017)
('OI044', 'O026', 'P015', 1, 29.99), -- Action Figure
('OI045', 'O026', 'P008', 2, 79.99), -- Sneakers

-- Order O027 (Customer C017)
('OI046', 'O027', 'P020', 1, 499.99), -- Sofa
('OI047', 'O027', 'P013', 1, 24.99), -- Novel

-- Order O028 (Customer C018)
('OI048', 'O028', 'P017', 2, 19.99), -- Lipstick
('OI049', 'O028', 'P009', 1, 129.99), -- Coffee Maker

-- Order O029 (Customer C018)
('OI050', 'O029', 'P022', 1, 499.99), -- Camera

-- Order O030 (Customer C019)
('OI051', 'O030', 'P010', 1, 59.99), -- Backpack
('OI052', 'O030', 'P014', 1, 149.99), -- Microwave

-- Order O031 (Customer C020)
('OI053', 'O031', 'P004', 1, 89.99), -- Blender
('OI054', 'O031', 'P021', 1, 99.99); -- Keyboard

SELECT 
    order_id,
    SUM(quantity * price) AS total_amount
FROM 
    OrderItems
GROUP BY 
    order_id;

ALTER TABLE Orders ADD total_amount DECIMAL(10, 2) DEFAULT 0;

SET SQL_SAFE_UPDATES = 0;

UPDATE Orders o
SET total_amount = (
    SELECT SUM(oi.quantity * oi.price)
    FROM OrderItems oi
    WHERE oi.order_id = o.order_id
    GROUP BY oi.order_id
);


select *from orders

DELIMITER $$
CREATE TRIGGER check_order_item_price
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10, 2);
    
    -- Retrieve the product price from the Products table
    SELECT price INTO product_price
    FROM Products
    WHERE product_id = NEW.product_id;
    
    -- Check if the price matches
    IF product_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product ID does not exist in Products table';
    ELSEIF product_price != NEW.price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price in OrderItems does not match Products table';
    END IF;
END$$

DELIMITER ;


select * from orders;

INSERT INTO Payments (payment_id, order_id, customer_id, total_amount, payment_status, payment_date, cc_flag, gc_flag)
VALUES
-- Orders for Customer C001
('PAY001', 'O001', 'C001', 1699.98, 'Completed', '2024-07-01 13:00:00', TRUE, FALSE),
('PAY002', 'O002', 'C001', 479.97, 'Completed', '2024-07-15 10:00:00', TRUE, FALSE),

-- Orders for Customer C002
('PAY003', 'O003', 'C002', 149.96, 'Completed', '2024-07-10 09:00:00', FALSE, TRUE),
('PAY004', 'O004', 'C002', 79.98, 'Completed', '2024-06-30 12:00:00', TRUE, FALSE),

-- Orders for Customer C003
('PAY005', 'O005', 'C003', 629.98, 'Completed', '2024-07-12 15:00:00', TRUE, TRUE), -- Split payment 1
('PAY006', 'O006', 'C003', 39.98, 'Completed', '2024-07-20 17:30:00', TRUE, FALSE),

-- Orders for Customer C004
('PAY007', 'O007', 'C004', 249.98, 'Completed', '2024-07-18 11:00:00', FALSE, TRUE),

-- Orders for Customer C005
('PAY008', 'O008', 'C005', 84.98, 'Completed', '2024-07-01 14:00:00', TRUE, FALSE),
('PAY009', 'O009', 'C005', 29.98, 'Completed', '2024-07-10 09:30:00', FALSE, TRUE),

-- Orders for Customer C006
('PAY010', 'O010', 'C006', 239.96, 'Completed', '2024-07-12 15:30:00', TRUE, FALSE),
('PAY011', 'O011', 'C006', 59.98, 'Completed', '2024-07-12 15:45:00', TRUE, FALSE),

-- Orders for Customer C007
('PAY012', 'O012', 'C007', 499.99, 'Completed', '2024-07-15 10:30:00', TRUE, TRUE), -- Split payment 2

-- Orders for Customer C008
('PAY013', 'O013', 'C008', 999.98, 'Completed', '2024-07-18 11:30:00', FALSE, TRUE),

-- Orders for Customer C009
('PAY014', 'O014', 'C009', 559.97, 'Completed', '2024-07-01 14:30:00', TRUE, FALSE),
('PAY015', 'O015', 'C009', 104.98, 'Completed', '2024-07-10 10:00:00', TRUE, FALSE),

-- Orders for Customer C010
('PAY016', 'O016', 'C010', 209.97, 'Completed', '2024-07-12 16:00:00', TRUE, TRUE), -- Split payment 3
('PAY017', 'O017', 'C010', 99.99, 'Completed', '2024-07-12 16:30:00', FALSE, TRUE),

-- Orders for Customer C011
('PAY018', 'O018', 'C011', 1099.97, 'Completed', '2024-07-15 11:00:00', TRUE, TRUE), -- Split payment 4

-- Orders for Customer C012
('PAY019', 'O019', 'C012', 79.97, 'Completed', '2024-07-18 12:00:00', FALSE, TRUE),

-- Orders for Customer C013
('PAY020', 'O020', 'C013', 189.96, 'Completed', '2024-07-01 15:00:00', TRUE, FALSE),
('PAY021', 'O021', 'C013', 159.97, 'Completed', '2024-07-10 10:30:00', TRUE, FALSE),

-- Orders for Customer C014
('PAY022', 'O022', 'C014', 1014.98, 'Completed', '2024-07-12 17:00:00', TRUE, TRUE), -- Split payment 5
('PAY023', 'O023', 'C014', 119.97, 'Pending', '2024-07-12 17:30:00', TRUE, FALSE), -- Processing

-- Orders for Customer C015
('PAY024', 'O024', 'C015', 899.98, 'Completed', '2024-07-15 12:00:00', TRUE, FALSE),

-- Orders for Customer C016
('PAY025', 'O025', 'C016', 79.98, 'Completed', '2024-07-18 12:30:00', FALSE, TRUE),

-- Orders for Customer C017
('PAY026', 'O026', 'C017', 189.97, 'Completed', '2024-07-01 16:00:00', TRUE, FALSE),
('PAY027', 'O027', 'C017', 524.98, 'Completed', '2024-07-10 11:00:00', FALSE, TRUE),

-- Orders for Customer C018
('PAY028', 'O028', 'C018', 169.97, 'Completed', '2024-07-12 18:00:00', TRUE, FALSE),
('PAY029', 'O029', 'C018', 499.99, 'Completed', '2024-07-12 18:30:00', FALSE, TRUE),

-- Orders for Customer C019
('PAY030', 'O030', 'C019', 209.98, 'Completed', '2024-07-15 13:00:00', TRUE, FALSE),

-- Orders for Customer C020
('PAY031', 'O031', 'C020', 189.98, 'Pending', '2024-07-18 13:30:00', TRUE, FALSE); -- Processing

DELIMITER $$

CREATE TRIGGER check_total_payment
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10, 2);

    -- Fetch the total amount for the associated order
    SELECT total_amount INTO order_total
    FROM Orders
    WHERE order_id = NEW.order_id;

    -- Check if the payment total matches the order total
    IF NEW.total_amount != order_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total payment amount must match the total amount of the order';
    END IF;
END$$

DELIMITER ;



INSERT INTO Reviews (review_id, product_id, customer_id, rating, comment, review_date)
VALUES
-- Reviews for Customer C001
('R001', 'P001', 'C001', 5, 'The smartphone is excellent and very user-friendly.', '2024-08-01 12:00:00'), -- Order O001
('R002', 'P007', 'C001', 2, 'The headphones are uncomfortable for long use.', '2024-08-15 09:00:00'), -- Order O002

-- Reviews for Customer C002
('R003', 'P012', 'C002', 4, 'The dress is elegant and fits well.', '2024-08-10 08:00:00'), -- Order O003
('R004', 'P018', 'C002', 2, 'The yoga mat gets slippery after some use.', '2024-07-30 11:45:00'), -- Order O004

-- Reviews for Customer C003
('R005', 'P009', 'C003', 5, 'The coffee maker works perfectly. Highly recommend!', '2024-08-12 14:15:00'), -- Order O005
('R006', 'P003', 'C003', 3, 'The cookbook has some nice recipes, but not enough variety.', '2024-08-20 16:45:00'), -- Order O006

-- Reviews for Customer C004
('R007', 'P021', 'C004', 4, 'The keyboard is smooth and responsive.', '2024-08-18 10:30:00'), -- Order O007

-- Reviews for Customer C005
('R008', 'P013', 'C005', 4, 'The novel was a gripping read!', '2024-08-01 12:00:00'), -- Order O008
('R009', 'P019', 'C005', 1, 'The car charger stopped working after a week.', '2024-08-10 08:00:00'), -- Order O009

-- Reviews for Customer C006
('R010', 'P004', 'C006', 5, 'The blender works great for smoothies.', '2024-08-12 14:15:00'), -- Order O010
('R011', 'P016', 'C006', 2, 'The basketball lost air quickly.', '2024-08-12 14:15:00'), -- Order O011

-- Reviews for Customer C007
('R012', 'P020', 'C007', 5, 'The sofa is very comfortable and looks amazing.', '2024-08-15 09:00:00'), -- Order O012

-- Reviews for Customer C008
('R013', 'P001', 'C008', 5, 'The smartphone is fantastic. Very user-friendly.', '2024-08-18 10:30:00'), -- Order O013

-- Reviews for Customer C009
('R014', 'P015', 'C009', 4, 'The action figures are detailed and well-crafted.', '2024-08-01 12:00:00'), -- Order O014

-- Reviews for Customer C010
('R015', 'P022', 'C010', 5, 'The camera is excellent for both photos and videos.', '2024-08-12 14:15:00'), -- Order O016
('R016', 'P021', 'C010', 3, 'The keyboard is decent, but the keys feel sticky sometimes.', '2024-08-12 14:15:00'), -- Order O017

-- Reviews for Customer C011
('R017', 'P001', 'C011', 5, 'The smartphone is very fast and reliable.', '2024-08-15 09:00:00'), -- Order O018

-- Reviews for Customer C012
('R018', 'P017', 'C012', 4, 'The lipstick is vibrant and lasts long.', '2024-08-18 10:30:00'), -- Order O019

-- Reviews for Customer C013
('R019', 'P003', 'C013', 3, 'The cookbook is nice but lacks innovative recipes.', '2024-08-01 12:00:00'), -- Order O020

-- Reviews for Customer C014
('R020', 'P006', 'C014', 4, 'The t-shirt is comfortable and fits perfectly.', '2024-08-12 14:15:00'), -- Order O022
('R021', 'P012', 'C014', 5, 'The dress is stylish and fits perfectly.', '2024-08-12 14:15:00'), -- Order O023

-- Reviews for Customer C015
('R022', 'P001', 'C015', 5, 'The smartphone exceeded my expectations.', '2024-08-15 09:00:00'), -- Order O024

-- Reviews for Customer C016
('R023', 'P018', 'C016', 5, 'The yoga mat is very comfortable and non-slip.', '2024-08-18 10:30:00'), -- Order O025

-- Reviews for Customer C017
('R024', 'P008', 'C017', 3, 'The sneakers are okay, but the sole wore out quickly.', '2024-08-01 12:00:00'), -- Order O026

-- Reviews for Customer C018
('R025', 'P009', 'C018', 2, 'The coffee maker stopped working after a month.', '2024-08-12 14:15:00'); -- Order O028

select * from orderitems;



INSERT INTO CreditCardPayments (credit_card_payment_id, payment_id, card_number, card_holder_name, expiry_date)
VALUES
('CCPAY001', 'PAY001', '4111111111111111', 'John Doe', '2025-07-01'),
('CCPAY002', 'PAY002', '4111111111111111', 'John Doe', '2025-07-01'),
('CCPAY003', 'PAY004', '4111111111111113', 'Jane Smith', '2025-06-30'),
('CCPAY004', 'PAY005', '4111111111111114', 'Alice Johnson', '2025-07-12'),
('CCPAY005', 'PAY006', '4111111111111114', 'Alice Johnson', '2025-07-20'),
('CCPAY006', 'PAY008', '4111111111111116', 'Michael Williams', '2025-07-01'),
('CCPAY007', 'PAY010', '4111111111111117', 'Emily Jones', '2025-07-12'),
('CCPAY008', 'PAY011', '4111111111111117', 'Emily Jones', '2025-07-12'),
('CCPAY009', 'PAY012', '4111111111111119', 'David Miller', '2025-07-15'),
('CCPAY010', 'PAY014', '4111111111111120', 'James Garcia', '2025-07-01'),
('CCPAY011', 'PAY015', '4111111111111120', 'James Garcia', '2025-07-10'),
('CCPAY012', 'PAY016', '4111111111111122', 'Laura Martinez', '2025-07-12'),
('CCPAY013', 'PAY018', '4111111111111123', 'Robert Rodriguez', '2025-07-15'),
('CCPAY014', 'PAY020', '4111111111111125', 'William Hernandez', '2025-07-01'),
('CCPAY015', 'PAY021', '4111111111111125', 'William Hernandez', '2025-07-10'),
('CCPAY016', 'PAY022', '4111111111111126', 'Barbara Lopez', '2025-07-12'),
('CCPAY017', 'PAY023', '4111111111111126', 'Barbara Lopez', '2025-07-12'),
('CCPAY018', 'PAY024', '4111111111111128', 'Richard Gonzalez', '2025-07-15'),
('CCPAY019', 'PAY026', '4111111111111129', 'Joseph Anderson', '2025-07-01'),
('CCPAY020', 'PAY028', '4111111111111130', 'Jessica Thomas', '2025-07-12'),
('CCPAY021', 'PAY030', '4111111111111131', 'Charles Taylor', '2025-07-15'),
('CCPAY022', 'PAY031', '4111111111111132', 'Karen Moore', '2025-07-18');

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.order_id,
    p.payment_id
FROM 
    Customers c
JOIN 
    Payments p ON c.customer_id = p.customer_id;
    
INSERT INTO GiftCardPayments (gift_card_payment_id, payment_id, gift_card_code)
VALUES
('GCPAY001', 'PAY003', 'GC1234567890'),
('GCPAY002', 'PAY005', 'GC1234567891'),
('GCPAY003', 'PAY007', 'GC1234567892'),
('GCPAY004', 'PAY009', 'GC1234567893'),
('GCPAY005', 'PAY012', 'GC1234567894'),
('GCPAY006', 'PAY013', 'GC1234567895'),
('GCPAY007', 'PAY016', 'GC1234567896'),
('GCPAY008', 'PAY017', 'GC1234567903'),
('GCPAY009', 'PAY018', 'GC1234567897'),
('GCPAY010', 'PAY019', 'GC1234567902'),
('GCPAY011', 'PAY022', 'GC1234567904'),
('GCPAY012', 'PAY025', 'GC1234567898'),
('GCPAY013', 'PAY027', 'GC1234567899'),
('GCPAY014', 'PAY029', 'GC1234567900');

DELIMITER $$

CREATE TRIGGER check_cc_flag_before_insert
BEFORE INSERT ON CreditCardPayments
FOR EACH ROW
BEGIN
    DECLARE cc_flag_value BOOLEAN;
    
    -- Fetch the cc_flag value from the Payments table for the corresponding payment_id
    SELECT cc_flag INTO cc_flag_value
    FROM Payments
    WHERE payment_id = NEW.payment_id;
    
    -- Check if cc_flag is TRUE
    IF cc_flag_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment cannot be processed as Credit Card payment. cc_flag is FALSE.';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_gc_flag_before_insert
BEFORE INSERT ON GiftCardPayments
FOR EACH ROW
BEGIN
    DECLARE gc_flag_value BOOLEAN;
    
    -- Fetch the gc_flag value from the Payments table for the corresponding payment_id
    SELECT gc_flag INTO gc_flag_value
    FROM Payments
    WHERE payment_id = NEW.payment_id;
    
    -- Check if gc_flag is TRUE
    IF gc_flag_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment cannot be processed as Gift Card payment. gc_flag is FALSE.';
    END IF;
END $$

DELIMITER ;

select *from payments;

-- Orders for Customer C001
-- Payment ID: PAY001
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD001', 'PAY001', 1699.98, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY002
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD002', 'PAY002', 479.97, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C002
-- Payment ID: PAY003
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD003', 'PAY003', 149.96, 'Gift Card');  -- Full payment via Gift Card

-- Payment ID: PAY004
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD004', 'PAY004', 79.98, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C003
-- Payment ID: PAY005 (Split payment 1)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD005', 'PAY005', 310.99, 'Credit Card'),  -- First part of split payment via Credit Card
('PD006', 'PAY005', 318.99, 'Gift Card');    -- Second part of split payment via Gift Card

-- Payment ID: PAY006
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD007', 'PAY006', 39.98, 'Credit Card');   -- Full payment via Credit Card

-- Orders for Customer C004
-- Payment ID: PAY007
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD008', 'PAY007', 249.98, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C005
-- Payment ID: PAY008
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD009', 'PAY008', 84.98, 'Credit Card');   -- Full payment via Credit Card

-- Payment ID: PAY009
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD010', 'PAY009', 29.98, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C006
-- Payment ID: PAY010
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD011', 'PAY010', 239.96, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY011
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD012', 'PAY011', 59.98, 'Credit Card');   -- Full payment via Credit Card

-- Orders for Customer C007
-- Payment ID: PAY012 (Split payment 2)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD013', 'PAY012', 249.99, 'Credit Card'),  -- First part of split payment via Credit Card
('PD014', 'PAY012', 249.99, 'Gift Card');    -- Second part of split payment via Gift Card

-- Orders for Customer C008
-- Payment ID: PAY013
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD015', 'PAY013', 999.98, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C009
-- Payment ID: PAY014
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD016', 'PAY014', 559.97, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY015
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD017', 'PAY015', 104.98, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C010
-- Payment ID: PAY016 (Split payment 3)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD018', 'PAY016', 104.98, 'Credit Card'),  -- First part of split payment via Credit Card
('PD019', 'PAY016', 104.99, 'Gift Card');    -- Second part of split payment via Gift Card

-- Payment ID: PAY017
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD020', 'PAY017', 99.99, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C011
-- Payment ID: PAY018 (Split payment 4)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD021', 'PAY018', 549.99, 'Credit Card'),  -- First part of split payment via Credit Card
('PD022', 'PAY018', 549.98, 'Gift Card');    -- Second part of split payment via Gift Card

-- Orders for Customer C012
-- Payment ID: PAY019
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD023', 'PAY019', 79.97, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C013
-- Payment ID: PAY020
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD024', 'PAY020', 189.96, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY021
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD025', 'PAY021', 159.97, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C014
-- Payment ID: PAY022 (Split payment 5)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD026', 'PAY022', 507.49, 'Credit Card'),  -- First part of split payment via Credit Card
('PD027', 'PAY022', 507.49, 'Gift Card');    -- Second part of split payment via Gift Card

INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD038', 'PAY023', 119.97, 'Credit Card');

-- Orders for Customer C015
-- Payment ID: PAY024
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD028', 'PAY024', 899.98, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C016
-- Payment ID: PAY025
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD029', 'PAY025', 79.98, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C017
-- Payment ID: PAY026
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD030', 'PAY026', 189.97, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY027
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD031', 'PAY027', 524.98, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C018
-- Payment ID: PAY028
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD032', 'PAY028', 169.97, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY029
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD033', 'PAY029', 499.99, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C019
-- Payment ID: PAY030
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD034', 'PAY030', 209.98, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C020
-- Payment ID: PAY031
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD035', 'PAY031', 189.98, 'Credit Card');  -- Full payment via Credit Card

select * from paymentdetails

DELIMITER //

CREATE TRIGGER validate_payment_amounts
BEFORE INSERT ON PaymentDetails
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10, 2);
    DECLARE payment_total DECIMAL(10, 2);

    -- Get the total amount paid by both credit card and gift card for the payment
    SELECT SUM(amount) INTO total_paid
    FROM PaymentDetails
    WHERE payment_id = NEW.payment_id;

    -- Get the total amount from the Payments table
    SELECT total_amount INTO payment_total
    FROM Payments
    WHERE payment_id = NEW.payment_id;

    -- Compare the total amount paid with the total amount in the Payments table
    IF total_paid > payment_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total payment amount exceeds the order total amount.';
    END IF;
    
    IF total_paid < payment_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total payment amount is less than the order total amount.';
    END IF;

END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER update_stock_on_purchase
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    -- Decrease the stock by the quantity ordered
    UPDATE Products
    SET units_in_stock = units_in_stock - NEW.quantity
    WHERE product_id = NEW.product_id;
    
    -- Optional: Add condition to ensure stock cannot be negative
    IF (SELECT units_in_stock FROM Products WHERE product_id = NEW.product_id) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock for this product.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER update_stock_on_supply
AFTER INSERT ON ProductSuppliers
FOR EACH ROW
BEGIN
    -- Increase the stock when a product is supplied
    UPDATE Products
    SET units_in_stock = units_in_stock + 1  -- Adjust the quantity as needed
    WHERE product_id = NEW.product_id;
END//

DELIMITER ;

-- Srinivas Ganisetti 
-- SQL query 1 (Retrieve detailed information about customer orders, including customer names, order IDs, product details, quantities, and prices, while ensuring the results are ordered by customer ID, order ID, and product ID)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    oi.product_id,
    p.name AS product_name,
    oi.quantity,
    oi.price
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
JOIN 
    OrderItems oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
ORDER BY 
    c.customer_id, o.order_id, oi.product_id;
    
-- Srinivas Ganisetti
-- SQL query 2 ( query to give summary information about the total sales, average order value, and the number of orders for each customer

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_sales,
    AVG(o.total_amount) AS average_order_value
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_sales DESC;

-- Srinivas Ganisetti
-- SQL query 3 (Retrieve the top 5 products by total sales amount, including the total quantity sold and the total revenue generated.)
SELECT 
    p.product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM 
    OrderItems oi
JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_id, p.name
ORDER BY 
    total_revenue DESC
LIMIT 5;

-- Srinivas Ganisetti
-- SQL query 4 (Retrieve orders that have both credit card and gift card payments and how much they paid through each payment method)
SELECT 
    o.order_id,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.total_amount,
    p.payment_id,
    p.payment_status,
    p.payment_date,
    (SELECT SUM(pd.amount) 
     FROM PaymentDetails pd 
     WHERE pd.payment_id = p.payment_id AND pd.payment_type = 'Credit Card') AS credit_card_amount,
    (SELECT SUM(pd.amount) 
     FROM PaymentDetails pd 
     WHERE pd.payment_id = p.payment_id AND pd.payment_type = 'Gift Card') AS gift_card_amount
FROM 
    Orders o
JOIN 
    Customers c ON o.customer_id = c.customer_id
JOIN 
    Payments p ON o.order_id = p.order_id
JOIN 
    CreditCardPayments ccp ON p.payment_id = ccp.payment_id
JOIN 
    GiftCardPayments gcp ON p.payment_id = gcp.payment_id
WHERE 
    p.cc_flag = TRUE AND p.gc_flag = TRUE;


