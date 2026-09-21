CREATE DATABASE ecommerce_order_management;

USE ecommerce_order_management;

CREATE TABLE customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone         VARCHAR(15)  UNIQUE,
    email         VARCHAR(100) UNIQUE,
    address       VARCHAR(200)
);

INSERT INTO customers (customer_name, phone, email, address) VALUES
('Arun Kumar',      '9876543210', 'arun.kumar@gmail.com',      'Chennai, Tamil Nadu'),
('Priya Sharma',    '9876543211', 'priya.sharma@gmail.com',    'Bengaluru, Karnataka'),
('Rahul Verma',     '9876543212', 'rahul.verma@gmail.com',     'Delhi, NCR'),
('Sneha Reddy',     '9876543213', 'sneha.reddy@gmail.com',     'Hyderabad, Telangana'),
('Vikram Singh',    '9876543214', 'vikram.singh@gmail.com',    'Mumbai, Maharashtra'),
('Anjali Gupta',    '9876543215', 'anjali.gupta@gmail.com',    'Pune, Maharashtra'),
('Karthik Raja',    '9876543216', 'karthik.raja@gmail.com',    'Coimbatore, Tamil Nadu'),
('Divya Nair',      '9876543217', 'divya.nair@gmail.com',      'Kochi, Kerala'),
('Suresh Babu',     '9876543218', 'suresh.babu@gmail.com',     'Vijayawada, Andhra Pradesh'),
('Meena Iyer',      '9876543219', 'meena.iyer@gmail.com',      'Trichy, Tamil Nadu');

SELECT * FROM customers;

-- Basic concepts & operations on customers
SELECT customer_name, email FROM customers;                       -- Column selection
SELECT * FROM customers WHERE address LIKE '%Tamil Nadu%';        -- LIKE operator
SELECT * FROM customers ORDER BY customer_name ASC;                -- ORDER BY
SELECT * FROM customers LIMIT 5;                                   -- LIMIT
SELECT * FROM customers WHERE customer_id BETWEEN 1 AND 5;         -- BETWEEN
SELECT DISTINCT address FROM customers;                             -- DISTINCT
SELECT * FROM customers WHERE customer_id IN (1,3,5,7);            -- IN
SELECT COUNT(*) AS total_customers FROM customers;                  -- COUNT

CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description   VARCHAR(200)
);

INSERT INTO categories (category_name, description) VALUES
('Electronics',        'Mobiles, laptops, gadgets and accessories'),
('Fashion',             'Men and women clothing, footwear'),
('Home & Kitchen',      'Furniture, kitchenware and home decor'),
('Books',               'Fiction, non-fiction and academic books'),
('Beauty & Personal Care','Cosmetics, skincare and grooming products'),
('Sports & Fitness',    'Sportswear, gym and fitness equipment'),
('Toys & Games',        'Kids toys, board games and puzzles'),
('Groceries',           'Daily essentials and food items'),
('Automotive',          'Car and bike accessories'),
('Stationery',          'Office and school supplies');

SELECT * FROM categories;

-- Basic concepts & operations on categories
SELECT * FROM categories WHERE category_name LIKE 'B%';
SELECT * FROM categories ORDER BY category_name DESC;
SELECT category_name FROM categories WHERE description LIKE '%kids%' OR description LIKE '%Kids%';
SELECT COUNT(*) AS total_categories FROM categories;

