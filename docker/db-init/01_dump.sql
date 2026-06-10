--
-- PostgreSQL database dump
--

\restrict jqtwWdGIHvzjLdQbeiysxfNsbbI2P63709gtB0UajSl4QqGRgCYgByTdxZuLkmQ

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

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
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: chat_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_rooms (
    id character varying(36) NOT NULL,
    product_id bigint,
    buyer_id bigint,
    seller_id bigint,
    last_message character varying(500),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: favorite_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorite_products (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: favorite_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorite_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorite_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorite_products_id_seq OWNED BY public.favorite_products.id;


--
-- Name: manners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manners (
    id bigint NOT NULL,
    from_user_id bigint NOT NULL,
    to_user_id bigint NOT NULL,
    score integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT manners_score_check CHECK (((score >= 1) AND (score <= 5)))
);


--
-- Name: manners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manners_id_seq OWNED BY public.manners.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    type integer,
    content character varying(50),
    is_read boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    room_id character varying(36) NOT NULL,
    user_id bigint NOT NULL,
    unread_count bigint DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    last_read_id bigint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: product_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_images (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    image_url character varying(250) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    category_id bigint,
    title character varying(100) NOT NULL,
    description text,
    status character varying(20) DEFAULT '판매중'::character varying NOT NULL,
    price integer NOT NULL,
    thumbnail character varying(250),
    view_count integer DEFAULT 0 NOT NULL,
    like_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    CONSTRAINT products_price_check CHECK ((price >= 0))
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: sale_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sale_reviews (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    buyer_id bigint NOT NULL,
    seller_id bigint NOT NULL,
    rating integer,
    content character varying(500),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT sale_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: sale_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sale_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sale_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sale_reviews_id_seq OWNED BY public.sale_reviews.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    nickname character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    region character varying(20) NOT NULL,
    profile_image character varying(250),
    manner_temp numeric(4,2) DEFAULT 36.5 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: favorite_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_products ALTER COLUMN id SET DEFAULT nextval('public.favorite_products_id_seq'::regclass);


--
-- Name: manners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manners ALTER COLUMN id SET DEFAULT nextval('public.manners_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: sale_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_reviews ALTER COLUMN id SET DEFAULT nextval('public.sale_reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES (1, '도서', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (2, '가구/인테리어', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (3, '기타', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (4, '의류/잡화', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (5, '스포츠/레저', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (6, '디지털기기', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');
INSERT INTO public.categories VALUES (7, '생활가전', '2026-06-10 15:14:01.783928', '2026-06-10 15:14:01.783928');


--
-- Data for Name: chat_rooms; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: favorite_products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: manners; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.product_images VALUES (1, 4, '/images/d0b88016-a045-4338-a3e8-18b4f1a33a64.jpg', '2026-06-10 21:12:16.663297', '2026-06-10 21:12:16.663297');
INSERT INTO public.product_images VALUES (2, 4, '/images/d41a4a53-1d40-4dff-baf4-3b925a717880.jpg', '2026-06-10 21:12:16.663297', '2026-06-10 21:12:16.663297');
INSERT INTO public.product_images VALUES (3, 4, '/images/7ed63211-704f-4a82-8621-22c37d3bf68b.jpg', '2026-06-10 21:12:16.663297', '2026-06-10 21:12:16.663297');
INSERT INTO public.product_images VALUES (4, 4, '/images/d83cfd98-88e0-485d-a669-b59f789cd1e2.jpg', '2026-06-10 21:12:16.663297', '2026-06-10 21:12:16.663297');
INSERT INTO public.product_images VALUES (5, 4, '/images/9c946f50-b04f-4f79-a2ff-ddbb846b3796.jpg', '2026-06-10 21:12:16.663297', '2026-06-10 21:12:16.663297');


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.products VALUES (4, 3, NULL, 'sdfs', '', '판매중', 123134, '/images/d0b88016-a045-4338-a3e8-18b4f1a33a64.jpg', 0, 0, '2026-06-10 21:12:16.62828', '2026-06-10 21:12:16.62828', NULL);
INSERT INTO public.products VALUES (3, 3, NULL, 'sdfs', 'sdfasdfa', '판매중', 123123, NULL, 5, 0, '2026-06-10 20:30:10.029576', '2026-06-10 20:30:10.029576', NULL);


--
-- Data for Name: sale_reviews; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (3, '노현수', 'ssanta011205@gmail.com', '$2a$10$cB5bZNE6uo53WmR4Vjk/dumtoLgOijXK3d.nQ/uLCUMLcxaOsGo8G', 'gyeongbuk', NULL, 36.50, '2026-06-10 20:27:19.352628', '2026-06-10 20:27:19.352628');


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 7, true);


--
-- Name: favorite_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorite_products_id_seq', 1, false);


--
-- Name: manners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.manners_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_images_id_seq', 5, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 4, true);


--
-- Name: sale_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sale_reviews_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: chat_rooms chat_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_pkey PRIMARY KEY (id);


--
-- Name: favorite_products favorite_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT favorite_products_pkey PRIMARY KEY (id);


--
-- Name: favorite_products favorite_products_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT favorite_products_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- Name: manners manners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manners
    ADD CONSTRAINT manners_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (room_id, user_id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: sale_reviews sale_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_reviews
    ADD CONSTRAINT sale_reviews_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_nickname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_nickname_key UNIQUE (nickname);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_chat_buyer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_buyer ON public.chat_rooms USING btree (buyer_id);


--
-- Name: idx_chat_seller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_seller ON public.chat_rooms USING btree (seller_id);


--
-- Name: idx_fav_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fav_user ON public.favorite_products USING btree (user_id);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- Name: idx_product_images_pid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_images_pid ON public.product_images USING btree (product_id);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: idx_products_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_created_at ON public.products USING btree (created_at DESC);


--
-- Name: idx_products_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_status ON public.products USING btree (status);


--
-- Name: idx_products_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_user_id ON public.products USING btree (user_id);


--
-- Name: chat_rooms chat_rooms_buyer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: chat_rooms chat_rooms_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: chat_rooms chat_rooms_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: favorite_products favorite_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT favorite_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: favorite_products favorite_products_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_products
    ADD CONSTRAINT favorite_products_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: manners manners_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manners
    ADD CONSTRAINT manners_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: manners manners_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manners
    ADD CONSTRAINT manners_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: participants participants_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE;


--
-- Name: participants participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: products products_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sale_reviews sale_reviews_buyer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_reviews
    ADD CONSTRAINT sale_reviews_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sale_reviews sale_reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_reviews
    ADD CONSTRAINT sale_reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: sale_reviews sale_reviews_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_reviews
    ADD CONSTRAINT sale_reviews_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict jqtwWdGIHvzjLdQbeiysxfNsbbI2P63709gtB0UajSl4QqGRgCYgByTdxZuLkmQ

