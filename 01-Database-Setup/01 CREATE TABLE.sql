CREATE DATABASE DB_PERFORMANCE;
GO
USE DB_PERFORMANCE;
GO


CREATE TABLE CUSTOMERS(
	CUSTOMERID INT PRIMARY KEY IDENTITY,
	FIRSTNAME VARCHAR(100) NOT NULL,
	LASTNAME VARCHAR(100) NOT NULL,
	EMAIL VARCHAR(200),
	CITY VARCHAR(100),
	COUNTRY VARCHAR(100),
	REGISTRATIONDATE DATE
);
GO

CREATE TABLE PRODUCTS(
	PRODUCTID INT PRIMARY KEY IDENTITY,
	PRODUCTNAME VARCHAR(200) NOT NULL,
	CATEGORY VARCHAR(100) NOT NULL,
	BRAND VARCHAR(100) NOT NULL,
	PRICE DECIMAL(10,2) NOT NULL,
	STOCK INT NOT NULL
);
GO

CREATE TABLE ORDERS(
	ORDERID BIGINT PRIMARY KEY IDENTITY,
	CUSTOMERID INT,
	ORDERDATE DATETIME,
	TOTALAMOUNT DECIMAL(12,2),
	PAYMENTMETHOD VARCHAR(30),
	STATUS VARCHAR(30),
	CONSTRAINT FK_ORDERS_CUSTOMERS
		FOREIGN KEY (CUSTOMERID)
		REFERENCES CUSTOMERS(CUSTOMERID)
);
GO

CREATE TABLE ORDERDETAILS(
	ORDERDETAILID BIGINT PRIMARY KEY IDENTITY,
	ORDERID BIGINT,
	PRODUCTID INT,
	QUANTITY INT,
	UNITPRICE DECIMAL(10,2),
	CONSTRAINT FK_ORDERDETAILS_ORDER
		FOREIGN KEY (ORDERID)
		REFERENCES ORDERS(ORDERID),
	CONSTRAINT FK_ORDERDETAILS_PRODUCT
		FOREIGN KEY (PRODUCTID)
		REFERENCES PRODUCTS(PRODUCTID)
);
GO

;WITH Numbers AS
(
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO Customers
(
    FirstName,
    LastName,
    Email,
    City,
    Country,
    RegistrationDate
)
SELECT
    CONCAT('Customer', N),
    CONCAT('Lastname', N),
    CONCAT('customer', N, '@mail.com'),

    CHOOSE(ABS(CHECKSUM(NEWID())) % 10 + 1,
        'New York',
        'Madrid',
        'Santo Domingo',
        'Bogotá',
        'Lima',
        'Ciudad de México',
        'Buenos Aires',
        'Miami',
        'Toronto',
        'Chicago'),

    CHOOSE(ABS(CHECKSUM(NEWID())) % 8 + 1,
        'USA',
        'España',
        'República Dominicana',
        'Colombia',
        'Perú',
        'México',
        'Argentina',
        'Canadá'),

    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % 2500,
        '2018-01-01'
    )
FROM Numbers;

;WITH Numbers AS
(
    SELECT TOP (100000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO Products
(
    ProductName,
    Category,
    Brand,
    Price,
    Stock
)
SELECT
    CONCAT('Product ', N),

    CASE ABS(CHECKSUM(NEWID())) % 8
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Clothing'
        WHEN 2 THEN 'Sports'
        WHEN 3 THEN 'Books'
        WHEN 4 THEN 'Home'
        WHEN 5 THEN 'Toys'
        WHEN 6 THEN 'Beauty'
        ELSE 'Automotive'
    END,

    CASE ABS(CHECKSUM(NEWID())) % 10
        WHEN 0 THEN 'Samsung'
        WHEN 1 THEN 'Apple'
        WHEN 2 THEN 'Sony'
        WHEN 3 THEN 'Nike'
        WHEN 4 THEN 'Adidas'
        WHEN 5 THEN 'LG'
        WHEN 6 THEN 'HP'
        WHEN 7 THEN 'Dell'
        WHEN 8 THEN 'Lenovo'
        ELSE 'Logitech'
    END,

    CAST((RAND(CHECKSUM(NEWID())) * 4995 + 5) AS DECIMAL(10,2)),

    ABS(CHECKSUM(NEWID())) % 1000
FROM Numbers;

;WITH Numbers AS
(
    SELECT TOP (10000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
    CROSS JOIN sys.objects d
)
INSERT INTO Orders
(
    CustomerID,
    OrderDate,
    TotalAmount,
    PaymentMethod,
    Status
)
SELECT
    ABS(CHECKSUM(NEWID())) % 1000000 + 1,

    DATEADD(
        DAY,
        ABS(CHECKSUM(NEWID())) % 2557,
        '2019-01-01'
    ),

    CAST((RAND(CHECKSUM(NEWID())) * 2990 + 10) AS DECIMAL(12,2)),

    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1,
        'Credit Card',
        'Debit Card',
        'PayPal',
        'Cash',
        'Bank Transfer'),

    CHOOSE(ABS(CHECKSUM(NEWID())) % 5 + 1,
        'Pending',
        'Paid',
        'Shipped',
        'Delivered',
        'Cancelled')
FROM Numbers;


DECLARE @MinOrderID BIGINT;
DECLARE @MaxOrderID BIGINT;
DECLARE @MaxProductID INT;

SELECT
    @MinOrderID = MIN(OrderID),
    @MaxOrderID = MAX(OrderID)
FROM Orders;

SELECT
    @MaxProductID = MAX(ProductID)
FROM Products;

;WITH Numbers AS
(
    SELECT TOP (40000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
    CROSS JOIN sys.objects d
)
INSERT INTO OrderDetails
(
    OrderID,
    ProductID,
    Quantity,
    UnitPrice
)
SELECT
    ABS(CHECKSUM(NEWID())) % (@MaxOrderID - @MinOrderID + 1) + @MinOrderID,
    ABS(CHECKSUM(NEWID())) % @MaxProductID + 1,
    ABS(CHECKSUM(NEWID())) % 10 + 1,
    CAST(RAND(CHECKSUM(NEWID())) * 4995 + 5 AS DECIMAL(10,2))
FROM Numbers;