sql = f"""
CREATE TABLE {schema}.rightmove_complete AS
TABLE {schema}.rightmove_complete_{cycle_number};
"""
result = engine.execute(sql)

--1
sql = f"""
UPDATE {schema}.rightmove_complete
SET  bedrooms = 0
WHERE detailed_property_type = 'Studio' ;
""" 
result = engine.execute(sql)
----

sql = f"""
UPDATE {schema}.rightmove_complete
SET  bedrooms = NULL
WHERE bedrooms = 'NA' ;
""" 
result = engine.execute(sql)
---
sql = f"""
UPDATE {schema}.rightmove_complete
SET bathrooms = NULL
WHERE bathrooms = 'NA';
""" 
result = engine.execute(sql)
---

sql = f"""
UPDATE {schema}.rightmove_complete
SET size_sqm = NULL
WHERE size_sqm = 'NA';
""" 
result = engine.execute(sql)

---

-------------
-------------
-- SELECT * 
-- FROM
-- rightmove_details_0
-- WHERE size_sqm LIKE '%-%';

-- SELECT 	LEFT(size_sqm, 4),
-- 		size_sqm
-- FROM rightmove_details_0
-- WHERE size_sqm LIKE '%-%';

-- SELECT 	LEFT(size_sqm, pos_minus),
-- 		size_sqm
-- FROM SELECT POSITION('-' IN size_sqm) AS pos_minus
-- FROM rightmove_details_0
-- WHERE size_sqm LIKE '%-%';

-- -- #### Alternative: ####
-- sql = f"""
-- DELETE FROM {schema}.rightmove_complete
-- WHERE size_sqm LIKE '%-%';
-- """


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
*/
------------
------------

--8 PRICES
sql = f"""
UPDATE {schema}.rightmove_complete
SET price = NULL
WHERE price = 'POA';
"""
result = engine.execute(sql)

sql = f"""
ALTER TABLE {schema}.rightmove_complete
ALTER COLUMN price TYPE INT USING price::INT;
"""
result = engine.execute(sql)


-- 4 DATA TYPES
sql = f"""
ALTER TABLE {schema}.rightmove_complete
RENAME COLUMN detailed_property_type TO property_type;
"""
result = engine.execute(sql)
---####---#
-- CUT IN Notebook Script (for calculations)
---###---#
sql = f"""
ALTER TABLE {schema}.rightmove_complete
ALTER COLUMN size_sqm TYPE INT USING size_sqm::INT,
ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT,
ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
ALTER COLUMN property_type TYPE VARCHAR,
ALTER COLUMN let_type TYPE VARCHAR,
ALTER COLUMN detailed_furniture TYPE VARCHAR,
ALTER COLUMN scraping_date TYPE DATE USING scraping_date::DATE;
"""
result = engine.execute(sql)
-------------
-- ## available_from possible values: date, 'Now', 'Ask agent', NULL
--availability
sql = f"""
ALTER TABLE {schema}.rightmove_complete
ADD available_today VARCHAR;
"""
result = engine.execute(sql)
------------------------------------------------------------
--####### needs to be modified (next 30 days?! #######)
sql = f"""
UPDATE {schema}.rightmove_complete
SET available_today = 'available'
WHERE available_from = 'Now';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET available_today = 'occupied'
WHERE available_from != 'Now';
"""
result = engine.execute(sql)
--####### needs to be modified (next 30 days?! #######)
------------------------------------------------------------
sql = f"""
UPDATE {schenma}.rightmove_complete
SET available_today = 'unclear'
WHERE available_from = 'Ask agent';
""" --2557x 'unclear' in first table 2 weeks ago
result = engine.execute(sql)

sql = f"""
DELETE FROM {schema}.rightmove_complete
WHERE bedrooms IS NULL;
"""
result = engine.execute(sql)

--furniture

sql =  f"""
DELETE FROM {schema}.rightmove_complete
WHERE detailed_furniture IS NULL
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET detailed_furniture = 'furnished'
WHERE detailed_furniture = 'Furnished';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET detailed_furniture = 'unfurnished'
WHERE detailed_furniture = 'Unfurnished';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET detailed_furniture = 'flexible'
WHERE detailed_furniture = 'Furnished or unfurnished, landlord is flexible';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET detailed_furniture = 'part furnished'
WHERE detailed_furniture = 'Part furnished';
"""
result = engine.execute(sql)
-------------

--Add column furniture which holds simplified furniture values
sql = f"""
ALTER TABLE {schema}.rightmove_complete
ADD COLUMN furniture VARCHAR;
"""
result = engine.execute(sql)
---
sql = f"""
UPDATE {schema}.rightmove_complete
SET furniture = detailed_furniture
WHERE detailed_furniture = 'furnished' OR detailed_furniture = 'unfurnished';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET furniture = 'furnished'
WHERE detailed_furniture = 'flexible';
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET furniture = 'unfurnished'
WHERE detailed_furniture = 'part furnished';
"""
result = engine.execute(sql)
-------------

----

-- delete all rows that don't fit our targeted property_types
sql =  f"""
DELETE FROM {schema}.rightmove_complete
WHERE property_type NOT IN ('Flat', 'Apartment', 'Studio', 'Penthouse', 'Ground Flat', 'Block of Apartments')
"""
result = engine.execute(sql)


------ Availability
sql = f"""
UPDATE {schema}.rightmove_complete
SET available_from = NULL
WHERE available_from = 'Ask agent'; 
"""
result = engine.execute(sql)

sql = f"""
UPDATE {schema}.rightmove_complete
SET available_from = to_char(now(), 'DD/MM/YYYY')
WHERE available_from = 'Now';
"""
result = engine.execute(sql)
-- 2136 Updated

sql = f"""
UPDATE {schema}.rightmove_complete
ALTER COLUMN available_from TYPE DATE USING TO_DATE(available_from, 'DD/MM/YYYY');
"""
result = engine.execute(sql)
----------------
----------------


--rightmove_clean
---#-#-#- create missing columns like price_sqm, price_bedroom

--'final' platform table - ready to be merged
sql = f"""
CREATE TABLE {schema}.rightmove_clean AS
SELECT
	platform_id,
	platform,
	neighbourhood,
	furniture,
	property_type,
	size_sqm,
	bedrooms,
	bathrooms,
	price,
	price_sqm,
	price_bedroom,
	available_from,
	available_today,
	let_type,
	detailed_furniture,
	scraping_date
FROM rightmove_complete;
"""
result = engine.execute(sql)	
	

-----####----
UPDATE rightmove_clean
SET price_per_sqm = ROUND(price_per_sqm::numeric, 2);

UPDATE rightmove_clean
SET price_per_bedroom = price_pcm
WHERE price_per_bedroom = 'Infinity';

SELECT * FROM rightmove_clean WHERE price_per_bedroom = 'Infinity';

UPDATE rightmove_clean
SET price_per_bedroom = ROUND(price_per_bedroom::numeric, 2);
	








