--------------------------------------------------
CREATE TABLE spotahome_final_3 AS
SELECT *
FROM spotahome_df_complete_available_from sdcaf 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdcaf.platform_id = sddc.id;


--------------------------------------------------
UPDATE spotahome_final_3
SET
available_from_2 = COALESCE(available_from_2, '2022');


--------------------------------------------------	
ALTER TABLE spotahome_final_3
  ADD available_from_total VARCHAR;


 
--------------------------------------------------	
UPDATE spotahome_final_3 
	SET available_from_total = available_from_0 || '-' || available_from_1 || '-' || available_from_2;


--------------------------------------------------
ALTER TABLE spotahome_final_3
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR,
    ALTER COLUMN price_pcm TYPE INT USING price_pcm::INT,
    ALTER COLUMN title TYPE VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR,
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

--ALTER TABLE spotahome_final_3
	--RENAME COLUMN housing_type TO property_type;


--------------------------------------------------
SELECT *
FROM spotahome_final_3 sf
ORDER BY available_from;