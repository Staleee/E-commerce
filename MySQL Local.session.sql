CREATE SCHEMA ECOMMERCE;

CREATE TABLE Sellers (
    SellerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Address VARCHAR(255)
);

CREATE TABLE Brands (
    BrandID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);
-- Create tables
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Price DECIMAL(10, 2),
    StockQuantity INT,
    Ratings DECIMAL(3, 2),
    Discount DECIMAL(3, 2),
    Variation VARCHAR(50),
    SellerID INT,
    BrandID INT,
    CategoryID INT,
    FOREIGN KEY (SellerID) REFERENCES Sellers(SellerID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);



CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255),
    Password VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY,
    UserID INT,
    Balance DECIMAL(10, 2),
    CardType VARCHAR(50),
    CreditLimit DECIMAL(10, 2),
    ExpiryDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    UserID INT,
    Amount DECIMAL(10, 2),
    TransactionStatus ENUM('pending', 'completed', 'failed'),
    CardID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    UserID INT,
    ProductID INT,
    Rating DECIMAL(3, 2),
    Comment TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    UserID INT,
    OrderDate DATE,
    Quantity INT,
    TotalPaidAmount DECIMAL(10, 2),
    OrderStatus VARCHAR(50),
    ShippingAddress VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Insert data into Sellers table
INSERT INTO Sellers (SellerID, Name, Email, Address) VALUES
(1, 'John''s Electronics', 'john@example.com', '123 Main St, Cityville, USA'),
(2, 'Sarah''s Furniture', 'sarah@example.com', '456 Elm St, Townsville, USA');

-- Insert data into Brands table
INSERT INTO Brands (BrandID, Name, Description) VALUES
(1, 'Samsung', 'South Korean multinational conglomerate'),
(2, 'IKEA', 'Swedish-founded multinational group');

-- Insert data into Categories table
INSERT INTO Categories (CategoryID, Name, Description) VALUES
(1, 'Electronics', 'Products related to electronic devices'),
(2, 'Furniture', 'Products related to home and office furniture');

-- Insert data into Products table
INSERT INTO Products (ProductID, Name, Price, StockQuantity, Ratings, Discount, Variation, SellerID, BrandID, CategoryID) VALUES
(1, 'Samsung Galaxy S21', 999.99, 100, 4.8, 0.05, 'Black', 1, 1, 1),
(2, 'IKEA Hemnes Bed Frame', 249.99, 50, 4.5, 0.0, 'Queen size, Black-brown', 2, 2, 2),
(3, 'Samsung 65-inch QLED TV', 1499.99, 75, 4.7, 0.1, '4K, Smart TV', 1, 1, 1);

-- Sample Queries
-- List all top selling products and order them based on ratings
SELECT p.ProductID, p.Name, p.Price, p.StockQuantity, p.Ratings, p.Discount, p.Variation
FROM Products p
ORDER BY p.Ratings DESC;

-- List product information
SELECT * FROM Products;

-- Display customer order history (ordered based on order Date)
SELECT * FROM Orders WHERE UserID = UserID ORDER BY OrderDate DESC;

-- Display and list all items in the customer’s shopping cart
-- Assuming there's a table for shopping cart items
SELECT * FROM ShoppingCart WHERE UserID = UserID;

-- List discounted products (or offers)
SELECT * FROM Products WHERE Discount > 0;

-- Display the total amount paid
SELECT SUM(TotalPaidAmount) AS TotalAmountPaid FROM Orders WHERE UserID = UserID;

-- Display products that are out of stock
SELECT * FROM Products WHERE StockQuantity = 0;

-- Display reviews of products
SELECT r.*, u.Name AS UserName, p.Name AS ProductName
FROM Reviews r
JOIN Users u ON r.UserID = u.UserID
JOIN Products p ON r.ProductID = p.ProductID;
-- Index creation
CREATE INDEX idx_Products_SellerID ON Products(SellerID);
CREATE INDEX idx_Products_BrandID ON Products(BrandID);
CREATE INDEX idx_Products_CategoryID ON Products(CategoryID);
CREATE INDEX idx_Orders_UserID ON Orders(UserID);
CREATE INDEX idx_Reviews_UserID ON Reviews(UserID);
CREATE INDEX idx_Reviews_ProductID ON Reviews(ProductID);
-- View creation
CREATE VIEW TopSellingProducts AS
SELECT p.ProductID, p.Name, p.Price, p.StockQuantity, p.Ratings, p.Discount, p.Variation
FROM Products p
ORDER BY p.Ratings DESC;


