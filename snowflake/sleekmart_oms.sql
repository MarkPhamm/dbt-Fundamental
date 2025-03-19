-- Create Database
CREATE DATABASE SLEEKMART_OMS;

-- Create Schemas
CREATE SCHEMA L1_LANDING;
CREATE SCHEMA L2_PROCESSING;
CREATE SCHEMA L3_CONSUMPTION;

-- Use the Database and Schema
USE DATABASE SLEEKMART_OMS;
USE SCHEMA L1_LANDING;

-- Create Tables
DROP TABLE IF EXISTS Dates;
CREATE TABLE IF NOT EXISTS Dates (
    Date DATE NOT NULL PRIMARY KEY,
    Day VARCHAR(3),
    Month VARCHAR(10),
    Year VARCHAR(4),
    Quarter INT,
    DayOfWeek VARCHAR(10),
    WeekOfYear INT,
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS Cusomters;
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(2),
    ZipCode VARCHAR(10),
    Updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(200),
    JobTitle VARCHAR(100),
    HireDate DATE,
    ManagerID INT,
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS Stores;
CREATE TABLE IF NOT EXISTS Stores (
    StoreID INT NOT NULL PRIMARY KEY,
    StoreName VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Email VARCHAR(200),
    Phone VARCHAR(50),
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS Suppliers;
CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID INT NOT NULL PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Email VARCHAR(200),
    Phone VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(10),
    ZipCode VARCHAR(10),
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS Products;
CREATE TABLE IF NOT EXISTS Products (
    ProductID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(100),
    RetailPrice DECIMAL(10,2),
    SupplierPrice DECIMAL(10,2),
    SupplierID INT,
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS OrderItems;
CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INT NOT NULL PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Updated_at TIMESTAMP
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(10),
    EmployeeID INT,
    StoreID INT,
    Status VARCHAR(10),
    Updated_at TIMESTAMP
);

-- Sample data for Dates table
INSERT INTO Dates (Date, Day, Month, Year, Quarter, DayOfWeek, WeekOfYear, Updated_at) VALUES
('2024-01-01', 'Mon', 'January', '2024', 1, 'Monday', 1, '2024-08-01 10:00:00'),
('2024-01-02', 'Tue', 'January', '2024', 1, 'Tuesday', 1, '2024-08-01 10:00:00'),
('2024-01-03', 'Wed', 'January', '2024', 1, 'Wednesday', 1, '2024-08-01 10:00:00'),
('2024-01-04', 'Thu', 'January', '2024', 1, 'Thursday', 1, '2024-08-01 10:00:00'),
('2024-01-05', 'Fri', 'January', '2024', 1, 'Friday', 1, '2024-08-01 10:00:00');

-- Sample data for customers table
INSERT INTO customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Updated_at) VALUES
('C001', 'John', 'Doe', 'john.doe@example.com', '555-0100', '123 Main St', 'Springfield', 'IL', '62701', '2024-08-01 10:00:00'),
('C002', 'Jane', 'Smith', 'jane.smith@example.com', '555-0101', '456 Oak St', 'Springfield', 'IL', '62702', '2024-08-01 10:00:00'),
('C003', 'Alice', 'Johnson', 'alice.johnson@example.com', '555-0102', '789 Pine St', 'Springfield', 'IL', '62703', '2024-08-01 10:00:00'),
('C004', 'Bob', 'Brown', 'bob.brown@example.com', '555-0103', '101 Maple St', 'Springfield', 'IL', '62704', '2024-08-01 10:00:00'),
('C005', 'Charlie', 'Davis', 'charlie.davis@example.com', '555-0104', '202 Birch St', 'Springfield', 'IL', '62705', '2024-08-01 10:00:00');

-- Sample data for Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, JobTitle, HireDate, ManagerID, Address, City, State, ZipCode, Updated_at) VALUES
(1, 'Tom', 'Hanks', 'tom.hanks@example.com', 'Manager', '2022-01-15', NULL, '101 Maple St', 'Springfield', 'IL', '62701', '2024-08-01 10:00:00'),
(2, 'Emma', 'Watson', 'emma.watson@example.com', 'Sales Associate', '2023-02-20', 1, '202 Birch St', 'Springfield', 'IL', '62702', '2024-08-01 10:00:00'),
(3, 'Mark', 'Smith', 'mark.smith@example.com', 'Developer', '2021-03-10', 1, '303 Cedar St', 'Springfield', 'IL', '62703', '2024-08-01 10:00:00'),
(4, 'Lucy', 'Williams', 'lucy.williams@example.com', 'HR', '2020-04-25', 1, '404 Oak St', 'Springfield', 'IL', '62704', '2024-08-01 10:00:00'),
(5, 'David', 'Jones', 'david.jones@example.com', 'Support', '2019-05-30', 2, '505 Pine St', 'Springfield', 'IL', '62705', '2024-08-01 10:00:00');

