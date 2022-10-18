-- comment goes here
/* comment goes here */

/* PostGres - SQL - File to manipulate the Data from our Python - Import */



/* Part 1 - Change all the Data - Values, we can easily change
 * https://www.techonthenet.com/postgresql/tables/alter_table.php
 * 
 */

ALTER TABLE capstone_jmrs.blueground_df_main
  ALTER COLUMN platform_id  			TYPE integer USING platform_id::integer,
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
UPDATE capstone_jmrs.blueground_df_main
SET  bedrooms = 1
WHERE bedrooms = '1 Bedroom' ;

UPDATE capstone_jmrs.blueground_df_main
SET  bedrooms = 2
WHERE bedrooms = '2 Bedroom' ;

UPDATE capstone_jmrs.blueground_df_main
SET  bedrooms = 3
WHERE bedrooms = '3 Bedroom' ;

--- Update the property_type to Studio, if the  bedrooms is a Jr. 1 Bedroom

UPDATE capstone_jmrs.blueground_df_main
SET  property_type = 'Studio',
	 bedrooms = 1
WHERE bedrooms = 'Jr. 1 Bedroom' ;

--- we Update the Studio in "Bedroom" to 0 (Zero), to convert them later to Integer or Float
UPDATE capstone_jmrs.blueground_df_main
SET  bedrooms = '0'
WHERE bedrooms = 'Studio' ;


--- Update the property_type to Apartment, if the property_type is Bedroom
UPDATE capstone_jmrs.blueground_df_main
SET  property_type = 'Apartment'
WHERE property_type = 'Bedroom' ;

---- now we will update the bathrooms ----
UPDATE capstone_jmrs.blueground_df_main
SET  bathroom = 1
WHERE bathroom = '1 Bath' ;

UPDATE capstone_jmrs.blueground_df_main
SET  bathroom = 1.5
WHERE bathroom = '1.5 Bath' ;


UPDATE capstone_jmrs.blueground_df_main
SET  bathroom = 2
WHERE bathroom = '2 Bath' ;

UPDATE capstone_jmrs.blueground_df_main
SET  bathroom = 2.5
WHERE bathroom = '2.5 Bath' ;

--- now we want to ALTER the column of Bedrooms to Integer
ALTER TABLE capstone_jmrs.blueground_df_main
  ALTER COLUMN bedrooms  TYPE integer USING (trim(bedrooms)::integer);
  
--- now we want to Alter the column of Bathroom to Float  
ALTER TABLE capstone_jmrs.blueground_df_main
  ALTER COLUMN bathroom  TYPE float USING (trim(bathroom)::float);

 ---- now we want to Alter the column of Price to an Integer
ALTER TABLE capstone_jmrs.blueground_df_main
ALTER COLUMN price_pcm  TYPE integer USING (trim(price_pcm)::integer) ; 
  
 
  /* Part 4 -  We have to Update the Neighboorhouds to make it even with the requirments from Uki
 * currently, we have "String" in this cells
 * https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/
 * 
 */
 --- Update to Hammersmith and Fulham
UPDATE capstone_jmrs.blueground_df_main
SET  neighbourhood = 'Hammersmith and Fulham'
WHERE (neighbourhood = 'Hammersmith') OR (neighbourhood = 'Fulham'); 

 --- Update to Kensington and Chelsea
 UPDATE capstone_jmrs.blueground_df_main
SET  neighbourhood = 'Kensington and Chelsea'
WHERE (neighbourhood = 'Kensington') OR (neighbourhood = 'Chelsea'); 

 --- City of Westminster
 UPDATE capstone_jmrs.blueground_df_main
SET  neighbourhood = 'City of Westminster'
WHERE (neighbourhood = 'Westminster');

 --- Update to Lambeth
 UPDATE capstone_jmrs.blueground_df_main
SET  neighbourhood = 'Lambeth'
WHERE (neighbourhood = 'Stockwell') OR (neighbourhood = 'Vauxhall')OR (neighbourhood = 'Waterloo'); 

 --- Update to Tower of Hamlets
 UPDATE capstone_jmrs.blueground_df_main
