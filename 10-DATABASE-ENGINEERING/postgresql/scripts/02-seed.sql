--
-- PostgreSQL database dump
--

\restrict aedw2aULFhZ45VGeLvl9nx6UXEK8Sta75tWVt1OgdMrVcuiZbLHURU1b0Qd1JEg

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
-- Data for Name: category; Type: TABLE DATA; Schema: shop; Owner: -
--

COPY shop.category (id, name) FROM stdin;
1	displays
2	peripherals
3	furniture
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: shop; Owner: -
--

COPY shop.customer (id, email, full_name, created_at) FROM stdin;
1	ada@example.org	Ada Lovelace	2026-10-26 17:36:22.692602+03
2	grace@example.org	Grace Hopper	2026-10-26 17:36:22.692602+03
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: shop; Owner: -
--

COPY shop."order" (id, customer_id, placed_at, status) FROM stdin;
1	1	2026-10-26 17:36:22.705403+03	paid
2	2	2026-10-26 17:36:22.705403+03	new
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: shop; Owner: -
--

COPY shop.product (id, sku, name, category_id, price, attrs) FROM stdin;
1	KBD-001	Mechanical Keyboard	2	120.00	{"layout": "tkl", "switch": "brown"}
2	MON-271	27-inch Monitor	1	310.00	{"hz": 75, "panel": "ips"}
3	STN-001	Laptop Stand	3	39.00	{"material": "aluminium"}
4	LMP-001	Desk Lamp	\N	27.00	{}
\.


--
-- Data for Name: order_line; Type: TABLE DATA; Schema: shop; Owner: -
--

COPY shop.order_line (id, order_id, product_id, qty, unit_price) FROM stdin;
1	1	1	2	120.00
2	1	3	1	39.00
3	2	2	1	310.00
\.


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: -
--

SELECT pg_catalog.setval('shop.category_id_seq', 3, true);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: -
--

SELECT pg_catalog.setval('shop.customer_id_seq', 2, true);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: -
--

SELECT pg_catalog.setval('shop.order_id_seq', 3, true);


--
-- Name: order_line_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: -
--

SELECT pg_catalog.setval('shop.order_line_id_seq', 4, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: -
--

SELECT pg_catalog.setval('shop.product_id_seq', 5, true);


--
-- PostgreSQL database dump complete
--

\unrestrict aedw2aULFhZ45VGeLvl9nx6UXEK8Sta75tWVt1OgdMrVcuiZbLHURU1b0Qd1JEg

