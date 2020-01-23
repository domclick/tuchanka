\set ON_ERROR_STOP 'on'
CREATE USER heartbeat WITH PASSWORD 'ChangeMe';
CREATE DATABASE heartbeat;
\c heartbeat
BEGIN;
CREATE TABLE heartbeat (beat time(1) NOT NULL);
INSERT INTO heartbeat VALUES (LOCALTIME(1));
GRANT SELECT,UPDATE ON TABLE heartbeat TO heartbeat;
CREATE PROCEDURE heart(IN _name text DEFAULT '') LANGUAGE plpgsql AS
$heart$
DECLARE
	_beat heartbeat.beat%TYPE;
BEGIN
	LOOP
		UPDATE heartbeat SET beat=LOCALTIME(1) RETURNING beat INTO _beat;
		RAISE INFO E'\r%\033[H\033[Kheart %:\r',_beat,_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$heart$;
GRANT EXECUTE ON PROCEDURE heart(text) TO heartbeat;
CREATE PROCEDURE beat(IN _name text DEFAULT '') LANGUAGE plpgsql AS
$beat$
DECLARE
	_beat heartbeat.beat%TYPE;
BEGIN
	LOOP
		SELECT beat INTO _beat FROM heartbeat;
		RAISE INFO E'\r%\033[H\033[Kbeat %:\r',_beat,_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$beat$;
GRANT EXECUTE ON PROCEDURE beat(text) TO heartbeat;
COMMIT;
