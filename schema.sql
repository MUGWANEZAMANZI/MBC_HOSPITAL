-- MBC Hospital Management System — Database Schema
-- Run this file first on a fresh MySQL 8.x instance.
-- Connection: localhost:3306, user: root, password: (empty)

CREATE DATABASE IF NOT EXISTS PMS
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE PMS;

-- Staff and patient accounts (login credentials)
CREATE TABLE IF NOT EXISTS Users (
    UserID      INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(100)  NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL,
    userType    ENUM('Admin','Nurse','Doctor','Patient') NOT NULL,
    is_verified BOOLEAN       NOT NULL DEFAULT FALSE
);

-- Registered patients
CREATE TABLE IF NOT EXISTS Patients (
    PatientID        INT AUTO_INCREMENT PRIMARY KEY,
    FirstName        VARCHAR(100)  NOT NULL,
    LastName         VARCHAR(100)  NOT NULL,
    Telephone        VARCHAR(20)   NOT NULL,
    Email            VARCHAR(255),
    Address          TEXT,
    PImageLink       VARCHAR(500),
    RegisteredBy     INT,
    RegistrationDate TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RegisteredBy) REFERENCES Users(UserID)
);

-- Doctor profiles (separate from Users login record)
CREATE TABLE IF NOT EXISTS Doctors (
    DoctorID     INT AUTO_INCREMENT PRIMARY KEY,
    FirstName    VARCHAR(100) NOT NULL,
    LastName     VARCHAR(100) NOT NULL,
    Telephone    VARCHAR(20),
    Email        VARCHAR(255),
    Address      TEXT,
    HospitalName VARCHAR(255),
    RegisteredBy VARCHAR(100),
    status       VARCHAR(50)
);

-- Nurse profiles (separate from Users login record)
CREATE TABLE IF NOT EXISTS Nurses (
    NurseId      INT AUTO_INCREMENT PRIMARY KEY,
    FirstName    VARCHAR(100) NOT NULL,
    LastName     VARCHAR(100) NOT NULL,
    Telephone    VARCHAR(20),
    Email        VARCHAR(255),
    Address      TEXT,
    HealthCenter VARCHAR(255),
    RegisteredBy VARCHAR(100),
    Status       VARCHAR(50)
);

-- Diagnosis records — one per patient, updated through the workflow
CREATE TABLE IF NOT EXISTS Diagnosis (
    DiagnosisID          INT AUTO_INCREMENT PRIMARY KEY,
    PatientID            INT  NOT NULL,
    NurseID              INT,
    DoctorID             INT,
    DiagnoStatus         ENUM('Action Required','Referrable','Not Referable','Positive','Negative')
                             NOT NULL DEFAULT 'Action Required',
    Result               VARCHAR(255) DEFAULT 'Pending',
    MedicationsPrescribed VARCHAR(255),
    FollowUpDate         DATE,
    DiagnosisDate        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NurseAssessment      TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (NurseID)   REFERENCES Users(UserID),
    FOREIGN KEY (DoctorID)  REFERENCES Users(UserID)
);
