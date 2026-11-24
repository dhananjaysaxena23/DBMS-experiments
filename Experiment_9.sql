-- EXPERIMENT 9: INDEXING AND QUERY PERFORMANCE OPTIMIZATION USING EXPLAIN
-- The PDF instructs generating/inserting at least 5,000 records.
-- The sample rows below are those shown in the source; add/generate records as needed.


-- 1. Create Railway Booking table
CREATE TABLE RailwayBooking (
    BookingID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    TrainNumber INT,
    SourceStation VARCHAR(50),
    DestinationStation VARCHAR(50),
    TravelDate DATE,
    SeatNumber INT,
    Class VARCHAR(20),
    Fare DECIMAL(10,2)
);


-- 2. Insert sample records
INSERT INTO RailwayBooking
(BookingID, PassengerName, TrainNumber, SourceStation, DestinationStation,
 TravelDate, SeatNumber, Class, Fare)
VALUES
(1, 'Aman', 12001, 'Delhi', 'Lucknow', '2026-11-01', 1, 'AC', 1500),
(2, 'Riya', 12002, 'Kanpur', 'Delhi', '2026-11-02', 2, 'Sleeper', 800),
(3, 'Rahul', 12003, 'Lucknow', 'Kanpur', '2026-11-03', 3, 'AC', 1000);

-- Add/generate records until the table has at least 5,000 rows.

-- 3. Check number of records
SELECT COUNT(*) AS TotalBookings
FROM RailwayBooking;


-- 4. Display sample records
SELECT *
FROM RailwayBooking
LIMIT 10;


-- 5. Query before indexing
SELECT *
FROM RailwayBooking
WHERE PassengerName = 'Aman';


-- 6. EXPLAIN before indexing
EXPLAIN
SELECT *
FROM RailwayBooking
WHERE PassengerName = 'Aman';


-- 7. Create single-column index
CREATE INDEX idx_passenger_name
ON RailwayBooking(PassengerName);


-- 8. Check index
SHOW INDEX FROM RailwayBooking;


-- 9. Execute query after single-column index
SELECT *
FROM RailwayBooking
WHERE PassengerName = 'Aman';


-- 10. EXPLAIN after single-column index
EXPLAIN
SELECT *
FROM RailwayBooking
WHERE PassengerName = 'Aman';


-- 11. Create composite index
CREATE INDEX idx_route
ON RailwayBooking(SourceStation, DestinationStation);


-- 12. Execute query using composite index
SELECT *
FROM RailwayBooking
WHERE SourceStation = 'Delhi'
  AND DestinationStation = 'Lucknow';


-- 13. EXPLAIN for composite index
EXPLAIN
SELECT *
FROM RailwayBooking
WHERE SourceStation = 'Delhi'
  AND DestinationStation = 'Lucknow';


-- 14. Drop single-column index
DROP INDEX idx_passenger_name
ON RailwayBooking;


-- 15. Drop composite index
DROP INDEX idx_route
ON RailwayBooking;
