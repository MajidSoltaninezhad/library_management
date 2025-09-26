-- CREATE DATABASE library;

--// Creat tables

CREATE TABLE brunch (
    brunch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10) NOT NULL,
    brunch_address VARCHAR(100) NOT NULL,
    conntact_number VARCHAR(15) NOT NULL
);


