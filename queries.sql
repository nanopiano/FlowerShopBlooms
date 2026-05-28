-- ============================================
-- FlowerShopBlooms Queries
-- queries.sql
-- ============================================

USE FlowerShopBlooms;

-- ============================================
-- QUERY 1
-- Lists customers who placed multiple orders
-- containing roses. Deletes incomplete records
-- with no email.
-- Uses CREATE VIEW, JOIN, GROUP BY, HAVING,
-- DELETE, IN
-- ============================================

CREATE VIEW loyalroselovers AS
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    COUNT(o.OrderID) AS RoseOrderCount
FROM CUSTOMER c
JOIN `ORDER` o ON c.CustomerID = o.CustomerID
JOIN FLOWER_ORDER fo ON o.OrderID = fo.OrderID
JOIN FLOWER f ON fo.FlowerID = f.FlowerID
WHERE f.FlowerName LIKE '%Rose%'
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email
HAVING COUNT(o.OrderID) > 1;

DELETE FROM CUSTOMER
WHERE CustomerID IN (
    SELECT CustomerID FROM loyalroselovers
    WHERE Email IS NULL
);

SELECT * FROM loyalroselovers;

-- ============================================
-- QUERY 2
-- Identifies employees who handled supplier
-- event orders or Valentine Day orders for
-- customers whose name ends with 'n'.
-- Uses SELECT, JOIN, EXISTS, LIKE, UNION
-- ============================================

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    'Handled Supplier Event Order' AS Reason
FROM EMPLOYEE e
JOIN `ORDER` o ON e.EmployeeID = o.EmployeeID
JOIN FLOWER_ORDER fo ON o.OrderID = fo.OrderID
JOIN FLOWER f ON fo.FlowerID = f.FlowerID
WHERE EXISTS (
    SELECT 1
    FROM SUPPLIER_EVENT se
    WHERE se.SupplierID = f.SupplierID
)

UNION

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    'Handled Valentine Order for Customer Ending with n' AS Reason
FROM EMPLOYEE e
JOIN `ORDER` o ON e.EmployeeID = o.EmployeeID
JOIN CUSTOMER c ON o.CustomerID = c.CustomerID
JOIN FLOWER_ORDER fo ON o.OrderID = fo.OrderID
JOIN FLOWER f ON fo.FlowerID = f.FlowerID
JOIN FLOWER_CATEGORY fc ON f.FlowerID = fc.FlowerID
JOIN CATEGORY cat ON fc.CategoryID = cat.CategoryID
WHERE cat.CategoryName = 'Valentine Day'
AND c.FirstName LIKE '%n';

-- ============================================
-- QUERY 3
-- Adds CustomerStatus column, updates VIP
-- status for customers who spent over 50 AED
-- on non-seasonal flowers after 2024.
-- Uses ALTER TABLE, UPDATE, JOIN, GROUP BY,
-- HAVING, ORDER BY
-- ============================================

ALTER TABLE CUSTOMER ADD COLUMN CustomerStatus VARCHAR(20) DEFAULT 'Regular';

UPDATE CUSTOMER
SET CustomerStatus = 'VIP'
WHERE CustomerID IN (
    SELECT c.CustomerID
    FROM CUSTOMER c
    JOIN `ORDER` o ON c.CustomerID = o.CustomerID
    JOIN FLOWER_ORDER fo ON o.OrderID = fo.OrderID
    JOIN FLOWER f ON fo.FlowerID = f.FlowerID
    WHERE f.FlowerID NOT IN (
        SELECT FlowerID FROM SEASONAL
    )
    AND o.OrderDate >= '2024-01-01'
    GROUP BY c.CustomerID
    HAVING SUM(fo.UnitPrice * fo.Quantity) > 50
);

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.CustomerStatus,
    SUM(fo.UnitPrice * fo.Quantity) AS TotalSpent
FROM CUSTOMER c
JOIN `ORDER` o ON c.CustomerID = o.CustomerID
JOIN FLOWER_ORDER fo ON o.OrderID = fo.OrderID
JOIN FLOWER f ON fo.FlowerID = f.FlowerID
WHERE f.FlowerID NOT IN (
    SELECT FlowerID FROM SEASONAL
)
AND o.OrderDate >= '2024-01-01'
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerStatus
HAVING TotalSpent > 50
ORDER BY TotalSpent DESC;

-- Index added after CustomerStatus column exists
CREATE INDEX idx_CustomerStatus ON CUSTOMER(CustomerStatus);

-- ============================================
-- RELATIONAL ALGEBRA
-- ============================================

-- Operation 1:
-- Count how many different flowers Green Oasis
-- supplies for each category
--
-- γ_CategoryName; COUNT(DISTINCT FlowerID) (
--     σ_SupplierName = 'Green Oasis' (
--         SUPPLIER
--         ⨝ SUPPLIER.SupplierID = FLOWER.SupplierID
--         ⨝ FLOWER.FlowerID = FLOWER_CATEGORY.FlowerID
--         ⨝ FLOWER_CATEGORY.CategoryID = CATEGORY.CategoryID
--     )
-- )
--
-- Joins connect supplier to flower to category.
-- Filter keeps only Green Oasis rows.
-- Grouping counts unique FlowerIDs per category.

-- Operation 2:
-- List all customers who placed an order
-- containing a flower priced above 12
--
-- π_CustomerID, FirstName, LastName (
--     (CUSTOMER ⋈ ORDER)
--     ∩
--     (π_CustomerID, FirstName, LastName (
--         (CUSTOMER ⋈ ORDER)
--         WHERE OrderID ∈ (
--             π_OrderID (
--                 σ_Price > 12 (
--                     FLOWER_ORDER ⋈ FLOWER
--                 )
--             )
--         )
--     ))
-- )
--
-- Joins FLOWER_ORDER and FLOWER, filters Price > 12.
-- Projects qualifying OrderIDs.
-- Intersects with full customer order list
-- to return only matching customers.
