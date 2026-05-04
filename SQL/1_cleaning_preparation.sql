USE ispu_monitoring;
-- Preview raw tables
SELECT * FROM dim_stasiun;
SELECT * FROM fact_ispu;

SELECT 
	'Minimum' AS stats,
     MIN(pm10) AS pm10,
     MIN(pm25) AS pm25,
	 MIN(co)   AS co,
     MIN(o3)   AS o3
FROM fact_ispu
UNION ALL
SELECT 
    'Maximum',
     MAX(pm10),
     MAX(pm25),
     MAX(co),
     MAX(o3)
FROM fact_ispu;

-- Total rows
SELECT COUNT(*) AS total_rows
FROM fact_ispu;

SELECT COUNT(*)
FROM fact_ispu
WHERE o3 IS NULL;

-- Create working table
CREATE TEMPORARY TABLE ispu_analysis AS
SELECT
    fi.stasiun_id,
    fi.tanggal,
    fi.pm10, fi.pm25, fi.co, fi.o3,
    fi.categori,
    ds.nama_stasiun
FROM fact_ispu fi
JOIN dim_stasiun ds
ON fi.stasiun_id = ds.stasiun_id;

-- Check duplicate rows
SELECT 
    stasiun_id,
    tanggal,
    pm10,
    pm25,
    co,
    o3,
    categori,
    nama_stasiun,
    COUNT(*) AS duplicate_count
FROM ispu_analysis
GROUP BY
    stasiun_id,
    tanggal,
    pm10,
    pm25,
    co,
    o3,
    categori,
    nama_stasiun
HAVING COUNT(*) > 1;

-- Standardize date format
UPDATE ispu_analysis
SET tanggal = STR_TO_DATE(tanggal,'%Y-%m-%d');

ALTER TABLE ispu_analysis
MODIFY COLUMN tanggal DATE;

-- Preview
SELECT * FROM ispu_analysis;