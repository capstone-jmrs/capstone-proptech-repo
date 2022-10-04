--------------------------------------------------
SELECT *
FROM spotahome_eda;


--------------------------------------------------
ALTER TABLE spotahome_eda
	DROP COLUMN price_pcm,
	DROP COLUMN price_pcm_0,
	DROP COLUMN price_pcm_1;
  
  
ALTER TABLE spotahome_eda
	RENAME COLUMN avg_price_sqm TO price_pcm;