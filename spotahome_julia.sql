/*Select tables*/

SELECT *
FROM spotahome_df_complete sdc;


--------------------------------------------------
SELECT *
FROM spotahome_df_details_complete sddc;


--------------------------------------------------
SELECT *
FROM spotahome_final_3
WHERE platform_id = '601114';


--------------------------------------------------
SELECT *
FROM spotahome_final_2 sf
ORDER BY available_from;


--------------------------------------------------
SELECT *
FROM spotahome_final_2 sf;


--------------------------------------------------
SELECT *
FROM rightmove_1 r;


--------------------------------------------------
SELECT *
FROM rightmove_details_julia rdj;


--------------------------------------------------
SELECT *
FROM spotahome_df_complete_available_from sdcaf;


--------------------------------------------------
--------------------------------------------------
SELECT *
FROM spotahome_df_details_complete sddc
ORDER BY details;


--------------------------------------------------
SELECT COUNT(*)
FROM spotahome_df_complete sdc;


--------------------------------------------------
SELECT *
FROM spotahome_df_complete sdc  
ORDER BY property_type;


--------------------------------------------------
SELECT *
FROM spotahome_df_complete sdc 
ORDER BY platform_id ;

--------------------------------------------------
SELECT *
FROM spotahome_df_complete sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;


--------------------------------------------------
--------------------------------------------------
/* create the new colum final witch includes df_complete and df_details_complete
Change all the dataypes from text to int/carchar/datetime*/

CREATE TABLE spotahome_final AS
SELECT *
FROM spotahome_df_complete sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;


--------------------------------------------------
ALTER TABLE spotahome_final 
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR USING platform::VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR USING neighborhood::VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR USING property_type::VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR USING housing_type::VARCHAR,
    --price_pcm
    ALTER COLUMN title TYPE VARCHAR USING title::VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR USING furnished::VARCHAR,
    --available from
    ALTER COLUMN id TYPE INT USING id::INT,
    ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
    ALTER COLUMN m2 TYPE INT USING m2::INT,
    ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT;
  

--------------------------------------------------
--------------------------------------------------
CREATE TABLE spotahome_final_2 AS
SELECT *
FROM spotahome_df_complete_2 sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;
	   

--------------------------------------------------
ALTER TABLE spotahome_final_3
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR USING platform::VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR USING neighborhood::VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR USING property_type::VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR USING housing_type::VARCHAR,
    ALTER COLUMN price_pcm TYPE INT USING price_pcm::INT,
    ALTER COLUMN title TYPE VARCHAR USING title::VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR USING furnished::VARCHAR,
    ALTER COLUMN available_from_total TYPE DATE USING available_from::DATE,
    ALTER COLUMN id TYPE INT USING id::INT,
    ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
    ALTER COLUMN m2 TYPE INT USING m2::INT,
    ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT;
   

--------------------------------------------------
ALTER TABLE spotahome_final_2   
	ALTER COLUMN available_from TYPE DATE USING to_timestamp(available_from, 'DD-Month-YYYY');


--------------------------------------------------
SELECT DISTINCT(DATE_PART('year', available_from))
FROM spotahome_final_2;


--------------------------------------------------
UPDATE spotahome_final_2
SET available_from = available_from + 
    MAKE_INTERVAL(YEARS := 2022 - EXTRACT(YEAR FROM available_from)::INTEGER);
   

--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------   
--------------------------------------------------
SELECT *
FROM spotahome_final_3
--WHERE bedrooms ='4';
ORDER BY bedrooms;
--WHERE property_type = 'studios';

--------------------------------------------------
CREATE TABLE spotahome_final_3 AS
SELECT *
FROM spotahome_df_complete_available_from sdcaf 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdcaf.platform_id = sddc.id;


--------------------------------------------------
/*SELECT 
COALESCE(available_from_2, '2022')
FROM spotahome_final_3 sf;*/


--------------------------------------------------
UPDATE spotahome_final_3
SET
available_from_2 = COALESCE(available_from_2, '2022');


