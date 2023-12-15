create table if not exists "transaction_categories" (
    category_id serial primary key,
    category_name varchar(100) unique
);

insert into transaction_categories (category_name)
values
       ('Salaire'),
       ('Alimentation'),
       ('Transport'),
       ('Loisirs'),
       ('Factures'),
       ('Prêts');
