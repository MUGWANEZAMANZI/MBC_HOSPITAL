<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient, com.mbc_hospital.model.Diagnosis" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Validate user session
    String usertype = (String) session.getAttribute("usertype");
    if (usertype == null || !"nurse".equalsIgnoreCase(usertype)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get diagnosis details from request attribute
    Diagnosis diagnosis = (Diagnosis) request.getAttribute("diagnosis");
    Map<String, Object> patientInfo = (Map<String, Object>) request.getAttribute("patientInfo");
    
    // Default values if attributes are not set
    String patientName = "Not available";
    String diagnosisDate = "Not available";
    String followUpDate = "No follow-up scheduled";
    String status = "Awaiting Diagnosis";
    String nurseAssessment = "No assessment provided.";
    String medications = "No medications prescribed.";
    String result = "";
    
    if (diagnosis != null) {
        status = diagnosis.getStatus();
        nurseAssessment = diagnosis.getNurseAssessment() != null ? diagnosis.getNurseAssessment() : nurseAssessment;
        medications = diagnosis.getMedicationsPrescribed() != null ? diagnosis.getMedicationsPrescribed() : medications;
        result = diagnosis.getResult() != null ? diagnosis.getResult() : "";
        
        if (diagnosis.getDiagnosisDate() != null) {
            diagnosisDate = diagnosis.getDiagnosisDate().toString();
        }
        
        if (diagnosis.getFollowUpDate() != null) {
            followUpDate = diagnosis.getFollowUpDate().toString();
        }
    }
    
    if (patientInfo != null) {
        patientName = patientInfo.get("patientName") != null ? (String) patientInfo.get("patientName") : patientName;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnosis Details - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        :root {
            --primary-color: #1e48b7;
            --primary-light: #2854c3;
            --primary-dark: #1a3c93;
            --text-light: #ffffff;
            --bg-light: #f5f7fb;
        }
        body {
            font-family: Arial, sans-serif;
            background-color: var(--bg-light);
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: var(--primary-color);
            color: var(--text-light);
            padding: 0.75rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .breadcrumb {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            color: #6b7280;
        }
        .breadcrumb a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .breadcrumb .separator {
            margin: 0 0.5rem;
        }
        .card {
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .label {
            color: #6b7280;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }
        .value {
            font-weight: 500;
            margin-bottom: 1rem;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .button {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
        }
        .button-primary {
            background-color: var(--primary-color);
            color: white;
        }
        .button-secondary {
            background-color: #e5e7eb;
            color: #374151;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .print-break {
                page-break-before: always;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header no-print">
        <div class="flex items-center">
            <span class="text-2xl font-bold">MBC Hospital</span>
        </div>
        <div class="flex items-center space-x-4">
            <a href="nurse.jsp" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                <i class="fas fa-home mr-2"></i>Home
            </a>
            <div class="flex items-center">
                <i class="fas fa-user-circle text-xl mr-2"></i>
                <span>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></span>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto p-6">
        <!-- Breadcrumb -->
        <div class="breadcrumb no-print">
            <a href="nurse.jsp">Dashboard</a>
            <span class="separator">/</span>
            <a href="nurse-referred-cases">Referred Cases</a>
            <span class="separator">/</span>
            <span>Details</span>
        </div>

        <div class="mb-6">
            <div class="flex items-center justify-between">
                <h1 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-file-medical-alt mr-3 text-blue-600"></i>
                    Diagnosis #<%= diagnosis != null ? diagnosis.getDiagnosisId() : "N/A" %>
                </h1>
                <div>
                    <% if ("Referrable".equals(status) || "Awaiting Diagnosis".equals(status)) { %>
                        <span class="status-badge bg-yellow-100 text-yellow-800">
                            <i class="fas fa-clock mr-1"></i> Awaiting Doctor
                        </span>
                    <% } else if ("In Progress".equals(status)) { %>
                        <span class="status-badge bg-blue-100 text-blue-800">
                            <i class="fas fa-spinner mr-1"></i> In Progress
                        </span>
                    <% } else if ("Positive".equals(result)) { %>
                        <span class="status-badge bg-red-100 text-red-800">
                            <i class="fas fa-exclamation-circle mr-1"></i> Positive
                        </span>
                    <% } else if ("Negative".equals(result)) { %>
                        <span class="status-badge bg-green-100 text-green-800">
                            <i class="fas fa-check-circle mr-1"></i> Negative
                        </span>
                    <% } else { %>
                        <span class="status-badge bg-gray-100 text-gray-800">
                            <i class="fas fa-question-circle mr-1"></i> <%= status %>
                        </span>
                    <% } %>
                </div>
            </div>
            <p class="text-gray-600 mt-1">View detailed information about this diagnosis</p>
        </div>

        <!-- Patient Information -->
        <div class="card">
            <h2 class="text-lg font-semibold mb-4">Patient Information</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <div class="label">Patient Name</div>
                    <div class="value flex items-center">
                        <i class="fas fa-user-circle text-blue-500 mr-2"></i>
                        <%= patientName %>
                    </div>
                </div>
                <div>
                    <div class="label">Diagnosis Date</div>
                    <div class="value flex items-center">
                        <i class="fas fa-calendar-alt text-blue-500 mr-2"></i>
                        <%= diagnosisDate %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Diagnosis Details -->
        <div class="card">
            <h2 class="text-lg font-semibold mb-4">Diagnosis Details</h2>
            
            <div class="mb-4">
                <div class="label">Status</div>
                <div class="value">
                    <% if ("Referrable".equals(status) || "Awaiting Diagnosis".equals(status)) { %>
                        <span class="status-badge bg-yellow-100 text-yellow-800">
                            <i class="fas fa-clock mr-1"></i> Awaiting Doctor
                        </span>
                    <% } else if ("In Progress".equals(status)) { %>
                        <span class="status-badge bg-blue-100 text-blue-800">
                            <i class="fas fa-spinner mr-1"></i> In Progress
                        </span>
                    <% } else if ("Positive".equals(result)) { %>
                        <span class="status-badge bg-red-100 text-red-800">
                            <i class="fas fa-exclamation-circle mr-1"></i> Positive
                        </span>
                    <% } else if ("Negative".equals(result)) { %>
                        <span class="status-badge bg-green-100 text-green-800">
                            <i class="fas fa-check-circle mr-1"></i> Negative
                        </span>
                    <% } else { %>
                        <span class="status-badge bg-gray-100 text-gray-800">
                            <i class="fas fa-question-circle mr-1"></i> <%= status %>
                        </span>
                    <% } %>
                </div>
            </div>
            
            <div class="mb-4">
                <div class="label">Nurse Assessment</div>
                <div class="value bg-gray-50 p-3 rounded border border-gray-200">
                    <%= nurseAssessment %>
                </div>
            </div>
            
            <div class="mb-4">
                <div class="label">Prescribed Medications</div>
                <div class="value bg-gray-50 p-3 rounded border border-gray-200">
                    <%= medications %>
                </div>
            </div>
            
            <div>
                <div class="label">Follow-up Date</div>
                <div class="value flex items-center">
                    <i class="fas fa-calendar-check text-blue-500 mr-2"></i>
                    <%= followUpDate %>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-between mt-6 no-print">
            <a href="nurse-referred-cases" class="button button-secondary">
                <i class="fas fa-arrow-left mr-2"></i>
                Back to Referred Cases
            </a>
            <button onclick="window.print()" class="button button-primary">
                <i class="fas fa-print mr-2"></i>
                Print Report
            </button>
        </div>
        
        <footer class="mt-8 text-center text-gray-500">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>
</body>
</html> 