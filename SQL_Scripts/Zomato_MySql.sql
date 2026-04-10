-- 2nd Project SQL(Group 3)
USE zomato_database;

# 1. Build a Country Map Table 

CREATE TABLE country_map (
    country_code INT PRIMARY KEY,
    country_name VARCHAR(50)
);

INSERT INTO country_map (country_code, country_name) VALUES 
(1, 'India'),
(14, 'Australia'),
(30, 'Brazil'),
(37, 'Canada'),
(94, 'Indonesia'),
(148, 'New Zealand'),
(162, 'Philippines'),
(166, 'Qatar'),
(184, 'Singapore'),
(189, 'South Africa'),
(191, 'Sri Lanka'),
(208, 'Turkey'),
(214, 'UAE'),
(215, 'United Kingdom'),
(216, 'United States');

SELECT * FROM country_map;

------------------------------------------------------------------------------------------------------------------------------------------------------

# 2. Build a Calendar Table using the Column Datekey

CREATE TABLE calendar_table AS
SELECT 
    Datekey,
    YEAR(Datekey) AS Year,
    MONTH(Datekey) AS MonthNo,
    MONTHNAME(Datekey) AS MonthFullName,
    CONCAT('Q', QUARTER(Datekey)) AS Quarter,
    DATE_FORMAT(Datekey, '%Y-%b') AS YearMonth,
    DAYOFWEEK(Datekey) AS WeekdayNo,
    DAYNAME(Datekey) AS WeekdayName,
    
    -- Financial Month (April = FM1)
    CASE 
        WHEN MONTH(Datekey) >= 4 THEN CONCAT('FM', MONTH(Datekey) - 3)
        ELSE CONCAT('FM', MONTH(Datekey) + 9)
    END AS FinancialMonth,

    -- Financial Quarter (Apr-Jun = FQ1)
    CASE 
        WHEN MONTH(Datekey) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Datekey) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(Datekey) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter

FROM (
    SELECT DISTINCT Datekey_Opening AS Datekey
    FROM zomato_main
) AS distinct_dates;

SELECT * FROM calendar_table;

---------------------------------------------------------------------------------------------------------------------------------------------------

# 3.Find the Numbers of Resturants based on City and Country.

SELECT 
    c.country_name, 
    z.City, 
    COUNT(z.RestaurantID) AS no_of_restaurants
FROM zomato_main z
JOIN country_map c 
    ON z.CountryCode = c.country_code
GROUP BY c.country_name, z.City
ORDER BY c.country_name, z.City;

---------------------------------------------------------------------------------------------------------------------------------------------------

# 4.Numbers of Resturants opening based on Year , Quarter , Month

SELECT 
    c.Year,
    c.Quarter,
    c.MonthFullName,
    COUNT(z.RestaurantID) AS No_of_Restaurants
FROM zomato_main z
JOIN calendar_table c 
    ON z.Datekey_Opening = c.Datekey
GROUP BY c.Year, c.Quarter, c.MonthFullName, c.MonthNo -- Added MonthNo for sorting
ORDER BY c.Year, c.Quarter, c.MonthNo;

------------------------------------------------------------------------------------------------------------------------------------------------------

# 5. Count of Resturants based on Average Ratings

SELECT 
    Rating, 
    COUNT(RestaurantID) AS No_of_Restaurants
FROM zomato_main
GROUP BY Rating
ORDER BY Rating DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------

# 6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

SELECT 
    CASE 
        WHEN Average_Cost_for_two BETWEEN 0 AND 300 THEN '0 - 500 (Low Cost)'
        WHEN Average_Cost_for_two BETWEEN 301 AND 600 THEN '501 - 1000 (Medium Cost)'
        WHEN Average_Cost_for_two BETWEEN 601 AND 1000 THEN '1001 - 2000 (High Cost)'
        WHEN Average_Cost_for_two BETWEEN 1001 AND 43000 THEN '2001 - 5000 (Luxury)'
        WHEN Average_Cost_for_two > 2000 THEN '5001+ (Ultra Luxury)'
        ELSE 'Other'
    END AS Cost_Bucket,
    COUNT(RestaurantID) AS No_of_Restaurants
FROM zomato_main
GROUP BY Cost_Bucket
ORDER BY No_of_Restaurants DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------

 # 7.Percentage of Resturants based on "Has_Table_booking"

SELECT 
    Has_Table_booking, 
    COUNT(RestaurantID) AS Count_of_Restaurants,
    CONCAT(ROUND(COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM zomato_main), 2), '%') AS Percentage
FROM zomato_main
GROUP BY Has_Table_booking;

-------------------------------------------------------------------------------------------------------------------------------------------------------

# 8.Percentage of Resturants based on "Has_Online_delivery"

SELECT 
    Has_Online_delivery, 
    COUNT(RestaurantID) AS Count_of_Restaurants,
    CONCAT(ROUND(COUNT(RestaurantID) * 100.0 / (SELECT COUNT(*) FROM zomato_main), 2), '%') AS Percentage
FROM zomato_main
GROUP BY Has_Online_delivery;
















