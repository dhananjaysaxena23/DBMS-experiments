CREATE DATABASE ECommerceDB; 
USE ECommerceDB; 
CREATE TABLE Customer ( 
    CustomerID INT PRIMARY KEY, 
    CustomerName VARCHAR(100), 
    Email VARCHAR(50), 
    Phone VARCHAR(12) 
); 
CREATE TABLE Address ( 
    AddressID INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    HouseNo VARCHAR(50), 
    City VARCHAR(50), 
    State VARCHAR(50), 
    Pincode INT, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
); 
CREATE TABLE Seller ( 
    SellerID INT PRIMARY KEY, 
    SellerName VARCHAR(50), 
    Email VARCHAR(60) 
); 
CREATE TABLE Category ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 
CREATE TABLE Product ( 
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(50), 
    Price DECIMAL(10,2), 
    CategoryID INT, 
    SellerID INT, 
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON DELETE CASCADE, 
    FOREIGN KEY (SellerID) REFERENCES Seller(SellerID) ON DELETE SET NULL 
); 
CREATE TABLE Orders ( 
    OrderID INT PRIMARY KEY, 
    CustomerID INT, 
    OrderDate DATE, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE 
); 
CREATE TABLE OrderItem (     OrderID INT, 
    ProductID INT, 
    Quantity INT, 
    Price DECIMAL(10,2), 
    PRIMARY KEY (OrderID, ProductID) 
); 
CREATE TABLE Payment ( 
    PaymentID INT PRIMARY KEY,     OrderID INT, 
    PaymentMethod VARCHAR(30), 
    Amount DECIMAL(10,2), 
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE ); 
CREATE TABLE Delivery ( 
    DeliveryID INT PRIMARY KEY, 
    OrderID INT, 
    AddressID INT, 
    DeliveryStatus VARCHAR(30), 
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE, 
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON DELETE CASCADE ); 
INSERT INTO Customer VALUES 
(1, 'ABC', 'abc@gmail.com', '98765432'), 
(2, 'XYZ', 'xyz@gmail.com', '123456789'), 
(3, 'EFG', 'efg@gmail.com', '135791120'); 
INSERT INTO Address VALUES 
(101, 1, 'HNo 1', 'Delhi', 'Delhi', 100100), 
(102, 2, 'HNo 67', 'Chandigarh', 'Punjab', 274124), 
(103, 3, 'HNo 9', 'Lucknow', 'UP', 222001); 
INSERT INTO Seller VALUES 
(1712, 'Tech World', 'tw@gmail.com'), 
(1727, 'Smart Store', 'SSShop@gmail.com'); 
INSERT INTO Category VALUES 
(301, 'Electronics'), 
(302, 'Toys'), 
(303, 'Mobile'); 
INSERT INTO Orders VALUES 
(501, 1, '2026-09-20'), 
(502, 2, '2026-09-23'); 
INSERT INTO OrderItem VALUES 
(501, 401, 1, 69990.00), 
(502, 401, 1, 55999.00), 
(503, 402, 3, 64999.00); 
INSERT INTO Payment VALUES 
(601, 501, 'UPI', 12599.00), 
(602, 502, 'Credit Card', 12999.00); 
SELECT * FROM Customer; 
SELECT * FROM Address; 
SELECT * FROM Seller; 
SELECT * FROM Category; 
SELECT * FROM Orders; 
SELECT * FROM OrderItem; 
SELECT * FROM Payment; 

-- Invalid operation examples written in the notebook: INSERT INTO Orders VALUES (503, 99, '2026-09-23'); -- Rejected because CustomerID 99 does not exist. 
INSERT INTO Customer VALUES (4, 'Test', 'abc@gmail.com', '9900000'); -- Rejected as duplicate email (if Email has a UNIQUE constraint). 

INSERT INTO OrderItem VALUES (501, 401, 2, 69990.00); 
DELETE FROM Customer 
WHERE CustomerID = 1; 
DELETE FROM Seller 
WHERE SellerID = 201; 
SELECT * FROM Product;