SET  neighbourhood = 'Tower of Hamlets'
WHERE (neighbourhood = 'Bromley by Bow') OR (neighbourhood = 'Bromley-by-Bow') OR (neighbourhood = 'Limehouse')OR (neighbourhood = 'Wapping') OR (neighbourhood = 'Whitechapel')OR (neighbourhood = 'Whitechapel/Brick Lane'); 


 /* Part 5 -  We now have to update the Types of the Detail
 * currently, we have "String" in this cells
 * https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/
 * 
 */
 ALTER TABLE capstone_jmrs.blueground_df_details
 ALTER COLUMN  blueground_id_details 	TYPE integer USING blueground_id_details::integer,
 ALTER COLUMN  lotsize			TYPE varchar,
 ALTER COLUMN  value			TYPE float USING (trim(value)::float),
 ALTER COLUMN  caption			TYPE varchar;

 /* Part 6 -  We now create a new table from the Main and Detail-Tables
 * https://stackoverflow.com/questions/14065408/how-do-i-merge-two-tables-in-postgresql
 * 
 */


CREATE TABLE blueground_final AS
SELECT *
FROM capstone_jmrs.blueground_df_main
LEFT JOIN  capstone_jmrs.blueground_df_details
	   ON blueground_df_main.platform_id  = blueground_df_details.blueground_id_details ;
	  
	  
--- DROP an existing table
DROP TABLE IF EXISTS capstone_jmrs.blueground_final ;

--- DROP an existing table
DROP TABLE IF EXISTS  capstone_jmrs.blueground_clean;


--- Create the final table, according to project structure
--- we will use the "capstone_jmrs.blueground_final", because it has all columns
CREATE TABLE IF NOT EXISTS blueground_clean AS
SELECT 
	platform_id AS platform_id, 
	platform AS platform,
	neighbourhood AS neigbourhood,
	property_type AS property_type,
	title AS title,
	furniture AS furniture,
	let_type AS let_type,
	available_today AS available_today,
	scraping_date_main AS scraping_date,
	bathroom AS bathrooms,
	size_sqm AS size_sqm,
	bedrooms AS bedrooms,
	available_from AS available_from,
	price_pcm AS price_pcm,
	price_per_sqm AS price_per_sqm,
	price_per_bedroom AS price_per_bedroom
FROM capstone_jmrs.blueground_eda_cleaned ;

--- Change Column-Type to final structure:

 ALTER TABLE capstone_jmrs.blueground_clean
 ALTER COLUMN   platform_id	TYPE TEXT ,
  ALTER COLUMN   platform	TYPE TEXT ,
   ALTER COLUMN   neigbourhood 		TYPE TEXT ,
    ALTER COLUMN   property_type	TYPE TEXT ,
     ALTER COLUMN   title		TYPE TEXT ,
      ALTER COLUMN   furniture	TYPE TEXT ,
       ALTER COLUMN   let_type	TYPE TEXT ,
        ALTER COLUMN  available_today 	TYPE TEXT ,
		 ALTER COLUMN  	bathrooms		TYPE  float USING bathrooms::float,
		  ALTER COLUMN  	bedrooms		TYPE  float USING bedrooms::float,
		   ALTER COLUMN  	size_sqm		TYPE  float USING size_sqm::float,
		    ALTER COLUMN  	price_pcm		TYPE  float USING price_pcm::float,
		     ALTER COLUMN  	price_per_sqm	TYPE  float USING price_per_sqm::float,
		      ALTER COLUMN  	price_per_bedroom		TYPE  float USING price_per_bedroom::float ;
		     
-------
select 
    row_number() over () as id, 
    *
 FROM blueground_clean bc ;
 ---

-- Update to Camden

 UPDATE capstone_jmrs.blueground_clean
SET   neigbourhood= 'Camden'
WHERE ( neigbourhood= 'Camden Town');

