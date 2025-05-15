<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient, com.mbc_hospital.model.Diagnosis" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Validate user session
    String usertype = (String) session.getAttribute("usertype");
    if (usertype == null || !"patient".equalsIgnoreCase(usertype)) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
    
    // Get patient information from session
    Patient patient = (Patient) session.getAttribute("patient");
    List<Diagnosis> patientDiagnoses = (List<Diagnosis>) request.getAttribute("patientDiagnoses");
    
    if (patient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            200: '#bfdbfe',
                            300: '#93c5fd',
                            400: '#60a5fa',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                        }
                    },
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-out forwards',
                        'slide-up': 'slideUp 0.5s ease-out forwards',
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' },
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' },
                        }
                    }
                },
            },
        }
    </script>
    <style>
        [x-cloak] { display: none !important; }
        .header {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            color: white;
            padding: 1rem 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table th {
            background-color: #f8fafc;
            padding: 0.85rem 1.25rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .table td {
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
            color: #1e293b;
            vertical-align: middle;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: #f1f5f9;
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
<body class="bg-gray-50 min-h-screen">
    <!-- Header -->
    <header class="header no-print">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-hospital text-3xl mr-3"></i>
                <div>
                    <h1 class="text-2xl font-bold">MBC Hospital</h1>
                    <p class="text-sm text-blue-100">Patient Portal</p>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <div class="flex items-center">
                    <div class="h-10 w-10 rounded-full bg-white/20 flex items-center justify-center mr-2">
                        <i class="fas fa-user text-xl"></i>
                    </div>
                    <span class="font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></span>
                </div>
                <a href="patient-logout" class="px-4 py-2 bg-red-600/20 text-white rounded hover:bg-red-700/30 transition">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto py-8 px-4">
        <!-- Patient Information Card -->
        <div class="card mb-8 animate-fade-in">
            <div class="flex justify-between items-start">
                <div>
                    <h2 class="text-xl font-bold text-gray-800 mb-2">
                        <i class="fas fa-user-circle text-blue-600 mr-2"></i>
                        Patient Information
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                        <div>
                            <p class="text-sm text-gray-500">Patient ID</p>
                            <p class="font-medium"><%= patient.getPatientID() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Full Name</p>
                            <p class="font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Phone Number</p>
                            <p class="font-medium"><%= patient.getTelephone() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Email Address</p>
                            <p class="font-medium"><%= patient.getEmail() != null ? patient.getEmail() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Address</p>
                            <p class="font-medium"><%= patient.getAddress() != null ? patient.getAddress() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Registration Date</p>
                            <p class="font-medium"><%= patient.getRegistrationDate() != null ? patient.getRegistrationDate() : "Unknown" %></p>
                        </div>
                    </div>
                </div>
                <button onclick="window.print()" class="btn no-print bg-blue-100 text-blue-700 px-4 py-2 rounded-lg hover:bg-blue-200 transition flex items-center">
                    <i class="fas fa-print mr-2"></i>
                    Print Information
                </button>
            </div>
        </div>

        <!-- Diagnoses Section -->
        <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center">
            <i class="fas fa-clipboard-check text-blue-600 mr-2"></i>
            My Diagnosis Results
        </h2>

        <div class="card animate-fade-in" style="animation-delay: 0.1s">
            <% if (patientDiagnoses != null && !patientDiagnoses.isEmpty()) { %>
                <div class="overflow-x-auto">
                    <table class="table min-w-full">
                        <thead>
                            <tr>
                                <th>Diagnosis Date</th>
                                <th>Status</th>
                                <th>Result</th>
                                <th>Medications</th>
                                <th>Follow-up Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Diagnosis diagnosis : patientDiagnoses) { %>
                            <tr>
                                <td><%= diagnosis.getDiagnosisDate() != null ? diagnosis.getDiagnosisDate().toString() : "N/A" %></td>
                                <td>
                                    <% if ("Positive".equals(diagnosis.getResult())) { %>
                                        <span class="status-badge bg-red-100 text-red-800">
                                            <i class="fas fa-exclamation-circle mr-1"></i> Positive
                                        </span>
                                    <% } else if ("Negative".equals(diagnosis.getResult())) { %>
                                        <span class="status-badge bg-green-100 text-green-800">
                                            <i class="fas fa-check-circle mr-1"></i> Negative
                                        </span>
                                    <% } else { %>
                                        <span class="status-badge bg-gray-100 text-gray-800">
                                            <i class="fas fa-question-circle mr-1"></i> <%= diagnosis.getStatus() %>
                                        </span>
                                    <% } %>
                                </td>
                                <td class="max-w-xs truncate"><%= diagnosis.getResult() != null ? diagnosis.getResult() : "No result provided" %></td>
                                <td><%= diagnosis.getMedicationsPrescribed() != null ? diagnosis.getMedicationsPrescribed() : "None" %></td>
                                <td><%= diagnosis.getFollowUpDate() != null ? diagnosis.getFollowUpDate().toString() : "Not scheduled" %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="flex flex-col items-center justify-center py-8 text-center">
                    <div class="inline-flex h-20 w-20 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                        <i class="fas fa-clipboard-check text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No diagnosis results found</h3>
                    <p class="text-gray-500">You don't have any diagnosis records in our system yet.</p>
                </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="mt-12 text-center text-gray-500 text-sm">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>
</body>
</html> 