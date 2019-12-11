SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET default_table_access_method = heap;
SET default_tablespace = '';
SET idle_in_transaction_session_timeout = 0;
SET lock_timeout = 0;
SET row_security = off;
SET standard_conforming_strings = on;
SET statement_timeout = 0;
SET xmloption = content;


CREATE SCHEMA IF NOT EXISTS public;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA pg_catalog;


CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'password';
CREATE ROLE anon NOLOGIN;
CREATE ROLE bo_user NOLOGIN;


CREATE FUNCTION public.declare_new_screen() RETURNS character
    LANGUAGE plpgsql
    AS $$
DECLARE
    ascii_numbers integer[];
    ascii_letters integer[];
    ascii_chars integer[];
    id uuid;
    code char(5);
BEGIN
    ascii_numbers := array(select * from generate_series(48, 57));
    ascii_letters := array(select * from generate_series(65, 90));
    ascii_chars := ascii_numbers || ascii_letters;

    LOOP
        SELECT uuid_generate_v4() INTO id;
        SELECT array_to_string(array(
          SELECT chr(ascii_chars[round(random() * (array_length(ascii_chars, 1) - 1)) + 1] :: integer)
          FROM generate_series(1, 5))
        , '')
        INTO code;
        BEGIN
            INSERT INTO screens (id, code) VALUES (id, code);
            RETURN json_build_object('id', id, 'code', code);
        EXCEPTION WHEN unique_violation THEN
        END;
    END LOOP;
END;
$$;

ALTER FUNCTION public.declare_new_screen() OWNER TO "authenticator";


CREATE TABLE public.screens (
    id uuid NOT NULL PRIMARY KEY,
    code character(5) NOT NULL UNIQUE,
    user_id character varying(256) NULL DEFAULT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE public.screens OWNER TO "authenticator";
