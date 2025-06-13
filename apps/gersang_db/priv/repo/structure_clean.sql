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
    market_price bigint,
    cost_per double precision,
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
-- Name: recipe_spec; Type: TABLE; Schema: public; Owner: gersang_db
--

CREATE TABLE public.recipe_spec (
    id bigint NOT NULL,
    product_item_id bigint NOT NULL,
    production_fee integer DEFAULT 0,
    production_amount integer DEFAULT 1,
    wages integer DEFAULT 1000,
    workload integer DEFAULT 0,
    media character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.recipe_spec OWNER TO gersang_db;

--
-- Name: recipe_spec_id_seq; Type: SEQUENCE; Schema: public; Owner: gersang_db
--

CREATE SEQUENCE public.recipe_spec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_spec_id_seq OWNER TO gersang_db;

--
-- Name: recipe_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gersang_db
--

ALTER SEQUENCE public.recipe_spec_id_seq OWNED BY public.recipe_spec.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: gersang_db
--

CREATE TABLE public.recipes (
    id bigint NOT NULL,
    product_item_id bigint NOT NULL,
    material_item_id bigint NOT NULL,
    material_amount integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    recipe_spec_id bigint
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
-- Name: recipe_spec id; Type: DEFAULT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipe_spec ALTER COLUMN id SET DEFAULT nextval('public.recipe_spec_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Data for Name: gersang_items; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.gersang_items (id, name, tags, margin, market_price, cost_per, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: recipe_spec; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.recipe_spec (id, product_item_id, production_fee, production_amount, wages, workload, media, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.recipes (id, product_item_id, material_item_id, material_amount, inserted_at, updated_at, recipe_spec_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: gersang_db
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20240226160600	2025-06-13 18:24:42
20250524025539	2025-06-13 18:24:42
20250607120154	2025-06-13 18:24:42
20250607130157	2025-06-13 18:24:42
20250607143507	2025-06-13 18:24:42
\.


--
-- Name: gersang_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gersang_db
--

SELECT pg_catalog.setval('public.gersang_items_id_seq', 1, false);


--
-- Name: recipe_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gersang_db
--

SELECT pg_catalog.setval('public.recipe_spec_id_seq', 1, false);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gersang_db
--

SELECT pg_catalog.setval('public.recipes_id_seq', 1, false);


--
-- Name: gersang_items gersang_items_pkey; Type: CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.gersang_items
    ADD CONSTRAINT gersang_items_pkey PRIMARY KEY (id);


--
-- Name: recipe_spec recipe_spec_pkey; Type: CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipe_spec
    ADD CONSTRAINT recipe_spec_pkey PRIMARY KEY (id);


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
-- Name: recipe_spec_product_item_id_index; Type: INDEX; Schema: public; Owner: gersang_db
--

CREATE INDEX recipe_spec_product_item_id_index ON public.recipe_spec USING btree (product_item_id);


--
-- Name: recipe_spec recipe_spec_product_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipe_spec
    ADD CONSTRAINT recipe_spec_product_item_id_fkey FOREIGN KEY (product_item_id) REFERENCES public.gersang_items(id) ON DELETE CASCADE;


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
-- Name: recipes recipes_recipe_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gersang_db
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_recipe_spec_id_fkey FOREIGN KEY (recipe_spec_id) REFERENCES public.recipe_spec(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

