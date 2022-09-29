-- comment goes here
/* comment goes here */

/* PostGres - SQL - File to manipulate the Data from our Python - Import */



/* Part 1 - Change all the Data - Values, we can easily change
 * https://www.techonthenet.com/postgresql/tables/alter_table.php
 * 
 */

ALTER TABLE capstone_jmrs.blueground_df_complete
  ALTER COLUMN blueground_id  			TYPE integer USING blueground_id::integer,
  ALTER COLUMN platform 				TYPE varchar,
  ALTER COLUMN neighbourhood 			TYPE varchar,
  ALTER COLUMN property_type 			TYPE varchar,
  ALTER COLUMN title 					TYPE varchar,
  ALTER COLUMN furnished 				TYPE varchar,
  ALTER COLUMN get_url_to_detail_page 	TYPE varchar,
  ALTER COLUMN available_from 			TYPE date USING available_from::date ;

  

/* Part 2 -  We have to edit the values from "BedRooms, BathRooms and Price_Pcm" to convert it to an integer or float
 * currently, we have "String" in this cells
 * https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/
 * 
 */

 --- We change the Values of the Bedrooms
UPDATE capstone_jmrs.blueground_df_complete
SET  bedrooms = 1
WHERE bedrooms = '1 Bedroom' ;

UPDATE capstone_jmrs.blueground_df_complete
SET  bedrooms = 2
WHERE bedrooms = '2 Bedroom' ;

UPDATE capstone_jmrs.blueground_df_complete
SET  bedrooms = 3
WHERE bedrooms = '3 Bedroom' ;

--- Update the property_type to Studio, if the  bedrooms is a Jr. 1 Bedroom

UPDATE capstone_jmrs.blueground_df_complete
SET  property_type = 'Studio',
	 bedrooms = 1
WHERE bedrooms = 'Jr. 1 Bedroom' ;

--- we Update the Studio in "Bedroom" to 0 (Zero), to convert them later to Integer or Float
UPDATE capstone_jmrs.blueground_df_complete
SET  bedrooms = '0'
WHERE bedrooms = 'Studio' ;


--- Update the property_type to Apartment, if the property_type is Bedroom
UPDATE capstone_jmrs.blueground_df_complete
SET  property_type = 'Apartment'
WHERE property_type = 'Bedroom' ;

---- now we will update the bathrooms ----
UPDATE capstone_jmrs.blueground_df_complete
SET  bathroom = 1
WHERE bathroom = '1 Bath' ;

UPDATE capstone_jmrs.blueground_df_complete
SET  bathroom = 1.5
WHERE bathroom = '1.5 Bath' ;


UPDATE capstone_jmrs.blueground_df_complete
SET  bathroom = 2
WHERE bathroom = '2 Bath' ;

UPDATE capstone_jmrs.blueground_df_complete
SET  bathroom = 2.5
WHERE bathroom = '2.5 Bath' ;

--- now we want to ALTER the column of Bedrooms to Integer
ALTER TABLE capstone_jmrs.blueground_df_complete
  ALTER COLUMN bedrooms  TYPE integer USING (trim(bedrooms)::integer);
  
--- now we want to Alter the column of Bathroom to Float  
ALTER TABLE capstone_jmrs.blueground_df_complete
  ALTER COLUMN bathroom  TYPE float USING (trim(bathroom)::float);

 ---- now we want to Alter the column of Price to an Integer
ALTER TABLE capstone_jmrs.blueground_df_complete
ALTER COLUMN price_pcm  TYPE integer USING (trim(price_pcm)::integer) ; 
  
 
  /* Part 4 -  We have to Update the Neighboorhouds to make it even with the requirments from Uki
 * currently, we have "String" in this cells
 * https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/
 * 
 */
 --- Update to Hammersmith and Fulham
UPDATE capstone_jmrs.blueground_df_complete
SET  neighbourhood = 'Hammersmith and Fulham'
WHERE (neighbourhood = 'Hammersmith') OR (neighbourhood = 'Fulham'); 

 --- Update to Kensington and Chelsea
 UPDATE capstone_jmrs.blueground_df_complete
SET  neighbourhood = 'Kensington and Chelsea'
WHERE (neighbourhood = 'Kensington') OR (neighbourhood = 'Chelsea'); 

 --- City of Westminster
 UPDATE capstone_jmrs.blueground_df_complete
SET  neighbourhood = 'City of Westminster'
WHERE (neighbourhood = 'Westminster');

 --- Update to Lambeth
 UPDATE capstone_jmrs.blueground_df_complete
SET  neighbourhood = 'Lambeth'
WHERE (neighbourhood = 'Stockwell') OR (neighbourhood = 'Vauxhall')OR (neighbourhood = 'Waterloo'); 

 --- Update to Tower of Hamlets
 UPDATE capstone_jmrs.blueground_df_complete
SET  neighbourhood = 'Lambeth'
WHERE (neighbourhood = 'Bromley-by-Bow') OR (neighbourhood = 'Limehouse')OR (neighbourhood = 'Wapping') OR (neighbourhood = 'Whitechapel')OR (neighbourhood = ' Whitechapel/Brick Lane'); 


 