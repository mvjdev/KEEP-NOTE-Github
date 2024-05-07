-- Création de la base de données
CREATE DATABASE gestion_stations;

-- Sélection de la base de données pour les opérations suivantes
\c gestion_stations;

-- Création de la table Lieu
CREATE TABLE Lieu (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

-- Création de la table Station
CREATE TABLE Station (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    lieu_id INTEGER,
    FOREIGN KEY (lieu_id) REFERENCES Lieu(id)
);

-- Création de la table Produit
CREATE TABLE Produit (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prix DECIMAL(5, 3),
    taux_evaporation DECIMAL(5, 2)
);

-- Création de la table Mouvement
CREATE TABLE Mouvement (
    id SERIAL PRIMARY KEY,
    produit_id INTEGER,
    station_id INTEGER,
    type ENUM('Entrante', 'Sortante'),
    quantite INTEGER,
    date TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (produit_id) REFERENCES Produit(id),
    FOREIGN KEY (station_id) REFERENCES Station(id)
);

-- Création de la table Vente
CREATE TABLE Vente (
    id SERIAL PRIMARY KEY,
    produit_id INTEGER,
    station_id INTEGER,
    quantite INTEGER,
    date TIMESTAMP WITH TIME ZONE,
    montant DECIMAL(10, 2),
    FOREIGN KEY (produit_id) REFERENCES Produit(id),
    FOREIGN KEY (station_id) REFERENCES Station(id)
);

-- Création de la table ProduitTemplate
CREATE TABLE ProduitTemplate (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prix DECIMAL(5, 3)
);

-- Création de la table Stock
CREATE TABLE Stock (
    produit_id INTEGER,
    station_id INTEGER,
    quantite_stock INTEGER,
    PRIMARY KEY (produit_id, station_id),
    FOREIGN KEY (produit_id) REFERENCES Produit(id),
    FOREIGN KEY (station_id) REFERENCES Station(id)
);

-- Insertion de données d'exemple dans Lieu
INSERT INTO Lieu (nom) VALUES
('Lieu Central'),
('Lieu 1'),
('Lieu 2');

-- Insertion de données d'exemple dans ProduitTemplate
INSERT INTO ProduitTemplate (nom, prix) VALUES
('Gasoil', 4900),
('Essence', 5900),
('Pétrole', 2130);

-- Insertion de données d'exemple dans Produit
INSERT INTO Produit (nom, prix, taux_evaporation) VALUES
('Gasoil', 4900, 50),
('Essence', 5900, 100),
('Pétrole', 2130, 10);

-- Insertion de données d'exemple dans Station
INSERT INTO Station (nom, lieu_id) VALUES
('Station Centrale', 1),
('Station 1', 2),
('Station 2', 3);

-- Insertion de données d'exemple dans Mouvement
INSERT INTO Mouvement (produit_id, station_id, type, quantite, date) VALUES
(1, 1, 'Entrante', 1000, '2024-05-01 08:00:00+00'),
(2, 1, 'Entrante', 2000, '2024-05-01 08:00:00+00'),
(3, 1, 'Entrante', 500, '2024-05-01 08:00:00+00'),
(1, 1, 'Sortante', 50, '2024-05-01 08:15:00+00'),
(2, 1, 'Sortante', 10, '2024-05-01 08:17:00+00'),
(3, 1, 'Sortante', 90, '2024-05-02 08:01:00+00');

-- Insertion de données d'exemple dans Vente
INSERT INTO Vente (produit_id, station_id, quantite, date, montant) VALUES
(1, 1, 100, '2024-05-01 09:00:00+00', 490000),
(2, 1, 50, '2024-05-01 09:30:00+00', 295000),
(3, 1, 20, '2024-05-01 10:00:00+00', 42600);

-- Insertion de données d'exemple dans Stock
INSERT INTO Stock (produit_id, station_id, quantite_stock) VALUES
(1, 1, 5000),
(2, 1, 3000),
(3, 1, 2000),
(1, 2, 4000),
(2, 2, 2500),
(3, 2, 1500);
