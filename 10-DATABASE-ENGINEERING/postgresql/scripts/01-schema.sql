--
-- PostgreSQL database dump
--

\restrict 5ALF6CFqQbkMdCxWm1XUn61sykOl2oyp12eNBmnIfdKLWelr3cUHwHTFOPeZN3y

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: shop; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA shop;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.category (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: -
--

ALTER SEQUENCE shop.category_id_seq OWNED BY shop.category.id;


--
-- Name: customer; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.customer (
    id integer NOT NULL,
    email text NOT NULL,
    full_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: -
--

ALTER SEQUENCE shop.customer_id_seq OWNED BY shop.customer.id;


--
-- Name: order; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop."order" (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    placed_at timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'new'::text NOT NULL,
    CONSTRAINT order_status_check CHECK ((status = ANY (ARRAY['new'::text, 'paid'::text, 'shipped'::text, 'cancelled'::text])))
);


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: -
--

ALTER SEQUENCE shop.order_id_seq OWNED BY shop."order".id;


--
-- Name: order_line; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.order_line (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    qty integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT order_line_qty_check CHECK ((qty > 0)),
    CONSTRAINT order_line_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


--
-- Name: order_line_id_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.order_line_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_line_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: -
--

ALTER SEQUENCE shop.order_line_id_seq OWNED BY shop.order_line.id;


--
-- Name: product; Type: TABLE; Schema: shop; Owner: -
--

CREATE TABLE shop.product (
    id integer NOT NULL,
    sku text NOT NULL,
    name text NOT NULL,
    category_id integer,
    price numeric(10,2) NOT NULL,
    attrs jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT product_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: shop; Owner: -
--

CREATE SEQUENCE shop.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: -
--

ALTER SEQUENCE shop.product_id_seq OWNED BY shop.product.id;


--
-- Name: category id; Type: DEFAULT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.category ALTER COLUMN id SET DEFAULT nextval('shop.category_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.customer ALTER COLUMN id SET DEFAULT nextval('shop.customer_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop."order" ALTER COLUMN id SET DEFAULT nextval('shop.order_id_seq'::regclass);


--
-- Name: order_line id; Type: DEFAULT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_line ALTER COLUMN id SET DEFAULT nextval('shop.order_line_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.product ALTER COLUMN id SET DEFAULT nextval('shop.product_id_seq'::regclass);


--
-- Name: category category_name_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: order_line order_line_order_id_product_id_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_line
    ADD CONSTRAINT order_line_order_id_product_id_key UNIQUE (order_id, product_id);


--
-- Name: order_line order_line_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_line
    ADD CONSTRAINT order_line_pkey PRIMARY KEY (id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product product_sku_key; Type: CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_sku_key UNIQUE (sku);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES shop.customer(id);


--
-- Name: order_line order_line_order_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_line
    ADD CONSTRAINT order_line_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop."order"(id) ON DELETE CASCADE;


--
-- Name: order_line order_line_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.order_line
    ADD CONSTRAINT order_line_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: -
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES shop.category(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 5ALF6CFqQbkMdCxWm1XUn61sykOl2oyp12eNBmnIfdKLWelr3cUHwHTFOPeZN3y

