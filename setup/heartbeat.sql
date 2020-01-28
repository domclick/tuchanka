\set ON_ERROR_STOP 'on'
CREATE USER heartbeat WITH PASSWORD 'ChangeMe';
CREATE DATABASE heartbeat;

\c heartbeat
BEGIN;
CREATE TABLE heartbeat (beat time(1) NOT NULL);
INSERT INTO heartbeat VALUES (LOCALTIME(1));

CREATE FUNCTION heart() RETURNS time LANGUAGE sql VOLATILE SECURITY DEFINER PARALLEL UNSAFE AS
$heart$
UPDATE heartbeat SET beat=LOCALTIME(1) RETURNING beat
$heart$;
GRANT EXECUTE ON FUNCTION heart() TO heartbeat;

CREATE FUNCTION beat() RETURNS time LANGUAGE SQL STABLE SECURITY DEFINER PARALLEL SAFE AS
$beat$
SELECT beat FROM heartbeat
$beat$;
GRANT EXECUTE ON FUNCTION beat() TO heartbeat;

CREATE PROCEDURE heart4tmux(IN _name text DEFAULT '') LANGUAGE plpgsql AS
$heart4tmux$
BEGIN
	LOOP
		RAISE INFO E'\r%\033[H\033[Kheart %:\r',(SELECT heart()),_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$heart4tmux$;
GRANT EXECUTE ON PROCEDURE heart4tmux(text) TO heartbeat;

CREATE PROCEDURE beat4tmux(IN _name text DEFAULT '') LANGUAGE plpgsql AS
$beat4tmux$
BEGIN
	LOOP
		RAISE INFO E'\r%\033[H\033[Kbeat %:\r',(SELECT beat()),_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$beat4tmux$;
GRANT EXECUTE ON PROCEDURE beat4tmux(text) TO heartbeat;

CREATE TABLE reactions (
	failure text NOT NULL,
	reaction integer NOT NULL CHECK (reaction>0)
);
GRANT SELECT,INSERT ON reactions TO heartbeat;

COMMIT;
