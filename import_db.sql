CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  parent_id INTEGER,
  question_id INTEGER,
  author_id INTEGER,
  FOREIGN KEY (parent_id)  REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  liker_id INTEGER,
  FOREIGN KEY (liker_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);





--
--
-- INSERT INTO
--   users (fname, lname)
-- VALUES
--   ('Adam', 'Intrator'), ('Nat', 'Homer');
--
-- INSERT INTO
--   users (fname, lname)
-- VALUES
--   ('tommy', 'duek'), ('Beyonce', 'Knowles'), ('Barack', 'Obama');
--
-- INSERT INTO
--   questions (title, body, author_id)
-- VALUES
--   ('question1', 'question1 body', (SELECT id FROM users WHERE fname = 'Adam'));
--
-- INSERT INTO
--   questions (title, body, author_id)
-- VALUES
--   ('life', 'meaning of life', (SELECT id FROM users WHERE fname = 'Beyonce'));
--
-- INSERT INTO
--   question_likes (question_id, liker_id)
-- VALUES
--   ((SELECT id FROM questions WHERE author_id = 1), (SELECT id FROM users WHERE fname = 'Nat'));
--
--
--
-- INSERT INTO
--   replies (body, parent_id, question_id, author_id)
-- VALUES
--   ('there is no meaning', NULL, 2, 4);
--
-- INSERT INTO
--   replies (body, parent_id, question_id, author_id)
-- VALUES
--   ('but why??', 1, 2, 5);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (5, 1);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (5, 2);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (4, 1);
