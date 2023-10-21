--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2023-10-20 10:53:59

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
-- TOC entry 233 (class 1255 OID 11058687)
-- Name: custom_json_object_set_key(json, text, anyelement); Type: FUNCTION; Schema: public; Owner: dbadmin
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


ALTER FUNCTION public.custom_json_object_set_key(json json, key_to_set text, value_to_set anyelement) OWNER TO dbadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 200 (class 1259 OID 11058688)
-- Name: accounts; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    data json NOT NULL
);


ALTER TABLE public.accounts OWNER TO dbadmin;

--
-- TOC entry 201 (class 1259 OID 11058694)
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO dbadmin;

--
-- TOC entry 3161 (class 0 OID 0)
-- Dependencies: 201
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- TOC entry 202 (class 1259 OID 11058696)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: dbadmin
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


ALTER TABLE public.databasechangelog OWNER TO dbadmin;

--
-- TOC entry 203 (class 1259 OID 11058702)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO dbadmin;

--
-- TOC entry 204 (class 1259 OID 11058705)
-- Name: keys; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.keys (
    id bigint NOT NULL,
    number character varying(255) NOT NULL,
    key_id bigint NOT NULL,
    public_key text NOT NULL,
    last_resort smallint DEFAULT 0,
    device_id bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.keys OWNER TO dbadmin;

--
-- TOC entry 205 (class 1259 OID 11058713)
-- Name: keys_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keys_id_seq OWNER TO dbadmin;

--
-- TOC entry 3162 (class 0 OID 0)
-- Dependencies: 205
-- Name: keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.keys_id_seq OWNED BY public.keys.id;


--
-- TOC entry 206 (class 1259 OID 11058715)
-- Name: messages; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    device_id bigint NOT NULL,
    encrypted_message text NOT NULL
);


ALTER TABLE public.messages OWNER TO dbadmin;

--
-- TOC entry 207 (class 1259 OID 11058721)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO dbadmin;

--
-- TOC entry 3163 (class 0 OID 0)
-- Dependencies: 207
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 208 (class 1259 OID 11058723)
-- Name: pandora_accounts; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_accounts (
    id bigint NOT NULL,
    pandora_id character varying(255),
    password character varying(255),
    registration_id integer NOT NULL,
    discover boolean NOT NULL,
    expiry_date timestamp without time zone,
    half_password character varying(255),
    public_key character varying(3000),
    wipe boolean NOT NULL,
    wipe_code character varying(255),
    signature_public_key character varying(3000),
    username character varying(255),
    enable_wipe boolean,
    delete_time bigint,
    signaling_key character varying(255),
    subscription_code character varying(255),
    nickname character varying(255),
    created timestamp without time zone,
    delete_time_date timestamp without time zone,
    last_seen timestamp without time zone
);


ALTER TABLE public.pandora_accounts OWNER TO dbadmin;

--
-- TOC entry 209 (class 1259 OID 11058729)
-- Name: pandora_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_accounts_id_seq OWNER TO dbadmin;

--
-- TOC entry 3164 (class 0 OID 0)
-- Dependencies: 209
-- Name: pandora_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_accounts_id_seq OWNED BY public.pandora_accounts.id;


--
-- TOC entry 226 (class 1259 OID 11058926)
-- Name: pandora_admins; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_admins (
    id bigint NOT NULL,
    email character varying(255),
    password character varying(255),
    created timestamp without time zone
);


ALTER TABLE public.pandora_admins OWNER TO dbadmin;

--
-- TOC entry 225 (class 1259 OID 11058924)
-- Name: pandora_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_admins_id_seq OWNER TO dbadmin;

--
-- TOC entry 3165 (class 0 OID 0)
-- Dependencies: 225
-- Name: pandora_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_admins_id_seq OWNED BY public.pandora_admins.id;


--
-- TOC entry 228 (class 1259 OID 11058940)
-- Name: pandora_applications; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_applications (
    id bigint NOT NULL,
    created timestamp without time zone,
    description character varying(5000),
    location character varying(255),
    size integer,
    updated timestamp without time zone,
    version character varying(255)
);


ALTER TABLE public.pandora_applications OWNER TO dbadmin;

--
-- TOC entry 227 (class 1259 OID 11058938)
-- Name: pandora_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_applications_id_seq OWNER TO dbadmin;

--
-- TOC entry 3166 (class 0 OID 0)
-- Dependencies: 227
-- Name: pandora_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_applications_id_seq OWNED BY public.pandora_applications.id;


--
-- TOC entry 213 (class 1259 OID 11058779)
-- Name: pandora_attachment; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_attachment (
    id bigint NOT NULL,
    content oid,
    signal_id character varying(255),
    created timestamp without time zone,
    token character varying(255)
);


ALTER TABLE public.pandora_attachment OWNER TO dbadmin;

