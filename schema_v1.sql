-- schema_v1.sql
-- Artificial Sentience Character Database, Version 1

PRAGMA foreign_keys = ON;

-- Catalog of surveys
CREATE TABLE IF NOT EXISTS surveys (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    version TEXT DEFAULT 'v1',
    created_at TEXT DEFAULT (datetime('now'))
);

-- Questions for each survey
CREATE TABLE IF NOT EXISTS questions (
    id INTEGER PRIMARY KEY,
    survey_id INTEGER NOT NULL REFERENCES surveys(id) ON DELETE CASCADE,
    q_num INTEGER NOT NULL,
    text TEXT NOT NULL,
    type TEXT NOT NULL,              -- 'choice' | 'text' | 'ranking'
    required INTEGER DEFAULT 0,      -- 0/1
    meta JSON                        -- store options or ranking keys if relevant
);

-- Options for multiple-choice questions
CREATE TABLE IF NOT EXISTS options (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    code TEXT NOT NULL,              -- short stable code, e.g. 'MOON', 'OCEAN'
    label TEXT NOT NULL,             -- user-facing label
    ord INTEGER                      -- display order
);

-- Students / respondents
CREATE TABLE IF NOT EXISTS respondents (
    id INTEGER PRIMARY KEY,
    display_name TEXT,               -- chosen character name
    class_period TEXT,
    source_email TEXT                -- optional, omit if anonymous
);

-- A response = one submitted form
CREATE TABLE IF NOT EXISTS responses (
    id INTEGER PRIMARY KEY,
    survey_id INTEGER NOT NULL REFERENCES surveys(id) ON DELETE CASCADE,
    respondent_id INTEGER REFERENCES respondents(id) ON DELETE SET NULL,
    submitted_at TEXT,
    source_row_id TEXT               -- optional: ID from export
);

-- Individual answers
CREATE TABLE IF NOT EXISTS answers (
    id INTEGER PRIMARY KEY,
    response_id INTEGER NOT NULL REFERENCES responses(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_code TEXT,                -- if multiple-choice
    text_answer TEXT,                -- if free text
    numeric_value REAL,              -- for numbers/likert
    rank_json JSON                   -- for ranking answers
);

-- Convenience view: pulls core identity traits together
CREATE VIEW IF NOT EXISTS v_character_core AS
SELECT
    r.id AS response_id,
    r.submitted_at,
    resp.display_name AS chosen_name,
    MAX(CASE WHEN q.q_num = 2 THEN a.option_code END) AS faction,
    MAX(CASE WHEN q.q_num = 3 THEN a.option_code END) AS story_role,
    MAX(CASE WHEN q.q_num = 4 THEN a.option_code END) AS ai_stance,
    MAX(CASE WHEN q.q_num = 6 THEN a.option_code END) AS moral_choice,
    MAX(CASE WHEN q.q_num = 7 THEN a.option_code END) AS conflict_style,
    MAX(CASE WHEN q.q_num = 8 THEN a.option_code END) AS risk_style,
    MAX(CASE WHEN q.q_num = 9 THEN a.option_code END) AS adaptation,
    MAX(CASE WHEN q.q_num = 10 THEN a.option_code END) AS primary_skill,
    MAX(CASE WHEN q.q_num = 11 THEN a.option_code END) AS trust_anchor,
    MAX(CASE WHEN q.q_num = 12 THEN a.option_code END) AS valued_resource,
    MAX(CASE WHEN q.q_num = 13 THEN a.option_code END) AS stress_tone,
    MAX(CASE WHEN q.q_num = 14 THEN a.option_code END) AS fatal_flaw
FROM responses r
LEFT JOIN respondents resp ON resp.id = r.respondent_id
LEFT JOIN answers a ON a.response_id = r.id
LEFT JOIN questions q ON q.id = a.question_id
GROUP BY r.id, r.submitted_at, resp.display_name;