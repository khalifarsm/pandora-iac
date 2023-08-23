DROP DATABASE IF EXISTS "signal-accounts";
DROP DATABASE IF EXISTS "signal-messages";
create database "signal-accounts";
create database "signal-messages";


\c signal-accounts;
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2023-07-20 10:43:34

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
-- TOC entry 214 (class 1255 OID 11058380)
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
-- TOC entry 203 (class 1259 OID 11058310)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    data json NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 11058308)
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
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 202
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- TOC entry 201 (class 1259 OID 11058302)
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
-- TOC entry 200 (class 1259 OID 11058297)
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
-- TOC entry 207 (class 1259 OID 11058337)
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
-- TOC entry 206 (class 1259 OID 11058335)
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
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 206
-- Name: keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keys_id_seq OWNED BY public.keys.id;


--
-- TOC entry 211 (class 1259 OID 11058370)
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
-- TOC entry 210 (class 1259 OID 11058368)
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
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 210
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 205 (class 1259 OID 11058324)
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
-- TOC entry 204 (class 1259 OID 11058322)
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
-- TOC entry 3081 (class 0 OID 0)
-- Dependencies: 204
-- Name: pending_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pending_accounts_id_seq OWNED BY public.pending_accounts.id;


--
-- TOC entry 209 (class 1259 OID 11058357)
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
-- TOC entry 208 (class 1259 OID 11058355)
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
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 208
-- Name: pending_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pending_devices_id_seq OWNED BY public.pending_devices.id;


--
-- TOC entry 2896 (class 2604 OID 11058313)
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- TOC entry 2899 (class 2604 OID 11058340)
-- Name: keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys ALTER COLUMN id SET DEFAULT nextval('public.keys_id_seq'::regclass);


--
-- TOC entry 2904 (class 2604 OID 11058373)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);

--
-- TOC entry 2897 (class 2604 OID 11058327)
-- Name: pending_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts ALTER COLUMN id SET DEFAULT nextval('public.pending_accounts_id_seq'::regclass);


--
-- TOC entry 2902 (class 2604 OID 11058360)
-- Name: pending_devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices ALTER COLUMN id SET DEFAULT nextval('public.pending_devices_id_seq'::regclass);


--
-- TOC entry 3061 (class 0 OID 11058310)
-- Dependencies: 203
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id, number, data) FROM stdin;
\.


--
-- TOC entry 3059 (class 0 OID 11058302)
-- Dependencies: 201
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
\.


--
-- TOC entry 3058 (class 0 OID 11058297)
-- Dependencies: 200
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
\.


--
-- TOC entry 3065 (class 0 OID 11058337)
-- Dependencies: 207
-- Data for Name: keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keys (id, number, key_id, public_key, last_resort, device_id) FROM stdin;
\.


--
-- TOC entry 3069 (class 0 OID 11058370)
-- Dependencies: 211
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, account_id, device_id, encrypted_message) FROM stdin;
\.


--
-- TOC entry 3067 (class 0 OID 11058357)
-- Dependencies: 209
-- Data for Name: pending_devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pending_devices (id, number, verification_code, "timestamp") FROM stdin;
\.


--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 202
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_seq', 26, true);


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 206
-- Name: keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keys_id_seq', 2000, true);


--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 210
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);

--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 204
-- Name: pending_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pending_accounts_id_seq', 26, true);


--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 208
-- Name: pending_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pending_devices_id_seq', 1, false);


--
-- TOC entry 2909 (class 2606 OID 11058321)
-- Name: accounts accounts_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_number_key UNIQUE (number);

--
-- TOC entry 2913 (class 2606 OID 11058334)
-- Name: pending_accounts pending_accounts_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pending_accounts_number_key UNIQUE (number);


--
-- TOC entry 2920 (class 2606 OID 11058367)
-- Name: pending_devices pending_devices_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pending_devices_number_key UNIQUE (number);


--
-- TOC entry 2911 (class 2606 OID 11058319)
-- Name: accounts pk_accounts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT pk_accounts PRIMARY KEY (id);


--
-- TOC entry 2907 (class 2606 OID 11058301)
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- TOC entry 2918 (class 2606 OID 11058346)
-- Name: keys pk_keys; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT pk_keys PRIMARY KEY (id);


--
-- TOC entry 2925 (class 2606 OID 11058378)
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- TOC entry 2915 (class 2606 OID 11058332)
-- Name: pending_accounts pk_pending_accounts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pk_pending_accounts PRIMARY KEY (id);


--
-- TOC entry 2922 (class 2606 OID 11058365)
-- Name: pending_devices pk_pending_devices; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pk_pending_devices PRIMARY KEY (id);


--
-- TOC entry 2916 (class 1259 OID 11058347)
-- Name: keys_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keys_number_index ON public.keys USING btree (number);


--
-- TOC entry 2923 (class 1259 OID 11058379)
-- Name: messages_account_and_device; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_account_and_device ON public.messages USING btree (account_id, device_id);


-- Completed on 2023-07-20 10:43:34

--
-- PostgreSQL database dump complete
--









\c signal-messages;
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2023-07-20 10:47:08

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 11058276)
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
-- TOC entry 200 (class 1259 OID 11058271)
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
-- TOC entry 203 (class 1259 OID 11058284)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    type smallint NOT NULL,
    relay text NOT NULL,
    "timestamp" bigint NOT NULL,
    source text NOT NULL,
    source_device integer NOT NULL,
    destination text NOT NULL,
    destination_device integer NOT NULL,
    message bytea,
    content bytea
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 11058282)
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
-- TOC entry 3007 (class 0 OID 0)
-- Dependencies: 202
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 2860 (class 2604 OID 11058287)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 2999 (class 0 OID 11058276)
-- Dependencies: 201
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
\.


--
-- TOC entry 2998 (class 0 OID 11058271)
-- Dependencies: 200
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
\.


--
-- TOC entry 3001 (class 0 OID 11058284)
-- Dependencies: 203
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, type, relay, "timestamp", source, source_device, destination, destination_device, message, content) FROM stdin;
\.


--
-- TOC entry 3008 (class 0 OID 0)
-- Dependencies: 202
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 7, true);


--
-- TOC entry 2862 (class 2606 OID 11058275)
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 11058292)
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- TOC entry 2863 (class 1259 OID 11058294)
-- Name: destination_and_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX destination_and_type_index ON public.messages USING btree (destination, destination_device, type);


--
-- TOC entry 2864 (class 1259 OID 11058293)
-- Name: destination_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX destination_index ON public.messages USING btree (destination, destination_device);


--
-- TOC entry 2997 (class 2618 OID 11058296)
-- Name: messages bounded_message_queue; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE bounded_message_queue AS
    ON INSERT TO public.messages DO  DELETE FROM public.messages
  WHERE (messages.id IN ( SELECT messages_1.id
           FROM public.messages messages_1
          WHERE ((messages_1.destination = new.destination) AND (messages_1.destination_device = new.destination_device))
          ORDER BY messages_1."timestamp" DESC
         OFFSET 1000));


-- Completed on 2023-07-20 10:47:09

--
-- PostgreSQL database dump complete
--