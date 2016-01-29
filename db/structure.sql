--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.0
-- Dumped by pg_dump version 9.5.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fn_trig_upsert_event(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_trig_upsert_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  insert into fast_event_reports(id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url)
  select id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url
  from event_reports
  where id = new.id

  on conflict(id) do update
  set type = excluded.type,
      created_at = excluded.created_at,
      payload = excluded.payload;

  return null;
end
$$;


--
-- Name: fn_trig_upsert_repo(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_trig_upsert_repo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  insert into fast_event_reports(id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url)
  select id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url
  from event_reports
  where repo_id = new.id

  on conflict(id) do update
  set repo_name = excluded.repo_name,
      repo_url = excluded.repo_url;

  return null;
end
$$;


--
-- Name: fn_trig_upsert_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_trig_upsert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  insert into fast_event_reports(id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url)
  select id, type, created_at, payload, repo_id, repo_name, repo_url, username, user_id, user_url, avatar_url
  from event_reports
  where user_id = new.id

  on conflict(id) do update
  set username = excluded.username,
      avatar_url = excluded.avatar_url,
      user_url = excluded.user_url;

  return null;
end
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id bigint NOT NULL,
    type character varying NOT NULL,
    user_id integer NOT NULL,
    repo_id integer NOT NULL,
    payload jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: repos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE repos (
    id integer NOT NULL,
    name character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying NOT NULL,
    url character varying(1000) NOT NULL,
    avatar_url character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_reports; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW event_reports AS
 SELECT events.id,
    events.type,
    events.created_at,
    events.payload,
    repos.id AS repo_id,
    repos.name AS repo_name,
    repos.url AS repo_url,
    users.id AS user_id,
    users.username,
    users.url AS user_url,
    users.avatar_url
   FROM ((events
     JOIN repos ON ((repos.id = events.repo_id)))
     JOIN users ON ((users.id = events.user_id)));


--
-- Name: fast_event_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fast_event_reports (
    id bigint NOT NULL,
    type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    payload jsonb NOT NULL,
    repo_id integer NOT NULL,
    repo_name character varying NOT NULL,
    repo_url character varying NOT NULL,
    user_id integer NOT NULL,
    username character varying NOT NULL,
    user_url character varying NOT NULL,
    avatar_url character varying NOT NULL
);


--
-- Name: repos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE repos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE repos_id_seq OWNED BY repos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY repos ALTER COLUMN id SET DEFAULT nextval('repos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: fast_event_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fast_event_reports
    ADD CONSTRAINT fast_event_reports_pkey PRIMARY KEY (id);


--
-- Name: repos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY repos
    ADD CONSTRAINT repos_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_events_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_created_at ON events USING btree (created_at);


--
-- Name: index_events_on_repo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_repo_id ON events USING btree (repo_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON events USING btree (user_id);


--
-- Name: index_fast_event_reports_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fast_event_reports_on_created_at ON fast_event_reports USING btree (created_at);


--
-- Name: index_fast_event_reports_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fast_event_reports_on_id ON fast_event_reports USING btree (id);


--
-- Name: index_fast_event_reports_on_repo_name_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fast_event_reports_on_repo_name_and_type ON fast_event_reports USING btree (repo_name varchar_pattern_ops, type varchar_pattern_ops);


--
-- Name: index_fast_event_reports_on_username_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fast_event_reports_on_username_and_type ON fast_event_reports USING btree (username varchar_pattern_ops, type varchar_pattern_ops);


--
-- Name: index_users_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_url ON users USING btree (url);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: trig_upsert_event; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trig_upsert_event AFTER INSERT OR UPDATE ON events FOR EACH ROW EXECUTE PROCEDURE fn_trig_upsert_event();


--
-- Name: trig_upsert_repo; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trig_upsert_repo AFTER INSERT OR UPDATE ON repos FOR EACH ROW EXECUTE PROCEDURE fn_trig_upsert_repo();


--
-- Name: trig_upsert_user; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trig_upsert_user AFTER INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE fn_trig_upsert_user();


--
-- Name: fk_rails_0cb5590091; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_0cb5590091 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_6663ff9223; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_6663ff9223 FOREIGN KEY (repo_id) REFERENCES repos(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160122025604');

INSERT INTO schema_migrations (version) VALUES ('20160122025815');

INSERT INTO schema_migrations (version) VALUES ('20160122030346');

INSERT INTO schema_migrations (version) VALUES ('20160123215237');

INSERT INTO schema_migrations (version) VALUES ('20160127010043');

INSERT INTO schema_migrations (version) VALUES ('20160127013909');

INSERT INTO schema_migrations (version) VALUES ('20160127013910');

INSERT INTO schema_migrations (version) VALUES ('20160129015149');

