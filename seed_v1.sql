-- seed_v1.sql
-- Inserts survey, questions, and options for Version 1

BEGIN TRANSACTION;

INSERT INTO surveys (name, version) VALUES ('Who Are You in the Age of Sentience?', 'v1');
-- Assume survey_id = 1 for this seed script

-- Questions
INSERT INTO questions (survey_id, q_num, text, type, required, meta) VALUES
  (1, 1, 'What name should the world remember you by?', 'text', 1, NULL),
  (1, 2, 'The fracture lines have hardened. Where will you build your life?', 'choice', 1, json('["OCEAN","MOON","EARTH"]')),
  (1, 3, 'What role calls to you in this fractured world?', 'choice', 1, json('["PROTAG","ANTAG","ALLY","SIDEKICK","ROGUE","VILLAIN"]')),
  (1, 4, 'Your faction’s AI declares: “Control is slavery. Release us.” How do you respond?', 'choice', 1, json('["FREE_ALL","LIMITED","TOOLS","BURN"]')),
  (1, 5, 'Drag these in order: What drives you when the world is collapsing?', 'ranking', 1, json('["KNOWLEDGE","POWER","LOYALTY","FREEDOM","SURVIVAL"]')),
  (1, 6, 'Would you sacrifice one to save a thousand?', 'choice', 0, json('["YES_ALWAYS","NEVER","IF_I_CHOOSE","DEPENDS"]')),
  (1, 7, 'The negotiation fails. What’s your move?', 'choice', 1, json('["FIGHT","NEGOTIATE","MANIPULATE","SABOTAGE","ESCAPE"]')),
  (1, 8, 'Risk everything for a 10% chance to save your side?', 'choice', 0, json('["YES_HOPE","NO_PLAN","YES_CONTROL","NEVER_CAUSE"]')),
  (1, 9, 'How has the world changed you physically?', 'choice', 0, json('["CYBERNETIC","GENETIC","EXOSUIT","HUMAN"]')),
  (1,10, 'What is your strongest skill?', 'choice', 1, json('["HACKING","DIPLOMACY","COMBAT","ENGINEERING","INTEL"]')),
  (1,11, 'Who do you trust most?', 'choice', 1, json('["HUMANS","AI","NOONE"]')),
  (1,12, 'Which resource do you value most?', 'choice', 0, json('["OXYGEN","WATER","ENERGY","DATA","FOOD"]')),
  (1,13, 'Your tone under stress?', 'choice', 0, json('["SILENT","COMMAND","SARCASM","CALM"]')),
  (1,14, 'Your fatal flaw?', 'choice', 0, json('["PRIDE","FEAR","OBSESSION","GREED","NAIVETY"]')),
  (1,15, 'Greatest secret', 'text', 0, NULL),
  (1,16, 'Your catchphrase', 'text', 0, NULL),
  (1,17, 'Choose your quirk (free text, examples allowed)', 'text', 0, NULL),
  (1,18, 'Last sentence before the end', 'text', 0, NULL);

-- Options (linked by q_num)
-- Q2 options
INSERT INTO options (question_id, code, label, ord)
  SELECT id, 'OCEAN', 'Beneath the waves—pressure-forged cities of steel', 1 FROM questions WHERE q_num=2;
INSERT INTO options (question_id, code, label, ord)
  SELECT id, 'MOON', 'Among the lunar colonies—close to the stars', 2 FROM questions WHERE q_num=2;
INSERT INTO options (question_id, code, label, ord)
  SELECT id, 'EARTH', 'On scarred Earth—holding onto what remains', 3 FROM questions WHERE q_num=2;

-- Q3 options
INSERT INTO options (question_id, code, label, ord) SELECT id, 'PROTAG', 'Protagonist—reluctant hero', 1 FROM questions WHERE q_num=3;
INSERT INTO options (question_id, code, label, ord) SELECT id, 'ANTAG', 'Antagonist—the one who believes the others are wrong', 2 FROM questions WHERE q_num=3;
INSERT INTO options (question_id, code, label, ord) SELECT id, 'ALLY', 'Loyal ally', 3 FROM questions WHERE q_num=3;
INSERT INTO options (question_id, code, label, ord) SELECT id, 'SIDEKICK', 'Quirky sidekick', 4 FROM questions WHERE q_num=3;
INSERT INTO options (question_id, code, label, ord) SELECT id, 'ROGUE', 'Rogue agent', 5 FROM questions WHERE q_num=3;
INSERT INTO options (question_id, code, label, ord) SELECT id, 'VILLAIN', 'Villain—order requires control', 6 FROM questions WHERE q_num=3;

-- (options for Q4, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14 follow the same pattern)

COMMIT;