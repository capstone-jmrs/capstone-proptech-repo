/* comment goes here */

/* PostGres - SQL - File to manipulate the DETAIL-Data from our Python - Import */


 
 /* Part 3 -  We now have to update the Types of the Detail
 * currently, we have "String" in this cells
 * https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/
 * 
 */
 ALTER TABLE capstone_jmrs.blueground_df_details
 ALTER COLUMN blueground_id_details  	TYPE integer USING blueground_id_details::integer,
 ALTER COLUMN  lotsize			TYPE varchar,
 ALTER COLUMN  value			TYPE float USING (trim(value)::float),
 ALTER COLUMN  caption			TYPE varchar;
 