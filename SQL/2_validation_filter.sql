USE ispu_monitoring;

SELECT *
FROM ispu_analysis
WHERE categori = 'BAIK' AND (
			(pm10 BETWEEN 0 AND 50 OR pm10 IS NULL) AND
            (pm25 BETWEEN 0 AND 50 OR pm25 IS NULL) AND
            (co BETWEEN 0 AND 50 OR co IS NULL) AND
            (o3 BETWEEN 0 AND 50 OR o3 IS NULL)
	  )
      ORDER BY pm25 DESC;
      
SELECT *
FROM ispu_analysis
WHERE categori = 'SEDANG' AND(
			(pm10 BETWEEN 51 AND 100) OR
            (pm25 BETWEEN 51 AND 100) OR
            (co BETWEEN 51 AND 100) OR
            (o3 BETWEEN 51 AND 100)
	  ) AND
      (pm10 <= 100 OR pm10 IS NULL) AND 
      (pm25 <= 100 OR pm25 IS NULL) AND 
      (co <= 100 OR co IS NULL) AND 
      (o3 <= 100 OR o3 IS NULL);
      
SELECT *
FROM ispu_analysis
WHERE categori = 'TIDAK SEHAT' AND (
			(pm10 BETWEEN 101 AND 200) OR
            (pm25 BETWEEN 101 AND 200) OR
            (co BETWEEN 101 AND 200) OR
            (o3 BETWEEN 101 AND 200)
	  ) AND
      (pm10 <= 200 OR pm10 IS NULL) AND 
      (pm25 <= 200 OR pm25 IS NULL) AND 
      (co <= 200 OR co IS NULL) AND 
      (o3 <= 200 OR o3 IS NULL);
      
SELECT *
FROM ispu_analysis
WHERE categori = 'SANGAT TIDAK SEHAT' AND (
			(pm10 BETWEEN 201 AND 300) OR
            (pm25 BETWEEN 201 AND 300) OR
            (co BETWEEN 201 AND 300) OR
            (o3 BETWEEN 201 AND 300)
	  ) AND
      (pm10 <= 300 OR pm10 IS NULL) AND 
      (pm25 <= 300 OR pm25 IS NULL) AND 
      (co <= 300 OR co IS NULL) AND 
      (o3 <= 300 OR o3 IS NULL);
      
SELECT *
FROM ispu_analysis
WHERE categori = 'BERBAHAYA' AND (
			(pm10 > 300) OR
            (pm25 > 300) OR
            (co > 300) OR
            (o3 > 300)
	  );

SELECT *
FROM ispu_analysis
WHERE categori = 'TIDAK ADA DATA' AND (
    (pm10 = 0 OR pm10 IS NULL) AND 
    (pm25 = 0 OR pm25 IS NULL) AND 
    (co = 0 OR co IS NULL) AND 
    (o3 = 0 OR o3 IS NULL)
);

-- Instead of deleting records directly, a new validated table was created containing only records that passed ISPU consistency rules.
DROP TABLE IF EXISTS ispu_clean;

CREATE TABLE ispu_clean AS
SELECT *
FROM ispu_analysis
WHERE 
(
    categori = 'BAIK' AND
    (pm10 BETWEEN 0 AND 50 OR pm10 IS NULL) AND 
    (pm25 BETWEEN 0 AND 50 OR pm25 IS NULL) AND 
    (co BETWEEN 0 AND 50 OR co IS NULL) AND 
    (o3 BETWEEN 0 AND 50 OR o3 IS NULL)
) 
OR (
    categori = 'SEDANG' AND (
        (pm10 BETWEEN 51 AND 100) OR
        (pm25 BETWEEN 51 AND 100) OR
        (co BETWEEN 51 AND 100) OR
        (o3 BETWEEN 51 AND 100)
    ) AND 
    (pm10 <= 100 OR pm10 IS NULL) AND 
    (pm25 <= 100 OR pm25 IS NULL) AND 
    (co <= 100 OR co IS NULL) AND 
    (o3 <= 100 OR o3 IS NULL)
)
OR(
    categori = 'TIDAK SEHAT' AND (
        (pm10 BETWEEN 101 AND 200) OR
        (pm25 BETWEEN 101 AND 200) OR
        (co BETWEEN 101 AND 200) OR
        (o3 BETWEEN 101 AND 200)
    ) AND 
    (pm10 <= 200 OR pm10 IS NULL) AND 
    (pm25 <= 200 OR pm25 IS NULL) AND 
    (co <= 200 OR co IS NULL) AND 
    (o3 <= 200 OR o3 IS NULL)
)
OR(
    categori = 'SANGAT TIDAK SEHAT' AND (
        (pm10 BETWEEN 201 AND 300) OR
        (pm25 BETWEEN 201 AND 300) OR
        (co BETWEEN 201 AND 300) OR
        (o3 BETWEEN 201 AND 300)
    ) AND 
    (pm10 <= 300 OR pm10 IS NULL) AND 
    (pm25 <= 300 OR pm25 IS NULL) AND 
    (co <= 300 OR co IS NULL) AND 
    (o3 <= 300 OR o3 IS NULL)
)
OR(
    categori = 'BERBAHAYA' AND (
        pm10 > 300 OR
        pm25 > 300 OR
        co > 300 OR
        o3 > 300
    )
)
OR(
    categori = 'TIDAK ADA DATA' AND
    (pm10 = 0 OR pm10 IS NULL) AND 
    (pm25 = 0 OR pm25 IS NULL) AND 
    (co = 0 OR co IS NULL) AND 
    (o3 = 0 OR o3 IS NULL)
);

SELECT *
FROM ispu_clean;

SELECT 
    SUM(pm10 IS NULL) AS pm10_null,
    SUM(pm25 IS NULL) AS pm25_null,
    SUM(co IS NULL)   AS co_null,
    SUM(o3 IS NULL)   AS o3_null,
    categori
FROM ispu_clean
GROUP BY categori;