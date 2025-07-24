SELECT * FROM [dbo].[googleplaystore]; 

--replacing installs column values
UPDATE [dbo].[googleplaystore]
SET Installs = REPLACE(REPLACE(Installs, '+', ''), ',', '') 

SELECT DISTINCT Installs FROM googleplaystore;

--altered installs column to integer datatype
ALTER TABLE googleplaystore 
ALTER COLUMN Installs INT;

SELECT * FROM googleplaystore;

--updating rating column with null values to average rating
UPDATE googleplaystore
SET Rating = (SELECT AVG(Rating)as Average_rating FROM googleplaystore)
WHERE Rating IS NULL;					 

--Created backup table to store actual values
SELECT * INTO googleplaystore_backup	
FROM googleplaystore; 

SELECT * FROM googleplaystore_backup

--Rounding off rating column to 2 decimals for clarity
UPDATE googleplaystore
SET Rating = ROUND(Rating, 2);			

--Checking null values in type column
SELECT * FROM googleplaystore
WHERE Type IS NULL;						

--Updated Type column having null values with "Free"
UPDATE googleplaystore
SET Type = 'Free'
WHERE Type IS NULL;						

--Checked the Price column to verify the updated column
SELECT DISTINCT Price FROM googleplaystore
ORDER BY Price DESC;					

--Checked datatype of all the columns
SELECT * FROM google_playstore.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'googleplaystore';

--Rounding off the price column with 2 decimals
UPDATE googleplaystore
SET Price = ROUND(Price, 2);			

--updated size column from 'varies with device' value to 0
UPDATE googleplaystore
SET size = 0
WHERE Size =  'Varies with device';	

--Removed whitespace from app, category and content_rating columns
UPDATE googleplaystore
SET app = LTRIM(RTRIM(App)),
	Category = LTRIM(RTRIM(Category)),
	Content_Rating = LTRIM(RTRIM(Content_Rating));	 

--Checked duplicates and kept first occurence of duplicates
WITH CTE_duplicates  AS(							
	SELECT *, ROW_NUMBER() OVER(PARTITION BY App ORDER BY Rating DESC) AS rn
	FROM googleplaystore
)
DELETE FROM CTE_duplicates
WHERE rn > 1;

SELECT * INTO googleplaystore_cleaned FROM googleplaystore;