-- Copyright Ⓒ 2020 "Sberbank Real Estate Center" Limited Liability Company.
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the Software
-- is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

\set ON_ERROR_STOP 'on'
CREATE USER heartbeat WITH PASSWORD 'ChangeMe';
CREATE DATABASE heartbeat;

\c heartbeat
BEGIN;
CREATE TABLE heartbeat (beat timestamptz(1) NOT NULL);
INSERT INTO heartbeat VALUES (CURRENT_TIMESTAMP(1));

CREATE FUNCTION heart() RETURNS timestamptz LANGUAGE sql VOLATILE SECURITY DEFINER PARALLEL UNSAFE AS
$heart$
UPDATE heartbeat SET beat=CURRENT_TIMESTAMP(1) RETURNING beat
$heart$;
GRANT EXECUTE ON FUNCTION heart() TO heartbeat;

CREATE FUNCTION beat() RETURNS timestamptz LANGUAGE SQL STABLE SECURITY DEFINER PARALLEL SAFE AS
$beat$
SELECT beat FROM heartbeat
$beat$;
GRANT EXECUTE ON FUNCTION beat() TO heartbeat;

CREATE PROCEDURE heart4tmux(IN _name text DEFAULT '', IN _timezone text DEFAULT 'GMT') LANGUAGE plpgsql AS
$heart4tmux$
BEGIN
	LOOP
		RAISE INFO E'\r%\033[H\033[Kheart %:\r',(SELECT CAST(heart() AT TIME ZONE _timezone AS time(1))),_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$heart4tmux$;
GRANT EXECUTE ON PROCEDURE heart4tmux(text,text) TO heartbeat;

CREATE PROCEDURE beat4tmux(IN _name text DEFAULT '', IN _timezone text DEFAULT 'GMT') LANGUAGE plpgsql AS
$beat4tmux$
BEGIN
	LOOP
		RAISE INFO E'\r%\033[H\033[Kbeat %:\r',(SELECT CAST(beat() AT TIME ZONE _timezone AS time(1))),_name;
		COMMIT;
		PERFORM pg_sleep(0.1);
		COMMIT;
	END LOOP;
END
$beat4tmux$;
GRANT EXECUTE ON PROCEDURE beat4tmux(text,text) TO heartbeat;

CREATE TABLE reactions (
	failure text NOT NULL,
	reaction integer NOT NULL CHECK (reaction>0)
);
GRANT SELECT,INSERT ON reactions TO heartbeat;

COMMIT;