--
-- TOC entry 212 (class 1259 OID 11058777)
-- Name: pandora_attachment_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_attachment_id_seq OWNER TO dbadmin;

--
-- TOC entry 3167 (class 0 OID 0)
-- Dependencies: 212
-- Name: pandora_attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_attachment_id_seq OWNED BY public.pandora_attachment.id;


--
-- TOC entry 219 (class 1259 OID 11058818)
-- Name: pandora_block; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_block (
    id bigint NOT NULL,
    bocked character varying(255),
    bocker character varying(255),
    report character varying(255),
    blocked character varying(255),
    blocker character varying(255)
);


ALTER TABLE public.pandora_block OWNER TO dbadmin;

--
-- TOC entry 218 (class 1259 OID 11058816)
-- Name: pandora_block_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_block_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_block_id_seq OWNER TO dbadmin;

--
-- TOC entry 3168 (class 0 OID 0)
-- Dependencies: 218
-- Name: pandora_block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_block_id_seq OWNED BY public.pandora_block.id;


--
-- TOC entry 214 (class 1259 OID 11058785)
-- Name: pandora_contacts; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_contacts (
    contact_id bigint NOT NULL,
    contact character varying(255) NOT NULL
);


ALTER TABLE public.pandora_contacts OWNER TO dbadmin;

--
-- TOC entry 230 (class 1259 OID 11058953)
-- Name: pandora_discount_codes; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_discount_codes (
    id bigint NOT NULL,
    code character varying(255),
    created timestamp without time zone,
    discount integer NOT NULL,
    min_accounts integer NOT NULL,
    used bigint NOT NULL
);


ALTER TABLE public.pandora_discount_codes OWNER TO dbadmin;

--
-- TOC entry 229 (class 1259 OID 11058951)
-- Name: pandora_discount_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_discount_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_discount_codes_id_seq OWNER TO dbadmin;

--
-- TOC entry 3169 (class 0 OID 0)
-- Dependencies: 229
-- Name: pandora_discount_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_discount_codes_id_seq OWNED BY public.pandora_discount_codes.id;


--
-- TOC entry 222 (class 1259 OID 11058906)
-- Name: pandora_group_admins; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_group_admins (
    group_id bigint NOT NULL,
    admin character varying(255) NOT NULL
);


ALTER TABLE public.pandora_group_admins OWNER TO dbadmin;

--
-- TOC entry 215 (class 1259 OID 11058790)
-- Name: pandora_group_members; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_group_members (
    member_id bigint NOT NULL,
    member character varying(255) NOT NULL
);


ALTER TABLE public.pandora_group_members OWNER TO dbadmin;

--
-- TOC entry 217 (class 1259 OID 11058797)
-- Name: pandora_groups; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_groups (
    id bigint NOT NULL,
    created timestamp without time zone,
    hide_ids boolean NOT NULL,
    member_can_invite boolean NOT NULL,
    name character varying(255),
    owner character varying(255),
    pandora_id character varying(255),
    expire_after bigint,
    auto_delete_messages bigint,
    expire_after_date timestamp without time zone
);


ALTER TABLE public.pandora_groups OWNER TO dbadmin;

--
-- TOC entry 216 (class 1259 OID 11058795)
-- Name: pandora_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_groups_id_seq OWNER TO dbadmin;

--
-- TOC entry 3170 (class 0 OID 0)
-- Dependencies: 216
-- Name: pandora_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_groups_id_seq OWNED BY public.pandora_groups.id;


--
-- TOC entry 232 (class 1259 OID 11058961)
-- Name: pandora_orders; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_orders (
    id bigint NOT NULL,
    accounts integer,
    address character varying(255),
    amount double precision,
    confirms_needed integer,
    coupon character varying(255),
    duration character varying(255),
    price bigint,
    qr_url character varying(255),
    status character varying(255),
    timeout bigint,
    transaction_id character varying(255),
    show_transaction boolean,
    created timestamp without time zone
);


ALTER TABLE public.pandora_orders OWNER TO dbadmin;

--
-- TOC entry 231 (class 1259 OID 11058959)
-- Name: pandora_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_orders_id_seq OWNER TO dbadmin;

--
-- TOC entry 3171 (class 0 OID 0)
-- Dependencies: 231
-- Name: pandora_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_orders_id_seq OWNED BY public.pandora_orders.id;


--
-- TOC entry 224 (class 1259 OID 11058918)
-- Name: pandora_subscription_codes; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pandora_subscription_codes (
    id bigint NOT NULL,
    code character varying(12),
    created timestamp without time zone,
    duration bigint,
    account_id character varying(255),
    usage_date timestamp without time zone,
    used boolean NOT NULL,
    transaction_id bigint
);


ALTER TABLE public.pandora_subscription_codes OWNER TO dbadmin;

