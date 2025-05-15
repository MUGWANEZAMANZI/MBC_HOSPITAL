# MBC Hospital Patient Portal

## Overview

The MBC Hospital Patient Portal is a secure web application that allows patients to access their medical records, view diagnosis results, and manage appointments. The portal provides a user-friendly interface for patients to stay informed about their healthcare journey.

## Features

- **Secure Login**: Patients can securely log in using their phone number and patient ID
- **View Diagnosis Results**: Access complete diagnosis history including results, medications, and follow-up instructions
- **Personal Information**: View personal information stored in the hospital system
- **Appointment Management**: View upcoming appointments and schedule new ones
- **Print Functionality**: Print diagnosis reports and medical records

## Technical Implementation

The Patient Portal consists of the following components:

1. **Patient Login Page (`patient_login.jsp`)**: 
   - Provides a dedicated login form for patients
   - Validates patient credentials using phone number and patient ID

2. **Patient Dashboard (`patient_dashboard.jsp`)**: 
   - Displays patient information and diagnosis results
   - Provides access to appointment scheduling

3. **Backend Servlets**:
   - `PatientLoginServlet`: Handles patient authentication
   - `PatientLogoutServlet`: Manages patient logout
   - `PatientViewDiagnosisServlet`: Retrieves specific diagnosis details

## Security Considerations

- Patient sessions are separate from staff sessions
- Access control ensures patients can only view their own records
- Session timeout for security
- Input validation to prevent SQL injection

## Database Schema

The patient portal uses the existing database tables:
- `patients`: Stores patient information
- `diagnoses`: Contains diagnosis records linked to patients
- `users`: Contains healthcare provider information

## Usage Instructions

1. **Accessing the Portal**:
   - Navigate to the hospital homepage
   - Click on "Patient Portal"
   - Enter your phone number and patient ID

2. **Viewing Diagnosis Results**:
   - After logging in, scroll to "My Diagnosis Results"
   - Click "View Details" on any diagnosis to see complete information

3. **Scheduling Appointments**:
   - Click "Schedule an Appointment" in the Upcoming Appointments section

4. **Printing Records**:
   - Use the "Print Information" or "Print Details" buttons to print records

## Future Enhancements

- Mobile application for easier access
- Notification system for new diagnosis results and appointment reminders
- Secure messaging with healthcare providers
- Online bill payment
- Prescription refill requests 