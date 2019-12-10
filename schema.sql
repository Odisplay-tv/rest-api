--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: insert_pending_pairing(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.insert_pending_pairing() RETURNS character
    LANGUAGE plpgsql
    AS $$
DECLARE
    ascii_numbers integer[];
    ascii_letters integer[];
    ascii_chars integer[];
    code char(5);
BEGIN
    ascii_numbers := array(select * from generate_series(48, 57));
    ascii_letters := array(select * from generate_series(65, 90));
    ascii_chars := ascii_numbers || ascii_letters;

    LOOP
        SELECT array_to_string(array(
          SELECT chr(ascii_chars[round(random() * (array_length(ascii_chars, 1) - 1)) + 1] :: integer)
          FROM generate_series(1, 5))
        , '')
        INTO code;
        BEGIN
            INSERT INTO pending_pairings (code) VALUES (code);
            RETURN code;
        EXCEPTION WHEN unique_violation THEN
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION public.insert_pending_pairing() OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pending_pairings; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.pending_pairings (
    code character(5) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.pending_pairings OWNER TO "user";

--
-- Name: pending_pairings pending-pairings-unique; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.pending_pairings
    ADD CONSTRAINT "pending-pairings-unique" UNIQUE (code);


--
-- PostgreSQL database dump complete
--