--------------------------------------------------
/*ALTER TABLE spotahome_final_3  
	ALTER COLUMN available_from_0 TYPE VARCHAR USING available_from::VARCHAR,
	ALTER COLUMN available_from_1 TYPE VARCHAR USING available_from::VARCHAR,
	ALTER COLUMN available_from_2 TYPE VARCHAR USING available_from::VARCHAR;*/


--------------------------------------------------
/*SELECT available_from_0,
		available_from_1,
		available_from_2,*/
		
		
--------------------------------------------------		
/*ALTER TABLE spotahome_final_3  
	ALTER COLUMN available_from_0 TYPE DATE USING to_timestamp(available_from, 'DD'),
	ALTER COLUMN available_from_1 TYPE DATE USING to_timestamp(available_from, 'Month'),
	ALTER COLUMN available_from_2 TYPE DATE USING to_timestamp(available_from, 'YYYY');*/


--------------------------------------------------	
ALTER TABLE spotahome_final_3
  ADD available_from_total VARCHAR;

ALTER TABLE spotahome_final_3
  ADD let_type VARCHAR;
 
--------------------------------------------------	
UPDATE spotahome_final_3 
	SET available_from_total = available_from_0 || '-' || available_from_1 || '-' || available_from_2;


--------------------------------------------------
ALTER TABLE spotahome_final_3
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR,-- USING platform::VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR,-- USING neighborhood::VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR,-- USING property_type::VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR,-- USING housing_type::VARCHAR,
    ALTER COLUMN price_pcm TYPE INT USING price_pcm::INT,
    ALTER COLUMN title TYPE VARCHAR,-- USING title::VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR,-- USING furnished::VARCHAR,
    ALTER COLUMN available_from_total TYPE DATE USING available_from_total::DATE,
    ALTER COLUMN id TYPE INT USING id::INT,
    ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
    ALTER COLUMN m2 TYPE INT USING m2::INT,
    ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT;
   
   
--------------------------------------------------
ALTER TABLE spotahome_final_3
  DROP COLUMN available_from,
  DROP COLUMN available_from_0,
  DROP COLUMN available_from_1,
  DROP COLUMN available_from_2,
  DROP COLUMN id;
  --DROP COLUMN property_type;

--------------------------------------------------
UPDATE spotahome_final_3
SET m2 = NULL
WHERE m2 = '1'
	OR m2 = '3'
	OR m2 = '8'
	OR m2 = '1000';


--------------------------------------------------
ALTER TABLE spotahome_final_3
	RENAME COLUMN available_from_total TO available_from;
	
ALTER TABLE spotahome_final_3
	RENAME COLUMN furnished TO furniture;

ALTER TABLE spotahome_final_3
	RENAME COLUMN m2 TO size_sqm;

ALTER TABLE spotahome_final_3
	RENAME COLUMN housing_type TO property_type;


--------------------------------------------------
UPDATE spotahome_final_3
SET bedrooms = COALESCE(bedrooms, '0')
WHERE property_type = 'studios';

UPDATE spotahome_final_3
SET bedrooms = COALESCE(bedrooms, '1')
WHERE property_type = 'apartments/bedrooms:1';

UPDATE spotahome_final_3
SET bedrooms = COALESCE(bedrooms, '2')
WHERE property_type = 'apartments/bedrooms:2';

UPDATE spotahome_final_3
SET bedrooms = COALESCE(bedrooms, '3')
WHERE property_type = 'apartments/bedrooms:3';


--------------------------------------------------
--------------------------------------------------
SELECT *
FROM spotahome_eda se 
--WHERE neighborhood = 'City of Westminster'
ORDER BY size_sqm;




--------------------------------------------------
--------------------------------------------------
/*Drop old tables*/

DROP TABLE spotahome_final_3;
DROP TABLE spotahome_eda;
DROP TABLE capstone_jmrs.rightmove_details_julia;
DROP TABLE capstone_jmrs.rightmove_details_julia_2;
DROP TABLE capstone_jmrs.spotahome_df_complete;
DROP TABLE capstone_jmrs.spotahome_df_complete_2;
DROP TABLE capstone_jmrs.spotahome_clean;