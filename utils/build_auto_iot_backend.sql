%sql
DROP DATABASE IF EXISTS main.resamplerdata CASCADE;
CREATE DATABASE IF NOT EXISTS main.resamplerdata;
USE main.resamplerdata;

CREATE TABLE IF NOT EXISTS main.resamplerdata.auto_iot_bronze_sensors
(
  -- Id BIGINT GENERATED BY DEFAULT AS IDENTITY,
  Timestamp TIMESTAMP, 
  EngineTemperature  FLOAT,
  OilPressure FLOAT, 
  Speed FLOAT,
  FuelLevel  FLOAT, 
  TirePressure  FLOAT,
  BatteryVoltage  FLOAT
)
USING DELTA
TBLPROPERTIES ("delta.targetFileSize" = "600mb");


COPY INTO main.resamplerdata.auto_iot_bronze_sensors
FROM (
    SELECT 
        'Timestamp'::timestamp AS Timestamp,
        "EngineTemperature_C"::float AS EngineTemperature,
        "OilPressure_psi"::float AS OilPressure,
        "Speed_kmh"::float AS Speed,
        "FuelLevel_percent"::float AS FuelLevel,
        "TirePressure_psi"::float AS  TirePressure,
        "BatteryVoltage_V"::float AS BatteryVoltage 
    FROM "/FileStore/auto_iot_sensor_data.csv"
)
FILEFORMAT = csv -- Specify CSV format
COPY_OPTIONS('force'='true') -- Option to be incremental or always load all files
;
