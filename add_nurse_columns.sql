-- Safe to run multiple times by checking if columns exist before adding them

-- Add medications_prescribed field to store prescribed medications
SET @MedsColumnExists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Diagnosis' AND COLUMN_NAME = 'MedicationsPrescribed'
);

SET @NurseAssessColumnExists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Diagnosis' AND COLUMN_NAME = 'NurseAssessment'
);

SET @FollowUpColumnExists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Diagnosis' AND COLUMN_NAME = 'FollowUpDate'
);

-- Add columns only if they don't exist
SET @MedsAddSQL = IF(@MedsColumnExists = 0, 'ALTER TABLE Diagnosis ADD COLUMN MedicationsPrescribed VARCHAR(255) NULL', 'SELECT "MedicationsPrescribed column already exists"');
SET @NurseAssessAddSQL = IF(@NurseAssessColumnExists = 0, 'ALTER TABLE Diagnosis ADD COLUMN NurseAssessment TEXT NULL', 'SELECT "NurseAssessment column already exists"');
SET @FollowUpAddSQL = IF(@FollowUpColumnExists = 0, 'ALTER TABLE Diagnosis ADD COLUMN FollowUpDate DATE NULL', 'SELECT "FollowUpDate column already exists"');

PREPARE MedsStmt FROM @MedsAddSQL;
PREPARE NurseAssessStmt FROM @NurseAssessAddSQL;
PREPARE FollowUpStmt FROM @FollowUpAddSQL;

EXECUTE MedsStmt;
EXECUTE NurseAssessStmt;
EXECUTE FollowUpStmt;

DEALLOCATE PREPARE MedsStmt;
DEALLOCATE PREPARE NurseAssessStmt;
DEALLOCATE PREPARE FollowUpStmt;

-- Make sure DiagnoStatus column accepts all needed values
ALTER TABLE Diagnosis MODIFY COLUMN DiagnoStatus ENUM('Referrable','Not Referable','Action Required','Positive','Negative') NOT NULL DEFAULT 'Action Required'; 