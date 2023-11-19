-- Supprimer les tables si elles existent
DROP TABLE IF EXISTS book, author, subscriber;

-- Supprimer le type enum s'il existe
DROP TYPE IF EXISTS Topic;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS admin;
-- Supprimer le type enum s'il existe
DROP TYPE IF EXISTS AdminRole;

-- Créer le type enum Topic
CREATE TYPE Topic AS ENUM ('COMEDY', 'ROMANCE', 'OTHER');

-- Créer la table Author
CREATE TABLE IF NOT EXISTS author (
      author_id SERIAL PRIMARY KEY,
      author_name VARCHAR(200),
      gender_author CHAR(1)
);

-- Créer la table Book
CREATE TABLE IF NOT EXISTS book (
      id SERIAL PRIMARY KEY,
      book_id VARCHAR(100),
      book_name VARCHAR(50),
      topic Topic,
      page_number INT,
      release_date DATE,
      author_id INT,
      is_borrow BOOLEAN,
      CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES author (author_id)
);

-- Créer la table Subscriber
CREATE TABLE IF NOT EXISTS subscriber (
      subscriber_id SERIAL PRIMARY KEY,
      subscriber_name VARCHAR(200),
      subscriber_reference VARCHAR(200),
      borrowed_book_id INT REFERENCES book (id), -- Référence à l'ID du livre emprunté
      borrow BOOLEAN
);

-- Créer le type enum pour les rôles d'administrateurs
CREATE TYPE AdminRole AS ENUM ('Super Admin', 'Administrator', 'Moderator');

-- Créer la table Admin avec le type enum pour les rôles d'administrateurs
CREATE TABLE IF NOT EXISTS admin (
     admin_id SERIAL PRIMARY KEY,
     admin_name VARCHAR(200),
     admin_role AdminRole,
     admin_password VARCHAR(200) -- Stockage des mots de passe en clair
);


-- Ajouter des données à la table Author
INSERT INTO author (author_name, gender_author)
VALUES
    ('John Doe', 'M'),
    ('Jane Smith', 'F'),
    ('Alex Johnson', 'M');

-- Ajouter des données à la table Book
INSERT INTO book (book_id, book_name, topic, page_number, release_date, author_id, is_borrow)
VALUES
      (uuid_generate_v4(), 'Book1', 'COMEDY', 200, '2023-01-01', 1, TRUE),
      (uuid_generate_v4(), 'Book2', 'ROMANCE', 300, '2022-05-15', 2, FALSE),
      (uuid_generate_v4(), 'Book3', 'OTHER', 250, '2023-10-20', 3, TRUE);


-- Ajouter des données à la table Subscriber
INSERT INTO subscriber (subscriber_name, subscriber_reference, borrowed_book_id, borrow)
VALUES
     ('Alice', uuid_generate_v4(), 1, TRUE), -- Alice emprunte le livre avec l'ID 1
     ('Bob', uuid_generate_v4(), NULL, FALSE), -- Bob n'emprunte aucun livre pour le moment
     ('Eve', uuid_generate_v4(), 3, TRUE); -- Eve emprunte le livre avec l'ID 3

-- Ajouter des données à la table Admin avec des rôles d'administrateurs
INSERT INTO admin (admin_name, admin_role, admin_password)
VALUES
    ('Admin1', 'Super Admin', 'motdepasse1'),
    ('Admin2', 'Administrator', 'motdepasse2'),
    ('Admin3', 'Moderator', 'motdepasse3');

