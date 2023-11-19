DROP TABLE IF EXISTS admin;
-- Supprimer le type enum s'il existe
DROP TYPE IF EXISTS AdminRole;
-- Créer le type enum pour les rôles d'administrateurs
CREATE TYPE AdminRole AS ENUM ('Super Admin', 'Administrator', 'Moderator');

-- Créer la table Admin avec le type enum pour les rôles d'administrateurs
CREATE TABLE IF NOT EXISTS admin (
     admin_id SERIAL PRIMARY KEY,
     admin_name VARCHAR(200),
     admin_role AdminRole, -- Utilisation du type enum pour la colonne de rôle
     admin_password VARCHAR(8)
);

-- Ajouter des données à la table Admin avec des rôles d'administrateurs
INSERT INTO admin (admin_name, admin_role, admin_password)
VALUES
    ('Admin1', 'Super Admin', 'motdepasse1'),
    ('Admin2', 'Administrator', 'motdepasse2'),
    ('Admin3', 'Moderator', 'motdepasse3');
