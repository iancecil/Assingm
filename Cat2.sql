-- SECTION A 

-- Question 1: Create BranchServices table with foreign key and ON DELETE CASCADE
CREATE TABLE BranchServices (
    ServiceID INT PRIMARY KEY,
    BranchNo VARCHAR(5),
    ServiceName VARCHAR(50),
    Description TEXT,
    FOREIGN KEY (BranchNo) REFERENCES Branch(branchNo) ON DELETE CASCADE
);
-- Creates a new table for branch services with referential integrity to Branch table

-- Question 2: Add Department column with CHECK constraint
ALTER TABLE Staff
ADD COLUMN Department VARCHAR(10) CHECK (Department IN ('Sales', 'PR', 'IT'));
-- Adds a new column restricted to specific department values

-- Question 3: Assign departments based on staff number prefixes
UPDATE Staff
SET Department = CASE 
    WHEN staffNo LIKE 'SL%' THEN 'Sales'
    WHEN staffNo LIKE 'SG%' THEN 'PR'
    ELSE 'IT'
END;
-- Classifies staff into departments based on their ID prefixes

-- Question 4: Insert records into BranchServices
INSERT INTO BranchServices VALUES
(1, 'B007', 'Property Appraisal', 'Professional appraisal of property value.'),
(2, 'B002', 'Mortgage Assistance', 'Guidance on mortgage processes.'),
(3, 'B007', 'Customer Support', 'Helpdesk for property inquiries.'),
(4, 'B003', 'Property Inspection', 'On-site property inspections.'),
(5, 'B002', 'Legal Assistance', 'Support with legal documentation.'),
(6, 'B004', 'Marketing Services', 'Property advertisement and promotions.');
-- Populates the BranchServices table with sample data

-- Question 5: Delete 'Mortgage Assistance' services
DELETE FROM BranchServices 
WHERE ServiceName = 'Mortgage Assistance';
-- Removes all mortgage assistance service records


-- SECTION B 

-- Question 6: Sales department staff details
SELECT iName, iName, position
FROM Staff
WHERE Department = 'Sales';
-- Retrieves names and positions of sales department staff

-- Question 7: High-rent properties (rent > 360)
SELECT * 
FROM PropertyForRent
WHERE rent > 360
ORDER BY rent DESC;
-- Shows properties with rent above 360, sorted from highest to lowest

-- Question 8: Mid-range rent properties (400-600)
SELECT propertyNo, rent
FROM PropertyForRent
WHERE rent BETWEEN 400 AND 600;
-- Lists property numbers and rents in the specified range

-- Question 9: Staff with names starting with 'J'
SELECT *
FROM Staff
WHERE iName LIKE 'J%' OR iName LIKE 'J%';
-- Finds all staff members with first or last name beginning with J

-- Question 10: Property annual rent calculation
SELECT propertyNo, rent, (rent * 12) AS "Annual Rent"
FROM PropertyForRent;
-- Calculates and displays annual rent for each property

-- Question 11: Properties managed by high-salary staff
SELECT p.*
FROM PropertyForRent p
JOIN Staff s ON p.staffNo = s.staffNo
WHERE s.salary > (SELECT AVG(salary) FROM Staff);
-- Finds properties managed by staff earning above average salary

-- Question 12: Staff count per branch
SELECT branchNo, COUNT(*) AS StaffCount
FROM Staff
GROUP BY branchNo;
-- Counts how many staff work in each branch

-- Question 13: Branches managing >3 properties
SELECT branchNo, COUNT(*) AS PropertyCount
FROM PropertyForRent
GROUP BY branchNo
HAVING COUNT(*) > 3;
-- Identifies branches handling more than 3 properties


-- SECTION C SOLUTIONS

-- Question 14: Property details with managing staff
SELECT p.propertyNo, p.street AS Address, s.iName, s.iName
FROM PropertyForRent p
LEFT JOIN Staff s ON p.staffNo = s.staffNo;
-- Shows all properties with their managing staff names

-- Question 15: Complete branch-staff listing
SELECT b.branchNo, b.city, s.staffNo, s.iName, s.iName
FROM Branch b
FULL OUTER JOIN Staff s ON b.branchNo = s.branchNo;
-- Displays all branches and all staff, including unassigned records

-- Question 16: Branches with services (including no services)
SELECT b.branchNo, b.city, bs.ServiceName, bs.Description
FROM Branch b
LEFT JOIN BranchServices bs ON b.branchNo = bs.BranchNo;
-- Lists all branches and their services, showing branches with no services too

-- Question 17: Cartesian product of Branch and Staff
SELECT *
FROM Branch
CROSS JOIN Staff;
-- Combines every branch with every staff member (all possible combinations)

-- Question 18: Staff earning more than property rent they manage
SELECT s.*, p.propertyNo, p.rent
FROM Staff s
JOIN PropertyForRent p ON s.staffNo = p.staffNo
WHERE s.salary > p.rent;
-- Finds staff whose salary exceeds the rent of properties they manage


-- Question 19: SQL equivalents for algebraic expressions

-- i. πBranchNo, Address(Branch)
SELECT branchNo, street AS Address
FROM Branch;
-- Projection of branch numbers and addresses

-- ii. σRent > 500(Property)
SELECT *
FROM PropertyForRent
WHERE rent > 500;
-- Selection of properties with rent over 500

-- iii. Property ⋈Property.StaffNo=Staff.StaffNo Staff
SELECT *
FROM PropertyForRent p
JOIN Staff s ON p.staffNo = s.staffNo;
-- Natural join of Property and Staff tables on staffNo

-- iv. πBranchNo (Property) ∩ πBranchNo(Staff)
SELECT branchNo FROM PropertyForRent
INTERSECT
SELECT branchNo FROM Staff;
-- Intersection of branch numbers from Property and Staff tables

-- v. πBranchNo (Branch)−πBranchNo(Property)
SELECT branchNo FROM Branch
EXCEPT
SELECT branchNo FROM PropertyForRent;
-- Branch numbers in Branch table but not in Property table
