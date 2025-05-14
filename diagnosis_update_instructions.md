# Diagnosis Table Update Instructions

## Overview
The diagnosis form has been updated to include additional fields for doctors to provide more comprehensive diagnosis information. This update includes:

1. Medications prescribed
2. Follow-up date scheduling
3. Timestamp of diagnosis
4. Nurse assessment storage
5. Updated diagnosis status options

## Database Update Instructions

1. Run the SQL script `diagnosis_table_updates.sql` on your MySQL database:

```bash
mysql -u your_username -p your_database_name < diagnosis_table_updates.sql
```

Or you can copy and paste the contents of the script directly into your MySQL client.

## Code Changes Made

The following Java classes have been updated or created:

1. `Diagnosis.java` - Updated model with new fields
2. `DiagnosisViewServlet.java` - Updated to handle new fields in database queries
3. `UpdateDiagnosisServlet.java` - New servlet to handle form submissions
4. `diagnosis_view.jsp` - Updated to display the new fields

## Troubleshooting

If you encounter the 404 error with the `/update-diagnosis` URL, make sure your application has been redeployed after making these changes.

If fields are showing as null in the interface, you may need to rebuild all classes and restart your Tomcat server.

## Testing the Changes

1. Login as a doctor
2. Navigate to the patient diagnosis form
3. Fill in the new fields (medications, follow-up date)
4. Submit the form
5. Check the diagnosis view page to verify the new fields are displayed correctly 