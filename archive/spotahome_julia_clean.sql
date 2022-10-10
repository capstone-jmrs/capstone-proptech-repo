--------------------------------------------------
CREATE TABLE spotahome_merged AS
SELECT *
FROM spotahome_df_complete_available_from sdcaf
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdcaf.platform_id = sddc.id;


--------------------------------------------------
UPDATE spotahome_merged
	SET available_from_2 = COALESCE(available_from_2, '2022');

ALTER TABLE spotahome_merged
	ADD available_from_total VARCHAR;

 UPDATE spotahome_merged 
	SET available_from_total = available_from_0 || '-' || available_from_1 || '-' || available_from_2;


--------------------------------------------------
ALTER TABLE spotahome_merged
    ALTER COLUMN platform_id TYPE VARCHAR,
    ALTER COLUMN platform TYPE VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR,
    ALTER COLUMN title TYPE VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR,
    ALTER COLUMN let_type TYPE VARCHAR,
    --available_today
    ALTER COLUMN scraping_date TYPE DATE USING scraping_date::DATE,
    ALTER COLUMN price_pcm_0 TYPE FLOAT USING price_pcm_0::FLOAT,
    ALTER COLUMN price_pcm_1 TYPE FLOAT USING price_pcm_1::FLOAT,
    ALTER COLUMN bathrooms TYPE FLOAT USING bathrooms::FLOAT,
    ALTER COLUMN m2 TYPE FLOAT USING m2::FLOAT,
    ALTER COLUMN bedrooms TYPE FLOAT USING bedrooms::FLOAT,
    ALTER COLUMN available_from_total TYPE DATE USING available_from_total::DATE;
   
   
--------------------------------------------------
ALTER TABLE spotahome_merged
  DROP COLUMN available_from,
  DROP COLUMN available_from_0,
  DROP COLUMN available_from_1,
  DROP COLUMN available_from_2,
  DROP COLUMN id;

 
--------------------------------------------------
UPDATE spotahome_merged
SET m2 = NULL
WHERE m2 = '1'
	OR m2 = '3'
	OR m2 = '8'
	OR m2 = '1000';


--------------------------------------------------
ALTER TABLE spotahome_merged
	RENAME COLUMN available_from_total TO available_from;
	
ALTER TABLE spotahome_merged
	RENAME COLUMN furnished TO furniture;

ALTER TABLE spotahome_merged
	RENAME COLUMN m2 TO size_sqm;

ALTER TABLE spotahome_merged
	RENAME COLUMN neighborhood TO neighbourhood;

--------------------------------------------------
UPDATE spotahome_merged
SET bedrooms = COALESCE(bedrooms, '0')
WHERE housing_type = 'studios';

UPDATE spotahome_merged
SET bedrooms = COALESCE(bedrooms, '1')
WHERE housing_type = 'apartments/bedrooms:1';

UPDATE spotahome_merged
SET bedrooms = COALESCE(bedrooms, '2')
WHERE housing_type = 'apartments/bedrooms:2';

UPDATE spotahome_merged
SET bedrooms = COALESCE(bedrooms, '3')
WHERE housing_type = 'apartments/bedrooms:3';

UPDATE spotahome_merged
SET bedrooms = COALESCE(bedrooms, '4')
WHERE housing_type = 'apartments/bedrooms:3more';

ALTER TABLE spotahome_merged
	DROP COLUMN housing_type,
	DROP COLUMN title;


--------------------------------------------------
 UPDATE spotahome_merged
	SET available_today = CASE 
      						WHEN available_from = '2022-10-05'  THEN 'available'
      						ELSE 'occupied'
						  END;
						 
						 
--------------------------------------------------						 
UPDATE spotahome_merged
SET let_type = NULL 
WHERE let_type = '';
			
						 
--------------------------------------------------						 
CREATE TABLE IF NOT EXISTS capstone_jmrs.spotahome_clean AS
SELECT 
	platform_id, 
	platform,
	neighbourhood,
	furniture,
	property_type,
	size_sqm,
	bedrooms,
	bathrooms,
	price_pcm,
	price_per_sqm,
	price_per_bedroom,
	available_from,
	available_today,
	let_type,
	scraping_date	
FROM capstone_jmrs.spotahome_eda;
						 
						 
--UPDATE spotahome_clean
--SET let_type = NULL 
--WHERE let_type = '';						 
						 

 
--------------------------------------------------
--DROP TABLE spotahome_merged;
--DROP TABLE spotahome_eda;
--DROP TABLE spotahome_clean;
--DROP TABLE platforms_complete;
						 
						 
						 
						 
						 
						 
						 
						 
						 