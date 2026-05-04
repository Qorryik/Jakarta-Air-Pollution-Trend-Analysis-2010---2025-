-- HANDLING NULL VALUES
USE ispu_monitoring;

UPDATE ispu_clean
SET 
    pm10 = COALESCE(pm10, 0),
    pm25 = COALESCE(pm25, 0),
    co   = COALESCE(co, 0),
    o3   = COALESCE(o3, 0)
WHERE categori = 'TIDAK ADA DATA';
-- pm10
UPDATE ispu_clean AS target
SET target.pm10 = (
    SELECT AVG(pm10_val)
    FROM (
        SELECT pm10 AS pm10_val,
               ROW_NUMBER() OVER (ORDER BY pm10) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'BAIK' AND
              pm10 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm10 IS NULL
  AND target.categori = 'BAIK';
  
UPDATE ispu_clean AS target
SET target.pm10 = (
    SELECT AVG(pm10_val)
    FROM (
        SELECT pm10 AS pm10_val,
               ROW_NUMBER() OVER (ORDER BY pm10) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SEDANG' AND
              pm10 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm10 IS NULL
  AND target.categori = 'SEDANG';
  
UPDATE ispu_clean AS target
SET target.pm10 = (
    SELECT AVG(pm10_val)
    FROM (
        SELECT pm10 AS pm10_val,
               ROW_NUMBER() OVER (ORDER BY pm10) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'TIDAK SEHAT' AND
              pm10 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm10 IS NULL
  AND target.categori = 'TIDAK SEHAT';
  
UPDATE ispu_clean AS target
SET target.pm10 = (
    SELECT AVG(pm10_val)
    FROM (
        SELECT pm10 AS pm10_val,
               ROW_NUMBER() OVER (ORDER BY pm10) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SANGAT TIDAK SEHAT' AND
              pm10 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm10 IS NULL
  AND target.categori = 'SANGAT TIDAK SEHAT';

SELECT DISTINCT pm10
FROM ispu_clean
ORDER BY 1;

-- PM25
UPDATE ispu_clean AS target
SET target.pm25 = (
    SELECT AVG(pm25_val)
    FROM (
        SELECT pm25 AS pm25_val,
               ROW_NUMBER() OVER (ORDER BY pm25) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'BAIK' AND
              pm25 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm25 IS NULL
  AND target.categori = 'BAIK';
  
UPDATE ispu_clean AS target
SET target.pm25 = (
    SELECT AVG(pm25_val)
    FROM (
        SELECT pm25 AS pm25_val,
               ROW_NUMBER() OVER (ORDER BY pm25) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SEDANG' AND
              pm25 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm25 IS NULL
  AND target.categori = 'SEDANG';

UPDATE ispu_clean AS target
SET target.pm25 = (
    SELECT AVG(pm25_val)
    FROM (
        SELECT pm25 AS pm25_val,
               ROW_NUMBER() OVER (ORDER BY pm25) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'TIDAK SEHAT' AND
              pm25 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm25 IS NULL
  AND target.categori = 'TIDAK SEHAT';

UPDATE ispu_clean AS target
SET target.pm25 = (
    SELECT AVG(pm25_val)
    FROM (
        SELECT pm25 AS pm25_val,
               ROW_NUMBER() OVER (ORDER BY pm25) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SANGAT TIDAK SEHAT' AND
              pm25 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm25 IS NULL
  AND target.categori = 'SANGAT TIDAK SEHAT';

UPDATE ispu_clean AS target
SET target.pm25 = (
    SELECT AVG(pm25_val)
    FROM (
        SELECT pm25 AS pm25_val,
               ROW_NUMBER() OVER (ORDER BY pm25) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE pm25 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.pm25 IS NULL
  AND target.categori = 'BERBAHAYA';

SELECT DISTINCT pm25
FROM ispu_clean
ORDER BY 1;

-- CO
UPDATE ispu_clean AS target
SET target.co = (
    SELECT AVG(co_val)
    FROM (
        SELECT co AS co_val,
               ROW_NUMBER() OVER (ORDER BY co) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'BAIK' AND
              co IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.co IS NULL
  AND target.categori = 'BAIK';
  
UPDATE ispu_clean AS target
SET target.co = (
    SELECT AVG(co_val)
    FROM (
        SELECT co AS co_val,
               ROW_NUMBER() OVER (ORDER BY co) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SEDANG' AND
              co IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.co IS NULL
  AND target.categori = 'SEDANG';

UPDATE ispu_clean AS target
SET target.co = (
    SELECT AVG(co_val)
    FROM (
        SELECT co AS co_val,
               ROW_NUMBER() OVER (ORDER BY co) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'TIDAK SEHAT' AND
              co IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.co IS NULL
  AND target.categori = 'TIDAK SEHAT';
  
UPDATE ispu_clean AS target
SET target.co = (
    SELECT AVG(co_val)
    FROM (
        SELECT co AS co_val,
               ROW_NUMBER() OVER (ORDER BY co) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SANGAT TIDAK SEHAT' AND
              co IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.co IS NULL
  AND target.categori = 'SANGAT TIDAK SEHAT';

SELECT DISTINCT co
FROM ispu_clean
ORDER BY 1;

-- O3
UPDATE ispu_clean AS target
SET target.o3 = (
    SELECT AVG(o3_val)
    FROM (
        SELECT o3 AS o3_val,
               ROW_NUMBER() OVER (ORDER BY o3) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'BAIK' AND
              o3 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.o3 IS NULL
  AND target.categori = 'BAIK';
  
UPDATE ispu_clean AS target
SET target.o3 = (
    SELECT AVG(o3_val)
    FROM (
        SELECT o3 AS o3_val,
               ROW_NUMBER() OVER (ORDER BY o3) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'SEDANG' AND
              o3 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.o3 IS NULL
  AND target.categori = 'SEDANG';
  
UPDATE ispu_clean AS target
SET target.o3 = (
    SELECT AVG(o3_val)
    FROM (
        SELECT o3 AS o3_val,
               ROW_NUMBER() OVER (ORDER BY co) AS rn,
               COUNT(*) OVER () AS total_rows
        FROM ispu_clean
        WHERE categori = 'TIDAK SEHAT' AND
              o3 IS NOT NULL
    ) AS temp
    WHERE rn IN (
        FLOOR((total_rows + 1)/2),
        FLOOR((total_rows + 2)/2)
    )
)
WHERE target.o3 IS NULL
  AND target.categori = 'TIDAK SEHAT';

SELECT *
FROM ispu_clean;