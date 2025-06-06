--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: gersang_db
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO gersang_db;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: gersang_items; Type: TABLE; Schema: public; Owner: gersang_db
--

CREATE TABLE public.gersang_items (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    tags character varying(255)[],
    margin double precision,
    market_price integer,
    cost_per double precision,
    "artisan_product?" boolean DEFAULT false NOT NULL,
    artisan_production_amount integer,
    artisan_production_fee integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.gersang_items OWNER TO gersang_db;

--
-- Name: gersang_items_id_seq; Type: SEQUENCE; Schema: public; Owner: gersang_db
--

CREATE SEQUENCE public.gersang_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gersang_items_id_seq OWNER TO gersang_db;

--
-- Name: gersang_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gersang_db
--

ALTER SEQUENCE public.gersang_items_id_seq OWNED BY public.gersang_items.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: gersang_db
--

CREATE TABLE public.recipes (
    id bigint NOT NULL,
    product_item_id bigint NOT NULL,
    material_item_id bigint NOT NULL,
    media character varying(255),
    material_amount integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.recipes OWNER TO gersang_db;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: gersang_db
--

CREATE SEQUENCE public.recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO gersang_db;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gersang_db
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: gersang_db
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO gersang_db;

--
-- Name: gersang_items id; Type: DEFAULT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.gersang_items ALTER COLUMN id SET DEFAULT nextval('public.gersang_items_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Data for Name: gersang_items; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.gersang_items (id, name, tags, margin, market_price, cost_per, "artisan_product?", artisan_production_amount, artisan_production_fee, inserted_at, updated_at) FROM stdin;
54	Sealed Power Piece	\N	\N	1600000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
55	Sealed Power Shard	\N	\N	17000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
56	Yellow Force Stone	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
57	Red Force Stone	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
58	Blue Force Stone	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
59	Moon Seal	\N	\N	2000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
60	Sun Seal	\N	\N	1000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
61	Five color powder	\N	\N	1500000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
62	Force of Deities(Thunder)	\N	\N	35000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
63	Force of Deities(Earth)	\N	\N	35000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
64	Force of Deities(Wind)	\N	\N	35000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
65	Force of Deities(Water)	\N	\N	35000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
66	Force of Deities(Flame)	\N	\N	35000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
67	Piece of Deities(Thunder)	\N	\N	850000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
68	Piece of Deities(Earth)	\N	\N	890000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
69	Piece of Deities(Wind)	\N	\N	1400000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
70	Piece of Deities(Water)	\N	\N	1980000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
71	Piece of Deities(Flame)	\N	\N	3000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
72	Small Elemental Stone of Flame	\N	\N	940000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
73	Small Elemental Stone of Water	\N	\N	850000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
74	Small Elemental Stone of Wind	\N	\N	790000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
75	Small Elemental Stone of Thunder	\N	\N	850000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
76	Small Elemental Stone of Earth	\N	\N	8500000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
77	Force Beads(Flame)	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
78	Force Beads(Water)	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
79	Force Beads(Wind)	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
80	Force Beads(Thunder)	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
81	Force Beads(Earth)	\N	\N	0	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
82	Fragmented Force Beads(Flame)	\N	\N	2900000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
83	Fragmented Force Beads(Water)	\N	\N	2800000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
84	Fragmented Force Beads(Wind)	\N	\N	275000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
85	Fragmented Force Beads(Thunder)	\N	\N	1200000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
86	Fragmented Force Beads(Earth)	\N	\N	500000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
87	Flame Stone	\N	\N	1000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
88	Frozen Stone	\N	\N	1000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
89	maple stone	\N	\N	1000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
90	Thunder Soul Stone	\N	\N	1000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
91	Earth specter stone	\N	\N	500000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
92	Flame specter stone	\N	\N	4000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
93	Water specter stone	\N	\N	2000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
94	Wind specter stone	\N	\N	2000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
95	Thunder specter stone	\N	\N	2000000	\N	f	\N	\N	2025-06-06 21:30:38	2025-06-06 21:30:38
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.recipes (id, product_item_id, material_item_id, media, material_amount, inserted_at, updated_at) FROM stdin;
1	55	54	Masamune	10	2025-06-06 21:36:23	2025-06-06 21:36:23
6	83	83	Zhang Guolao	10	2025-06-06 21:38:23	2025-06-06 21:38:23
7	83	73	Zhang Guolao	5	2025-06-06 21:38:23	2025-06-06 21:38:23
8	83	88	Zhang Guolao	2	2025-06-06 21:38:23	2025-06-06 21:38:23
9	83	61	Zhang Guolao	2	2025-06-06 21:38:23	2025-06-06 21:38:23
10	77	82	Zhang Guolao	10	2025-06-06 21:39:02	2025-06-06 21:39:02
11	77	72	Zhang Guolao	5	2025-06-06 21:39:02	2025-06-06 21:39:02
12	77	87	Zhang Guolao	2	2025-06-06 21:39:02	2025-06-06 21:39:02
13	77	61	Zhang Guolao	2	2025-06-06 21:39:02	2025-06-06 21:39:02
14	72	59	test	5	2025-06-06 21:43:49	2025-06-06 21:43:49
15	72	60	test	5	2025-06-06 21:43:49	2025-06-06 21:43:49
16	61	54	test	5	2025-06-06 21:44:36	2025-06-06 21:44:36
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20240226160600	\N
20250524025539	2025-05-31 18:22:42
\.


--
-- Name: gersang_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gersang_db
--

SELECT pg_catalog.setval('public.gersang_items_id_seq', 95, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gersang_db
--

SELECT pg_catalog.setval('public.recipes_id_seq', 16, true);


--
-- Name: gersang_items gersang_items_pkey; Type: CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.gersang_items
    ADD CONSTRAINT gersang_items_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: recipes recipes_material_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_material_item_id_fkey FOREIGN KEY (material_item_id) REFERENCES public.gersang_items(id);


--
-- Name: recipes recipes_product_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_product_item_id_fkey FOREIGN KEY (product_item_id) REFERENCES public.gersang_items(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: gersang_db
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

