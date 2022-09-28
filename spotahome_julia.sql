/*Select tables*/

SELECT *
FROM spotahome_df_complete sdc;


--------------------------------------------------
SELECT *
FROM spotahome_df_details_complete sddc;


--------------------------------------------------
SELECT *
FROM spotahome_final sf;


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
CREATE TABLE spotahome_final_2 AS
SELECT *
FROM spotahome_df_complete_2 sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;
	   

--------------------------------------------------
ALTER TABLE spotahome_final_2
    ALTER COLUMN platform_id TYPE INT USING platform_id::INT,
    ALTER COLUMN platform TYPE VARCHAR USING platform::VARCHAR,
    ALTER COLUMN neighborhood TYPE VARCHAR USING neighborhood::VARCHAR,
    ALTER COLUMN property_type TYPE VARCHAR USING property_type::VARCHAR,
    ALTER COLUMN housing_type TYPE VARCHAR USING housing_type::VARCHAR,
    ALTER COLUMN price_pcm TYPE INT USING price_pcm::INT,
    ALTER COLUMN title TYPE VARCHAR USING title::VARCHAR,
    ALTER COLUMN furnished TYPE VARCHAR USING furnished::VARCHAR,
    ALTER COLUMN available_from TYPE VARCHAR USING available_from::VARCHAR,
    ALTER COLUMN id TYPE INT USING id::INT,
    ALTER COLUMN bathrooms TYPE INT USING bathrooms::INT,
    ALTER COLUMN m2 TYPE INT USING m2::INT,
    ALTER COLUMN bedrooms TYPE INT USING bedrooms::INT;
   

--------------------------------------------------
ALTER TABLE spotahome_final_2   
	ALTER COLUMN available_from TYPE DATE USING to_timestamp(available_from, 'DD-Month-YYYY');


--------------------------------------------------
UPDATE spotahome_final_2
SET available_from = '2022',
WHERE available_from = '0001';


--------------------------------------------------


--------------------------------------------------


--------------------------------------------------
   
--------------------------------------------------
/*Drop old tables*/

DROP TABLE spotahome_df_details;