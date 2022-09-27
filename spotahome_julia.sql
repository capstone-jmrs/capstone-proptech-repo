/*Select tables*/
SELECT *
FROM spotahome_df_complete sdc;


---
SELECT *
FROM spotahome_df_details_complete sddc;


---
SELECT *
FROM spotahome_final sf;


---
SELECT *
FROM rightmove_1 r;


---
SELECT *
FROM spotahome_df_details_complete sddc
ORDER BY details;


----
SELECT COUNT(*)
FROM spotahome_df_complete sdc;

---

SELECT *
FROM spotahome_df_complete sdc  
ORDER BY property_type;

---
SELECT *
FROM spotahome_df_complete sdc 
ORDER BY platform_id ;

---
SELECT *
FROM spotahome_df_complete sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;

---
CREATE TABLE spotahome_final AS
SELECT *
FROM spotahome_df_complete sdc 
LEFT JOIN spotahome_df_details_complete sddc  
	   ON sdc.platform_id = sddc.id;


---
SELECT *
FROM spotahome_final sf;


---
ALTER TABLE tablename rename to oldtable;
    create table tablename (column defs go here); ### with all the constraints
    insert into tablename (col1, col2, col3) select col1, col2, col3 from oldtable;


---
DROP TABLE spotahome_df_details;