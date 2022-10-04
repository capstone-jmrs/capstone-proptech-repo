--1
UPDATE rightmove_details_0
SET bedrooms = 0
WHERE property_type = 'Studio'; --266 updated

UPDATE rightmove_details_0
SET bedrooms = NULL
WHERE bedrooms = 'NA'; --159 updated

UPDATE rightmove_details_0
SET bathrooms = NULL
WHERE bathrooms = 'NA'; --336 updated


ALTER TABLE rightmove_details_0
RENAME COLUMN "size" TO size_sqm;

UPDATE rightmove_details_0
SET size_sqm = NULL 
WHERE size_sqm = 'NA'; --4982 updated


--2a
SELECT * 
FROM
rightmove_details_0
WHERE size_sqm LIKE '%-%';

SELECT COUNT(*) FROM rightmove_3;

--2b
SELECT 	LEFT(size_sqm, 4),
		size_sqm
FROM rightmove_details_0
WHERE size_sqm LIKE '%-%';



SELECT 	LEFT(size_sqm, pos_minus),
		size_sqm
FROM SELECT POSITION('-' IN size_sqm) AS pos_minus
FROM rightmove_details_0
WHERE size_sqm LIKE '%-%';


/* not yet working
 * 
UPDATE rightmove_test
SET size_sqm = 
	(SELECT 	LEFT(size_sqm, (pos_minus - 1))
	FROM 		(SELECT POSITION('-' IN size_sqm) AS pos_minus
				FROM rightmove_test AS f
				WHERE size_sqm LIKE '%-%' ) f2)
WHERE size_sqm LIKE '%-%';


SELECT 	LEFT(size_sqm, (pos_minus - 1)),
		size_sqm
FROM 		(SELECT POSITION('-' IN size_sqm) AS pos_minus,
			size_sqm
			FROM rightmove_details_0) AS iner
WHERE size_sqm LIKE ('%-%');


CREATE TABLE rightmove_test AS (SELECT * FROM rightmove_details_0);

SELECT *
FROM rightmove_details_0
*/

ALTER TABLE rightmove_details_0
ALTER COLUMN size_sqm TYPE INT USING size_sqm::INT;
--

-- 4 DATA TYPES
ALTER TABLE rightmove_details_0
ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT;

ALTER TABLE rightmove_details_0
ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT;

ALTER TABLE rightmove_details_0
ALTER COLUMN property_type TYPE VARCHAR;

ALTER TABLE rightmove_details_0
ALTER COLUMN let_type TYPE VARCHAR;

ALTER TABLE rightmove_details_0
ALTER COLUMN furnished TYPE VARCHAR;



.
.
.



--5 availability
ALTER TABLE rightmove_details_0
ADD available_today VARCHAR;

UPDATE rightmove_details_0
SET available_today = 'available'
WHERE available_from = 'Now';

UPDATE rightmove_details_0
SET available_today = 'occupied'
WHERE available_from != 'Now';

UPDATE rightmove_details_0
SET available_today = 'unclear'
WHERE available_from = 'Ask agent'; --2557x 'unclear'



--6 furniture
ALTER TABLE rightmove_details_0
RENAME COLUMN furnished TO furnished_orig;

ALTER TABLE rightmove_details_0
ADD COLUMN furniture VARCHAR;

UPDATE rightmove_details_0 
SET furniture = 'Furnished'
WHERE furnished_orig = 'Furnished';

UPDATE rightmove_details_0 
SET furniture = 'Unfurnished'
WHERE furnished_orig = 'Unfurnished';


UPDATE rightmove_details_0
SET furniture = 'Furnished'
WHERE furnished_orig  = 'Furnished or unfurnished, landlord is flexible'; --updated 1410 ROWS

UPDATE rightmove_details_0
SET furniture = 'Unfurnished'
WHERE furnished_orig = 'Part furnished'; --updated 474 ROWS







--7 simple prop type

DELETE FROM rightmove_details_0
WHERE property_type IN ('Parking', 'Garages', 'Serviced Apartments'); --28 deleted

ALTER TABLE rightmove_details_0
ADD COLUMN simple_prop_type VARCHAR;

UPDATE rightmove_details_0
SET simple_prop_type = property_type;

UPDATE rightmove_details_0
SET simple_prop_type = 'Other'
WHERE property_type NOT IN ('Studio', 'Apartment'); --4015 updated

UPDATE rightmove_details_0 
SET simple_prop_type = 'Other'
WHERE property_type 

SELECT * FROM rightmove_details_0 rd WHERE simple_prop_type ISNULL;
/*WHERE property_type IN ('Town House', 'House', 'Flat', 'Apartment', 'Penthouse', 'Maisonette',
						'Terraced', 'Cottage', 'Detached', 'Semi-Detached', 'NA', 'Mews', 'Duplex', 
						'Link Detached House', 'House of Multiple Occupation', 'End of Terrace');
*/
					
/*
SELECT 	(property_type),
		COUNT (property_type)
FROM rightmove_details_0
GROUP BY 1
ORDER BY COUNT;
*/

SELECT COUNT(platform_id) AS c,
	platform_id,
	property_type,
	bedrooms
FROM rightmove_details_0
GROUP BY 2, 3, 4
HAVING COUNT(platform_id) > 1;

SELECT * FROM rightmove_details_0 WHERE platform_id = '127151582';
		
SELECT * FROM rightmove_details_0 rd WHERE bedrooms ISNULL;

--8 PRICES
UPDATE rightmove_3
SET prices_pcm = NULL
WHERE prices_pcm = 'POA'; --1 updated

ALTER TABLE rightmove_3
ALTER COLUMN prices_pcm TYPE INT USING prices_pcm::INT;