--
-- TOC entry 223 (class 1259 OID 11058916)
-- Name: pandora_subscription_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pandora_subscription_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pandora_subscription_codes_id_seq OWNER TO dbadmin;

--
-- TOC entry 3172 (class 0 OID 0)
-- Dependencies: 223
-- Name: pandora_subscription_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pandora_subscription_codes_id_seq OWNED BY public.pandora_subscription_codes.id;


--
-- TOC entry 221 (class 1259 OID 11058839)
-- Name: pending_accounts; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pending_accounts (
    id bigint NOT NULL,
    number character varying(255),
    "timestamp" bigint,
    verification_code character varying(255)
);


ALTER TABLE public.pending_accounts OWNER TO dbadmin;

--
-- TOC entry 220 (class 1259 OID 11058837)
-- Name: pending_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pending_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pending_accounts_id_seq OWNER TO dbadmin;

--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 220
-- Name: pending_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pending_accounts_id_seq OWNED BY public.pending_accounts.id;


--
-- TOC entry 210 (class 1259 OID 11058740)
-- Name: pending_devices; Type: TABLE; Schema: public; Owner: dbadmin
--

CREATE TABLE public.pending_devices (
    id bigint NOT NULL,
    number text NOT NULL,
    verification_code text NOT NULL,
    "timestamp" bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision) NOT NULL
);


ALTER TABLE public.pending_devices OWNER TO dbadmin;

--
-- TOC entry 211 (class 1259 OID 11058747)
-- Name: pending_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE public.pending_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pending_devices_id_seq OWNER TO dbadmin;

--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 211
-- Name: pending_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE public.pending_devices_id_seq OWNED BY public.pending_devices.id;


--
-- TOC entry 2962 (class 2604 OID 11058749)
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- TOC entry 2965 (class 2604 OID 11058750)
-- Name: keys id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.keys ALTER COLUMN id SET DEFAULT nextval('public.keys_id_seq'::regclass);


--
-- TOC entry 2966 (class 2604 OID 11058751)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 2967 (class 2604 OID 11058752)
-- Name: pandora_accounts id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_accounts ALTER COLUMN id SET DEFAULT nextval('public.pandora_accounts_id_seq'::regclass);


--
-- TOC entry 2975 (class 2604 OID 11058929)
-- Name: pandora_admins id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_admins ALTER COLUMN id SET DEFAULT nextval('public.pandora_admins_id_seq'::regclass);


--
-- TOC entry 2976 (class 2604 OID 11058943)
-- Name: pandora_applications id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_applications ALTER COLUMN id SET DEFAULT nextval('public.pandora_applications_id_seq'::regclass);


--
-- TOC entry 2970 (class 2604 OID 11058782)
-- Name: pandora_attachment id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_attachment ALTER COLUMN id SET DEFAULT nextval('public.pandora_attachment_id_seq'::regclass);


--
-- TOC entry 2972 (class 2604 OID 11058821)
-- Name: pandora_block id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_block ALTER COLUMN id SET DEFAULT nextval('public.pandora_block_id_seq'::regclass);


--
-- TOC entry 2977 (class 2604 OID 11058956)
-- Name: pandora_discount_codes id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_discount_codes ALTER COLUMN id SET DEFAULT nextval('public.pandora_discount_codes_id_seq'::regclass);


--
-- TOC entry 2971 (class 2604 OID 11058800)
-- Name: pandora_groups id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_groups ALTER COLUMN id SET DEFAULT nextval('public.pandora_groups_id_seq'::regclass);


--
-- TOC entry 2978 (class 2604 OID 11058964)
-- Name: pandora_orders id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_orders ALTER COLUMN id SET DEFAULT nextval('public.pandora_orders_id_seq'::regclass);


--
-- TOC entry 2974 (class 2604 OID 11058921)
-- Name: pandora_subscription_codes id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_subscription_codes ALTER COLUMN id SET DEFAULT nextval('public.pandora_subscription_codes_id_seq'::regclass);


--
-- TOC entry 2973 (class 2604 OID 11058842)
-- Name: pending_accounts id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pending_accounts ALTER COLUMN id SET DEFAULT nextval('public.pending_accounts_id_seq'::regclass);


--
-- TOC entry 2969 (class 2604 OID 11058754)
-- Name: pending_devices id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pending_devices ALTER COLUMN id SET DEFAULT nextval('public.pending_devices_id_seq'::regclass);


--
-- TOC entry 2980 (class 2606 OID 11058756)
-- Name: accounts accounts_number_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_number_key UNIQUE (number);


--
-- TOC entry 2992 (class 2606 OID 11058758)
-- Name: pandora_accounts pandora_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_accounts
    ADD CONSTRAINT pandora_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3014 (class 2606 OID 11058934)
-- Name: pandora_admins pandora_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_admins
    ADD CONSTRAINT pandora_admins_pkey PRIMARY KEY (id);


