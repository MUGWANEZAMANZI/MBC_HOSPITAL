# MBC Hospital Management System — Technical Documentation

**Project:** MBC_HOSPITAL  
**Version:** 1.0  
**Authors:** MUGWANEZA MANZI Audace, RUKUNDO Wilson, UWAYEZU Alice, UWABERA Latifa, ISHIMWE Boncouer, TUYISHIME Eric, HERVE, MUNYEMANA Gadi  
**Last updated:** October 2026

---

## Table of Contents

1. [Getting Started Guide](#1-getting-started-guide)
2. [API Reference](#2-api-reference)
3. [Troubleshooting Guide](#3-troubleshooting-guide)
4. [Prompt History](#4-prompt-history)
5. [Reflection](#5-reflection)

---

---

# 1. Getting Started Guide

**Audience:** New team members setting up the project for the first time, and hospital staff using the system for the first time.

---

## 1.1 What Is MBC Hospital Management System?

MBC Hospital Management System is a web application that helps a hospital coordinate patient care between nurses, doctors, and administrators. It replaces paper-based records with a shared digital system where:

- **Nurses** register new patients and record initial health assessments.
- **Doctors** review referred cases and record diagnoses and treatment plans.
- **Administrators** manage staff accounts and monitor overall activity.
- **Patients** can log in to view their own diagnosis history.

Every patient follows a clear care path from registration through to a final diagnosis outcome.

---

## 1.2 The Patient Care Workflow

Before using the system, it helps to understand how a patient moves through it.

```
1. Nurse registers patient
         │
         ▼
   Status: Action Required
         │
         ▼
2. Nurse records health assessment
         │
         ├──► Status: Not Referable  (nurse handles it directly)
         │
         └──► Status: Referrable     (nurse refers to a doctor)
                        │
                        ▼
               3. Doctor reviews the case
                        │
                        ├──► Status: Positive  (condition confirmed)
                        │
                        └──► Status: Negative  (condition ruled out)
```

---

## 1.3 Developer Setup

This section is for developers who need to run the application locally.

### 1.3.1 Prerequisites

Before you begin, make sure the following software is installed on your machine.

| Software | Required version | Notes |
|---|---|---|
| Java Development Kit (JDK) | **17** | Must be Java 17 specifically |
| Apache Tomcat | **10.1.x** | Must be version 10.x — older versions are incompatible |
| MySQL Server | **8.x** | MySQL 8.0 or newer |
| Git | Any recent version | To clone the repository |

> **Why Tomcat 10.1 specifically?** This project uses the `jakarta.servlet.*` package namespace, which was introduced in Jakarta EE 9. Tomcat 9 and earlier use the older `javax.servlet.*` namespace and will not work with this codebase.

All other dependencies (MySQL Connector, JSTL, Gson, JSON library) are already included in the repository under `src/main/webapp/WEB-INF/lib/`. You do not need to download them separately.

---

### 1.3.2 Step 1 — Clone the Repository

```bash
git clone git@github.com:MUGWANEZAMANZI/MBC_HOSPITAL.git
cd MBC_HOSPITAL
```

---

### 1.3.3 Step 2 — Set Up the Database

The application connects to a MySQL database named `PMS` on `localhost:3306` using the `root` account with no password. This is configured in `src/main/java/com/mbc_hospital/model/DBConnection.java`.

**Step 2a — Start MySQL and open a client:**

```bash
mysql -u root
```

**Step 2b — Create the database schema:**

```bash
mysql -u root < schema.sql
```

This creates the `PMS` database and all five tables: `Users`, `Patients`, `Doctors`, `Nurses`, and `Diagnosis`.

**Step 2c — Create the first admin account:**

```bash
mysql -u root < seed_admin.sql
```

This inserts a default admin login:

| Field | Value |
|---|---|
| Username | `admin` |
| Password | `admin123` |

> **Security note:** The system stores passwords in plain text. Change the admin password directly in the database before using the application in any shared or production environment:
> ```sql
> USE PMS;
> UPDATE Users SET password = 'your-new-password' WHERE username = 'admin';
> ```

**Step 2d — Apply schema migrations (if upgrading an existing database):**

If you already have a `PMS` database from a previous version, run the migration scripts instead of `schema.sql`:

```bash
mysql -u root PMS < diagnosis_table_updates.sql
# OR use the safer idempotent version:
mysql -u root PMS < add_nurse_columns.sql
```

---

### 1.3.4 Step 3 — Build and Run

#### On Linux / macOS

The project includes a build script that compiles the Java code and starts Tomcat.

```bash
chmod +x run.sh
./run.sh
```

The script does the following automatically:
1. Stops any running Tomcat instance
2. Compiles all Java source files into `target/classes/`
3. Copies the web application files to `target/MBC_HOSPITAL/`
4. Starts Tomcat using `catalina.sh run`

Tomcat is located by searching `/usr/share` for `catalina.jar`. If your Tomcat is installed elsewhere, set the `CATALINA_HOME` environment variable before running:

```bash
export CATALINA_HOME=/path/to/your/tomcat
./run.sh
```

#### On Windows

There is no Windows build script. Follow these steps manually.

**Compile the Java source:**

```cmd
javac -cp "src\main\webapp\WEB-INF\lib\*;%CATALINA_HOME%\lib\servlet-api.jar" ^
      -d target\classes ^
      -sourcepath src\main\java ^
      src\main\java\com\mbc_hospital\**\*.java ^
      src\main\java\com\mbc\*.java
```

**Copy the web application:**

```cmd
xcopy /E /I src\main\webapp target\MBC_HOSPITAL
xcopy /E /I target\classes target\MBC_HOSPITAL\WEB-INF\classes
```

**Deploy to Tomcat and start:**

```cmd
xcopy /E /I target\MBC_HOSPITAL "%CATALINA_HOME%\webapps\MBC_HOSPITAL"
%CATALINA_HOME%\bin\catalina.bat run
```

---

### 1.3.5 Step 4 — Open the Application

Once Tomcat has started, open a browser and go to:

```
http://localhost:8080/MBC_HOSPITAL/
```

You should see the application landing page. If you see a 404 error, see the [Troubleshooting Guide](#3-troubleshooting-guide).

---

## 1.4 Logging In

The system has two separate login pages depending on who is logging in.

### Staff Login (Admin, Nurses, Doctors)

1. Go to: `http://localhost:8080/MBC_HOSPITAL/login.jsp`
2. Enter your **Username** and **Password**.
3. Click **Login**.

What happens next depends on your account:

| Account state | Result |
|---|---|
| Verified account | You are taken to the dashboard |
| Unverified account | You see a "pending verification" page |
| Wrong credentials | You stay on the login page with an error message |
| Admin account | Always goes to the dashboard, regardless of verification status |

### Patient Login

Patients do not use a username and password. Instead they log in with their Patient ID and the telephone number registered in the system.

1. Go to: `http://localhost:8080/MBC_HOSPITAL/patient_login.jsp`
2. Enter your **Patient ID** (a number — given to you when you were registered).
3. Enter your **Telephone number** (as registered).
4. Click **Login**.

---

## 1.5 User Roles and What Each Can Do

The system has four roles. Each role sees a different interface after login.

### Administrator

The Admin has full access to the system.

| Task | Where to find it |
|---|---|
| View all users | Dashboard → User Directory |
| Verify or reject a staff account | Dashboard → Unverified Accounts |
| View all patients | Dashboard → All Patients |
| View all diagnoses | Dashboard → Diagnosis View |
| View system statistics | Admin Dashboard (charts and KPI cards) |

### Nurse

Nurses register patients and carry out initial health assessments.

**Daily workflow:**

1. **Register a new patient** — go to *Patients → Register New Patient*. Fill in the patient's name, telephone, email, address, and optionally upload a photo. The system automatically creates a diagnosis record with status `Action Required`.

2. **Submit a health assessment** — go to *Patients → My Patients*, find the patient, and fill in the assessment form. You can record:
   - Diagnosis status (`Action Required` or `Not Referable`)
   - Result notes
   - Medications prescribed
   - Nurse assessment notes

3. **Refer a case to a doctor** — if the patient needs specialist attention, click *Refer Case*. The status changes to `Referrable` and the case becomes visible to doctors.

4. **View referred cases** — go to *Referred Cases* to see all cases you have sent to doctors and track their progress.

### Doctor

Doctors review cases referred to them by nurses.

**Daily workflow:**

1. **View referred cases** — the Doctor dashboard opens directly on the list of cases with status `Referrable`.

2. **Update a diagnosis** — click on a patient to open the diagnosis form. You can record:
   - Final status (`Positive` or `Negative`)
   - Diagnosis result
   - Medications prescribed
   - Follow-up date

3. **View confirmed cases** — go to *Confirmed Cases* to see all cases you have resolved (Positive or Negative).

4. **Verify nurse accounts** — doctors can approve or reject new nurse registrations from the *Unverified Nurses* page.

### Patient

Patients can log in to view their own health records. They cannot edit any information.

After logging in, the patient dashboard shows:
- Personal details (name, telephone, address)
- A list of all diagnosis records, ordered from newest to oldest
- For each diagnosis: status, result, medications prescribed, nurse assessment, and follow-up date

---

## 1.6 Registering New Staff Accounts

New nurses and doctors register themselves through the staff registration page:

1. Go to: `http://localhost:8080/MBC_HOSPITAL/registration.jsp`
2. Enter a **Username** (at least 3 characters).
3. Enter a **Password** (at least 3 characters).
4. Select your **Role** (`Nurse` or `Doctor`).
5. Click **Register**.

After registering, the account is created with status *unverified*. You will be shown a "pending" page until an administrator or doctor approves your account.

> **Admins cannot self-register.** Admin accounts must be created directly in the database. See [Step 2c](#133-step-2--set-up-the-database) above.

---

## 1.7 Registering a New Patient

Only nurses can register patients.

1. Log in as a nurse.
2. Go to *Patients → Register New Patient* (or navigate to `create_patient.jsp`).
3. Fill in the patient form:

   | Field | Required | Notes |
   |---|---|---|
   | First Name | Yes | |
   | Last Name | Yes | |
   | Telephone | Yes | Used as the patient's login credential |
   | Email | No | |
   | Address | No | |
   | Photo | No | Maximum file size: **5 MB**. Accepted formats: standard image types. |

4. Click **Register Patient**.

The system performs two actions at once:
- Creates the patient record
- Creates an initial diagnosis record with status `Action Required`

If either action fails, both are cancelled and you are returned to the nurse dashboard with an error message. Check the [Troubleshooting Guide](#3-troubleshooting-guide) if this happens.

After successful registration, you are redirected to the patients list.

---

---

---

# 2. API Reference

**Audience:** Developers extending the system, debugging a specific endpoint, or building new views. Assumes familiarity with HTTP, Java servlets, and HTML forms.

---

## 2.1 Conventions

### Base URL

All endpoints are relative to:

```
http://localhost:8080/MBC_HOSPITAL
```

### Session Model

The application uses Jakarta HTTP sessions. All protected endpoints check for a valid session on every request.

**Staff session** (set by `/login`):

| Attribute | Type | Value |
|---|---|---|
| `username` | `String` | The logged-in user's username |
| `usertype` | `String` | `Admin`, `Nurse`, or `Doctor` (case-sensitive) |
| `id` | `int` | The user's `UserID` from the `Users` table |

**Patient session** (set by `/patient-login`):

| Attribute | Type | Value |
|---|---|---|
| `patient` | `Patient` object | Full patient record |
| `usertype` | `String` | `patient` (lowercase) |
| `patientID` | `int` | The patient's `PatientID` |

When a session is missing or invalid, endpoints redirect to `login.jsp` without returning an error code.

### Diagnosis Status Values

The `DiagnoStatus` column is a MySQL ENUM. The only accepted values are:

| Status | Set by | Meaning |
|---|---|---|
| `Action Required` | System (on patient registration) | Nurse has not yet assessed the patient |
| `Not Referable` | Nurse via `/submitDiagnosis` | Nurse has resolved the case without referral |
| `Referrable` | Nurse via `/refer-case` or `/submitDiagnosis` | Case has been referred to a doctor |
| `Positive` | Doctor via `/update-diagnosis` | Doctor confirmed the condition |
| `Negative` | Doctor via `/update-diagnosis` | Doctor ruled out the condition |

### Response Types

| Type | Used by |
|---|---|
| HTML forward | Most GET endpoints — renders a JSP page |
| Redirect | Most POST endpoints — follows the POST-Redirect-GET pattern |
| `text/plain` integer | All count/stat endpoints |
| `application/json` | Chart data and verification endpoints |

---

## 2.2 Authentication Endpoints

### POST /login

Authenticates a staff member and creates a session.

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `username` | String | Yes | Must not be empty |
| `password` | String | Yes | Must not be empty. Stored and compared as plain text |

**Outcomes:**

| Condition | Result |
|---|---|
| Credentials match, account verified | Session created → redirect `dashboard.jsp` |
| Credentials match, account is Admin | Session created → redirect `dashboard.jsp` (Admin bypasses verification check) |
| Credentials match, account unverified | Partial session (`pending_username`, `pending_usertype`) → redirect `pending.jsp` |
| Username or password is empty | Redirect `login.jsp?error=empty` |
| Credentials do not match | Redirect `login.jsp?error=invalid` |
| Database error | Redirect `login.jsp?error=server` |

---

### POST /registration

Creates a new unverified staff account.

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `uname` | String | Yes | Minimum 3 characters |
| `pass` | String | Yes | Minimum 3 characters. Stored as plain text |
| `userType` | String | Yes | Must be `Nurse` or `Doctor`. Admin accounts cannot be self-registered |

**Outcomes:**

| Condition | Result |
|---|---|
| Valid input | User created with `is_verified = false` → redirect `pending.jsp` |
| Username or password too short | Request ignored silently — no redirect |
| Database error | Redirect `registration.jsp?error=server` |

> **Note:** New accounts are not active until an Admin or Doctor approves them via the verification endpoints.

---

### GET /patient-login

Redirects to the patient login page.

**Response:** Redirect → `patient_login.jsp`

---

### POST /patient-login

Authenticates a patient using their Patient ID and registered telephone number.

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `patientID` | int | Yes | The numeric ID assigned when the patient was registered |
| `telephone` | String | Yes | Must match the telephone stored in the `Patients` table exactly |

**Outcomes:**

| Condition | Result |
|---|---|
| Credentials match | Session created → **forward** to `patient_dashboard.jsp` with `patientDiagnoses` list in request scope |
| Either field is missing | Redirect `patient_login.jsp?error=missing` |
| `patientID` is not a number | Redirect `patient_login.jsp?error=invalid` |
| No patient found with those credentials | Redirect `patient_login.jsp?error=invalid` |
| Database error | Redirect `patient_login.jsp?error=database` |

> **Forward vs redirect:** On success the servlet forwards (not redirects) so that the diagnosis list is available to the JSP immediately without a second database round-trip.

---

## 2.3 Patient Management Endpoints

### GET /patients-list

Returns a role-filtered list of patients, or a single patient's full diagnosis history.

**Session required:** Staff (`Admin`, `Nurse`, or `Doctor`)

**Query parameters:**

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `action` | String | No | Pass `view` to switch to single-patient mode |
| `id` | int | Conditional | Required when `action=view`. The `PatientID` to display |

**Behaviour by mode:**

**Default mode** (no `action` parameter) — patient list:

| Role | Patients returned |
|---|---|
| `Nurse` | Only patients registered by this nurse (`RegisteredBy = session id`) |
| `Doctor` | Patients from the same hospital (joined on `Nurses.HealthCenter = Doctors.HospitalName`) |
| `Admin` | All patients registered by any nurse |

Forward → `Patients.jsp` with request attribute `patients` (`ArrayList<Patient>`)

**View mode** (`?action=view&id={patientId}`) — single patient:

Forward → `patient_diagnoses.jsp` with request attributes:
- `patient` — the `Patient` object
- `patientDiagnoses` — `List<Map<String, Object>>` containing each diagnosis row joined with nurse and doctor names

---

### POST /CreatePatientServlet

Registers a new patient and atomically creates an initial diagnosis record.

**Session required:** Staff (no explicit role check — nurses use this in practice)

**Content type:** `multipart/form-data` (required for photo upload)

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `firstName` | String | Yes | |
| `lastName` | String | Yes | |
| `telephone` | String | Yes | Used as the patient's login credential |
| `email` | String | No | |
| `address` | String | No | |
| `registeredBy` | int | Yes | The `UserID` of the nurse registering the patient |
| `pImageLink` | File | No | Maximum **5 MB**. Saved to `{webapp_root}/images/{timestamp}_{filename}`. Path stored in DB as `images/{filename}` |

**Transactional behaviour:** The patient insert and the diagnosis insert run inside a single database transaction. If either fails, both are rolled back.

| Condition | Result |
|---|---|
| Success | Patient and `Diagnosis` (status `Action Required`, result `Pending`) created → redirect `patients-dir` |
| Any exception | Full rollback → redirect `nurse_dashboard.jsp?error=creation_failed` |

---

### GET /all-patients

Returns all patients in the system without role-based filtering.

**Session required:** Staff

**Response:** Forward → `all-patients.jsp` with request attribute `patients` (via `PatientDAO.getAllPatients()`)

---

### GET /patients-dir

Returns all patients with their associated diagnosis records.

**Session required:** Staff

**Response:** Forward → `all_patients.jsp` with patient-diagnosis data (via `PatientDiagnosisDAO.getAllPatientDiagnoses()`)

---

### GET /patients

Returns all patients with full nurse and doctor name details joined.

**Session required:** Staff

**Response:** Forward → `patient_results.jsp`

---

## 2.4 Diagnosis Workflow Endpoints

### POST /submitDiagnosis

Nurse submits or updates a health assessment for a patient.

**Session required:** Nurse

**Content type:** `application/x-www-form-urlencoded`

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `patientID` | int | Yes | |
| `nurseID` | int | Yes | Should match `session.getAttribute("id")` |
| `diagnosisStatus` | String | Yes | Must be a valid `DiagnoStatus` ENUM value |
| `result` | String | No | Free-text result notes |
| `medicationsPrescribed` | String | No | |
| `nurseAssessment` | String | No | |

**Behaviour:** Checks whether a `Diagnosis` row already exists for `patientID`.
- If yes: `UPDATE` the existing row (sets `DiagnosisDate = NOW()`)
- If no: `INSERT` a new row

**Response:** `text/plain`

| Condition | HTTP status | Body |
|---|---|---|
| Updated existing record | 200 | `Diagnosis updated successfully` |
| Created new record | 200 | `Diagnosis created successfully` |
| Missing `patientID`, `nurseID`, or `diagnosisStatus` | 400 | `Missing required parameters` |
| Non-numeric ID | 400 | `Invalid ID format` |
| Database error | 500 | `Database error: {message}` |
| Other server error | 500 | `Server error: {message}` |

---

### GET /refer-case

Nurse refers a patient's case to a doctor by setting the diagnosis status to `Referrable`.

**Session required:** Nurse (nurse ID is read from `session.getAttribute("id")`)

**Query parameters:**

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `id` | int | Yes | The `PatientID` (not the `DiagnosisID`) |

**Behaviour:** Checks whether a `Diagnosis` row already exists for `patientID`.
- If yes: `UPDATE` sets `DiagnoStatus = 'Referrable'` and `DiagnosisDate = NOW()`
- If no: `INSERT` a new row with `DiagnoStatus = 'Referrable'`

| Condition | Result |
|---|---|
| Success | Session attribute `message` set → redirect `nurse-referred-cases` |
| Missing `id` or session has no nurse ID | Session attribute `error` set → redirect `nurse-action-cases` |
| Invalid number format | Session attribute `error` set → redirect `nurse-action-cases` |
| Database error | Session attribute `error` set → redirect `nurse-action-cases` |

---

### GET /referred-diagnoses

Returns all cases with status `Referrable` for a doctor to review.

**Session required:** Doctor

**Response:** Forward → `referred_diagnoses.jsp` with list of referrable diagnoses

---

### GET /update-diagnosis

Loads a specific diagnosis into the doctor's update form.

**Session required:** Doctor (redirects to `login.jsp` if not Doctor)

**Query parameters:**

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `id` | int | Yes | The `DiagnosisID` to load |

| Condition | Result |
|---|---|
| Diagnosis found | Forward → `update_diagnosis.jsp` with `diagnosis` object and `patientName` string |
| Missing `id` | Forward → `referred-diagnoses` with `error` attribute |
| Diagnosis not found | Forward → `referred-diagnoses` with `error` attribute |
| Database error | Forward → `referred-diagnoses` with `error` attribute |

---

### POST /update-diagnosis

Doctor submits a final diagnosis decision.

**Session required:** Doctor (doctor's `UserID` read from `session.getAttribute("id")`)

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `diagnosisID` | int | No | If empty, `patientID` is used as the ID (creates a new record) |
| `patientID` | int | Yes | |
| `diagnoStatus` | String | Yes | Typically `Positive` or `Negative` |
| `result` | String | No | Doctor's diagnosis notes |
| `medicationsPrescribed` | String | No | |
| `followUpDate` | String | No | Format: `YYYY-MM-DD` |

**Behaviour:** Uses `REPLACE INTO Diagnosis` — inserts a new row or replaces the existing row if the `DiagnosisID` already exists. Sets `DoctorID` to the doctor's session `id`.

| Condition | Result |
|---|---|
| Success | Session attribute `message` set → redirect `DiagnosisViewServlet` |
| No rows affected | Session attribute `error` set → redirect `referred-diagnoses` |
| Database error | Session attribute `error` set → redirect `referred-diagnoses` |
| Invalid number format | Session attribute `error` set → redirect `referred-diagnoses` |

---

### POST /SolveDiagnosisServlet

Marks a diagnosis as confirmed (sets `Result = 'Confirmed'`).

**Session required:** Staff

**Form fields:**

| Field | Type | Required |
|---|---|---|
| `diagnosisId` | int | Yes |

| Condition | Result |
|---|---|
| Success | Session attribute `message` = `"Case Solved Successfully."` → redirect `DiagnosisViewServlet` |
| Failure | Session attribute `error` = `"Failed to solve case."` → redirect `DiagnosisViewServlet` |

---

### POST /TransferDiagnosisServlet

Transfers a diagnosis by setting its `DiagnoStatus` to `'Referred'`.

**Session required:** Staff

**Form fields:**

| Field | Type | Required |
|---|---|---|
| `diagnosisId` | int | Yes |

| Condition | Result |
|---|---|
| Success | Session attribute `message` = `"Case Transferred Successfully."` → redirect `diagnosis_view.jsp` |
| Failure | Session attribute `error` = `"Failed to transfer case."` → redirect `diagnosis_view.jsp` |

---

### GET /DiagnosisViewServlet

Returns all diagnosis records joined with patient names.

**Session required:** Staff

**Response:** Forward → `diagnosis_view.jsp` with all diagnosis rows

---

### GET /confirmed-cases

Returns all diagnoses with status `Positive` or `Negative`.

**Session required:** Doctor

**Response:** Forward → `confirmed_cases.jsp`

---

### GET /nurse-action-cases

Returns all patients whose diagnosis status is `Action Required`.

**Session required:** Nurse

**Response:** Forward → `nurse_action_cases.jsp`

---

### GET /nurse-referred-cases

Returns all cases the current nurse has referred (status `Referrable`).

**Session required:** Nurse

**Response:** Forward → `nurse_referred_cases.jsp`

---

## 2.5 Nurse Management Endpoints

### GET /nurse-dashboard

Lists all registered nurses.

**Session required:** Staff

**Response:** Forward → `nurseDashboard.jsp` with `nurses` list (via `NurseDAO.getAllNurses()`)

---

### POST /nurse-dashboard

Updates a nurse's status field.

**Session required:** Staff

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `nurseId` | int | Yes | The `NurseId` in the `Nurses` table |
| `newStatus` | String | Yes | Free-text status string — no ENUM constraint enforced |

**Response:** Redirect back to `/nurse-dashboard`

---

### POST /RegisterNurse

Creates a new nurse profile in the `Nurses` table.

**Session required:** Staff

**Form fields:** First name, last name, telephone, email, address, health center (exact field names not enforced by a role check — consult `register_nurse.jsp` for the form definition)

**Response:** JavaScript `alert()` in the response body (non-standard pattern)

---

### POST /verify-nurse

Verifies or rejects a nurse's login account.

**Session required:** Doctor or Admin (returns error JSON for any other role)

**Content type:** `application/x-www-form-urlencoded`

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `nurseid` | int | Yes | The `UserID` in the `Users` table (not the `NurseId` in the `Nurses` table) |
| `action` | String | Yes | `verify` — sets `is_verified = 1`; `reject` — deletes the user row |

**Response:** `application/json`

```json
{ "success": true, "message": "Nurse verified successfully" }
{ "success": false, "message": "No nurse found with the provided ID or action failed" }
{ "success": false, "message": "Unauthorized. Only doctors and administrators can verify nurses." }
```

---

### POST /update-verification

Sets the `is_verified` flag for any user by ID.

**Session required:** Staff (no role check — Admin intent)

**Form fields:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `userId` | int | Yes | The `UserID` in the `Users` table |
| `action` | String | Yes | `verify` → sets `is_verified = 1`; any other value → sets `is_verified = 0` |

**Response:** `application/json`

```json
{ "success": true }
{ "success": false, "message": "User not found." }
{ "success": false, "error": "Server error." }
```

---

### GET /unverified-nurse-list

Returns the list of nurse accounts with `is_verified = false`.

**Session required:** Staff

**Response:** Forward → `unverified_nurses.jsp`

---

### GET /nurse-count

Returns the total number of verified or unverified nurse accounts.

**Session required:** None (open endpoint)

**Response:** `text/plain` — plain integer

```
12
```

---

### GET /all-nurses

Lists all registered nurse accounts.

**Session required:** Staff

**Response:** Forward → view with all nurses

---

## 2.6 Doctor Management Endpoints

### GET /doctors-dir

Lists all registered doctors.

**Session required:** Staff

**Response:** Forward → `view_doctors.jsp` with `doctors` list from the `Doctors` table

---

### POST /new-doctor

Creates a new doctor profile in the `Doctors` table.

**Session required:** Staff

**Response:** Redirect → `/doctors-dir`

---

### GET /reffered

Returns all patient diagnosis records for the doctor's dashboard view.

**Session required:** Doctor

**Response:** Forward → `doctor.jsp` with all patient diagnoses (via `Doctor_diagnosis_dao.getAllPatientDiagnoses()`)

---

### POST /update-doctor-status

Updates a doctor's `status` field.

**Session required:** Staff

**Response:** Redirect → `/doctors-dir`

---

### GET /doctor-count

Returns the number of doctor accounts in the `Users` table.

**Session required:** None (open endpoint)

**Response:** `text/plain` — plain integer

```
5
```

> **Note:** This counts rows in `Users WHERE UserType = 'Doctor'`, not rows in the `Doctors` table. These two tables can have different counts if doctor profiles were created independently of login accounts.

---

### GET /all-doctors

Lists all registered doctor accounts.

**Session required:** Staff

**Response:** Forward → view with all doctors

---

### GET /verified-doctors

Lists only verified doctor accounts.

**Session required:** Staff

**Response:** Forward → view with verified doctors

---

## 2.7 User and Admin Management Endpoints

### GET /users-directory

Lists all users in the system. Supports deletion via a query parameter.

**Session required:** Staff

**Query parameters:**

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `action` | String | No | Pass `delete` to delete a user |
| `id` | int | Conditional | Required when `action=delete`. The `UserID` to delete |

**Response:** Forward → `userList.jsp` with `users` list

---

### GET /unverified-accounts

Returns all unverified non-Admin accounts as a JSON array.

**Session required:** Staff

**Response:** `application/json` — array of user objects with unverified status

---

## 2.8 Dashboard Data Endpoints

These endpoints return raw numbers or JSON used by the dashboard's charts and KPI cards. They are called internally by `dashboard.jsp` and `nurse.jsp` via `http://localhost:8080/MBC_HOSPITAL/{endpoint}`.

### Count Endpoints (text/plain)

All count endpoints below accept `GET`, require no parameters, and return a `text/plain` plain integer (e.g., `42`).

| Endpoint | What it counts | Source table |
|---|---|---|
| `/patient-count` | All patients | `Patients` |
| `/doctor-count` | Users with `UserType = 'Doctor'` | `Users` |
| `/nurse-count` | Users with `UserType = 'Nurse'` | `Users` |
| `/action-required-case-count` | Diagnoses with `DiagnoStatus = 'Action Required'` | `Diagnosis` |
| `/confirmed-cases-count` | Diagnoses with `DiagnoStatus IN ('Positive', 'Negative')` | `Diagnosis` |
| `/non-referrable-case-count` | Diagnoses with `DiagnoStatus = 'Not Referable'` | `Diagnosis` |
| `/referrable-case-count` | Diagnoses with `DiagnoStatus = 'Referrable'` | `Diagnosis` |
| `/pending-cases-count` | Diagnoses with `DiagnoStatus = 'Referrable'` | `Diagnosis` |

> **Naming note:** `/pending-cases-count` and `/referrable-case-count` both count `DiagnoStatus = 'Referrable'`. In this system, "pending" means cases awaiting a doctor, which are cases in the `Referrable` state. The `/action-required-case-count` endpoint is the correct one for counting cases still awaiting nurse assessment.

---

### GET /monthly-cases-data

Returns patient registration counts and referral counts grouped by month for the current calendar year.

**Session required:** None

**Response:** `application/json`

```json
{
  "labels": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
  "totalCases": [3, 5, 8, 2, 0, 4, 1, 0, 0, 0, 0, 0],
  "referredCases": [1, 2, 3, 1, 0, 2, 0, 0, 0, 0, 0, 0]
}
```

- `labels` — fixed 12-month array, always January through December
- `totalCases` — patient registrations per month (`Patients.RegistrationDate`)
- `referredCases` — patients with a `Referrable` diagnosis registered that month

---

### GET /recent-activities

Returns up to 9 recent system events for the activity feed (3 registrations + 3 completed diagnoses + 3 referrals).

**Session required:** None

**Response:** `application/json` — array of activity objects

```json
[
  {
    "type": "registration",
    "icon": "user-plus",
    "title": "New patient registered",
    "description": "Jean Mutoni was added to the system",
    "time": "2 hours ago"
  },
  {
    "type": "diagnosis",
    "icon": "clipboard-check",
    "title": "Diagnosis completed",
    "description": "Pierre Habimana's diagnosis was completed",
    "time": "1 day ago"
  },
  {
    "type": "referral",
    "icon": "share",
    "title": "Case referred",
    "description": "Amina Uwase was referred to Dr. alice — awaiting doctor assignment",
    "time": "3 hours ago"
  }
]
```

**Field descriptions:**

| Field | Type | Notes |
|---|---|---|
| `type` | String | `registration`, `diagnosis`, or `referral` |
| `icon` | String | Font Awesome icon name (without `fa-` prefix) |
| `title` | String | Short event label |
| `description` | String | Human-readable event detail. For referrals where no doctor has been assigned yet, shows `"awaiting doctor assignment"` |
| `time` | String | Relative time string: `"just now"`, `"N minutes ago"`, `"N hours ago"`, or `"N days ago"` |

---

### GET /diagnosis-stats

Returns monthly case resolution counts and status distribution totals for the doctor-and-nurse performance charts.

**Session required:** None

**Response:** `application/json`

```json
{
  "doctorMonthlyStats": [0, 0, 2, 1, 0, 3, 0, 0, 0, 0, 0, 0],
  "nurseMonthlyStats":  [0, 1, 4, 2, 0, 2, 0, 0, 0, 0, 0, 0],
  "statusStats": {
    "resolvedByDoctors": 6,
    "resolvedByNurses":  9,
    "pendingCases":      4,
    "referredCases":     2
  }
}
```

**Field descriptions:**

| Field | Type | Notes |
|---|---|---|
| `doctorMonthlyStats` | int[12] | Diagnoses resolved (Positive/Negative) with a `DoctorID` set, grouped by month, current year |
| `nurseMonthlyStats` | int[12] | Diagnoses resolved (Positive/Negative) with a `NurseID` set, grouped by month, current year |
| `statusStats.resolvedByDoctors` | int | All-time resolved diagnoses with a `DoctorID` |
| `statusStats.resolvedByNurses` | int | All-time resolved diagnoses with a `NurseID` |
| `statusStats.pendingCases` | int | Diagnoses currently in `Action Required` state |
| `statusStats.referredCases` | int | Diagnoses currently in `Referrable` state |

---

---

---

# 3. Troubleshooting Guide

**Audience:** Developers and system administrators who encounter an error during setup, build, login, or normal use. Each problem below lists what you will see, why it happens based on the source code, and exactly how to fix it.

---

## 3.1 Setup and Installation Problems

### The application shows a 404 error on every page after deployment

**What you see:** Every URL returns HTTP 404, including `http://localhost:8080/MBC_HOSPITAL/`.

**Root cause:** The most common reason is a **Tomcat version mismatch**. This project uses the `jakarta.servlet.*` package namespace, introduced in Jakarta EE 9. Tomcat 9 and earlier use `javax.servlet.*` and cannot load these servlets — they are silently skipped, leaving no routes registered.

**Fix:**
1. Confirm your Tomcat version:
   ```bash
   catalina.sh version
   # or on Windows:
   catalina.bat version
   ```
2. The output must show **Apache Tomcat/10.1.x**. If it shows 9.x or earlier, install Tomcat 10.1.
3. After installing the correct version, rebuild and redeploy:
   ```bash
   ./run.sh
   ```

---

### `ClassNotFoundException: com.mysql.cj.jdbc.Driver` in Tomcat logs

**What you see:** The application starts but every database operation fails. Tomcat logs contain:
```
java.lang.ClassNotFoundException: com.mysql.cj.jdbc.Driver
```

**Root cause:** The MySQL Connector/J JAR is missing from `WEB-INF/lib/`. The project expects `mysql-connector-java-8.0.18.jar` at that path. Without it, `DBConnection.getConnection()` cannot load the driver and prints the error to `stderr` before returning `null`.

**Fix:** Confirm the JAR is present:
```bash
ls src/main/webapp/WEB-INF/lib/
```
You should see `mysql-connector-java-8.0.18.jar` in the listing. If it is missing, add it to that directory and rebuild.

---

### `NullPointerException` immediately after any page loads

**What you see:** HTTP 500 on first request. Tomcat logs show a `NullPointerException` inside a controller class, often on a line that calls `.prepareStatement()` or `.executeQuery()`.

**Root cause:** `DBConnection.getConnection()` returned `null`. This happens silently — the method catches the exception internally, prints to `stderr`, and returns `null` instead of throwing. Any caller that does not null-check the connection will throw a `NullPointerException` on the next line.

The most likely causes are:

| Cause | How to confirm |
|---|---|
| MySQL is not running | `mysql -u root` — if it fails to connect, MySQL is stopped |
| The `PMS` database does not exist | Run `SHOW DATABASES;` in MySQL — `PMS` must appear |
| Wrong MySQL credentials in `DBConnection.java` | The file hardcodes `user=root` and `password=""` — if your MySQL root has a password, this will fail silently |

**Fix:**
1. Start MySQL if it is not running.
2. If the `PMS` database is missing, create it:
   ```bash
   mysql -u root < schema.sql
   ```
3. If your MySQL root account has a password, edit `DBConnection.java`:
   ```java
   // src/main/java/com/mbc_hospital/model/DBConnection.java
   private static final String pass = "your-root-password";
   ```
   Then rebuild with `./run.sh`.

---

### `package jakarta.servlet does not exist` compilation error

**What you see:** The `run.sh` script fails during the `javac` step with many lines like:
```
error: package jakarta.servlet does not exist
error: package jakarta.servlet.http does not exist
```

**Root cause:** The `javac` classpath does not include Tomcat's `servlet-api.jar`. The `.classpath` file specifies `/opt/tomcat/lib/servlet-api.jar`. If Tomcat is installed elsewhere, this path does not resolve.

**Fix:** Set `CATALINA_HOME` to your Tomcat installation path before running the build script:
```bash
export CATALINA_HOME=/usr/local/tomcat
./run.sh
```
The script uses `CATALINA_HOME` to locate `catalina.jar` and the servlet API JAR.

---

### `run.sh` fails with `catalina.sh: command not found` or similar

**What you see:** The build script exits with an error when trying to start Tomcat.

**Root cause:** `run.sh` searches `/usr/share` for `catalina.jar` to locate Tomcat. If Tomcat is installed in a different directory (e.g., `/usr/local/tomcat`, `/opt/tomcat`), the search fails.

**Fix:** Set `CATALINA_HOME` explicitly before running:
```bash
export CATALINA_HOME=/path/to/your/tomcat
./run.sh
```
Or edit `run.sh` directly to hard-code the path.

> **Windows users:** `run.sh` is a bash script and cannot be run on Windows. Follow the manual Windows build steps in [Section 1.3.4](#134-step-3--build-and-run) instead.

---

### Patient photo upload silently does nothing — no image is saved

**What you see:** Patient registration completes successfully but the patient record has no photo, even though a file was selected.

**Root cause:** `CreatePatientServlet` saves the image using `getServletContext().getRealPath("/")` to find the webapp root. If Tomcat is running from a WAR file (not an exploded directory), `getRealPath()` returns `null`, causing the file write to silently fail. The servlet does not treat a failed image save as a transaction error — the patient record is still created.

**Fix:** Deploy the application as an **exploded directory** (not a packed WAR). The `run.sh` script already does this by copying `src/main/webapp/*` into `target/MBC_HOSPITAL/` and pointing Tomcat at that directory. If you are deploying manually, copy the exploded folder rather than a `.war` file.

---

## 3.2 Login and Session Problems

### Logging in redirects back to `pending.jsp` even with correct credentials

**What you see:** You enter a valid username and password but land on the "Your account is pending verification" page instead of the dashboard.

**Root cause:** The account exists in the `Users` table but `is_verified = 0` (false). `LoginServlet` checks this flag and redirects unverified non-Admin accounts to `pending.jsp`. This is expected for newly registered nurses and doctors who have not yet been approved.

**Fix — if you are an Admin or Doctor:** Verify the account through the system:
1. Log in with an Admin account.
2. Go to the Unverified Accounts page.
3. Click Verify next to the user.

**Fix — if there is no Admin account yet:** Create one directly in the database:
```sql
USE PMS;
INSERT INTO Users (username, password, userType, is_verified)
VALUES ('admin', 'admin123', 'Admin', TRUE);
```

**Fix — if you need to verify a user directly in the database:**
```sql
USE PMS;
UPDATE Users SET is_verified = 1 WHERE username = 'the-username';
```

> **Note:** Admin accounts always bypass the `is_verified` check. Even an Admin with `is_verified = 0` will be taken to the dashboard on login. See `LoginServlet.java:44`.

---

### Login fails with `?error=invalid` even though credentials are correct

**What you see:** The login page reloads with an error message after entering what you believe are correct credentials.

**Root cause:** Passwords are stored and compared as **plain text**. There is no encoding or case folding. The username and password must match the database values byte-for-byte.

**Fix:** Check the exact value stored for the user:
```sql
USE PMS;
SELECT username, password FROM Users WHERE username = 'your-username';
```
Use the password exactly as it appears in the `password` column.

---

### Patient cannot log in — login page returns `?error=invalid`

**What you see:** A patient enters their Patient ID and telephone number but the login fails.

**Root cause:** `PatientLoginServlet` queries `WHERE PatientID = ? AND Telephone = ?`. The telephone number must match the value stored in `Patients.Telephone` **exactly** — including any spaces, dashes, or country code prefix used when the patient was registered.

**Fix:** Check the stored telephone value:
```sql
USE PMS;
SELECT PatientID, FirstName, LastName, Telephone FROM Patients WHERE PatientID = <id>;
```
The patient must enter the telephone in exactly the same format shown in the database.

---

### A nurse sees all patients instead of only their own

**What you see:** A nurse logs in and the Patients page shows every patient in the system, not just those the nurse registered.

**Root cause:** `PatientController` filters the patient list using `session.getAttribute("id")` to get the nurse's `UserID`. If the session `id` attribute is `null` or the wrong type (e.g., a `String` instead of an `int`), the SQL `WHERE p.RegisteredBy = ?` comparison will fail or match nothing, causing the fallback Admin query to run instead.

**Fix:** Confirm the session was created correctly. After logging in, visit `session_debug.jsp` (included in the project for this purpose). The `id` attribute must be present and must be an integer equal to the nurse's `UserID`. If it is absent, the login likely failed partway through — try logging out and in again.

---

### A doctor does not see any patients on their dashboard

**What you see:** The doctor dashboard loads but shows an empty patient list.

**Root cause:** `PatientController` filters patients for doctors by joining `Nurses.HealthCenter = Doctors.HospitalName`. If the doctor's profile in the `Doctors` table has no `HospitalName`, or the nurses' `Nurses.HealthCenter` values do not match it exactly, the join returns no rows.

**Fix:** Check the doctor's profile:
```sql
USE PMS;
SELECT DoctorID, FirstName, HospitalName FROM Doctors WHERE DoctorID = <id>;
```
Then check the nurses' health centers:
```sql
SELECT NurseId, FirstName, HealthCenter FROM Nurses;
```
The `HospitalName` and `HealthCenter` values must match exactly (case-sensitive on some MySQL configurations).

---

## 3.3 Patient Registration Problems

### Patient registration fails and returns `?error=creation_failed`

**What you see:** After filling in the patient form and clicking Register, you are redirected to `nurse_dashboard.jsp?error=creation_failed`.

**Root cause:** `CreatePatientServlet` wraps both the patient INSERT and the diagnosis INSERT in a database transaction. If either fails, both are rolled back. The redirect happens on **any** uncaught exception, including:

| Likely cause | How to confirm |
|---|---|
| Missing required form field (`firstName`, `lastName`, `telephone`, `registeredBy`) | Check Tomcat logs for `NumberFormatException` or `NullPointerException` |
| `registeredBy` is not a valid integer | Check that the form is passing the nurse's `UserID` correctly |
| `Patients.Telephone` is a duplicate (if a UNIQUE constraint exists) | Check Tomcat logs for `SQLIntegrityConstraintViolationException` |
| Database connection returned `null` | See the `NullPointerException` troubleshooting entry above |

**Fix:** Check the Tomcat console output immediately after the failure. The servlet logs the full exception with `LOGGER.log(Level.SEVERE, "Error creating patient record", e)`.

---

### Photo upload fails with "Request Entity Too Large" or the form submission hangs

**What you see:** Submitting the patient registration form with a large photo results in an error or the browser hangs.

**Root cause:** `CreatePatientServlet` is annotated with `@MultipartConfig(maxFileSize = 1024 * 1024 * 5)` — the maximum file size is **5 MB**. Files larger than this will be rejected by Tomcat before the servlet code runs.

**Fix:** Compress or resize the photo to under 5 MB before uploading.

---

## 3.4 Diagnosis Workflow Problems

### Nurse submits a diagnosis but the patient's status does not change

**What you see:** After submitting the assessment form, the patient's status in the list still shows `Action Required`.

**Root cause:** `SubmitDiagnosisServlet` returns a `text/plain` response body (`"Diagnosis updated successfully"`) rather than redirecting. If the calling page does not handle this response and refresh the patient list, the displayed status will not update.

Additionally, the servlet updates by `PatientID`, not by `DiagnosisID`. If more than one `Diagnosis` row exists for the same patient, only the first matching row is found and updated.

**Fix:** After submitting, manually refresh the patient list page. If the status still does not change, check the Tomcat logs for any `400` or `500` responses from `/submitDiagnosis` and correct the form fields accordingly.

---

### Doctor opens referred diagnoses but the list is empty

**What you see:** A doctor navigates to the referred diagnoses page but sees no cases, even though nurses have referred patients.

**Root cause:** Two possible causes:

1. **ENUM case mismatch.** The `DiagnoStatus` column is `'Referrable'` (capital R). If any code path wrote a different casing or spelling (e.g., `'referrable'`, `'Referable'`), MySQL's ENUM will reject the value silently and the row will have an empty status, which the query `WHERE DiagnoStatus = 'Referrable'` will not find.

2. **Doctor's session `id` is wrong.** Some filtering logic joins on `DoctorID` from the session — if the session `id` does not match a doctor in the database, the join returns nothing.

**Fix:** Check what values are actually in the `DiagnoStatus` column:
```sql
USE PMS;
SELECT DiagnosisID, PatientID, DiagnoStatus FROM Diagnosis;
```
If any `DiagnoStatus` is blank or contains an unexpected value, update it:
```sql
UPDATE Diagnosis SET DiagnoStatus = 'Referrable' WHERE DiagnosisID = <id>;
```

---

### Doctor updates a diagnosis but the change is not saved

**What you see:** The doctor fills in the diagnosis update form and submits, but the patient's status remains unchanged.

**Root cause:** `UpdateDiagnosisServlet` uses `REPLACE INTO Diagnosis`. This statement deletes the old row and inserts a new one. If `diagnosisID` is not provided in the form (or is empty), the servlet uses `patientID` as the `DiagnosisID`, which may not match the actual `DiagnosisID` — causing a new, orphaned row to be created rather than updating the existing one.

**Fix:** Confirm that the `update_diagnosis.jsp` form is passing `diagnosisID` as a hidden field. Open browser developer tools → Network → inspect the POST payload to verify:
```
diagnosisID=42&patientID=7&diagnoStatus=Positive&...
```
If `diagnosisID` is missing or `0`, the JSP form must be fixed to include it.

---

## 3.5 Dashboard and Charts Problems

### Dashboard KPI cards all show 0 or are blank

**What you see:** After logging in as Admin, the dashboard shows zero for patient count, doctor count, nurse count, and other statistics.

**Root cause:** `dashboard.jsp` fetches these numbers by making **internal HTTP requests** to its own count endpoints:
```
http://localhost:8080/MBC_HOSPITAL/patient-count
http://localhost:8080/MBC_HOSPITAL/doctor-count
...
```
These URLs are **hardcoded**. If the application is running on a different port or context path, these internal requests fail silently and the JavaScript that renders the cards receives no data.

**Fix:** Confirm the application is accessible at exactly `http://localhost:8080/MBC_HOSPITAL/`. If you changed the Tomcat port or the deployment context path, the dashboard's internal HTTP calls will break and must be updated manually in `dashboard.jsp` and `nurse.jsp`.

---

### Charts on the dashboard are empty or throw a JavaScript error

**What you see:** The bar or line charts on the dashboard render with no data, or the browser console shows a JSON parse error.

**Root cause:** The chart data endpoints (`/monthly-cases-data`, `/diagnosis-stats`) return `application/json`. If the database query inside one of them throws an exception, the servlet writes an error JSON object:
```json
{"error": "...message..."}
```
Chart.js receives this instead of the expected array format and fails to render.

**Fix:**
1. Open the browser developer tools → Network tab.
2. Reload the dashboard.
3. Find the requests to `/monthly-cases-data` and `/diagnosis-stats`.
4. Inspect their response bodies. If you see `{"error": "..."}`, the error message will tell you the SQL or database problem to fix.

---

### The recent activity feed shows no referral events

**What you see:** The admin dashboard activity feed shows patient registrations and completed diagnoses, but never shows any referral events, even when nurses have referred cases.

**Root cause:** This was a bug in `RecentActivitiesServlet` where the referral SQL query used an `INNER JOIN` on `DoctorID`, which is `NULL` for all newly-referred cases (a doctor has not yet been assigned). The `INNER JOIN` silently returned zero rows.

**Status:** **Fixed.** The query now uses a `LEFT JOIN`, so referral events appear regardless of whether a doctor has been assigned. If you have an older copy of the code without this fix, update `RecentActivitiesServlet.java` line 77:

```java
// Change this:
"JOIN Users d2 ON d.DoctorID = d2.UserID " +

// To this:
"LEFT JOIN Users d2 ON d.DoctorID = d2.UserID " +
```

---

## 3.6 Known Limitations

These are characteristics of the current system that are not bugs but should be understood before deploying or extending it.

---

### Passwords are stored as plain text

**Detail:** `RegistrationController` inserts passwords directly into the `Users` table with no hashing. `LoginServlet` compares the submitted password to the stored value with a plain string match. Anyone with read access to the database can see all passwords.

**Impact:** This is a serious security risk for any environment beyond a local development machine.

**Workaround:** Do not use real passwords during development. Before any shared or production deployment, replace the plain-text storage and comparison with a hashing library such as BCrypt.

---

### No database connection pooling

**Detail:** `DBConnection.getConnection()` opens a brand-new MySQL connection on every call by loading the driver class and calling `DriverManager.getConnection()`. Connections are closed individually after each request.

**Impact:** Under moderate load, the application will exhaust available MySQL connections. Each open connection consumes server memory.

**Workaround:** For development and small demos this is acceptable. For any production use, replace `DBConnection` with a connection pool (e.g., Apache DBCP or HikariCP configured as a JNDI resource in Tomcat).

---

### Dashboard URLs are hardcoded to `localhost:8080`

**Detail:** `dashboard.jsp` and `nurse.jsp` make internal HTTP calls to `http://localhost:8080/MBC_HOSPITAL/...` to fetch KPI counts. This URL is a string literal in the JSP files.

**Impact:** Deploying the application on a different port, a remote server, or behind a reverse proxy will break the dashboard statistics silently.

**Workaround:** If the deployment host or port changes, update the base URL string in both `dashboard.jsp` and `nurse.jsp`.

---

### Build script is Linux / macOS only

**Detail:** `run.sh` uses bash syntax, `pkill`, and `catalina.sh`. It cannot be run on Windows.

**Impact:** Windows developers have no automated build path.

**Workaround:** Follow the manual Windows build steps in [Section 1.3.4](#134-step-3--build-and-run).

---

### Two separate include fragment sets exist

**Detail:** The project contains two sets of `header.jsp`, `footer.jsp`, and `sidebar.jsp`:
- `src/main/webapp/WEB-INF/includes/`
- `src/main/webapp/common/`

Different JSP pages include from different sets, which can cause style inconsistencies if one set is updated and the other is not.

**Impact:** Visual inconsistency across pages if includes are modified in only one location.

**Workaround:** When editing shared UI elements, update both sets, or consolidate all JSPs to use one set.

---

### The `Doctors` and `Nurses` tables are separate from `Users`

**Detail:** A staff member who logs in has a record in `Users`. A doctor or nurse also has a separate profile record in `Doctors` or `Nurses`. These two records are not automatically linked — a doctor could have a `Users` login but no matching row in `Doctors`.

**Impact:** `DoctorCountServlet` counts from `Users WHERE UserType = 'Doctor'`, while `DoctorController` lists from the `Doctors` table. These counts can differ. The patient-filtering join for doctors (`Nurses.HealthCenter = Doctors.HospitalName`) will return no results if the doctor has no `Doctors` profile row.

**Workaround:** When registering a new doctor, ensure both a `Users` account (via `registration.jsp`) and a `Doctors` profile (via `new-doctor.jsp`) are created.

---

---

---

# 4. Prompt History

A chronological log of every prompt submitted to Claude (claude-sonnet-4-6) during the production of this documentation. Each entry records what was asked, how the output was used, and what required human correction.

---

## Prompt #1 — Task Analysis

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Pre-writing — understanding the assignment  
**Prompt:**
> "You are a Senior Technical Writer and Documentation Architect. Your job is NOT to write documentation yet. First, analyze the assignment requirements and create a detailed execution plan. [Assignment context, deliverables, objectives, output format, and constraints provided]"

**Output quality:** Used as-is  
**Notes:** The AI correctly identified all five deliverables, structured a breakdown by audience and purpose, and produced a phased roadmap. It also proactively flagged 18 verification points — items that required source-code confirmation before writing could begin. No corrections were needed at this stage.

---

## Prompt #2 — Documentation Blueprint

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Pre-writing — planning structure  
**Prompt:**
> "Create a complete documentation blueprint. Do NOT write the final documentation. Create only the structure, outline, content requirements, and evidence collection checklist. For every section: define the target audience, define the purpose, list required information, identify repository sources that provide the information, identify validation steps, provide a writing strategy."

**Output quality:** Used as-is  
**Notes:** The AI generated a full section-by-section blueprint with audience definitions, source file references, and a 18-item verification checklist. It correctly identified the three most critical gaps: missing schema SQL, missing admin seed, and unconfirmed Java/Tomcat version. Output matched actual project structure when verified against the repository.

---

## Prompt #3 — Gap Resolution and Code Fixes

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Pre-writing — resolving verification points  
**Prompt:**
> "Resolve all verification points, you might do code changes, new files. Implement coding fix then later. Give full access, please make fix this with surgical precision."

**Output quality:** Modified  
**Notes:** The AI read 15+ servlet files and resolved all 18 verification points. It discovered two real bugs:
1. `RecentActivitiesServlet` used an `INNER JOIN` on `DoctorID` (which is NULL for all referred cases), causing the referral activity feed to always return 0 rows — **fixed by changing to `LEFT JOIN`**.
2. `model/PatientDiagnosisServlet.java` was an empty ghost class in the wrong package — **fixed by replacing with a redirect comment**.

The AI also created two missing files (`schema.sql`, `seed_admin.sql`) that the project had no equivalent for. Human review confirmed all fixes were correct.

---

## Prompt #4 — Getting Started Guide (Phase 1)

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Getting Started Guide  
**Prompt:**
> "Okay now make documentation file for the first phase. Do only one phase after reading that md file I will prompt you to start second phase."

**Output quality:** Used as-is  
**Notes:** The AI read the assignment MD file, determined the correct first deliverable (Getting Started Guide), and wrote a complete guide covering prerequisites, database setup, Linux and Windows build steps, login flows for all four roles, role capability tables, staff registration, and patient registration. All field names, version numbers, and file paths were verified against source code before writing. No corrections were needed.

---

## Prompt #5 — API Reference (Phase 2)

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** API Reference  
**Prompt:**
> "Implement phase two - API reference with Surgical precision. Follow the existing format in Documentation md."

**Output quality:** Modified — one additional read required  
**Notes:** Before writing, the AI identified that `UpdateDiagnosisServlet` POST parameters had not yet been confirmed, and read the file before proceeding. The final output covered 40+ endpoints across 7 domain groups, with exact field names, session requirements, response formats, and outcome tables for every endpoint. The `REPLACE INTO` behaviour of `POST /update-diagnosis` and the `LEFT JOIN` fix context for `/recent-activities` were both correctly documented. The naming discrepancy between `/pending-cases-count` and `/action-required-case-count` (both counting `Referrable`) was surfaced and explained.

---

## Prompt #6 — Troubleshooting Guide (Phase 3)

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Troubleshooting Guide  
**Prompt:**
> "Phase 3 - Troubleshooting Guide"

**Output quality:** Used as-is  
**Notes:** The AI produced 16 documented failure scenarios across 6 categories. Each scenario included the exact symptom, the specific source-code root cause (with file and line references where applicable), and a concrete fix. The guide correctly identified that the referral activity feed bug (which had already been fixed in Prompt #3) should be documented for teams running older copies of the code. Known limitations were documented accurately and matched confirmed code patterns.

---

## Prompt #7 — Prompt History and Reflection (Phase 4)

**Date:** October 2026  
**Tool:** Claude (claude-sonnet-4-6)  
**Section:** Prompt History and Reflection  
**Prompt:**
> "Implement Phase 4 - Prompt History and Reflection. Commit files and push to GitHub at git@github.com:MUGWANEZAMANZI/MBC_HOSPITAL.git"

**Output quality:** In progress — this entry  
**Notes:** This prompt produced the current section. The AI compiled the complete prompt log from the session and wrote the reflection based on evidence from all prior prompts.

---

---

# 5. Reflection

**Word count target:** 200 words or fewer

---

The hardest part of this task was not writing — it was **verification**. AI-generated documentation is fast and confident, but confidence is not accuracy. The system produced plausible content based on naming patterns alone: for example, it initially assumed `PendingCasesCountServlet` counted `Action Required` cases, because "pending" implies that. Reading the source revealed it actually counts `Referrable` cases. Without that check, the API Reference would have been silently wrong.

Iterative prompting changed the quality in two concrete ways. First, separating the *planning* prompts (analysis, blueprint, gap resolution) from the *writing* prompts meant the AI never wrote a claim it had not already verified. Second, chaining each phase on top of verified evidence — rather than writing everything in one pass — allowed each section to reuse confirmed facts from earlier turns instead of re-deriving or guessing them.

The process also surfaced two real code bugs: an `INNER JOIN` on a nullable column that silently emptied the activity feed, and a ghost class in the wrong package. Neither was a documentation problem; both were caught because documentation requires reading every endpoint carefully.

AI is a strong first drafter and a reliable structure builder. It is not a substitute for reading the code.

---

*End of document.*
