-- postgres=# \df *avg*
--                                            List of functions
--    Schema   |          Name           | Result data type |        Argument data types         |  Type  
-- ------------+-------------------------+------------------+------------------------------------+--------
--  pg_catalog | avg                     | numeric          | bigint                             | agg <<<<<<<
--  pg_catalog | avg                     | double precision | double precision                   | agg
--  pg_catalog | avg                     | numeric          | integer                            | agg
--  pg_catalog | avg                     | interval         | interval                           | agg
--  pg_catalog | avg                     | numeric          | numeric                            | agg
--  pg_catalog | avg                     | double precision | real                               | agg
--  pg_catalog | avg                     | numeric          | smallint                           | agg
--  pg_catalog | float8_avg              | double precision | double precision[]                 | normal
--  pg_catalog | float8_regr_avgx        | double precision | double precision[]                 | normal
--  pg_catalog | float8_regr_avgy        | double precision | double precision[]                 | normal
--  pg_catalog | int2_avg_accum          | bigint[]         | bigint[], smallint                 | normal
--  pg_catalog | int2_avg_accum_inv      | bigint[]         | bigint[], smallint                 | normal
--  pg_catalog | int4_avg_accum          | bigint[]         | bigint[], integer                  | normal
--  pg_catalog | int4_avg_accum_inv      | bigint[]         | bigint[], integer                  | normal
--  pg_catalog | int4_avg_combine        | bigint[]         | bigint[], bigint[]                 | normal
--  pg_catalog | int8_avg                | numeric          | bigint[]                           | normal
--  pg_catalog | int8_avg_accum          | internal         | internal, bigint                   | normal
--  pg_catalog | int8_avg_accum_inv      | internal         | internal, bigint                   | normal
--  pg_catalog | int8_avg_combine        | internal         | internal, internal                 | normal
--  pg_catalog | int8_avg_deserialize    | internal         | bytea, internal                    | normal
--  pg_catalog | int8_avg_serialize      | bytea            | internal                           | normal
--  pg_catalog | interval_avg            | interval         | interval[]                         | normal
--  pg_catalog | numeric_avg             | numeric          | internal                           | normal
--  pg_catalog | numeric_avg_accum       | internal         | internal, numeric                  | normal
--  pg_catalog | numeric_avg_combine     | internal         | internal, internal                 | normal
--  pg_catalog | numeric_avg_deserialize | internal         | bytea, internal                    | normal
--  pg_catalog | numeric_avg_serialize   | bytea            | internal                           | normal
--  pg_catalog | numeric_poly_avg        | numeric          | internal                           | normal
--  pg_catalog | regr_avgx               | double precision | double precision, double precision | agg
--  pg_catalog | regr_avgy               | double precision | double precision, double precision | agg
-- (30 rows)

------------ PARAMETERS
-- CREATE AGGREGATE name (arg_data_type)
-- (
--     SFUNC = sfunc,                -- State transition function   -- sfunc( state_data_type, arg_data_type ) ---> state_data_type
--     STYPE = state_data_type,      -- Temporary variable data type
--     FINALFUNC = ffunc,            -- Final aggregation function  -- ffunc( state_data_type ) ---> aggregate-value
-- --- SUPPORT PARTIAL AGGREGATION --> Support PARALLEL SAFE
--     COMBINEFUNC = combinefunc,    -- Support partial aggregation -- combinefunc( state_data_type, state_data_type ) --> state_data_type
--     SERIALFUNC = serialfunc,      -- Serialize for transmission  -- serialfunc( state_data_type ) -- bytea
--     DESERIALFUNC = deserialfunc,  -- Deserialize        dfe         -- deserialfunc( bytea, --unused-- internal ) -- state_data_type
--     PARALLEL = SAFE,
--     INITCOND = initial_condition, -- Initial state ---> state_data_type
-- --- SUPPORT FOR MOVING AGGREGATE MODE
--     MSFUNC = sfunc,               -- Moving aggregate (windows)  -- Same as SFUNC for us
--     MINVFUNC = minvfunc,          -- Moving Inverse aggregate    -- minvfunc( state_data_type, arg_data_type ) ---> state_data_type
--     MSTYPE = state_data_type,     -- Moving temporary variable   -- Same as STYPE for us
--     MFINALFUNC = ffunc,           -- Moving final aggregation    -- Same as FINALFUNC for us
--     MINITCOND = initial_condition -- Moving initial state        -- Same as INITCOND for us
-- );


---- Template
-- CREATE AGGREGATE cdb_avg (arg_data_type)
-- (
--     SFUNC = sfunc,
--     STYPE = state_data_type,
--     FINALFUNC = ffunc,
--     COMBINEFUNC = combinefunc,
--     SERIALFUNC = serialfunc,
--     DESERIALFUNC = deserialfunc,
--     PARALLEL = SAFE,
--     INITCOND = initial_condition,
--     MSFUNC = sfunc,
--     MINVFUNC = minvfunc,
--     MSTYPE = state_data_type,
--     MFINALFUNC = ffunc,
--     MINITCOND = initial_condition
-- );

Functions:
cdb_$type_avg_accum        -- sfunc
cdb_$type_avg_accum_inv    -- minvfunc
cdb_$type_avg              -- ffunc
cdb_$type_avg_combine      -- combinefunc
cdb_$type_avg_serialize    -- serialfunc
cdb_$type_avg_deserialize  -- deserialfunc

Types: 
int4     -- integer, smallint(cast)
int8     -- bigint
float8   -- double, real(cast)
numeric  -- numeric
interval -- interval 

-- Function template
CREATE OR REPLACE FUNCTION cdb_$type_avg_accum
