\pset format unaligned
\set ECHO none
\i test/fixtures/ml_values.sql
SELECT cdb_crankshaft._cdb_random_seeds(1234);

WITH expected AS (
  SELECT generate_series(1000,1020) AS id, unnest(ARRAY[
    4.565347755667527,
   1.7915611657636712,
   1.0277881671757865,
    2.660716845611126,
   2.9699523636176077,
   3.9548835811663374,
     4.16688182177564,
    3.812199063326875,
   1.8809746451771368,
   1.6330703244597695,
    3.036687558146356,
   3.3027348164224226,
    1.582807206783856,
   3.7543522681410426,
   1.0823757871416837,
    3.810255180922767,
   2.6648936300074904,
   1.5848007898771204,
    3.680276400196117,
   3.5331758637726765
    ]) AS expected LIMIT 20
),
prediction AS
(
    SELECT cartodb_id::integer id, prediction
    FROM cdb_crankshaft.CDB_CreateAndPredictSegment('SELECT target, x1, x2, x3 FROM ml_values WHERE class = $$train$$','target','SELECT cartodb_id, target, x1, x2, x3 FROM ml_values WHERE class = $$test$$')
    LIMIT 20
)
-- With the last updates, the `_cdb_random_seeds` isn't stable enough until everything is loaded
    SELECT abs(e.expected - p.prediction) <= 0.1 AS within_tolerance FROM expected e, prediction p WHERE e.id = p.id;
