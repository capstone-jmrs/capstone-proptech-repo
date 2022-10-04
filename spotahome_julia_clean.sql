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
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR,
    ALTER COLUMN title TYPE VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR,
    ALTER COLUMN let_type TYPE VARCHAR,
    --available_today
    ALTER COLUMN scraping_date TYPE DATE USING scraping_date::DATE,
    ALTER COLUMN price_pcm_0 TYPE INT USING price_pcm_0::INT,
    ALTER COLUMN price_pcm_1 TYPE INT USING price_pcm_1::INT,
    ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
    ALTER COLUMN m2 TYPE INT USING m2::INT,
    ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT,
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
	DROP COLUMN housing_type;


--------------------------------------------------
SELECT *
FROM spotahome_merged
WHERE bedrooms IS NULL;

--------------------------------------------------
--DROP TABLE spotahome_merged;