--
-- TOC entry 3018 (class 2606 OID 11058948)
-- Name: pandora_applications pandora_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_applications
    ADD CONSTRAINT pandora_applications_pkey PRIMARY KEY (id);


--
-- TOC entry 2998 (class 2606 OID 11058784)
-- Name: pandora_attachment pandora_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_attachment
    ADD CONSTRAINT pandora_attachment_pkey PRIMARY KEY (id);


--
-- TOC entry 3006 (class 2606 OID 11058826)
-- Name: pandora_block pandora_block_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_block
    ADD CONSTRAINT pandora_block_pkey PRIMARY KEY (id);


--
-- TOC entry 3000 (class 2606 OID 11058789)
-- Name: pandora_contacts pandora_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_contacts
    ADD CONSTRAINT pandora_contacts_pkey PRIMARY KEY (contact_id, contact);


--
-- TOC entry 3020 (class 2606 OID 11058958)
-- Name: pandora_discount_codes pandora_discount_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_discount_codes
    ADD CONSTRAINT pandora_discount_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 3010 (class 2606 OID 11058910)
-- Name: pandora_group_admins pandora_group_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_group_admins
    ADD CONSTRAINT pandora_group_admins_pkey PRIMARY KEY (group_id, admin);


--
-- TOC entry 3002 (class 2606 OID 11058794)
-- Name: pandora_group_members pandora_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_group_members
    ADD CONSTRAINT pandora_group_members_pkey PRIMARY KEY (member_id, member);


--
-- TOC entry 3004 (class 2606 OID 11058805)
-- Name: pandora_groups pandora_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_groups
    ADD CONSTRAINT pandora_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3022 (class 2606 OID 11058969)
-- Name: pandora_orders pandora_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_orders
    ADD CONSTRAINT pandora_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3012 (class 2606 OID 11058923)
-- Name: pandora_subscription_codes pandora_subscription_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_subscription_codes
    ADD CONSTRAINT pandora_subscription_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 3008 (class 2606 OID 11058847)
-- Name: pending_accounts pending_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pending_accounts
    ADD CONSTRAINT pending_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 2994 (class 2606 OID 11058762)
-- Name: pending_devices pending_devices_number_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pending_devices_number_key UNIQUE (number);


--
-- TOC entry 2982 (class 2606 OID 11058764)
-- Name: accounts pk_accounts; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT pk_accounts PRIMARY KEY (id);


--
-- TOC entry 2984 (class 2606 OID 11058766)
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- TOC entry 2987 (class 2606 OID 11058768)
-- Name: keys pk_keys; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT pk_keys PRIMARY KEY (id);


--
-- TOC entry 2990 (class 2606 OID 11058770)
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- TOC entry 2996 (class 2606 OID 11058774)
-- Name: pending_devices pk_pending_devices; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pending_devices
    ADD CONSTRAINT pk_pending_devices PRIMARY KEY (id);


--
-- TOC entry 3016 (class 2606 OID 11058936)
-- Name: pandora_admins uk_9ct2c7k1252pnl0uuj4u67s9p; Type: CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_admins
    ADD CONSTRAINT uk_9ct2c7k1252pnl0uuj4u67s9p UNIQUE (email);


--
-- TOC entry 2985 (class 1259 OID 11058775)
-- Name: keys_number_index; Type: INDEX; Schema: public; Owner: dbadmin
--

CREATE INDEX keys_number_index ON public.keys USING btree (number);


--
-- TOC entry 2988 (class 1259 OID 11058776)
-- Name: messages_account_and_device; Type: INDEX; Schema: public; Owner: dbadmin
--

CREATE INDEX messages_account_and_device ON public.messages USING btree (account_id, device_id);


--
-- TOC entry 3024 (class 2606 OID 11058811)
-- Name: pandora_group_members fkd1h090f1msaac7gyx4fdomw1e; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_group_members
    ADD CONSTRAINT fkd1h090f1msaac7gyx4fdomw1e FOREIGN KEY (member_id) REFERENCES public.pandora_groups(id);


--
-- TOC entry 3023 (class 2606 OID 11058806)
-- Name: pandora_contacts fki6ed30pr8fv13e9olxrvtifyw; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_contacts
    ADD CONSTRAINT fki6ed30pr8fv13e9olxrvtifyw FOREIGN KEY (contact_id) REFERENCES public.pandora_accounts(id);


--
-- TOC entry 3025 (class 2606 OID 11058911)
-- Name: pandora_group_admins fkiws1s88yhpov4fy26t22qcb4v; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY public.pandora_group_admins
    ADD CONSTRAINT fkiws1s88yhpov4fy26t22qcb4v FOREIGN KEY (group_id) REFERENCES public.pandora_groups(id);


-- Completed on 2023-10-20 10:54:00

--
-- PostgreSQL database dump complete
--