-- Sample data for Stores table
INSERT INTO Stores (StoreID, StoreName, Address, City, State, ZipCode, Email, Phone, Updated_at) VALUES
(1, 'Main Street Store', '111 Main St', 'Springfield', 'IL', '62701', 'mainstore@example.com', '555-0120', '2024-08-01 10:00:00'),
(2, 'Downtown Store', '222 Elm St', 'Springfield', 'IL', '62702', 'downtownstore@example.com', '555-0121', '2024-08-01 10:00:00'),
(3, 'Eastside Store', '333 Oak St', 'Springfield', 'IL', '62703', 'eastsidestore@example.com', '555-0122', '2024-08-01 10:00:00'),
(4, 'Westside Store', '444 Birch St', 'Springfield', 'IL', '62704', 'westsidestore@example.com', '555-0123', '2024-08-01 10:00:00'),
(5, 'Southside Store', '555 Cedar St', 'Springfield', 'IL', '62705', 'southsidestore@example.com', '555-0124', '2024-08-01 10:00:00');

-- Sample data for Suppliers table
INSERT INTO Suppliers (SupplierID, SupplierName, ContactPerson, Email, Phone, Address, City, State, ZipCode, Updated_at) VALUES
(1, 'ABC Supplies', 'Robert Brown', 'robert.brown@abc.com', '555-0130', '123 Supply St', 'Springfield', 'IL', '62701', '2024-08-01 10:00:00'),
(2, 'XYZ Corp', 'Susan Green', 'susan.green@xyz.com', '555-0131', '456 Warehouse St', 'Springfield', 'IL', '62702', '2024-08-01 10:00:00'),
(3, '123 Distributors', 'Nancy White', 'nancy.white@123.com', '555-0132', '789 Distribution St', 'Springfield', 'IL', '62703', '2024-08-01 10:00:00'),
(4, 'Tech Supplies', 'James Black', 'james.black@tech.com', '555-0133', '101 Tech St', 'Springfield', 'IL', '62704', '2024-08-01 10:00:00'),
(5, 'Home Supplies', 'Michael Blue', 'michael.blue@home.com', '555-0134', '202 Home St', 'Springfield', 'IL', '62705', '2024-08-01 10:00:00');

-- Sample data for Products table
INSERT INTO Products (ProductID, Name, Category, RetailPrice, SupplierPrice, SupplierID, Updated_at) VALUES
(1, 'Laptop', 'Electronics', 999.99, 800.00, 1, '2024-08-01 10:00:00'),
(2, 'Smartphone', 'Electronics', 699.99, 500.00, 2, '2024-08-01 10:00:00'),
(3, 'Tablet', 'Electronics', 499.99, 350.00, 3, '2024-08-01 10:00:00'),
(4, 'Monitor', 'Electronics', 199.99, 150.00, 4, '2024-08-01 10:00:00'),
(5, 'Keyboard', 'Electronics', 49.99, 30.00, 5, '2024-08-01 10:00:00');

-- Sample data for Orders table
INSERT INTO Orders (OrderID, OrderDate, CustomerID, EmployeeID, StoreID, Status, Updated_at) VALUES
(1, '2024-07-15', 'C001', 1, 1, 'Shipped', '2024-08-01 10:00:00'),
(2, '2024-07-16', 'C002', 2, 2, 'Pending', '2024-08-01 10:00:00'),
(3, '2024-07-17', 'C003', 3, 3, 'Delivered', '2024-08-01 10:00:00'),
(4, '2024-07-18', 'C004', 4, 4, 'Processing', '2024-08-01 10:00:00'),
(5, '2024-07-19', 'C005', 5, 5, 'Cancelled', '2024-08-01 10:00:00');

-- Sample data for OrderItems table
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Updated_at) VALUES
(1, 1, 1, 1, 999.99, '2024-08-01 10:00:00'),
(2, 2, 2, 1, 699.99, '2024-08-01 10:00:00'),
(3, 3, 3, 2, 499.99, '2024-08-01 10:00:00'),
(4, 4, 4, 1, 199.99, '2024-08-01 10:00:00'),
(5, 5, 5, 3, 49.99, '2024-08-01 10:00:00');


