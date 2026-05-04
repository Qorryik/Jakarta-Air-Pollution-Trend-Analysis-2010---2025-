USE ispu_monitoring;

SELECT *
FROM ispu_clean;

SELECT COUNT(*)
FROM ispu_clean;

-- Pollutant range per category
SELECT 
	CONCAT(MIN(pm10), '-', MAX(pm10)) AS pm10_range,
    CONCAT(MIN(pm25), '-', MAX(pm25)) AS pm25_range,
    CONCAT(MIN(co), '-', MAX(co)) AS co_range,
    CONCAT(MIN(o3), '-', MAX(o3)) AS o3_range,
    categori
FROM ispu_clean
GROUP BY categori
ORDER BY CASE categori
	WHEN 'TIDAK ADA DATA' THEN 1
    WHEN 'BAIK' THEN 2
    WHEN 'SEDANG' THEN 3
    WHEN 'TIDAK SEHAT' THEN 4
    WHEN 'SANGAT TIDAK SEHAT' THEN 5
    WHEN 'BERBAHAYA' THEN 6
    END;

-- Yearly Distribution
SELECT COUNT(*), YEAR(tanggal)
FROM ispu_clean
GROUP BY YEAR(tanggal)
ORDER BY 2;

SELECT
    YEAR(tanggal) AS tahun,
    AVG(categori='BAIK') AS baik,
    AVG(categori = 'SEDANG') AS sedang,
    AVG(categori = 'TIDAK SEHAT') AS tidak_sehat,
    AVG(categori = 'SANGAT TIDAK SEHAT') AS sangat_tidak_sehat,
    AVG(categori='BERBAHAYA') AS berbahaya
FROM ispu_clean
WHERE YEAR(tanggal) < 2025
GROUP BY YEAR(tanggal)
ORDER BY YEAR(tanggal);

-- BEST vs WORST AIR POLUTAN
SELECT
    YEAR(tanggal) AS tahun,
    AVG(categori='BAIK') AS baik,
    AVG(categori = 'SEDANG') AS sedang,
    AVG(categori = 'TIDAK SEHAT') AS tidak_sehat,
    AVG(categori = 'SANGAT TIDAK SEHAT') AS sangat_tidak_sehat,
    AVG(categori='BERBAHAYA') AS berbahaya
FROM ispu_clean
WHERE YEAR(tanggal) < 2025
GROUP BY YEAR(tanggal)
ORDER BY baik, sedang, tidak_sehat, sangat_tidak_sehat, berbahaya;

SELECT
    MONTH(tanggal) AS bulan,
    AVG(categori='BAIK') AS baik,
    AVG(categori = 'SEDANG') AS sedang,
    AVG(categori = 'TIDAK SEHAT') AS tidak_sehat,
    AVG(categori = 'SANGAT TIDAK SEHAT') AS sangat_tidak_sehat,
    AVG(categori='BERBAHAYA') AS berbahaya
FROM ispu_clean
WHERE YEAR(tanggal) = 2012
GROUP BY MONTH(tanggal)
ORDER BY baik, sedang, tidak_sehat, sangat_tidak_sehat, berbahaya;

SELECT
    YEAR(tanggal) AS tahun,
    WEEK(tanggal) AS minggu_ke,
    AVG(pm10) AS avg_pm10,
    AVG(pm25) AS avg_pm25,
    AVG(co) AS avg_co,
    AVG(o3) AS avg_o3
FROM ispu_clean
GROUP BY tahun, minggu_ke
ORDER BY tahun, minggu_ke;

-- WEEKDAY VS WEEKEND
SELECT *
FROM ispu_clean
WHERE categori = 'BERBAHAYA';

SELECT pm10, pm25, co, o3, categori,
	   CASE
			WHEN DAYOFWEEK(tanggal) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
       END AS jenis_hari
FROM ispu_clean
WHERE YEAR(tanggal) = 2012
ORDER BY CASE categori
	WHEN 'BERBAHAYA' THEN 1
    WHEN 'SANGAT TIDAK SEHAT' THEN 2
    WHEN 'TIDAK SEHAT' THEN 3
    WHEN 'SEDANG' THEN 4
    WHEN 'BAIK' THEN 5
	WHEN 'TIDAK ADA DATA' THEN 6
    END;
    
-- DAILY CHANGES AND SPIKE
SELECT tanggal,
	   pm10,
       LAG(pm10) OVER(ORDER BY tanggal) AS hari_sebelumnya,
       pm10 - LAG(pm10) OVER(ORDER BY tanggal) AS lonjakan,
       categori
FROM ispu_clean
ORDER BY lonjakan DESC;

-- DOMINAN POLUTAN
SELECT tahun, dominan_polutan, jumlah
FROM (
    SELECT 
        tahun,
        dominan_polutan,
        COUNT(*) AS jumlah,
        ROW_NUMBER() OVER (
            PARTITION BY tahun 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM (
        SELECT 
            YEAR(tanggal) AS tahun,
            CASE
                WHEN pm10 >= pm25 AND pm10 >= co AND pm10 >= o3 THEN 'PM10'
                WHEN pm25 >= pm10 AND pm25 >= co AND pm25 >= o3 THEN 'PM25'
                WHEN co >= pm10 AND co >= pm25 AND co >= o3 THEN 'CO'
                ELSE 'O3'
            END AS dominan_polutan
        FROM ispu_clean
    ) AS sub1
    GROUP BY tahun, dominan_polutan
) AS sub2
WHERE rn = 1
ORDER BY tahun;