CREATE TABLE products (
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    category_id    INT NOT NULL,
    product_name   VARCHAR(100) NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    product_status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO products (category_id, product_name, price, stock_quantity, product_status) VALUES
(1, 'Samsung Galaxy M14',        14999.00, 50,  'Active'),
(1, 'Dell Inspiron Laptop',      52999.00, 20,  'Active'),
(2, 'Men Cotton T-Shirt',          599.00, 200, 'Active'),
(2, 'Women Kurti',                 899.00, 150, 'Active'),
(3, 'Non-Stick Cookware Set',     1999.00, 40,  'Active'),
(4, 'Atomic Habits Book',          399.00, 100, 'Active'),
(5, 'Face Wash Combo Pack',        499.00, 80,  'Active'),
(6, 'Yoga Mat',                    699.00, 60,  'Active'),
(7, 'Remote Control Car',         1299.00, 30,  'Active'),
(9, 'Car Phone Holder',            349.00, 90,  'Active');

SELECT * FROM products;

-- Basic concepts & operations on products
SELECT * FROM products WHERE price > 1000;
SELECT * FROM products WHERE stock_quantity < 50 ORDER BY stock_quantity ASC;
SELECT product_name, price FROM products WHERE product_status = 'Active';
SELECT MAX(price) AS costliest_product, MIN(price) AS cheapest_product FROM products;
SELECT * FROM products WHERE product_name LIKE '%Book%';

CREATE TABLE orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Placed',
    total_amount DECIMAL(10,2) DEFAULT 0,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO orders (customer_id, order_date, order_status, total_amount) VALUES
(1, '2026-01-05', 'Delivered',  15598.00),
(2, '2026-01-08', 'Delivered',    899.00),
(3, '2026-01-10', 'Cancelled',  52999.00),
(4, '2026-01-12', 'Delivered',   1999.00),
(5, '2026-01-15', 'Shipped',      399.00),
(6, '2026-01-18', 'Delivered',   1198.00),
(7, '2026-01-20', 'Returned',     699.00),
(8, '2026-01-22', 'Delivered',   1299.00),
(9, '2026-01-25', 'Placed',       349.00),
(10,'2026-01-28', 'Delivered',   1497.00);

SELECT * FROM orders;

-- Basic concepts & operations on orders
SELECT * FROM orders WHERE order_status = 'Delivered';
SELECT * FROM orders WHERE total_amount > 1000 ORDER BY total_amount DESC;
SELECT * FROM orders WHERE order_date BETWEEN '2026-01-01' AND '2026-01-15';
SELECT order_status, COUNT(*) AS status_count FROM orders GROUP BY order_status;

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL,
    price         DECIMAL(10,2) NOT NULL,
    subtotal      DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orderitems_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orderitems_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES
(1, 1, 1, 14999.00, 14999.00),
(1, 3, 1,   599.00,   599.00),
(2, 4, 1,   899.00,   899.00),
(3, 2, 1, 52999.00, 52999.00),
(4, 5, 1,  1999.00,  1999.00),
(5, 6, 1,   399.00,   399.00),
(6, 3, 2,   599.00,  1198.00),
(7, 8, 1,   699.00,   699.00),
(8, 9, 1,  1299.00,  1299.00),
(9, 10,1,   349.00,   349.00);

SELECT * FROM order_items;

-- Basic concepts & operations on order_items
SELECT * FROM order_items WHERE quantity > 1;
SELECT product_id, SUM(quantity) AS total_units_sold FROM order_items GROUP BY product_id;
SELECT * FROM order_items ORDER BY subtotal DESC;

CREATE TABLE payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date   DATE NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO payments (order_id, payment_method, payment_amount, payment_date, payment_status) VALUES
(1,  'UPI',          15598.00, '2026-01-05', 'Success'),
(2,  'Credit Card',    899.00, '2026-01-08', 'Success'),
(3,  'Net Banking',  52999.00, '2026-01-10', 'Refunded'),
(4,  'UPI',           1999.00, '2026-01-12', 'Success'),
(5,  'Debit Card',     399.00, '2026-01-15', 'Success'),
(6,  'UPI',           1198.00, '2026-01-18', 'Success'),
(7,  'Wallet',         699.00, '2026-01-20', 'Refunded'),
(8,  'Credit Card',   1299.00, '2026-01-22', 'Success'),
(9,  'Cash on Delivery', 349.00,'2026-01-25','Pending'),
(10, 'UPI',           1497.00, '2026-01-28', 'Success');

SELECT * FROM payments;

-- Basic concepts & operations on payments
SELECT * FROM payments WHERE payment_status = 'Success';
SELECT payment_method, COUNT(*) AS usage_count FROM payments GROUP BY payment_method;
SELECT SUM(payment_amount) AS total_collected FROM payments WHERE payment_status = 'Success';

CREATE TABLE deliveries (
    delivery_id      INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT NOT NULL,
    delivery_address VARCHAR(200) NOT NULL,
    delivery_date    DATE,
    delivery_status  VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT fk_deliveries_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO deliveries (order_id, delivery_address, delivery_date, delivery_status) VALUES
(1,  'Chennai, Tamil Nadu',      '2026-01-08', 'Delivered'),
(2,  'Bengaluru, Karnataka',     '2026-01-11', 'Delivered'),
(3,  'Delhi, NCR',               NULL,         'Cancelled'),
(4,  'Hyderabad, Telangana',     '2026-01-15', 'Delivered'),
(5,  'Mumbai, Maharashtra',      NULL,         'In Transit'),
(6,  'Pune, Maharashtra',        '2026-01-21', 'Delivered'),
(7,  'Coimbatore, Tamil Nadu',   '2026-01-23', 'Returned'),
(8,  'Kochi, Kerala',            '2026-01-25', 'Delivered'),
(9,  'Vijayawada, Andhra Pradesh',NULL,        'Pending'),
(10, 'Trichy, Tamil Nadu',       '2026-01-31', 'Delivered');

SELECT * FROM deliveries;

-- Basic concepts & operations on deliveries
SELECT * FROM deliveries WHERE delivery_status = 'Delivered';
SELECT * FROM deliveries WHERE delivery_date IS NULL;      -- IS NULL
SELECT * FROM deliveries WHERE delivery_date IS NOT NULL;  -- IS NOT NULL

CREATE TABLE cancellations (
    cancellation_id  INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT NOT NULL,
    cancellation_date DATE NOT NULL,
    reason           VARCHAR(200),
    CONSTRAINT fk_cancellations_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO cancellations (order_id, cancellation_date, reason) VALUES
(3, '2026-01-11', 'Customer changed mind'),
(3, '2026-01-11', 'Duplicate order placed'),
(5, '2026-01-16', 'Delivery delay'),
(5, '2026-01-16', 'Found cheaper alternative'),
(7, '2026-01-21', 'Product not required'),
(7, '2026-01-21', 'Wrong address entered'),
(9, '2026-01-26', 'Payment failure'),
(9, '2026-01-26', 'Ordered by mistake'),
(2, '2026-01-09', 'Long delivery time'),
(4, '2026-01-13', 'Better price found elsewhere');

SELECT * FROM cancellations;

-- Basic concepts & operations on cancellations
SELECT * FROM cancellations WHERE reason LIKE '%mistake%';
SELECT order_id, COUNT(*) AS cancel_attempts FROM cancellations GROUP BY order_id;

CREATE TABLE returns (
    return_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    return_date   DATE NOT NULL,
    return_reason VARCHAR(200),
    return_status VARCHAR(20) DEFAULT 'Requested',
    CONSTRAINT fk_returns_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_returns_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO returns (order_id, product_id, return_date, return_reason, return_status) VALUES
(7, 8, '2026-01-24', 'Size mismatch',            'Approved'),
(1, 3, '2026-01-10', 'Wrong item delivered',     'Approved'),
(6, 3, '2026-01-22', 'Product damaged',          'Rejected'),
(4, 5, '2026-01-17', 'Not as described',         'Approved'),
(8, 9, '2026-01-27', 'Quality issue',            'Requested'),
(2, 4, '2026-01-13', 'Changed mind',             'Rejected'),
(10,10,'2026-02-02', 'Late delivery',            'Approved'),
(1, 1, '2026-01-09', 'Defective piece',          'Approved'),
(5, 6, '2026-01-18', 'Duplicate item received',  'Requested'),
(9, 10,'2026-01-28', 'Wrong color',              'Requested');

SELECT * FROM returns;

-- Basic concepts & operations on returns
SELECT * FROM returns WHERE return_status = 'Approved';
SELECT return_status, COUNT(*) AS total FROM returns GROUP BY return_status;

-- CRUD OPERATIONS  (Create, Read, Update, Delete)
INSERT INTO customers (customer_name, phone, email, address)
VALUES ('Ramesh Chandran', '9876543220', 'ramesh.c@gmail.com', 'Madurai, Tamil Nadu');

SELECT * FROM customers WHERE customer_name = 'Ramesh Chandran';

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1;

UPDATE orders
SET order_status = 'Delivered'
WHERE order_id = 9;

DELETE FROM cancellations
WHERE cancellation_id = 2;

SELECT * FROM customers WHERE customer_name = 'Ramesh Chandran';
SELECT * FROM products WHERE product_id = 1;
SELECT * FROM orders WHERE order_id = 9;
SELECT * FROM cancellations;

-- JOINS
SELECT o.order_id, c.customer_name, o.order_date, o.order_status, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- INNER JOIN : order_items with product and order details
SELECT oi.order_item_id, o.order_id, p.product_name, oi.quantity, oi.subtotal
FROM order_items oi
INNER JOIN orders o   ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

-- LEFT JOIN : all orders with their payment status (even if payment missing)
SELECT o.order_id, c.customer_name, p.payment_status
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p  ON o.order_id = p.order_id;

-- LEFT JOIN : all orders with delivery info
SELECT o.order_id, o.order_status, d.delivery_status, d.delivery_date
FROM orders o
LEFT JOIN deliveries d ON o.order_id = d.order_id;

-- RIGHT JOIN : products with their category names
SELECT p.product_name, c.category_name
FROM categories c
RIGHT JOIN products p ON c.category_id = p.category_id;

-- Multi-table JOIN : full order summary (customer + product + payment)
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity,
       oi.subtotal, pay.payment_method, pay.payment_status
       FROM orders o
JOIN customers c     ON o.customer_id = c.customer_id
JOIN order_items oi  ON o.order_id = oi.order_id
JOIN products p      ON oi.product_id = p.product_id
JOIN payments pay    ON o.order_id = pay.order_id;

-- AGGREGATE FUNCTIONS
SELECT COUNT(*) AS total_orders FROM orders;
SELECT SUM(total_amount) AS total_revenue FROM orders WHERE order_status = 'Delivered';
SELECT AVG(price) AS average_product_price FROM products;
SELECT MAX(total_amount) AS highest_order_value FROM orders;
SELECT MIN(total_amount) AS lowest_order_value FROM orders;

-- GROUP BY
-- Total revenue per customer
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Total quantity sold per product
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- Number of orders per order status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

-- Total sales per category
SELECT cat.category_name, SUM(oi.subtotal) AS category_sales
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name;

-- HAVING
-- Customers who spent more than 1000
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_amount) > 1000;

-- Products sold more than 1 unit in total
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity) > 1;

-- Categories with sales above 1000
SELECT cat.category_name, SUM(oi.subtotal) AS category_sales
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
HAVING SUM(oi.subtotal) > 1000;

-- SUBQUERIES
-- Customers who placed orders above the average order amount
SELECT customer_name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
);

-- Products that have never been ordered
SELECT product_name FROM products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- Customer with the highest single order value
SELECT customer_name FROM customers
WHERE customer_id = (
    SELECT customer_id FROM orders
    ORDER BY total_amount DESC LIMIT 1
);

-- Correlated subquery: orders whose amount is above that customer's average
SELECT o.order_id, o.customer_id, o.total_amount
FROM orders o
WHERE o.total_amount > (
    SELECT AVG(o2.total_amount) FROM orders o2
    WHERE o2.customer_id = o.customer_id
);

-- VIEWS
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT o.order_id, c.customer_name, o.order_date, o.order_status,
       o.total_amount, pay.payment_status, d.delivery_status
FROM orders o
JOIN customers c    ON o.customer_id = c.customer_id
LEFT JOIN payments pay   ON o.order_id = pay.order_id
LEFT JOIN deliveries d   ON o.order_id = d.order_id;

SELECT * FROM vw_order_summary;

-- View: product sales report
CREATE OR REPLACE VIEW vw_product_sales AS
SELECT p.product_name, cat.category_name,
       SUM(oi.quantity) AS units_sold, SUM(oi.subtotal) AS revenue
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_name, cat.category_name;

SELECT * FROM vw_product_sales;

-- STORED PROCEDURES
DELIMITER $$

-- Procedure to get complete order details for a given order_id
CREATE PROCEDURE sp_get_order_details(IN p_order_id INT)
BEGIN
    SELECT o.order_id, c.customer_name, p.product_name,
           oi.quantity, oi.subtotal, o.order_status
    FROM orders o
    JOIN customers c    ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    WHERE o.order_id = p_order_id;
END$$

-- Procedure to place a new order (inserts order + updates stock)
CREATE PROCEDURE sp_place_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_order_id INT;

    SELECT price INTO v_price FROM products WHERE product_id = p_product_id;

    INSERT INTO orders (customer_id, order_date, order_status, total_amount)
    VALUES (p_customer_id, CURDATE(), 'Placed', v_price * p_quantity);

    SET v_order_id = LAST_INSERT_ID();

    INSERT INTO order_items (order_id, product_id, quantity, price, subtotal)
    VALUES (v_order_id, p_product_id, p_quantity, v_price, v_price * p_quantity);

    UPDATE products SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;
END$$

DELIMITER ;

-- Call the procedures
CALL sp_get_order_details(1);
CALL sp_place_order(2, 7, 2);

-- FUNCTIONS
DELIMITER $$

-- Function to calculate total amount spent by a customer
CREATE FUNCTION fn_customer_total_spent(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT IFNULL(SUM(total_amount), 0) INTO v_total
    FROM orders WHERE customer_id = p_customer_id;
    RETURN v_total;
END$$

-- Function to return stock status text
CREATE FUNCTION fn_stock_status(p_stock INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(20);
    IF p_stock = 0 THEN
        SET v_status = 'Out of Stock';
    ELSEIF p_stock < 20 THEN
        SET v_status = 'Low Stock';
    ELSE
        SET v_status = 'In Stock';
    END IF;
    RETURN v_status;
END$$

DELIMITER ;

-- Use the functions
SELECT customer_name, fn_customer_total_spent(customer_id) AS total_spent
FROM customers;

SELECT product_name, stock_quantity, fn_stock_status(stock_quantity) AS status
FROM products;

-- TRIGGERS
DELIMITER $$

-- Trigger: reduce product stock automatically after an order item is inserted
CREATE TRIGGER trg_after_orderitem_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END$$

-- Trigger: log order status change into an audit table
DELIMITER ;

CREATE TABLE order_status_log (
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_after_order_status_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status <> NEW.order_status THEN
        INSERT INTO order_status_log (order_id, old_status, new_status)
        VALUES (NEW.order_id, OLD.order_status, NEW.order_status);
    END IF;
END$$

DELIMITER ;

-- Test the triggers
UPDATE orders SET order_status = 'Shipped' WHERE order_id = 2;
SELECT * FROM order_status_log;

-- WINDOW FUNCTIONS
-- Rank customers by total spending
SELECT customer_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
    SELECT c.customer_name, SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
) AS customer_totals;

-- Running total of revenue by order date
SELECT order_id, order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- Row number of orders per customer (most recent first)
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS order_sequence
FROM orders;

-- Compare each product's revenue with the previous product using LAG
SELECT product_name, revenue,
       LAG(revenue) OVER (ORDER BY revenue DESC) AS previous_product_revenue
FROM (
    SELECT p.product_name, SUM(oi.subtotal) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
) AS product_totals;


-- FINAL REPORTS
-- 1) Customer Report: total orders and total spend per customer
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       IFNULL(SUM(o.total_amount),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- 2) Product Report: best-selling products
SELECT p.product_name, cat.category_name,
       SUM(oi.quantity) AS units_sold, SUM(oi.subtotal) AS revenue
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_name, cat.category_name
ORDER BY revenue DESC;

-- 3) Order Report: full order status overview
SELECT * FROM vw_order_summary ORDER BY order_date;

-- 4) Payment Report: revenue by payment method
SELECT payment_method,
       COUNT(*) AS total_transactions,
       SUM(payment_amount) AS total_amount
FROM payments
WHERE payment_status = 'Success'
GROUP BY payment_method
ORDER BY total_amount DESC;

-- 5) Delivery Report: delivery performance
SELECT delivery_status, COUNT(*) AS total
FROM deliveries
GROUP BY delivery_status;

-- 6) Sales Report: monthly revenue trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS monthly_revenue
FROM orders
WHERE order_status <> 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- 7) Return & Cancellation Report
SELECT
    (SELECT COUNT(*) FROM cancellations) AS total_cancellations,
    (SELECT COUNT(*) FROM returns WHERE return_status = 'Approved') AS approved_returns,
    (SELECT COUNT(*) FROM returns WHERE return_status = 'Rejected') AS rejected_returns,
    (SELECT COUNT(*) FROM returns WHERE return_status = 'Requested') AS pending_returns;

-- 8) Category-wise Revenue Report
SELECT cat.category_name, SUM(oi.subtotal) AS category_revenue
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY category_revenue DESC;

-- 9) Top 3 Customers Report (using window function)
SELECT customer_name, total_spent, spending_rank
FROM (
    SELECT c.customer_name, SUM(o.total_amount) AS total_spent,
           RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
) ranked_customers
WHERE spending_rank <= 3;






























