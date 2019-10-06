USE ssibd;

DROP TABLE IF EXISTS base_table;
DROP TABLE IF EXISTS prevm_table;
DROP TABLE IF EXISTS prevq_table;
DROP TABLE IF EXISTS prevy_table;
DROP TABLE IF EXISTS final_result;

CREATE TABLE base_table AS
SELECT
  row_label,
  count,
  CAST(date AS DATE) AS date,
  STR_TO_DATE(
    CONCAT(
      YEAR(DATE_ADD(CAST(date AS DATE), INTERVAL -1 month)), "-",
      MONTH(DATE_ADD(CAST(date AS DATE), INTERVAL -1 month)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join_1m,
  STR_TO_DATE(
    CONCAT(
      YEAR(DATE_ADD(CAST(date AS DATE), INTERVAL -3 month)), "-",
      MONTH(DATE_ADD(CAST(date AS DATE), INTERVAL -3 month)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join_1q,
  STR_TO_DATE(
    CONCAT(
      YEAR(DATE_ADD(CAST(date AS DATE), INTERVAL -1 year)), "-",
      MONTH(DATE_ADD(CAST(date AS DATE), INTERVAL -1 year)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join_1y
FROM self_join_20191005
;

CREATE TABLE prevm_table AS
SELECT
  row_label,
  count,
  CAST(date AS DATE) AS date,
  STR_TO_DATE(
    CONCAT(
      YEAR(CAST(date AS DATE)), "-",
      MONTH(CAST(date AS DATE)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join
FROM self_join_20191005
;

CREATE TABLE prevq_table AS
SELECT
  row_label,
  count,
  CAST(date AS DATE) AS date,
  STR_TO_DATE(
    CONCAT(
      YEAR(CAST(date AS DATE)), "-",
      MONTH(CAST(date AS DATE)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join
FROM self_join_20191005
;

CREATE TABLE prevy_table AS
SELECT
  row_label,
  count,
  CAST(date AS DATE) AS date,
  STR_TO_DATE(
    CONCAT(
      YEAR(CAST(date AS DATE)), "-",
      MONTH(CAST(date AS DATE)), "-",
      1
    ),
    "%Y-%m-%d"
  ) AS date_join
FROM self_join_20191005
;

CREATE TABLE final_result AS
SELECT
  A.row_label,
  A.date AS date_c,
  A.count AS cnt,
  A.date_join_1m AS date_1m_A,
  B.date_join AS date_1m,
  B.count AS cnt_1m,
  A.date_join_1q AS date_1q_A,
  C.date_join AS date_1q,
  C.count AS cnt_1q,
  A.date_join_1y AS date_1y_A,
  D.date_join AS date_1y,
  D.count AS cnt_1y
FROM base_table A
LEFT JOIN prevm_table B
  ON A.row_label = B.row_label 
  AND A.date_join_1m = B.date_join
LEFT JOIN prevq_table C
  ON A.row_label = C.row_label 
  AND A.date_join_1q = C.date_join
LEFT JOIN prevy_table D
  ON A.row_label = D.row_label 
  AND A.date_join_1y = D.date_join
;