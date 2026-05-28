-- ============================================
-- FlowerShopBlooms Sample Data
-- data.sql
-- ============================================

USE FlowerShopBlooms;

-- SUPPLIER
INSERT INTO SUPPLIER (SupplierID, SupplierName, ContactPersonID, Phone, Email, Address)
VALUES
(101, 'Green Oasis', 1, 971502223344, 'sales@greenoasis.ae', 'Sharjah, UAE'),
(102, 'Petal Roots', 2, 971509998877, 'contact@petalroots.com', 'Riyadh, Saudi Arabia');

-- FLOWER
INSERT INTO FLOWER (FlowerID, FlowerName, FlowerDescription, Color, Price, SupplierID, FlowerType)
VALUES
(201, 'Rose', 'Long stem red rose', 'Red', 8.50, 101, 'Y'),
(202, 'Lily', 'White oriental lily', 'White', 12.25, 101, 'Y'),
(203, 'Tulip', 'Purple tulip imported from Holland', 'Purple', 9.75, 102, 'S'),
(204, 'Orchid', 'Pink phalaenopsis orchid', 'Pink', 15.00, 102, 'Y'),
(205, 'Rose', 'Short stem white rose', 'White', 6.00, 101, 'S'),
(206, 'Tulip', 'Yellow tulip from Turkey', 'Yellow', 8.95, 101, 'S'),
(207, 'Sunflower', 'Bright yellow sunflower', 'Yellow', 7.50, 102, 'S'),
(208, 'Rose', 'Pink garden rose', 'Pink', 10.00, 101, 'S'),
(209, 'Hydrangea', 'Blue hydrangea bloom', 'Blue', 13.45, 102, 'S'),
(210, 'Orchid', 'Mini white orchid', 'White', 14.00, 101, 'Y');

-- YEARROUND
INSERT INTO YEARROUND (FlowerID, GreenhouseType, ClimateControl)
VALUES
(201, 'Indoor', 'Yes'),
(202, 'Indoor', 'Yes'),
(204, 'Indoor', 'Yes'),
(210, 'Indoor', 'Yes');

-- SEASONAL
INSERT INTO SEASONAL (FlowerID, Season, BloomStart, BloomEnd)
VALUES
(203, 'Spring', '2025-03-01', '2025-05-30'),
(205, 'Summer', '2025-06-01', '2025-08-31'),
(206, 'Spring', '2025-03-15', '2025-05-30'),
(207, 'Summer', '2025-06-01', '2025-09-01'),
(208, 'Spring', '2025-03-01', '2025-06-15'),
(209, 'Fall', '2025-09-01', '2025-11-15');

-- CATEGORY
INSERT INTO CATEGORY (CategoryID, CategoryName, CategoryDescription)
VALUES
(1, 'Wedding', 'Arrangements for weddings and receptions'),
(2, 'Birthday', 'Colorful bouquets for birthday celebrations'),
(3, 'Congratulations', 'Celebratory arrangements'),
(4, 'Mother Day', 'Special flowers for mothers'),
(5, 'Apology', 'Say sorry with flowers'),
(6, 'Valentine Day', 'Romantic bouquets and roses'),
(7, 'Anniversary', 'Elegant floral gifts for anniversaries'),
(8, 'Graduation', 'Flowers for grads and success');

-- EMPLOYEE
INSERT INTO EMPLOYEE (EmployeeID, FirstName, LastName, Position, HireDate, Phone)
VALUES
(301, 'Ahmad', 'Khaled', 'Florist', '2023-07-15', 971501234567),
(302, 'Julia', 'Nasr', 'Manager', '2022-04-01', 971505556677),
(303, 'Najm', 'Hussein', 'Delivery', '2023-12-01', 971508889999),
(304, 'Lara', 'Salem', 'Florist', '2024-01-18', 971507777111);

-- FLOWER_CATEGORY
INSERT INTO FLOWER_CATEGORY (FlowerID, CategoryID)
VALUES
(201, 6),
(202, 1),
(203, 2),
(204, 4),
(205, 7),
(206, 2),
(207, 3),
(208, 6),
(209, 3),
(210, 1);

-- CUSTOMER
INSERT INTO CUSTOMER (CustomerID, FirstName, LastName, Email, Phone, Address, EmployeeID)
VALUES
(401, 'Juman', 'Hassan', 'juman.hassan@gmail.com', 971501119999, 'Dubai Marina', 301),
(402, 'Qusai', 'Sami', 'qusai.sami@outlook.com', 971507777222, 'Al Ain', 302),
(403, 'Dareen', 'Yousef', 'dareen.yousef@live.com', 971504448888, 'Amman, Jordan', 303),
(404, 'Roaa', 'Fayez', 'roaa.fayez@mail.com', 971505550000, 'Sharjah', 301),
(405, 'Dayan', 'Majed', 'dayan.majed@mail.com', 971506660000, 'Riyadh', NULL);

-- EVENT
INSERT INTO EVENT (EventID, EventName, EventDate, Location, EventTheme)
VALUES
(501, 'Julia & Jamel Wedding', '2025-05-22', 'Palm Jumeirah', 'Elegant Romantic'),
(502, 'Dareen Graduation', '2025-06-01', 'Zayed University', 'Success & Growth'),
(503, 'Amar Birthday Bash', '2025-07-15', 'JBR', 'Colorful Chaos'),
(504, 'Najm Proposal', '2025-08-05', 'Burj Khalifa', 'Red & Gold Romance');

-- ORDER
INSERT INTO `ORDER` (OrderID, OrderDate, Status, TotalAmount, CustomerID, EmployeeID, EventID)
VALUES
(601, '2025-04-18', 'Completed', 75.25, 401, 301, 501),
(602, '2025-04-19', 'Pending', 45.00, 402, 302, NULL),
(603, '2025-04-20', 'Pending', 99.95, 403, NULL, 502),
(604, '2025-04-21', 'Completed', 65.00, 404, 301, 503),
(605, '2025-04-22', 'Pending', 38.50, 405, 304, 504);

-- FLOWER_ORDER
INSERT INTO FLOWER_ORDER (FlowerID, OrderID, Quantity, UnitPrice)
VALUES
(201, 601, 5, 8.50),
(202, 601, 1, 12.25),
(203, 602, 3, 9.75),
(204, 603, 2, 15.00),
(205, 604, 4, 6.00),
(208, 604, 1, 10.00),
(201, 605, 2, 8.50),
(204, 605, 1, 15.00);

-- SUPPLIER_EVENT
INSERT INTO SUPPLIER_EVENT (SupplierID, EventID, SuppliedDate)
VALUES
(101, 501, '2025-05-20'),
(101, 504, '2025-08-04'),
(102, 502, '2025-05-31'),
(102, 503, '2025-07-14');