--- Update to Tower Hamlets	
 UPDATE capstone_jmrs.blueground_clean
SET  neigbourhood = 'Tower Hamlets'
WHERE ( neigbourhood = 'Tower of Hamlets') ;


--- Change Platform to UPPER-Case in the first letter
UPDATE capstone_jmrs.blueground_clean
SET  platform = 'Blueground'
WHERE ( platform = 'blueground');


UPDATE capstone_jmrs.blueground_clean
SET  available_today = 'occupied'
WHERE ( available_today = 'Occupied');

---- round the Prices to two decimals after comma
SELECT 
	 ROUND(price_per_sqm ::numeric, 2 )
FROM capstone_jmrs.platforms_complete;

UPDATE capstone_jmrs.platforms_complete
SET price_per_sqm =  ROUND(price_per_sqm ::numeric, 2 ) ;

UPDATE capstone_jmrs.platforms_complete
SET price_per_bedroom =  ROUND(price_per_bedroom::numeric, 2 ) ;

UPDATE capstone_jmrs.platforms_complete
SET price_per_bedroom =  ROUND(price_pcm::numeric, 2 ) 
WHERE  price_per_bedroom = 'Infinity' ;
----

UPDATE capstone_jmrs.blueground_clean
SET let_type = NULL 
WHERE let_type = '';


---
DROP TABLE IF EXISTS capstone_jmrs.blueground_clean;


----  We now create a new table from the worked EDA data

CREATE TABLE IF NOT EXISTS blueground_clean AS
SELECT 
	platform_id AS platform_id, 
	platform AS platform,
	neighbourhood AS neighbourhood,
	furniture AS furniture,	
	property_type AS property_type,
	size_sqm AS size_sqm,
	bedrooms AS bedrooms,
	bathroom AS bathrooms,
	price_pcm AS price_pcm,
	price_per_sqm AS price_per_sqm,
	price_per_bedroom AS price_per_bedroom,
	available_from AS available_from,
	available_today AS available_today,
	let_type AS let_type,
	scraping_date_main AS scraping_date
FROM capstone_jmrs.blueground_eda_cleaned ;


---- # Change Column-Type to final structure:

 ALTER TABLE {schema}.blueground_clean
 ALTER COLUMN   platform_id	TYPE TEXT ,
  ALTER COLUMN   platform	TYPE TEXT ,
   ALTER COLUMN   neighbourhood 	    TYPE TEXT ,
    ALTER COLUMN   property_type	TYPE TEXT ,
      ALTER COLUMN   furniture	TYPE TEXT ,
       ALTER COLUMN   let_type	TYPE TEXT ,
        ALTER COLUMN  available_today 	TYPE TEXT ,
		 ALTER COLUMN  	bathrooms		    TYPE  float USING bathrooms::float,
		  ALTER COLUMN  	bedrooms		TYPE  float USING bedrooms::float,
		   ALTER COLUMN  	size_sqm		TYPE  float USING size_sqm::float,
		    ALTER COLUMN  	price_pcm		TYPE  float USING price_pcm::float,
		     ALTER COLUMN  	price_per_sqm	TYPE  float USING price_per_sqm::float,
		      ALTER COLUMN  	price_per_bedroom		TYPE  float USING price_per_bedroom::float ;
		     
------
 UPDATE capstone_jmrs.platforms_complete
SET   neighbourhood = 'Camden'
WHERE ( neighbourhood= 'Camden Town');

--- Update to Tower Hamlets	
 UPDATE capstone_jmrs.platforms_complete
SET  neighbourhood = 'Tower Hamlets'
WHERE ( neighbourhood = 'Tower of Hamlets') ;


--- Change Platform to UPPER-Case in the first letter
UPDATE capstone_jmrs.platforms_complete
SET  platform = 'Blueground'
WHERE ( platform = 'blueground');


UPDATE capstone_jmrs.platforms_complete
SET  available_today = 'occupied'
WHERE ( available_today = 'Occupied');
