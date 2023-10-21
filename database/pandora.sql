--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2023-10-20 10:50:27

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
-- TOC entry 212 (class 1255 OID 11059210)
-- Name: custom_json_object_set_key(json, text, anyelement); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.custom_json_object_set_key(json json, key_to_set text, value_to_set anyelement) RETURNS json
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
            SELECT COALESCE(
            (SELECT ('{' || string_agg(to_json("key") || ':' || "value", ',') || '}')
            FROM (SELECT *
            FROM json_each("json")
            WHERE "key" <> "key_to_set"
            UNION ALL
            SELECT "key_to_set", to_json("value_to_set")) AS "fields"),
            '{}'
            )::json
            $$;


ALTER FUNCTION public.custom_json_object_set_key(json json, key_to_set text, value_to_set anyelement) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 200 (class 1259 OID 11059211)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    data json NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 11059217)
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- TOC entry 3053 (class 0 OID 0)
-- Dependencies: 201
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- TOC entry 202 (class 1259 OID 11059219)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 11059225)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 11059228)
-- Name: keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keys (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    key_id bigint NOT NULL,
    public_key text NOT NULL,
    last_resort smallint DEFAULT 0,
    device_id bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.keys OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 11059236)
-- Name: keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keys_id_seq OWNER TO postgres;

--
-- TOC entry 3054 (class 0 OID 0)
-- Dependencies: 205
-- Name: keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keys_id_seq OWNED BY public.keys.id;


--
-- TOC entry 206 (class 1259 OID 11059238)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    device_id bigint NOT NULL,
    encrypted_message text NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 11059244)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO postgres;

--
-- TOC entry 3055 (class 0 OID 0)
-- Dependencies: 207
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 208 (class 1259 OID 11059246)
-- Name: pending_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pending_accounts (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    verification_code character varying(255) NOT NULL,
    "timestamp" bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL
);


ALTER TABLE public.pending_accounts OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 11059253)
-- Name: pending_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pending_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pending_accounts_id_seq OWNER TO postgres;

--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 209
-- Name: pending_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pending_accounts_id_seq OWNED BY public.pending_accounts.id;


--
-- TOC entry 210 (class 1259 OID 11059255)
-- Name: pending_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pending_devices (
    id bigint NOT NULL,
    number text NOT NULL,
    verification_code text NOT NULL,
    "timestamp" bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL
);


ALTER TABLE public.pending_devices OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 11059262)
-- Name: pending_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pending_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pending_devices_id_seq OWNER TO postgres;

--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 211
-- Name: pending_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pending_devices_id_seq OWNED BY public.pending_devices.id;


--
-- TOC entry 2889 (class 2604 OID 11059264)
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- TOC entry 2892 (class 2604 OID 11059265)
-- Name: keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys ALTER COLUMN id SET DEFAULT nextval('public.keys_id_seq'::regclass);


--
-- TOC entry 2893 (class 2604 OID 11059266)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 2895 (class 2604 OID 11059267)
-- Name: pending_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts ALTER COLUMN id SET DEFAULT nextval('public.pending_accounts_id_seq'::regclass);


--
-- TOC entry 2897 (class 2604 OID 11059268)
-- Name: pending_devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices ALTER COLUMN id SET DEFAULT nextval('public.pending_devices_id_seq'::regclass);


--
-- TOC entry 2899 (class 2606 OID 11059270)
-- Name: accounts accounts_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_number_key UNIQUE (number);


--
-- TOC entry 2911 (class 2606 OID 11059272)
-- Name: pending_accounts pending_accounts_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pending_accounts_number_key UNIQUE (number);


--
-- TOC entry 2915 (class 2606 OID 11059274)
-- Name: pending_devices pending_devices_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pending_devices_number_key UNIQUE (number);


--
-- TOC entry 2901 (class 2606 OID 11059276)
-- Name: accounts pk_accounts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT pk_accounts PRIMARY KEY (id);


--
-- TOC entry 2903 (class 2606 OID 11059278)
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 11059280)
-- Name: keys pk_keys; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT pk_keys PRIMARY KEY (id);


--
-- TOC entry 2909 (class 2606 OID 11059282)
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- TOC entry 2913 (class 2606 OID 11059284)
-- Name: pending_accounts pk_pending_accounts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pk_pending_accounts PRIMARY KEY (id);


--
-- TOC entry 2917 (class 2606 OID 11059286)
-- Name: pending_devices pk_pending_devices; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pk_pending_devices PRIMARY KEY (id);


--
-- TOC entry 2904 (class 1259 OID 11059287)
-- Name: keys_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keys_number_index ON public.keys USING btree (number);


--
-- TOC entry 2907 (class 1259 OID 11059288)
-- Name: messages_account_and_device; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_account_and_device ON public.messages USING btree (account_id, device_id);


-- Completed on 2023-10-20 10:50:27

--
-- PostgreSQL database dump complete
--

