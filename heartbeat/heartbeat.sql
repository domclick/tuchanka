\set ON_ERROR_STOP 'on'
CREATE USER heartbeat WITH PASSWORD 'ChangeMe';
CREATE DATABASE heartbeat;
\c heartbeat
BEGIN;
CREATE TABLE heartbeat (beat timestamptz NOT NULL);
INSERT INTO heartbeat VALUES (current_timestamp);
GRANT SELECT,UPDATE ON heartbeat TO heartbeat;
COMMIT;
