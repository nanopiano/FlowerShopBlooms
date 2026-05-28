-- ============================================
-- FlowerShopBlooms Database Schema
-- schema.sql
-- ============================================

CREATE DATABASE FlowerShopBlooms;
USE FlowerShopBlooms;

-- SUPPLIER
CREATE TABLE SUPPLIER (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL UNIQUE,
    ContactPersonID INT,
    Phone BIGINT UNIQUE CHECK (Phone > 999999),
    Email VARCHAR(100),
    Address VARCHAR(200)
);

-- FLOWER
CREATE TABLE FLOWER (
    FlowerID INT PRIMARY KEY,
    FlowerName VARCHAR(100) NOT NULL,
    FlowerDescription VARCHAR(200),
    Color VARCHAR(50),
    Price DECIMAL(10,2) CHECK (Price BETWEEN 1 AND 100),
    SupplierID INT NOT NULL,
    FlowerType ENUM('Y', 'S') NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES SUPPLIER(SupplierID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- YEARROUND
CREATE TABLE YEARROUND (
    FlowerID INT PRIMARY KEY,
    GreenhouseType ENUM('Indoor', 'Outdoor', 'Hybrid'),
    ClimateControl ENUM('Yes', 'No'),
    FOREIGN KEY (FlowerID) REFERENCES FLOWER(FlowerID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- SEASONAL
CREATE TABLE SEASONAL (
    FlowerID INT PRIMARY KEY,
    Season ENUM('Spring', 'Summer', 'Fall', 'Winter') NOT NULL,
    BloomStart DATE,
    BloomEnd DATE,
    FOREIGN KEY (FlowerID) REFERENCES FLOWER(FlowerID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- CATEGORY
CREATE TABLE CATEGORY (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    CategoryDescription VARCHAR(150)
);

-- EMPLOYEE
CREATE TABLE EMPLOYEE (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50),
    HireDate DATE,
    Phone BIGINT UNIQUE CHECK (Phone > 999999)
);

-- FLOWER_CATEGORY
CREATE TABLE FLOWER_CATEGORY (
    FlowerID INT,
    CategoryID INT,
    PRIMARY KEY (FlowerID, CategoryID),
    FOREIGN KEY (FlowerID) REFERENCES FLOWER(FlowerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES CATEGORY(CategoryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- CUSTOMER
CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone BIGINT CHECK (Phone > 999999),
    Address VARCHAR(200),
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- EVENT
CREATE TABLE EVENT (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATE,
    Location VARCHAR(100),
    EventTheme VARCHAR(100)
);

-- ORDER
CREATE TABLE `ORDER` (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL DEFAULT (CURDATE()),
    Status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    TotalAmount DECIMAL(10,2) DEFAULT 0.00 CHECK (TotalAmount >= 0),
    CustomerID INT NOT NULL,
    EmployeeID INT,
    EventID INT,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- FLOWER_ORDER
CREATE TABLE FLOWER_ORDER (
    FlowerID INT,
    OrderID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice >= 0),
    PRIMARY KEY (FlowerID, OrderID),
    FOREIGN KEY (FlowerID) REFERENCES FLOWER(FlowerID)
        ON UPDATE CASCADE,
    FOREIGN KEY (OrderID) REFERENCES `ORDER`(OrderID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- SUPPLIER_EVENT
CREATE TABLE SUPPLIER_EVENT (
    SupplierID INT,
    EventID INT,
    SuppliedDate DATE,
    PRIMARY KEY (SupplierID, EventID),
    FOREIGN KEY (SupplierID) REFERENCES SUPPLIER(SupplierID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- INDEXES
CREATE INDEX idx_Seasonal_FlowerID ON SEASONAL(FlowerID);
CREATE INDEX idx_OrderDate ON `ORDER`(OrderDate);
CREATE INDEX idx_FlowerOrder_FlowerID ON FLOWER_ORDER(FlowerID);
CREATE INDEX idx_FlowerOrder_OrderID ON FLOWER_ORDER(OrderID);
