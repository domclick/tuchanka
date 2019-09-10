\set ON_ERROR_STOP 'on'
CREATE USER heartbeat WITH PASSWORD 'ChangeMe';
CREATE DATABASE heartbeat;
\c heartbeat
BEGIN;
CREATE TABLE heartbeat (beat time(1) NOT NULL);
INSERT INTO heartbeat VALUES (LOCALTIME(1));
GRANT SELECT,UPDATE ON heartbeat TO heartbeat;
COMMIT;
