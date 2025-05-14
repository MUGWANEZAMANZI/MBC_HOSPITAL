-- Add medications_prescribed field to store prescribed medications
ALTER TABLE Diagnosis ADD COLUMN MedicationsPrescribed VARCHAR(255) NULL;

-- Add follow_up_date field for scheduling patient follow-ups
ALTER TABLE Diagnosis ADD COLUMN FollowUpDate DATE NULL;

-- Add DiagnosisDate to record when the diagnosis was made/updated
ALTER TABLE Diagnosis ADD COLUMN DiagnosisDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add NurseAssessment field to store initial assessment by the nurse
ALTER TABLE Diagnosis ADD COLUMN NurseAssessment TEXT NULL;

-- Update existing DiagnoStatus values to match the frontend options (if needed)
-- The current enum in DB is 'Referrable','Not Referable','Action Required'
-- But the frontend form has 'Positive' and 'Negative' options
ALTER TABLE Diagnosis MODIFY COLUMN DiagnoStatus ENUM('Referrable','Not Referable','Action Required','Positive','Negative') NOT NULL DEFAULT 'Action Required';

-- Sample query to show the updated table structure
-- DESC Diagnosis; 