-- MBC Hospital Management System — Admin Seed
-- Run AFTER schema.sql.
-- Creates the first admin account so you can log in and verify other users.
--
-- WARNING: passwords are stored in plain text. Change 'admin123' before
-- exposing this application outside a local development machine.

USE PMS;

INSERT INTO Users (username, password, userType, is_verified)
VALUES ('admin', 'admin123', 'Admin', TRUE);

-- Admin accounts bypass is_verified automatically (see LoginServlet.java:44),
-- but setting TRUE here keeps the row consistent.
